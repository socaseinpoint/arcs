# design notes — checklist items as arcs (B), PARKED

Brainstorm paused by user; will resume later. Decided so far + open questions, captured so
nothing is lost.

## Decided
- **Model B chosen.** A goal's checklist IS its set of sub-arcs. A checklist item == a sub-arc.
  Done item = the sub-arc closed (`__…__`). Progress N/M = closed sub-arcs / total, read from
  disk. The `closes:` link, the item-key matching, slugify-of-keys, and the `## Checklist`
  markdown block all disappear.
- **Kills:** the dotted-key bug (arc 21), the typo-no-op (roast #4), and candidate
  04-goal-checklist-actually-fires (this replaces it).
- **Planned-but-unstarted item = an open (possibly empty) sub-arc.** Planning a goal = creating
  its sub-arcs open up front; closing each marks the item done. No new mechanism.

## OPEN — to resolve on resume (do NOT pre-decide)
1. **Spikes.** A sub-arc that closes no requirement — under B every sub-arc counts toward N/M.
   Options: opt-out marker (`spike: true` in arc.md, excluded from count) vs everything counts.
2. **Immutable contract.** Today intent is frozen in checklist text (change = supersede). If the
   checklist = the sub-arc set, where does the frozen contract live? Options: only `goal:` is
   frozen + sub-arc set is mutable (change item = supersede that arc) vs the whole set is frozen
   at goal creation.
3. **Migration of legacy goals** (10, 13 use `## Checklist` + `closes:`). Options: dual read
   path (new=B, old=legacy) / migrate them to B / just stop rendering N/M for old goals.
4. **Breaking?** Options: minor 0.4.0 (old data still reads, MIN_VERSION untouched) vs major
   1.0.0 (drop `closes:` entirely, raise MIN_VERSION → forced update).
5. (settled assumption) open sub-arc = planned item — no question.

## Mechanics sketch (subject to the open questions)
- `arcs new-goal` stops scaffolding `## Checklist` / drops the `closes:` template line.
- `arcs status` goal badge + per-item lines computed from the sub-arc set, not from keys.
- `arcs new-arc -g <goal> <slug>` = add a checklist item (open). `arcs close` = tick it.
- supersede already handles "this item's aim changed" at the arc level.

## Pointer
Full idea + framing: `../input/idea.md`. Resume = answer the 5 open questions, then writing-plans.
