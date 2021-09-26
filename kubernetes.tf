//cria um namespace no cluster
resource "kubernetes_namespace" "remessa" {
//Este depends_on deve ser comentado antes de executar o terraform destroy
  depends_on = [module.eks]
  
  metadata {
    name = "remessa"
  }
}

//cria o deploy no namespace
resource "kubernetes_deployment" "nginx" {
  depends_on = [kubernetes_namespace.remessa]
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.remessa.metadata.0.name
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
          image = "nginx"
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

//cria um serviço para expor o nginx
resource "kubernetes_service" "nginx_service" {
  depends_on = [kubernetes_deployment.nginx]
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.remessa.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.nginx.spec.0.template.0.metadata.0.labels.app
    }
    type = "LoadBalancer"
    port {
      node_port   = 30201
      port        = 80
      target_port = 80
    }
  }
}

//cria um ingress para o serviço do nginx
resource "kubernetes_ingress" "nginxingress" {
  wait_for_load_balancer = false
  metadata {
    name = "nginxingress"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }
  spec {
    rule {
      http {
        path {
          path = "/*"
          backend {
            service_name = kubernetes_service.nginx_service.metadata.0.name
            service_port = 80
          }
        }
      }
    }
  }
}

