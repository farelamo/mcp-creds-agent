# mcp-policy.hcl — read-only access to exactly the paths each MCP needs.
# Apply: vault policy write mcp-agent mcp-policy.hcl

path "mcp/data/jenkins"    { capabilities = ["read"] }
path "mcp/data/vault-access" { capabilities = ["read"] }
path "mcp/data/ssh"        { capabilities = ["read"] }
path "mcp/data/ssh-key"    { capabilities = ["read"] }
path "mcp/data/custom"     { capabilities = ["read"] }
path "mcp/data/grafana"    { capabilities = ["read"] }
path "mcp/data/elastic"    { capabilities = ["read"] }
path "mcp/data/prometheus" { capabilities = ["read"] }

path "auth/token/renew-self"      { capabilities = ["update"] }
path "auth/token/lookup-self"     { capabilities = ["read"] }
