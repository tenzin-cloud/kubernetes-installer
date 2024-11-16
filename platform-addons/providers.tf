provider "helm" {
  kubernetes {
    config_path = "/etc/kubernetes/admin.conf"
  }
}

provider "kubernetes" {
  config_path = "/etc/kubernetes/admin.conf"
}
