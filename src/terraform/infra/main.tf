terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.46.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform"
    storage_account_name = "xantaraitggf4ga07"
    container_name       = "tfstate"
    key                  = "infra.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "infra" {
  name     = var.rg_name
  location = var.location

  tags = {
    environment = "infra"
  }
}

resource "azurerm_network_security_group" "infra" {
  name                = "nsg-infra"
  location            = azurerm_resource_group.infra.location
  resource_group_name = azurerm_resource_group.infra.name

  tags = {
    environment = "infra"
  }
}

resource "azurerm_network_security_group" "development" {
  name                = "nsg-development"
  location            = azurerm_resource_group.infra.location
  resource_group_name = azurerm_resource_group.infra.name

  tags = {
    environment = "infra"
  }
}

resource "azurerm_network_security_group" "testing" {
  name                = "nsg-testing"
  location            = azurerm_resource_group.infra.location
  resource_group_name = azurerm_resource_group.infra.name

  tags = {
    environment = "infra"
  }
}

resource "azurerm_network_security_group" "staging" {
  name                = "nsg-staging"
  location            = azurerm_resource_group.infra.location
  resource_group_name = azurerm_resource_group.infra.name

  tags = {
    environment = "infra"
  }
}

resource "azurerm_network_security_group" "production" {
  name                = "nsg-production"
  location            = azurerm_resource_group.infra.location
  resource_group_name = azurerm_resource_group.infra.name

  tags = {
    environment = "infra"
  }
}


#
# IP Range:      10.0.240.0/20
# Subnet mask:   255.255.240.0
# Uasable range: 10.0.240.1 - 10.0.255.254
#
resource "azurerm_virtual_network" "infra" {
  name                = "vn-infra"
  location            = azurerm_resource_group.infra.location
  resource_group_name = azurerm_resource_group.infra.name
  address_space       = ["10.0.240.0/20"]
  # dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "sn-infra"
    address_prefix = "10.0.240.0/24"
    security_group = azurerm_network_security_group.infra.id
  }

  subnet {
    name           = "sn-development"
    address_prefix = "10.0.241.0/24"
    security_group = azurerm_network_security_group.development.id
  }

  subnet {
    name           = "sn-testing"
    address_prefix = "10.0.242.0/24"
    security_group = azurerm_network_security_group.testing.id
  }

  subnet {
    name           = "sn-staging"
    address_prefix = "10.0.243.0/24"
    security_group = azurerm_network_security_group.staging.id
  }

  subnet {
    name           = "sn-production"
    address_prefix = "10.0.244.0/24"
    security_group = azurerm_network_security_group.production.id
  }

  tags = {
    environment = "infra"
  }
}
