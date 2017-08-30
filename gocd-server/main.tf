
resource "kubernetes_namespace" "gocd-server" {
  metadata {
    name = "gocd-server"
  }
}

resource "google_compute_disk" "prod_go_data" {
  name  = "prod-go-data"
  type  = "pd-standard"
  zone  = "${var.gce_zone}"
  size  = "100"
}

resource "google_compute_disk" "prod_go_datadb" {
  name  = "prod-go-data-db"
  type  = "pd-ssd"
  zone  = "${var.gce_zone}"
  size  = "10"
}


// Change to the template language later
// https://www.terraform.io/docs/providers/template/d/file.html
module "kubernetes_goserver" {
  source        = "../kubernetes_beta"
  namespace 	= "${kubernetes_namespace.gocd-server.metadata.0.name}"
  k8sconf    	= "${data.terraform_remote_state.gke.k8sconf}"
  configuration = "${file("${path.module}/goserver.yaml")}"
  depends_on	= "${google_compute_disk.prod_go_data.users} ${google_compute_disk.prod_go_datadb.users} "
}

resource "kubernetes_service" "gocd-server" {
  metadata {
    name = "gocd-server"
    namespace = "gocd-server"
    
  }
  spec {
    selector {
      name = "gocd-server"
    }
    session_affinity = "None"
    port {
      port = 443
      target_port = 8154
    }
    type = "LoadBalancer"
  }
}

