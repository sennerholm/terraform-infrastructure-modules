

resource "random_integer" "gen_suffix" {
  min = 1
  max = 50000
}

resource "azurerm_container_registry" "registry" {
  name                = "${var.resource_name}${random_integer.gen_suffix.result}${var.location}${var.subscription_name}"
  resource_group_name = "${var.full_resourcegroup_name}"
  location            = "${var.location}"
  sku                 = "Basic"
  admin_enabled       = false
  #  georeplication_locations = ["East US", "West Europe"]
}
