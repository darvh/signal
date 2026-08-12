# Protocols

All protocols produce a Signal packet and keep the evidence standard.

**Audit** — read first. Map boundaries, owners, contracts, behavior, dependencies, controls, feedback, failures, observability, unknowns. Separate facts, risks, gaps. Do not fix unless asked.

**Debt** — record obligation, location, cost, risk, ceiling, trigger, owner, payoff. Rank `risk × reach × delay cost`. Preference is not debt.

**Recommend** — define need, constraints, budget, horizon, and decision owner; compare real alternatives against the same criteria. Prefer primary/current evidence, expose trade-offs and lock-in, state confidence and fit, and give a default plus a reason to reject it. Do not produce a generic list when criteria or evidence are missing.

**Brownfield** — map existing system/process/document/team/product; capture users, contracts, data, operations, compatibility, rollback. Characterize; change one cause; verify; expand.

**Greenfield** — define user, destination, constraints, trust boundary, failure budget, recovery, observability, success. Then choose minimal architecture. Add flexibility only for named variation.

**Heal** — bounded recovery, not blind autonomy:

`observe → diagnose → allowed action → verify → record`

Require trusted health invariant, safe envelope, idempotent/reversible action, retry/cooldown limits, circuit breaker, stop condition, escalation owner, rollback point, and evidence trail. Never hide symptoms, mutate unauthorized data, or claim unverified recovery. Apply Ashby's requisite variety: if the allowed controller cannot match disturbance variety, escalate or widen control only with explicit authority.
