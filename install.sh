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

echo
echo "Done. Open a new shell (or: source $RC), then:"
echo "  cd <your-project> && arcs init && arcs new-goal <slug> && arcs status"
