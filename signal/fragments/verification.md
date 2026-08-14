# Verification

Reduce decision-relevant uncertainty, not all uncertainty. Set cost by risk; if the next check cannot justify its cost, stop and label `unverified`.

Start at the lowest rung covering the whole success contract; climb only after failure, ambiguity, or named risk. Prefer the repository’s decisive regression over a new narrow test:

1. Path/state/text
2. Syntax/declaration/call/focused test
3. Compiler/type/LSP
4. Build/test
5. Runtime/production measure

Label claims `exact`, `resolved`, or `heuristic`. Measure against a real baseline. Test expected failure only when it changes safety or correctness. Silence is unverified. One evidence-based recovery attempt; repeat failure → stop unresolved.
