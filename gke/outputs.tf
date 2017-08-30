
output "endpoint" {
  value = "https://${google_container_cluster.gke.endpoint}"
}

output "k8sconf" {
  value = {
  	endpoint 		   = "https://${google_container_cluster.gke.endpoint}"
  	client_certificate = "${base64decode(google_container_cluster.gke.master_auth.0.client_certificate)}"
  	client_key		   = "${base64decode(google_container_cluster.gke.master_auth.0.client_key)}"
  	ca_certificate     = "${base64decode(google_container_cluster.gke.master_auth.0.cluster_ca_certificate)}"
  	username		   = "${google_container_cluster.gke.master_auth.0.username}"
  	password           = "${google_container_cluster.gke.master_auth.0.password}"
  }
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

