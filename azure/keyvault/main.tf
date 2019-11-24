

resource "random_integer" "suffix" {
  min = 1
  max = 50000
}
resource "azuread_application" "application" {
  name = "${var.resource_name}${var.resourcegroup_name}${random_integer.suffix.result}${var.location}${var.subscription_name}"
}

resource "azuread_service_principal" "sp" {
  application_id               = "${azuread_application.application.application_id}"
  app_role_assignment_required = false

}

resource "random_string" "password" {
  length      = 64
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  min_special = 1
}
resource "azuread_service_principal_password" "pw" {
  service_principal_id = "${azuread_service_principal.sp.id}"
  value                = "${random_string.password.result}"
  end_date_relative    = "8766h" #Close to 1year
}

resource "azurerm_key_vault" "vault" {
  name                = "${var.resource_name}-${var.resourcegroup_name}-${random_integer.suffix.result}"
  resource_group_name = "${var.full_resourcegroup_name}"
  location            = "${var.location}"

  enabled_for_disk_encryption = true
  tenant_id                   = "${var.tenant_id}"

  sku_name = "standard"

  # Need to add network ACLS
  #network_acls {
  #  default_action = "Deny"
  #  bypass         = "AzureServices"
  #}
}

data "azuread_service_principal" "terra" {
  # Get terra serviceprincipal
  application_id = "${var.client_id}"
}

resource "azurerm_key_vault_access_policy" "terra" {
  # Give terraform all permissions
  key_vault_id = "${azurerm_key_vault.vault.id}"

  tenant_id = "${var.tenant_id}"
  object_id = "${data.azuread_service_principal.terra.id}"

  key_permissions = [
    "backup",
    "create",
    "decrypt",
    "delete",
    "encrypt",
    "get",
    "import",
    "list",
    "purge",
    "recover",
    "restore",
    "sign",
    "unwrapKey",
    "update",
    "verify",
    "wrapKey",
  ]

  secret_permissions = [
    "backup",
    "delete",
    "get",
    "list",
    "purge",
    "recover",
    "restore",
    "set",
  ]
}

resource "azurerm_key_vault_access_policy" "app" {
  # Give terraform all permissions
  key_vault_id = "${azurerm_key_vault.vault.id}"

  tenant_id = "${var.tenant_id}"
  object_id = "${azuread_service_principal.sp.id}"

  key_permissions = [
    "get",
    "list",
  ]

  secret_permissions = [
    "list",
  ]
}


# TODO
# Add fw rule, and to right subnet
