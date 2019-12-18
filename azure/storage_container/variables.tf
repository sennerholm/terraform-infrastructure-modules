variable "client_id" {}
variable "client_secret" {}


variable resource_name {
  default = "db"
}


variable full_resourcegroup_name {}


variable "subscription_name" {}
variable location {}
variable resourcegroup_name {}
variable src_subnets {
  type        = list(string)
  description = "src subnet id's to access"
}
