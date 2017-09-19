
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

output "name" {
  value = "${var.gke_name}"
}
