variable "namespace" {
  description = "Namespace, in dem die App laeuft."
  type        = string
}

variable "image" {
  description = "Container Image der App."
  type        = string
}

variable "replicas" {
  description = "Anzahl der Pods im Deployment."
  type        = number
  default     = 2
}

variable "app_version" {
  description = "Wert fuer die APP_VERSION Umgebungsvariable."
  type        = string
  default     = "0.2.0"
}

variable "redis_host" {
  description = "Hostname des Redis Service."
  type        = string
  default     = "redis-service"
}

variable "app_secret_key" {
  description = "Platzhalterwert fuer ein Secret, kommt idealerweise aus TF_VAR_app_secret_key und nicht aus einer eingecheckten Datei."
  type        = string
  sensitive   = true
}

variable "cpu_request" {
  type    = string
  default = "50m"
}

variable "cpu_limit" {
  type    = string
  default = "200m"
}

variable "memory_request" {
  type    = string
  default = "64Mi"
}

variable "memory_limit" {
  type    = string
  default = "128Mi"
}
