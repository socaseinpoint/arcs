# benchmark-pluggable-structures — goal result

Built a working, structure-agnostic benchmark stand (`bench/`) and validated it on
a real 24-cell Sonnet run. The pluggable `arms/` layer (bare vs arcs-default)
seeds candidate 02.

## First-run verdict

On trivial coding tasks: arcs-default vs bare → input ×3.0, time ×2.2, cost ×1.5,
quality flat-to-slightly-worse (both 100% tests; judge 4.83 vs 5.00). The measured
**floor** — these tasks sit below where structure pays off; not a verdict against
the method.

## Sub-arcs

- `01-scaffold-harness` — bench/ harness (run.sh, arms, lib, README), bash-3.2-safe
- `02-author-3-tasks` — 3 tests-first Python tasks (slugify, balanced, csv-stats)
- `03-first-run-and-report` — real 24-cell run + findings → `03-…/output/`

## Open follow-up (next goal, not this one)

Non-trivial / multi-step task suite + alternative-structure arms once CLI
pluggability lands — only then can "which structure fits which work" be answered.
Candidate to re-surface when ready.
