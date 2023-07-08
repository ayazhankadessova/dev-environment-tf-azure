resource "azurerm_virtual_network" "aya-vm" {
  name                = "aya-network"
  location            = var.my_location # vm is dependant on rg
  resource_group_name = var.my_resource_group_name
  address_space       = ["10.123.0.0/16"]
  tags = var.my_tags
}