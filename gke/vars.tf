variable "google_project" {
  description = "GCE Project to use"
}

variable "google_region" {
  description = "GCE Region"
}

variable "google_keyfile" {
  description = "GCE Keyfile to access the project"
}

variable "gke_name" {
  description = "Name of the cluster to be created"
}

variable "gke_zone" {
  description = "Name of the zone to create the cluster in",
}

variable "gke_nr_of_nodes" {
  description = "Nr of initial nodes in the cluster"
}

variable "gke_type_of_nodes" {
  description = "Typ of nodes",
  default = "n1-standard-1"
}
