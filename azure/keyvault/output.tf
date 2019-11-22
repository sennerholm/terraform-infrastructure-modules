output "client_id" {
  value = "${azuread_service_principal.sp.id}"
}

output "client_key" {
  value     = "${random_string.password.result}"
  sensitive = true
}

output "uri" {
  value = "${azurerm_key_vault.vault.vault_uri}"
}


