# Duplicate landing removal — report

Shipped as commit `b2544d7` (6 files, 1253 deletions).

## Verdict: confirmed duplicate
- `distribution/sites/arcs/.vercel/project.json` and this repo's `.vercel/project.json` carry the
  **identical** `projectId prj_pEdLZhGNpvmvDwzSEHLJJg2v77GE` (project "arcs") → one and the same
  Vercel project.
- distribution is source of truth: `sites/arcs/site.json` (url `arcs-delta.vercel.app`, `core →
  socaseinpoint/arcs`) + `build.sh`/`deploy.sh`. README table maps `arcs → arcs-delta.vercel.app`.
- Risk neutralized: a `vercel deploy` from THIS repo would have pushed `docs/` onto the same project,
  clobbering the canonical site with a stale copy.

## Removed (landing-only)
- `docs/index.html` — landing page
- `docs/style.css`, `docs/app.js` — landing assets (referenced only by the landing HTML)
- `docs/docs.html` — landing-only deep-docs page
- `docs/.gitignore` — vestigial landing-deploy plumbing (only ignored `.vercel`; root `.gitignore`
  already covers it)
- `vercel.json` — tracked; existed only to deploy the landing (`outputDirectory: docs`)
- `.vercel/` — this repo's Vercel link (untracked, removed from disk; not in commit)

## Kept deliberately
- `docs/DEPLOY.md` — product documentation (arcs setup guide), not landing
- `README.md`, `SPEC.md`, `CHANGELOG.md`, `RELEASING.md` — product docs
- README landing link `arcs-delta.vercel.app` — points at the live URL, correct to keep
- All source: `bin/`, `rules/`, `skill/`, `hooks/`, `template/`, `examples/`, `bench/`, `dashboard/`,
  `prototypes/`

## Live URL
`https://arcs-delta.vercel.app` → **HTTP 200**, served by distribution, unaffected by the deletes.

## Process note
Work was done before opening this arc — the arc was created retroactively to record it. The hook
flagged it; the right order is arc first, then work.
