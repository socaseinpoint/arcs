# Spec — rewrite docs for goal-v2

Goal-v2 is now IMPLEMENTED in `bin/arcs` (see sibling arc
`../__01-cli-goal-v2__/output/result.md` for exact new syntax — READ IT FIRST). The method's prose
docs still describe the OLD mutable/version-numbered goal. Bring every doc surface in line with goal-v2.
Also fold the arc-writing-review's template/SKILL recommendations
(`../../../__12-review-arc-writing-quality__/output/result.md` — READ IT).

This arc closes checklist item **rewrite-docs-for-goal-v2**. Set `closes: rewrite-docs-for-goal-v2` in arc.md.

## What goal-v2 changed (authoritative source = the cli arc's output/result.md; summary):
- Goals are IMMUTABLE: intent never mutated in place; an aim change → `arcs supersede <old> <new>`
  (closes old, creates new with `supersedes: <old>` + seeded `input/from-<old>.md`) → traceable chain.
- Goal-doc version numbering DROPPED: one `<slug>-goal.md` (no `MM-` prefix, no `version:` line).
- Goals carry a `## Checklist`; item done-state is COMPUTED from sub-arcs' `closes: <item-key>` and
  rendered by `arcs status` as `(N/M ✓)` + per-item `✓ <key> → <arc>` / `○ <key>`. No checklist →
  raw sub-arc list (back-compat).
- New optional arc.md fields: `closes:`, `supersedes:` (`prev:` accepted as read-alias).

## Surfaces to update (verify each against the real new bin/arcs behavior before writing):
1. **SPEC.md** — the canonical method def. Rewrite the goal section: remove "versioning a goal by
   number"; document immutability + supersession chains, the `## Checklist` + computed `closes:`
   mechanism, `arcs supersede`, and the new fields. Keep SPEC's existing tone/structure.
2. **skill/SKILL.md** (the skill body; repo `skill/` is symlinked to the installed skill) — update the
   goal description to goal-v2. ALSO fold the review's PROCESS guidance: workspace is disposable
   thinking (if a workspace note restates output, it shouldn't exist); anything a later arc consumes
   must be an `output/`, never a `workspace/` file; keep `goal:` lines ≤12 words. Add the `arcs supersede`
   command to the commands list.
3. **docs/** landing (`index.html`, `app.js`, `style.css` as needed) — find any block describing goal
   versioning and replace with the goal-v2 story (immutable goals + checklist + supersession). Match the
   existing essence-first design; don't redesign, just correct the content.
4. **examples/** — any example showing a `version:` line or MM-goal file → update to goal-v2 shape
   (e.g. a goal with a `## Checklist`). Update `examples/README.md` if its narrative references versioning.
5. **CHANGELOG.md** — add an `## [Unreleased]` entry under Added/Changed describing goal-v2 (immutable
   goals, supersession chains, `arcs supersede`, computed checklist, dropped goal-doc versioning).
6. **bin/arcs template wording ONLY** (tiny, from the review): in `arc_md()` turn the `## input`
   placeholder from prose into a pointer cue (e.g. `<input/… — one-line gist>`); in `goal_md()` add a
   `≤12-word` cue next to the `goal:` placeholder. Do NOT change goal_md's structural goal-v2 behavior
   (already done by the cli arc) — wording/placeholders only.

## Constraints
- Ground truth is the SHIPPED bin/arcs behavior — if a doc claim would contradict what the CLI does,
  fix the doc to match the CLI (not vice-versa).
- Do NOT touch `.arcs/` self-hosted goal/arc docs — that's the parallel migrate arc. Stay in
  SPEC/SKILL/docs/examples/CHANGELOG/bin-template-wording.
- Keep prose in `en`. Humanize CHANGELOG/landing prose (no press-release tone).
- Do NOT git commit. Record notes in workspace/, write output/result.md with per-surface pointers
  (file + section changed) + any doc that still needs follow-up.
