variable "location" {
  description = "Name of the location of the Azure Cloud"
  default = "West Europe"
}

variable "environment" {
    description = "Name of the environent"
}

variable "cidr_blocks_vnet" {
    description = "IP addresss range VNet"
    default = "10.0.240.0/20"
}

variable "cidr_blocks_snet" {
    description = "IP addresss range SubNet"
    default = "10.0.240.0/24"
}
