// Need to get the already created "default" vpc to connect to, so it's possible to connect 
// to backend services like "redis"
data "google_compute_network" "default" {
  name = "default"
}
data "google_compute_subnetwork" "default" {
  name   = "default"
  region = var.region
}
// Create cluster over multiple failorzones
// Not a recommended setup, should have node_config separately but increase time of deploy
// Authentication should not use username/password


resource "google_container_cluster" "main" {
  name               = "gke${var.region}${var.env}${var.system}${var.component}${var.append_name}"
  location              = var.region
  
  network = "default"
  subnetwork = "default"
  ip_allocation_policy {
    cluster_ipv4_cidr_block ="" # Allocate a free one
    services_ipv4_cidr_block ="" # Allocate a free one
  }
  initial_node_count = var.gke_nr_of_nodes

  node_config {
    machine_type = var.gke_type_of_nodes
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }
  }
/*   master_auth {
    client_certificate_config {
      issue_client_certificate = true
    }
  } */
 /*  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      minimum = 1
      maximum = var.max_cpu 
    }
  } */
}
