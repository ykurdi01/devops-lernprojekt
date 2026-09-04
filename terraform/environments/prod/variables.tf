variable "kubeconfig_path" {
  description = "Pfad zur lokalen kubeconfig Datei."
  type        = string
  default     = "~/.kube/config"
}

variable "namespace" {
  description = "Name des Kubernetes Namespace fuer die prod Umgebung."
  type        = string
  default     = "lernprojekt-prod"
}

variable "app_image" {
  description = "Image, das im Deployment verwendet wird."
  type        = string
  default     = "lernprojekt-app:0.2.0"
}

variable "replicas" {
  description = "Anzahl der Pods im Deployment."
  type        = number
  default     = 3
}

variable "app_secret_key" {
  description = "Wert fuer das Secret, sollte per TF_VAR_app_secret_key gesetzt werden und nicht in tfvars stehen."
  type        = string
  sensitive   = true
}

variable "cpu_request" {
  type    = string
  default = "100m"
}

variable "cpu_limit" {
  type    = string
  default = "500m"
}

variable "memory_request" {
  type    = string
  default = "128Mi"
}

variable "memory_limit" {
  type    = string
  default = "256Mi"
}
