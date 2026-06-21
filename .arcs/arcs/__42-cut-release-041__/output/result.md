# Release 0.4.1 — cut

Cut the 0.4.1 release: promoted the `[Unreleased]` block to `[0.4.1] - 2026-06-20`
in `CHANGELOG.md` and added the entries that shipped after 0.4.0.

## What's in 0.4.1
- **Added** — `arcs dashboard` (read-only static viewer over every `.arcs/` on disk;
  arcs 33–37); `arcs init` now offers to `git init` when no repo exists (arc 40).
- **Fixed** — dashboard generation no longer crashes on multibyte content; the data
  block is injected under `LC_ALL=C` so `head -c`-truncated UTF-8 can't trip macOS
  awk's `towc: multibyte conversion failure` (arc 41).
- **Design** — proof-gated arc profiles (heavy/light over a frozen wire format),
  design + roast only, not implemented (arc 38).

## Mechanics
- Per-arc commits for 38/40/41/27 pushed to `origin/main` (split `bin/arcs`'s mixed
  diff into the awk fix and the git-init offer as separate commits).
- CHANGELOG release commit + compare links (`v0.4.0...v0.4.1`).
- Annotated tag `v0.4.1` re-pointed to the release commit and force-pushed.

## Result
`origin/main` carries 0.4.1; tag `v0.4.1` points at the CHANGELOG release commit.
