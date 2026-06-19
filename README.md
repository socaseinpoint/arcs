# arcs

A file-based method for running work. Two primitives — **arc** (atom of work) and **goal** (an arc
with a purpose that holds nested arcs). Both live in one numbered stream inside `.arcs/arcs/`: arcs are
`NN-<slug>/`, goals are `NN-@<slug>/` (the `@` marks a goal), sharing one sequence. State lives in
files, not in an ephemeral chat. Tool-independent. All work lives in a hidden `.arcs/` — **it never
clutters project code**.

🔗 **Landing:** [arcs-delta.vercel.app](https://arcs-delta.vercel.app)

## Quick start

```bash
# 1. install (clone anywhere, then run the installer)
git clone https://github.com/socaseinpoint/arcs ~/arcs
cd ~/arcs && ./install.sh        # adds `arcs` to PATH (+ Claude skill if present)
exec $SHELL                      # reload shell so `arcs` is found

# 2. use it in any project
cd my-project
arcs init                        # creates .arcs/ and asks the arc language (en/ru/es)
arcs new-goal payments           # start multi-arc work (NN-@payments)
arcs new-arc spike-redis         # or a one-off standalone arc (NN-spike-redis)
arcs candidate retry-webhooks --from spike-redis   # park an idea that popped up mid-work
arcs promote retry-webhooks      # turn a parked idea into a real arc
arcs close spike-redis           # wrap a finished arc: NN-slug -> __NN-slug__
arcs status                      # what's done, where you are, candidates, the language
arcs lang es                     # change the language anytime
```
Pick the language your arcs are written in at `init` (`en`/`ru`/`es`) — agents then keep the arc
content in it. Change later with `arcs lang <code>`.

Update later — one command, from anywhere:
```bash
arcs version                     # what you have installed
arcs update                      # git pull + re-wire PATH, skill, and hooks (idempotent)
```
(then restart your Claude Code session so it reloads the skill)

Each session a throttled check (≤1/day) nudges you when a newer release exists — no action needed,
just a one-line `update available: arcs X` on the board. A release that breaks compatibility raises
`MIN_VERSION`; installs below it are hard-blocked from editing until `arcs update`.

Needs bash + grep/sed (macOS/Linux). No build step. Full guide: `docs/DEPLOY.md`. Method: `SPEC.md`.

## In 20 seconds
```
.arcs/                       meta dir at the project root
  arcs/                      one numbered stream — arcs and goals share the sequence
    NN-slug/                 atom: input → workspace → output (outward only via output) + arc.md
    NN-@slug/                a goal (@ marks it): an arc with a purpose + its own nested arcs/
      slug-goal.md           immutable status: a goal: line + where we are
      input/ workspace/ output/ arcs/
    __NN-slug__/             a closed arc/goal (wrapped in __…__ = done)
  candidates/NN-slug.md      backlog of surfaced ideas, each with a from: line
  config                     lang= and rules= switches
```
Surface from work → open the goal's `slug-goal.md` → see where you are. Don't get lost. A goal is
immutable: aim changed → `arcs supersede <old> <new>` (a linked chain), never an in-place rewrite;
its checklist *is* its sub-arcs — each closed one ticks itself, progress (`N/M ✓`) read from disk by `arcs status`.
An idea that pops up mid-work goes to `candidates/` so it isn't buried in a closed arc's
`workspace/`; promote it later into a real arc's `input/`. Behavior **rules** have global bodies
in `<repo>/rules/`, toggled per project via `rules=` in `.arcs/config`.

## This repo
```
arcs/                        tooling + spec, lives outside your projects
  SPEC.md                    the full method
  bin/arcs                   CLI: init · new-arc · new-goal · close · reopen · candidate · promote · rule · status · lang · version · check-update · update
  install.sh                 PATH + Claude skill setup
  rules/                     global rule bodies (toggled per project via .arcs/config rules=)
  template/README.md         project-README template for an arcs-using repo
  skill/SKILL.md             Claude skill (advises the agent)
  hooks/arcs-hook            reminder hook (SessionStart + UserPromptSubmit)
  hooks/arcs-gate            hard gate (PreToolUse: no edits until an arc is open)
  docs/DEPLOY.md             setup guide
  examples/basic/            a filled-in .arcs walkthrough
```

Three enforcement layers (wired by `install.sh`): the **skill** advises, **arcs-hook** reminds every
session/prompt, **arcs-gate** hard-blocks edits to project files until an arc is open. In a project
without `.arcs/` nothing fires — `arcs init` is the opt-in.

Landing (what & why, RU/EN): https://arcs-delta.vercel.app
