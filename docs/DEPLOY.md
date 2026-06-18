# Set up arcs on your machine

The tooling lives in this repo (clone it anywhere — `~/arcs`, `~/code/arcs`, whatever).
A project only ever gets a hidden `.arcs/` dir. The method never clutters your code.

## Quick install (one command)
```bash
git clone https://github.com/socaseinpoint/arcs ~/arcs
cd ~/arcs && ./install.sh
```
`install.sh` adds `arcs` to your PATH (in `~/.zshrc` / `~/.bashrc`) and, if `~/.claude/skills`
exists, symlinks the Claude skill. Open a new shell afterwards.

## Manual install (if you prefer)
Clone wherever you like, then point PATH at that clone's `bin/`:
```bash
git clone https://github.com/socaseinpoint/arcs <DIR>
echo 'export PATH="<DIR>/bin:$PATH"' >> ~/.zshrc   # use your real <DIR>
source ~/.zshrc
# optional Claude skill:
ln -s <DIR>/skill ~/.claude/skills/arcs
```

Check:
```bash
arcs help
```

## Use it in a project
From the project root:
```bash
cd my-project
arcs init                         # creates .arcs/{arcs,goals} + a README pointer
arcs new-goal payments            # multi-arc work → .arcs/goals/01-payments/
arcs new-arc -g payments stripe   # an arc inside the goal
arcs new-arc spike-redis          # a standalone arc → .arcs/arcs/NN-...
arcs status                       # board: what's done, where the bottleneck is
```
Then follow `SPEC.md`: input → workspace → output, outward only via output.

## Updating
One command, from anywhere — the CLI knows where it was cloned:
```bash
arcs update          # git pull the method + relink the Claude skill
```
Then restart your Claude Code session so it picks up the new skill. Your projects' `.arcs/` data
is untouched.

## Requirements
bash + standard coreutils (grep, sed). macOS / Linux. No build step.

## Project .gitignore
`.arcs/` is usually **committed** (it's the memory of the work). If you don't want that, add `.arcs/`
to the project's `.gitignore`.
