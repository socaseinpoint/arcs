# Result — rules become global, toggled in config

Rule BODIES now live globally in the method repo (`<repo>/rules/<slug>.md`), versioned with
the method. The on/off SWITCH is the `rules=` line in `.arcs/config`. No more `enabled:` field
inside per-project rule files, no more copying bodies into every project.

Rationale (user): arcs is installed globally → rule definitions are global; a project just
opts in/out via config. DRY + portable toggles + `arcs update` ships new rules everywhere.

## Shipped
- Global library: moved `template/rules/subagents.md` → `<repo>/rules/subagents.md` (stripped
  `enabled:` line).
- `.arcs/config` gains a `rules=` comma list (e.g. `rules=subagents`). `arcs init` writes
  `rules=subagents` by default.
- Resolution: enabled slug → `.arcs/rules/<slug>.md` (local override) if present, else
  `<repo>/rules/<slug>.md` (global).
- CLI: `arcs rule list` (global+local, on/off from config), `arcs rule on/off <slug>` (edits
  config), `arcs rule add <slug>` (scaffolds a LOCAL custom rule, off until enabled).
- `arcs status` prints `rules:` from config.

## Bug fixed during build
`set -euo pipefail` + `pipefail` killed `cmd_rule` silently: the `list` loop ended on a false
`[ -f ]` and `off`'s `grep -vx` returns 1 when it filters everything → pipeline non-zero →
`set -e` exit. Guarded both with `|| true`.

## Migration
- Repo `.arcs/config` += `rules=subagents`; removed copied `.arcs/rules/subagents.md`.
- examples/basic `.arcs/config` set to `lang=en` + `rules=subagents`.

## Docs
SPEC.md + skill/SKILL.md rules sections + landing §04 updated (global bodies, config toggle).

## Verified
Temp-dir: init writes config rules=; list shows global subagents [on]; off clears config; on
restores; add creates local rule + enable appends to config list.
