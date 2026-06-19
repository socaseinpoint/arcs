# PARKED (separate future arc) — arc immutability via supersession chains

User idea (ru, verbatim): "логичнее не менять цель, так не будет мутации; если цель
изменилась, то мы закрываем арку и новую открываем со ссылкой на ту, которая была ранее;
арки могут выстраиваться в цепочки, так потом можно будет отследить мысль".

## Essence
- Don't MUTATE an arc/goal's intent in place. If the aim changes → close the current arc
  (done) + open a NEW arc carrying a `prev:`/`supersedes:` link to the old one.
- Arcs form CHAINS → the evolution of thought is traceable after the fact.
- Aligns with the user's global immutability principle (no in-place mutation).

## Design sketch (to flesh out when we build it)
- `arc.md` gets a `prev: <NN-slug>` (or `supersedes:`) field.
- CLI helper: `arcs supersede <old-slug> <new-slug>` = close old (output guard applies) +
  create new arc with `prev:` set to old. Chains visible in `arcs status`.
- Interaction with goal-versioning: today a goal updates by dropping `MM-<slug>-goal.md`
  versions in place. Chains may REPLACE that — a pivot = supersede the goal, not edit it.
  The living "you are here" then = `arcs status` (computed from open arcs) + latest in chain,
  not a hand-maintained doc. OPEN QUESTION: chains replace goal-version docs, or coexist?

## Extension — immutable goal: no version number + checklist + arc-linked completion
User idea (ru, verbatim): "если цель иммутабельна то номер не нужен и когда определяется
цель как будто бы чеклист должен быть по цели и когда пункт выполнен можно пометить какой
аркой".

- If the goal is IMMUTABLE, the version number on the goal doc is pointless — there's just
  one goal doc, not `01/02/03` versions. DROP goal-doc versioning (it existed only to avoid
  in-place mutation; immutability + supersession-on-pivot replaces it).
- A goal DEFINES a **checklist** of its items/steps up front.
- Each checklist item, when done, is **marked with the arc that completed it**
  (e.g. `- [x] integrate stripe → 03-integrate-stripe`). Completion is traceable to an arc.
- Likely derivable: an arc's `closes:`/`prev:` pointer + the checklist → `arcs status` can
  compute goal progress (which items done, by which arc) without hand-editing — ties into the
  supersession-chain idea above.
- If the goal's PURPOSE itself changes → supersede (close + new linked goal), not edit.

Together these reshape the goal concept ("goal v2"): immutable purpose + checklist, progress
by arc-linked checkmarks, version-numbering removed, pivots via supersession chains.

## Why parked
Mid-flight there is a stack of uncommitted method changes (single-stream model + docs;
rules → global lib + config toggle). These goal-v2 ideas are a NEW, cohesive redesign — give
them their own goal/arc AFTER the current batch is committed, so changes don't tangle.
