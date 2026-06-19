# Result — arc writing-quality review

Judged every arc/goal in `.arcs/arcs/` (except this one) as *writing*: scannability, substance,
redundancy, encapsulation, consistency vs `arc_md()`/`goal_md()` (bin/arcs) + SPEC. Review-only.
Full analysis: `workspace/review.md`.

## Per-arc verdict (one line each)

| Arc / goal | Verdict | Note |
|---|---|---|
| 01-subagent-delegation | **good** | model arc; Insight in input is load-bearing, workspace truly scratch |
| 02-close-arcs-underscore | **good** | best input/ — flagged the next_num bug before it bit |
| 03-changelog | **good** | small kept small; mild input↔output overlap, tolerable |
| 04-close-requires-output | **good** | clearest goal line; ties guard to method core |
| 05-unify-goals-into-single-arc-stream | **good** | input long but earns it; `.goal`-vs-`@` state drift unnoted |
| 06-@landing-essence-first (goal) | **good** | goal-line too long; "Where we are" stale (closed but says "Building…"); goal↔sub-arc output overlap |
| └ 01-redesign (sub-arc) | **good** | textbook unit — crisp passport, high-signal input, real scratch plan |
| 07-move-rules-to-global-library | **good** | best output/ ("Bug fixed during build"); dangling input pointer |
| 09-add-ideas-candidate-backlog | **good** | clean, no redundancy |
| 11-fix-doc-drift-and-orphan | **redundant** | `workspace/notes.md` ≈ `output/result.md` (same per-item table twice) |
| 10-@immutable-goals-and-chains (goal, active) | **too-verbose** | goal-line too long; brainstorm 300+ lines half-restated in goal doc; coherence-audit is load-bearing for arc 11 |
| └ 01-cli-goal-v2/input/spec.md (stable) | **good** | precise implementation ticket, right altitude |

**Worst offenders:** redundancy → **arc 11** (notes duplicate output). Encapsulation break →
**goal 10** (`coherence-audit.md` in workspace is consumed as input by arc 11 — it wanted to be an
output). Verbosity → **goal 10** (`brainstorm-goal-v2.md`). Stalest doc → **goal 06** ("Where we are").

## Cross-cutting patterns

**Done well (keep):**
- arc.md passports stay minimal — none grew into a doc. The "passport does not grow" rule holds 9/9.
- output/ carries durable WHY + gotchas, not commit restatement (07's build-bug note, 11's per-item table).
- verbatim user steer preserved in input/ (ru quotes) — traceable seed, never paraphrased away.
- a concrete "Verified" section in nearly every output — repeatable, earns the close.
- all prose `en`; ru appears only as quoted steer — correct.

**Done badly (fix):**
- `goal:` lines on GOALS drift into 30–40-word paragraphs (06, 10) — not graspable in seconds. (Arcs are fine.)
- workspace ↔ output redundancy: arc 11 (notes ≈ output), goal 10 (brainstorm ≈ goal-doc locked model).
- workspace going load-bearing across arcs: goal 10's coherence-audit drives arc 11 — breaks "workspace is private, dies with the arc."
- dangling input pointers in arc.md (07 points at files no longer on disk).
- goal status docs not advanced to a done "Where we are" (06 closed but reads "Building…").
- input↔output state mismatches with no breadcrumb (05 `.goal`→`@`; 01 `enabled:`→config toggle).

## Prioritized recommendations

1. **TRIM workspace/output duplication.** Make the rule explicit (in SKILL): if a workspace note ends up
   restating output, delete it — workspace is disposable thinking, not a second copy of the conclusion.
   Worst case to clean up retroactively if desired: arc 11 notes, goal 10 brainstorm.
2. **STANDARDIZE: an artifact another unit will consume must be an `output/`, never a `workspace/` file.**
   goal 10's coherence-audit should have been an arc whose output arc 11 read. Add this as a one-line
   encapsulation reminder in SKILL ("if a later arc needs it, it's output, not workspace").
3. **TIGHTEN goal `goal:` lines to ≤12 words**; push the long framing into `## Where we are`. Enforce via
   the template placeholder (below).
4. **KEEP goal status docs current on close** — when a goal closes, its "Where we are" must read as a
   done-state, not mid-flight. (goal 10's own checklist mechanism is the durable fix; until then, a
   convention.)
5. **ADD an input-as-pointer convention** — the strongest inputs are pointer lines
   (`input/ask.md — <gist>`) not prose; nudge it via the arc_md placeholder.
6. (minor) **NO dangling pointers in arc.md** — if input/workspace files move, update the passport.

## Call on the templates (bin/arcs)

**Yes — change both, modestly. `arc_md()` now; `goal_md()` via goal 10 (do not pre-empt it).**

`arc_md()` — one nudge (the `## input` placeholder invites prose; make it a pointer):
```
## input
<input/… — one-line gist of what came in>
```
(en; mirror in ru/es. `goal:` placeholder is already fine.)

`goal_md()` — two changes, but **both are squarely goal 10's deliverable** (it already plans to drop
`version:` for a `## Checklist`). Recommend goal 10 adopt this exact shape rather than editing now:
```
# <slug>-goal — <goal>
goal: <one line, ≤12 words; long version goes in "Where we are">
status: active

## Checklist
- [ ] <item-key — desc>          # done-state computed from sub-arcs' closes:, rendered by status

## Where we are
<current bottleneck>

## Arcs of this goal
<NN-arc → output → status>
```
Rationale: adds the **≤12-word cue** on `goal:` (fixes the paragraph-goal-line pattern), and folds in
goal 10's `version:`→checklist swap so the template stops scaffolding a soon-deprecated field. Keeping
this in goal 10 avoids a half-migrated template (`version:` gone from the scaffold while SPEC still
teaches it). **Net: edit arc_md's input placeholder now; specify goal_md here, execute it inside goal 10.**
