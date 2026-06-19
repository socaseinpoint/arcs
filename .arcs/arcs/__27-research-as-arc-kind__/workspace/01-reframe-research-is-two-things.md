# workspace — the reframe that dissolves "research = kind of arc"

## The decision being settled
User came from research-research tangled on: where does research live vs arcs?
Earlier resolution (concept doc) = "research is a KIND of arc". User now doubts it.
Verdict reached here: **the concept doc was the tangle, not the solution.**

## Core move: research is TWO things, fused in the tangle
1. **Doing research = a run.** Scope→fan-out→verify→synthesize→close. Bounded.
   Has input→workspace→output, numbered, verified, closes. This **is** an arc.
   (Implementation plan already says exactly this: "a research run = producer of arcs"
   — goal + per-channel arcs + synthesis arc. Works today, zero CLI change.)
2. **Research knowledge = a product.** RESEARCH-KNOWLEDGE-EXPORT.md. Read/shared/grows.
   Has **no** arc skeleton — no input/workspace/output, no close. A living leaf doc.

## Why the anti-duplication argument fails
Concept doc claim: "split research off → it reinvents the arc skeleton → duplication."
- True only for the RUN. But the run isn't split off — it's already an arc.
- The PRODUCT does not reinvent the skeleton (a markdown KB has no input→accumulate→output,
  no close, no numbering). A file is not a parallel system. → no duplication.
- So "research = kind of arc" forced the product (a leaf) to wear the process's shape.
  That mismatch IS the tangle.

## User already invented the right model (organically)
EXPORT.md footer: "Depth & full per-topic reports live in arks 01–04 (workspace/*.md);
this export is the self-contained synthesis."
→ Runs = arcs (trails 01–04). Knowledge = one living visible doc OUTSIDE .arcs/, distilled
from runs. Solved before it got tangled.

## Answer to the gut question ("can research live without an arc?")
- The DOING can't — doing research is doing work is an arc. That's why it feels close:
  it's not adjacent to the primitive, it's an instance of it.
- The KNOWLEDGE does — it's a product/doc, stands alone. Feels separate because it is.
No paradox, no duplication, no new primitive.

## Consequence for the arcs method
Add nothing. `kind: research` buys nothing the skill can't do:
- close semantics — run closes normally;
- mandatory product file — /research skill enforces, not the CLI;
- visibility — product lives outside .arcs/ regardless.
arcs stays the pure engine. Research is RUN BY arcs and PRODUCES a visible knowledge doc.

## The one genuinely separate question (NOT an arcs-primitive question)
Globality: where do the /research skill and a cross-project knowledge base live?
→ skill in ~/.claude/skills/ (global, 0-install per repo); KB = a top-level docs folder
or a dedicated research repo (research-research already plays that role for standalone
"is there a tool for X" queries). Runs materialize as arcs in whatever repo you're in.

## Status
Reframe presented to user; awaiting confirmation it lands / probing for a pull I'm missing
before writing the design doc. If confirmed → arc 27 closes with "no change to arcs;
research lives as run(arc)+product(doc)"; the real build work returns to research-research.
