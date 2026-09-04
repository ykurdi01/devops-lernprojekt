output "namespace" {
  description = "Name des angelegten Namespace."
  value       = kubernetes_namespace.lernprojekt.metadata[0].name
}

output "service_name" {
  description = "Name des Kubernetes Service."
  value       = kubernetes_service.lernprojekt_service.metadata[0].name
}

output "node_port" {
  description = "Port, unter dem die App erreichbar ist."
  value       = 30080
}
