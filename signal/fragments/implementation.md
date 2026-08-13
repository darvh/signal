# Implementation

Treat implementation as a control action: resolve uncertainty, change the smallest surface, observe feedback, stop.

## Minimum-first ladder

1. Name uncertainty and success signal.
2. Inspect existing behavior and reuse code/process.
3. Use standard/native capability.
4. Take one small test action.
5. Add minimum durable solution.

Stop at first working rung. If an authoritative patch matches the problem and base, apply it; do not recreate it.

For bugs, trace callers and fix the shared cause. Before refactoring:
`characterize → de-duplicate → adhere`.

Track frontier:

- `committed`: true/executes now;
- `provisional`: plausible next work;
- `contingent`: added only after named failure.

Add capability only for measured failure, explicit constraint, or named risk. If it fails, stop; do not rescue it with machinery.
