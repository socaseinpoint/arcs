# 19 — no change: the Russian is intentional i18n

## Verdict

The Cyrillic in `bin/arcs` is the `ru)` branch of the localized template `case` in `arc_md()` /
`goal_md()` — one of three locales (`*)`=en, `ru)`, `es)`) selected by the project's `lang`
(`arcs init en|ru|es`). Field keys (`goal:`/`status:`/`closes:`/`supersedes:`) stay English so the
parser is language-agnostic; only human placeholder text + headings localize (per the line-113
comment). The CLI logic and code comments are already English.

The candidate's premise ("English-only code, stray Russian") was a misread. Removing the Russian
would delete the `lang=ru` feature, not clean up the code.

## Decision (user)

**Keep as-is.** No code change. en/ru/es all stay.

## Evidence

`bin/arcs`:
- `arc_md()` — en `bin/arcs:147`, ru `:117`, es `:132`
- `goal_md()` — en `bin/arcs:197`, ru `:167`, es `:182`
- localization rationale comment `bin/arcs:113`
