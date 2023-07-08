resource "azurerm_network_security_rule" "aya-dev-rule" {
  name                        = var.network-sr-name
  priority                    = 100       # lower number, higher priority
  direction                   = "Inbound" # allow access to our instances, not from
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = var.my-source_address_prefix
  destination_address_prefix  = "*"
  resource_group_name         = var.rg-name
  network_security_group_name = var.network-sg-name
}