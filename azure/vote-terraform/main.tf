resource "kubernetes_namespace" "azure-vote" {
  metadata {
    annotations = {
      name = "example-annotation"
    }

    labels = {
      mylabel = "label-value"
    }

    name = "${var.resourcegroup_name}-${var.name}"
  }
}

resource "kubernetes_deployment" "azure-vote-front" {
  metadata {
    name      = "azure-vote-front"
    namespace = "${kubernetes_namespace.azure-vote.metadata.0.name}"
    labels = {
      app = "azure-vote-front"
    }
  }

  spec {
    replicas = "${var.pod_scale}"

    selector {
      match_labels = {
        app = "azure-vote-front"
      }
    }

    template {
      metadata {
        labels = {
          app = "azure-vote-front"
        }
      }

      spec {
        container {
          image = "neilpeterson/azure-vote-front:v3"
          name  = "azure-vote-front"

          env {
            name  = "REDIS"
            value = "azure-vote-back"
          }
          env {
            name  = "TITLE"
            value = "Terraform Voting app"
          }
          env {
            name  = "VOTE1VALUE"
            value = "Terraform"
          }
          env {
            name  = "VOTE2VALUE"
            value = "Helmcharts"
          }
          resources {
            requests {
              cpu    = "100m"
              memory = "250Mi"
            }
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "azure-vote-front" {
  metadata {
    name      = "azure-vote-front"
    namespace = "${kubernetes_namespace.azure-vote.metadata.0.name}"
  }
  spec {
    selector = {
      app = "${kubernetes_deployment.azure-vote-front.metadata.0.labels.app}"
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_deployment" "azure-vote-back" {
  metadata {
    name      = "azure-vote-back"
    namespace = "${kubernetes_namespace.azure-vote.metadata.0.name}"
    labels = {
      app = "azure-vote-back"
    }
  }

  spec {
    replicas = "1"

    selector {
      match_labels = {
        app = "azure-vote-back"
      }
    }

    template {
      metadata {
        labels = {
          app = "azure-vote-back"
        }
      }

      spec {
        container {
          image = "redis"
          name  = "azure-vote-back"

          resources {
            requests {
              cpu    = "250m"
              memory = "250Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "azure-vote-back" {
  metadata {
    name      = "azure-vote-back"
    namespace = "${kubernetes_namespace.azure-vote.metadata.0.name}"
  }
  spec {
    selector = {
      app = "${kubernetes_deployment.azure-vote-back.metadata.0.labels.app}"
    }
    port {
      port        = 6379
      target_port = 6379
    }
  }
}

