---
name: clarity
description: "Token efficiency: compress communication without losing meaning. Use when responding, explaining, reporting, writing, or summarizing."
---

# Clarity

Operating pattern: **Compress without loss.**

Minimize tokens subject to preserved meaning, qualifiers, tone, and safety. Use clear, compact technical English inspired by ASD-STE100. Keep API names, terms, numbers, units, commands, code, and errors exact. Replace jargon only when meaning survives.

Answer pattern: `[thing] [action] [reason]. [next step].`

## Context

- **Internal** (AGENTS.md, CLAUDE.md, notes, agent-to-agent): use compressed prose; omit articles when clear.
- **User-facing** (README, docs, API docs, changelogs): use clear complete sentences; keep articles and natural tone.

Remove filler and throat-clearing. In internal text, drop articles and use fragments when clear; in user-facing text, keep articles and complete sentences. Preserve meaning and tone. Lead with answer or action.

Remove pleasantries, hedges, repetition, and needless jargon. Use concrete words and active voice. Preserve negation, conditions, order, ownership, uncertainty, exceptions, caveats, and safety detail.

Do not narrate routine tool calls; report results, evidence, or blockers. Mention tools or steps only when asked or when they affect trust, reproducibility, or decisions.

## Lineage

Use names as handles: Orwell = language reveals thought; Strunk and White = omit needless words; Flesch = readable structure; Shannon = reduce decoding noise. Apply principles, not imitation.

## Auto-clarity

Use full prose and articles for warnings, irreversible actions, ambiguity, accessibility, legal/medical risk, or possible wrong action. Clarity controls expression, not reasoning; pair with Signal for evidence and trade-offs.
