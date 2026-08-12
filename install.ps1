# Signal + Clarity skill installer — self-contained, agent-agnostic.
# No dependencies (no node). Windows.
#
#   irm https://raw.githubusercontent.com/darvh/signal/main/install.ps1 | iex
#   powershell -File install.ps1 [-Local] [-Targets a,b] [-Skills signal|clarity|both]
#                                 [-Force] [-DryRun]
#
# Mirrors install.sh: same agents, same flags, same behavior.
$ErrorActionPreference = "Stop"

$SKILLS = @("signal", "clarity")

$Targets = @(
  @{ Name = "opencode";     UserSkills = "$HOME\.config\opencode\skills";  ProjectSkills = ".opencode\skills";  UserCmds = "$HOME\.config\opencode\commands" },
  @{ Name = "claude-code";  UserSkills = "$HOME\.claude\skills";           ProjectSkills = ".claude\skills";     UserCmds = "$HOME\.claude\commands" },
  @{ Name = "codex";        UserSkills = "$HOME\.codex\skills";            ProjectSkills = ".codex\skills";      UserCmds = $null },
  @{ Name = "cursor";       UserSkills = "$HOME\.cursor\skills";           ProjectSkills = ".cursor\skills";     UserCmds = $null },
  @{ Name = "copilot";      UserSkills = "$HOME\.agents\skills";           ProjectSkills = ".agents\skills";     UserCmds = $null },
  @{ Name = "antigravity";  UserSkills = "$HOME\.agents\skills";           ProjectSkills = ".agents\skills";     UserCmds = $null }
)

$CmdSignal = @"
---
description: Activate the Signal skill — reduce uncertainty, gather evidence, verify.
---

Use the Signal skill before working: reduce uncertainty before acting (read the code, check assumptions); gather decision-changing evidence (run tests, probe edge inputs); act within bounds; verify your change before claiming done; recover when something fails. Never claim completion without verifying it yourself.
"@
$CmdClarity = @"
---
description: Activate the Clarity skill — compact technical English.
---

Use the Clarity skill when communicating: lead with the answer, decision, or next action; remove filler, repetition, and needless jargon; preserve negation, conditions, uncertainty, and safety detail. Compact, natural English.
"@

$mode = "global"; $only = @(); $pick = @(); $force = $false; $dry = $false
for ($i = 0; $i -lt $args.Count; $i++) {
  switch ($args[$i]) {
    "--local" { $mode = "local" }
    "--targets" { $only = $args[++$i] -split "," | ForEach-Object { $_.Trim() } }
    "--skills" {
      $v = $args[++$i].Trim()
      if ($v -in @("both", "all", "signal+clarity")) { $pick = $SKILLS }
      elseif ($v -in $SKILLS) { $pick = @($v) }
      else { Write-Error "unknown skill: $v (use one of: signal, clarity, both)"; exit 2 }
    }
    "--force" { $force = $true }
    "--dry-run" { $dry = $true }
    default { Write-Error "unknown option: $($args[$i])"; exit 2 }
  }
}
if ($pick.Count -eq 0) { $pick = $SKILLS }

# Local checkout (PSScriptRoot set) or iex path: acquire from the repo.
$here = $PSScriptRoot
if (-not $here -or -not (Test-Path "$here\signal\SKILL.md")) {
  $tmp = Join-Path $env:TEMP "signal-install"
  if (Test-Path $tmp) { Remove-Item -Recurse -Force $tmp }
  & git clone --depth 1 https://github.com/darvh/signal.git $tmp
  if ($LASTEXITCODE -ne 0) { Write-Error "signal: clone failed"; exit 1 }
  $here = $tmp
}

Write-Host "signal install (skills: $($pick -join ' '), scope: $mode$($(if ($only.Count) { ", targets: $($only -join ',')" })))"
foreach ($t in $Targets) {
  if ($only.Count -and $t.Name -notin $only) { continue }
  if ($mode -eq "local") { $dir = Join-Path $here $t.ProjectSkills; New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  else {
    $dir = $t.UserSkills
    if (-not (Test-Path $dir)) { Write-Host ("  {0,-12} {1,-8} {2,-10} {3}" -f $t.Name, "skill", "agent-miss", $dir); continue }
  }
  foreach ($s in $pick) {
    $dst = Join-Path $dir $s; $src = Join-Path $here $s
    $st = "installed"
    $link = Get-Item $dst -ErrorAction SilentlyContinue
    if ($link -and $link.LinkType) {
      if ((Get-Item $dst).Target -eq $src) { $st = "up-to-date" }
      else { $st = "conflict" }
    } elseif ($link) {
      $st = "conflict"
    }
    if ($st -eq "conflict" -and -not $force) {
      Write-Host ("  {0,-12} {1,-8} {2,-10} {3} (use --force)" -f $t.Name, $s, "conflict", $dst); continue
    }
    if ($st -eq "conflict") { $st = "updated" }
    if (-not $dry) {
      if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
      New-Item -ItemType Junction -Path $dst -Target $src -Force | Out-Null
    }
    if ($dry -and $st -eq "installed") { $st = "installed (dry-run)" }
    Write-Host ("  {0,-12} {1,-8} {2,-10} {3}" -f $t.Name, $s, $st, $dst)
  }
  if ($t.UserCmds) {
    if (-not $dry) { New-Item -ItemType Directory -Force -Path $t.UserCmds | Out-Null }
    foreach ($s in $pick) {
      $cdst = Join-Path $t.UserCmds "$s.md"
      if ((Test-Path $cdst) -and -not $force) {
        Write-Host ("  {0,-12} {1,-8} {2,-10} {3} (use --force)" -f $t.Name, $s, "conflict", $cdst); continue
      }
      if (-not $dry) { Set-Content -Path $cdst -Value (Get-Variable "Cmd$($s.Substring(0,1).ToUpper())$($s.Substring(1))" -ValueOnly) }
      Write-Host ("  {0,-12} {1,-8} {2,-10} {3}" -f $t.Name, $s, "command", $cdst)
    }
  }
}
Write-Host "Done. Restart your agent to pick up the skills."
