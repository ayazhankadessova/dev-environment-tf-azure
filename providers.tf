# Strongly recommend using the required_providers block to set the
# Azure Provider source and version being use
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  tenant_id = var.ARM_TENANT_ID
  features {}
}