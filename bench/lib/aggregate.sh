#!/usr/bin/env bash
# lib/aggregate.sh — runs.csv → markdown report (per-arm means + spread).
# Contract: <runs.csv>  → markdown on stdout
set -euo pipefail

csv="${1:?runs.csv}"
[ -f "$csv" ] || { echo "aggregate: no csv at $csv" >&2; exit 1; }

echo "# Benchmark report"
echo
echo "Source: \`$csv\`"
echo

# Per-arm aggregates. CSV cols: arm,task,rep,in_tok,out_tok,cost_usd,dur_ms,tests_pass,judge
awk -F, '
  NR==1 { next }
  {
    arm=$1
    n[arm]++
    in_tok[arm]+=$4; out_tok[arm]+=$5; cost[arm]+=$6; dur[arm]+=$7
    pass[arm]+=$8; judge[arm]+=$9; jn[arm]+=($9>0?1:0)
  }
  END {
    print "## Per arm (means)"
    print ""
    print "| arm | runs | in_tok | out_tok | cost $ | dur ms | tests pass % | judge avg |"
    print "|-----|------|--------|---------|--------|--------|--------------|-----------|"
    for (a in n) {
      c=n[a]
      javg=(jn[a]>0 ? judge[a]/jn[a] : 0)
      printf "| %s | %d | %.0f | %.0f | %.4f | %.0f | %.0f%% | %.2f |\n", \
        a, c, in_tok[a]/c, out_tok[a]/c, cost[a]/c, dur[a]/c, 100*pass[a]/c, javg
    }
    print ""
  }
' "$csv"

# Per arm × task breakdown.
awk -F, '
  NR==1 { next }
  {
    k=$1"|"$2
    n[k]++
    out_tok[k]+=$5; cost[k]+=$6; dur[k]+=$7; pass[k]+=$8; judge[k]+=$9; jn[k]+=($9>0?1:0)
  }
  END {
    print "## Per arm × task (means)"
    print ""
    print "| arm | task | runs | out_tok | cost $ | dur ms | pass % | judge |"
    print "|-----|------|------|---------|--------|--------|--------|-------|"
    for (k in n) {
      split(k,p,"|"); c=n[k]
      javg=(jn[k]>0 ? judge[k]/jn[k] : 0)
      printf "| %s | %s | %d | %.0f | %.4f | %.0f | %.0f%% | %.2f |\n", \
        p[1], p[2], c, out_tok[k]/c, cost[k]/c, dur[k]/c, 100*pass[k]/c, javg
    }
    print ""
  }
' "$csv"

echo "_in_tok = total input incl. cache (fresh + cache-creation + cache-read);"
echo "cost \$ is the money truth (prices cache tiers correctly). Means hide variance —"
echo "check runs.csv for per-rep spread before drawing conclusions._"
