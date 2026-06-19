# benchmark-pluggable-structures-goal — benchmark whether arcs structure helps

goal: build a bench stand measuring arcs vs bare on tokens/time/quality
status: done
# supersedes: <slug of the goal whose intent this one pivots from — optional>

# The goal's items = its sub-arcs (NN-slug in arcs/). Progress N/M = closed (__) / total. Create them with: arcs new-arc -g <slug> <item>

## Where we are

Candidate 02 (pluggable-arc-structures, from arc 16) asks: the arc structure
(input→workspace→output) is a FIXED default — make it swappable, then benchmark
which structure fits which work. Foundation first: a reusable bench stand that
runs the SAME small coding tasks through arms (arcs-default vs bare baseline) on
one cheap model (Sonnet) and compares tokens, wall-time, and quality
(auto-tests + LLM judge). `bench/arms/` IS the future pluggable layer — adding a
structure later is just a new arm. Pluggability in the CLI comes after the stand
proves the measurement.

Design spec: input/design.md.

DONE. Stand built + validated on real API (24-cell first run, sub-arc 03). Result:
on trivial tasks arcs is pure overhead (input ×3, time ×2, quality flat-to-worse) —
the measured floor, since these tasks are below where structure pays off. The goal
(a working, structure-agnostic bench with a pluggable arms/ layer) is met. Open
follow-up (next goal): a non-trivial task suite + alt-structure arms once CLI
pluggability lands — only then can we answer "which structure fits which work".
See arcs/03-first-run-and-report/output/.
