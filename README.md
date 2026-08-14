# Signal

Solve harder problems with fewer tokens.

## Skills

- [Signal](signal/SKILL.md) — reduce a problem to its load-bearing unknown,
  run the cheapest decisive check, make the smallest sufficient change, verify,
  and stop.

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

Useful flags: `--local`, `--targets <agents>`, `--skills signal`,
`--force`, and `--dry-run`. See [install.sh](install.sh) and
[install.ps1](install.ps1).

Supported targets include OpenCode, Claude Code, Codex, Cursor, Copilot,
Antigravity, and Pi. Pi uses the shared Agent Skills locations
`~/.agents/skills` for user skills and `.agents/skills` for project skills.

## Signal fragments

Load only the fragment needed:

- [Channel](signal/fragments/channel.md) — signal, noise, and redundancy
- [Epistemology](signal/fragments/epistemology.md) — claims and falsification
- [Verification](signal/fragments/verification.md) — precision and measurement
- [Recovery](signal/fragments/recovery.md) — trust and reversibility
- [Modes](signal/fragments/modes.md) — protocol details

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
