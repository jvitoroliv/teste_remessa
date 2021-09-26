
# Display load balancer hostname (typically present in AWS)
output "load_balancer_hostname" {
  value = kubernetes_service.nginx_service.status
}
