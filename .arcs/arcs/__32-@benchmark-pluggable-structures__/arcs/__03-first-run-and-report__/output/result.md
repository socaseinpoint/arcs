# 03-first-run-and-report — result

First real run of the bench stand. 24 cells (2 arms × 4 tasks × 3 reps) + 24 LLM
judge calls on Sonnet (claude-sonnet-4-6). Run: `results/20260619-013344/`
(gitignored; report.md + runs.csv copied here).

## Headline

| arm | in_tok | out_tok | cost $ | dur ms | tests | judge |
|-----|--------|---------|--------|--------|-------|-------|
| bare         | 103.8k | 365 | 0.18 | 13.8s | 100% | 5.00 |
| arcs-default | 308.1k | 964 | 0.27 | 30.4s | 100% | 4.83 |

Delta (arcs vs bare): input **×3.0**, output ×2.6, cost **×1.5**, time **×2.2**,
quality **flat to slightly worse** (both 100% tests pass; judge 4.83 < 5.00,
dragged by 00-stub at 4.33). Total spend ≈ $5.4 (arm cells) + judge ≈ ~$7.

## Finding

On **trivial** tasks the arc structure is pure overhead. The scaffold (`arcs init`,
reading method docs, opening an arc, extra tool calls) burns ~3× the input tokens
and ~2× the wall-time, and there is nothing to pay it back: the task is too small
to benefit from being structured. The structure even nudges quality DOWN a hair —
the agent spends a turn on bookkeeping instead of the code.

This is the **floor, not a verdict against arcs.** The method is designed for
multi-step / non-trivial work; this task suite sits exactly in the regime where
arcs should NOT help. The benchmark behaved correctly and measured that floor
cleanly (low variance across reps).

## What this validates (the actual goal)

- The stand works end-to-end on real API: headless `claude -p`, honest token
  capture (incl. cache), objective tests + LLM judge, side-by-side report.
- `arms/` is a working pluggable layer — bare vs arcs-default differ only by the
  arm script. A new structure later plugs in the same way (seeds candidate 02).

## Caveats / next

- Token count includes cache-read (cheap); `cost $` is the money truth. arcs's ×3
  input is partly cache re-read of a bigger context, so cost delta (×1.5) < token
  delta (×3.0).
- Judge is single-vote, same model family → some noise. Add multi-vote later.
- **Next goal:** a non-trivial / multi-step task suite (where structure should pay
  off) + more arms (e.g. alternative structures) once CLI pluggability lands.
  Only then can we answer "which structure fits which work".
