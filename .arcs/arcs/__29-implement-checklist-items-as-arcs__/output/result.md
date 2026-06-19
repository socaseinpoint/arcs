# result — checklist items as sub-arcs (model B), shipped as 0.4.0

A goal's checklist is no longer a `## Checklist` markdown block with `closes:` key matching.
**An item IS a sub-arc; done = the sub-arc is closed (`__…__`); `N/M ✓` is read from disk.**
This kills the dotted-key bug (arc 21) and the typo-no-op (roast #4) at the root — there is no
key left to mistype.

## What changed — `bin/arcs`
- **Removed 5 functions** (the entire key-matching machinery): `slugify`, `read_closes`,
  `goal_item_keys`, `closing_arc_for`, `item_key`. `read_supersedes` kept (supersede stays).
- **`goal_progress_badge`** now counts the goal's sub-arc dirs: `total` = all, `done` = those
  wrapped `__…__`. Returns `N/M ✓`, or empty when a goal has 0 sub-arcs.
- **`render_goal_substream`** lists the sub-arcs: `✓ <bare-slug> <goal-line>` for closed,
  `○ <slug> [status] <goal-line>` for open; a superseded sub-arc shows `(supersedes <x>)`.
- **`cmd_status`** computes the badge from disk every time (dropped the `goal_item_keys` guard
  and the second `gdoc` arg to the render/badge helpers).
- **Templates:** goal doc lost the `## Checklist` block (all 3 langs), replaced by a one-line
  hint "items = sub-arcs"; arc doc lost the `# closes:` line (all 3 langs). Field-key comment
  updated (`goal:/status:/supersedes:`).

### Bug caught during build
`goal_progress_badge` first ended with `[ "$total" -gt 0 ] && printf …` → returns exit 1 when a
goal has 0 sub-arcs. Under the script's `set -euo pipefail`, `badge="$(goal_progress_badge …)"`
then aborted `cmd_status` and a fresh 0-sub-arc goal vanished from the board. Fixed: `if … then
printf … fi` (an `if` with a false condition is exit 0). Verified both 0-sub-arc and N-sub-arc
goals render.

## Docs realigned (drift killed, lesson from arc 11)
`SPEC.md`, `README.md`, `examples/README.md`, `skill/SKILL.md`, `docs/docs.html` (two sections:
goals + worked example) all rewritten to "the checklist IS the sub-arcs". The live example
`examples/basic/` migrated: goal doc de-checklisted, `__01-research__` lost `closes:`, two open
sub-arcs `02-draft`/`03-ship` added so the board shows `(1/3 ✓)` with ✓/○ — verified by running
`arcs status` in it.

## Compatibility (per arc 28 decision: ship zero migration)
**Not a hard break; `MIN_VERSION` stays 0.0.0.** Old goals carrying `## Checklist` + `closes:`
keep working — the reader ignores the unknown block and recomputes `N/M` from their sub-arcs on
disk. Verified live: this repo's closed goals **06 (1/1 ✓), 10 (3/3 ✓), 13 (2/2 ✓)** still show
the same numbers without their checklists being read. No migration script, no `arcs doctor`, no
schema stamp (all rejected by the arc 28 consortium).

## Release
`VERSION` 0.3.2 → **0.4.0** (minor — behavior/format change, backward-compatible reads).
`CHANGELOG.md`: new `## [0.4.0]` section (Changed/Removed/Compatibility) + footer compare-links.
`./release-check.sh` → **OK** (consistent, ready to tag). Tag/push NOT done — left to the user's
release step.

## Verification run
- `bash -n bin/arcs` → OK.
- Fresh scratch: goal with 0 sub-arcs renders (no badge); +1 open sub-arc → `(0/1 ✓)` + `○`;
  close one of three → `(1/3 ✓)` with ✓/○.
- Templates: no `## Checklist`, no `closes:`.
- Repo + example boards render correctly.
- Grep sweep: no `closes:` / `## Checklist` / `slugify` / old item-keys left in shipping
  surfaces (CHANGELOG history intentionally retains past-release mentions).

## Open (deferred, non-blocking — noted by the design)
- "Freeze only `goal:`, sub-arc set mutable" is the working contract — confirm if ever revisited.
- `data > tool` hard-refuse vs warn: untouched here (lives in the existing MIN_VERSION floor;
  the arc 28 verdict flagged it as an open split for a future arc, not this one).
