# 01-scaffold-harness — result

Built the benchmark harness at repo root `bench/` per input/design.md.

## What shipped (repo root, not arc output — code lives where it runs)

```
bench/
  run.sh                  orchestrator: arms × tasks × reps; one mktemp sandbox per cell;
                          captures in/out tokens, cost, duration from claude -p JSON;
                          runs verify.sh (tests_pass) + lib/judge.sh (1-5); writes runs.csv;
                          flags: --reps --arms --tasks --model --judge-model --dry-run --out
  arms/bare/run.sh        baseline arm — task prompt only, no arcs
  arms/arcs-default/run.sh arc arm — arcs init in sandbox + PATH + "work through an arc" preamble
  lib/judge.sh            LLM judge: file snapshot + rubric → score 1-5
  lib/aggregate.sh        runs.csv → report.md (per-arm + per-arm×task means)
  tasks/00-stub/          stub task (add.sh) for dry-run: prompt.md · verify.sh · rubric.md
  README.md               how to run, add a task, add an arm; deps + safety
```

`bench/arms/` is the pluggable layer (seed of candidate 02): a new structure later
is just a new `arms/<name>/run.sh`; tasks stay fixed.

## Verified (offline, with a stub `claude` on PATH — no API spend)

- `bash -n` clean on every script.
- Made bash 3.2-safe (macOS /bin/bash 3.2.57): dropped `mapfile`; fixed a
  `set -u` loop-var-lost-after-nested-$() bug in judge.sh (case→if-grep).
- `aggregate.sh` on a fake CSV → correct per-arm/per-task means tables.
- `run.sh --dry-run` for **bare** and **arcs-default**: sandbox created, arm ran,
  add.sh produced, `verify.sh` → tests_pass=1 (100%), `judge.sh` → 4, row in
  runs.csv, report.md rendered.
- arcs-default arm confirmed to `arcs init` the sandbox and capture the JSON.

## Decisions / notes

- `bench/results/` gitignored — keep the harness, not the runs.
- Deps: `jq` + `claude` CLI (bench is dev-tooling; shipped arcs CLI stays zero-dep).
- Sandbox uses `--permission-mode bypassPermissions` — safe (throwaway mktemp dir).

## Next (sub-arc 02)

Author 3 real small coding tasks (prompt + verify.sh tests-first + rubric + starter),
replacing reliance on the stub. Then sub-arc 03 runs the 18-cell matrix on Sonnet.
