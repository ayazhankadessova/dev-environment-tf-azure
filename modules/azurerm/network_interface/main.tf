resource "azurerm_network_interface" "aya-nic" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name 

  ip_configuration {
    name                          = var.ip-name 
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    private_ip_address            = "10.0.2.5"
    public_ip_address_id = var.public_ip_address_id
  }

  tags = var.my_tags
}