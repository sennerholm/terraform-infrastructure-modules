variable "client_id" {}
variable "client_secret" {}

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

variable full_resourcegroup_name {}


variable "subscription_name" {}
variable location {}
variable resourcegroup_name {}
