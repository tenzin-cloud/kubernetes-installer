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

  backend "local" {}
}

provider "vault" {
  address = var.vault_address
  auth_login_userpass {
    username = var.vault_username
    password = var.vault_password
  }
}

resource "vault_kv_secret_v2" "kubeconifg" {
  mount = "kubernetes-secrets"
  name  = "kubeconfig/${var.cluster_name}"
  data_json = jsonencode({
    kubeconfig = fileexists("/etc/kubernetes/admin.conf") ? file("/etc/kubernetes/admin.conf") : "kubeconfig not found"
  })
  disable_read = true
}

resource "helm_release" "calico" {
  name             = "calico"
  namespace        = "tigera-operator"
  create_namespace = true
  repository       = "https://projectcalico.docs.tigera.io/charts"
  chart            = "tigera-operator"
  version          = "v3.29.2"
  wait             = true
  values = [templatefile("${path.module}/templates/calico-values.yaml", {
    pod_cidr_network = "10.253.0.0/16"
  })]
}

resource "helm_release" "local_path_provisioner" {
  name             = "local-path-provisioner"
  namespace        = "kube-system"
  create_namespace = false
  repository       = "oci://ghcr.io/tenzin-io"
  chart            = "local-path-provisioner"
  version          = "v0.0.31"
  wait             = true

  set {
    name  = "image.tag"
    value = "v0.0.31"
  }

  set {
    name  = "storageClass.defaultClass"
    value = true
  }

  depends_on = [helm_release.calico]
}

