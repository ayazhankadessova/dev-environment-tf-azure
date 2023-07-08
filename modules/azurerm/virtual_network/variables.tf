variable "my_location" {
  type = string
}

variable "my_resource_group_name" {
  type = string
}

variable "my_tags" {
  type    = map(string)
  default = {
    environment = "dev"
    owner       = "Ayazhan Kadessova"
  }
}