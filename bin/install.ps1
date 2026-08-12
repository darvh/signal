# Signal + Plain installer — Windows shim (iex one-liner: irm <url> | iex).
# Thin wrapper around bin/install.js (the single Node source of truth).
$ErrorActionPreference = "Stop"

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
  Write-Error "signal: Node.js (>=18) required. Install: https://nodejs.org"
  exit 1
}
$major = [int](node -p "process.versions.node.split('.')[0]")
if ($major -lt 18) { Write-Error "signal: Node too old (need >=18)."; exit 1 }

$here = $PSScriptRoot
if (Test-Path "$here\bin\install.js") {
  & node "$here\bin\install.js" @args
  exit $LASTEXITCODE
}

# iex path: acquire from the distribution repo into a temp dir.
$tmp = Join-Path $env:TEMP "signal-install"
if (Test-Path $tmp) { Remove-Item -Recurse -Force $tmp }
& git clone --depth 1 https://github.com/darvh/signal.git $tmp
& node "$tmp\bin\install.js" @args
exit $LASTEXITCODE
