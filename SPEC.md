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
    config           the arc language (en|ru|es) + `rules=` toggle line
    rules/           LOCAL rule overrides / custom rules (built-ins live globally in the method repo)
    arcs/            ONE continuous stream:
      NN-<slug>/       an arc  (work without a purpose)
      NN-@<slug>/      a goal  (an arc with a purpose) — @ marks it
  <project code>
```
There is no separate `goals/` directory — arcs and goals share the single `arcs/` stream.
Tooling (the `arcs` CLI, the skill) stays outside, in the method repo; a project gets only `.arcs/`.

---

## Two primitives

### Arc — atom of work
Work without a purpose. One finished chunk. Folder `NN-<slug>/` in the stream (numbering `01`, `02`…
+ a descriptive slug naming the content).

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
closes: goal <NN-@slug> step <N>   ← if it's a sub-arc of a goal
## output → pointers
- `output/...` — what goes outward
```
Everything else (how, flow, notes, iterations) → `workspace/`.

**Lifecycle (the rhythm):**
```
open arc → fix input → work in workspace → close → self-contained output
  → update arc.md → (if inside a goal) pull a pointer into the goal → next
```
**Closing marks done two ways at once:** wrap the folder in `__…__` (`NN-<slug>` → `__NN-<slug>__`,
or `NN-@<slug>` → `__NN-@<slug>__`, two underscores each side) **and** set status done — in `arc.md`
for an arc, in the current `MM-<slug>-goal.md` for a goal. The `__…__` name makes done-state visible
in `ls`; the status doc stays the machine source of truth — both agree. Reopening undoes both: strip
the `__…__`, status back to active.

### One stream, two kinds of entry
Everything lives in `.arcs/arcs/` under **one continuous numbering sequence** — arcs and goals draw
from the same counter, so an arc and a goal never share a number.

- **`NN-<slug>/`** — an **arc**: work *without* a purpose. Need an answer but don't want it lost in the
  ephemeral chat → drop one. One-shot, self-contained.
- **`NN-@<slug>/`** — a **goal**: an arc *with* a purpose. The `@` prefix marks it as a goal, visible
  right in the name (the way `__…__` marks closed). Meaningful multi-arc work; carries its own nested
  `arcs/` substream.

**Slugs must be descriptive.** Multi-word, content-rich, meaningful (`extract-auth-from-monolith`),
never generic (`fix`, `stuff`, `tmp`). The name is the at-a-glance index of the stream.

---

## Goal — for complex work that won't fit one arc
**Arc = work without a purpose. Goal = work pursued through an arc that has a purpose** — it organizes
sub-arcs toward that purpose. Same skeleton as an arc (`input/ workspace/ output/`), plus its own
`arcs/` substream and a versioned status doc. For running a project / deep research. The `@` in the
name marks it a goal — folder `arcs/NN-@<slug>/`:

| | Role |
|---|---|
| `MM-<slug>-goal.md` | **goal + "what's done / where we are"**, briefly. Versioned by leading number (`MM`). |
| `input/` | what entered the goal — seed, context, requirements (like an arc) |
| `workspace/` | helper files for the goal (method, drafts) |
| `output/` | **self-contained** final deliverable, once the goal closes (like an arc) |
| `arcs/` | sub-arcs of this goal, numbered locally `01`, `02`… |

Arc vs goal: a goal is an arc with a purpose — `@` in its name, a nested `arcs/` substream, and a
versioned status doc. Encapsulation is the same: outward only through `output/`.

### Versioning a goal (by number, not by editing)
- Files inside the goal folder: `01-<slug>-goal.md`, `02-<slug>-goal.md`, `03-<slug>-goal.md`…
  (e.g. `01-cv-goal.md`). This `MM` is a private version axis, separate from the stream number `NN`.
- **Highest number = current = authoritative.** Old ones = history, never touched.
- Update a goal = drop a new version next to it. No agonizing over in-place edits.
- Change rarely and deliberately. A version captures a pivot.

The current `MM-<slug>-goal.md` always answers briefly: the goal, which sub-arcs are open, where I am globally.

---

## Rules — optional behavior layer
The base method (arc · goal · encapsulation · versioning) is tooling-independent and complete on its
own. **Rules** are an opt-in layer on top: per-project behaviors an agent follows while working. They
change nothing about the method's essence — turn them all off and the method runs exactly as above.

