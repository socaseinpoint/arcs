# Spec — migrate this repo's self-hosted state to goal-v2

The arcs repo dogfoods its own method: `.arcs/arcs/` IS arcs-tracked work. goal-v2 is now shipped in
`bin/arcs` (single `<slug>-goal.md`, no `version:` line, `## Checklist` + computed `closes:`). The two
existing goal docs still use the OLD `MM-<slug>-goal.md` + `version:` shape. Migrate them so the repo's
own state matches the method it now implements.

This arc closes checklist item **migrate-existing-self-hosted-state**. Set `closes: migrate-existing-self-hosted-state` in arc.md.

## Existing goal docs to migrate
1. `.arcs/arcs/__06-@landing-essence-first__/01-landing-essence-first-goal.md`
   - Rename → `landing-essence-first-goal.md` (drop the `01-` prefix). Use `git mv` if tracked, else `mv`.
   - Remove the `version: 01 (…)` line.
   - Tighten the `goal:` line to ≤12 words (push extra framing into "## Where we are").
   - FIX the stale status: this goal is CLOSED/done (landing shipped), but its "## Where we are" still
     says "Building…". Update it to reflect the shipped end-state (review flagged this).
2. `.arcs/arcs/10-@immutable-goals-and-chains/01-immutable-goals-and-chains-goal.md` (the ACTIVE goal)
   - Rename → `immutable-goals-and-chains-goal.md` (drop `01-` prefix).
   - Remove the `version: 01 (…)` line.
   - Tighten the `goal:` line to ≤12 words.
   - The `## Checklist` item `design-lock-goal-v2-model` renders `○` but the model IS locked (done in
     this very doc, not via a sub-arc). RESOLVE cleanly: remove that item from the checklist (locking
     the model is the goal-authoring act, not a deliverable sub-arc) so the checklist is the 3 real
     impl items. Leave the other 3 items as `- [ ]` (computed render flips them).
   - Do NOT alter the "## Locked model" section content.

## After migrating
- Run `arcs status` and CONFIRM: both goals still render; goal 06 still shows its no-checklist fallback;
  goal 10 shows `(N/3 ✓)` with the right items. Paste the render into your output.
- Verify nothing in `bin/arcs` resolves goal docs by the `MM-` prefix anymore (the cli arc already
  switched to single-file resolution — just confirm your renamed files are found).

## Constraints
- This is the repo's LIVE arcs state — be careful, do not corrupt other arcs. Touch ONLY the two goal
  docs named above (rename + edit). Do NOT edit closed sub-arcs' content, SPEC/SKILL/docs/examples
  (that's the parallel docs arc), or bin/arcs.
- Preserve git history where possible (`git mv` for the rename).
- `en` prose. Do NOT git commit. Notes → workspace/, write output/result.md with: the renames done,
  the `arcs status` render after, and confirmation the board is intact.
