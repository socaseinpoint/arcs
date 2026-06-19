# notes — doc-drift + orphan cleanup

Ground truth = `bin/arcs`. Verified before each edit:
- `cmd_status` prints board header `STREAM` (bin/arcs:234), candidates header
  `CANDIDATES (surfaced arc-candidates — promote with: arcs promote <slug>)` (bin/arcs:248).
- Single stream: goals + arcs both under `.arcs/arcs/`; goal dir = `NN-@slug` (cmd_new_goal,
  bin/arcs:217-226). No `.arcs/goals/` anywhere in the CLI.
- Real subcommands incl. `candidate` + `promote` (dispatch bin/arcs:426-440); candidates dir is
  `.arcs/candidates/` (cmd_candidate:382).

## Per item

### C1 — docs/DEPLOY.md (lines 36-37)
Block taught removed `.arcs/goals/01-payments/`. Rewrote comments to current stream:
`new-goal payments → .arcs/arcs/NN-@payments/`, `new-arc spike-redis → .arcs/arcs/NN-spike-redis/`.
Matches README quick-start phrasing (NN-@slug).

### C2 — delete 08 ghost
Verified empty (only empty workspace/output/arcs dirs, `find` shows 0 files) and untracked
(`git ls-files` empty, porcelain empty). `rm -rf .arcs/arcs/08-@immutable-goals-and-chains`.
Untracked + empty → frees no git history number; just a dead first attempt (live = 10-).

### H1 — examples/README.md sample board
`ARCS` → `STREAM`. Also aligned candidates header to the real CLI string and removed the blank
line before CANDIDATES (CLI prints them back-to-back). Did NOT add the lang:/rules: preamble —
kept the sample focused on the board, header accuracy is the drift fix.

### H2 — numbering gap 07→09→10
Resolved purely by deleting the 08 ghost. Live board now reads 07, 09, 10, 11 — no 08 phantom.
No code change.

### H3 — template/.arcs/goals/.gitkeep
Was git-TRACKED (`git ls-files` hit). `git rm` the .gitkeep + rmdir the goals/ dir. Template now
ships only `.arcs/arcs/.gitkeep`, matching its own README (which lists only `.arcs/arcs/`).

### M1 — bin/arcs top comment
Line 3 subcommand list: inserted `candidate · promote` (order matches README CLI line).
Line 4 meta-dir gloss: `.arcs/{arcs,rules}/` → `.arcs/{arcs,candidates,rules}/`.

### M2 — README landing URL
Two divergent URLs: line 9 canonical `arcs-delta.vercel.app`, line 77 stale
`arcs-socaseinpoints-projects.vercel.app`. 89b952e shipped prod to arcs-delta. Pointed line 77 at
the canonical. Both README links now consistent.

## Scope guardrails honored
- Did NOT touch SPEC.md versioning or any goal-doc `version:` field (reserved for goal-v2 / arc 10).
- Pre-existing working-tree change `D .arcs/candidates/01-immutable-goals-and-chains.md` is NOT
  mine — left untouched.
