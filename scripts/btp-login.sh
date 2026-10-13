#!/usr/bin/env bash
set -e

# ==============================================================================
# Helper Script: SAP BTP CLI Login
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Source env.sh if available
if [ -f "$ROOT_DIR/env.sh" ]; then
  # shellcheck source=/dev/null
  source "$ROOT_DIR/env.sh"
fi

GLOBALACCOUNT="${BTP_GLOBALACCOUNT:-$1}"
USERNAME="${BTP_USERNAME:-$2}"
PASSWORD="${BTP_PASSWORD:-$3}"
CLI_URL="${BTP_CLI_SERVER_URL:-https://cli.btp.cloud.sap}"

if [ -z "$GLOBALACCOUNT" ]; then
  echo "Error: Global account subdomain is not set."
  echo "Please set BTP_GLOBALACCOUNT in env.sh or pass it as the first argument."
  echo "Usage: $0 [globalaccount_subdomain] [username] [password]"
  exit 1
fi

echo "Logging in to SAP BTP CLI..."
echo "  Server:        $CLI_URL"
echo "  Global Account: $GLOBALACCOUNT"

LOGIN_CMD=(btp login --url "$CLI_URL" --subdomain "$GLOBALACCOUNT")

if [ -n "$USERNAME" ]; then
  LOGIN_CMD+=(--user "$USERNAME")
fi

if [ -n "$PASSWORD" ]; then
  LOGIN_CMD+=(--password "$PASSWORD")
fi

if [ -n "$BTP_IDP" ]; then
  LOGIN_CMD+=(--idp "$BTP_IDP")
fi

"${LOGIN_CMD[@]}"

echo ""
echo "=== Current Target Context ==="
btp target
