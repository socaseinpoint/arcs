# Version-aware update — shipped

A user on a git-clone now learns when a release ships, and breaking releases force the update.

## What landed

- **`VERSION` / `MIN_VERSION`** at repo root — single source of truth. VERSION = current release;
  MIN_VERSION = breaking floor (default `0.0.0`).
- **`bin/arcs`**:
  - `arcs version` — prints installed version.
  - `arcs check-update [--force] [--quiet]` — throttled (≤1/day), `timeout 4 git fetch`, never fatal.
    Soft-nudges if behind the latest tag; writes/clears `.arcs-update-required` if the install is
    below the remote-declared `MIN_VERSION` (read from `origin/main` so it's visible pre-pull).
  - `arcs update` — now shows `before → after` and clears the flag after pulling.
- **`hooks/arcs-hook`** (SessionStart) — calls `check-update`; one-line nudge on the board, silent if current.
- **`hooks/arcs-gate`** (PreToolUse) — if `.arcs-update-required` exists, hard-blocks project edits
  (`.arcs/` bookkeeping still allowed) until `arcs update`.
- **`.gitignore`** — ignores the per-install runtime state files.
- **Docs** — README + `docs/DEPLOY.md` cover `version`/`check-update`, the nudge, the breaking floor,
  and a maintainer "Cutting a release" checklist.

## Decisions

soft-notice always + hard-force only on breaking · SemVer git tags · git-clone install. See
`input/decisions.md`.

## Verified

- `bash -n` clean; `arcs version` → `arcs 0.2.0`.
- behind path → `update available: arcs 0.2.0 (you have 0.1.0)`.
- breaking flag → gate exits 2 on a project file, 0 on `.arcs/` files.
- current state → check-update silent, exit 0; throttle skips the second fetch.

## Follow-up

Candidate `03-russian-in-cli-templates` — Russian copy in the bin/arcs scaffolds; decide ru-template
vs English-only code. (Deferred per user.)
