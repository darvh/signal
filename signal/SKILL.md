---
name: signal
description: "Agent efficacy with efficiency: reduce uncertainty, gather evidence, take bounded action, verify outcomes. Use when implementing, fixing bugs, debugging, or making changes where correctness matters."
---

# Signal

## Operate

1. Check preconditions (scope, access, inputs, safety). Invalid → stop, report.
2. Name the uncertainty and stop condition.
3. Reuse exact solutions; prefer standard capability; smallest bounded change with a success signal.
4. Run the cheapest falsifying check — one that fails if you are wrong.
5. Evidence decides → stop. Record limits, recovery, feedback.

## Discipline

- **Question (Socratic).** For each load-bearing claim: claim? evidence? what falsifies? whose uncertainty? leverage? limits? Confidence ≠ evidence.
- Verify once. A check that changes no decision is wasted — stop.
- Before chasing a failing check, prove it is not pre-existing (compare before/after); if pre-existing, move on.
- On failure: diagnose once, one new bounded action; repeat or no new evidence → stop, report.
- Separate facts, observations, hypotheses, decisions.

## Implementation

Ladder: name success signal → inspect existing/reuse → standard capability → one small test action → minimum solution. Stop at first working rung. Bugs: trace callers, fix the shared cause. Refactor: `characterize → de-duplicate → adhere`. Add capability only for named failure, constraint, or risk. No rescue machinery.

## Use

Depth: `quick` · `standard` · `rigorous`. Protocol: `audit` · `debt` · `recommend` · `brownfield` · `greenfield` · `heal`. `/signal [depth] [protocol]`; `stop signal` / `normal mode`. Default `standard`.

## Communication

Direct technical English (ASD-STE100). No filler, repetition, jargon, narration.

## Guardrails

YAGNI, DRY, KISS, POLA, least privilege, idempotence, fail-fast, separation of concerns — tests, not laws. Keep safety, accessibility, validation, privacy, recovery, explicit requirements.

## Packet

Consequential work: `source, uncertainty, observations, decision, confidence, action, verification, limits`.

## Details

Load only what the task needs: [channel](fragments/channel.md) · [epistemology](fragments/epistemology.md) · [verification](fragments/verification.md) · [recovery](fragments/recovery.md) · [modes](fragments/modes.md)
