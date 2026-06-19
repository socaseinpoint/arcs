# Result — rules system + subagents rule

Built a toggleable **rules layer** for arcs (pivoted from "hardcode subagents"). Rules are
opt-in behaviors; the base method is unchanged with all rules off.

## Shipped
- **`.arcs/rules/<slug>.md`** format: `# <slug>` + `enabled: true|false` + body.
- **CLI `arcs rule`**: `list` · `on <slug>` · `off <slug>` · `add <slug>` (add scaffolds `enabled: false`).
- **`arcs init`** seeds `.arcs/rules/subagents.md` (enabled) from `template/rules/subagents.md`.
- **`arcs status`** prints a `rules: <enabled...>` line.
- **`subagents` rule** (template/rules/subagents.md): arc boundary = subagent boundary →
  one subagent per arc, parallel independent arcs, pipeline dependent, orchestrator reads only `output/`.
- Skill + spec document the rules layer + the obey-on-session-start contract.

## Decisions (user)
- Storage: rule files in `.arcs/rules/` (not config flags). 
- subagents rule: ON by default at init.

## Pointers — changed files
- `bin/arcs` (rule subcommand, init seed, status line)
- `template/rules/subagents.md` (new)
- `skill/SKILL.md` (§ Rules + session-start step + commands) — via parallel subagent
- `SPEC.md` (§ Rules — optional behavior layer) — via parallel subagent
- `.arcs/rules/subagents.md` (this repo seeded)

## Verified
Temp-dir test: init seeds + enables subagents, status shows it, `rule off/on/list` work.
