resource "azurerm_subnet" "subnet-1" {
  name                 = var.subnet-name
  virtual_network_name = var.vn-name
  resource_group_name  = var.resource_group_name
  address_prefixes     = ["10.123.1.0/24"]

}