#!/usr/bin/env bash
# arms/bare/run.sh — baseline: agent gets the task only. No arcs.
# Contract: <sandbox_dir> <task_dir> <model> <raw_json_out>
#   - cwd-agnostic; works inside the sandbox
#   - leaves produced files in sandbox
#   - writes the claude -p JSON result to raw_json_out
set -euo pipefail

sandbox="${1:?sandbox}"; task_dir="${2:?task_dir}"; model="${3:?model}"; raw="${4:?raw}"

prompt="$(cat "$task_dir/prompt.md")"

cd "$sandbox"
claude -p "$prompt" \
  --model "$model" \
  --output-format json \
  --permission-mode bypassPermissions \
  > "$raw"
