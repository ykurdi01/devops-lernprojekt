# Dieser Teil zeigt, wie man dieselben Kubernetes Ressourcen aus dem
# kubernetes Ordner auch mit Terraform als Code verwalten kann,
# statt sie per kubectl apply einzuspielen.

resource "kubernetes_namespace" "lernprojekt" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_deployment" "lernprojekt_app" {
  metadata {
    name      = "lernprojekt-app"
    namespace = kubernetes_namespace.lernprojekt.metadata[0].name
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
          image = var.app_image

          port {
            container_port = 5000
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = 5000
            }
            initial_delay_seconds = 3
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 5000
            }
            initial_delay_seconds = 5
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "lernprojekt_service" {
  metadata {
    name      = "lernprojekt-service"
    namespace = kubernetes_namespace.lernprojekt.metadata[0].name
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
