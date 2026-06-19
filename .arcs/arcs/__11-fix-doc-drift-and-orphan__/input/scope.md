# Cleanup scope — doc drift + broken orphan

Source: coherence audit run 2026-06-18 (see ../10-@immutable-goals-and-chains/workspace/coherence-audit.md).
The arcs method's core (SPEC ↔ bin/arcs CLI) is coherent; drift is in stale docs + one broken
self-hosted goal. Fix all items below. The repo is self-hosting — fixes must match what the CLI
actually does today (single `.arcs/arcs/NN-@slug/` stream; `.arcs/goals/` was removed in arc 05;
board header is `STREAM`; commands include candidate/promote).

## Items to fix
- **C1 (CRITICAL)** `docs/DEPLOY.md` — "Use it in a project" block teaches the REMOVED `.arcs/goals/`
  dir (`arcs new-goal payments # → .arcs/goals/01-payments/`). Goals now live in the single
  `.arcs/arcs/NN-@slug/` stream. Rewrite to current reality.
- **C2 (CRITICAL)** `.arcs/arcs/08-@immutable-goals-and-chains/` — empty, untracked, no goal doc,
  doesn't render in `arcs status`. Dead first attempt at goal-v2; live version is `10-`. DELETE it
  (`rm -rf`). It's empty + untracked so no number is "freed" in git history — note the removal.
- **H1 (HIGH)** `examples/README.md` — sample board output shows old `ARCS` header; CLI now prints
  `STREAM`. Update sample output to match.
- **H3 (HIGH)** `template/.arcs/goals/.gitkeep` — ships the removed `.arcs/goals/` dir, contradicts
  the template's own README. Remove the dir/gitkeep.
- **M1 (MED)** `bin/arcs` top-of-file comment — omits `candidate`/`promote`/`candidates/`. Add them.
- **M2 (MED)** README links two different landing URLs: `arcs-delta.vercel.app` vs
  `arcs-socaseinpoints-projects.vercel.app`. Canonical is `arcs-delta.vercel.app` (commit 89b952e
  shipped prod there). Make all README links consistent to the canonical.

H2 (numbering gap 07→09→10) is RESOLVED by deleting the 08 ghost — no code change, just note it.

Do NOT touch SPEC.md's versioning section or any goal-doc `version:` field — those are intentionally
left for the goal-v2 goal (arc 10) to rewrite under supersession. Cleanup = drift only, not redesign.
