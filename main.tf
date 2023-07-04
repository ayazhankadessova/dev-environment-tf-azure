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
  location = "Central US"

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