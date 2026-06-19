# Result — release 0.2.0

Cut the 0.2.0 release: the goal-v2 work + the two-surface web presence.

## Done
- `CHANGELOG.md`: moved `[Unreleased]` → `## [0.2.0] - 2026-06-18`; added the two-surface web-presence
  entry (Added) + the English-only landing note (Changed); left a fresh empty `[Unreleased]`; updated
  the footer compare links (`[Unreleased]` → `v0.2.0...HEAD`, added `[0.2.0]` → `v0.1.0...v0.2.0`).
- Landing/docs `changelog ↗` links repointed `/commits/main` → `/blob/main/CHANGELOG.md` (the real file).
- Tags: repo had NO tags (0.1.0 was documented but never tagged). Tagged `v0.1.0` retroactively at the
  0.1.0 baseline commit so the compare links resolve, and `v0.2.0` at the release commit.

## Pointers
- Release commit + tags pushed to `main` (see git log / GitHub releases).
- Web surfaces shipped in sibling arc `__01-rebuild-landing-and-deep-docs__/output/result.md`.
- Vercel auto-deploys `docs/` on push → landing + `/docs.html` go live.
