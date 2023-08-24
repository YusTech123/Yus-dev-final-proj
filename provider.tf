terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.68.0"
    }
  }
}


provider "azurerm" {
  subscription_id = "dcca56dc-7bdc-4c6d-abd7-8bef926c1f09"
  client_id       = "f596548a-2fa4-42a7-919f-6a73e055667d"
  client_secret   = "Dow8Q~Zhl_UaP2ZlmT4kKw9fQ4RA.poL_nbc5aS5"
  tenant_id       = "46cb2516-307b-4336-90a5-29441a4e8c22"
  features {

  }
}