# arcs

A file-based method for running work. Two primitives — **arc** (atom of work) and **goal** (an arc
with a purpose that holds nested arcs). State lives in files, not in an ephemeral chat. Tool-independent.
All work lives in a hidden `.arcs/` — **it never clutters project code**.

## Quick start

```bash
# 1. install (clone anywhere, then run the installer)
git clone https://github.com/socaseinpoint/arcs ~/arcs
cd ~/arcs && ./install.sh        # adds `arcs` to PATH (+ Claude skill if present)
exec $SHELL                      # reload shell so `arcs` is found

# 2. use it in any project
cd my-project
arcs init                        # creates .arcs/ and asks the arc language (en/ru/es)
arcs new-goal payments           # start multi-arc work
arcs new-arc spike-redis         # or a one-off standalone arc
arcs status                      # see what's done, where you are, and the language
arcs lang es                     # change the language anytime
```
Pick the language your arcs are written in at `init` (`en`/`ru`/`es`) — agents then keep the arc
content in it. Change later with `arcs lang <code>`.

Update later — one command, from anywhere:
```bash
arcs update                      # git pull + re-wire PATH, skill, and hooks (idempotent)
```
(then restart your Claude Code session so it reloads the skill)

Needs bash + grep/sed (macOS/Linux). No build step. Full guide: `docs/DEPLOY.md`. Method: `SPEC.md`.

## In 20 seconds
```
.arcs/                       meta dir at the project root
  arcs/NN-slug/              atom: input → workspace → output (outward only via output) + arc.md
  goals/NN-slug/             an arc with a purpose + its own arcs
    NN-slug-goal.md          brief status, version = leading number (highest = current)
    input/ workspace/ output/ arcs/
```
Surface from work → open the current `*-goal.md` → see where you are. Don't get lost.

## This repo
```
arcs/                        tooling + spec, lives outside your projects
  SPEC.md                    the full method
  bin/arcs                   CLI: init · new-arc · new-goal · status
  install.sh                 PATH + Claude skill setup
  template/.arcs/            skeleton (arcs/ + goals/)
  skill/SKILL.md             Claude skill (advises the agent)
  hooks/arcs-hook            reminder hook (SessionStart + UserPromptSubmit)
  hooks/arcs-gate            hard gate (PreToolUse: no edits until an arc is open)
  docs/DEPLOY.md             setup guide
  examples/basic/            a filled-in .arcs walkthrough
```

Three enforcement layers (wired by `install.sh`): the **skill** advises, **arcs-hook** reminds every
session/prompt, **arcs-gate** hard-blocks edits to project files until an arc is open. In a project
without `.arcs/` nothing fires — `arcs init` is the opt-in.

Landing (what & why, RU/EN): https://arcs-socaseinpoints-projects.vercel.app
