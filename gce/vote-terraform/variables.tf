variable "pod_scale" {
  default = 1
}

variable name {
  default = "vote"
}


variable kubernetes_host {}
variable kubernetes_client_key {}
variable kubernetes_client_certificate {}
variable kubernetes_cluster_ca_certificate {}

variable "vote1value" {
  description = "First vote option"  
}

variable "vote2value" {
  description = "Second vote option"  
}



