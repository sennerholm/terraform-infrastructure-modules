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

variable "gcr_host" {
  description = "Host name of the container registry",
}

variable "terragrunt_config_path" {
  description = "Absolut path to a directory containing a terraform.tfvars to be imported as an configmap to the go container",
}
