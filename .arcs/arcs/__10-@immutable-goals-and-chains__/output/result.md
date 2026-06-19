# Result — goal-v2: immutable goals + supersession chains

Shipped. Goals are now an immutable contract; intent never mutates in place.

## What landed
- **Immutability + supersession chains.** `arcs supersede <old> <new>` closes the old arc/goal and
  creates a new one carrying `supersedes: <old>` + a seeded `input/from-<old>.md` — drift and pivots
  become a traceable chain instead of an in-place edit. `prev:` accepted as a read-alias.
- **Computed checklist replaces goal-doc versioning.** A goal carries a `## Checklist`; each item flips
  `✓` only when a CLOSED sub-arc declares `closes: <item-key>`. `arcs status` renders `(N/M ✓)` + per-item
  `✓ <key> → <arc>` / `○ <key>`. Goals without a checklist fall back to the raw sub-arc list (back-compat).
- **`MM-<slug>-goal.md` + `version:` dropped** → one `<slug>-goal.md` per goal.

## Pointers
- Engine: `bin/arcs` — see `arcs/__01-cli-goal-v2__/output/result.md` (functions + new syntax).
- Docs: SPEC.md, skill/SKILL.md, docs/ landing, examples/, CHANGELOG, README — see
  `arcs/__02-rewrite-docs-for-goal-v2__/output/result.md`.
- Self-hosted migration (this repo's own goal docs): `arcs/__03-migrate-existing-self-hosted-state__/output/result.md`.
- Design rationale: `workspace/brainstorm-goal-v2.md`. Coherence audit that ran alongside:
  `workspace/coherence-audit.md` (its drift fixes shipped as standalone arc `__11-fix-doc-drift-and-orphan__`).

## Dogfood proof
This goal's own board renders `(3/3 ✓)` under the new mechanism — the method validates itself live.

## Deviations / deferred
- `arcs supersede` kept to `<old> <new>` (no trailing text arg); rationale lives in the seeded `from-<old>.md`.
- Deferred (YAGNI): `[x]` write-back into goal-doc bytes; checklists on standalone arcs (goals only).
