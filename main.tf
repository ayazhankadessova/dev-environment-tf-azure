# Create a resource group
resource "azurerm_resource_group" "aya-rg" {
  name     = "aya-rg"
  location = "East US"

  tags = local.common_tags
}

module "aya-vm" {

  source = "./modules/azurerm/virtual_network"

  my_location            = local.location # vm is dependant on rg
  my_resource_group_name = local.name

  my_tags = local.common_tags

}

module "subnet-1" {
  source              = "./modules/azurerm/subnet"
  subnet-name         = "aya-subnet-1"
  vn-name             = module.aya-vm.name
  resource_group_name = local.name
}

module "aya-network-security-group" {
  source                         = "./modules/azurerm/network_security_group"
  network-sg-name                = "aya-network-security-group"
  network-sg-location            = local.location
  network-sg-resource_group_name = local.name

  my_tags = local.common_tags
}

module "aya-dev-rule" {
  source = "./modules/azurerm/network_security_rule"

  network-sr-name = "aya-dev-rule"

  my-source_address_prefix = var.source_address_prefix

  rg-name         = local.name
  network-sg-name = module.aya-network-security-group.name
}

resource "azurerm_subnet_network_security_group_association" "aya-sga" {
  subnet_id                 = module.subnet-1.id
  network_security_group_id = module.aya-network-security-group.id
}

module "aya-ip" {

  source = "./modules/azurerm/public_ip"


  name                = "aya-pip"
  location            = local.location
  resource-group-name = local.name
}

module "aya-nic" {

  source              = "./modules/azurerm/network_interface"
  name                = "aya-nic"
  location            = local.location
  resource_group_name = local.name

  ip-name   = "internal"
  subnet_id = module.subnet-1.id

  public_ip_address_id = module.aya-ip.id
  #   }
}

resource "azurerm_linux_virtual_machine" "aya-vm" {
  name                = "aya-machine"
  resource_group_name = local.name
  location            = local.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    module.aya-nic.id,
  ]

  custom_data = filebase64("${path.module}/scripts/customdata.tpl")

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }


  // script file, vars
  provisioner "local-exec" {
    command = templatefile("./scripts/${var.host_os}-ssh-script.tpl", {
      hostname     = self.public_ip_address,
      user         = "adminuser",
      identityfile = "~/.ssh/id_rsa"
    })
    interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
  }

  tags = local.common_tags
}

# data "azurerm_public_ip" "aya-ip-data" {
#   name                = module.aya-ip.name
#   resource_group_name = local.name
# }