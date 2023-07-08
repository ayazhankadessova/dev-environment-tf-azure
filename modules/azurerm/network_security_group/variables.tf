variable "my_tags" {
  type    = map(string)
  default = {
    environment = "dev"
    owner       = "Ayazhan Kadessova"
  }
}

variable "network-sg-name" {
  type = string
}

variable "network-sg-location" {
  type = string
}

variable "network-sg-resource_group_name" {
  type = string
}