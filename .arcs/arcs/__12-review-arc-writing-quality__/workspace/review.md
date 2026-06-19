# Review — arc writing quality

Scope: every arc/goal in `.arcs/arcs/` except `12` (this one). Judged as *writing* — how well
each arc reads as a unit of the method, against `arc_md()`/`goal_md()` (bin/arcs) and SPEC.md.
Not judging the code/docs they shipped.

Reference templates (bin/arcs):
- `arc.md`: `# slug` / `goal:` / `status: active` / `## input` / `## output → pointers`
- goal doc: `# MM-slug-goal — <goal>` / `goal:` / `status:` / `version:` / `## Where we are` / `## Arcs of this goal`

SPEC intent: input = constructor args, workspace = private disposable state, output = self-contained
public interface; arc.md = minimal passport that does not grow; output derivable-alone; all prose `en`.

---

## Per-arc reads

### 01-subagent-delegation  — verdict: GOOD (model arc)
- `arc.md`: crisp. `goal:` one line, real signal ("toggleable rules layer; subagents rule ON by default").
  `## input` line cleverly points at BOTH input/ask.md and the pivot in workspace/ — orients a reader fast.
- `input/ask.md`: carries the verbatim ru steer + an "Insight" + "Scope". High signal; the Insight
  ("arc boundary IS a subagent boundary") is the load-bearing idea of the whole arc. Right altitude.
- `workspace/pivot-rules-system.md`: genuinely scratch — captures the mid-arc reframe + design space
  A/B/C + open decisions. Correctly NOT in output. Good encapsulation discipline.
- `output/result.md`: self-contained — shipped list, decisions, changed-files pointers, verification.
  Minor: describes rule format as `enabled: true|false` field, later reversed by arc 07 (frozen history,
  acceptable — output is a snapshot, not a living doc).
- Nit: `goal:` line in `arc.md` ends with a trailing space (cosmetic).

### 02-close-arcs-underscore — verdict: GOOD
- Tight throughout. `arc.md` goal line is excellent ("close an arc by renaming … ; numbering counts closed").
- `input/ask.md` is the best-written input in the repo: verbatim steer + Design + a sharp
  "Interaction to handle (important)" calling out the next_num glob bug *before* it bit. That foresight
  is exactly what input/ should carry.
- `output/result.md`: shipped/pointers/verified, lean. No redundancy vs input. Encapsulation clean.

### 03-changelog — verdict: GOOD (smallest, appropriately)
- A small arc kept small. `arc.md` goal line crisp.
- `input/ask.md` (Decisions + Mapping) and `output/result.md` overlap noticeably — both restate the
  Unreleased/0.1.0 split almost verbatim. For an arc this small that's borderline-redundant but tolerable;
  the output adds the v0.1.0-tag caveat (real signal not in input). Right size overall.

### 04-close-requires-output — verdict: GOOD
- Exemplary small arc. `arc.md` goal line is the clearest in the repo. input "Why it matters" ties the
  guard to the method's core principle — substance, not boilerplate. output lean. No bloat.

### 05-unify-goals-into-single-arc-stream — verdict: GOOD, mild input-verbosity
- Biggest model-change arc; writing scales appropriately.
- `input/ask.md`: long but earns it — 4 numbered requirements w/ verbatim ru, a "Resulting model"
  tree, open decision, migration, touch list. One soft spot: the model tree shows `.goal` suffix while
  the shipped marker is `@` — input captured a pre-decision state (fine as frozen input, but a reader
  diffing input↔output sees the mismatch with no note).
- `output/result.md`: clean, self-contained, sectioned (model/CLI/migration/docs/verified). Good.

### 06-@landing-essence-first (GOAL) — verdict: GOOD, with one structural smell
- Goal doc `01-landing-essence-first-goal.md`: `goal:` line is RICH but LONG — one 30-word sentence
  packing payoff+how-to-start+agent-framing+spec-demotion. Scannable-in-seconds? Borderline; it's a
  paragraph masquerading as a one-liner. "## Where we are" still reads "Building… Now rewriting" —
  i.e. the goal was CLOSED but its status doc was never advanced to a done-state "where we are"
  (the output/result.md carries the real final state instead). The version-doc didn't get a final tick.
- `output/result.md` (goal-level): good — live URL, what shipped, an honest note that later edits were
  "folded in directly" outside the single sub-arc. Self-contained.
- nested `arcs/__01-redesign__`: textbook. arc.md crisp; input/ask.md (intent + reference takeaways +
  constraints) is high-signal; workspace/plan.md is real scratch (diagnosis + build steps checklist);
  output/result.md self-contained. This sub-arc is one of the best-written units in the repo.
