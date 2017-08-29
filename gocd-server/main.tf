
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

// We need an initcontainer to fill the go_data disk with bootstrap config. 
// Otherwize we should have declared the pod as a kubectl pod
// Now we doesn't handle delete any good...
resource "null_resource" "gocd-pod-with-init" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers {
    go_data = "${google_compute_disk.prod_go_data.self_link}"
  }
  depends_on = ["kubernetes_namespace.gocd-server",
  				"google_compute_disk.prod_go_data",
  				"google_compute_disk.prod_go_datadb"]
  provisioner "local-exec" {
    command = "kubectl apply --namespace gocd-server -f ${path.module}/goserver.yaml"
  }
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

