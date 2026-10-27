# Output the load balancer hostname for accessing the Nginx service
output "load_balancer_hostname" {
  description = "Hostname of the LoadBalancer exposing the Nginx service"
  value       = kubernetes_service.nginx_service.status
}
