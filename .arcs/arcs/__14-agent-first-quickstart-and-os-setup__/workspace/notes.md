# Working notes — agent-first quickstart + per-OS setup

## Ground truth read before writing
- `install.sh`: picks RC from `$SHELL` (zsh→~/.zshrc, bash→~/.bashrc, else ~/.profile),
  appends a PATH line for `<repo>/bin`. Symlinks `~/.claude/skills/arcs -> <repo>/skill`
  IF `~/.claude/skills` exists. Registers `arcs-hook` (SessionStart+UserPromptSubmit) +
  `arcs-gate` (PreToolUse Edit|Write|MultiEdit) in `~/.claude/settings.json` IF `~/.claude`
  exists AND `python3` available (else prints manual line). `.bak` backup, idempotent.
- `bin/arcs update`: git pull --ff-only + re-runs install.sh (re-wires PATH/skill/hooks).
- So Windows honesty: under WSL the home is the Linux home; under Git Bash $SHELL is bash so
  PATH → ~/.bashrc in Git Bash home, hooks need python3 on PATH or they're skipped.

## Decisions
- Renamed docs anchor `#install` → `#setup` (section heading "Setup & install"). Updated both
  nav menus (header + aside scroll-spy list) so scroll-spy + links stay correct.
- Landing: removed the manual `arcs init/status` command block from the start section. Kept ONE
  install command + 3 numbered prose beats (install once / talk to agent / peek via `arcs status`).
  Any other arcs commands framed as "what the agent runs".
- Added "Setup for your OS →" inline-link (existing `.inline-link` style) → docs.html#setup.
- Docs §08: leads with usage model, then macOS/Linux (one-command + manual PATH variant),
  Windows (WSL recommended + Git Bash, def-grid for the two, honest "no PowerShell yet"),
  Enforcement, "Opting a project in" (reframed "Use it in a project" → agent runs it), Updating.
- Reused existing components only: figure/pre/.k/.c spans, .def-grid/.def, .callout-free,
  .inline-link, .ordered. No new CSS, no JS change needed.

## Verification (local HTTP + Playwright DOM)
- index.html & docs.html both HTTP 200.
- Landing start h2 = "Install once. Then just talk to your agent."; both links → docs.html#setup.
- docs #setup anchor scrolls to top:62px (under sticky header). h2→h3→h4 order clean, 0 jumps across page.
- Windows path present (`wsl --install`, Git Bash steps). No stale `#install` refs anywhere.
- Screenshots reviewed: design system intact on both pages.
