terraform {
  required_version = ">= 1.5.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.31"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

module "namespace" {
  source = "../../modules/namespace"
  name   = var.namespace
}

module "redis" {
  source    = "../../modules/redis"
  namespace = module.namespace.name
}

module "app" {
  source         = "../../modules/app"
  namespace      = module.namespace.name
  image          = var.app_image
  replicas       = var.replicas
  app_secret_key = var.app_secret_key
  redis_host     = module.redis.service_name
  cpu_request    = var.cpu_request
  cpu_limit      = var.cpu_limit
  memory_request = var.memory_request
  memory_limit   = var.memory_limit
}
