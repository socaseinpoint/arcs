# Spec — implement goal-v2 in bin/arcs

Implements the LOCKED model in the parent goal doc
(`../../01-immutable-goals-and-chains-goal.md`, see "## Locked model"). Detailed design rationale:
`../../workspace/brainstorm-goal-v2.md`. Current method: `SPEC.md`. Current impl: `bin/arcs` (440 lines, bash).

This arc closes checklist item **cli-goal-v2**. One coherent change to `bin/arcs` delivering 3 things:

## 1. Drop `MM-` goal-doc version numbering
- Today `goal_md()` writes `MM-<slug>-goal.md` and new-goal/close/reopen resolve "current" via
  `*-goal.md | sort | tail -1`. Replace with a SINGLE `<slug>-goal.md` per goal (no MM prefix, no
  `version:` line). Update `goal_md()` (all 3 language variants), `cmd_new_goal`, and any close/reopen/
  status code that globs `*-goal.md` or reads `version:`.
- Clarifying edits happen in place; intent CHANGE is handled by supersession (below), not a new version file.

## 2. Checklist on goals + computed rendering
- A goal doc MAY carry a `## Checklist` with items `- [ ] <item-key>  — <desc>`. Item keys are stable
  slugs (never "step N").
- Done-state is COMPUTED, never hand-ticked: a sub-arc declares `closes: <item-key>` in its `arc.md`.
  An item is ✓ when some CLOSED sub-arc (`__NN-…__`, status done) declares `closes: <that-key>`.
- `arcs status` rendering for a goal WITH a checklist:
  - goal line gets a `N/M ✓` progress badge (N done items / M total).
  - under it, per-item lines: `✓ <item-key> → <NN-arc-slug>` (closed) or `○ <item-key>` (open).
  - A goal with NO `## Checklist` falls back to today's raw sub-arc list (back-compat — do not break
    existing goal `__06-@landing-essence-first__` which has no checklist).
- Add `closes:` to the `arc_md()` template (all 3 langs) as an optional commented field, e.g.
  `closes: <goal-checklist-item-key this arc completes, optional>`.

## 3. `arcs supersede <old> <new>` + `supersedes:` field
- New subcommand. `arcs supersede <old-slug> <new-slug> [-g <goal>]`:
  1. close `<old>` (rename → `__…__`, status done) — WITHOUT the empty-output guard (a superseded arc
     may legitimately have no output; this is the `-f` path internally).
  2. create `<new>` arc (same stream / same goal substream as old).
  3. write `supersedes: <old-slug>` into new's `arc.md`.
  4. seed `<new>/input/from-<old>.md` with a one-line pointer back to the superseded arc.
- Add `supersedes:` to `arc_md()` template (all langs) as optional commented field. `prev:` is accepted
  as a READ alias only (if you parse supersedes anywhere, also accept prev:) — do not write `prev:`.
- Refs are bare folder slugs; when matching, strip leading/trailing `__` so a ref resolves whether the
  target is open or closed.
- Register `supersede)` in the command dispatch + add to `cmd_help` + the top-of-file comment.

## Constraints
- Pure bash, match existing style in bin/arcs (helper fns, `die`, zero-padded `next_num`, lang variants).
- Back-compat: existing arcs/goals without the new fields must still work; `arcs status` must still
  render the whole current board (01–12) without error.
- No tests exist in repo. After implementing, VERIFY by hand: run `arcs status` (must render clean),
  create a throwaway goal with a checklist + a sub-arc that `closes:` an item + close it + confirm the
  badge/✓ renders, run `arcs supersede` on a throwaway arc + confirm the chain. Tear down throwaways.
- Do NOT edit SPEC.md / SKILL / landing — docs are a SEPARATE arc. Code + arc.md only here.
