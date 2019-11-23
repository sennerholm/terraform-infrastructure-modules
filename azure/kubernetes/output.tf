output "client_key" {
  sensitive = true

  value = "${azurerm_kubernetes_cluster.k8s.kube_config.0.client_key}"
}

output "client_certificate" {
  sensitive = true

  value = "${azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate}"
}

output "cluster_ca_certificate" {
  value = "${azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate}"
}

output "cluster_username" {
  value = "${azurerm_kubernetes_cluster.k8s.kube_config.0.username}"
}

output "cluster_password" {
  sensitive = true
  value     = "${azurerm_kubernetes_cluster.k8s.kube_config.0.password}"
}

output "kube_config" {
  sensitive = true

  value = "${azurerm_kubernetes_cluster.k8s.kube_config_raw}"
}
output "host" {
  value = "${azurerm_kubernetes_cluster.k8s.kube_config.0.host}"
}
output "data_k8s" {
  sensitive = true
  value     = "${data.azurerm_kubernetes_cluster.k8s}"
}
output "data_vnets" {
  value = "${data.azurerm_virtual_network.vnet}"
}
output "data_subnets" {
  value = flatten(values(data.azurerm_virtual_network.vnet)[*].subnets.*)
}
output "data_subnet_ids" {
  value = flatten(values(data.azurerm_subnet.subnet)[*].id)
}
