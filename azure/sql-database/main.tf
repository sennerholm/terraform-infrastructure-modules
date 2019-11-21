resource "random_string" "password" {
  length      = 32
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  min_special = 1
}

resource "random_string" "username" {
  length  = 16
  special = false
}
resource "azurerm_sql_server" "server" {
  name                         = "server-${var.resource_name}"
  resource_group_name          = "${var.full_resourcegroup_name}"
  location                     = "${var.location}"
  version                      = "12.0"
  administrator_login          = "${random_string.username.result}"
  administrator_login_password = "${random_string.password.result}"

  tags = {
    subscription = "${var.subscription_name}"
  }
}
resource "azurerm_sql_database" "db" {
  name                = "${var.resource_name}"
  resource_group_name = "${var.full_resourcegroup_name}"
  location            = "${var.location}"
  server_name         = "${azurerm_sql_server.server.name}"

  tags = {
    environment = "production"
  }
}
# TODO
# Add fw rule, and to right subnet, and thread detection
