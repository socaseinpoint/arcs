# Working prototype

Lives at repo root in **`prototypes/`** (kept out of `.arcs/` on purpose — it's the
presentation layer, not core). Self-contained HTML, no build, no network. Open directly
or serve via any static server.

| file | proves |
|---|---|
| `prototypes/dashboard-v0.html` | first cut — board + lineage + drawer, dark OKLCH theme |
| `prototypes/dashboard-v1.html` | single-project: rail with view switch + display settings; board-as-home (pulse + NOW + enriched rows); cleaner 2-line lineage; rich drawer (input→workspace→output stage track) |
| `prototypes/dashboard-v2.html` | **current** — multi-project portfolio: scope switch, cross-project NOW, project grid, drill-in, **digest** lens (today/week, real git data), all v1 lenses scoped per project |

All data in the prototypes is **real**, pulled from the four live arcs projects on disk
(`arcs`, `job_search`, `ai-news-channel-aggregated`, `research-research`). The arcs
project carries deep data (lineage hub, clusters, releases, input/output); the others
carry their real arcs with honest "no lineage/themes yet" fallbacks.

Next: the implementation arc turns `prototypes/dashboard-v2.html` into the front-end
served by `arcs dashboard` (see spec §8). Build it as a **separate arc, with a subagent**,
per the user's plan.
