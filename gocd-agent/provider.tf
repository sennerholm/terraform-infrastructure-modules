data "terraform_remote_state" "gke" {
  backend = "gcs"
  config {
    bucket = "${var.google_project}"
    path = "europe-west1/prod/gke/terraform.tfstate"    
    project="${var.google_project}" 
    credentials = "${var.google_keyfile}"
  }
}

data "terraform_remote_state" "gocd-server" {
  backend = "gcs"
  config {
    bucket = "${var.google_project}"
    path = "europe-west1/prod/gocd-server/terraform.tfstate"    
    project="${var.google_project}" 
    credentials = "${var.google_keyfile}"
  }
}

provider "kubernetes" {
  host = "${data.terraform_remote_state.gke.k8sconf.endpoint}"
  username = "${data.terraform_remote_state.gke.k8sconf.username}"
  password = "${data.terraform_remote_state.gke.k8sconf.password}"
  client_certificate = "${data.terraform_remote_state.gke.k8sconf.client_certificate}"
  client_key = "${data.terraform_remote_state.gke.k8sconf.client_key}"
  cluster_ca_certificate = "${data.terraform_remote_state.gke.k8sconf.ca_certificate}"
}

provider "google" {
  project     = "${var.google_project}"
  region      = "${var.google_region}"
  credentials = "${file("${var.google_keyfile}")}"
}

