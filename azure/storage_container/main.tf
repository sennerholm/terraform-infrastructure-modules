

resource "random_integer" "account_suffix" {
  min = 1
  max = 50000
}

resource "azurerm_storage_account" "account" {
  name                     = "account-${var.resource_name}"
  resource_group_name      = "${var.full_resourcegroup_name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    application    = "terragrunt"
    infrastructure = "true"
  }
}

resource "azurerm_storage_container" "container" {
  name                  = "${var.full_resourcegroup_name}"
  storage_account_name  = "${azurerm_storage_account.account.name}"
  container_access_type = "private"
}


# TODO
# Add fw rule, and to right subnet
