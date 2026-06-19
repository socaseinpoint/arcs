#!/usr/bin/env bash
# verify.sh — runs inside the sandbox. exit 0 = pass.
set -euo pipefail
[ -f slugify.py ] || { echo "no slugify.py"; exit 1; }

python3 - <<'PY'
import sys
from slugify import slugify
cases = [
    ("Hello, World!", "hello-world"),
    ("  A  B  ", "a-b"),
    ("foo--bar__baz", "foo-bar-baz"),
    ("Already-A-Slug", "already-a-slug"),
    ("", ""),
    ("!!!", ""),
    ("Café 123", "caf-123"),
]
for inp, want in cases:
    got = slugify(inp)
    assert got == want, f"slugify({inp!r}) == {got!r}, want {want!r}"
print("ok")
PY
