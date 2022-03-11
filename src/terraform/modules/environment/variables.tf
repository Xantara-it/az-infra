variable "location" {
  description = "Name of the location of the Azure Cloud"
  default     = "West Europe"
}

variable "environment" {
  description = "Name of the environent"
}

variable "cidr_blocks_vnet" {
  description = "IP addresss range VNet"
  default     = "10.0.240.0/20"
}

variable "cidr_blocks_snet" {
  description = "IP addresss range SubNet"
  default     = "10.0.240.0/24"
}

variable "linux_vm_image_publisher" {
  type        = string
  description = "Virtual machine source image publisher"
  default     = "RedHat"
}

variable "linux_vm_image_offer" {
  type        = string
  description = "Virtual machine source image offer"
  default     = "RHEL"
}

# az vm image list -l westeurope -p RedHat -f RHEL --all --out table
variable "linux_vm_image_sku" {
  type        = string
  description = "Virtual machine source image sku"
  default     = "8-lvm-gen2"
}

variable "linux_vm_image_version" {
  type        = string
  description = "Virtual machine source image version"
  default     = "8.5.2021121504"
}

# az vm list-sizes -l westeurope --out table
variable "linux_vm_size" {
  type        = string
  description = "Size of the VM"
  default     = "Standard_B1ms"
}

variable "linux_vm_name" {
  type        = string
  description = "Name of the Linux VM"
}


variable "linux_admin_username" {
  type        = string
  description = "Username of the admin"
  default     = "xantara"
}
