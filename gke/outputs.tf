
output "endpoint" {
  value = "https://${google_container_cluster.gke.endpoint}"
}

output "client_certificate" {
  value = "${base64decode(google_container_cluster.gke.master_auth.0.client_certificate)}"
}

output "client_key" {
  value = "${base64decode(google_container_cluster.gke.master_auth.0.client_key)}"
}

output "ca_certificate" {
  value = "${base64decode(google_container_cluster.gke.master_auth.0.cluster_ca_certificate)}"
}


output "username" {
  value = "${google_container_cluster.gke.master_auth.0.username}"
}


output "password" {
  value = "${google_container_cluster.gke.master_auth.0.password}"
}

