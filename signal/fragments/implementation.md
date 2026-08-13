# Implementation

Resolve uncertainty, change smallest surface, observe feedback, stop early.

## Gate

Before mutation, check scope, access, inputs, safety. Invalid → stop, report blocker.

## Ladder

1. Name uncertainty and success signal.
2. Inspect existing behavior; reuse code/process.
3. Use standard/native capability.
4. One small test action.
5. Minimum durable solution.

Stop at first working rung. Run target check once. Pass means exit.

For bugs, trace callers and fix the shared cause. Before refactoring: `characterize → de-duplicate → adhere`.

Add capability only for measured failure, explicit constraint, or named risk. Track frontier: `committed` (executes now), `provisional` (plausible next), `contingent` (only after named failure). No rescue machinery.
