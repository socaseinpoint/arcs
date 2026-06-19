#!/usr/bin/env bash
# arms/arcs-default/run.sh — agent works through the default arc structure.
# Contract: <sandbox_dir> <task_dir> <model> <raw_json_out>
#   - inits .arcs/ in the sandbox, puts the arcs CLI on PATH
#   - prompt instructs: open an arc, work input→workspace→output, then implement
set -euo pipefail

sandbox="${1:?sandbox}"; task_dir="${2:?task_dir}"; model="${3:?model}"; raw="${4:?raw}"

# Locate this repo's bin so the sandbox agent can call `arcs`.
ARCS_BIN="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)/bin"
[ -x "$ARCS_BIN/arcs" ] || { echo "arcs-default: bin/arcs not found at $ARCS_BIN" >&2; exit 1; }

task="$(cat "$task_dir/prompt.md")"

cd "$sandbox"
PATH="$ARCS_BIN:$PATH" arcs init en >/dev/null 2>&1 || true

# Double-quoted string (no heredoc) — avoids bash 3.2 heredoc-in-$() parse bugs.
preamble="You are working in a project that uses the arcs method (.arcs/ is present, the
\`arcs\` CLI is on PATH). Before implementing, work through an arc:
  1. \`arcs new-arc <slug>\` to open an arc for this task.
  2. Note the task in the arc input/, do the work in workspace/, and put the
     final result where the task asks for it.
Then implement the task below. Use the arcs structure to organize your work.

TASK:
$task"

PATH="$ARCS_BIN:$PATH" claude -p "$preamble" \
  --model "$model" \
  --output-format json \
  --permission-mode bypassPermissions \
  > "$raw"
