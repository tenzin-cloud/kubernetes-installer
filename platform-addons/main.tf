terraform {
  required_version = "~> 1.0"
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }

  backend "local" {
    path = "/data/shared/cluster.tfstate"
  }
}

module "calico" {
  source           = "git::https://github.com/tenzin-io/terraform-modules.git//kubernetes/calico?ref=main"
  pod_cidr_network = "10.253.0.0/16"
}

module "local_path_provisioner" {
  source     = "git::https://github.com/tenzin-io/terraform-modules.git//kubernetes/local-path-provisioner?ref=main"
  local_path = "/data/shared"
  depends_on = [module.calico]
}

module "nginx_ingress" {
  source                   = "git::https://github.com/tenzin-io/terraform-modules.git//kubernetes/ingress-nginx?ref=main"
  enable_cloudflare_tunnel = true
  cloudflare_tunnel_token  = var.cloudflare_tunnel_token
}