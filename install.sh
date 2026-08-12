#!/usr/bin/env bash
# Signal + Clarity installer shim — thin wrapper around bin/install.js (the
# single Node source of truth; one script for macOS/Linux/Windows/WSL).
#
# One-line:  curl -fsSL https://raw.githubusercontent.com/darvh/signal/main/install.sh | bash
# Local:     bash install.sh [flags]
# Flags are forwarded: --local --targets <a,b> --force --dry-run
set -euo pipefail

if ! command -v node >/dev/null 2>&1; then
  echo "signal: Node.js (>=18) required. macOS: brew install node | Linux/WSL: https://nodejs.org" >&2
  exit 1
fi
if [ "$(node -p "process.versions.node.split('.')[0]")" -lt 18 ]; then
  echo "signal: Node too old (need >=18). Upgrade: https://nodejs.org" >&2
  exit 1
fi

here=""
source_path="${BASH_SOURCE[0]:-}"
if [ -n "$source_path" ]; then
  here="$(cd "$(dirname "$source_path")" 2>/dev/null && pwd)" || here=""
fi
if [ -n "$here" ] && [ -f "$here/bin/install.js" ]; then
  exec node "$here/bin/install.js" "$@"
fi

# curl-pipe path: acquire from the distribution repo into a temp dir.
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
git clone --depth 1 https://github.com/darvh/signal.git "$tmp" >/dev/null 2>&1
exec node "$tmp/bin/install.js" "$@"
