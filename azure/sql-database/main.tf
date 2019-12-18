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
resource "random_integer" "gen_suffix" {
  min = 1
  max = 50000
}

resource "azurerm_sql_server" "server" {
  name                         = "server-${var.resource_name}${random_integer.gen_suffix.result}${var.location}${var.subscription_name}"
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
  edition             = "basic"

  tags = {
    environment = "production"
  }
}
resource "azurerm_sql_virtual_network_rule" "src_access" {
  for_each            = toset(var.src_subnets)
  name                = "Clients${sha256(each.value)}"
  resource_group_name = "${var.full_resourcegroup_name}"
  server_name         = "${azurerm_sql_server.server.name}"
  subnet_id           = each.value
}
# TODO
# Add threat detection? 
