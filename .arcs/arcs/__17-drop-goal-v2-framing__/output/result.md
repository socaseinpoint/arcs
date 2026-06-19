# Result — dropped "goal-v2" / legacy framing

Goals are now presented as the single current concept. No v1→v2 narrative, no "no version number /
back-compat / MM- axis" comparisons. Prose only — zero behavior change.

## Changed
- docs/docs.html — "Goals v2" → "Goals" (meta desc, nav x2, section comment, h2); "No version number →
  a computed checklist" → "A computed checklist"; "falls back to a raw sub-arc list (back-compat)" →
  "a goal that hasn't defined any ## Checklist items just lists its sub-arcs". Cache-bust v6→v7.
- SPEC.md — same de-versioning in the goal table row, the immutable-contract intro, rule 2 heading,
  and the no-checklist sentence.
- skill/SKILL.md, README.md — dropped the "(no version number)" parentheticals.
- bin/arcs — comment-only: goal_md/cmd_new_goal/render_goal_substream no longer say "no version prefix"
  / "back-compat". Fallback CODE kept (a goal with no checklist items legitimately just lists its arcs).

## Untouched (by design)
CHANGELOG.md (historical ledger — the change belongs there) and closed .arcs/ history (immutable).
