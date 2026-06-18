# Deploy arcs for a new project

The tooling lives in this repo (`~/Documents/projects/arcs`). A project gets only `.arcs/`.
The method never clutters the code: all bookkeeping sits in the hidden `.arcs/`, the CLI/skill stay outside.

## 1. Put the CLI on PATH (once)
Add to `~/.zshrc`:
```bash
export PATH="$HOME/Documents/projects/arcs/bin:$PATH"
```
Restart the shell → `arcs` is available anywhere.

Check:
```bash
arcs help
```

## 2. Enable the method in a project
From the project root:
```bash
cd my-project
arcs init                 # creates .arcs/{arcs,goals} + a README pointer
```

## 3. Work
```bash
arcs new-goal payments            # multi-arc work → .arcs/goals/01-payments/
arcs new-arc -g payments stripe   # an arc inside the goal
arcs new-arc spike-redis          # a standalone arc → .arcs/arcs/NN-...
arcs status                       # board: what's done, where the bottleneck is
```
Then follow `SPEC.md`: input → workspace → output, outward only via output.

## 4. Claude skill (optional)
The skill source is `skill/SKILL.md` in this repo. Install it globally via a symlink (not a copy,
so edits in the repo are picked up immediately):
```bash
ln -s ~/Documents/projects/arcs/skill ~/.claude/skills/arcs
```
After that the agent knows the method and calls the CLI itself.

## Project .gitignore
`.arcs/` is usually **committed** (it's the memory of the work). If you don't want that, add `.arcs/`
to `.gitignore`.
