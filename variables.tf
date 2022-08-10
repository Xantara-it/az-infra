variable "location" {
  description = "Location of the Azure Cloud"
  default     = "westeurope"
}

variable "rg_name" {
  description = "Name of the resource group"
  default     = "az-infra-rg"
}

variable "name_prefix" {
  description = "Name prefix"
  default     = "az-infra"
}

variable "address_space_prefix" {
  description = "VNET address prefix"
  default     = "10.128"
}

variable "tags" {
  type = map(any)
  default = {
    "environment" = "infra",
    "createdby"   = "terraform"
  }
}
