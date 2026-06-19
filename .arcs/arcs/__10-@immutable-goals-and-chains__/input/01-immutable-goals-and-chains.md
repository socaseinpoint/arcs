# immutable-goals-and-chains
from: 07-move-rules-to-global-library

A surfaced arc-candidate: redesign the goal concept so intent is IMMUTABLE.

## The idea (two linked moves)
1. **Immutability + supersession chains.** Don't mutate a goal/arc's intent in place. If the
   aim changes → close it (done) + open a NEW arc carrying a `prev:`/`supersedes:` link to the
   old one. Arcs form CHAINS → the evolution of thought is traceable. Aligns with the user's
   global immutability principle.
2. **Immutable goal = no version number + checklist + arc-linked completion.** If the goal is
   immutable, the goal-doc version number is pointless — drop `MM-…-goal.md` versioning. A goal
   instead DEFINES a checklist of items; each item, when done, is marked with the arc that closed
   it (`- [x] integrate stripe → 03-integrate-stripe`), likely derivable from arcs' `closes:`/`prev:`.

## Open questions to resolve first
- Checklist progress: marked by hand in the goal doc, or computed from arcs' `closes:`/`prev:`?
- Do supersession chains REPLACE goal-doc version numbering, or coexist?
- `prev:`/`supersedes:` field shape on arc.md; CLI `arcs supersede <old> <new>`?
- What does `arcs status` show for a goal's checklist progress?

## Candidate sub-steps (once design is locked)
- design + lock the goal-v2 model
- CLI: `arcs supersede`, `prev:` field, checklist rendering in status
- drop goal-doc version numbering
- docs: SPEC / SKILL / landing / examples
- migrate existing goals

(Promote with `arcs promote immutable-goals-and-chains` when ready to work it.)
