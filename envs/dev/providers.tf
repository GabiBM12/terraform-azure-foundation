terraform {
    required_version = ">= 1.6.0"
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = ">= 3.1.0"
        }
    }
}
provider "azurerm" {
    subscription_id = "b344b3e2-c925-41d5-b337-d60cd06cef64"
    features {}
  
}