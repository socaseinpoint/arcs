# Pivot — from "bake in subagents" to "toggleable rules system"

## User steer (ru, verbatim)
"эта тема с тем что юзать сабагентов — это правка которая меняет суть арка и как будто
должна быть включаемым/выключаемым правилом, и потом я могу ещё захотеть добавить,
мне кажется это правильный дизайн"

## Reframe
- Subagent-delegation changes the *essence* of how arcs executes → must NOT be hardcoded.
- It's one **rule**: an opt-in/opt-out behavior layered on the method.
- Design must be **extensible**: user adds more rules over time.
- So: build a **rules system** for arcs. `subagents` (delegate + parallelize) = rule #1.

## Method-purity guard
The base method stays tooling-independent (arc/goal/encapsulation). Rules are an
optional behavior layer on top — enabled per project. Method without rules = today's arcs.

## Design space (storage + toggle)
A) Rule files: `.arcs/rules/<slug>.md`, enabled by presence (or `enabled: true` field).
   CLI `arcs rule add/on/off/list`. Bodies are markdown the skill reads + applies.
   Most file-native (matches arcs ethos), open-ended.
B) Config flags: `.arcs/config` → `rules=subagents,parallel`. Rule meaning lives in
   skill/spec (built-in only). Simple, but not user-extensible.
C) Hybrid: `.arcs/config` lists enabled rule names; bodies live in `.arcs/rules/`.
   Shipped rule templates (subagents) in the repo, copied/linked on enable.

Recommendation: A (or C) — per-project rules as files, shipped templates for built-ins,
skill reads `.arcs/rules/` each session and honors enabled rules.

## Open decisions for the user
1. Storage/toggle mechanism (A/B/C).
2. (later) exact CLI surface + whether rules can be global defaults vs per-project only.
