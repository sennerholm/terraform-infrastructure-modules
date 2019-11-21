
resource "azurerm_container_registry" "acr" {
  name                = "${var.resource_name}"
  resource_group_name = "${var.full_resourcegroup_name}"
  location            = "${var.location}"
  sku                 = "Basic"
  admin_enabled       = false
  #  georeplication_locations = ["East US", "West Europe"]
}
