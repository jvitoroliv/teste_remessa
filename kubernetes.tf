# Kubernetes resources: namespace, deployment, service, and ingress

# Create a dedicated namespace for the application
# NOTE: This depends_on must be commented out before running terraform destroy
resource "kubernetes_namespace" "remessa" {
  depends_on = [module.eks]

  metadata {
    name = "remessa"
  }
}

# Nginx deployment
resource "kubernetes_deployment" "nginx" {
  depends_on = [kubernetes_namespace.remessa]

  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.remessa.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          image = "nginx:stable-alpine"
          name  = "nginx-container"

          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

# Service to expose Nginx via a LoadBalancer
resource "kubernetes_service" "nginx_service" {
  depends_on = [kubernetes_deployment.nginx]

  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.remessa.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.nginx.spec[0].template[0].metadata[0].labels.app
    }

    type = "LoadBalancer"

    port {
      node_port   = 30201
      port        = 80
      target_port = 80
    }
  }
}

# Ingress resource for the Nginx service
# Updated from deprecated kubernetes_ingress to kubernetes_ingress_v1
resource "kubernetes_ingress_v1" "nginxingress" {
  wait_for_load_balancer = false

  metadata {
    name      = "nginxingress"
    namespace = kubernetes_namespace.remessa.metadata[0].name

    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.nginx_service.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
