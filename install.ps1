# Signal skill installer — self-contained, agent-agnostic.
# No dependencies (no node). Windows.
#
#   irm https://raw.githubusercontent.com/darvh/signal/main/install.ps1 | iex
#   powershell -File install.ps1 [-Local] [-Targets a,b] [-Skills signal]
#                                 [-Ref <git-ref>] [-Create] [-Force] [-NoForce]
#                                 [-DryRun] [-Uninstall] [-Help]
#
# Mirrors install.sh: same agents, same flags, same behavior. Flags accept
# -Local, --local and -local (PowerShell + shell styles).
$ErrorActionPreference = "Stop"

$SKILLS = @("signal")

# name | userSkills | projectSkills | userCmds | projectCmds | probes
$Targets = @(
  @{ Name = "opencode";    UserSkills = "$HOME\.config\opencode\skills"; ProjectSkills = ".opencode\skills"; UserCmds = "$HOME\.config\opencode\commands"; ProjectCmds = ".opencode\commands"; Probes = @("$HOME\.config\opencode") },
  @{ Name = "claude-code"; UserSkills = "$HOME\.claude\skills";          ProjectSkills = ".claude\skills";    UserCmds = "$HOME\.claude\commands";          ProjectCmds = ".claude\commands";    Probes = @("$HOME\.claude") },
  @{ Name = "codex";       UserSkills = "$HOME\.codex\skills";           ProjectSkills = ".codex\skills";     UserCmds = $null; ProjectCmds = $null; Probes = @("$HOME\.codex") },
  @{ Name = "cursor";      UserSkills = "$HOME\.cursor\skills";          ProjectSkills = ".cursor\skills";    UserCmds = $null; ProjectCmds = $null; Probes = @("$HOME\.cursor") },
  @{ Name = "copilot";     UserSkills = "$HOME\.copilot\skills";         ProjectSkills = ".agents\skills";    UserCmds = $null; ProjectCmds = $null; Probes = @("$HOME\.config\github-copilot", "$HOME\.vscode") },
  @{ Name = "antigravity"; UserSkills = "$HOME\.agents\skills";          ProjectSkills = ".agents\skills";    UserCmds = $null; ProjectCmds = $null; Probes = @("$HOME\.antigravity") },
  @{ Name = "pi";          UserSkills = "$HOME\.agents\skills";          ProjectSkills = ".agents\skills";    UserCmds = $null; ProjectCmds = $null; Probes = @("$HOME\.pi") }
)

function Show-Usage {
  @"
signal install.ps1

Installs the Signal agent skill (and slash command where the host supports it).

USAGE:
    install.ps1 [OPTIONS]

OPTIONS:
    -Local                Install into the current project (or $env:SIGNAL_PROJECT_ROOT)
    -Targets <agents>     Comma-separated agents (default: all)
    -Skills signal        Skill to install (only: signal)
    -Ref <git-ref>        Clone/pin a tag or branch instead of main
    -Create               Create absent home-scope agent dirs (default: report only)
    -Force / -NoForce     Overwrite a non-link at the destination
    -DryRun               Print the plan, install nothing
    -Uninstall            Remove installed skill links and slash commands
    -Help                 Show this help

ENVIRONMENT:
    SIGNAL_PROJECT_ROOT   Project scope root for -Local
    SIGNAL_REF            Same as -Ref
"@
}

