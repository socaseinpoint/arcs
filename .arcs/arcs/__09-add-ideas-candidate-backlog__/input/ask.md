# Ask — candidates backlog

A spawned arc-candidate (an idea that surfaced mid-work) must live SEPARATELY from the work
stream, visible, not buried in a closed arc's private `workspace/`.

User steer (ru):
- "я бы идеи отдельно такие выносил, это кандидат на арку который всплыл, может рядом сделать
  директорию для такого?"
- "типо candidates и там также по номерам и можно посмотреть откуда всплыло из какой арки".

## Design
- New dir `.arcs/candidates/` (sibling of `arcs/`).
- Entries are NUMBERED files `NN-<slug>.md`, own numbering sequence (separate from the work stream).
- Each records `from:` — the arc it surfaced from (so you can trace origin).
- `arcs status` surfaces a CANDIDATES section: `NN-slug   from <arc>`.
- CLI:
  - `arcs candidate <slug> [--from <arc>] [text]` — capture a candidate.
  - `arcs candidate list` (or `arcs status`) — see them.
  - `arcs promote [-g <goal>] <NN-or-slug> [<new-slug>]` — turn a candidate into a real arc:
    create the arc (stream or goal substream), move the candidate file into the arc's `input/`,
    remove it from `candidates/`.

## Then
- Move the parked goal-v2 (`08-@immutable-goals-and-chains`, never started) OUT of the work
  stream INTO candidates (`from: 07-move-rules-to-global-library`) — it's a candidate, not active work.
- Document in SPEC + SKILL: spawned future-work → a candidate, not a workspace file.
