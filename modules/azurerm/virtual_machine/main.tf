# resource "azurerm_linux_virtual_machine" "aya-vm" {
#   name                = "aya-machine"
#   resource_group_name = local.name
#   location            = local.location
#   size                = "Standard_F2"
#   admin_username      = "adminuser"
#   network_interface_ids = [
#     module.aya-nic.id,
#   ]

#   custom_data = filebase64("${path.module}/scripts/customdata.tpl")

#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = file("~/.ssh/id_rsa.pub")
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-focal"
#     sku       = "20_04-lts"
#     version   = "latest"
#   }


#   // script file, vars
#   provisioner "local-exec" {
#     command = templatefile("./scripts/${var.host_os}-ssh-script.tpl", {
#       hostname     = self.public_ip_address,
#       user         = "adminuser",
#       identityfile = "~/.ssh/id_rsa"
#     })
#     interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
#   }
#   # interpreter = [ "Powershell", "-Command" ] // for windows; wheter we are using powershell/bash 

#   tags = local.common_tags
# }