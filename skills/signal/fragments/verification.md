# Verification

Reduce decision-relevant uncertainty, not all. Cost by risk; if next check can't justify cost, stop, label `unverified`.

Start lowest rung covering whole success contract; climb only on failure/ambiguity/named risk. Bug fixes: inspect affected tests before editing; prefer repo's decisive regression, else smallest permanent regression. Temporary narrow check supplements, never replaces:

1. Path/state/text
2. Syntax/declaration/call/focused test
3. Compiler/type/LSP
4. Build/test
5. Runtime/production measure

Label claims `exact`/`resolved`/`heuristic`. Measure against real baseline. Test expected failure only if safety/correctness changes. Silence is unverified. One evidence-based recovery attempt; repeat failure → stop unresolved.
