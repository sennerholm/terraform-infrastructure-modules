output "instance_group_urls" {
  value = google_container_cluster.main.instance_group_urls
}

output "client_key" {
  sensitive = true

  value = "${google_container_cluster.main.master_auth.0.client_key}"
}

output "client_certificate" {
  sensitive = true

  value = "${google_container_cluster.main.master_auth.0.client_certificate}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.main.master_auth.0.cluster_ca_certificate}"
}

output "cluster_username" {
  value = "${google_container_cluster.main.master_auth.0.username}"
}

output "cluster_password" {
  sensitive = true
  value     = "${google_container_cluster.main.master_auth.0.password}"
}
output "endpoint" {
  value = "https://${google_container_cluster.main.endpoint}"
}


output "name" {
  value = "${google_container_cluster.main.name}"
}
