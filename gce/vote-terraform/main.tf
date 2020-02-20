resource "kubernetes_namespace" "vote" {
  metadata {
    annotations = {
      name = "example-annotation"
    }

    labels = {
      mylabel = "label-value"
    }

    name = lower(var.system)
  }
} 

resource "kubernetes_secret" "rediscache-secret" {
  metadata {
    name      = "rediscache-secret"
    namespace = kubernetes_namespace.vote.metadata.0.name

  }

  data = {
    REDIS          = var.redis_host
  }
}


resource "kubernetes_deployment" "vote-front" {
  depends_on = [ kubernetes_secret.rediscache-secret ]
  metadata {
    name      = "vote-front"
    namespace = kubernetes_namespace.vote.metadata.0.name
    labels = {
      app = "vote-front"
    }
  }

  spec {
    replicas = var.pod_scale

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
            value = var.vote_title
          }
          env {
            name  = "VOTE1VALUE"
            value = var.vote_alt1
          }
          env {
            name  = "VOTE2VALUE"
            value = var.vote_alt2
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
    namespace = kubernetes_namespace.vote.metadata.0.name
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
data "cloudflare_zones" "main" {
  filter {
    name   = var.domain
    status = "active"
    paused = false
  }
}

resource "cloudflare_record" "vote-front" {
  zone_id = data.cloudflare_zones.main.zones[0].id
  name    = "vote.${var.system}.${var.region}.${var.project}"
  value   = kubernetes_service.vote-front.load_balancer_ingress[0].ip 
  type    = "A"
}
