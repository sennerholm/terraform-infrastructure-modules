output "servername" {
  value = "${azurerm_sql_server.server.name}"
}
output "servername_fqdn" {
  value = "${azurerm_sql_server.server.fully_qualified_domain_name}"
}
output "database_id" {
  value = "${azurerm_sql_database.db.id}"
}
output "database_name" {
  value = "${azurerm_sql_database.db.name}"
}

output "database_admin_login" {
  value = "${azurerm_sql_server.server.administrator_login}"
}

output "database_admin_login_password" {
  sensitive = true
  value     = "${azurerm_sql_server.server.administrator_login_password}"
}
