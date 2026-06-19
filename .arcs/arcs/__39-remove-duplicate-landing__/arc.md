# 39-remove-duplicate-landing

goal: remove this repo's duplicate landing + Vercel link — landing now deploys from the central `distribution` repo, so a stray `vercel deploy` here could clobber the canonical site
status: done

## input
- `docs/` mixed a landing (index.html + style.css + app.js + docs.html) WITH product docs (DEPLOY.md)
- `vercel.json` (`outputDirectory: docs`) + `.vercel/` link both present in this repo
- claim to verify: `arcs-delta.vercel.app` is now served by the central `distribution` repo

## output → pointers
- output/report.md — what was removed, what was kept (and why), confirmation the live URL resolves
- shipped as commit b2544d7 (6 files, 1253 deletions)
