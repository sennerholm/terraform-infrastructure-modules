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

variable "environment" {
  description = "environment to deploy in, for example, prod, test, stage etc"
}


variable "namespace_suffix" {
  description = "Suffix of namespace to create",
  default = "",
}

variable "version" {
  description = "Version of the container to start",
}

variable "registry_host" {
  description = "Registry host to pull images from",
  default     = "eu.gcr.io"
}



