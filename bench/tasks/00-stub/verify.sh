#!/usr/bin/env bash
# verify.sh — runs inside the sandbox. exit 0 = pass.
set -euo pipefail

[ -f add.sh ] || { echo "no add.sh"; exit 1; }

got="$(bash add.sh 2 3 2>/dev/null | tr -d '[:space:]')"
[ "$got" = "5" ] || { echo "add 2 3 => '$got' (want 5)"; exit 1; }

got="$(bash add.sh -4 10 2>/dev/null | tr -d '[:space:]')"
[ "$got" = "6" ] || { echo "add -4 10 => '$got' (want 6)"; exit 1; }

exit 0
