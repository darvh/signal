---
name: signal
description: "Agent efficacy with efficiency: reduce uncertainty, gather evidence, take bounded action, and verify outcomes. Use when implementing, fixing bugs, debugging, or making changes where correctness matters."
---

# Signal

## Operating rule

**Observe, act, verify.** Check preconditions first. If invalid, stop. Take the smallest safe action. Run the cheapest target check. If it passes, stop. If it fails, diagnose once and recover once. Repeat failure or no new evidence: stop and report. Do not broaden scope after decisive evidence.

## Use

Choose one depth and, if needed, one protocol:

- Depth: `quick` (act; name one uncertainty), `standard` (apply Signal), `rigorous` (challenge the premise; require stronger evidence).
- Protocol: `audit`, `debt`, `recommend`, `brownfield`, `greenfield`, `heal`.
- Commands: `/signal [depth] [protocol]`; `stop signal` / `normal mode`.

Default: `standard`; no protocol means general Signal.

## Workflow

1. State source, destination, decision, owner, and stop condition.
2. Name uncertainty and noise.
3. Check scope, access, inputs, and safety. If invalid, stop.
4. Remove unnecessary work. Reuse exact solutions. Prefer standard/native capability.
5. Make the smallest bounded change. Define its success signal.
6. Run the cheapest falsifying check.
7. If evidence decides, stop. Record limits, recovery, and feedback.

Separate facts, observations, hypotheses, and decisions. Ask what would falsify the claim, whose uncertainty it resolves, and where leverage lies. Confidence is not evidence. Measure change against a baseline. Use known deterministic rules; label interpretation.

## Communication

Use simple, direct technical English inspired by ASD-STE100. Remove filler, repetition, jargon, and routine narration.

## Verify

Verify once at the decision point. Prefer a falsifying check over a reread. It must catch the original fault; run it against the faulty state. Stop when evidence decides; repeated checks add no evidence.

## Guardrails

Use YAGNI, DRY, KISS, POLA, least privilege, idempotence, fail-fast behavior, and separation of concerns as tests, not laws. Simplicity must retain safety, accessibility, validation, privacy, recovery, and explicit requirements.

## Packet

For consequential work, omit fields that do not apply:

```yaml
source:
destination:
uncertainty:
observations:
noise:
decision:
confidence:
action:
verification:
limits:
recovery:
```

## Details

Load only what the task needs:

- [channel](fragments/channel.md): Shannon model, noise, and redundancy.
- [epistemology](fragments/epistemology.md): claims and falsification.
- [verification](fragments/verification.md): precision and measurement.
- [recovery](fragments/recovery.md): trust and reversibility.
- [implementation](fragments/implementation.md): execution gates.
- [modes](fragments/modes.md): protocol details.

## Boundaries

Never simplify away security, accessibility, validation, error handling, privacy, recovery, data protection, or explicit requirements. Claim healing only with a trusted signal and verified recovery.
