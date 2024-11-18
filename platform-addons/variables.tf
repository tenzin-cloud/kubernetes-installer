variable "shared_filesystem_path" {
  type = string
}

variable "cloudflare_tunnel_token" {
  type      = string
  sensitive = true
}