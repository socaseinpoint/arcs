---
name: arcs
description: Use when structuring non-trivial work in a project that follows the arcs method — multi-step tasks, deep research, project tracking, or any work worth persisting outside the ephemeral chat. Triggers when a project has a `.arcs/` directory, when the user says "заведи арку", "новая цель", "arcs status", "по методу arcs", or when work needs file-based state (input/workspace/output) instead of living only in conversation.
---

# arcs — file-based work method (arc + goal)

Work lives in a hidden meta dir `.arcs/` so it never clutters project code. Full spec:
`SPEC.md` in the arcs repo (this skill is symlinked from `<arcs-repo>/skill`, so the spec is at
`../SPEC.md` next to it). CLI: the `arcs` command (the repo's `install.sh` puts it on PATH).

## Two primitives
- **arc** — atom of work. `input/` (what came in) → `workspace/` (work in progress) →
  `output/` (self-contained result; outside world reads ONLY this). Plus `arc.md` (passport:
  goal · status · output pointers). Encapsulation rule: anything the next step needs must be
  derivable from `output/` alone.
- **goal** — "arc with a purpose": same skeleton + its own `arcs/` + a versioned status file
  `NN-<slug>-goal.md` (highest number = current; never edit old versions, drop a new one).
  Use for multi-arc work; use a standalone arc for one-shot answers.

## When to use which
- One-shot question worth persisting → `arcs new-arc <slug>` (lands in `.arcs/arcs/`).
- Sustained multi-arc work (project, deep research) → `arcs new-goal <slug>`, then
  `arcs new-arc -g <goal> <slug>` per step.

## Commands
```
arcs init                      .arcs/{arcs,goals} + README pointer
arcs new-arc <slug>            standalone arc
arcs new-arc -g <goal> <slug>  arc inside a goal
arcs new-goal <slug>           new goal
arcs status                    board: what's done, where the bottleneck is
```

## Working discipline
1. Drop incoming context into `input/`. Work in `workspace/`. Freeze the deliverable in `output/`.
2. Keep `arc.md` / `*-goal.md` as the single source of status (short — details go in workspace).
3. Surfacing after a deep dive? Open the current `*-goal.md` to see the whole picture.
4. Don't invent a parallel tracking scheme — if `.arcs/` exists, use it.
