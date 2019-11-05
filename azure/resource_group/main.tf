resource "azurerm_resource_group" "rg" {
  name     = "${var.resourcegroup_name}-${var.location}"
  location = "${var.location}"
  tags = {
    subscription = "${var.subscription_name}"

  }
}
