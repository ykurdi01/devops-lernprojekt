output "service_name" {
  description = "Name des Redis Service, wird von der App als REDIS_HOST gebraucht."
  value       = kubernetes_service.redis.metadata[0].name
}
