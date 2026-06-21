# Bug: `arcs update` never clears the "update available" nudge

User reports `arcs update` "doesn't update" — the nudge keeps firing.

## Diagnosis
`VERSION` file at repo root = `0.4.0`, but the release tag is `v0.4.1`.
The 0.4.1 release (arc 42) bumped CHANGELOG + tag but **forgot to bump `VERSION`**.

`cmd_check_update` compares `latest_remote_tag` (0.4.1) against `read_ver VERSION` (0.4.0):
- nudge: "update available: arcs 0.4.1 (you have 0.4.0)"
- user runs `arcs update` → `git pull --ff-only` pulls fresh main, but main's `VERSION`
  is still `0.4.0` → `before == after` → prints "already latest (0.4.0)"
- next check sees tag 0.4.1 > VERSION 0.4.0 again → nudge never clears = "не обновляется"

The code DID update (fresh main pulled); only the version indicator is stuck.

## Fix
Bump `VERSION` → `0.4.1`, commit, move tag `v0.4.1` to the bump commit, push.

## Follow-up (candidate)
Release process is manual and error-prone (must hand-edit VERSION + MIN_VERSION +
CHANGELOG + tag in lockstep). An `arcs release <ver>` subcommand would prevent this
class of drift.
