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

# Optional enforcement hook in ~/.claude/settings.json (SessionStart + UserPromptSubmit).
CLAUDE_DIR="$HOME/.claude"
HOOK="$REPO/hooks/arcs-hook"
if [ -d "$CLAUDE_DIR" ] && command -v python3 >/dev/null 2>&1; then
  SETTINGS="$CLAUDE_DIR/settings.json" HOOKCMD="$HOOK" python3 - <<'PY'
import json, os
path = os.environ["SETTINGS"]; cmd = os.environ["HOOKCMD"]
try:
    with open(path) as f: data = json.load(f)
except Exception:
    data = {}
hooks = data.setdefault("hooks", {})
changed = False
for event in ("SessionStart", "UserPromptSubmit"):
    groups = hooks.setdefault(event, [])
    present = any(
        h.get("command") == cmd
        for g in groups if isinstance(g, dict)
        for h in g.get("hooks", []) if isinstance(h, dict)
    )
    if not present:
        groups.append({"hooks": [{"type": "command", "command": cmd}]})
        changed = True
if changed:
    if os.path.exists(path):
        try: os.replace(path, path + ".bak")
        except Exception: pass
    with open(path, "w") as f: json.dump(data, f, indent=2)
    print("hook: registered arcs-hook in", path, "(backup: settings.json.bak)")
else:
    print("hook: already registered in", path)
PY
else
  echo "hook: skipped (need ~/.claude + python3); see docs/DEPLOY.md to add it manually"
fi

echo
echo "Done. Open a new shell (or: source $RC), then:"
echo "  cd <your-project> && arcs init && arcs new-goal <slug> && arcs status"
