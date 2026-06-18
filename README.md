# arcs

A file-based method for running work. Two primitives — **arc** (atom of work) and **goal** (an arc
with a purpose that holds nested arcs). State lives in files, not in an ephemeral chat. Tool-independent.
All work lives in a hidden `.arcs/` — **it never clutters project code**.

```
arcs/                        ← this repo (tooling + spec, lives outside projects)
  SPEC.md                    the full method
  bin/arcs                   CLI: init · new-arc · new-goal · status
  template/.arcs/            skeleton (arcs/ + goals/)
  skill/SKILL.md             Claude skill (symlink into ~/.claude/skills/)
  docs/DEPLOY.md             how to deploy for a new project
```

## In 20 seconds
```
.arcs/                       meta dir at the project root
  arcs/NN-slug/              atom: input → workspace → output (outward only via output) + arc.md
  goals/NN-slug/             an arc with a purpose + its own arcs
    NN-slug-goal.md          brief status, version = leading number (highest = current)
    input/ workspace/ output/ arcs/
```
Surface from work → open the current `*-goal.md` → see where you are. Don't get lost.

## Start
```bash
export PATH="$HOME/Documents/projects/arcs/bin:$PATH"   # once, in ~/.zshrc
cd my-project && arcs init
arcs new-goal <slug>     # or: arcs new-arc <slug>
arcs status
```
Details — `docs/DEPLOY.md`.
