terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.17.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "xantara-it-rg"
    storage_account_name = "xantaraitiw1oy9f6"
    container_name       = "tfstate"
    key                  = "az-infra.tfstate"
  }
}

provider "azurerm" {
  features {
  }
}
