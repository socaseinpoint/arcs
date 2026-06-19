# Design — arcs benchmark stand (foundation for pluggable structures)

Date: 2026-06-19
Goal: 32-@benchmark-pluggable-structures
Origin: candidate 02-pluggable-arc-structures (from arc 16)

## Problem

The arc structure `input → workspace → output` is a fixed default. The open
question (candidate 02): does that structure actually help an agent, and which
structure fits which work? We can't answer it without a way to measure. So the
foundation is a **benchmark stand**: run the SAME task through different "arms"
(ways of working) and compare cost and quality. Pluggable structures in the CLI
come later — this stand is what will judge them.

## Scope (this goal)

In: a reusable bench harness; 2 arms (`arcs-default`, `bare`); 3 small coding
tasks; per-run capture of tokens + wall-time; quality = auto-tests + LLM judge;
an aggregated side-by-side report; one real first run on Sonnet.

Out (later goals): making the arc structure pluggable in `bin/arcs`; more arms /
more structures; bigger task suites; multi-model sweeps.

## Decisions (locked in brainstorm)

- **Engine:** headless `claude -p --model claude-sonnet-4-6 --output-format json`.
  JSON gives exact `usage` (input/output tokens) + `duration_ms`. Each run is a
  fresh process = clean isolation, honest measurement.
- **Harness language:** pure bash. Matches the repo (bin/arcs is bash, zero deps).
- **Quality:** auto-tests (objective: `verify.sh` exit 0 = pass) + LLM judge
  (rubric 1–5). Two signals: "does it work" + "is it done well".
- **Tasks:** 3 small coding tasks with pre-written tests. Identical input across
  arms. Real dev work — what arcs is for.
- **Model:** Sonnet for both arms (cheap, identical across arms).
- **Reps:** default 3 per (arm × task) cell, env-configurable. 2×3×3 = 18 runs.

## Layout

```
bench/
  run.sh              # orchestrator: arms × tasks × reps
  arms/               # ← the pluggable layer (seed of candidate 02)
    bare/run.sh           # prompt = bare task, no arcs
    arcs-default/run.sh   # arcs init in sandbox + prompt "work through an arc"
  tasks/
    01-<slug>/
      prompt.md           # identical input for all arms
      verify.sh           # auto-test: exit 0 = pass
      rubric.md           # LLM-judge rubric (1–5 dimensions)
      starter/            # optional starter files (may be empty)
  lib/
    judge.sh            # claude -p as judge against rubric → {score}
    aggregate.sh        # raw json + verify results → runs.csv + report.md
  results/<ts>/
    raw/<arm>-<task>-<rep>.json
    runs.csv            # arm,task,rep,in_tok,out_tok,cost_usd,dur_ms,tests_pass,judge
    report.md           # arms side by side
  README.md           # how to run, how to read results
```

## One run (the unit)

1. `mktemp -d` sandbox per (arm, task, rep). Copy `tasks/<t>/starter/` in.
2. `arms/<arm>/run.sh` builds the prompt and invokes:
   `claude -p "<prompt>" --model claude-sonnet-4-6 --output-format json \
     --permission-mode bypassPermissions`
   - **bare:** prompt = the task only. No arcs available.
   - **arcs-default:** `arcs init` in the sandbox, arcs CLI on PATH, prompt tells
     the agent to open an arc and work input→workspace→output.
   - Capture stdout JSON (usage + duration). Files land in the sandbox.
3. Copy `tasks/<t>/verify.sh` into the sandbox, run it → `tests_pass` (0/1).
4. `lib/judge.sh` reads the sandbox result + `rubric.md` → `judge` score (1–5).
5. Append a row to `runs.csv`.

`bypassPermissions` is safe: the sandbox is a throwaway temp dir.

## Metrics & report

Per run: input_tokens, output_tokens, cost_usd (from Sonnet pricing), duration_ms,
tests_pass (0/1), judge (1–5). `report.md` aggregates per arm: mean tokens, mean
cost, mean duration, % tests pass, mean judge — arms side by side, so the arcs
arm's overhead vs payoff is visible at a glance.

## Why this seeds candidate 02

`bench/arms/` IS the swappable layer. Today: `bare` + `arcs-default`. A new
structure later = one new `arms/<name>/run.sh`; `tasks/` stay fixed. The stand is
structure-agnostic by construction, so when CLI pluggability lands it plugs
straight in.

## Sub-arcs (build order)

1. **scaffold-harness** — bench/ tree, run.sh orchestrator, lib/aggregate.sh,
   lib/judge.sh, the two arms, README. No tasks yet; dry-run with a stub task.
2. **author-3-tasks** — 3 small coding tasks: prompt.md + verify.sh + rubric.md
   (+ starter). Tests written first, must fail on empty input.
3. **first-run-and-report** — run the full 18-run matrix on Sonnet, produce
   results/<ts>/report.md, write findings (does arcs help? at what token cost?).

## Risks / open

- LLM-judge variance → reps + report the spread, not just the mean.
- Headless tool-permission quirks → bypassPermissions in sandbox only.
- Sonnet stochasticity → reps; keep tasks small and well-specified.
- Cost guard: 18 small Sonnet runs is cheap, but run.sh should print an estimate
  and support a `--dry-run` / single-cell mode before the full matrix.
