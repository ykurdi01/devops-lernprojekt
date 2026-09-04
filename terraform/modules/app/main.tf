resource "kubernetes_config_map" "app" {
  metadata {
    name      = "lernprojekt-config"
    namespace = var.namespace
  }

  data = {
    APP_VERSION = var.app_version
    REDIS_HOST  = var.redis_host
    REDIS_PORT  = "6379"
  }
}

resource "kubernetes_secret" "app" {
  metadata {
    name      = "lernprojekt-secret"
    namespace = var.namespace
  }

  data = {
    APP_SECRET_KEY = var.app_secret_key
  }
}

resource "kubernetes_deployment" "app" {
  metadata {
    name      = "lernprojekt-app"
    namespace = var.namespace
    labels = {
      app = "lernprojekt-app"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "lernprojekt-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "lernprojekt-app"
        }
      }

      spec {
        container {
          name  = "lernprojekt-app"
          image = var.image

          port {
            container_port = 5000
          }

          env_from {
            config_map_ref {
              name = kubernetes_config_map.app.metadata[0].name
            }
          }

          env_from {
            secret_ref {
              name = kubernetes_secret.app.metadata[0].name
            }
          }

          resources {
            requests = {
              cpu    = var.cpu_request
              memory = var.memory_request
            }
            limits = {
              cpu    = var.cpu_limit
              memory = var.memory_limit
            }
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = 5000
            }
            initial_delay_seconds = 5
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 5000
            }
            initial_delay_seconds = 10
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name      = "lernprojekt-service"
    namespace = var.namespace
  }

  spec {
    type = "NodePort"

    selector = {
      app = "lernprojekt-app"
    }

    port {
      port        = 80
      target_port = 5000
      node_port   = 30080
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v2" "app" {
  metadata {
    name      = "lernprojekt-app-hpa"
    namespace = var.namespace
  }

  spec {
    min_replicas = var.replicas
    max_replicas = var.replicas + 3

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.app.metadata[0].name
    }

    metric {
      type = "Resource"

      resource {
        name = "cpu"

        target {
          type                = "Utilization"
          average_utilization = 60
        }
      }
    }
  }
}
