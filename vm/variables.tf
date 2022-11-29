variable "name" {
  type = string
}

variable "resource_group" {
  type = object({
    id       = string
    name     = string
    location = string
  })
}

variable "security_groups" {
  type = list(object({
    id   = string
    name = string
  }))
}

variable "subnet" {
  type = object({
    id = string
  })
}

variable "size" {
  type    = string
  default = "Standard_B1ls"
}

variable "username" {
  type    = string
  default = "adminuser"
}