# cross-project-candidates
from: distribution/02-@distribution-system/03-observe-cron

## idea
A candidate's `from:` may name ANOTHER PROJECT, not only a sibling arc. One project DROPS a candidate
into another project's `.arcs/candidates/` inbox instead of editing it directly. The inbox is the ONLY
cross-project-writable surface; the receiving project triages and promotes. Actor / mailbox model.

## why it fits arcs
- `candidates/` already IS the inbox; `from:` already records origin. This just widens `from:` to cross-project.
- Enforces: no project mutates another (one-way dependency, no-god-layer) — message-passing, not shared-memory.
- Provenance survives (`from: <project>/<arc>`); the receiving project keeps full agency over its own canon.

## directions
- `from:` cross-project format: `from: <project>/<arc-path>`.
- helper: `arcs candidate --to <project> <slug>` → writes the file into the target inbox (the only sanctioned cross-project write).
- triage: the receiving project's session sees foreign-origin candidates, accepts → opens an arc / promotes → canon, or rejects.
- guard: a cross-project write may touch ONLY `candidates/`, never anything else in the target.

## related
- Born while seeding the `principles` project from a distribution session — which was done as a DIRECT write
  and should have been a candidate-drop. This candidate is itself dropped cross-project (dogfood).
- Paired principle candidate: `principles/.arcs/candidates/01-cross-project-via-candidates.md`.
