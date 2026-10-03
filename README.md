# Signal

Solve harder problems with fewer tokens.

[![CI](https://img.shields.io/github/actions/workflow/status/darvh/signal/ci.yml?branch=main&label=CI)](https://github.com/darvh/signal/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

Signal is an agent skill for coding agents — OpenCode, Claude Code, Codex, Cursor, Copilot, Antigravity, and Pi. It reduces a problem to its load-bearing unknown, runs the cheapest decisive check, makes the smallest sufficient change, verifies, and stops.

## Quickstart

macOS, Linux, or WSL:

```bash
curl -fsSL https://raw.githubusercontent.com/darvh/signal/main/install.sh | bash
```

Windows:

```powershell
irm https://raw.githubusercontent.com/darvh/signal/main/install.ps1 | iex
```

Then use it in your agent — OpenCode and Claude Code get a slash command, all targets get the skill:

```text
/signal quick
```

## Skills

| Skill | Contents | What it does |
|---|---|---|
| [signal](skills/signal/SKILL.md) | `SKILL.md` | Reduce a problem to its load-bearing unknown, run the cheapest decisive check, make the smallest sufficient change, verify, and stop. |
| fragments | `fragments/*.md` | channel, epistemology, verification, recovery, modes — loaded only as needed. |

Signal optimizes the whole solve loop, not only the final response. `/signal [depth] [protocol]` supports
`quick`, `standard`, and `rigorous` work plus `audit`, `debt`, `recommend`,
`brownfield`, `greenfield`, and `heal` protocols.

## Install

### macOS, Linux, or WSL

```bash
curl -fsSL https://raw.githubusercontent.com/darvh/signal/main/install.sh | bash
```

### Windows

```powershell
irm https://raw.githubusercontent.com/darvh/signal/main/install.ps1 | iex
```

Useful flags: `--local`, `--targets <agents>`, `--skills signal`, `--ref <tag>`,
`--create`, `--force`/`--no-force`, `--dry-run`, and `--uninstall`. `--local` writes
under the caller's current project (or `SIGNAL_PROJECT_ROOT`); piped installs keep
their checkout in a revisioned cache so links remain valid after the installer
exits. By default an absent home-scope agent dir is reported (`agent-miss`) and
never created; `--create` materializes it only for agents actually present on the
machine. Slash commands are installed for OpenCode and Claude Code (from
`commands/signal.md`). The skill also follows the `skills/<name>/SKILL.md`
convention, so it is discoverable by `gh skill install darvh/signal`. See
[install.sh](install.sh) and [install.ps1](install.ps1).

Supported targets include OpenCode, Claude Code, Codex, Cursor, Copilot,
Antigravity, and Pi. Copilot user scope is `~/.copilot/skills` (matching
`gh skill install --agent github-copilot`) with project scope `.agents/skills`;
Antigravity and Pi use the shared `~/.agents/skills` / `.agents/skills`
locations; host-specific directories are used where the host defines them.

## Signal fragments

Load only the fragment needed:

- [Channel](skills/signal/fragments/channel.md) — signal, noise, and redundancy
- [Epistemology](skills/signal/fragments/epistemology.md) — claims and falsification
- [Verification](skills/signal/fragments/verification.md) — precision and measurement
- [Recovery](skills/signal/fragments/recovery.md) — trust and reversibility
- [Modes](skills/signal/fragments/modes.md) — protocol details

## Efficiency and efficacy

Efficiency means less wasted work, smaller change surface, faster feedback,
lower token use, and lower cognitive load.

Efficacy means solving the right problem with evidence, clear communication,
bounded authority, verification, and honest limits.

Do not optimize one at the expense of the other. Measure both:

- Efficiency: tokens, actions, elapsed time, files changed, retries, and
  unnecessary work avoided.
- Efficacy: decision quality, evidence strength, correctness, regression rate,
  recovery quality, and unresolved risk.

No benchmark suite is included yet. Do not claim gains without a baseline;
record task, baseline, intervention, result, and limits when benchmarking.

## Principles

Portable tests include YAGNI, DRY, KISS, POLA, least privilege, idempotence,
fail-fast behavior, separation of concerns, reversibility, and feedback. They
are heuristics, not excuses to remove safety, accessibility, validation,
privacy, recovery, or explicit requirements.

See [ACKNOWLEDGEMENTS.md](ACKNOWLEDGEMENTS.md) for sources and influences.
