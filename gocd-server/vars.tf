variable "google_project" {
  description = "GCE Project to use"
}

variable "google_region" {
  description = "GCE Region"
}

variable "google_keyfile" {
  description = "GCE Keyfile to access the project"
}

variable "gce_zone" {
  description = "Name of the zone to create resources in",
}

variable "ssh_key_path" {
  description = "Absolut path to a directory containing a id_rsa and id_rsa.pub file to create a secret from",
}
