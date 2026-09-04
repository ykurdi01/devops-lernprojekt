terraform {
  required_version = ">= 1.5.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.31"
    }
  }
}

# Nutzt den lokalen Kubeconfig, zum Beispiel von kind oder minikube.
provider "kubernetes" {
  config_path = var.kubeconfig_path
}
