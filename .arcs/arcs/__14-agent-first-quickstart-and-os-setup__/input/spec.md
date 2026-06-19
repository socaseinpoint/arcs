# Spec — agent-first quickstart + per-OS setup

Two corrections to the just-shipped web presence, from user feedback on the live page.

## Problem
1. The landing quickstart reads like the user runs `arcs` BY HAND (`arcs new-goal`, `arcs new-arc`,
   `arcs close`…). Wrong mental model: **arcs is tooling the AGENT runs, not the human.** A base user's
   path is: install once → use it THROUGH Claude (the agent calls `arcs` itself). The human almost never
   types `arcs` (maybe `arcs status` to peek). The landing must teach the agent-driven path.
2. Setup only covers macOS/Linux. Need **per-OS setup incl. Windows**. The CLI is bash, so Windows runs
   via WSL or Git Bash — document it honestly per-OS.
3. Detailed setup should be a SEPARATE thing (in the deep docs), not bloating the landing.

## Surface 1 — LANDING (`docs/index.html`) — reframe the "20-second / start" section to agent-first
Replace the manual-CLI quickstart with the real base-user flow:
1. **Install once** — one command (`git clone https://github.com/socaseinpoint/arcs ~/arcs &&
   cd ~/arcs && ./install.sh`), one line on what it does (PATH + Claude skill + hooks).
2. **Then just talk to your agent** — open your project in Claude Code and tell it what to build. The
   agent runs `arcs` for you: it opens an arc/goal, works input→workspace→output, closes it. You don't
   type commands. Make this the hero of the section.
3. **Peek if you want** — optional one-liner: run `arcs status` to see the board the agent is keeping.
- Keep the manual command list OFF the landing (it's what the agent does, not a user how-to). If you
  show any `arcs` commands, frame them as "what the agent runs", not "what you type".
- Per-OS detail does NOT go on the landing — add a small "Setup for your OS →" link to the docs setup section.
- Keep the existing aesthetic + everything else (hero, value props, honest framing) intact.

## Surface 2 — DEEP DOCS (`docs/docs.html`) — make Install a proper per-OS "Setup" section
- Lead the section by stating the usage model: **you install the CLI once; from then on your agent
  drives it.** Humans rarely type `arcs` (status/peek aside).
- Per-OS setup, clearly separated (own subsections / boxes):
  - **macOS / Linux** — native bash: the one-command install + the manual PATH variant (from DEPLOY.md).
  - **Windows** — the CLI is bash, so run it under **WSL** (recommended) or **Git Bash**. Give the
    concrete steps for each: install WSL/Git Bash, clone, `./install.sh`, note the Claude skill symlink
    + PATH land in the WSL/Git-Bash home. Call out honestly that native PowerShell isn't supported yet.
- Keep the command reference + worked example as-is, but ensure any "you run X" wording reflects that
  the AGENT runs arcs (adjust phrasing where it implies the human drives the CLI).

## Surface 3 — `docs/DEPLOY.md`
- "## Requirements" currently says "macOS / Linux". Add Windows via WSL/Git Bash. Add a one-liner that
  the CLI is agent-driven (installed once, then the agent runs it).

## Constraints
- Static, no build step, reuse the design system (`style.css`/`app.js`); intentional, not template.
- Ground every command in actual `bin/arcs` / `install.sh` behavior — read `install.sh` to state
  honestly what it wires on each OS (PATH file, skill symlink path, hook registration).
- `en`, humanized. Semantic HTML, keyboard-nav, reduced-motion respected. Do NOT git commit.

## Verify
- Landing's start section no longer reads as a manual CLI how-to; agent-driven path is the hero.
- Docs has a clear per-OS Setup with a real Windows path (WSL + Git Bash).
- Internal links still resolve (landing → docs setup anchor).
Write notes → workspace/, output/result.md (what changed per surface + files). Fill arc.md
`goal:` + output pointers (leave status active; orchestrator closes + deploys).
