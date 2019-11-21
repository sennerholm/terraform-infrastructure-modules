
output "storage_account_name" {
  value       = "${azurerm_storage_account.account.name}"
  description = "The AzureStorageAccountName"
}

output "storage_account_key" {
  value       = "${azurerm_storage_account.account.primary_access_key}"
  description = "The AzureStorageAccountKey (primary)"
}

output "storage_container" {
  value       = "${azurerm_storage_container.container.name}"
  description = "The name of the container to use"
}

