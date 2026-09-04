output "namespace" {
  value = module.namespace.name
}

output "service_name" {
  value = module.app.service_name
}

output "node_port" {
  value = 30080
}
