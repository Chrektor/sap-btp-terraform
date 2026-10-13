#!/usr/bin/env bash
set -e

# ==============================================================================
# Helper Script: Run Terraform with BTP Environment
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TF_DIR="$ROOT_DIR/terraform"

if [ -f "$ROOT_DIR/env.sh" ]; then
  # shellcheck source=/dev/null
  source "$ROOT_DIR/env.sh"
fi

if [ -n "$BTP_GLOBALACCOUNT" ]; then
  export TF_VAR_globalaccount="$BTP_GLOBALACCOUNT"
fi

if [ -z "$1" ]; then
  echo "Usage: $0 [plan|apply|destroy|init|validate|import|state] [additional flags...]"
  exit 1
fi

CMD="$1"
shift

terraform -chdir="$TF_DIR" "$CMD" "$@"
