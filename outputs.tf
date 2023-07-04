output "aya_vm_id" {
  value = azurerm_virtual_network.aya-vm.id
}

output "subnet_id" {
  value = azurerm_subnet.subnet-1.id
}

output "subnet_prefixes" {
  value = azurerm_subnet.subnet-1.address_prefixes
}