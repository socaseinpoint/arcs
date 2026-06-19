# Result — Vercel git auto-deploy

Push-to-main now auto-deploys the site. No more manual `vercel --prod`.

## What was done
- Connected the Vercel project `arcs` to GitHub `socaseinpoint/arcs` (`vercel git connect`).
- Project Root Directory is the repo root (`.`), so added root `vercel.json` with
  `outputDirectory: "docs"` → a repo-root build serves `docs/` at the domain.
- Validated with a preview deploy from the repo root (landing + `/docs.html` = 200) BEFORE enabling
  prod, so the connection couldn't break live.
- Confirmed: the `vercel.json` commit push triggered a Production deploy automatically (no manual
  command) and arcs-delta.vercel.app serves the new landing.

## Pointers
- `vercel.json` (repo root) — `outputDirectory: docs`.
- `.vercel/` stays git-ignored (Vercel link metadata, not shared).
- Also did a one-off manual `vercel --prod` earlier this arc to fix the stale live site immediately,
  before auto-deploy was wired.

## Note
Native-Windows tooling (PowerShell installer) is still out of scope — the CLI is bash (WSL/Git Bash).