$mode = "global"
$projectRoot = if ($env:SIGNAL_PROJECT_ROOT) { $env:SIGNAL_PROJECT_ROOT } else { (Get-Location).Path }
$only = @(); $pick = @(); $force = $false; $dry = $false; $create = $false; $ref = ""; $uninstall = $false
for ($i = 0; $i -lt $args.Count; $i++) {
  $flag = ($args[$i] -replace "^[-]+", "").ToLower()
  if ($flag -like "targets=*") { $only = $flag.Substring(8) -split "," | ForEach-Object { $_.Trim() }; continue }
  if ($flag -like "skills=*") {
    $skill = $flag.Substring(7).Trim()
    if ($skill -ne "signal") { Write-Error "unknown skill: $skill (use: signal)"; exit 2 }
    $pick = @("signal"); continue
  }
  if ($flag -like "ref=*") { $ref = $flag.Substring(4).Trim(); continue }
  switch ($flag) {
    "local" { $mode = "local" }
    "targets" { $only = $args[++$i] -split "," | ForEach-Object { $_.Trim() } }
    "skills" {
      $v = $args[++$i].Trim()
      if ($v -eq "signal") { $pick = @("signal") }
      else { Write-Error "unknown skill: $v (use: signal)"; exit 2 }
    }
    "ref" { $ref = $args[++$i].Trim() }
    "create" { $create = $true }
    "force" { $force = $true }
    "dry-run" { $dry = $true }
    "uninstall" { $uninstall = $true }
    "h" { Show-Usage; exit 0 }
    "help" { Show-Usage; exit 0 }
    default { Write-Error "unknown option: $($args[$i])"; exit 2 }
  }
}
if ($pick.Count -eq 0) { $pick = $SKILLS }
if (-not $ref) { $ref = $env:SIGNAL_REF }

# Local checkout (PSScriptRoot set) or iex path: acquire from the repo.
$here = $PSScriptRoot
if (-not $here -or -not (Test-Path "$here\skills\signal\SKILL.md")) {
  $cacheRoot = if ($env:XDG_CACHE_HOME) { $env:XDG_CACHE_HOME } else { Join-Path $HOME ".cache" }
  $cacheRoot = Join-Path $cacheRoot "signal"
  New-Item -ItemType Directory -Force -Path $cacheRoot | Out-Null
  $tmp = Join-Path $env:TEMP ("signal-install-" + [guid]::NewGuid().ToString("N"))
  $cloneArgs = @("clone", "--depth", "1")
  if ($ref) { $cloneArgs += @("--branch", $ref) }
  $cloneArgs += @("https://github.com/darvh/signal.git", $tmp)
  & git @cloneArgs
  if ($LASTEXITCODE -ne 0) { Write-Error "signal: clone failed"; exit 1 }
  $revision = (& git -C $tmp rev-parse HEAD).Trim()
  if (-not $revision) { Write-Error "signal: cannot read cloned revision"; exit 1 }
  $cached = Join-Path $cacheRoot $revision
  if (-not (Test-Path $cached)) { Move-Item $tmp $cached } else { Remove-Item -Recurse -Force $tmp }
  $here = $cached
}

$cmdFile = Join-Path $here "commands\signal.md"

function Test-AgentPresent {
  param($Target)
  foreach ($p in $Target.Probes) {
    if (Test-Path $p) { return $true }
    $bin = Split-Path $p -Leaf
    if (Get-Command $bin -ErrorAction SilentlyContinue) { return $true }
  }
  return $false
}

if ($uninstall) {
  Write-Host "signal uninstall (skills: $($pick -join ' '), scope: $mode$($(if ($only.Count) { ", targets: $($only -join ',') })))"
  foreach ($t in $Targets) {
    if ($only.Count -and $t.Name -notin $only) { continue }
    $dir = if ($mode -eq "local") { Join-Path $projectRoot $t.ProjectSkills } else { $t.UserSkills }
    $cdir = if ($mode -eq "local") { Join-Path $projectRoot $t.ProjectCmds } else { $t.UserCmds }
    foreach ($s in $pick) {
      $dst = Join-Path $dir $s
      $link = Get-Item $dst -ErrorAction SilentlyContinue
      if ($link -and $link.LinkType) {
        if (-not $dry) { [System.IO.Directory]::Delete($dst, $false) }
        Write-Host ("  {0,-12} {1,-8} {2,-10} {3}" -f $t.Name, $s, "removed", $dst)
      }
      if ($t.UserCmds) {
        $cdst = Join-Path $cdir "$s.md"
        if ((Test-Path $cdst) -and (Select-String -Path $cdst -Pattern "Activate Signal" -Quiet)) {
          if (-not $dry) { Remove-Item -Force $cdst }
          Write-Host ("  {0,-12} {1,-8} {2,-10} {3}" -f $t.Name, $s, "removed", $cdst)
        }
      }
    }
  }
  if ($dry) { Write-Host "signal: dry-run, nothing removed" }
  exit 0
}

