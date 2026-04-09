#!/usr/bin/env bash
## bootstrap.sh — one-time Vault setup for the Go MCP stack.
## Run with a root/admin Vault token. After this, Vault Agent handles everything.

set -euo pipefail

echo "══════════════════════════════════════════"
echo "  Vault Agent Go MCP — bootstrap"
echo "══════════════════════════════════════════"

vault secrets enable -path=secret kv-v2 2>/dev/null || echo "(kv-v2 already enabled)"
vault policy write mcp-agent ./configs/mcp-policy.hcl
vault auth enable approle 2>/dev/null || echo "(approle already enabled)"

vault write auth/approle/role/mcp-agent \
  token_policies="mcp-agent" \
  token_ttl=1h \
  token_max_ttl=4h \
  token_renewable=true

mkdir -p ./agent
vault read  -field=role_id   auth/approle/role/mcp-agent/role-id   > ./agent/role-id
vault write -f -field=secret_id auth/approle/role/mcp-agent/secret-id > ./agent/secret-id
chmod 600 ./agent/role-id ./agent/secret-id
echo "role-id and secret-id written to ./agent/ (add to .gitignore)"

echo ""
echo "→ Seeding Jenkins secrets..."
read -rp  "  Jenkins URL: "      JENKINS_URL
read -rp  "  Jenkins username: " JENKINS_USER
read -rsp "  Jenkins API token: " JENKINS_TOKEN; echo
vault kv put secret/mcp/jenkins url="$JENKINS_URL" username="$JENKINS_USER" api_token="$JENKINS_TOKEN"

echo "→ Seeding SSH secrets..."
read -rp "  SSH host: "          SSH_HOST
read -rp "  SSH user: "          SSH_USER
read -rp "  SSH key file path: " SSH_KEY_FILE
vault kv put secret/mcp/ssh      host="$SSH_HOST" username="$SSH_USER" port="22"
vault kv put secret/mcp/ssh-key  private_key="$(cat "$SSH_KEY_FILE")"
echo "  SSH key stored in Vault — safe to remove the file from disk now"

echo ""
echo "══════════════════════════════════════════"
echo "  Done. Next steps:"
echo "  1. Add ./agent/ to .gitignore"
echo "  2. docker compose -f docker/docker-compose.yml up -d"
echo "══════════════════════════════════════════"
