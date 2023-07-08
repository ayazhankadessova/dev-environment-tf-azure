resource "azurerm_public_ip" "aya-ip" {
  name                    = var.name
  location                = var.location
  resource_group_name     = var.resource-group-name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = var.my_tags
}