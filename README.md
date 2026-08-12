# Signal

Small, composable skills for more efficient and effective agent work.

## Skills

- [Signal](signal/SKILL.md) — reduce uncertainty, gather useful evidence, act
  within bounds, verify, and recover.
- [Clarity](clarity/SKILL.md) — write clear, compact English while preserving
  conditions, uncertainty, ownership, and safety detail.

Signal improves efficacy. Clarity improves communication. Together:

`Signal → Clarity`

Use either alone when that is enough. `/signal [depth] [protocol]` supports
`quick`, `standard`, and `rigorous` work plus `audit`, `debt`, `recommend`,
`brownfield`, `greenfield`, and `heal` protocols.

## Signal fragments

Load only the fragment needed:

- [Channel](signal/fragments/channel.md) — signal, noise, and redundancy
- [Epistemology](signal/fragments/epistemology.md) — claims and falsification
- [Verification](signal/fragments/verification.md) — precision and measurement
- [Recovery](signal/fragments/recovery.md) — trust and reversibility
- [Implementation](signal/fragments/implementation.md) — execution gates
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

## Install

### macOS, Linux, or WSL

```bash
curl -fsSL https://raw.githubusercontent.com/darvh/signal/main/install.sh | bash
```

### Windows

```powershell
irm https://raw.githubusercontent.com/darvh/signal/main/install.ps1 | iex
```

Useful flags: `--local`, `--targets <agents>`, `--skills <signal|clarity|both>`,
`--force`, and `--dry-run`. See [install.sh](install.sh) and
[install.ps1](install.ps1).

See [ACKNOWLEDGEMENTS.md](ACKNOWLEDGEMENTS.md) for sources and influences.
