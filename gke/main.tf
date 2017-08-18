// Created by scripts/bootstrap.sh
provider "google" {
  project     = "${var.google_project}"
  region      = "${var.google_region}"
  credentials = "${file("${var.google_keyfile}")}"
}


// Create cluster over multiple failorzones
resource "google_container_cluster" "gke" {
  name               = "${var.gke_name}"
  zone               = "${var.gke_zone}"
  initial_node_count = "${var.gke_nr_of_nodes}"
 
  node_config {
    machine_type = "${var.gke_type_of_nodes}"
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
  provisioner "local-exec" {
    command = "gcloud --project ${var.google_project} container clusters get-credentials ${var.gke_name}"
  }
}
