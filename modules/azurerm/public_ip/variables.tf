variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource-group-name" {
  type = string
}

variable "my_tags" {
  type    = map(string)
  default = {
    environment = "dev"
    owner       = "Ayazhan Kadessova"
  }
}