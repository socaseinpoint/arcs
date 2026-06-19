# Result — unify goals into one arc stream

Goals are no longer a separate `.arcs/goals/` dir. Arcs and goals now live in ONE numbered
stream `.arcs/arcs/` with shared continuous numbering; a goal is marked by an `@` in its name.

## Model shipped
- `.arcs/arcs/` = single stream. arc = `NN-<slug>/` (work without a purpose). goal =
  `NN-@<slug>/` (an arc WITH a purpose) + nested `arcs/` substream + versioned goal doc.
- Shared numbering across arcs and goals (one `next_num` on `.arcs/arcs/`).
- Slugs must be descriptive (skill enforces).
- `arcs status` prints one STREAM board; goals expand their nested arcs.

## CLI (bin/arcs)
- base_dir: no `goals/`. new-goal → `NN-@slug` in the stream. new-arc -g resolves `NN-@goal`.
- status rewritten (single STREAM, goal detected by `*-goal.md`). close/reopen handle `@`
  goals and set status in the goal doc (not arc.md) when closing a goal.

## Migration
- This repo's `.arcs/goals/01-landing-essence-first` → `.arcs/arcs/06-@landing-essence-first`.
- examples/basic likewise → `.arcs/arcs/02-@newsletter`.

## Docs
SPEC.md, skill/SKILL.md, docs/index.html (tree + board figures), examples — updated via
parallel subagents.

## Verified
Temp-dir: arc 01, goal 02-@, nested arc, arc 03 (shared numbering), close/reopen goal sets
status done in goal doc. Real repo + examples boards render correctly.
