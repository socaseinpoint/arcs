# Fixed: VERSION file out of sync with the 0.4.1 tag

## What was wrong
The 0.4.1 release (arc 42) bumped `CHANGELOG.md` + git tag but left `VERSION` at `0.4.0`.
`cmd_check_update` reads `VERSION` as the installed version, so every client saw a
permanent "update available: 0.4.1 (you have 0.4.0)" that `arcs update` could not clear —
pulling fresh main still gave `VERSION=0.4.0` (`before == after` → "already latest").

## Fix applied
- `VERSION` → `0.4.1` (now matches tag `v0.4.1`).
- Tag `v0.4.1` re-pointed to the VERSION-bump commit and force-pushed, so the tagged tree
  carries the correct VERSION.

After this, a client's `arcs update` pulls `VERSION=0.4.1`, `before(0.4.0) → after(0.4.1)`,
and the nudge clears.

## Follow-up
Surfaced candidate: an `arcs release <ver>` subcommand to bump VERSION/MIN_VERSION +
CHANGELOG + tag atomically, so a release can't drift like this again.
