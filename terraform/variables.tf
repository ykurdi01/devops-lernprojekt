variable "kubeconfig_path" {
  description = "Pfad zur lokalen kubeconfig Datei."
  type        = string
  default     = "~/.kube/config"
}

variable "namespace" {
  description = "Name des Kubernetes Namespace fuer das Lernprojekt."
  type        = string
  default     = "lernprojekt"
}

variable "app_image" {
  description = "Image, das im Deployment verwendet wird."
  type        = string
  default     = "lernprojekt-app:0.1.0"
}

variable "replicas" {
  description = "Anzahl der Pods im Deployment."
  type        = number
  default     = 2
}
