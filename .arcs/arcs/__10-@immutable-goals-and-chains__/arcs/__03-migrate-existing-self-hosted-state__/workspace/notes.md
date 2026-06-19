# workspace notes — migrate-existing-self-hosted-state

## Tracking state before rename
- `__06-@landing-essence-first__/01-landing-essence-first-goal.md` — git-tracked → used `git mv`.
- `10-@immutable-goals-and-chains/01-immutable-goals-and-chains-goal.md` — NOT tracked (untracked) → used plain `mv`.

## Resolution check
- `bin/arcs` line 345: `gdoc=$(ls "$d"*-goal.md 2>/dev/null | sort | tail -1)` — resolves by the
  `*-goal.md` glob, no `MM-` prefix dependency. Renamed files (`landing-essence-first-goal.md`,
  `immutable-goals-and-chains-goal.md`) are found cleanly. Confirmed by the live `arcs status` render.

## Edits
### goal 06 (landing) — status was stale ("Building…") though landing shipped
- H1 `01-` prefix dropped; `version:` line removed.
- goal: tightened 19→10 words.
- "## Where we are" rewritten Building→Shipped (live at arcs-delta.vercel.app, goal done).

### goal 10 (immutable-goals) — ACTIVE
- H1 `01-` prefix dropped; `version:` line removed.
- goal: tightened to 12 words.
- Removed checklist item `design-lock-goal-v2-model` (the model is locked in this doc itself, not via a
  sub-arc → could never compute ✓). Checklist now the 3 real impl items.
- "## Locked model" section left byte-for-byte untouched.

## Scope guard
Touched ONLY the two goal docs (rename+edit) + this arc's own arc.md/workspace/output. No other arc,
no closed sub-arc content, no SPEC/SKILL/docs/examples, no bin/arcs. No git commit.
