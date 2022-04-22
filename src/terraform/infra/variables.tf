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

variable "sn_infra_address_space" {
  description = "IP Range of the Infra subnet"
  default     = "10.0.241.0/24"
}

variable "sn_development_address_space" {
  description = "IP Range of the Development subnet"
  default     = "10.0.242.0/24"
}

variable "sn_test_address_space" {
  description = "IP Range of the Test subnet"
  default     = "10.0.243.0/24"
}

variable "sn_staging_address_space" {
  description = "IP Range of the Staging subnet"
  default     = "10.0.244.0/24"
}

variable "sn_production_address_space" {
  description = "IP Range of the Production subnet"
  default     = "10.0.245.0/24"
}

variable "sn_vpnclient_address_space" {
  description = "IP Range of the Production subnet"
  default     = "10.0.239.0/24"
}

variable "tags" {
  type = map(any)
  default = {
    "environment" = "infra",
    "createdby"   = "terraform"
  }
}
