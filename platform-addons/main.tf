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
    path = "/data/local/cluster.tfstate"
  }
}

provider "vault" {
  address = "https://vault.tenzin.io"
}

resource "vault_kv_secret_v2" "kubeconifg" {
  mount = "kubernetes-secrets"
  name  = "kubeconfig/${var.cluster_name}-${var.cluster_uuid}"
  data_json = jsonencode({
    kubeconfig = var.kubeconfig
  })
}

module "calico" {
  source           = "git::https://github.com/tenzin-io/terraform-modules.git//kubernetes/calico?ref=main"
  pod_cidr_network = "10.253.0.0/16"
}

module "local_path_provisioner" {
  source     = "git::https://github.com/tenzin-io/terraform-modules.git//kubernetes/local-path-provisioner?ref=main"
  local_path = var.cluster_filesystem_path
  depends_on = [module.calico]
}

module "metallb" {
  source        = "git::https://github.com/tenzin-io/terraform-tenzin-homelab.git//kubernetes/metallb?ref=main"
  ip_pool_range = "${var.cluster_loadbalancer_ip}/32"
  depends_on    = [module.calico]
}

module "nginx_ingress" {
  source     = "git::https://github.com/tenzin-io/terraform-modules.git//kubernetes/ingress-nginx?ref=main"
  depends_on = [module.metallb]
}