# 01-immutable-goals-and-chains-goal — goal v2: immutable goals + supersession chains

goal: redesign the goal concept so intent is immutable — pivots happen via supersession chains, goals carry an arc-linked checklist, version-numbering is dropped
status: active
version: 01 (highest number = current)

## Where we are
Design stage. Seed idea captured in `input/idea-supersession-and-immutable-goals.md`
(rescued from a closed arc's workspace — it should have been surfaced as work from the start).

## Open questions to resolve first
- [ ] Checklist progress: marked by hand in the goal doc, or computed from arcs' `closes:`/`prev:`?
- [ ] Do supersession chains REPLACE goal-doc version numbering, or coexist?
- [ ] `prev:`/`supersedes:` field shape on arc.md; CLI `arcs supersede <old> <new>`?
- [ ] What does `arcs status` show for a goal's checklist progress?

## Arcs of this goal (candidate steps, once design is locked)
- [ ] design + lock the goal-v2 model (first real arc)
- [ ] CLI: `arcs supersede`, `prev:` field, checklist rendering in status
- [ ] drop goal-doc version numbering (immutable → no MM versions)
- [ ] docs: SPEC / SKILL / landing / examples
- [ ] migrate existing goals

## Meta note (separate candidate)
This goal exists because a spawned idea got buried in a closed arc's private `workspace/`.
Lesson / possible method change: a future-work idea must SURFACE — open a queued arc for it
immediately (board = backlog), never park it in `workspace/`. Worth a skill rule and maybe a
proposed/queued arc state. Track separately.
