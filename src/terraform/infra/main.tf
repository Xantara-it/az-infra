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
}