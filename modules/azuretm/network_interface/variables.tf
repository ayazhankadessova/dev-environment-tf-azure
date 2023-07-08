variable "name" {
  type = string
}

variable "ip-name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "public_ip_address_id" {
  type = string
}

variable "my_tags" {
  type    = map(string)
  default = {
    environment = "dev"
    owner       = "Ayazhan Kadessova"
  }
}
