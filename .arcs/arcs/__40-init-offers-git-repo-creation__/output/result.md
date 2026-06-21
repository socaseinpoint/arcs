# arcs init now offers git repo creation

## Change
`cmd_init` calls new helper `maybe_init_git` after initializing `.arcs/`.

`maybe_init_git`:
- skips if `git` not installed
- skips if already inside a git work tree (`git rev-parse --is-inside-work-tree`) — only asks when no repo exists here
- skips if no TTY (non-interactive)
- prompts `create one (git init + add + commit)? [y/N]` (default No)
- on yes: `git init && git add -A && git commit -m "chore: init arcs project"`

## Verified
- yes → repo created, single `chore: init arcs project` commit, `.arcs/` + README tracked
- no → no `.git` created
- existing repo → no prompt, repo untouched (no arcs commit)

## Files
- bin/arcs: `maybe_init_git` helper + call in `cmd_init`; help line updated
