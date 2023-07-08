locals {

  common_tags = {
    environment = "dev"
    owner       = "Ayazhan Kadessova"
  }
}

locals {
  location = azurerm_resource_group.aya-rg.location
  name     = azurerm_resource_group.aya-rg.name
}