variable "kubeconfig_path" {
  description = "Pfad zur lokalen kubeconfig Datei."
  type        = string
  default     = "~/.kube/config"
}

variable "namespace" {
  description = "Name des Kubernetes Namespace fuer die dev Umgebung."
  type        = string
  default     = "lernprojekt-dev"
}

variable "app_image" {
  description = "Image, das im Deployment verwendet wird."
  type        = string
  default     = "lernprojekt-app:0.2.0"
}

variable "replicas" {
  description = "Anzahl der Pods im Deployment."
  type        = number
  default     = 1
}

variable "app_secret_key" {
  description = "Wert fuer das Secret, sollte per TF_VAR_app_secret_key gesetzt werden und nicht in tfvars stehen."
  type        = string
  sensitive   = true
  default     = "nur-fuer-lokale-tests"
}
