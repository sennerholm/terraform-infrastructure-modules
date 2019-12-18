

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "${var.cluster_name}"
  location            = "${var.location}"
  resource_group_name = "${var.k8s_resourcegroup_name}"
  dns_prefix          = "${var.dns_prefix}"

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = "${file("${var.ssh_public_key}")}"
    }
  }

  agent_pool_profile {
    name                = "autoscale"
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = "true"
    min_count           = "${var.agent_mincount}"
    max_count           = "${var.agent_maxcount}"
    count               = "${var.agent_count}"
    vm_size             = "${var.agent_size}"
    os_type             = "Linux"

    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

  tags = {
    subscription = "${var.subscription_name}"

  }
}

/* data "azurerm_kubernetes_cluster" "k8s" {
  name                = "${azurerm_kubernetes_cluster.k8s.name}"
  resource_group_name = "${var.k8s_resourcegroup_name}"
}
data "azurerm_resources" "vnet" {
  resource_group_name = "${data.azurerm_kubernetes_cluster.k8s.node_resource_group}"
  type                = "Microsoft.Network/virtualNetworks"
}
#output "data_vnet" {
#  value = "${data.azurerm_resources.vnet.resources}"
#}

data "azurerm_virtual_network" "vnet" {
  depends_on          = [ azurerm_kubernetes_cluster.k8s ]
  for_each            = toset(data.azurerm_resources.vnet.resources.*.name)
  name                = each.value
  resource_group_name = "${data.azurerm_kubernetes_cluster.k8s.node_resource_group}"
}

#subnets - The list of name of the subnets that are attached to this virtual network.

data "azurerm_subnet" "subnet" {
  for_each             = toset(flatten(values(data.azurerm_virtual_network.vnet)[*].subnets.*))
  name                 = each.value
  virtual_network_name = "${data.azurerm_resources.vnet.resources.0.name}" # This will not work when we have multiple
  resource_group_name  = "${data.azurerm_kubernetes_cluster.k8s.node_resource_group}"
}
 */