# Result — doc drift + broken orphan fixed

All 6 audit items resolved (C1, C2, H1, H3, M1, M2) + H2 resolved as a side effect of C2.
Every fix was verified against `bin/arcs` (ground truth) and re-read after editing. The live
`arcs status` board now renders clean: sequence 07 → 09 → 10 → 11, no 08 phantom, header `STREAM`.

## Per-item status

| Item | Status | File:loc | What changed |
|------|--------|----------|--------------|
| **C1** | fixed | `docs/DEPLOY.md:36-37` | "Use it in a project" block taught removed `.arcs/goals/01-payments/`. Rewrote to current single stream: `new-goal payments → .arcs/arcs/NN-@payments/`, `new-arc spike-redis → .arcs/arcs/NN-spike-redis/`. |
| **C2** | fixed | `.arcs/arcs/08-@immutable-goals-and-chains/` (deleted) | Empty + untracked ghost (first goal-v2 attempt; live = `10-`). Verified 0 files + not in git, then `rm -rf`. No git number freed. |
| **H1** | fixed | `examples/README.md:34,39` | Sample board header `ARCS` → `STREAM` (matches `cmd_status`). Also aligned the candidates header to the real CLI string and removed the stray blank line above it. |
| **H2** | resolved | — | Numbering gap 07→09→10 was the 08 ghost; deleting it (C2) closes the gap. No code change. |
| **H3** | fixed | `template/.arcs/goals/.gitkeep` (deleted) | Tracked file shipping the removed `.arcs/goals/` dir, contradicting the template's own README. `git rm` + removed the empty `goals/` dir. Template now ships only `.arcs/arcs/`. |
| **M1** | fixed | `bin/arcs:3-4` | Top comment omitted new commands. Added `candidate · promote` to the subcommand list; updated meta-dir gloss `.arcs/{arcs,rules}/` → `.arcs/{arcs,candidates,rules}/`. |
| **M2** | fixed | `README.md:77` | Two divergent landing URLs. Pointed the stale `arcs-socaseinpoints-projects.vercel.app` at canonical `arcs-delta.vercel.app` (shipped prod in 89b952e). Both README links now consistent. |

## Files touched
- `docs/DEPLOY.md` (C1)
- `.arcs/arcs/08-@immutable-goals-and-chains/` — deleted (C2)
- `examples/README.md` (H1)
- `template/.arcs/goals/.gitkeep` + `template/.arcs/goals/` — deleted (H3)
- `bin/arcs` (M1)
- `README.md` (M2)

## Guardrails honored
- SPEC.md versioning section and all goal-doc `version:` fields left untouched (reserved for goal-v2 / arc 10).
- Pre-existing working-tree deletion `D .arcs/candidates/01-immutable-goals-and-chains.md` is not from this arc — left as-is.
- No `arcs close`, no git commit (orchestrator handles those).

## Pointers
- Working notes + diffs: `workspace/notes.md`
- Audit source: `../10-@immutable-goals-and-chains/workspace/coherence-audit.md`
