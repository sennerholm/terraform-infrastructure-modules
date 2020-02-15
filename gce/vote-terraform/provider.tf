
provider "kubernetes" {
  host = "${var.kubernetes_host}"

  client_key             = "${base64decode(var.kubernetes_client_key)}"
  client_certificate     = "${base64decode(var.kubernetes_client_certificate)}"
  cluster_ca_certificate = "${base64decode(var.kubernetes_cluster_ca_certificate)}"
}

