# bench/ — does the arcs structure actually help?

A benchmark stand that runs the **same** small coding tasks through different
**arms** (ways of working) on one cheap model, then compares cost and quality.

- `arcs-default` — agent opens an arc and works input→workspace→output
- `bare` — agent gets the task only, no arcs

Same task, same model (Sonnet). We measure **tokens, wall-time, tests-pass, and
an LLM-judge score**, side by side. This is the foundation for candidate 02
(pluggable arc structures): `arms/` IS the swappable layer — a new structure is
just a new `arms/<name>/run.sh`; `tasks/` never change.

## Run

```bash
bench/run.sh --dry-run                 # one cell — smoke the harness
bench/run.sh                           # full matrix (all arms × tasks × 3 reps)
bench/run.sh --reps 5 --arms arcs-default,bare --tasks 01-foo,02-bar
```

Results land in `results/<timestamp>/`:
- `raw/<arm>-<task>-<rep>.json` — the raw `claude -p` JSON (usage, cost, duration)
- `runs.csv` — one row per run
- `report.md` — per-arm and per-arm×task means

## Layout

```
bench/
  run.sh            orchestrator: arms × tasks × reps, one sandbox per cell
  arms/<arm>/run.sh how to invoke the agent for that arm  (the pluggable layer)
  tasks/<t>/        prompt.md · verify.sh (exit 0 = pass) · rubric.md · starter/
  lib/judge.sh      LLM judge: result + rubric → score 1..5
  lib/aggregate.sh  runs.csv → report.md
  results/<ts>/     raw/ · runs.csv · report.md
```

## Adding a task

`tasks/<NN-slug>/` with:
- `prompt.md` — identical input handed to every arm
- `verify.sh` — objective check, runs in the sandbox, exit 0 = pass (write it
  first; it must fail on empty input)
- `rubric.md` — 1–5 scale for the LLM judge
- `starter/` — optional files copied into the sandbox before the run

## Adding an arm

`arms/<name>/run.sh` taking `<sandbox> <task_dir> <model> <raw_json_out>`:
build the prompt, run the agent inside the sandbox, write the `claude -p` JSON to
`raw_json_out`. Leave produced files in the sandbox.

## Deps & safety

Needs `jq` and the `claude` CLI. bench/ is dev-tooling — the shipped arcs CLI
stays zero-dep. Each run executes in a throwaway `mktemp -d` sandbox with
`--permission-mode bypassPermissions`; nothing touches your real tree.

Cost: small Sonnet runs. Use `--dry-run` first. The default matrix is
arms × tasks × 3 reps — print the cell count before committing to a full run.
