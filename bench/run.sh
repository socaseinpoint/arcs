#!/usr/bin/env bash
# bench/run.sh — orchestrate arms × tasks × reps, capture tokens/time/quality.
#
# Each cell (arm,task,rep) runs in a throwaway sandbox via headless `claude -p`.
# Per run we record: input/output tokens, cost, wall-time, tests_pass, judge.
#
# Usage:
#   bench/run.sh [--reps N] [--arms a,b] [--tasks t1,t2] [--model ID]
#                [--judge-model ID] [--dry-run] [--out DIR]
#
#   --dry-run   one cell only (first arm × first task × 1 rep) — smoke the harness
#
# Deps: bash, jq, claude (CLI). bench/ is dev-tooling; the shipped arcs CLI stays
# zero-dep — jq lives here, not in bin/arcs.
set -euo pipefail

BENCH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

REPS="${REPS:-3}"
MODEL="${MODEL:-claude-sonnet-4-6}"
JUDGE_MODEL="${JUDGE_MODEL:-claude-sonnet-4-6}"
ARMS=""
TASKS=""
DRY_RUN=0
OUT=""

die() { echo "bench: $*" >&2; exit 1; }

while [ $# -gt 0 ]; do
  case "$1" in
    --reps)        REPS="${2:-}"; shift 2 ;;
    --arms)        ARMS="${2:-}"; shift 2 ;;
    --tasks)       TASKS="${2:-}"; shift 2 ;;
    --model)       MODEL="${2:-}"; shift 2 ;;
    --judge-model) JUDGE_MODEL="${2:-}"; shift 2 ;;
    --out)         OUT="${2:-}"; shift 2 ;;
    --dry-run)     DRY_RUN=1; shift ;;
    -h|--help)     sed -n '2,18p' "${BASH_SOURCE[0]}"; exit 0 ;;
    *)             die "unknown arg: $1" ;;
  esac
done

command -v jq >/dev/null     || die "jq not found (bench needs jq)"
command -v claude >/dev/null || die "claude CLI not found"

# Discover arms/tasks (comma list overrides; else every dir). bash 3.2 safe.
list_dirs() { find "$1" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort; }
read_dirs() { # $1=target_array_name not portable in 3.2; use globals
  _RD=(); while IFS= read -r _d; do [ -n "$_d" ] && _RD+=("$_d"); done < <(list_dirs "$1"); }

if [ -n "$ARMS" ];  then IFS=',' read -r -a ARM_LIST  <<< "$ARMS";  else read_dirs "$BENCH_DIR/arms";  ARM_LIST=("${_RD[@]}"); fi
if [ -n "$TASKS" ]; then IFS=',' read -r -a TASK_LIST <<< "$TASKS"; else read_dirs "$BENCH_DIR/tasks"; TASK_LIST=("${_RD[@]}"); fi

[ "${#ARM_LIST[@]}"  -gt 0 ] || die "no arms in $BENCH_DIR/arms"
[ "${#TASK_LIST[@]}" -gt 0 ] || die "no tasks in $BENCH_DIR/tasks"

if [ "$DRY_RUN" = 1 ]; then
  ARM_LIST=("${ARM_LIST[0]}"); TASK_LIST=("${TASK_LIST[0]}"); REPS=1
  echo "bench: DRY-RUN — ${ARM_LIST[0]} × ${TASK_LIST[0]} × 1"
fi

# Output dir. No Date in this env's tool sandbox, but run.sh is plain bash → date is fine.
TS="$(date +%Y%m%d-%H%M%S)"
RESULTS="${OUT:-$BENCH_DIR/results/$TS}"
mkdir -p "$RESULTS/raw"
CSV="$RESULTS/runs.csv"
echo "arm,task,rep,in_tok,out_tok,cost_usd,dur_ms,tests_pass,judge" > "$CSV"

total=$(( ${#ARM_LIST[@]} * ${#TASK_LIST[@]} * REPS ))
echo "bench: $total cells → $RESULTS  (model=$MODEL judge=$JUDGE_MODEL)"

n=0
for arm in "${ARM_LIST[@]}"; do
  arm_run="$BENCH_DIR/arms/$arm/run.sh"
  [ -x "$arm_run" ] || die "arm '$arm' has no executable run.sh"
  for task in "${TASK_LIST[@]}"; do
    task_dir="$BENCH_DIR/tasks/$task"
    [ -f "$task_dir/prompt.md" ] || die "task '$task' has no prompt.md"
    for rep in $(seq 1 "$REPS"); do
      n=$((n+1))
      cell="$arm-$task-$rep"
      echo "bench: [$n/$total] $cell"

      sandbox="$(mktemp -d)"
      trap 'rm -rf "$sandbox"' EXIT
      [ -d "$task_dir/starter" ] && cp -R "$task_dir/starter/." "$sandbox/" 2>/dev/null || true

      raw="$RESULTS/raw/$cell.json"
      # Arm produces sandbox files + writes the claude -p JSON to $raw.
      if ! "$arm_run" "$sandbox" "$task_dir" "$MODEL" "$raw"; then
        echo "bench:   arm run failed — recording zeros" >&2
      fi

      in_tok=0; out_tok=0; cost=0; dur=0
      if [ -s "$raw" ]; then
        # Total input = fresh + cache-creation + cache-read. usage.input_tokens
        # alone is misleading (most context arrives as cached tokens).
        in_tok=$(jq -r '((.usage.input_tokens // 0) + (.usage.cache_creation_input_tokens // 0) + (.usage.cache_read_input_tokens // 0))' "$raw" 2>/dev/null || echo 0)
        out_tok=$(jq -r '.usage.output_tokens // 0' "$raw" 2>/dev/null || echo 0)
        cost=$(jq -r '.total_cost_usd // 0' "$raw" 2>/dev/null || echo 0)
        dur=$(jq -r '.duration_ms // 0' "$raw" 2>/dev/null || echo 0)
      fi

      # Objective check.
      tests_pass=0
      if [ -f "$task_dir/verify.sh" ]; then
        cp "$task_dir/verify.sh" "$sandbox/__verify.sh"
        if ( cd "$sandbox" && bash __verify.sh >/dev/null 2>&1 ); then tests_pass=1; fi
        rm -f "$sandbox/__verify.sh"
      fi

      # Subjective check.
      judge=0
      if [ -f "$task_dir/rubric.md" ]; then
        judge="$("$BENCH_DIR/lib/judge.sh" "$sandbox" "$task_dir" "$JUDGE_MODEL" 2>/dev/null || echo 0)"
      fi

      echo "$arm,$task,$rep,$in_tok,$out_tok,$cost,$dur,$tests_pass,$judge" >> "$CSV"
      rm -rf "$sandbox"; trap - EXIT
    done
  done
done

echo "bench: aggregating →"
"$BENCH_DIR/lib/aggregate.sh" "$CSV" > "$RESULTS/report.md"
echo "bench: done → $RESULTS/report.md"
cat "$RESULTS/report.md"
