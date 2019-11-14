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

# NOTE: the Name used for Redis needs to be globally unique

resource "random_integer" "redis_suffix" {
  min = 1
  max = 50000
}
resource "azurerm_redis_cache" "backend" {
  name                = "${var.full_resourcegroup_name}-${var.name}-${random_integer.redis_suffix.result}"
  location            = "${var.location}"
  resource_group_name = "${var.full_resourcegroup_name}"
  capacity            = 0
  family              = "C"
  sku_name            = "Basic"
  minimum_tls_version = "1.2"
  enable_non_ssl_port = true

  redis_configuration {}
}

resource "kubernetes_secret" "rediscache-secret" {
  metadata {
    name      = "rediscache-secret"
    namespace = "${kubernetes_namespace.azure-vote.metadata.0.name}"

  }

  data = {
    REDIS     = "${azurerm_redis_cache.backend.hostname}"
    REDIS_PWD = "${azurerm_redis_cache.backend.primary_access_key}"
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

          env_from {
            secret_ref {
              name = "rediscache-secret"
            }
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
