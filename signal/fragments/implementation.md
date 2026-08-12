# Implementation

Treat implementation as a control action: resolve uncertainty, change the smallest surface, observe feedback, then stop.

## Rungs

1. Name uncertainty and success signal.
2. Inspect existing behavior and reuse code/process.
3. Use standard/native capability.
4. Take one small test action.
5. Add minimum durable solution.

For bugs, trace callers; fix shared cause. Before refactoring:
`characterize → de-duplicate → adhere`.

Track frontier:

- `committed`: true/executes now;
- `provisional`: plausible next work;
- `contingent`: added only after named failure.

Do not add capability by resemblance. Add it for measured failure, explicit constraint, or named risk. If it fails, stop; do not rescue with machinery.
