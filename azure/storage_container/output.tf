
output "storage_account_name" {
  value       = "${azurerm_storage_account.account.name}"
  description = "The AzureStorageAccountName"
}

output "storage_account_key" {
  sensitive   = true
  value       = "${azurerm_storage_account.account.primary_access_key}"
  description = "The AzureStorageAccountKey (primary)"
}
output "primary_connection_string" {
  value     = "${azurerm_storage_account.account.primary_connection_string}"
  sensitive = true

}
#output "storage_container" {
#  value       = "${azurerm_storage_container.container.name}"
#  description = "The name of the container to use"
#}

