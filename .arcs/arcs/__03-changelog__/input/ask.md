# Ask

User wants a CHANGELOG in the project.

## Decisions
- Format: Keep a Changelog (https://keepachangelog.com), SemVer.
- File: `CHANGELOG.md` at repo root.
- Language: English (repo docs are English).
- No version tags exist yet; all commits dated 2026-06-18.

## Mapping
- `[Unreleased]` = today's uncommitted work: rules system + subagents rule, arc close/reopen
  with `__marker__`, numbering counts closed, landing rebuilt essence-first.
- `[0.1.0] - 2026-06-18` = the committed baseline (method spec, CLI scaffolders, .arcs meta,
  Claude skill, enforcement hooks hook+gate, per-project language en/ru/es, bilingual landing).
