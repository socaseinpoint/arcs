# result — release 0.3.1

Patch release. Fix-dominant (dotted checklist keys), landing/docs touch-ups, no breaking change.

## Done
- `CHANGELOG.md`: opened `## [0.3.1] - 2026-06-18` below a fresh empty `[Unreleased]`; the dotted-keys
  Fixed entry + landing/russian-flag Changed entries roll into it.
- Footer compare links repaired: prior release left them drifted — added the missing `[0.3.0]` line
  and repointed `[Unreleased]` from `v0.2.0...HEAD` → `v0.3.1...HEAD`; added `[0.3.1]`.
- `VERSION` → `0.3.1`. `MIN_VERSION` stays `0.0.0` (no breaking change).
- Tag `v0.3.1` at the release commit; pushed with tags. Vercel auto-deploys `docs/` on push.

## Pointers
- Fix shipped in arc `__21-checklist-key-dots-break-matching__`.
- Release commit + tag on `main`.
