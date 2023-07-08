resource "azurerm_network_security_group" "aya-network-security-group" {
  name                = var.network-sg-name
  location            = var.network-sg-location
  resource_group_name = var.network-sg-resource_group_name

  tags = var.my_tags
}