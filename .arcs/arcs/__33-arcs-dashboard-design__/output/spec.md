# arcs dashboard — design spec (locked 2026-06-19)

> **Layer boundary (non-negotiable).** This is a *presentation layer* — tooling on top
> of arcs. It is **separate from arcs core** (method, `bin/arcs`, `.arcs/` format).
> The dashboard **only reads** `.arcs/` directories; it never writes them. The core
> can be explained, versioned, and shipped without ever mentioning the dashboard, and
> vice-versa. On the landing, the dashboard is its own section/page, not woven into the
> method explanation.

## 1. Core (what the dashboard *is*)

Not one screen — a **perspective engine**: one dataset (every `.arcs/` on disk) seen
through **swappable lenses**, with **display controls** to turn the projection.
Two levels:

- **Portfolio** — all arcs projects on the machine.
- **Project** — drill into one; its arcs through the project lenses.

## 2. Data model (read from disk)

Scan the filesystem for `.arcs/arcs/` directories. Per project, per arc directory:

| field | source |
|---|---|
| `id`, `slug` | dir name `NN-slug` / `__NN-slug__` |
| `status` | open dir = active; `__…__` wrapped = closed |
| `isGoal` | slug starts with `@` |
| `goal` | `goal:` line in `arc.md` |
| `from` / `supersedes` | `from:` / `supersedes:` lines → lineage edges |
| `sub` | nested `arcs/` count (goal arcs) |
| `input` / `output` | first bullet of `## input` / `## output` sections |
| `workspace` | file count in `workspace/` |
| timestamps | **git** (commit/mtime per arc dir) — used by digest |

Theme/cluster and release are **derived/optional** — not all projects tag them; views
degrade honestly when absent (show "untagged" / "no recorded lineage").

## 3. Lenses

**Portfolio level**
- **overview (home)** — global pulse (projects / arcs / in-flight / active projects /
  goals) + **NOW across all projects** (every active arc, project-tagged) + project grid
  (each card: mini-pulse, closed%, current focus, click to drill).
- **digest** — interpreted "what did I do **today** / **this week** / what's **left**",
  read from git. Per-project narrative + bullets (ship/close/open/feat) + a what's-left
  list. The one-line interpretation may be LLM-written; **the facts are deterministic**
  (commits + arc closures), never hallucinated.
- **all active** — cross-project in-flight, as cards.
- **all goals** — every goal arc across projects, grouped by project.

**Project level**
- **board (home)** — pulse + in-flight NOW + the full stream as enriched rows
  (theme stripe, `⑂N` spawned, `↳NN` from, output-written dot, release chip).
- **lineage** — SVG graph of `from`/`supersedes` edges; hubs (≥3 children) highlighted;
  2-line nodes (id + goal); honest summary ("N in lineage, M standalone").
- **timeline** — arcs by release (falls back to a single ordered history lane when a
  project tags no releases).
- **map** — arcs clustered by theme (only where themes exist).

## 4. Display controls (apply across lenses)
group-by (flat / status / theme / release) · color-by (status / theme) ·
show-closed toggle · compact density.

## 5. Detail drawer (click any arc, anywhere)
project / id · status + goal/theme/release badges · goal (lead) · goal-arc sub-arc
progress · **input → workspace → output** as a vertical stage track (filled steps glow,
empty steps italic "not yet written") · lineage (from / spawned, click to navigate) ·
on-disk path. All from real `arc.md` content.

## 6. Distribution (decided)
**Local CLI static viewer.** `arcs dashboard` boots a localhost server, opens the
browser, reads `.arcs/` live. Zero install, runs anywhere, matches the prototype.
- *Rejected for now:* desktop app (Tauri/Electron) — too heavy for a read-only tool;
  revisit later **if** background disk-scan + "arc closed" notifications are wanted
  (Tauri then — same HTML front, cheap port).
- *Rejected:* web service — would mean uploading private `.arcs/` to the cloud, against
  the point of a local instrument.

## 7. Non-goals (today)
No writes to `.arcs/`. No auth. No cloud. No editing arcs from the UI. Read-only.

## 8. Build path (for the implementation arc)
1. `arcs dashboard` subcommand → static file server + browser open.
2. A scanner: walk disk for `.arcs/arcs/`, parse arcs + git timestamps → JSON.
3. Serve the JSON to the prototype front-end (lift from `prototypes/dashboard-v2.html`).
4. Keep front-end framework-free, single-file, OKLCH dark theme (matches arcs brand).
5. Landing: add a separate "Dashboard" section/page — presentation layer, not core.
