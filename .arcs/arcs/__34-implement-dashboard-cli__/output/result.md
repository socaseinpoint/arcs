# result — `arcs dashboard` shipped

Read-only static portfolio viewer over every `.arcs/` project on disk. Implements the
locked design (arc 33 spec.md): perspective engine, portfolio + project levels, 5 lenses,
local static-viewer distribution. Layer boundary held — the dashboard **only reads** arc
dirs, never writes them.

## What shipped
- **`dashboard/template.html`** — `prototypes/dashboard-v2.html` with the hardcoded data
  literals (CLUSTERS / ARCS_ARCS / PROJECTS / DIGEST) replaced by one `/*__ARCS_DATA__*/`
  placeholder. All styles + render functions + helpers + `ST`/`DGK` kept verbatim.
- **`dashboard/scan.sh`** — pure-bash scanner (~230 lines, no python/node/jq). Discovers
  projects via `find … -path '*/.arcs/arcs'`; per arc emits `n, slug (keeps @), st,
  isGoal, goal, cl(theme:), rel(release:), inp/out (first bullet, skips placeholders),
  ws (workspace file count), sub (goal sub-arcs), from (resolved from supersedes:/prev:
  within the project)`. Builds CLUSTERS from themes seen (+ always untagged) and a
  git-derived DIGEST (today/week commit counts + commit-subject bullets → ship/close/
  open/feat/idle + what's-left active arcs). Hand-rolled JS escaping via `jstr()`.
- **`bin/arcs`** — added `cmd_dashboard()` + `dashboard)` dispatch + a help line. Roots
  default to parent-of-cwd + cwd (siblings = portfolio); override with `arcs dashboard
  <root…>`. Injects scanner output into the template via `awk` (placeholder split, not
  sed), writes `.arcs/.cache/dashboard.html`, opens via `open`/`xdg-open`/`start`, always
  prints the path.
- **`.arcs/.gitignore`** — `.cache/` so the generated page stays out of git.

## Distribution = zero-server, inline-data (decided)
Spec §6 said "boots a localhost server". Chose **inline-data injection** instead: scan →
inject JSON into the template → write one self-contained HTML → open as `file://`. Sidesteps
CORS/port-conflicts/python; runs on macOS + Linux + Windows Git Bash with bash alone.
Re-run `arcs dashboard` to refresh. (A server can come later if live-reload is wanted.)

## Verified (browser, live data)
Rendered the generated page (served on a throwaway port only because Playwright blocks
`file://`). No JS console errors (only a favicon 404). Screenshots in this dir:
- `screenshot-portfolio.png` — overview: 7 projects · 54 arcs · 4 in-flight · 12 goals,
  cross-project NOW (incl. this very arc 34, active), project grid with mini-pulses.
- `screenshot-board.png` — arcs project board: 33 arcs · 97% closed · full enriched stream.
- `screenshot-digest.png` — digest: "44 commits across 4 active projects", per-project
  git bullets + what's-left.
All five lenses (overview / digest / all-active / all-goals; board / lineage / timeline /
map) render; scope switch + drill-in + display controls work.

## Honest gaps
- **theme / release / lineage are blank on real data** — no `theme:` / `release:` /
  `supersedes:` fields exist on disk yet. The scanner reads them when present; views
  degrade honestly (untagged / "—" / "no recorded lineage"). Data gap, not code gap.
- **Digest narrative = facts only** — commit counts + keyword-classified commit subjects.
  No invented prose (per spec: facts deterministic, never hallucinated).
- bash 3.2 safe (no `declare -A`), matching `bin/arcs` style.

## Revision — whole-machine + run-from-anywhere
First cut defaulted roots to parent-of-cwd + cwd and required `.arcs/` in cwd (a wart — the
dashboard is portfolio-global). Fixed:
- Default root = `$HOME` — scans **every** `.arcs/` project on the machine, not just siblings.
- `arcs dashboard` runs from **any** directory; `arcs dashboard <root…>` still overrides.
- `scan.sh` find prunes heavy trees (node_modules/Library/.Trash/.git/caches), depth 8 →
  whole-`$HOME` scan in ~5s.
- Output cached to `${XDG_CACHE_HOME:-~/.cache}/arcs/dashboard.html` (per-user, cwd-independent).

## Follow-ups (candidates)
- Add a "Dashboard" section/page to the landing (spec §8.5) — separate from the method.
- Optional `theme:` / `release:` arc.md fields so map/timeline/lineage carry real signal.
