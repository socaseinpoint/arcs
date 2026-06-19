# benchmark-pluggable-structures-goal — benchmark whether arcs structure helps

goal: build a bench stand measuring arcs vs bare on tokens/time/quality
status: active
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

Design spec: input/design.md. Next bottleneck: scaffold the harness (sub-arc 01).
