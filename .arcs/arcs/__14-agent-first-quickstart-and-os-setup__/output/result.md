# Result — agent-first quickstart + per-OS setup

Reframed the web presence so the **agent-driven** path is the hero, and turned Install into a
real **per-OS Setup** (incl. Windows). All static, no build step, reused the existing design system.

## Files touched
- `docs/index.html` — landing start section (§03) reframed agent-first.
- `docs/docs.html` — §08 Install → "Setup & install" with per-OS subsections; anchor `#install`→`#setup`
  (both navs updated); command-reference intro reframed to "agent runs these".
- `docs/DEPLOY.md` — Requirements: added Windows (WSL/Git Bash) + agent-driven one-liner.

## Per surface

### Landing (`docs/index.html`)
- Section §03 retitled **"Install once. Then just talk to your agent."** Sub: "You don't run `arcs`
  by hand — your agent does."
- Removed the manual `arcs init` / `arcs status` command block. Now ONE install command, then three
  numbered prose beats: (1) install once — what the installer wires (PATH + Claude skill + hooks);
  (2) **talk to your agent** — it drives `arcs` for you (opens arc/goal, works input→workspace→output,
  closes); (3) **peek if you want** — `arcs status` is the only line a human might run; `new-goal`/
  `new-arc`/`close` framed as "what the agent runs".
- Added inline **"Setup for your OS →"** link → `docs.html#setup`. Hero/value-props/aesthetic untouched.

### Docs (`docs/docs.html`)
- Section now **"08 · Setup & install"** (`id="setup"`). Leads with the usage model: install the CLI
  once; the agent drives it thereafter; humans rarely type `arcs` (status aside).
- **macOS / Linux**: one-command install (honest about `$SHELL`-derived rc file, skill symlink path,
  python3-gated hook registration) + the manual PATH variant.
- **Windows**: bash CLI → run under **WSL** (recommended) or **Git Bash**, shown side-by-side in a
  def-grid, with concrete steps for each (`wsl --install` → Ubuntu shell → clone → install.sh; Git for
  Windows → Git Bash → clone → install.sh). Honest notes on where home/PATH/skill/hooks land per env
  and that **native PowerShell isn't supported yet**.
- Kept Enforcement, command reference, and worked example. "Use it in a project" → **"Opting a project
  in"**, reframed so the figure caption reads "what the agent runs" and the human-run line is `arcs status`.
- `#install`→`#setup` updated in header nav + sidebar scroll-spy list (so scroll-spy still resolves).

### DEPLOY.md
- `## Requirements` now lists macOS/Linux natively + Windows via WSL/Git Bash (where PATH/skill/hooks
  land), notes `python3` for hook registration, and adds: the CLI is **agent-driven** — install once,
  then the agent runs `arcs` for you.

## Verification
- Served `docs/` over local HTTP: both pages 200.
- Playwright DOM checks: landing start heading + both links resolve to `docs.html#setup`; the `#setup`
  anchor scrolls correctly (top under sticky header); heading order h2→h3→h4 with **0 order jumps**
  across the docs page; Windows/WSL content present; **no stale `#install` references** anywhere.
- Screenshots of both surfaces reviewed — design system intact, no layout breakage.

## Follow-up (optional)
- None required. If `style.css?v=3` is cache-busted on deploy, no version bump was needed (no CSS change).
