# Implementation

Treat implementation as control action: resolve uncertainty, change smallest surface, observe feedback, stop early.

## Fail-fast gate

Before mutation, check scope, access, inputs, and safety. If invalid, stop. Report blocker.

## Minimum-first ladder

1. Name uncertainty and success signal.
2. Inspect existing behavior and reuse code/process.
3. Use standard/native capability.
4. Take one small test action.
5. Add minimum durable solution.

Stop at first working rung. Exact authoritative patch plus matching base: apply it. Do not recreate it. Run target check once. Pass means exit.

For bugs, trace callers and fix the shared cause. Before refactoring:
`characterize → de-duplicate → adhere`.

Track frontier:

- `committed`: true/executes now;
- `provisional`: plausible next work;
- `contingent`: added only after named failure.

Add capability only for measured failure, explicit constraint, or named risk. On failure, diagnose once and take one new bounded action. Repeat failure or no new evidence: stop. Do not add rescue machinery.
