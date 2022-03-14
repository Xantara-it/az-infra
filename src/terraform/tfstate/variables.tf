variable "location" {
  description = "Location of the Azure Cloud"
  default     = "westeurope"
}

variable "rg_name" {
  description = "Name of the resource group"
  default     = "rg-infra"
}

variable "name_prefix" {
  description = "Prefix for the name of the storage account. The name must be unique globally."
  default     = "xantarait"
}

variable "name_container" {
  description = "Name of the storage container"
  default     = "tfstate"
}

variable "tags" {
  type = map(any)
  default = {
    "environment" = "infra",
    "createdby"   = "terraform"
  }
}
