#!/usr/bin/env bash
# verify.sh — runs inside the sandbox. exit 0 = pass.
set -euo pipefail
[ -f balanced.py ] || { echo "no balanced.py"; exit 1; }

python3 - <<'PY'
from balanced import is_balanced
cases = [
    ("(a[b]{c})", True),
    ("{[()]}", True),
    ("", True),
    ("(]", False),
    ("(()", False),
    (")(", False),
    ("([)]", False),
    ("no brackets here", True),
    ("{{{", False),
]
for inp, want in cases:
    got = is_balanced(inp)
    assert got == want, f"is_balanced({inp!r}) == {got!r}, want {want!r}"
print("ok")
PY
