# immutable-goals-and-chains-goal — immutable goals + supersession chains

goal: make goal intent immutable — aim changes spawn supersedes-linked arcs; checklist replaces versioning
status: done

## Where we are
Design LOCKED (brainstorm + user approval 2026-06-18). Model below is the contract.
Cleanup of pre-existing doc drift runs first as a standalone arc (user call), then the
sub-arcs below implement goal-v2.

## Locked model (the contract)
A goal is an immutable contract = a `goal:` line + a `## Checklist`. Two moves:

1. **Immutability + supersession chains.** Intent is never mutated in place. Aim changes →
   close the old arc/goal + open a NEW one carrying `supersedes: <ref>` (traceable chain).
   Refs are bare folder slugs (parser strips `__`). `prev:` kept only as a read-alias. New CLI
   verb `arcs supersede <old> <new>` = close-old (no output guard) + create-new + write
   `supersedes:` + seed `input/from-<old>.md`. NOT a rename — both live, linked.

2. **Immutable goal = no version number + arc-derived checklist.** Goal doc stores items as
   `- [ ]` ALWAYS; done-state is COMPUTED from sub-arcs' `closes: <item-key>` and RENDERED by
   `arcs status` (never hand-ticked — hand-marking reintroduces the drift the method kills).
   `closes:` keys are stable slugs, NOT "step N" (numbers shift on insert). `arcs status` shows
   `N/M ✓` on the goal line + per-item `✓/○ → <arc>`. No `## Checklist` → fallback to today's
   raw sub-arc list (back-compat).

**Supersession REPLACES `MM-<slug>-goal.md` version-numbering entirely** → one `<slug>-goal.md`
per goal. Clarifying edits allowed in place; supersede required only when MEANING changes.

Dropped: `MM` versioning, `prev:` as a separate field, numeric `step N`.
Deferred (YAGNI): `[x]` write-back into doc bytes, checklists on standalone arcs (goals only).

## Checklist (this goal's own items — dogfooded; close each via a sub-arc's `closes:`)
- [ ] cli-goal-v2                        — bin/arcs: `arcs supersede`, `closes:`/`supersedes:` fields, checklist render `N/M ✓`, drop `MM-` goal-doc versioning (one file, one change)
- [ ] rewrite-docs-for-goal-v2          — SPEC / SKILL / landing / examples (+ fold arc-writing-review findings)
- [ ] migrate-existing-self-hosted-state — fold this repo's own goals/arcs to goal-v2

## Arcs of this goal
- (created as design locks each item; first impl arc = cli-goal-v2)
