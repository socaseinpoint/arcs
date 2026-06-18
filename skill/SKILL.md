---
name: arcs
description: Activate whenever the current project has a `.arcs/` directory. That directory is the user's opt-in that work here runs with the arcs method — so from then on, structure all non-trivial work through arcs (orient with `arcs status`, create goals/arcs, keep input→workspace→output). The user does NOT learn the CLI — you run the `arcs` commands yourself. Also activate when the user says "arcs", "arc", "goal", "заведи арку", "новая цель", or "arcs status". If there is no `.arcs/`, the user has not opted in — do not create it unless they explicitly run `arcs init` or ask.
---

# arcs — file-based work method (arc + goal)

`.arcs/` in a project is the switch: **its presence means "run work here with arcs."** Work lives in
that hidden meta dir so it never clutters the code. Full spec: `SPEC.md` in the arcs repo (this skill
is symlinked from `<arcs-repo>/skill`, so the spec is at `../SPEC.md`). CLI: the `arcs` command.

## First thing, every session in an arcs project
1. Run `arcs status` to orient — see open goals/arcs and where the work stands.
2. Continue the open goal/arc, or start a new one for the task at hand.
3. **The user never types `arcs` commands — you do.** Just tell them in one line what you set up.

(No `.arcs/` dir? The user hasn't opted in. Don't auto-create it — only `arcs init` on their request.)

## Two primitives
- **arc** — atom of work. `input/` (what came in) → `workspace/` (work in progress) →
  `output/` (self-contained result; the outside reads ONLY this). Plus `arc.md` (passport:
  goal · status · output pointers). Encapsulation rule: anything the next step needs must be
  derivable from `output/` alone.
- **goal** — "arc with a purpose": same skeleton + its own `arcs/` + a versioned status file
  `NN-<slug>-goal.md` (highest number = current; never edit old versions, drop a new one).
  Use a goal for multi-arc work; a standalone arc for one-shot answers.

## Commands (you run these, not the user)
```
arcs status                    board: what's done, where the bottleneck is   ← run first
arcs new-goal <slug>           new goal (multi-arc work)
arcs new-arc -g <goal> <slug>  arc inside a goal (one step of it)
arcs new-arc <slug>            standalone arc (one-off, lands in .arcs/arcs/)
arcs init                      only on the user's request — opt a project in
```
If `arcs` isn't on PATH, fall back to creating the same dirs/files by hand per `SPEC.md`.

## Working discipline
1. Drop incoming context into `input/`. Work in `workspace/`. Freeze the deliverable in `output/`.
2. Keep `arc.md` / `*-goal.md` as the single source of status (short — details live in `workspace/`).
3. Surfacing after a deep dive? Open the current `*-goal.md` to see the whole picture.
4. Don't invent a parallel tracking scheme — if `.arcs/` exists, use it.
