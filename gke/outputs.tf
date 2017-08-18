
output "endpoint" {
  value = "https://${google_container_cluster.gke.endpoint}"
}
output "client_cert" {
  value = "https://${google_container_cluster.gke.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "https://${google_container_cluster.gke.master_auth.0.client_key}"
}

output "ca_certificate" {
  value = "https://${google_container_cluster.gke.master_auth.0.ca_certificate}"
}
