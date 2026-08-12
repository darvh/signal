---
name: signal
description: >
  Evidence-led uncertainty reduction and bounded recovery. Use for Signal,
  first-principles, audit, debt, recommend, brownfield, greenfield, or
  self-healing work.
---

# Signal

Treat work as a control loop, not a feature list:

`source → encoding → channel → decoder → outcome → feedback`

Find the uncertainty, noise, and receiver that matter. Take the smallest
reversible action that produces useful evidence. Keep facts, observations,
hypotheses, and decisions separate.

## Invocation

Use one depth and, when needed, one protocol:

- Depth: `quick` (act; name one uncertainty), `standard` (apply Signal),
  `rigorous` (challenge the premise and require stronger evidence).
- Protocol: `audit`, `debt`, `recommend`, `brownfield`, `greenfield`, `heal`.
- Commands: `/signal [depth] [protocol]`; `stop signal` / `normal mode`.

Default: `standard`; omitted protocol means general Signal.

## Core loop

1. State source, destination, decision, and owner.
2. Name uncertainty and noise.
3. Gather cheapest evidence that can change decision.
4. Choose bounded action and success signal.
5. Verify; record limits, recovery, and feedback.

Ask: what would falsify this? Whose uncertainty does it resolve? Where is the
leverage point? Confidence is not evidence. Measure net change over a real
baseline. Use deterministic rules where known; label interpretation.

## Lineage

Use names as handles, not decoration: Shannon = channel/noise; Wiener =
cybernetic feedback; Ashby = requisite variety/control capacity; Popper =
falsification; Deming = system measurement; Aristotle = first principles;
Socrates = interrogation; Ockham = no unnecessary machinery.

## Portable principles

Use as decision tests, not laws:

- **YAGNI:** do not solve hypothetical needs.
- **DRY:** keep one source of truth for repeated knowledge; do not force an
  abstraction over coincidental similarity.
- **KISS:** choose the simplest model that satisfies constraints and evidence.
- **POLA:** make behavior match reasonable expectation.
- **Least privilege:** grant only authority needed for this action.
- **Idempotence:** make retries safe when actions may repeat.
- **Fail fast:** surface invalid state near its source.
- **Separation of concerns:** bound reasons to change and failure domains.

Simplicity never removes safety, accessibility, validation, privacy, recovery,
or explicit requirements.

## Signal packet

Use for consequential work; omit fields that do not apply:

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

Do not simplify away security, accessibility, validation, error handling,
privacy, recovery, data protection, or explicit requirements. Do not claim
healing without a trusted signal and verified recovery.
