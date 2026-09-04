output "service_name" {
  description = "Name des App Service."
  value       = kubernetes_service.app.metadata[0].name
}

output "deployment_name" {
  description = "Name des App Deployments."
  value       = kubernetes_deployment.app.metadata[0].name
}
