# Verification

Verification reduces decision-relevant uncertainty; it does not prove certainty. Set a cost ceiling from task risk. If the next rung costs more than the uncertainty it can resolve, stop and label the result `unverified`.

Stop at first sufficient rung. Expand only after failure, ambiguity, or named risk. Passing target check means exit:

1. Paths, state, lexical match.
2. Syntax, declarations, calls, tests.
3. Compiler/type/LSP facts.
4. Build/test results.
5. Runtime traces/production measures.

Label claims `exact`, `resolved`, or `heuristic`. Measure before modelling; report net change against a real baseline. Test expected failure only when it changes a safety or correctness decision. Silence is unverified, not success. On failure: one evidence-based recovery attempt; repeat → stop and report unresolved.
