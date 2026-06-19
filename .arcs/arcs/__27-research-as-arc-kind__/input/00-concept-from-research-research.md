# input — research = a kind of arc (concept ported from research-research)

Source: `../research-research/.arcs/arcs/02-build-research-tool-v1/output/01-concept-research-as-arc-kind.md`
(design dialogue while building a `/research` tool; date 2026-06-19)

## The claim
research is **not** a parallel system and **not** a child of arcs — it is a **kind** of arc.
Same skeleton (input→accumulate→output, numbered, verify, close), different:
- intent: unit of **knowing** toward understanding (vs unit of **work** toward a goal)
- output: **understanding/synthesis** (vs change in the world)
- output shape: **living product that grows** (vs process trail that closes)

Anti-duplication argument: a standalone research system would reinvent the arc skeleton →
two systems, one form = duplication. So fold it in as a specialization.

## Implementation hypotheses (light→heavy)
1. Convention only — research-arc = ordinary arc run as living research; entry via `/research` skill. No CLI change.
2. `kind:` field in arc grammar (`work|research`, default work) — changes close-semantics, mandates a product-file, increments-as-subunits.
3. Product-face on goal/arc — visible README-synthesis updated as children accumulate, separate from the trail.

## Load-bearing open tensions (what this arc must resolve)
- **Lifecycle:** arc *closes* (process done); research *lives & grows* (product). Direct conflict with the core invariant.
- **Visibility/home:** product wants to be visible/top-level; arcs live in hidden `.arcs/`.
- **Globality:** research is cross-project (needed from any repo); arcs are per-repo.
- increment-source = child arc or new sub-unit type?
- re-synthesis via `supersede` (version history) or in-place README update?

## Relation to nearby arcs
- arc 26 (checklist-items-as-arcs) is also probing arc-kind/structure — watch for overlap.
- candidate 02-pluggable-arc-structures may be the same underlying lever.
