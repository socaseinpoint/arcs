#!/usr/bin/env bash
# lib/judge.sh — LLM judge. Scores the produced result against the task rubric.
# Contract: <sandbox_dir> <task_dir> <judge_model>  → prints an integer 1..5 (0 on error)
set -euo pipefail

sandbox="${1:?sandbox}"; task_dir="${2:?task_dir}"; model="${3:?model}"

MAX_BYTES_PER_FILE="${MAX_BYTES_PER_FILE:-8000}"

# Snapshot the candidate's text files (skip arcs/git plumbing and binaries).
# NB: bash 3.2 + set -u loses the loop var after a nested $() inside while-read,
# so the binary check uses if-grep (no command substitution in the loop body).
snapshot="$(
  cd "$sandbox"
  find . -type f \
    -not -path './.arcs/*' -not -path './.git/*' \
    -not -name '__verify.sh' \
    | sort | while read -r f; do
      if file -b --mime "$f" 2>/dev/null | grep -q 'charset=binary'; then
        continue
      fi
      printf '%s\n' "----- FILE: $f -----"
      head -c "$MAX_BYTES_PER_FILE" "$f"
      printf '\n'
    done
)"

task="$(cat "$task_dir/prompt.md")"
rubric="$(cat "$task_dir/rubric.md")"

# Plain double-quoted string (no heredoc) — bash 3.2 safe.
prompt="You are a strict code-quality judge. Score the candidate work on the task below
against the rubric. Consider correctness, completeness, and quality.

=== TASK ===
$task

=== RUBRIC (1=poor, 5=excellent) ===
$rubric

=== CANDIDATE OUTPUT (files produced) ===
$snapshot

Output ONLY compact JSON, no prose: {\"score\": <integer 1-5>, \"reason\": \"<short>\"}"

out="$(claude -p "$prompt" --model "$model" --output-format json --permission-mode bypassPermissions 2>/dev/null || true)"

# claude -p wraps the assistant text in .result; the rubric verdict json is inside it.
score="$(printf '%s' "$out" \
  | jq -r '.result // ""' 2>/dev/null \
  | grep -oE '"score"[[:space:]]*:[[:space:]]*[1-5]' \
  | grep -oE '[1-5]' \
  | head -n1)"

[ -n "${score:-}" ] && echo "$score" || echo 0