**Rule bodies are global.** They ship in the method repo at `<arcs-repo>/rules/<slug>.md`, versioned
with the method — so `arcs update` brings new and updated rules to every project at once (arcs is
installed globally, so rule definitions live globally, not copied into each project). A rule file is
just a heading plus body — no toggle inside it:
```markdown
# <slug>

<body — the behavior an agent must follow when this rule is enabled>
```

**The switch is per project, in `.arcs/config`** — one `rules=` line, a comma-separated list of the
enabled slugs (the single toggle panel for the project):
```
rules=subagents
```
**Local override / custom rules:** drop `.arcs/rules/<slug>.md` to override a global rule of the same
name, or to add a project-only one — local takes precedence over the global body. **Resolution:** for
each enabled slug, read `.arcs/rules/<slug>.md` if present, else `<repo>/rules/<slug>.md`; obey that body.

Toggling never edits a rule file — it edits the `rules=` line in `.arcs/config`:
```
arcs rule list            global + local rules, with on/off read from config
arcs rule on <slug>       add the slug to config `rules=`
arcs rule off <slug>      remove it from config `rules=`
arcs rule add <slug>      scaffold a LOCAL custom rule under .arcs/rules/ (left off until you rule on it)
```

**Built-in rule `subagents`** is the global default — `arcs init` writes `rules=subagents` into
`.arcs/config`, and its body lives globally at `<repo>/rules/subagents.md`. It is the agentic execution of the method:
an arc is already encapsulated (`input → workspace → output`, the outside reads only `output/`), so the
**arc boundary IS a subagent boundary**. With the rule on, an agent dispatches one subagent per arc —
independent arcs as parallel subagents, dependent arcs pipelined — while the orchestrator reads back
only each arc's `output/`. The method still works with it off: run the arcs inline, same files, same
encapsulation.

## Invariants
- `output/` contains no fact/claim not grounded in `input/` or the process.
- `workspace/` is disposable: any artifact is re-generable; never hand-tweak the final in `output/` outside the process.
- `arc.md` / `MM-<slug>-goal.md` is the single source of status.
- Numbering is **one continuous stream across arcs AND goals** in a given `arcs/`. It counts every
  entry — open arcs `NN-*`, open goals `NN-@*`, and closed `__…__` of either kind. Closing renames but
  never frees a number; an arc and a goal never reuse one. (A goal's nested `arcs/` is its own local
  stream, numbered `01`, `02`… independently.)

## Why this way
- **Don't get lost:** surfacing from a sub-arc → open the goal's current `MM-<slug>-goal.md` → see the whole picture.
- **Hands off cleanly:** `output/` is self-contained → another agent/session continues without chat context.
- **Automatable:** a script scans `arc.md`/`goal.md` → statuses, open items, pointers (`arcs status`).

## Using it in a project (CLI)
```
arcs init [en|ru|es]          create .arcs/ + pick the arc language (asks if a TTY)
arcs lang [en|ru|es]          show or change this project's arc language
arcs new-arc <slug>           arc in the stream → NN-<slug>
arcs new-goal <slug>          goal in the stream → NN-@<slug>
arcs new-arc -g <goal> <slug> sub-arc inside a goal's nested arcs/ (local 01,02…)
arcs close [-g <goal>] <slug> close: wrap in __…__ + status done (goal → its status doc; refuses empty output/; -f overrides)
arcs reopen [-g <goal>] <slug> reopen: strip __…__ + status active
arcs rule list                global + local rules, on/off read from .arcs/config
arcs rule on|off <slug>       add/remove the slug in config's rules= line
arcs rule add <slug>          scaffold a LOCAL custom rule under .arcs/rules/ (off until rule on)
arcs status                   the single STREAM board (also shows the language)
arcs update                   git pull the method + re-wire skill/hooks
```
**Language.** Each project picks the language its arcs are written in (`en`, `ru`, or `es`) at
`arcs init`, stored in `.arcs/config`. Templates and arc prose follow it; the field keys
(`goal:`, `status:`) stay English so the tooling is language-agnostic. Change anytime: `arcs lang <code>`.
Setup, updating, and the enforcement hooks (skill / arcs-hook / arcs-gate) — `docs/DEPLOY.md`.
