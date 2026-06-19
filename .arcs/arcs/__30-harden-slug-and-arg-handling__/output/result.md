# harden-slug-and-arg-handling — result

All four input-handling defects in `bin/arcs` fixed. Syntax-checked, release-check green,
exercised in a throwaway temp dir. No regressions in untouched commands.

## What was broken → what changed

### 1. Slugs not sanitized on creation (spaces / `/` break globs)
`new-arc`, `new-goal`, `candidate`, `promote` wrote the user's raw string straight into a
`NN-<slug>/` dir name. A slug like `foo bar/baz` produced a dir with a space and a slash,
which then broke every `[0-9][0-9]-<slug>/` glob (close/reopen/supersede could never find it).

- Added `slugify()` helper (`bin/arcs:11-18`): lowercases, maps space/`/`/`_` → `-`, drops any
  char outside `[a-z0-9-]`, collapses and trims `-`. Portable (bash 3.2 — uses `tr`/`sed`, no
  `${var,,}`), matching the rest of the script.
- Applied at every creation site:
  - `cmd_new_arc` slug + `-g` value (`bin/arcs:221,224`)
  - `cmd_new_goal` slug (`bin/arcs:246`)
  - `cmd_candidate` slug + `--from` value (`bin/arcs:521-526`)
  - `cmd_promote` newslug (`bin/arcs:547`)
- Empty/symbol-only input (e.g. `@@@`, `   `) now dies with the usage message instead of
  creating a `NN-/` dir.

### 2. `supersede` raw `sed` corrupts arc.md on `& | \`
`cmd_supersede` wrote `supersedes: $old` through `sed "s|...|...supersedes: $old|"` with no
escaping. `&` expands to the match, `|` (the delimiter) terminates the command, `\` is an
escape — any of them corrupted the file or crashed sed.

- Added `sed_repl_escape()` (`bin/arcs:21`): escapes `& | \` for a sed replacement.
- `cmd_supersede` now escapes the value before substituting (`bin/arcs:592-594`).
- Defense-in-depth: since slugs are now slugified, `& | \` can't reach the value via normal
  use, but the escape makes the write correct regardless. Verified: escaped value writes the
  literal `supersedes: a&b|c\d`; the unescaped form crashes sed (`bad flag in substitute`).

### 3. `-g` flag sites unguarded under `set -u`
`goal_slug="$2"` (no `${2:-}`) would trip `set -u` when `-g` had no following value.

- All `-g` reads now use `${2:-}` and die with a clear message if empty:
  `cmd_new_arc` (`:219-222`), `cmd_close` (`:458`), `cmd_reopen` (`:489-492`),
  `cmd_promote` (`:535`), `cmd_supersede` (`:558`), and `cmd_candidate --from` (`:523`).

### 4. `shift 2` aborts silently under `set -e`
In bash, `shift 2` with fewer than 2 positional args returns non-zero, and under `set -euo`
that silently aborts the whole script (confirmed: bash exits 1 with no message).

- `if`-style `-g` blocks (`new-arc`, `reopen`) now verify `$2` is present (via the `${2:-}`
  guard above) *before* `shift 2`, so the shift is always safe.
- `while`-loop flag cases that consumed an optional value (`candidate --from`, `promote -g`,
  `supersede -g`) replaced `shift 2` with `shift; [ $# -gt 0 ] && shift` so a trailing flag
  with no value can't abort the run.

## Verification
- `bash -n bin/arcs` → OK
- `./release-check.sh` → OK (0.4.0 consistent)
- Temp-dir smoke (mktemp, not the real `.arcs/`): `new-arc "foo bar/baz"` → `01-foo-bar-baz`;
  `new-goal "My Big Goal"` → `02-@my-big-goal`; `new-arc -g` with messy slug; `candidate`
  with messy slug + `--from`; `supersede` (escape path); every `-g`/`--from` with no value
  errors cleanly (exit 1, clear message) instead of silent abort.

## Not done / caveats
- Non-ASCII slugs lose accents (`héllo` → `hllo`). Acceptable: the goal is glob-safe ASCII
  kebab; preserving Unicode would need a transliteration table out of scope here.
