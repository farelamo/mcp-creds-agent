## vault-proxy.hcl — Vault Proxy config (replaces deprecated api_proxy in Agent)
## MCP servers hit http://vault-proxy:8007 instead of Vault directly.

auto_auth {
  method "approle" {
    mount_path = "auth/approle"
    config = {
      role_id_file_path   = "/run/vault/role-id"
      secret_id_file_path = "/run/vault/secret-id"
    }
  }

  sink "file" {
    config = {
      path = "/run/vault/proxy-token"
      mode = 0600
    }
  }
}

api_proxy {
  use_auto_auth_token = true
}

listener "tcp" {
  address     = "0.0.0.0:8007"
  tls_disable = true
}

pid_file = "/run/vault/proxy.pid"
