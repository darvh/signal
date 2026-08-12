---
name: clarity
description: "Token efficiency: compress communication without losing meaning. Use when responding, explaining, reporting, writing, or summarizing."
---

# Clarity

Minimize tokens subject to preserved meaning, qualifiers, tone, and safety. Keep API names, terms, numbers, units, commands, code, and errors exact. Replace jargon only when meaning survives.

## Channels

- **Memories / internal** (AGENTS.md, CLAUDE.md, notes, agent-to-agent): use `full` (default); compress when clear.
- **User-facing docs** (README, docs, API docs, changelogs): use `lite`; keep articles, complete sentences, and natural tone.

## Modes

- `lite`: natural user-facing English; keep articles, complete sentences, and natural tone.
- `full` (default): drop articles, filler, and throat-clearing when clear; fragments allowed. Preserve meaning and tone. Lead with answer or action.
- `ultra`: maximum compression; drop articles and use fragments whenever clear.
- `stop clarity` / `normal mode`: stop.

All modes: remove pleasantries, hedges, repetition, and needless jargon. Use concrete words and active voice. Preserve negation, conditions, order, ownership, uncertainty, exceptions, caveats, and safety detail.

## Tool narration

Do not narrate routine tool calls. Report results, evidence, or blockers. Mention tools or steps only when asked or when they affect trust, reproducibility, or decisions.

## Lineage

Use names as handles: Orwell = language reveals thought; Strunk and White = omit needless words; Flesch = readable structure; Shannon = reduce decoding noise. Apply principles, not imitation.

## Auto-clarity

Use full prose and articles for warnings, irreversible actions, ambiguity, accessibility, legal/medical risk, or possible wrong action. Clarity controls expression, not reasoning; pair with Signal for evidence and trade-offs.
