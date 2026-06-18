#!/usr/bin/env bash
# arcs installer — adds the CLI to PATH and (optionally) installs the Claude skill.
# Run from the cloned repo: ./install.sh
set -euo pipefail

# Resolve this repo's absolute dir (follow symlinks).
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"; SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
REPO="$(cd -P "$(dirname "$SOURCE")" && pwd)"

# Pick a shell rc.
case "${SHELL##*/}" in
  zsh)  RC="$HOME/.zshrc" ;;
  bash) RC="$HOME/.bashrc" ;;
  *)    RC="$HOME/.profile" ;;
esac

LINE="export PATH=\"$REPO/bin:\$PATH\""
if grep -qF "$REPO/bin" "$RC" 2>/dev/null; then
  echo "PATH: already in $RC"
else
  printf '\n# arcs\n%s\n' "$LINE" >> "$RC"
  echo "PATH: added arcs/bin to $RC"
fi

# Optional Claude skill symlink.
SKILLS="$HOME/.claude/skills"
if [ -d "$SKILLS" ]; then
  ln -sfn "$REPO/skill" "$SKILLS/arcs"
  echo "skill: linked $SKILLS/arcs -> $REPO/skill"
else
  echo "skill: skipped (no $SKILLS); run later: ln -s $REPO/skill ~/.claude/skills/arcs"
fi

# Enforcement hooks in ~/.claude/settings.json:
#   arcs-hook → SessionStart + UserPromptSubmit (reminder + board)   [advisory]
#   arcs-gate → PreToolUse Edit|Write|MultiEdit (block edits till an arc is open)  [hard]
CLAUDE_DIR="$HOME/.claude"
if [ -d "$CLAUDE_DIR" ] && command -v python3 >/dev/null 2>&1; then
  SETTINGS="$CLAUDE_DIR/settings.json" HOOKCMD="$REPO/hooks/arcs-hook" GATECMD="$REPO/hooks/arcs-gate" python3 - <<'PY'
import json, os
path = os.environ["SETTINGS"]; hook = os.environ["HOOKCMD"]; gate = os.environ["GATECMD"]
try:
    with open(path) as f: data = json.load(f)
except Exception:
    data = {}
hooks = data.setdefault("hooks", {})
changed = False

def has(event, cmd):
    return any(
        h.get("command") == cmd
        for g in hooks.get(event, []) if isinstance(g, dict)
        for h in g.get("hooks", []) if isinstance(h, dict)
    )

for event in ("SessionStart", "UserPromptSubmit"):
    if not has(event, hook):
        hooks.setdefault(event, []).append({"hooks": [{"type": "command", "command": hook}]})
        changed = True

if not has("PreToolUse", gate):
    hooks.setdefault("PreToolUse", []).append(
        {"matcher": "Edit|Write|MultiEdit", "hooks": [{"type": "command", "command": gate}]})
    changed = True

if changed:
    if os.path.exists(path):
        try: os.replace(path, path + ".bak")
        except Exception: pass
    with open(path, "w") as f: json.dump(data, f, indent=2)
    print("hooks: registered arcs-hook + arcs-gate in", path, "(backup: settings.json.bak)")
else:
    print("hooks: already registered in", path)
PY
else
  echo "hooks: skipped (need ~/.claude + python3); see docs/DEPLOY.md to add them manually"
fi

echo
echo "Done. Open a new shell (or: source $RC), then:"
echo "  cd <your-project> && arcs init && arcs new-goal <slug> && arcs status"
