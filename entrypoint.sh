#!/bin/sh
set -e

CONFIG_FILE="/etc/headscale/config.yaml"
DATA_DIR="/var/lib/headscale"
RUN_DIR="/var/run/headscale"

# Ensure data and run directories exist
mkdir -p "$DATA_DIR" "$RUN_DIR"

# Build server_url from RAILWAY_PUBLIC_DOMAIN if not explicitly set
if [ -z "$HEADSCALE_SERVER_URL" ] && [ -n "$RAILWAY_PUBLIC_DOMAIN" ]; then
  HEADSCALE_SERVER_URL="https://${RAILWAY_PUBLIC_DOMAIN}"
fi

# Default base domain for MagicDNS
HEADSCALE_BASE_DOMAIN="${HEADSCALE_BASE_DOMAIN:-headscale.net}"

# Substitute placeholders in config
sed -i "s|HEADSCALE_SERVER_URL|${HEADSCALE_SERVER_URL}|g" "$CONFIG_FILE"
sed -i "s|HEADSCALE_BASE_DOMAIN|${HEADSCALE_BASE_DOMAIN}|g" "$CONFIG_FILE"

# Apply optional overrides
if [ -n "$HEADSCALE_LOG_LEVEL" ]; then
  sed -i "s|level: info|level: ${HEADSCALE_LOG_LEVEL}|g" "$CONFIG_FILE"
fi

if [ "$HEADSCALE_MAGIC_DNS" = "false" ]; then
  sed -i "s|magic_dns: true|magic_dns: false|g" "$CONFIG_FILE"
fi

if [ "$HEADSCALE_DERP_SERVER_ENABLED" = "true" ]; then
  sed -i "/derp:/,/region_id:/{s|enabled: false|enabled: true|}" "$CONFIG_FILE"
fi

exec headscale "$@"
