/* resource "kubernetes_namespace" "vote" {
  metadata {
    annotations = {
      name = "example-annotation"
    }

    labels = {
      mylabel = "label-value"
    }

    name = lower(var.system)
  }
} */

resource "google_redis_instance" "main" {
  name               = "${substr(lower("redis${var.region}${var.env}${var.system}${var.component}${var.append_name}"),0,39)}"
  memory_size_gb = 1
}

resource "kubernetes_secret" "rediscache-secret" {
  metadata {
    name      = "rediscache-secret"
    #namespace = "${kubernetes_namespace.vote.metadata.0.name}"

  }

  data = {
    REDIS          = "${google_redis_instance.main.host}"
    REDIS_PORT     = "${google_redis_instance.main.port}"
  }
}


resource "kubernetes_deployment" "vote-front" {
  depends_on = [ kubernetes_secret.rediscache-secret ]
  metadata {
    name      = "vote-front"
    #namespace = "${kubernetes_namespace.vote.metadata.0.name}"
    labels = {
      app = "vote-front"
    }
  }

  spec {
    replicas = "${var.pod_scale}"

    selector {
      match_labels = {
        app = "vote-front"
      }
    }

    template {
      metadata {
        labels = {
          app = "vote-front"
        }
      }

      spec {
        container {
          image = "neilpeterson/azure-vote-front:v3"
          name  = "vote-front"

          env_from {
            secret_ref {
              name = "rediscache-secret"
            }
          }
          env {
            name  = "TITLE"
            value = "${var.vote_title}"
          }
          env {
            name  = "VOTE1VALUE"
            value = "${var.vote_alt1}"
          }
          env {
            name  = "VOTE2VALUE"
            value = "${var.vote_alt2}"
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

resource "kubernetes_service" "vote-front" {
  metadata {
    name      = "vote-front"
    #namespace = "${kubernetes_namespace.vote.metadata.0.name}"
  }
  spec {
    selector = {
      app = "vote-front"
    }
    session_affinity = "ClientIP"
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
