terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.46.0"
    }
  }
}

provider "azurerm" {
  features {
  }
}

resource "random_string" "resource_code" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tfstate" {
  location = var.location
  name     = var.rg_name
  tags     = var.tags
}

resource "azurerm_storage_account" "tfstate" {
  location                 = var.location
  resource_group_name      = var.rg_name
  name                     = "${var.name_prefix}${random_string.resource_code.result}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true
  tags                     = var.tags
}

resource "azurerm_storage_container" "tfstate" {
  name                  = var.name_container
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}
