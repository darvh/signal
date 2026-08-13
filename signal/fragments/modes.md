# Protocols

All protocols produce a Signal packet and use the same evidence standard.

**Audit** — read first. Map boundaries, owners, contracts, behavior, dependencies, controls, feedback, failures, observability, and unknowns. Separate facts, risks, and gaps. Do not fix unless asked.

**Debt** — record obligation, location, cost, risk, ceiling, trigger, owner, and payoff. Rank `risk × reach × delay cost`. Preference is not debt.

**Recommend** — define need, constraints, budget, horizon, and owner. Compare alternatives against shared criteria. Prefer current primary evidence. State trade-offs, lock-in, confidence, fit, default, and rejection reason. No generic list without criteria or evidence.

**Brownfield** — map the existing system, users, data, operations, compatibility, and rollback. Characterize, change one cause, verify, expand.

**Greenfield** — define user, destination, constraints, trust boundary, failure budget, recovery, observability, and success. Choose minimal architecture. Add flexibility only for named variation.

**Heal** — bounded recovery, not blind autonomy:

`observe → diagnose → allowed action → verify → record`

Require a trusted health invariant, safe envelope, idempotent/reversible action, retry/cooldown limits, circuit breaker, stop condition, escalation owner, rollback point, and evidence trail. Never hide symptoms, mutate unauthorized data, or claim recovery without verification. Apply Ashby: if controller capacity cannot match disturbance variety, escalate or widen control only with explicit authority.
