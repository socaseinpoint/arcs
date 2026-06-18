---
name: arcs
description: Activate whenever the current project has a `.arcs/` directory. That directory is the user's opt-in that work here runs with the arcs method — so you MUST structure non-trivial work through arcs, not just acknowledge the dir. Before doing the task, create the arc/goal and work inside it (input→workspace→output); the user does NOT learn the CLI — you run the `arcs` commands. Also activate on "arcs", "arc", "goal", "заведи арку", "arcs status". No `.arcs/`? The user has not opted in — don't create it unless they run `arcs init` or ask.
---

# arcs — file-based work method (arc + goal)

`.arcs/` in a project is the switch: its presence means **"run work here with arcs."** Seeing the dir
is NOT enough — you must actually open an arc and put files in it AS YOU WORK. Full spec: `SPEC.md`
in the arcs repo (skill is symlinked from `<arcs-repo>/skill`, so spec is at `../SPEC.md`).

## Do this BEFORE starting the task (mandatory — make these your first todos)
1. Run `arcs status` to orient (open goals/arcs, where things stand).
2. Trivial one-liner (a fact, a tiny edit)? Skip arcs. Anything real — a feature, a bug hunt,
   research, a refactor, a multi-step task — **must** run inside an arc. Don't rationalize past this.
3. **Open the container first, before working:**
   - one self-contained chunk → `arcs new-arc <slug>`
   - multi-step / a project thread → `arcs new-goal <slug>`, then `arcs new-arc -g <slug> <step>`
4. Write the user's request/spec into the arc's `input/`. Start a plan/notes file in `workspace/`.
5. Only now do the work — keeping notes flowing into `workspace/` as you go, not dumped at the end.

## The arc is the record, even when the deliverable is code
Most tasks ship their artifact elsewhere (source files in the repo). The arc does **not** replace that —
it's the **spine/log** of the work:
- `input/` — the ask, the spec, constraints, relevant context.
- `workspace/` — your plan, findings, dead-ends, scratch — the thinking, as it happens.
- `output/` — a short result + **pointers** to what changed (files/PRs/commits) and the key decisions.
- `arc.md` — goal + status (`active`→`done`), kept current.

A coding task is done = code written AND the arc carries `output/` + `arc.md status: done`.
**`.arcs/` still empty when you finish = you skipped the method. That's the failure mode. Don't.**

## Two primitives
- **arc** — atom of work: `input/` → `workspace/` → `output/` (the outside reads ONLY `output/`) + `arc.md`.
  Encapsulation: anything the next step needs must be derivable from `output/` alone.
- **goal** — "arc with a purpose": same skeleton + its own `arcs/` + a versioned status file
  `NN-<slug>-goal.md` (highest number = current; never edit old versions, drop a new one).

## Commands (you run these, not the user)
```
arcs status                    board — run first, every session
arcs new-goal <slug>           new goal (multi-arc work)
arcs new-arc -g <goal> <slug>  arc inside a goal (one step)
arcs new-arc <slug>            standalone arc (one-off)
arcs init / arcs update        opt a project in / self-update (only on user request)
```
If `arcs` isn't on PATH, create the same dirs/files by hand per `SPEC.md` — the method still applies.
