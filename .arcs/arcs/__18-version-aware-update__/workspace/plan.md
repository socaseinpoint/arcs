# Plan — version-aware update

## Files / state (single source of truth = repo root)

- `VERSION`       — current release, e.g. `0.2.0`. Bumped on every release + matching tag.
- `MIN_VERSION`   — breaking floor: lowest version still allowed to keep working. Default `0.0.0`.
                    Only bumped when a release breaks compatibility.

## CLI (bin/arcs)

- `cmd_version`        → print contents of repo `VERSION`.
- `cmd_check_update`   → throttled (≤1/day) `git fetch --tags` with `timeout`, never fatal.
    Compute via `sort -V`:
      - latest remote tag vs local VERSION → behind?
      - local VERSION vs remote MIN_VERSION → breaking-required?
    Side effects:
      - write/remove flag file `$repo/.arcs-update-required` (gate reads this — cheap).
      - print human status: `up to date` / `behind <latest>` / `BREAKING update required`.
    Throttle stamp: `$repo/.arcs-update-stamp` (mtime; skip fetch if <24h, unless --force).
- `cmd_update`         → after pull: clear flag, show old→new + changelog pointer.
- dispatch + help: add `version`, `check-update`.

## Hooks

- `arcs-hook` (SessionStart) → call `arcs check-update` (throttled), echo its line into context.
- `arcs-gate` (PreToolUse)   → resolve repo (same SOURCE-walk), if `.arcs-update-required`
    exists → block ALL edits with "breaking arcs update required → arcs update".
    (Checked before the open-arc check; cheap file test, no network.)

## Release discipline (docs)

Releasing = bump VERSION (+ MIN_VERSION iff breaking) + tag vX.Y.Z + CHANGELOG entry.

## Safety

- Network: `timeout 4 git fetch ... || true`. Offline = silent no-op, never blocks a session.
- Throttle so we don't fetch on every prompt.
- Flag file is global (repo), not per-project — version is a property of the install.
