# Create a resource group
resource "azurerm_resource_group" "aya-rg" {
  name     = "aya-rg"
  location = "East US"

  tags = local.common_tags
}

module "aya-vm" {

  source = "./modules/azuretm/virtual_network"

  my_location            = local.location # vm is dependant on rg
  my_resource_group_name = local.name

  my_tags = local.common_tags

}

module "subnet-1" {
  source              = "./modules/azuretm/subnet"
  subnet-name         = "aya-subnet-1"
  vn-name             = module.aya-vm.name
  resource_group_name = local.name
  #   address_prefixes     = ["10.123.1.0/24"]
}

module "aya-network-security-group" {
  source                         = "./modules/azuretm/network_security_group"
  network-sg-name                = "aya-network-security-group"
  network-sg-location            = local.location
  network-sg-resource_group_name = local.name

  my_tags = local.common_tags
}

module "aya-dev-rule" {
  source = "./modules/azuretm/network_security_rule"

  network-sr-name = "aya-dev-rule"
  #   priority                    = 100       # lower number, higher priority
  #   direction                   = "Inbound" # allow access to our instances, not from
  #   access                      = "Allow"
  #   protocol                    = "*"
  #   source_port_range           = "*"
  #   destination_port_range      = "*"
  my-source_address_prefix = var.source_address_prefix
  #   destination_address_prefix  = "*"
  rg-name         = local.name
  network-sg-name = module.aya-network-security-group.name
}

resource "azurerm_subnet_network_security_group_association" "aya-sga" {
  subnet_id                 = module.subnet-1.id
  network_security_group_id = module.aya-network-security-group.id
}

module "aya-ip" {

  source = "./modules/azuretm/public_ip"


  name                = "aya-pip"
  location            = local.location
  resource-group-name = local.name
}

module "aya-nic" {

  source = "./modules/azuretm/network_interface"
  name   = "aya-nic"
    location            = local.location
    resource_group_name = local.name

#   ip_configuration {
    ip-name = "internal"
    subnet_id                     = module.subnet-1.id
    # private_ip_address_allocation = "Dynamic"
    # private_ip_address            = "10.0.2.5"
    public_ip_address_id = module.aya-ip.id
#   }
}

resource "azurerm_linux_virtual_machine" "aya-vm" {
  name                = "aya-machine"
  resource_group_name = local.name
  location            = local.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    module.aya-nic.id,
  ]

  custom_data = filebase64("${path.module}/scripts/customdata.tpl")

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


  // script file, vars
  provisioner "local-exec" {
    command = templatefile("./scripts/${var.host_os}-ssh-script.tpl", {
      hostname     = self.public_ip_address,
      user         = "adminuser",
      identityfile = "~/.ssh/id_rsa"
    })
    interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
  }
  # interpreter = [ "Powershell", "-Command" ] // for windows; wheter we are using powershell/bash 

  tags = local.common_tags
}

# data "azurerm_public_ip" "aya-ip-data" {
#   name                = module.aya-ip.name
#   resource_group_name = local.name
# }








# moved {
#   from = azurerm_virtual_network.aya_vm
#   to   = module.virtual_network.azurerm_virtual_network.this[0]
# }

# moved {
#   from = aya_vm.name
#   to   = module.virtual_network.azurerm_virtual_network.aya-vm.name[0]
# }

# moved {
#   from = aya_vm.location
#   to   = module.virtual_network.azurerm_virtual_networkaya-vm.aya-vm.location[0]
# }

# moved {
#   from = aya_vm.resource_group_name
#   to   = module.virtual_network.azurerm_virtual_network.aya-vm.resource_group_name[0]
# }

# moved {
#   from = aya_vm.tags
#   to   = module.virtual_network.azurerm_virtual_network.aya-vm.tags[0]
# }

# moved {
#   from = aya_vm.address_space
#   to   = module.virtual_network.azurerm_virtual_network.aya-vm.address_space[0]
# }