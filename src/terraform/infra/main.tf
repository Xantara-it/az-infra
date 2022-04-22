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
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.infra.name
  name                 = "GatewaySubnet"
  address_prefixes     = [var.sn_infra_address_space]
}

resource "azurerm_subnet" "development" {
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.infra.name
  name                 = "sn-development"
  address_prefixes     = [var.sn_development_address_space]
}

resource "azurerm_subnet" "test" {
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.infra.name
  name                 = "sn-test"
  address_prefixes     = [var.sn_test_address_space]
}

resource "azurerm_subnet" "staging" {
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.infra.name
  name                 = "sn-staging"
  address_prefixes     = [var.sn_staging_address_space]
}

resource "azurerm_subnet" "production" {
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.infra.name
  name                 = "sn-production"
  address_prefixes     = [var.sn_production_address_space]
}
