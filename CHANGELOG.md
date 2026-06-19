# Changelog

All notable changes to **arcs** are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Rules — a toggleable behavior layer.** Per-project markdown rules in `.arcs/rules/<slug>.md`
  (`# <slug>` + `enabled: true|false` + body). An agent reads them at session start and obeys
  every enabled rule. Manage with `arcs rule list | on <slug> | off <slug> | add <slug>`.
  The base method is unchanged with all rules off.
- **`subagents` rule, shipped enabled by default** at `arcs init`. An arc is an encapsulated
  unit (`input → workspace → output`, outside reads only `output/`), so the arc boundary is a
  subagent boundary: dispatch one subagent per arc, run independent arcs in parallel, pipeline
  dependent ones, and keep the orchestrator reading back only each arc's `output/`.
- **Closing arcs with a visible marker.** `arcs close [-g <goal>] <slug>` renames `NN-<slug>`
  → `__NN-<slug>__` and sets `status: done`, so finished arcs are obvious in `ls`.
  `arcs reopen [-g <goal>] <slug>` reverses it. `arcs close` refuses an arc with an empty
  `output/` (a closed arc must carry a self-contained result); `-f` / `--force` overrides.
- `rules:` line in `arcs status` showing which rules are enabled.
- Essence-first landing rewrite (`docs/index.html`): benefit-led hero, quickstart pulled high,
  the method spec demoted to a "how it works" section, honest "works with or without an agent"
  framing.

### Changed
- Arc numbering now counts both open `NN-*` and closed `__NN-*__` entries, so numbers are
  never reused after a close.
- `skill/SKILL.md` and `SPEC.md` document the rules layer and the close/reopen lifecycle.

## [0.1.0] - 2026-06-18

### Added
- The **arcs** method: two primitives — **arc** (`input/ → workspace/ → output/`, encapsulated)
  and **goal** (an arc with a purpose holding nested arcs + a versioned status doc). Spec in
  `SPEC.md`, all state in a hidden `.arcs/` meta directory.
- `arcs` CLI: `init`, `new-arc`, `new-goal`, `status`, `lang`, `update`, `help`.
- Per-project arc language (`en` / `ru` / `es`) via `arcs init` / `arcs lang`, stored in
  `.arcs/config`; localized templates. Field keys stay English so tooling is language-agnostic.
- Claude skill (`skill/SKILL.md`) and `install.sh` to wire PATH + skill + hooks.
- Three enforcement layers: the skill (advises), `arcs-hook` (SessionStart + UserPromptSubmit
  reminder + board), and `arcs-gate` (PreToolUse hard block on edits until an arc is open).
- `arcs update` — one-command self-update (git pull + re-wire skill/hooks).
- Bilingual (RU/EN) landing page and `examples/basic` walkthrough.

[Unreleased]: https://github.com/socaseinpoint/arcs/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/socaseinpoint/arcs/releases/tag/v0.1.0
