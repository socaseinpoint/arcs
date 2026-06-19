# idea — checklist items become arcs (kill closes:)

User's idea (paraphrased): make goal checklist *items* into real filesystem entries instead of
`- [ ]` lines parsed out of `<slug>-goal.md`, and mark a done item with the same `__…__` wrapper
the method already uses for closed arcs/goals. Done-state read from disk, not from `closes:`-key
matching.

## Why this is interesting (my read, version B)
The radical form: a checklist item IS a sub-arc. The goal's substream = its checklist.
Progress = closed sub-arcs / total. This collapses three mechanisms into one:
- the `## Checklist` markdown + `- [ ]` parsing
- the `closes: <key>` link + key matching + slugify
- the close-rename (`__…__`)
into a single rule: a closeable thing is a dir; closing wraps it in `__`.

Kills outright: the dotted-key bug (arc 21), the typo-no-op (#4), candidate 04 (which was
"make closes: fire" — `closes:` disappears entirely).

## Open design questions (to resolve in this brainstorm)
1. Spikes — a sub-arc that does work but closes no requirement. Counts toward N/M? mark non-counting?
2. Planned-but-unstarted item = an open (empty) sub-arc stub. Allowed? how created?
3. Immutable-goal contract (arc 10): intent was frozen in the checklist. If checklist = arc set,
   how is intent frozen / how does supersede apply?
4. Migration of existing goals (10, 13) that use `## Checklist` + `closes:`.
5. Backward compat — is this breaking (MIN_VERSION bump)?

## Replaces
Candidate 04-goal-checklist-actually-fires (supersede it).
