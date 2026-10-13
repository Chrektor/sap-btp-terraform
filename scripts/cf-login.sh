#!/usr/bin/env bash
set -e

# ==============================================================================
# Helper Script: Cloud Foundry CLI Login
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

if [ -f "$ROOT_DIR/env.sh" ]; then
  # shellcheck source=/dev/null
  source "$ROOT_DIR/env.sh"
fi

CF_API_URL="${CF_API:-$1}"
USERNAME="${BTP_USERNAME:-$2}"
PASSWORD="${BTP_PASSWORD:-$3}"
ORG="${CF_ORG:-$4}"
SPACE="${CF_SPACE:-$5}"

if [ -z "$CF_API_URL" ]; then
  echo "Error: CF_API is not set."
  echo "Please set CF_API in env.sh or pass it as the first argument."
  echo "Example: https://api.cf.us10.hana.ondemand.com"
  exit 1
fi

echo "Connecting to Cloud Foundry API: $CF_API_URL..."
cf api "$CF_API_URL"

LOGIN_CMD=(cf login)

if [ -n "$USERNAME" ]; then
  LOGIN_CMD+=(-u "$USERNAME")
fi

if [ -n "$PASSWORD" ]; then
  LOGIN_CMD+=(-p "$PASSWORD")
fi

if [ -n "$ORG" ]; then
  LOGIN_CMD+=(-o "$ORG")
fi

if [ -n "$SPACE" ]; then
  LOGIN_CMD+=(-s "$SPACE")
fi

"${LOGIN_CMD[@]}"

echo ""
echo "=== Cloud Foundry Target ==="
cf target
