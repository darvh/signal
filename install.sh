#!/usr/bin/env bash
# Signal skill installer — self-contained, agent-agnostic.
# No dependencies (no node). macOS / Linux / WSL.
#
#   curl -fsSL https://raw.githubusercontent.com/darvh/signal/main/install.sh | bash
#   bash install.sh [--local] [--targets <agents>] [--skills signal]
#                   [--force|--no-force] [--dry-run] [--create]
#                   [--ref <git-ref>] [--uninstall] [--help]
#
# Runs from a checkout, or piped: the repo is cloned into a revisioned user
# cache so installed symlinks survive the installer process. User scope: absent
# agent dirs are reported (agent-miss), never created unless --create. Project
# scope (--local): skills and slash commands go into the project dirs. Installs
# are symlinks; slash commands are written from commands/<skill>.md.
set -euo pipefail

# Locate the distribution: a real checkout (via $0) or pipe/remote (clone).
HERE=""
source_path="${BASH_SOURCE[0]:-}"
if [ -n "$source_path" ]; then
  HERE="$(cd "$(dirname "$source_path")" 2>/dev/null && pwd)" || HERE=""
fi

SKILLS=(signal)

# agent|userSkills|projectSkills|userCommands|projectCommands|probes
targets="opencode|~/.config/opencode/skills|.opencode/skills|~/.config/opencode/commands|.opencode/commands|~/.config/opencode
claude-code|~/.claude/skills|.claude/skills|~/.claude/commands|.claude/commands|~/.claude
codex|~/.codex/skills|.codex/skills|||~/.codex
cursor|~/.cursor/skills|.cursor/skills|||~/.cursor
copilot|~/.copilot/skills|.agents/skills|||~/.config/github-copilot ~/.vscode
antigravity|~/.agents/skills|.agents/skills|||~/.antigravity
pi|~/.agents/skills|.agents/skills|||~/.pi"

mode=global
only=()
pick=()
force=0
dry=0
create=0
ref=""
uninstall=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --local) mode=local ;;
    --targets) IFS=',' read -r -a only <<< "$2"; shift ;;
    --skills)
      case "$2" in
        signal) pick=(signal) ;;
        *) echo "unknown skill: $2 (use: signal)" >&2; exit 2 ;;
      esac
      shift ;;
    --skills=*)
      case "${1#--skills=}" in
        signal) pick=(signal) ;;
        *) echo "unknown skill: ${1#--skills=} (use: signal)" >&2; exit 2 ;;
      esac ;;
    --ref) ref="${2:-}"; shift ;;
    --ref=*) ref="${1#--ref=}" ;;
    --create) create=1 ;;
    --force) force=1 ;;
    --dry-run) dry=1 ;;
    --uninstall) uninstall=1 ;;
    -h|--help)
      cat <<'EOF'
signal install.sh

Installs the Signal agent skill (and slash command where the host supports it).

USAGE:
    install.sh [OPTIONS]

OPTIONS:
    --local                Install into the current project (or $SIGNAL_PROJECT_ROOT)
    --targets <agents>     Comma-separated agents (default: all)
    --skills signal        Skill to install (only: signal)
    --ref <git-ref>        Clone/pin a tag or branch instead of main
    --create               Create absent home-scope agent dirs (default: report only)
    --force / --no-force   Overwrite a non-symlink at the destination
    --dry-run              Print the plan, install nothing
    --uninstall            Remove installed skill links and slash commands
    -h, --help             Show this help

ENVIRONMENT:
    SIGNAL_PROJECT_ROOT    Project scope root for --local
    SIGNAL_REF             Same as --ref
EOF
      exit 0
      ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
  shift
