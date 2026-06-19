# Ask — unify goals into one arc stream

User wants the arc/goal model simplified into a single stream. Collected requirements
(across several messages):

1. **Descriptive names.** Arc/goal slugs must be content-rich (multi-word, meaningful),
   not generic (`fix`, `stuff`). Skill should require this.
2. **No separate goals directory.** Drop `.arcs/goals/`. Arcs and goals live in ONE
   numbered stream (`.arcs/arcs/`), shared/continuous numbering — a single flow.
   Verbatim: "цели не надо отделять в отдельную директорию, это как единый поток
   goal это арка с целью, нумерация общая".
3. **Definitions.** arc = work WITHOUT a purpose; goal = work through an arc WITH a
   purpose (it organizes sub-arcs toward that purpose).
   Verbatim: "арка это работа без цели, goal (работа через арку с целью)".
4. **Goal is identifiable by NAME.** From the folder name alone it must be obvious it's a
   goal — a naming marker, like `__...__` marks a closed arc.
   Verbatim: "у goal ещё как будто бы по названию должно быть понятно что это цель".

## Resulting model (interpretation — confirm marker)
```
.arcs/
  config
  rules/
  arcs/                         # THE single stream — shared numbering
    01-<descriptive-slug>/        # arc (no purpose): input/ workspace/ output/ arc.md
    02-<slug>.goal/               # goal (arc WITH purpose) — name marker = ".goal" (TBD)
      01-<slug>-goal.md           # versioned status doc (version axis, starts 01)
      input/ workspace/ output/
      arcs/                       # the goal's sub-arcs (local numbering)
        01-<subslug>/ ...
```
- Top-level numbering is continuous across arcs AND goals (one `next_num` on `.arcs/arcs/`).
- A goal keeps nested `arcs/` (sub-stream, local numbering) — that's "work through arcs
  toward a purpose."
- Closed still wraps: `__02-<slug>.goal__`.

## Open decision (ask user)
- The goal name marker: `.goal` suffix vs `goal-` prefix vs other.

## Migration (this repo's own .arcs/)
- Move `.arcs/goals/01-landing-essence-first/` → `.arcs/arcs/NN-landing-essence-first.goal/`
  (next free number), keep its inner version doc + nested `__01-redesign__`.
- Remove `.arcs/goals/`.

## Touch list
bin/arcs (base_dir, next_num, new-arc, new-goal, status, close/reopen, init), SPEC.md,
skill/SKILL.md, template/, examples/basic, docs/index.html (tree figure + examples).
