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
2. Read the enabled rules from `.arcs/config` (`rules=`), then read each one's body (local
   `.arcs/rules/<slug>.md` or the global `<repo>/rules/<slug>.md`) and **obey it** for the whole session (see `## Rules`).
3. Trivial one-liner (a fact, a tiny edit)? Skip arcs. Anything real — a feature, a bug hunt,
   research, a refactor, a multi-step task — **must** run inside an arc. Don't rationalize past this.
4. **Open the container first, before working** (arc = work with NO purpose; goal = an arc WITH a purpose):
   - one self-contained chunk, no overarching purpose → `arcs new-arc <slug>` (creates `NN-<slug>/`)
   - a purpose with multiple steps → `arcs new-goal <slug>` (creates `NN-@<slug>/`), then
     `arcs new-arc -g <slug> <step>` for each nested arc in the goal's substream
   - **Slugs must be descriptive / content-rich** — multi-word and meaningful (`rewrite-landing-hero`,
     `trace-auth-token-leak`), never `fix`, `stuff`, `task`, `tmp`. The slug is how the work is found later.
5. Write the user's request/spec into the arc's `input/`. Start a plan/notes file in `workspace/`.
6. Do the work — keeping notes flowing into `workspace/` as you go, not dumped at the end. Finish an
   arc by writing `output/` then `arcs close <slug>`. (Future-work idea surfaces mid-task → `arcs candidate`, not a workspace note — see `## Candidates`.)

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

**`workspace/` is disposable thinking — it dies with the arc.** Two rules fall out of that:
- If a workspace note ends up just restating `output/`, delete it — don't keep a second copy of the
  conclusion. Workspace is scratch, not a duplicate of the result.
- **Anything a later arc will consume must be an `output/` file, never a `workspace/` one.** If you find
  yourself pointing a future arc at a workspace file, it wanted to be its own arc's output. Cross-arc
  handoff goes through `output/` only.

A coding task is done = code written AND the arc carries `output/` + `arc.md status: done`. You set
that done-state by running `arcs close <slug>` (writes `status: done` and wraps the name in `__…__`:
`NN-<slug>` → `__NN-<slug>__`, a goal `NN-@<slug>` → `__NN-@<slug>__`, so finished work is visible at a
glance in `ls`). Reverse with `arcs reopen <slug>`. Numbering counts closed entries, so numbers are never reused.
**`.arcs/` still empty when you finish = you skipped the method. That's the failure mode. Don't.**

## Two primitives — one stream
`.arcs/` holds `config`, `rules/`, and `arcs/` — **a single numbered stream**. There is no separate
goals directory; arcs and goals share continuous numbering in `.arcs/arcs/`.
- **arc** — work with NO purpose: `NN-<slug>/` = `input/` → `workspace/` → `output/` (the outside reads
  ONLY `output/`) + `arc.md`. Encapsulation: anything the next step needs must be derivable from `output/` alone.
- **goal** — an arc WITH a purpose: `NN-@<slug>/` (the `@` marks a goal). Same skeleton + its own nested
  `arcs/` substream + one immutable status file `<slug>-goal.md`. A goal is an
  immutable contract: a `goal:` line + a short "where we are". Don't rewrite intent in place — when the
  aim changes, `arcs supersede <old> <new>` closes the old and opens a new one linked by `supersedes:`
  (a traceable chain). A goal's **checklist IS its sub-arcs** — open each item as a sub-arc up front
  (`arcs new-arc -g <goal> <slug>`); an item is done when its sub-arc is closed (`__…__`). Nothing is
  hand-ticked — `arcs status` reads `N/M ✓` (closed / total sub-arcs) straight from disk.
  Keep `goal:` lines short — ≤12 words; push long framing into `## Where we are`.

## Candidates (surfaced future work)
**THE RULE:** when an idea for FUTURE work surfaces mid-task, do NOT bury it in the current arc's
`workspace/` — that's private and dies when the arc closes. Capture it as a **candidate** so it surfaces
on the board, then promote it when you actually start it. Candidates live in `.arcs/candidates/` as
numbered `NN-<slug>.md` (their own sequence), each carrying a `from:` field (the arc it surfaced from).
- `arcs candidate <slug> --from <current-arc> [text]` — capture one (text = the idea).
- `arcs status` shows them in a CANDIDATES section; `arcs candidate list` lists them.
- `arcs promote [-g <goal>] <slug>` — turn a candidate into a real arc: creates the arc, moves the
  candidate file into its `input/`, removes it from `candidates/`. Promote only when you start the work.

## Rules (toggleable behavior layer)
A rule is a markdown body describing a behavior you must follow. **Bodies are global** — shipped in
the method repo at `<repo>/rules/<slug>.md` (skill is symlinked from `<arcs-repo>/skill`, so the
global rules dir is at `../rules/`), so `arcs update` ships new rules to every project at once. The
**switch** is the `rules=` line in `.arcs/config` — a comma list of enabled slugs (e.g.
`rules=subagents`). A project may **override or add** a rule with a local body at `.arcs/rules/<slug>.md`
(local wins over a global of the same name). At session start read `rules=`, then for each slug read
its body (local if present, else global) and **obey it**. Manage with `arcs rule list / on <slug> /
off <slug> / add <slug>` (you run these, not the user).

Shipped enabled by default: **`subagents`** (global body) — an arc is a subagent boundary
(input→workspace→output). When enabled: delegate each arc's execution to a subagent, run independent
arcs as parallel subagents and pipeline dependent ones, and keep the orchestrator context lean by
reading back only each arc's `output/`.

## Commands (you run these, not the user)
```
arcs status                    board — one stream of arcs + goals; run first, every session
arcs new-goal <slug>           new goal: NN-@<slug>/ in the shared stream (a purpose with its own substream)
arcs new-arc -g <goal> <slug>  arc inside a goal's substream (one step)
arcs new-arc <slug>            standalone arc: NN-<slug>/ (work with no purpose)
arcs close [-g <goal>] <slug>  finish: status: done + wrap name in __…__ (refuses an empty output/; -f overrides)
arcs reopen [-g <goal>] <slug> undo close: __…__ → unwrapped name, status back to active
arcs supersede [-g <goal>] <old> <new>  aim changed: close <old> + open <new> linked by supersedes: (traceable chain)
arcs candidate <slug> [--from <arc>]  capture a surfaced future-work idea into .arcs/candidates/
arcs candidate list            list captured candidates
arcs promote [-g <goal>] <slug>  candidate → real arc (creates it, moves the file into input/, drops from candidates/)
arcs rule list                 list global + local rules with on/off state
arcs rule on/off <slug>        toggle a rule (edits the `rules=` switch in .arcs/config)
arcs rule add <slug>           scaffold a LOCAL custom rule (.arcs/rules/<slug>.md, off until enabled)
arcs init / arcs update        opt a project in / self-update (only on user request)
```
If `arcs` isn't on PATH, create the same dirs/files by hand per `SPEC.md` — the method still applies.
