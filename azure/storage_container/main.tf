

resource "random_integer" "account_suffix" {
  min = 1
  max = 50000
}

resource "azurerm_storage_account" "account" {
  name                     = "staccount${var.resource_name}${random_integer.account_suffix.result}"
  resource_group_name      = "${var.full_resourcegroup_name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"

  tags = {
    application    = "terragrunt"
    infrastructure = "true"
  }
}

#resource "azurerm_storage_container" "container" {
#  name                  = "stcont${var.resource_name}${random_integer.account_suffix.result}"
#  storage_account_name  = "${azurerm_storage_account.account.name}"
#  container_access_type = "private"
#}


# TODO
# Add fw rule, and to right subnet
