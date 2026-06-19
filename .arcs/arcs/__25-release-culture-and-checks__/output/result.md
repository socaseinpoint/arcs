# result — release culture + 0.3.2 cut through it

Built a real release process and immediately dogfooded it to ship 0.3.2.

## Added
- `RELEASING.md` — the deliberate-bump flow: semver policy, the `MIN_VERSION` breaking floor,
  9 steps (land → bump → roll changelog → fix footer links → `release-check` → commit → tag →
  GH release → verify), and a pre-release checklist.
- `release-check.sh` — gate before tagging. Asserts VERSION == CHANGELOG top dated section ==
  footer compare-link present, and `MIN_VERSION <= VERSION` (sort -V). Tag status is info only
  (tag is created after it passes). Exit 1 on any drift.

## Done
- **GH Release v0.3.1** published retroactively (notes from the CHANGELOG section). The tag was
  local-only — `--follow-tags` doesn't push lightweight tags; pushed it explicitly. RELEASING.md
  now prescribes annotated tags to avoid that trap.
- **Cut 0.3.2** through the new process: VERSION → 0.3.2; rolled `[Unreleased]` (gate fix +
  this release tooling) into `## [0.3.2] - 2026-06-18`; added `[0.3.2]` footer link + repointed
  `[Unreleased]`; `./release-check.sh` → OK; annotated tag + push + GH release.

## Pointers
- 0.3.2 ships the CRITICAL gate fix from arc 24.
- Process tool lives at repo root next to `install.sh` (maintainer-facing, not shipped to projects).
