#!/usr/bin/env bash
set -e

# ==============================================================================
# Helper Script: Inspect SAP BTP Account Status & Subaccounts
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

if [ -f "$ROOT_DIR/env.sh" ]; then
  # shellcheck source=/dev/null
  source "$ROOT_DIR/env.sh"
fi

echo "=================================================="
echo "          SAP BTP Target Context                  "
echo "=================================================="
btp target || echo "Not logged in or target not set yet. Run scripts/btp-login.sh first."

echo ""
echo "=================================================="
echo "          Subaccounts List                        "
echo "=================================================="
btp list accounts/subaccount --format json 2>/dev/null | jq -r '.[] | "Subaccount: \(.displayName) | ID: \(.guid) | Subdomain: \(.subdomain) | Region: \(.region) | State: \(.state)"' || btp list accounts/subaccount || true

echo ""
echo "=================================================="
echo "          Available Environments                  "
echo "=================================================="
btp list accounts/environment-instance || true
