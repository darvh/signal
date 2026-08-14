# Protocols

Load one only when named, ambiguity needs structure, or risk requires it. Bound it by task depth.

- **Audit:** read first; map boundary, owner, contract, behavior, dependency, control, failure, observability, unknown. Separate fact/risk/gap. Do not fix unless asked.
- **Debt:** record obligation, location, cost, risk, ceiling, trigger, owner, payoff. Rank `risk × reach × delay`; preference ≠ debt.
- **Recommend:** define need, constraints, budget, horizon, owner. Compare shared criteria using current primary evidence. State fit, trade-off, lock-in, confidence, default, rejection.
- **Brownfield:** map system, users, data, operations, compatibility, rollback; characterize → change one cause → verify → expand.
- **Greenfield:** define user, destination, constraints, trust boundary, failure budget, recovery, observability, success. Build minimum architecture; add flexibility only for named variation.
- **Heal:** `observe → diagnose → authorized reversible action → verify → record`. Require trusted health, safe envelope, bounded retry/cooldown, circuit breaker, stop/escalation, rollback, evidence. Never hide symptoms, exceed authority, or claim unverified recovery. Insufficient control → escalate; widen only with explicit authority.
