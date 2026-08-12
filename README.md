# Agent skills for efficiency and efficacy

This repository contains small, composable skills for better agent work.

- **Signal** improves efficacy: reduce uncertainty, gather decision-changing
  evidence, act within bounds, verify, and recover when possible.
- **Clarity** improves communication: use clear, compact English without hiding
  conditions, uncertainty, safety detail, or ownership.

## Efficiency and efficacy

Efficiency is not merely fewer tokens. It is less wasted work, smaller change
surface, faster feedback, and lower cognitive load.

Efficacy is not merely activity. It is solving the right problem with evidence,
clear communication, bounded authority, verification, and honest limits.

Use the skills together when useful:

`Signal → Clarity`

Question the work, reduce uncertainty, communicate the result clearly, then
compress only where meaning remains safe. Skip any skill that does not help.

## Install

One line, agent-agnostic (opencode, claude-code, codex, cursor, copilot,
antigravity; user or project scope):

```bash
# macOS / Linux / WSL
curl -fsSL https://raw.githubusercontent.com/darvh/signal/main/install.sh | bash

# Windows
irm https://raw.githubusercontent.com/darvh/signal/main/install.ps1 | iex
```

Flags: `--local` (project scope), `--targets <agents>`, `--skills <signal|clarity|both>` (default both), `--force`, `--dry-run`.
Installs both skills by default; slash commands are added where supported (opencode, claude-code).
Installs are symlinks; edits in this repo apply live. Restart your agent.

## Principles

The skills use portable principles such as YAGNI, DRY, KISS, POLA, least
privilege, idempotence, fail-fast behavior, separation of concerns, reversibility,
and feedback. They are heuristics, not excuses to remove safety, accessibility,
validation, privacy, recovery, or explicit requirements.

## Acknowledgements

Inspired by Claude Shannon, Norbert Wiener, W. Ross Ashby, Karl Popper, W.
Edwards Deming, Aristotle, Socrates, William of Ockham, George Orwell, William
Strunk and E. B. White, Rudolf Flesch, and Caveman and Ponytail skills.
