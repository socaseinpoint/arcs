# Releasing arcs

A release is a deliberate bump, not just a push to `main`. The tag is what `arcs check-update`
compares against, so only tagged releases ever nudge users — work in flight on `main` never does.

## Versioning

Semantic Versioning (`X.Y.Z`):
- **patch** (`Z`) — bug fixes, doc/landing changes, no behavior contract change.
- **minor** (`Y`) — new commands/flags/behavior, backward compatible.
- **major** (`X`) — breaking changes. Also raise `MIN_VERSION` to this version (see below).

`MIN_VERSION` is the **breaking floor**: an install below it is hard-blocked from editing by
`arcs-gate` until `arcs update`. Raise it **only** in a release that breaks older installs.

## Steps

1. **Land the work.** All changes for the release are committed on `main`.
2. **Bump `VERSION`** to the new `X.Y.Z`. Raise `MIN_VERSION` only on a breaking release.
3. **Roll the changelog.** In `CHANGELOG.md`, move the `[Unreleased]` notes under a fresh
   `## [X.Y.Z] - YYYY-MM-DD` heading; leave an empty `[Unreleased]` above it.
4. **Fix the footer links.** Add `[X.Y.Z]: …/compare/vPREV...vX.Y.Z` and repoint
   `[Unreleased]: …/compare/vX.Y.Z...HEAD`.
5. **Run the check:** `./release-check.sh` — must print `OK` (asserts VERSION == CHANGELOG
   top section == footer link present, and `MIN_VERSION <= VERSION`). Do not proceed on FAIL.
6. **Commit** the release: `chore(release): X.Y.Z`.
7. **Tag and push:** annotate the tag so `--follow-tags` actually pushes it —
   `git tag -a vX.Y.Z -m vX.Y.Z && git push --follow-tags` (or push it explicitly:
   `git push origin vX.Y.Z`; a lightweight tag is *not* pushed by `--follow-tags`).
8. **Publish the GitHub Release** from the changelog section:
   ```
   gh release create vX.Y.Z --title "vX.Y.Z" \
     --notes "$(awk '/^## \[X.Y.Z\]/{f=1;next} f&&/^## \[/{exit} f' CHANGELOG.md)"
   ```
9. **Verify:** `arcs version` locally, and the Vercel deploy of `docs/` (auto on push).

## Pre-release checklist

- [ ] `VERSION` bumped (and `MIN_VERSION` raised iff breaking)
- [ ] `CHANGELOG.md`: `[Unreleased]` rolled into `## [X.Y.Z] - <date>`, empty `[Unreleased]` left
- [ ] footer compare-links: `[X.Y.Z]` added, `[Unreleased]` repointed
- [ ] `./release-check.sh` prints `OK`
- [ ] tag `vX.Y.Z` pushed; GitHub Release published
