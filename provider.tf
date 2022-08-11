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

#
# ToDo: Ids are from my private Azure account
#
provider "azurerm" {
  features {}
  subscription_id = "23c28aac-2178-4d00-880c-94bd7e8944c3"
  tenant_id       = "1dac3ff2-bab9-401d-8ac3-6fa4eefa0422"
}
