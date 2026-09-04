output "name" {
  description = "Name des angelegten Namespace."
  value       = kubernetes_namespace.this.metadata[0].name
}
