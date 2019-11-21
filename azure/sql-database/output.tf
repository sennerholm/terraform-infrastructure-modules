output "servername" {
  value = "${azurerm_sql_server.server.name}"
}
output "database_id" {
  value = "${azurerm_sql_database.db.id}"
}
