# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being use

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  tenant_id = var.ARM_TENANT_ID
  features {}

}

# Create a resource group
resource "azurerm_resource_group" "aya-rg" {
  name     = "aya-rg"
  location = "East US"

  tags = local.common_tags
}

resource "azurerm_virtual_network" "aya-vm" {
  name                = "aya-network"
  location            = azurerm_resource_group.aya-rg.location # vm is dependant on rg
  resource_group_name = azurerm_resource_group.aya-rg.name
  address_space       = ["10.123.0.0/16"]
  #   dns_servers         = ["10.0.0.4", "10.0.0.5"]

  #   subnet {
  #     name           = "subnet1"
  #     address_prefix = "10.0.1.0/24"
  #   }

  #   subnet {
  #     name           = "subnet2"
  #     address_prefix = "10.0.2.0/24"
  #     security_group = azurerm_network_security_group.aya-rg.id 
  #   }

  tags = local.common_tags
}

resource "azurerm_subnet" "subnet-1" {
  name                 = "aya-subnet-1"
  virtual_network_name = azurerm_virtual_network.aya-vm.name
  resource_group_name  = azurerm_resource_group.aya-rg.name
  address_prefixes     = ["10.123.1.0/24"]
}

resource "azurerm_network_security_group" "aya-network-security-group" {
  name                = "aya-network-security-group"
  location            = azurerm_resource_group.aya-rg.location
  resource_group_name = azurerm_resource_group.aya-rg.name

  #   security_rule {
  #     name                       = "test123"
  #     priority                   = 100
  #     direction                  = "Inbound"
  #     access                     = "Allow"
  #     protocol                   = "Tcp"
  #     source_port_range          = "*"
  #     destination_port_range     = "*"
  #     source_address_prefix      = "*"
  #     destination_address_prefix = "*"
  #   }

  tags = local.common_tags
}

resource "azurerm_network_security_rule" "aya-dev-rule" {
  name                        = "aya-dev-rule"
  priority                    = 100 # lower number, higher priority
  direction                   = "Inbound" # allow access to our instances, not from
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = var.source_address_prefix 
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.aya-rg.name
  network_security_group_name = azurerm_network_security_group.aya-network-security-group.name
}

resource "azurerm_subnet_network_security_group_association" "aya-sga" {
  subnet_id                 = azurerm_subnet.subnet-1.id
  network_security_group_id = azurerm_network_security_group.aya-network-security-group.id
}

resource "azurerm_public_ip" "aya-ip" {
  name                    = "aya-pip"
  location                = azurerm_resource_group.aya-rg.location
  resource_group_name     = azurerm_resource_group.aya-rg.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = local.common_tags
}

resource "azurerm_network_interface" "aya-nic" {
  name                = "aya-nic"
  location            = azurerm_resource_group.aya-rg.location
  resource_group_name = azurerm_resource_group.aya-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet-1.id
    private_ip_address_allocation = "Dynamic"
    # private_ip_address            = "10.0.2.5"
    public_ip_address_id          = azurerm_public_ip.aya-ip.id
  }

   tags = local.common_tags
}

resource "azurerm_linux_virtual_machine" "aya-vm" {
  name                = "aya-machine"
  resource_group_name = azurerm_resource_group.aya-rg.name
  location            = azurerm_resource_group.aya-rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.aya-nic.id,
  ]

 custom_data = filebase64("${path.module}/customdata.tpl")

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  provisioner "local-exec" {
    // script file, vars
    command = templatefile("linux-ssh-script.tpl", {
        hostname = self.public_ip_address, 
        user = "adminuser",
        identityfile = "~/.ssh/id_rsa" // private_key
    })
    # interpreter = [ "Powershell", "-Command" ] // for windows; wheter we are using powershell/bash 

    interpreter = [ "bash", "-c" ] // for linux

  }

  tags = local.common_tags
}