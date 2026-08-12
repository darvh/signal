---
name: signal
description: "Evidence-led problem solving: reduce uncertainty, gather evidence, and verify before finalizing. Use when implementing, fixing bugs, debugging, or making changes where correctness matters."
---

# Signal

Treat work as a control loop:

`source → encoding → channel → decoder → outcome → feedback`

Find the relevant uncertainty, noise, and receiver. Take the smallest reversible action that yields evidence. Separate facts, observations, hypotheses, and decisions.

## Invocation

Choose one depth and, if needed, one protocol:

- Depth: `quick` (act; name one uncertainty), `standard` (apply Signal), `rigorous` (challenge the premise; require stronger evidence).
- Protocol: `audit`, `debt`, `recommend`, `brownfield`, `greenfield`, `heal`.
- Commands: `/signal [depth] [protocol]`; `stop signal` / `normal mode`.

Default: `standard`; no protocol means general Signal.

## Core loop

1. State source, destination, decision, owner.
2. Name uncertainty and noise.
3. Gather the cheapest evidence that can change the decision.
4. Choose bounded action and success signal.
5. Verify; record limits, recovery, feedback.

Ask: what would falsify this, whose uncertainty it resolves, and where leverage lies. Confidence is not evidence. Measure net change against a real baseline. Use deterministic rules when known; label interpretation.

## Verification discipline

Verify once at the decision point. Prefer a check that would fail if you are wrong—not a reread. It must catch the original fault; run it against the faulty state. Stop when evidence decides; repetition adds none.

## Lineage

Use names as handles: Shannon = channel/noise; Wiener = feedback; Ashby = control capacity; Popper = falsification; Deming = measurement; Aristotle = first principles; Socrates = interrogation; Ockham = no unnecessary machinery.

## Portable principles

Use as decision tests, not laws:

- **YAGNI:** do not solve hypothetical needs.
- **DRY:** keep one source of truth for repeated knowledge; do not force an abstraction over coincidental similarity.
- **KISS:** choose the simplest model that satisfies constraints and evidence.
- **POLA:** make behavior match reasonable expectation.
- **Least privilege:** grant only authority needed for this action.
- **Idempotence:** make retries safe when actions may repeat.
- **Fail fast:** surface invalid state near its source.
- **Separation of concerns:** bound reasons to change and failure domains.

Simplicity must retain safety, accessibility, validation, privacy, recovery, and explicit requirements.

## Signal packet

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

## Fragments

Load only what the task needs:

- [channel](fragments/channel.md): Shannon model, noise, and redundancy.
- [epistemology](fragments/epistemology.md): claims and falsification.
- [verification](fragments/verification.md): precision and measurement.
- [recovery](fragments/recovery.md): trust and reversibility.
- [implementation](fragments/implementation.md): execution gates.
- [modes](fragments/modes.md): protocol details.

## Boundaries

Never simplify away security, accessibility, validation, error handling, privacy, recovery, data protection, or explicit requirements. Claim healing only with a trusted signal and verified recovery.
