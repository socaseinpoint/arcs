# Changelog

All notable changes to **arcs** are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.3.1] - 2026-06-18

### Fixed
- **Dotted checklist keys now match `closes:`.** A checklist key containing dots (e.g.
  `cut-release-0.2.0`) was never recognized: the key-extraction regex rejected `.`, so the whole item
  text got slugified instead, and `closes:` was compared raw with no shared normalization — so the
  item always read as unclosed (`0/1 ✓`). The key regex now allows dots, and both sides of the
  match are slugified, so dot/dash representation drift round-trips
  (`cut-release-0.2.0` ↔ `cut-release-0-2-0`). Found dogfooding the 0.2.0 release.

### Changed
- **Landing payoff + first move.** `docs/index.html` gains a before→after "wow" band (a cold session
  days later: re-explain-and-redo vs. one-word `continue` that resumes from `.arcs/`) and a concrete
  "say this in Claude Code" first-move block, so the page shows the pain→relief and the start path,
  not just install steps.
- Investigated the "Russian in `bin/arcs`" flag: it's the intentional `ru)` locale branch of the
  en/ru/es templates (field keys stay English) — kept as-is, no code change.

## [0.3.0] - 2026-06-18

### Added
- **Version-aware update.** The install now carries a version (`VERSION` at the repo root) and the CLI
  knows when it's stale. `arcs version` prints what you have; `arcs check-update` runs a throttled
  (≤1/day), `timeout`-capped, never-fatal `git fetch --tags` and compares your install against the
  latest release tag. The SessionStart hook calls it, so the board carries a one-line
  `update available: arcs X` when a newer release exists — informational, nothing blocks. Offline no-ops.
- **Breaking-update floor.** A release that breaks compatibility raises `MIN_VERSION` to its own
  version. `check-update` reads that floor from the fetched `origin/main` (visible *before* you pull);
  an install below it gets a hard `arcs-gate` block on project edits until `arcs update` clears it.
- **`arcs update` feedback.** Now reports `before → after` and clears the breaking-update flag on success.

### Changed
- Runtime state (`.arcs-update-stamp`, `.arcs-update-required`) lives at the repo root and is git-ignored.
- `docs/DEPLOY.md` gains a maintainer "Cutting a release" checklist (bump VERSION, move CHANGELOG, tag).

## [0.2.0] - 2026-06-18

### Added
- **Immutable goals + supersession chains.** A goal's intent no longer gets edited in place. When the
  aim actually changes, `arcs supersede [-g <goal>] <old> <new>` closes the old unit and opens a new one
  carrying `supersedes: <old>` (with `input/from-<old>.md` seeded as a pointer back) — a traceable chain,
  both still on disk, rather than a rename or an overwrite. `closes:` and `supersedes:` are new optional
  `arc.md` fields (shipped commented in the template); `prev:` is read as an alias of `supersedes:`.
- **Goal checklists, computed not hand-ticked.** A goal can carry a `## Checklist`; items stay `- [ ]`
  and a sub-arc that finishes one declares `closes: <item-key>`. `arcs status` does the rest — `N/M ✓`
  on the goal line, then `✓ <key> → <arc>` for closed items and `○ <key>` for the rest. You never tick
  by hand, because a manual check is exactly the drift this method exists to avoid. A goal with no
  checklist falls back to the old raw sub-arc list.
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
- **Two-surface web presence.** The landing (`docs/index.html`) is now a short, value-first
  onboarding for a newcomer with an agent — the promise, three value props, and one 20-second start.
  A separate deep-docs page (`docs/docs.html`) carries the full what/where/how/why: concepts,
  lifecycle, goals v2, the rules layer, candidates, a full command reference, install, and a worked
  example. Landing and docs cross-link both ways.

### Changed
- **Dropped goal-doc version numbering.** A goal is now one immutable `<slug>-goal.md` — no `MM-`
  prefix, no `version:` line. The version axis is replaced by the checklist + supersession chains above.
  `SPEC.md`, `skill/SKILL.md`, `examples/`, the landing, and the `goal_md` template were updated to match.
- **One stream, no separate goals dir.** Dropped `.arcs/goals/`. Arcs and goals now share a single
  continuous numbered stream in `.arcs/arcs/`; a goal is marked by an `@` in its name (`NN-@<slug>/`)
  and keeps its own nested `arcs/` substream + versioned goal doc. Numbering counts open `NN-*`,
  goals `NN-@*`, and closed `__…__`; numbers are never reused.
- Slugs must be descriptive / content-rich (enforced by the skill).
- `skill/SKILL.md`, `SPEC.md`, `examples/`, and the landing document the single-stream model,
  the global-rules-with-config-toggle layer, and the close/reopen lifecycle.
- The landing dropped its RU/EN toggle and is English-only, matching the project's `en` default.

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

[Unreleased]: https://github.com/socaseinpoint/arcs/compare/v0.3.1...HEAD
[0.3.1]: https://github.com/socaseinpoint/arcs/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/socaseinpoint/arcs/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/socaseinpoint/arcs/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/socaseinpoint/arcs/releases/tag/v0.1.0
