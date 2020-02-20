variable "pod_scale" {
  default = 2
}

variable name {
  default = "vote"
}


variable kubernetes_host {}
variable kubernetes_client_key {}
variable kubernetes_client_certificate {}
variable kubernetes_cluster_ca_certificate {}

variable "redis_host" {
  description = "Host of the redis service"
}

variable "vote_title" {
  description = "Vote title"  
}

variable "vote_alt1" {
  description = "First vote option"  
}

variable "vote_alt2" {
  description = "Second vote option"  
}


variable "domain" {
  default = "mikan.net"
}
