#!/usr/bin/env bash
# release-check — assert a release is internally consistent before you tag it.
# Checks, against the repo root:
#   1. VERSION is a clean X.Y.Z
#   2. the top dated CHANGELOG section (first below [Unreleased]) == VERSION
#   3. a footer compare-link exists for that version
#   4. MIN_VERSION is a clean X.Y.Z and <= VERSION
# Reports git-tag status as info (the tag is created AFTER this passes).
# Exit 0 = consistent, ready to tag. Exit 1 = drift, do not release.
set -euo pipefail

cd "$(dirname "$0")"
fail=0
err() { printf '  ✗ %s\n' "$1" >&2; fail=1; }
ok()  { printf '  ✓ %s\n' "$1"; }

semver='^[0-9]+\.[0-9]+\.[0-9]+$'

[ -f VERSION ] || { err "VERSION file missing"; exit 1; }
ver="$(tr -d '[:space:]' < VERSION)"
if printf '%s' "$ver" | grep -qE "$semver"; then ok "VERSION = $ver"
else err "VERSION '$ver' is not X.Y.Z"; fi

# top dated changelog section (skip [Unreleased])
top="$(grep -m1 -E '^## \[[0-9]+\.[0-9]+\.[0-9]+\]' CHANGELOG.md \
        | sed -E 's/^## \[([0-9]+\.[0-9]+\.[0-9]+)\].*/\1/' || true)"
if [ -z "$top" ]; then err "no dated ## [X.Y.Z] section in CHANGELOG.md"
elif [ "$top" = "$ver" ]; then ok "CHANGELOG top section = $top"
else err "CHANGELOG top section ($top) != VERSION ($ver)"; fi

# footer compare-link for this version
if grep -qE "^\[$ver\]: https?://" CHANGELOG.md; then ok "footer link [$ver] present"
else err "footer compare-link [$ver] missing in CHANGELOG.md"; fi

# MIN_VERSION sanity
if [ -f MIN_VERSION ]; then
  minv="$(tr -d '[:space:]' < MIN_VERSION)"
  if printf '%s' "$minv" | grep -qE "$semver"; then
    # X.Y.Z compare via sort -V
    lowest="$(printf '%s\n%s\n' "$minv" "$ver" | sort -V | head -1)"
    if [ "$lowest" = "$minv" ]; then ok "MIN_VERSION = $minv (<= $ver)"
    else err "MIN_VERSION ($minv) > VERSION ($ver)"; fi
  else err "MIN_VERSION '$minv' is not X.Y.Z"; fi
else err "MIN_VERSION file missing"; fi

# git tag status — info only (tag is created after this passes)
if git rev-parse "v$ver" >/dev/null 2>&1; then
  printf '  • tag v%s already exists\n' "$ver"
else
  printf '  • tag v%s not yet created (expected pre-release)\n' "$ver"
fi

if [ "$fail" -eq 0 ]; then echo "release-check: OK — $ver is consistent, ready to tag."; exit 0
else echo "release-check: FAILED — fix the drift above before releasing." >&2; exit 1; fi