done
(( ${#pick[@]} )) || pick=("${SKILLS[@]}")
ref="${ref:-${SIGNAL_REF:-}}"

expand_home() { printf '%s' "${1/#\~/$HOME}"; }

# True when any probe dir (or its binary) exists, so --create only creates
# skill dirs for agents that are actually installed.
agent_present() {
  local probes="$1" p bin
  for p in $probes; do
    p="$(expand_home "$p")"
    [[ -d "$p" ]] && return 0
    bin="$(basename "$p")"
    command -v "$bin" >/dev/null 2>&1 && return 0
  done
  return 1
}

acquire() {
  if [ -n "$HERE" ] && [ -d "$HERE/skills/signal" ] && [ -f "$HERE/install.sh" ]; then return; fi
  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "$tmp_dir"' EXIT
  local cache_root="${XDG_CACHE_HOME:-$HOME/.cache}/signal"
  mkdir -p "$cache_root"
  local clone_args=(clone --depth 1)
  [[ -n "$ref" ]] && clone_args+=(--branch "$ref")
  git "${clone_args[@]}" https://github.com/darvh/signal.git "$tmp_dir/signal" >/dev/null 2>&1 || { echo "signal: clone failed (need git)" >&2; exit 1; }
  local revision
  revision="$(git -C "$tmp_dir/signal" rev-parse HEAD 2>/dev/null)" || { echo "signal: cannot read cloned revision" >&2; exit 1; }
  local cached="$cache_root/$revision"
  if [[ ! -d "$cached" ]]; then
    mv "$tmp_dir/signal" "$cached"
  fi
  HERE="$cached"
}
tmp_dir=""
acquire

cmd_file="$HERE/commands/signal.md"

do_uninstall() {
  echo "signal uninstall (skills: ${pick[*]}, scope: $mode${only[*]:+, targets: ${only[*]}})"
  while IFS='|' read -r name user_skills proj_skills user_cmds proj_cmds _probes; do
    [[ -n "$name" ]] || continue
    if ((${#only[@]})) && ! printf '%s\n' "${only[@]}" | grep -qx "$name"; then continue; fi
    local dir cdir
    if [[ $mode == local ]]; then
      dir="$project_root/$proj_skills"; cdir="$project_root/$proj_cmds"
    else
      dir="$(expand_home "$user_skills")"; cdir="$(expand_home "$user_cmds")"
    fi
    for s in "${pick[@]}"; do
      local dst="$dir/$s"
      if [[ -L "$dst" ]]; then
        ((!dry)) && rm -f "$dst"
        printf '  %-12s %-8s %-10s %s\n' "$name" "$s" "removed" "$dst"
      fi
      if [[ -n "$user_cmds" && -f "$cdir/$s.md" ]] && grep -q 'Activate Signal' "$cdir/$s.md" 2>/dev/null; then
        ((!dry)) && rm -f "$cdir/$s.md"
        printf '  %-12s %-8s %-10s %s\n' "$name" "$s" "removed" "$cdir/$s.md"
      fi
    done
  done <<< "$targets"
  ((dry)) && echo "signal: dry-run, nothing removed"
  exit 0
}
((uninstall)) && do_uninstall

echo "signal install (skills: ${pick[*]}, scope: $mode${only[*]:+, targets: ${only[*]}}${ref:+, ref: $ref})"
while IFS='|' read -r name user_skills proj_skills user_cmds proj_cmds probes; do
  [[ -n "$name" ]] || continue
  if ((${#only[@]})) && ! printf '%s\n' "${only[@]}" | grep -qx "$name"; then continue; fi
  if [[ $mode == local ]]; then
    dir="$HERE/$proj_skills"
    ((!dry)) && mkdir -p "$dir"
  else
    dir="$(expand_home "$user_skills")"
    if [[ ! -d "$dir" ]]; then
      # --create only materializes dirs for agents that are present on the box
      if ((create)) && agent_present "$probes"; then
        ((!dry)) && mkdir -p "$dir"
      else
        printf '  %-12s %-8s %-10s %s\n' "$name" skill agent-miss "$dir"
        continue
      fi
    fi
  fi
  for s in "${pick[@]}"; do
    dst="$dir/$s"; src="$HERE/skills/$s"
    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
      st="up-to-date"
    elif [[ -e "$dst" && ! -L "$dst" ]]; then
      if ((!force)); then
        printf '  %-12s %-8s %-10s %s (use --force)\n' "$name" "$s" conflict "$dst"
        continue
      fi
      st="updated"
    else
      st="installed"
    fi
    if ((!dry)) && [[ $st != up-to-date ]]; then
      [[ $st == updated ]] && rm -rf "$dst"
      ln -sfn "$src" "$dst"
    fi
    ((dry)) && [[ $st == installed ]] && st="installed (dry-run)"
    printf '  %-12s %-8s %-10s %s\n' "$name" "$s" "$st" "$dst"
  done
  if [[ -z "$user_cmds" ]]; then
    printf '  %-12s %-8s %-10s %s\n' "$name" commands "n/a" "(no native command mechanism)"
    continue
  fi
  cdir="$(expand_home "$user_cmds")"
  [[ $mode == local ]] && cdir="$project_root/$proj_cmds"
  ((!dry)) && mkdir -p "$cdir"
  for s in "${pick[@]}"; do
    cdst="$cdir/$s.md"
    if ((dry)); then
      st2="command (dry-run)"
    elif [[ -f "$cmd_file" ]] && cmp -s "$cmd_file" "$cdst"; then
      st2="command (up-to-date)"
    elif [[ -e "$cdst" && $force == 0 ]]; then
      printf '  %-12s %-8s %-10s %s (use --force)\n' "$name" "$s" conflict "$cdst"
      continue
    elif [[ -f "$cmd_file" ]]; then
      cp "$cmd_file" "$cdst"
      st2="command"
    else
      printf '  %-12s %-8s %-10s %s\n' "$name" "$s" "skipped" "(missing $cmd_file)"
      continue
    fi
    printf '  %-12s %-8s %-10s %s\n' "$name" "$s" "$st2" "$cdst"
  done
done <<< "$targets"
echo "Done. Restart your agent to pick up the skills."
