# Verdict — research is NOT a kind of arc; arcs needs no change

## Decision
Reject "research = a kind of arc". Add nothing to the arcs primitive: no `kind:` field,
no never-closing arcs, no product-face. arcs stays a pure engine.

## Why (the reframe)
"Research" is two things that got fused:
1. **Doing research = a run** — bounded process (scope→fan-out→verify→synthesize→close).
   Has the full arc skeleton. It already **is** an arc — a run = producer of arcs
   (goal + per-channel arcs + synthesis arc). No new mechanism.
2. **Research knowledge = a product** — a living, read/shared, growing doc. Has **no**
   arc skeleton (no input/workspace/output, no close). A leaf, not a system.

The anti-duplication argument ("split research off → reinvents the skeleton") holds only
for the run — and the run isn't split off, it's already an arc. The product reinvents
nothing; a markdown KB is a file, not a parallel system. "research = kind of arc" forced
a leaf (product) to wear the process's shape — that mismatch was the tangle itself.

## The model to use (user invented it organically in EXPORT.md)
- **runs = arcs** (process trails);
- **knowledge = one living visible doc OUTSIDE `.arcs/`**, distilled from the runs, which
  feed it via their synthesis output.

## Answer to "does research need to live in arcs?"
- Doing it → yes, via arcs (work = arc).
- The knowledge → no; it's an output that lives as a plain visible doc.

## What `kind: research` would have bought — nothing
- close semantics: run closes normally;
- mandatory product file: enforced by the /research skill, not the CLI;
- visibility: product lives outside `.arcs/` regardless.

## Handoff (work returns to research-research, NOT arcs)
The only open, genuinely-separate question is **globality**, and it's a research-research
decision, not an arcs-primitive one:
- `/research` skill → global (`~/.claude/skills/`), 0-install per repo;
- knowledge base → a top-level visible doc/folder (research-research already serves as the
  standalone home; per-project knowledge can sit in that project's own top-level docs);
- runs materialize as arcs in whatever repo you're working in.

research-research's existing design-spec + implementation-plan (the "run = producer of arcs"
build) stand as-is — they never depended on the rejected "kind" idea.

## Net effect on the arcs method
Zero code, zero grammar, zero docs change. This arc closes the question by ruling the
change OUT.
