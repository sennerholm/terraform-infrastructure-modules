provider "azurerm" {
  version = "~>1.5"
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}
