variable "namespace" {
  description = "Namespace, in dem Redis laeuft."
  type        = string
}

variable "storage_size" {
  description = "Groesse des persistenten Speichers fuer Redis."
  type        = string
  default     = "256Mi"
}
