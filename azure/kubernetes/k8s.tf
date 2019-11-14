

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
    vm_size             = "Standard_DS1_v2" #Standard_D2s_v3
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
