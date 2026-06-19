# arcs — method specification

> A file-based method for running work, **independent of tooling** (agents, chats, IDEs are
> implementation details, not part of the method). State lives in files, not in an ephemeral chat.
> Two primitives: **arc** and **goal**. What matters: numbering, titles, `input/workspace/output`,
> encapsulation, versioned status.

## Meta directory `.arcs/`
All method work lives in a hidden `.arcs/` at the project root — **so it never clutters the code**:
```
<project>/
  .arcs/
    arcs/    standalone arcs
    goals/   multi-arc goals
  <project code>
```
Tooling (the `arcs` CLI, the skill) stays outside, in the method repo; a project gets only `.arcs/`.

---

## Two primitives

### Arc — atom of work
One finished chunk. Folder `NN-<title>/` (numbering `01`, `02`… + a title describing the content).

| Folder / file | Role | OOP analogue |
|---|---|---|
| `input/` | what entered the work context — seed, requirements, ancestor artifacts | constructor args |
| `workspace/` | all work in progress — artifacts dumped here | private state |
| `output/` | **self-contained** result — the outside reads ONLY this | public interface |
| `arc.md` | small pointer: goal · status · pointers to key output | — |

**Encapsulation (hard rule):** anything the next step needs must be **derivable from `output/` alone**.
`workspace/` is private, never leaks out. `input/` is what came in. Close the arc → `output/` stands on its own.

**`arc.md` — passport (minimal, does not grow):**
```markdown
# NN-<slug>
goal:   <one line — what we close>
status: active | blocked | done
closes: goal <NN-slug> step <N>   ← if it's a goal's arc
## output → pointers
- `output/...` — what goes outward
```
Everything else (how, flow, notes, iterations) → `workspace/`.

**Lifecycle (the rhythm):**
```
open arc → fix input → work in workspace → close → self-contained output
  → update arc.md → (if inside a goal) pull a pointer into the goal → next
```
**Closing marks done two ways at once:** rename the folder `NN-<slug>` → `__NN-<slug>__`
(two underscores each side) **and** set `status: done` in `arc.md`. The `__…__` name makes
done-state visible in `ls`; `arc.md status: done` stays the machine source of truth — both agree.
Reopening undoes both: `__NN-<slug>__` → `NN-<slug>`, `status:` back to active.

### Two homes for arcs
- **`.arcs/arcs/`** — standalone arcs. Need an answer but don't want it lost in the ephemeral chat →
  drop a separate arc. One-shot, no goal.
- **`.arcs/goals/NN-<title>/arcs/`** — arcs inside a goal. Meaningful multi-arc work.

---

## Goal — for complex work that won't fit one arc
**Goal = an arc with a purpose.** Same skeleton as an arc (`input/ workspace/ output/`), plus its own
`arcs/` and a versioned status doc. For running a project / deep research. Folder `goals/NN-<title>/`:

| | Role |
|---|---|
| `NN-<slug>-goal.md` | **goal + "what's done / where we are"**, briefly. Versioned by leading number. |
| `input/` | what entered the goal — seed, context, requirements (like an arc) |
| `workspace/` | helper files for the goal (method, drafts) |
| `output/` | **self-contained** final deliverable, once the goal closes (like an arc) |
| `arcs/` | arcs of this goal (sub-work by steps) |

Arc vs goal: a goal has `arcs/` (multi-arc) + a versioned status doc. Encapsulation is the same:
outward only through `output/`.

### Versioning a goal (by number, not by editing)
- Files: `01-<slug>-goal.md`, `02-<slug>-goal.md`, `03-<slug>-goal.md`… (e.g. `01-cv-goal.md`).
- **Highest number = current = authoritative.** Old ones = history, never touched.
- Update a goal = drop a new version next to it. No agonizing over in-place edits.
- Change rarely and deliberately. A version captures a pivot.

The current `NN-<slug>-goal.md` always answers briefly: the goal, which arcs are open, where I am globally.

---

## Rules — optional behavior layer
The base method (arc · goal · encapsulation · versioning) is tooling-independent and complete on its
own. **Rules** are an opt-in layer on top: per-project behaviors an agent follows while working. They
change nothing about the method's essence — turn them all off and the method runs exactly as above.

Rules live as markdown in `.arcs/rules/<slug>.md`:
```markdown
# <slug>
enabled: true | false

<body — the behavior an agent must follow when this rule is enabled>
```
Toggled per project; enabling/disabling just flips the `enabled:` line:
```
arcs rule list            show rules + enabled state
arcs rule on <slug>       enabled: true
arcs rule off <slug>      enabled: false
arcs rule add <slug>      scaffold a new rule (enabled: false)
```

**Built-in rule `subagents`** ships enabled at `arcs init`. It is the agentic execution of the method:
an arc is already encapsulated (`input → workspace → output`, the outside reads only `output/`), so the
**arc boundary IS a subagent boundary**. With the rule on, an agent dispatches one subagent per arc —
independent arcs as parallel subagents, dependent arcs pipelined — while the orchestrator reads back
only each arc's `output/`. The method still works with it off: run the arcs inline, same files, same
encapsulation.

## Invariants
- `output/` contains no fact/claim not grounded in `input/` or the process.
- `workspace/` is disposable: any artifact is re-generable; never hand-tweak the final in `output/` outside the process.
- `arc.md` / `NN-slug-goal.md` is the single source of status.
- Numbering is contiguous within one `arcs/` and counts **both** open `NN-*` and closed `__NN-*__`
  entries — closing renames but never frees a number, so numbers are never reused.

## Why this way
- **Don't get lost:** surfacing from an arc → open the current `NN-<slug>-goal.md` → see the whole picture.
- **Hands off cleanly:** `output/` is self-contained → another agent/session continues without chat context.
- **Automatable:** a script scans `arc.md`/`goal.md` → statuses, open items, pointers (`arcs status`).

## Using it in a project (CLI)
```
arcs init [en|ru|es]          create .arcs/ + pick the arc language (asks if a TTY)
arcs lang [en|ru|es]          show or change this project's arc language
arcs new-arc <slug>           standalone arc in .arcs/arcs/
arcs new-arc -g <goal> <slug> arc inside a goal
arcs new-goal <slug>          goal in .arcs/goals/
arcs close [-g <goal>] <slug> close an arc: rename NN-slug → __NN-slug__ + status: done (refuses empty output/; -f overrides)
arcs reopen [-g <goal>] <slug> reopen: __NN-slug__ → NN-slug + status: active
arcs rule list                rules + enabled state
arcs rule on|off <slug>       flip a rule's enabled: line
arcs rule add <slug>          scaffold a new rule (disabled)
arcs status                   the status board (also shows the language)
arcs update                   git pull the method + re-wire skill/hooks
```
**Language.** Each project picks the language its arcs are written in (`en`, `ru`, or `es`) at
`arcs init`, stored in `.arcs/config`. Templates and arc prose follow it; the field keys
(`goal:`, `status:`) stay English so the tooling is language-agnostic. Change anytime: `arcs lang <code>`.
Setup, updating, and the enforcement hooks (skill / arcs-hook / arcs-gate) — `docs/DEPLOY.md`.
