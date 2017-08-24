data "terraform_remote_state" "gke" {
  backend = "gcs"
  config {
    bucket = "mikan-terraform-project6"
    path = "europe-west1/prod/gke/terraform.tfstate"    
    project="mikan-terraform-project6" 
    credentials = "/home/mikan/.config/gcloud/terraform-project6.json"
  }
}

provider "kubernetes" {
  host = "${data.terraform_remote_state.gke.endpoint}"
  username = "${data.terraform_remote_state.gke.username}"
  password = "${data.terraform_remote_state.gke.password}"
  client_certificate = "${data.terraform_remote_state.gke.client_certificate}"
  client_key = "${data.terraform_remote_state.gke.client_key}"
  cluster_ca_certificate = "${data.terraform_remote_state.gke.ca_certificate}"
}

provider "google" {
  project     = "${var.google_project}"
  region      = "${var.google_region}"
  credentials = "${file("${var.google_keyfile}")}"
}


resource "kubernetes_namespace" "gocd-server" {
  metadata {
    name = "gocd-server"
  }
}

resource "google_compute_disk" "go_data" {
  name  = "prod-go-data"
  type  = "pd-standard"
  zone  = "${var.gce_zone}"
  size  = "100"
}

resource "google_compute_disk" "go_datadb" {
  name  = "prod-go-data-db"
  type  = "pd-ssd"
  zone  = "${var.gce_zone}"
  size  = "10"
}

// Todo Add loadbalancer to reach gocd-server from agents.
