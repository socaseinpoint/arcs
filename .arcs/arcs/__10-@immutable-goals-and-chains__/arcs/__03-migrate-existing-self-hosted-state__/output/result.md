# result — migrate-existing-self-hosted-state

The repo's two existing goal docs migrated from the old `MM-<slug>-goal.md` + `version:` shape to
goal-v2 (single `<slug>-goal.md`, no version line). Only those two docs were touched.

## Renames (history preserved where tracked)
1. `__06-@landing-essence-first__/01-landing-essence-first-goal.md`
   → `__06-@landing-essence-first__/landing-essence-first-goal.md`  (`git mv` — was tracked)
2. `10-@immutable-goals-and-chains/01-immutable-goals-and-chains-goal.md`
   → `10-@immutable-goals-and-chains/immutable-goals-and-chains-goal.md`  (`mv` — was untracked)

## Edits
### goal 06 (landing, status done)
- Dropped `01-` from the H1; removed the `version: 01 (…)` line.
- `goal:` tightened to ≤12 words: "rebuild the arcs landing so payoff and how-to-start land instantly".
- FIXED stale "## Where we are": was "Building. … Now rewriting docs/index.html." → now reflects the
  shipped end-state (essence-first rewrite live at arcs-delta.vercel.app, goal done).
- Renders via the no-checklist fallback (raw sub-arc list).

### goal 10 (immutable-goals-and-chains, status active)
- Dropped `01-` from the H1; removed the `version: 01 (…)` line.
- `goal:` tightened to 12 words: "make goal intent immutable — aim changes spawn supersedes-linked
  arcs; checklist replaces versioning".
- REMOVED the `design-lock-goal-v2-model` checklist item (the model is locked in this very doc, not via
  a sub-arc, so it could never compute ✓). Checklist is now the 3 real impl items.
- "## Locked model" section left byte-for-byte unchanged.

## Resolution confirmed
`bin/arcs` resolves goal docs by the `*-goal.md` glob (line 345: `ls "$d"*-goal.md | sort | tail -1`),
no `MM-` prefix dependency. Both renamed files are found cleanly — confirmed by the render below.

## `arcs status` after migration

```
lang: en
rules: subagents
STREAM
  __01-subagent-delegation__           [done]    toggleable rules layer; subagents rule (delegate arcs + parallelize) ON by default
  __02-close-arcs-underscore__         [done]    close an arc by renaming NN-slug → __NN-slug__ (+ status done); numbering counts closed
  __03-changelog__                     [done]    add CHANGELOG.md (Keep a Changelog) — Unreleased + 0.1.0 baseline
  __04-close-requires-output__         [done]    arcs close refuses empty output/ (a closed arc must carry a self-contained result); -f overrides
  __05-unify-goals-into-single-arc-stream__ [done]    drop .arcs/goals/; one numbered stream, goal = NN-@slug; descriptive slugs; migrate repo+examples
  __06-@landing-essence-first__        [done]    rebuild the arcs landing so payoff and how-to-start land instantly
      __01-redesign__                  [done]    rebuild docs/index.html essence-first — agent-payoff hero, quickstart high, spec demoted
  __07-move-rules-to-global-library__  [done]    rule bodies global in <repo>/rules/; on/off via .arcs/config rules=; local override in .arcs/rules/
  __09-add-ideas-candidate-backlog__   [done]    candidates backlog — .arcs/candidates/NN-slug.md with from:; arcs candidate/promote; status section
  __11-fix-doc-drift-and-orphan__      [done]    fix doc drift (DEPLOY/examples/template/bin/README) + delete the empty untracked 08 goal-v2 ghost so docs match the CLI's single .arcs/arcs/ stream + STREAM board
  __12-review-arc-writing-quality__    [done]    judge the writing quality of every arc/goal as a unit of the method — per-arc verdict, cross-cutting patterns, template call
  10-@immutable-goals-and-chains       [active]  make goal intent immutable — aim changes spawn supersedes-linked arcs; checklist replaces versioning   (1/3 ✓)
      ✓ cli-goal-v2                    → 01-cli-goal-v2
      ○ rewrite-docs-for-goal-v2      
      ○ migrate-existing-self-hosted-state
      02-rewrite-docs-for-goal-v2      [active]  
      03-migrate-existing-self-hosted-state [active]
```

## Board intact
- Goal 06 renders via the no-checklist fallback (`__01-redesign__ [done]` raw sub-arc list).
- Goal 10 renders `(1/3 ✓)` with the 3 real items; `cli-goal-v2` already ✓ → `01-cli-goal-v2`.
- No other arc, closed sub-arc content, SPEC/SKILL/docs/examples, or `bin/arcs` was touched.
- No git commit made.
