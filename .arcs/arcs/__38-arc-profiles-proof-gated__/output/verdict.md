# Verdict — arc-profiles design (38)

Design/decision arc. Did NOT implement. Produced: idea → 12-lens adversarial roast →
refined idea → captured as a candidate for later. Implementation not urgent now (user).

## Decision
The v1 idea ("3 profiles + pluggable proof-kinds + autodetect + enforce + dashboard facets")
was over-built. Roast collapsed it to a small, honest, **bench-first** kernel. We capture
that kernel as a candidate and stop here — no spec, no implementation this round.

## The refined kernel (see workspace/idea-v2-refined.md)
- Don't ship "profiles" yet. Ship ONE optional **`close-requires-proof`** rule via the
  existing `rules:` toggle (off by default): `arcs close` refuses unless `output/proof/`
  is non-empty + referenced in arc.md. No profile abstraction, no proof-kind enum.
- Proof must MEAN something or it's theater (arc 24): gate **executes** the check live +
  **independent** verifier (author ≠ verifier, hook/CI/fresh subagent). Label honestly as
  declared-intent ceremony, not hard enforcement.
- Two meanings, one slot: code/visual arcs prove by *passing*; decision/research arcs prove
  by *recording* the reasoning they already produce.
- Selection: explicit only, declared at arc open. No autodetect, no enforce-floor in v1.
  profile-less = `default`, immutable, never stamp existing files (arc 28).

## Lightening (separately surfaced)
- "light as a directory profile" is dead — the 3× overhead is **behavioral** (round-trips:
  agent reads docs + i/w/o tool calls), not layout. Profile-immune.
- Lightening lives as a **behavioral prompt directive** (skip workspace-split, don't re-read
  docs, write straight to output), and it's the **cheaper experiment**: testable on the
  EXISTING trivial bench suite (quality ceiling already hit → just measure "cut tokens, hold
  judge=5"). No new discriminating bench needed, unlike heavy.

## Sequencing (if/when picked up)
1. Lean behavioral arm vs existing suite (cheap, ready now).
2. Discriminating bench for heavy — hidden adversarial failure modes, pass/judge divergence
   as headline, n≥10, fresh-vs-cache token split (this is candidate 01-where-arcs-wins).
3. `close-requires-proof` rule — design falls out of what the bench shows proof catches.

## Artifacts
- workspace/idea-v1.md — original idea (pre-roast)
- workspace/roast-synthesis.md — 12 lenses, grounded in file:line, kills + back-compat rules
- workspace/idea-v2-refined.md — the refined kernel + deferrals + sequencing
