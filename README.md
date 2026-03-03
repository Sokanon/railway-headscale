# Headscale

One-click deploy of [Headscale](https://github.com/juanfont/headscale) on Railway — a self-hosted, open-source implementation of the Tailscale control server.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/template/TEMPLATE_CODE)

## What is Headscale?

Headscale is an open-source implementation of the Tailscale control server. It lets you run your own WireGuard-based mesh VPN without relying on Tailscale's hosted infrastructure. Your devices still use the standard Tailscale client, but connect through your Headscale server instead.

## Features

- Self-hosted Tailscale control plane
- WireGuard-based encrypted mesh networking
- MagicDNS for automatic device name resolution
- Taildrop for file sharing between nodes
- ACL policy support for access control
- SQLite database (zero external dependencies)
- OIDC authentication support

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `HEADSCALE_SERVER_URL` | Public URL for the Headscale server. Auto-detected from `RAILWAY_PUBLIC_DOMAIN` if not set. | Auto-detected |
| `HEADSCALE_BASE_DOMAIN` | Base domain for MagicDNS | `headscale.net` |
| `HEADSCALE_LOG_LEVEL` | Log level (`trace`, `debug`, `info`, `warn`, `error`) | `info` |
| `HEADSCALE_MAGIC_DNS` | Enable MagicDNS (`true`/`false`) | `true` |
| `HEADSCALE_DERP_SERVER_ENABLED` | Enable built-in DERP relay server | `false` |

## Volume

A volume is mounted at `/var/lib/headscale` to persist:
- SQLite database (`db.sqlite`)
- Noise protocol private key (`noise_private.key`)
- DERP server private key (if enabled)

## Post-Deployment

### 1. Generate a public domain

Ensure Railway has generated a public domain for the service. The entrypoint automatically configures `server_url` from `RAILWAY_PUBLIC_DOMAIN`.

### 2. Create a user

Access the service via `railway ssh` or the Railway shell:

```bash
headscale users create myuser
```

### 3. Generate an auth key

```bash
headscale preauthkeys create --user myuser --reusable --expiration 24h
```

### 4. Connect a client

On your device, install the Tailscale client and connect:

```bash
tailscale up --login-server https://YOUR_RAILWAY_DOMAIN --authkey YOUR_AUTH_KEY
```

### 5. Manage nodes

```bash
headscale nodes list
headscale nodes register --user myuser --key mkey:...
```

## Notes

- Headscale listens on port **8080** (HTTP API) and **9090** (metrics)
- Railway handles TLS termination — Headscale runs plain HTTP behind Railway's proxy
- The Tailscale DERP relay network is used by default for NAT traversal
- For OIDC authentication, set the OIDC configuration via environment variables or modify the config directly
- [Official documentation](https://headscale.net/)
- [Source repository](https://github.com/juanfont/headscale)
