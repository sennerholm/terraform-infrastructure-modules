variable "client_id" {}
variable "client_secret" {}

variable "agent_count" {
  default = 3
}
variable "agent_mincount" {
  default = 2
}

variable "agent_maxcount" {
  default = 6
}

variable "agent_size" {
  default = "Standard_DS1_v2"
  #"Standard_DS1_v2" #Standard_D2s_v3
}
variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
  default = "kubernetes"
}

variable cluster_name {
  default = "kubernetes"
}

variable "subscription_name" {}
variable location {}
variable k8s_resourcegroup_name {}
