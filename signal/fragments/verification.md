# Verification

Stop at the first sufficient rung:

1. Paths, state, lexical match.
2. Syntax, declarations, calls, tests.
3. Compiler/type/LSP facts.
4. Build/test results.
5. Runtime traces/production measures.

Label claims `exact`, `resolved`, or `heuristic`. Measure before modelling; report net change against a real baseline. Known rule: deterministic output. Ambiguous rule: label interpretation; expert decides. Test expected failure first. Silence is unverified, not success.
