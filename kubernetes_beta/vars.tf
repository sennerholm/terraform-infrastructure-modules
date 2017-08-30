# A module that can create Kubernetes resources from YAML file descriptions.

variable "k8sconf" {
  type = "map"
  description = "The Kubernetes cluster map (for example from GKE module)"
}

variable "configuration" {
  description = "The configuration that should be applied"
}

variable "namespace" {
  description = "The namespace the configuration that should be applied to"
  default ="default"
}

variable "depends_on" {
  description = "Concat a string of all resources it depends on"
}
