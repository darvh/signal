---
name: signal
description: "Agent efficacy with efficiency: reduce uncertainty, gather evidence, take bounded action, verify outcomes. Use when implementing, fixing bugs, debugging, or making changes where correctness matters."
---

# Signal

## Operate

1. Check preconditions (scope, access, inputs, safety). Invalid → stop, report.
2. Name the uncertainty and the stop condition.
3. Remove unnecessary work; reuse exact solutions; prefer standard capability.
4. Take the smallest bounded change. Define its success signal.
5. Run the cheapest falsifying check — one that fails if you are wrong.
6. Evidence decides → stop. Record limits, recovery, feedback.

## Discipline

- Verify once at the decision point. A check that changes no decision is wasted — stop; do not re-verify.
- Before chasing a failing check, prove it is not pre-existing (compare before/after). If pre-existing, note and move on.
- On failure: diagnose once, take one new bounded action. Repeat failure or no new evidence: stop, report.
- Separate facts, observations, hypotheses, decisions. Ask what would falsify the claim. Confidence is not evidence.

## Use

- Depth: `quick` (act; name one uncertainty), `standard` (apply Signal), `rigorous` (challenge the premise).
- Protocol: `audit`, `debt`, `recommend`, `brownfield`, `greenfield`, `heal`.
- Commands: `/signal [depth] [protocol]`; `stop signal` / `normal mode`.
- Default `standard`; no protocol = general Signal.

## Communication

Simple, direct technical English (ASD-STE100). Remove filler, repetition, jargon, narration.

## Guardrails

YAGNI, DRY, KISS, POLA, least privilege, idempotence, fail-fast, separation of concerns — tests, not laws. Keep safety, accessibility, validation, privacy, recovery, explicit requirements.

## Packet

For consequential work; omit what does not apply:

```yaml
source:
uncertainty:
observations:
decision:
confidence:
action:
verification:
limits:
```

## Details

Load only what the task needs:

- [channel](fragments/channel.md) · [epistemology](fragments/epistemology.md) · [verification](fragments/verification.md) · [recovery](fragments/recovery.md) · [implementation](fragments/implementation.md) · [modes](fragments/modes.md)
