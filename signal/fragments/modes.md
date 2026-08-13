# Protocols

All protocols produce a Signal packet under the same evidence standard.

- **Audit** — read first. Map boundaries, owners, contracts, behavior, dependencies, controls, feedback, failures, observability, unknowns. Separate facts, risks, gaps. Do not fix unless asked.
- **Debt** — record obligation, location, cost, risk, ceiling, trigger, owner, payoff. Rank `risk × reach × delay`. Preference is not debt.
- **Recommend** — define need, constraints, budget, horizon, owner. Compare alternatives on shared criteria. Prefer current primary evidence. State trade-offs, lock-in, confidence, fit, default, rejection reason.
- **Brownfield** — map existing system, users, data, operations, compatibility, rollback. Characterize, change one cause, verify, expand.
- **Greenfield** — define user, destination, constraints, trust boundary, failure budget, recovery, observability, success. Minimal architecture; flexibility only for named variation.
- **Heal** — bounded recovery: `observe → diagnose → allowed action → verify → record`. Require trusted health invariant, safe envelope, idempotent/reversible action, retry/cooldown limits, circuit breaker, stop condition, escalation owner, rollback point, evidence trail. Never hide symptoms, mutate unauthorized data, or claim recovery without verification. If controller capacity < disturbance variety: escalate or widen control only with explicit authority.