Write-Host "signal install (skills: $($pick -join ' '), scope: $mode$($(if ($only.Count) { ", targets: $($only -join ',') }))$($(if ($ref) { ", ref: $ref" })))"
foreach ($t in $Targets) {
  if ($only.Count -and $t.Name -notin $only) { continue }
  if ($mode -eq "local") {
    $dir = Join-Path $here $t.ProjectSkills
    if (-not $dry) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  } else {
    $dir = $t.UserSkills
    if (-not (Test-Path $dir)) {
      if ($create -and (Test-AgentPresent $t)) {
        if (-not $dry) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
      } else {
        Write-Host ("  {0,-12} {1,-8} {2,-10} {3}" -f $t.Name, "skill", "agent-miss", $dir)
        continue
      }
    }
  }
  foreach ($s in $pick) {
    $dst = Join-Path $dir $s; $src = Join-Path $here "skills\$s"
    $st = "installed"
    $link = Get-Item $dst -ErrorAction SilentlyContinue
    if ($link -and $link.LinkType) {
      $st = if ((Get-Item $dst).Target -eq $src) { "up-to-date" } else { "conflict" }
    } elseif ($link) { $st = "conflict" }
    if ($st -eq "conflict" -and -not $force) {
      Write-Host ("  {0,-12} {1,-8} {2,-10} {3} (use -Force)" -f $t.Name, $s, "conflict", $dst)
      continue
    }
    if ($st -eq "conflict") { $st = "updated" }
    if (-not $dry) {
      if (Test-Path $dst) {
        if ($link -and $link.LinkType) { [System.IO.Directory]::Delete($dst, $false) }
        else { Remove-Item -Recurse -Force $dst }
      }
      New-Item -ItemType Junction -Path $dst -Target $src -Force | Out-Null
    }
    if ($dry -and $st -eq "installed") { $st = "installed (dry-run)" }
    Write-Host ("  {0,-12} {1,-8} {2,-10} {3}" -f $t.Name, $s, $st, $dst)
  }
  # slash commands: real only where the agent has a native mechanism
  # (opencode/claude-code commands); explicitly n/a elsewhere.
  if (-not $t.UserCmds) {
    Write-Host ("  {0,-12} {1,-8} {2,-10} {3}" -f $t.Name, "commands", "n/a", "(no native command mechanism)")
    continue
  }
  if ($t.UserCmds) {
    $cdir = if ($mode -eq "local") { Join-Path $here $t.ProjectCmds } else { $t.UserCmds }
    if (-not $dry) { New-Item -ItemType Directory -Force -Path $cdir | Out-Null }
    foreach ($s in $pick) {
      $cdst = Join-Path $cdir "$s.md"
      if (-not (Test-Path $cmdFile)) {
        Write-Host ("  {0,-12} {1,-8} {2,-10} {3}" -f $t.Name, $s, "skipped", "(missing $cmdFile)")
        continue
      }
      $template = Get-Content -Raw $cmdFile
      $existing = if (Test-Path $cdst) { Get-Content -Raw $cdst } else { $null }
      if ($dry) {
        $st2 = "command (dry-run)"
      } elseif ($existing -eq $template) {
        $st2 = "command (up-to-date)"
      } elseif ($existing -and -not $force) {
        Write-Host ("  {0,-12} {1,-8} {2,-10} {3} (use -Force)" -f $t.Name, $s, "conflict", $cdst)
        continue
      } else {
        Set-Content -Path $cdst -Value $template -NoNewline
        $st2 = "command"
      }
      Write-Host ("  {0,-12} {1,-8} {2,-10} {3}" -f $t.Name, $s, $st2, $cdst)
    }
  }
}
Write-Host "Done. Restart your agent to pick up the skills."
