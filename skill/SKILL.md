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
2. Read `.arcs/rules/*.md` and **obey every rule with `enabled: true`** for the whole session (see `## Rules`).
3. Trivial one-liner (a fact, a tiny edit)? Skip arcs. Anything real — a feature, a bug hunt,
   research, a refactor, a multi-step task — **must** run inside an arc. Don't rationalize past this.
4. **Open the container first, before working:**
   - one self-contained chunk → `arcs new-arc <slug>`
   - multi-step / a project thread → `arcs new-goal <slug>`, then `arcs new-arc -g <slug> <step>`
5. Write the user's request/spec into the arc's `input/`. Start a plan/notes file in `workspace/`.
6. Do the work — keeping notes flowing into `workspace/` as you go, not dumped at the end. Finish an
   arc by writing `output/` then `arcs close <slug>`.

**Language:** write all arc prose (goal, notes, output) in the project's language — `lang=en|ru|es`
in `.arcs/config`, also shown by `arcs status`. Field keys (`goal:`, `status:`) stay as-is. The user
changes it with `arcs lang <code>`; don't switch languages on your own mid-project.

## The arc is the record, even when the deliverable is code
Most tasks ship their artifact elsewhere (source files in the repo). The arc does **not** replace that —
it's the **spine/log** of the work:
- `input/` — the ask, the spec, constraints, relevant context.
- `workspace/` — your plan, findings, dead-ends, scratch — the thinking, as it happens.
- `output/` — a short result + **pointers** to what changed (files/PRs/commits) and the key decisions.
- `arc.md` — goal + status (`active`→`done`), kept current.

A coding task is done = code written AND the arc carries `output/` + `arc.md status: done`. You set
that done-state by running `arcs close <slug>` (writes `status: done` and renames `NN-slug` →
`__NN-slug__`, so finished arcs are visible at a glance in `ls`). Reverse with `arcs reopen <slug>`.
Numbering still counts closed arcs, so numbers are never reused.
**`.arcs/` still empty when you finish = you skipped the method. That's the failure mode. Don't.**

## Two primitives
- **arc** — atom of work: `input/` → `workspace/` → `output/` (the outside reads ONLY `output/`) + `arc.md`.
  Encapsulation: anything the next step needs must be derivable from `output/` alone.
- **goal** — "arc with a purpose": same skeleton + its own `arcs/` + a versioned status file
  `NN-<slug>-goal.md` (highest number = current; never edit old versions, drop a new one).

## Rules (toggleable behavior layer)
Rules are markdown files in `.arcs/rules/<slug>.md` — a `# <slug>` header, an `enabled: true|false`
line, then a body describing a behavior you must follow. At session start (right after `arcs status`)
read them all and **obey every rule whose `enabled:` is `true`**. Manage with `arcs rule list / on
<slug> / off <slug> / add <slug>` (you run these, not the user).

Shipped on by default at `arcs init`: **`subagents`** — an arc is a subagent boundary
(input→workspace→output). When enabled: delegate each arc's execution to a subagent, run independent
arcs as parallel subagents and pipeline dependent ones, and keep the orchestrator context lean by
reading back only each arc's `output/`.

## Commands (you run these, not the user)
```
arcs status                    board — run first, every session
arcs new-goal <slug>           new goal (multi-arc work)
arcs new-arc -g <goal> <slug>  arc inside a goal (one step)
arcs new-arc <slug>            standalone arc (one-off)
arcs close [-g <goal>] <slug>  finish an arc: status: done + rename NN-slug → __NN-slug__ (refuses an empty output/; -f overrides)
arcs reopen [-g <goal>] <slug> undo close: __NN-slug__ → NN-slug, status back to active
arcs rule list                 list rules + enabled state
arcs rule on/off <slug>        toggle a rule
arcs rule add <slug>           scaffold a new rule file
arcs init / arcs update        opt a project in / self-update (only on user request)
```
If `arcs` isn't on PATH, create the same dirs/files by hand per `SPEC.md` — the method still applies.
