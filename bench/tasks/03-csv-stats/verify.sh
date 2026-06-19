#!/usr/bin/env bash
# verify.sh — runs inside the sandbox. exit 0 = pass.
set -euo pipefail
[ -f stats.py ] || { echo "no stats.py"; exit 1; }

# even count
cat > _even.csv <<'CSV'
name,score
a,10
b,20
c,30
d,40
CSV
got="$(python3 stats.py _even.csv score 2>/dev/null | tr -d '\r')"
want="mean=25.00 median=25.00 max=40.00"
[ "$got" = "$want" ] || { echo "even: got '$got' want '$want'"; exit 1; }

# odd count, unsorted, second column
cat > _odd.csv <<'CSV'
id,val
1,100
2,1
3,4
4,2
5,3
CSV
got="$(python3 stats.py _odd.csv val 2>/dev/null | tr -d '\r')"
want="mean=22.00 median=3.00 max=100.00"
[ "$got" = "$want" ] || { echo "odd: got '$got' want '$want'"; exit 1; }

rm -f _even.csv _odd.csv
echo "ok"
