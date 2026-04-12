## vault-agent.hcl — Vault Agent config for Go MCP stack
## After re-rendering a template, Agent runs the `command` to hot-reload
## the target MCP container via docker kill --signal=SIGHUP.

## address is set via VAULT_ADDR environment variable in docker-compose.
## No need to hardcode it here.

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
      path = "/run/vault/agent-token"
      mode = 0600
    }
  }
}

## Proxy functionality moved to `vault proxy` subcommand.
## See vault-proxy.hcl for the proxy config.

## ── Jenkins MCP ──────────────────────────────────────────────────────────────
template {
  source      = "/etc/vault-agent/templates/jenkins.ctmpl"
  destination = "/run/secrets/jenkins/.env"
  perms       = "0600"
  ## Signal the Go container to invalidate its credential cache
  command     = "docker kill --signal=SIGHUP mcp-jenkins 2>/dev/null || true"
  error_on_missing_key = true
}

## ── Vault MCP ─────────────────────────────────────────────────────────────
template {
  source      = "/etc/vault-agent/templates/vault-mcp.ctmpl"
  destination = "/run/secrets/vault-mcp/.env"
  perms       = "0600"
  command     = "docker kill --signal=SIGHUP mcp-vault 2>/dev/null || true"
  error_on_missing_key = true
}

## ── SSH MCP ───────────────────────────────────────────────────────────────
template {
  source      = "/etc/vault-agent/templates/ssh.ctmpl"
  destination = "/run/secrets/ssh/.env"
  perms       = "0600"
  command     = "docker kill --signal=SIGHUP mcp-ssh 2>/dev/null || true"
  error_on_missing_key = true
}

## ── SSH private key (separate file, chmod 600) ──────────────────────────
template {
  source      = "/etc/vault-agent/templates/ssh-key.ctmpl"
  destination = "/run/secrets/ssh/id_ed25519"
  perms       = "0600"
  command     = "docker kill --signal=SIGHUP mcp-ssh 2>/dev/null || true"
  error_on_missing_key = true
}

## ── Custom MCP ────────────────────────────────────────────────────────────
template {
  source      = "/etc/vault-agent/templates/custom.ctmpl"
  destination = "/run/secrets/custom/.env"
  perms       = "0600"
  command     = "docker kill --signal=SIGHUP mcp-custom 2>/dev/null || true"
  error_on_missing_key = true
}

## ── Grafana MCP ────────────────────────────────────────────────────────────
template {
  source      = "/etc/vault-agent/templates/grafana.ctmpl"
  destination = "/run/secrets/grafana/.env"
  perms       = "0600"
  command     = "docker kill --signal=SIGHUP mcp-server 2>/dev/null || true"
  error_on_missing_key = true
}

## ── Elasticsearch MCP ─────────────────────────────────────────────────────
template {
  source      = "/etc/vault-agent/templates/elastic.ctmpl"
  destination = "/run/secrets/elastic/.env"
  perms       = "0600"
  command     = "docker kill --signal=SIGHUP mcp-server 2>/dev/null || true"
  error_on_missing_key = true
}

## ── Prometheus MCP ────────────────────────────────────────────────────────
template {
  source      = "/etc/vault-agent/templates/prometheus.ctmpl"
  destination = "/run/secrets/prometheus/.env"
  perms       = "0600"
  command     = "docker kill --signal=SIGHUP mcp-server 2>/dev/null || true"
  error_on_missing_key = true
}

## ── GitHub MCP ────────────────────────────────────────────────────────────
template {
  source      = "/etc/vault-agent/templates/github.ctmpl"
  destination = "/run/secrets/github/.env"
  perms       = "0600"
  command     = "docker kill --signal=SIGHUP mcp-server 2>/dev/null || true"
  error_on_missing_key = true
}

pid_file = "/run/vault/agent.pid"
