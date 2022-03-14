variable "location" {
  description = "Location of the Azure Cloud"
  default     = "westeurope"
}

variable "rg_name" {
  description = "Name of the resource group"
  default     = "rg-infra"
}

variable "vn_name" {
  description = "Name of the Virtual Network"
  default     = "vn-xantara-it"
}

variable "vn_address_space" {
  description = "IP Range of the Virtual Network"
  default     = "10.0.240.0/20"
}

variable "subnets" {
  type = map(string)
  default = {
    # "AzureBastionSubnet" = "10.0.240.0/24",
    "infra"       = "10.0.241.0/24",
    "development" = "10.0.242.0/24",
    "test"        = "10.0.243.0/24",
    "staging"     = "10.0.244.0/24",
    "production"  = "10.0.245.0/24"
  }
}

variable "tags" {
  type = map(any)
  default = {
    "environment" = "infra",
    "createdby"   = "terraform"
  }
}
