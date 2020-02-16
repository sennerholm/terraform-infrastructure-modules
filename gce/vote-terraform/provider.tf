
# From: https://stackoverflow.com/questions/51200159/how-to-bootstrap-rbac-privileges-when-bringing-up-a-gke-cluster-with-terraform
data "google_client_config" "default" {}

provider "kubernetes" {
  host = "${var.kubernetes_host}"
  token = "${data.google_client_config.default.access_token}"

  cluster_ca_certificate = "${base64decode(var.kubernetes_cluster_ca_certificate)}"
}