- Structural smell: goal-level output + sub-arc output partly restate each other (both describe the
  essence-first rewrite). Defensible because the goal absorbed extra direct edits, but it's the clearest
  case of output/output overlap in the repo.

### 07-move-rules-to-global-library — verdict: GOOD (best output in repo)
- `arc.md` goal line dense but legitimately so (3 clauses = 3 real facts).
- No input/ask.md on disk — input is summarized inside arc.md ("input/ask.md (plus chat steer)…").
  Minor inconsistency: arc.md points at input/ask.md and a workspace/parked-idea file, neither present
  on disk now (the parked idea became candidate→goal 10). Dangling pointer; cosmetic but a drift.
- `output/result.md`: the strongest output — Rationale, Shipped, a "Bug fixed during build" section
  (the pipefail/`set -e` trap) that is genuine transferable knowledge, Migration, Docs, Verified.
  This is what output/ should look like: not a commit restatement, but the durable why + gotchas.

### 09-add-ideas-candidate-backlog — verdict: GOOD
- Clean. arc.md goal line crisp. input/ask.md = steer + Design + "Then" (the goal-v2 relocation) —
  well-scoped. output/result.md self-contained (Shipped/Applied/Docs/Verified). No redundancy.

### 11-fix-doc-drift-and-orphan — verdict: GOOD but OVER-DOCUMENTED (workspace/output overlap)
- input/scope.md: excellent — 6 items C1/C2/H1/H3/M1/M2 with severity, exact file:loc, and explicit
  guardrails ("do NOT touch SPEC versioning"). Best-scoped input in the repo.
- output/result.md: a per-item table (item/status/file:loc/what-changed) + files-touched + guardrails.
  Self-contained, scannable. Good.
- workspace/notes.md: **near-duplicate of output** — same per-item breakdown (C1…M2), same file:locs,
  same reasoning, just slightly longer prose. This is the repo's clearest redundancy: workspace here is
  not scratch, it's a second copy of the output. Either the notes should have been disposable thinking
  OR the output should point at them — instead both say the same thing twice.

### 10-@immutable-goals-and-chains (GOAL, ACTIVE) — verdict: GOOD design, goal doc slightly heavy
- Goal doc: `goal:` line is LONG (a 40-word two-clause sentence). Same pattern as goal 06 — rich but
  not a glance-grab. Strong parts: "## Locked model (the contract)" is a genuinely good immutable-intent
  statement, and the dogfooded `## Checklist` with stable-slug keys is exemplary (the goal practices its
  own proposed mechanism). "Dropped/Deferred" lines are crisp decision-capture.
- input/01-immutable-goals-and-chains.md: the promoted candidate (origin preserved via `from:`). Good —
  shows the candidate→input lineage working. Slightly stale relative to the locked model (open questions
  already resolved in the goal doc) but that's correct: input is the frozen seed, not the latest state.
- workspace/brainstorm-goal-v2.md: 300+ lines. This is the single longest artifact in scope. It IS real
  design work (resolves Q1–Q4 with tradeoffs, field/CLI spec, migration, drop/defer) and correctly lives
  in workspace (private, disposable). But it is VERBOSE — much of its content was distilled into the goal
  doc's "Locked model", so a reader gets the decision twice (long-form here, locked there). Acceptable as
  scratch, but it's the altitude outlier: borderline an artifact that wants to be its own arc-output.
- workspace/coherence-audit.md: 160 lines, a full project audit. Two issues: (1) it's load-bearing —
  arc 11's entire input/scope.md is *derived from it*, and 11 references it by path. A workspace file
  another arc depends on violates "workspace is private, dies with the arc." This audit should arguably
  have been an arc's *output*, not goal 10's workspace. (2) It's excellent content in the wrong drawer.
- nested arcs/01-cli-goal-v2/input/spec.md (stable, reviewed): VERY GOOD. Precise 3-part implementation
  spec, explicit constraints, hand-verification plan, scope guardrails ("do NOT edit SPEC/SKILL"). Exactly
  the right altitude for an implementation arc's input. Reads like a clean ticket.

---

## Cross-cutting patterns

### What we do well (systematically)
1. **arc.md passports stay minimal and honest** — every one is goal/status/input-pointer/output-pointer,
   none has grown into a doc. The "passport does not grow" rule is respected across all 9 arcs.
2. **output/ carries durable WHY + gotchas, not commit restatement** — arcs 02/04/07/11 especially. The
   "Bug fixed during build" (07) and per-item tables (11) are transferable knowledge, not `git log`.
