# Common variables defined in common.tf

# Specific parts:
#variable "keyfile" {
#  description = "GCE Keyfile to access the project"
#}


variable "gke_nr_of_nodes" {
  description = "Nr of initial nodes in the cluster per zone (x3)"
  default     = "1"
}

variable "gke_type_of_nodes" {
  description = "Typ of nodes"
  default = "n1-standard-1"
}

variable "max_cpu" {
  description = "Max CPU for the autoscaling function"
  default = "16"
}
