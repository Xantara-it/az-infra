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
    key                  = "staging.tfstate"
  }
}

provider "azurerm" {
  features {}

  environment = "public"
}

module "development" {
  source = "../modules/environment"

  environment      = "staging"
  cidr_blocks_snet = "10.0.243.0/24"
}