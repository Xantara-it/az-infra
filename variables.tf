variable "location" {
  description = "Location of the Azure Cloud"
  default     = "westeurope"
}

variable "name_prefix" {
  description = "Name prefix"
  default     = "az-infra"
}

variable "address_space" {
  description = "VNET address prefix"
  default     = "10.128.0.0/16"
}

variable "tags" {
  type = map(any)
  default = {
    "environment" = "infra",
    "createdby"   = "terraform"
  }
}
