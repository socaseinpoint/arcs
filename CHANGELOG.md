# Changelog

All notable changes to **arcs** are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Rules — a toggleable behavior layer.** Rule **bodies are global**, shipped in the method
  repo at `<arcs-repo>/rules/<slug>.md` and versioned with the method (so `arcs update` brings
  new rules to every project). The **on/off switch** is the `rules=` line in `.arcs/config`
  (a comma list of enabled slugs). A project may override or add a rule locally at
  `.arcs/rules/<slug>.md` (local wins). Manage with `arcs rule list | on <slug> | off <slug> | add <slug>`.
- **`subagents` rule, shipped enabled by default** (`arcs init` writes `rules=subagents`). An arc
  is an encapsulated unit (`input → workspace → output`, outside reads only `output/`), so the arc
  boundary is a subagent boundary: dispatch one subagent per arc, run independent arcs in parallel,
  pipeline dependent ones, orchestrator reads back only each arc's `output/`.
- **Closing arcs/goals with a visible marker.** `arcs close [-g <goal>] <slug>` wraps the folder
  `NN-<slug>` → `__NN-<slug>__` (a goal `NN-@<slug>` → `__NN-@<slug>__`) and sets `status: done`.
  `arcs reopen` reverses it. `arcs close` refuses an empty `output/` (a closed arc must carry a
  self-contained result); `-f` overrides.
- **Candidates backlog.** `.arcs/candidates/` holds surfaced arc-candidates as numbered
  `NN-<slug>.md` files, each with a `from:` origin (the arc it bubbled up from). `arcs candidate
  <slug> [--from <arc>] [text]` captures one; `arcs status` shows a CANDIDATES section; `arcs
  promote [-g <goal>] <slug>` turns a candidate into a real arc (moves it into the arc's `input/`).
  A future-work idea surfaces on the board instead of dying in a closed arc's `workspace/`.
- `rules:` line in `arcs status`; `arcs status` now prints one **STREAM** board.
- Essence-first landing rewrite (`docs/index.html`): benefit-led hero, quickstart pulled high,
  spec demoted, honest "works with or without an agent" framing. README links to the landing.

### Changed
- **One stream, no separate goals dir.** Dropped `.arcs/goals/`. Arcs and goals now share a single
  continuous numbered stream in `.arcs/arcs/`; a goal is marked by an `@` in its name (`NN-@<slug>/`)
  and keeps its own nested `arcs/` substream + versioned goal doc. Numbering counts open `NN-*`,
  goals `NN-@*`, and closed `__…__`; numbers are never reused.
- Slugs must be descriptive / content-rich (enforced by the skill).
- `skill/SKILL.md`, `SPEC.md`, `examples/`, and the landing document the single-stream model,
  the global-rules-with-config-toggle layer, and the close/reopen lifecycle.

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
