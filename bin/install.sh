#!/usr/bin/env bash
set -euo pipefail

# Backward-compatible entry point for the Claude adapter.
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
exec bash "$SCRIPT_DIR/../adapters/claude/install.sh" "$@"
