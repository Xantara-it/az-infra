terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.46.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-infra"
    storage_account_name = "xantaraitggf4ga07"
    container_name       = "tfstate"
    key                  = "infra.tfstate"
  }
}

provider "azurerm" {
  features {}
}

#
# IP Range:      10.0.240.0/20
# Subnet mask:   255.255.240.0
# Uasable range: 10.0.240.1 - 10.0.255.254
#
resource "azurerm_virtual_network" "infra" {
  location            = var.location
  resource_group_name = var.rg_name
  name                = var.vn_name
  address_space       = [var.vn_address_space]
  tags                = var.tags
}

resource "azurerm_subnet" "infra" {
  for_each = var.subnets

  resource_group_name  = var.rg_name
  virtual_network_name = var.vn_name
  name                 = "sn-${each.key}"
  address_prefixes     = [each.value]
}

