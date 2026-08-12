#!/usr/bin/env bash
# Signal + Clarity skill installer — self-contained, agent-agnostic.
# No dependencies (no node). macOS / Linux / WSL.
#
#   curl -fsSL https://raw.githubusercontent.com/darvh/signal/main/install.sh | bash
#   bash install.sh [--local] [--targets <agents>] [--skills signal|clarity|both]
#                   [--force] [--dry-run]
#
# Runs from a checkout, or piped: the repo is cloned into a temp dir first, so
# symlinks never point at the caller's directory. User scope: absent agent
# dirs are reported (agent-miss), never created. Project scope (--local):
# skills and slash commands go into the project dirs. Installs are symlinks.
set -euo pipefail

# Locate the distribution: a real checkout (via $0) or pipe/remote (clone).
HERE=""
source_path="${BASH_SOURCE[0]:-}"
if [ -n "$source_path" ]; then
  HERE="$(cd "$(dirname "$source_path")" 2>/dev/null && pwd)" || HERE=""
fi
if [ -z "$HERE" ] || [ ! -d "$HERE/signal" ] || [ ! -f "$HERE/install.sh" ]; then
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  git clone --depth 1 https://github.com/darvh/signal.git "$tmp/signal" >/dev/null 2>&1 || { echo "signal: clone failed (need git)" >&2; exit 1; }
  HERE="$tmp/signal"
fi

SKILLS=(signal clarity)

# agent|userSkills|projectSkills|userCommands|projectCommands
targets="opencode|~/.config/opencode/skills|.opencode/skills|~/.config/opencode/commands|.opencode/commands
claude-code|~/.claude/skills|.claude/skills|~/.claude/commands|.claude/commands
codex|~/.codex/skills|.codex/skills||
cursor|~/.cursor/skills|.cursor/skills||
copilot|~/.agents/skills|.agents/skills||
antigravity|~/.agents/skills|.agents/skills||"

mode=global
only=()
pick=()
force=0
dry=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --local) mode=local ;;
    --targets) IFS=',' read -r -a only <<< "$2"; shift ;;
    --skills)
      case "$2" in
        both|all|signal+clarity) pick=("${SKILLS[@]}") ;;
        signal|clarity) pick=("$2") ;;
        *) echo "unknown skill: $2 (use one of: signal, clarity, both)" >&2; exit 2 ;;
      esac
      shift ;;
    --force) force=1 ;;
    --dry-run) dry=1 ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
  shift
done
(( ${#pick[@]} )) || pick=("${SKILLS[@]}")

cmd_content_signal='---
description: Activate the Signal skill — reduce uncertainty, gather evidence, verify.
---

Use the Signal skill before working: reduce uncertainty before acting (read the code, check assumptions); gather decision-changing evidence (run tests, probe edge inputs); act within bounds; verify your change before claiming done; recover when something fails. Never claim completion without verifying it yourself.'
cmd_content_clarity='---
description: Activate the Clarity skill — compact technical English.
---

Use the Clarity skill when communicating: lead with the answer, decision, or next action; remove filler, repetition, and needless jargon; preserve negation, conditions, uncertainty, and safety detail. Compact, natural English.'

echo "signal install (skills: ${pick[*]}, scope: $mode${only[*]:+, targets: ${only[*]}})"
while IFS='|' read -r name user_skills proj_skills user_cmds proj_cmds; do
  [[ -n "$name" ]] || continue
  if ((${#only[@]})) && ! printf '%s\n' "${only[@]}" | grep -qx "$name"; then continue; fi
  if [[ $mode == local ]]; then
    dir="$HERE/$proj_skills"
    ((!dry)) && mkdir -p "$dir"
  else
    dir="${user_skills/#\~/$HOME}"
    if [[ ! -d "$dir" ]]; then
      printf '  %-12s %-8s %-10s %s\n' "$name" skill agent-miss "$dir"
      continue
    fi
  fi
  for s in "${pick[@]}"; do
    dst="$dir/$s"; src="$HERE/$s"
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
  if [[ -n "$user_cmds" ]]; then
    cdir="${user_cmds/#\~/$HOME}"
    [[ $mode == local ]] && cdir="$HERE/$proj_cmds"
    ((!dry)) && mkdir -p "$cdir"
    for s in "${pick[@]}"; do
      cdst="$cdir/$s.md"
      if [[ -e "$cdst" && $force == 0 ]]; then
        printf '  %-12s %-8s %-10s %s (use --force)\n' "$name" "$s" conflict "$cdst"
        continue
      fi
      if ((dry)); then st2="command (dry-run)"; else
        printf '%s\n' "$(eval "echo \"\$cmd_content_$s\"")" > "$cdst"
        st2="command"
      fi
      printf '  %-12s %-8s %-10s %s\n' "$name" "$s" "$st2" "$cdst"
    done
  fi
done <<< "$targets"
echo "Done. Restart your agent to pick up the skills."