3. **Verbatim user steer preserved in input/** (ru quotes) — excellent for traceability; the seed is
   never paraphrased away. Consistent across 01/02/04/05/09.
4. **Verification sections** ("Temp-dir test: …") in nearly every output — concrete, repeatable, builds
   trust that the close was earned. Very consistent.
5. **Encapsulation mostly holds** — output/ is self-contained in every closed arc; next step is derivable.
6. **All prose is en** (project lang). Only ru appears as quoted verbatim steer — correct and intentional.

### What we do badly (systematically)
1. **`goal:` one-liners drift toward paragraphs** — fine on arcs (02/04 are crisp), but BOTH goal docs
   (06, 10) pack 30–40-word multi-clause sentences into the `goal:` slot. Not graspable in seconds.
2. **workspace/output redundancy** — arc 11 (notes ≈ output) and goal 10 (brainstorm ≈ goal-doc locked
   model) say the same thing twice. workspace is meant to be disposable scratch; instead it sometimes
   holds a parallel copy of the conclusion.
3. **workspace going load-bearing across arcs** — goal 10's `coherence-audit.md` is consumed by arc 11
   as input. A file in one unit's private workspace driving another unit's work breaks the "workspace
   dies with the arc, leaks nothing" invariant. It wanted to be an output.
4. **Dangling input pointers** — arc 07's arc.md points at input/ask.md + a workspace file, neither on
   disk (the parked idea moved to candidates). arc.md should not reference vanished files.
5. **goal status docs not advanced to a done "Where we are"** — goal 06 closed but its doc still reads
   "Building… Now rewriting." The version-doc's whole job (briefly answer "where I am globally") lapsed;
   the real end-state lives only in output/. (This is exactly the drift goal 10 wants to kill.)
6. **input↔output state mismatches with no note** — arcs 05 (`.goal` suffix in input vs `@` shipped) and
   01 (`enabled:` field in output vs config-toggle final). Frozen-input is correct in principle, but a
   one-line "superseded by …" breadcrumb would save a reader the double-take.

### Consistency vs templates/SPEC
- arc.md heading: template emits `# slug`; arcs use it consistently. Good.
- Templates put a blank line after `# slug` and between `goal:`/`status:`; several hand-written arc.md
  (01, 02, 04, 05) drop the blank between goal and status. Harmless but inconsistent with the template.
- `closes:` field: SPEC documents it on the arc passport; template never emits it; NO closed sub-arc
  carries it (06/01-redesign had a real parent goal and still omits it). The field is spec-fiction today —
  goal 10 is the arc that will finally make it real.
- goal doc `version:` line: present per template (06, 10). goal 10's own design drops it — so the
  template is about to be on the wrong side of the method.

---

## Template assessment (should arc_md/goal_md change?)

`arc_md()`: largely GOOD. It produces exactly the minimal passport the SPEC wants and arcs honor it.
Two small nudges worth making:
- The `## input` placeholder `<what came in>` invites a prose paragraph; the best arcs instead use it as
  a *pointer* line ("input/ask.md — <one-line gist>"). Changing the placeholder to
  `<input/… — one-line gist of what came in>` would nudge the better pattern.
- `goal:` placeholder `<one line — what this arc closes>` is fine for arcs. No change needed there.

`goal_md()`: needs the most attention, for two reasons:
1. **The `goal:` slot grows into a paragraph.** Both real goals overflow it. Add an explicit length cue:
   `<goal — one line, ≤12 words; the long version goes in "Where we are">`.
2. **`version:` is about to be deprecated** by goal 10 (supersession replaces MM-versioning). The template
   still scaffolds `version: $2 (highest number = current)`. This is a *known* impending change — flag it,
   but it is goal 10's job to actually rewrite goal_md (drop `version:`, switch to `## Checklist`). The
   review's call: yes, change goal_md, but DON'T pre-empt goal 10 — recommend the exact wording for that
   arc to adopt rather than editing now.
- `## Where we are` is good and should stay (it's where the long-form belongs once `goal:` is tightened).

Net: arc_md needs only a placeholder tweak (input-as-pointer). goal_md needs (a) a length cue on `goal:`,
and (b) the version→checklist swap — the latter is squarely goal 10's deliverable, so the template change
should be *specified here and executed there*, not duplicated.

---

## Worst offenders (named)
- **Most redundant:** arc 11 — `workspace/notes.md` is a near-duplicate of `output/result.md`.
- **Most encapsulation-breaking:** goal 10 — `workspace/coherence-audit.md` is consumed as input by arc 11.
- **Most verbose artifact:** goal 10 — `workspace/brainstorm-goal-v2.md` (300+ lines, half re-stated in the goal doc).
- **Least-scannable goal line:** tie, goals 06 and 10 (30–40-word `goal:` paragraphs).
- **Stalest status doc:** goal 06 — closed but "Where we are" still says "Building…".
