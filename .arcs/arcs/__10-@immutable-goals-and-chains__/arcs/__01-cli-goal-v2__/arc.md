# 01-cli-goal-v2

goal: implement goal-v2 in bin/arcs — drop MM- goal-doc versioning, computed `## Checklist` render (N/M ✓), `arcs supersede` + closes:/supersedes: fields
status: done
closes: cli-goal-v2

## input
- input/spec.md — authoritative task (3 deliverables, hard constraints)
- ../../01-immutable-goals-and-chains-goal.md (## Locked model) + ../../workspace/brainstorm-goal-v2.md

## output → pointers
- output/result.md — result + exact pointers (function names + line ranges in bin/arcs), new field/command syntax, deviation, notes for the docs arc
- workspace/notes.md — design choices (bash-3.2 map-free rewrite, read IFS-tab bug, item-key tiers) + full verification transcript
- bin/arcs — the implementation (only file edited): goal_md/arc_md/cmd_new_goal/cmd_status + new cmd_supersede, helpers slugify/read_closes/read_supersedes/goal_item_keys/item_key/closing_arc_for/goal_progress_badge/render_goal_substream
