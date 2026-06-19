# Result — candidates backlog

Added a backlog for surfaced arc-candidates so a mid-work idea reaches the board instead of
dying in a closed arc's private `workspace/`.

## Shipped
- `.arcs/candidates/` — numbered files `NN-<slug>.md` (own sequence), each with a `from:` origin.
- CLI (bin/arcs): `next_num_file` helper; `arcs candidate <slug> [--from <arc>] [text]` (capture);
  `arcs candidate list`; `arcs promote [-g <goal>] <NN-or-slug> [<new-slug>]` (candidate → real arc:
  create arc, move file into its `input/`, drop from candidates/). `arcs status` shows a
  CANDIDATES section with `from`.

## Applied
- Relocated the un-started goal-v2 out of the work stream into
  `.arcs/candidates/01-immutable-goals-and-chains.md` (from: 07). Removed the `08-@…` goal dir.

## Docs (all materials made consistent)
- SPEC.md, skill/SKILL.md, README.md, docs/index.html (landing §02 + fig.02 board), examples/
  (added `01-add-rss-feed` candidate + README) — via parallel subagents.
- Fixed stale `template/README.md` (old `.arcs/goals/` model) and a README `template/.arcs/` line.
- CHANGELOG updated.

## Verified
Temp-dir: capture (numbered + from), status CANDIDATES, promote moves file to arc input/ and
removes from candidates/. Real repo + examples boards render the CANDIDATES section.
