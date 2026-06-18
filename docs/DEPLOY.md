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
arcs init                         # creates .arcs/ + asks the arc language (en/ru/es)
arcs lang ru                      # ...or set/change it explicitly, anytime
arcs new-goal payments            # multi-arc work → .arcs/goals/01-payments/
arcs new-arc -g payments stripe   # an arc inside the goal
arcs new-arc spike-redis          # a standalone arc → .arcs/arcs/NN-...
arcs status                       # board: what's done, the bottleneck, and the language
```
The language sets what arcs are written in (templates + the prose agents produce). Field keys
(`goal:`, `status:`) stay English so the tooling never breaks.
Then follow `SPEC.md`: input → workspace → output, outward only via output.

## Enforcement (recommended)
Three layers, weakest to strongest:
1. **skill** — *advises* the agent to use arcs.
2. **`arcs-hook`** (SessionStart + UserPromptSubmit) — injects a reminder + the live board each
   session/prompt in an opted-in project, so the agent can't quietly forget.
3. **`arcs-gate`** (PreToolUse `Edit|Write|MultiEdit`) — *hard* block: refuses edits to project files
   while `.arcs/` has no active arc, forcing the agent to `arcs new-arc`/`new-goal` first. Edits to
   files inside `.arcs/` are always allowed; projects without `.arcs/` are never affected.

`install.sh` registers both hooks automatically (in `~/.claude/settings.json`, `.bak` backup, idempotent).
To add by hand, merge into `~/.claude/settings.json` (replace `<DIR>` with your clone path):
```json
{
  "hooks": {
    "SessionStart":     [{ "hooks": [{ "type": "command", "command": "<DIR>/hooks/arcs-hook" }] }],
    "UserPromptSubmit": [{ "hooks": [{ "type": "command", "command": "<DIR>/hooks/arcs-hook" }] }],
    "PreToolUse":       [{ "matcher": "Edit|Write|MultiEdit", "hooks": [{ "type": "command", "command": "<DIR>/hooks/arcs-gate" }] }]
  }
}
```
After wiring, restart your Claude Code session.

## Updating
One command, from anywhere — the CLI knows where it was cloned:
```bash
arcs update          # git pull + re-wire PATH, skill, and hook (idempotent)
```
Then restart your Claude Code session so it picks up the new skill + hook. Your projects' `.arcs/`
data is untouched.

## Requirements
bash + standard coreutils (grep, sed). macOS / Linux. No build step.

## Project .gitignore
`.arcs/` is usually **committed** (it's the memory of the work). If you don't want that, add `.arcs/`
to the project's `.gitignore`.
