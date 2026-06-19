# brainstorm — goal-v2: immutable goals + supersession chains

Design-lock input for `10-@immutable-goals-and-chains`. Resolves the four open
questions, gives concrete field/CLI syntax, and lays out migration + cuts.

---

## Recommended model (the locked design)

Two moves, one principle: **a goal's intent is a contract you don't edit — you
either complete it, or you supersede it with a successor that records why.**

### 1. The goal becomes a stable contract + a checklist
A goal doc has two stable parts that are written once and then only *checked off*,
never reworded:

- **`goal:`** — the one-line purpose (already exists).
- **`## Checklist`** — the decomposition of the goal into closeable items. Each
  item is one line. An item is satisfied by an arc closing against it.

The checklist is the goal's spine. Items are *defined by hand* (a human/agent
decides what the goal decomposes into) but their *done-state is rendered, not
hand-edited* — derived from which sub-arcs have closed against them.

```markdown
# landing-essence-first-goal — essence-first landing
goal: rebuild the landing so a visitor gets payoff + how-to-start instantly

## Checklist
- [ ] digest reference + write plan
- [ ] rewrite hero / order of docs
- [ ] verify on prod
```

The leading `MM-` version number is **dropped** — file is `<slug>-goal.md`, no
`01-`/`02-` axis. (See Decision 2.)

### 2. Arcs declare what they close; supersession replaces version-bumps
An arc that advances a goal carries `closes:` pointing at a **checklist item**
(by stable key — see field spec). `arcs status` joins arcs→items to render
`[x]`/`[ ]` and `N/M ✓`. No hand-marking, no drift.

When intent itself **changes** (not just progresses), you don't reword the goal
or bump a version. You **supersede**: close the current goal/arc as `done` and
open a NEW one carrying `supersedes:` ← the predecessor. The chain *is* the
version history — readable in `ls` (`__…__` predecessors) and in the
`supersedes:`/`prev:` links. Same mechanism for arcs whose aim drifts mid-flight.

**One word, two scopes:**
- `supersedes:` on a **goal** = the goal's intent pivoted (replaces MM-versioning).
- `supersedes:` (or `prev:` — alias) on an **arc** = this arc replaces an
  abandoned/redirected sibling arc; the chain traces the evolution of thought.

---

## Decisions

### Q1 — Checklist progress: hand-marked, or computed from arcs?

**Pick: COMPUTED from arcs' `closes:`, rendered by `arcs status`. The goal doc
stores items as `- [ ]` always (unchecked) — the `[x]` is never hand-written.**

Why: the project's whole thesis is *"status lives in files, the doc is a
projection, both must agree."* Today closing already double-writes (`__…__` +
`status: done`) precisely to avoid a hand/machine split. A hand-marked checklist
reintroduces exactly the drift the method exists to kill: an item ticked in prose
while no arc closed it, or an arc closed with no tick. The arc's `closes:` is the
**event**; the checkmark is a **view** of that event.

Concretely: the item text lives in the goal doc (authoring is human — you decide
the decomposition). The *done bit* is derived: `arcs status` scans the goal's
sub-arcs, reads each closed arc's `closes:`, and renders `[x]` for matched items.

**Tradeoff:** the rendered `[x]` view diverges from the raw bytes of the goal doc
(doc says `[ ]`, status says `[x]`). That's a real cost — someone `cat`-ing the
doc sees stale-looking `[ ]`. Mitigation: (a) `arcs status` is the canonical
render and the SPEC says so explicitly; (b) optionally a `arcs sync` /
`arcs check <goal>` command can *write* the computed `[x]` back into the doc as a
convenience snapshot — but the **source of truth stays `closes:`**, the doc is a
cache. Recommend shipping the read-side render first; defer write-back (see Drop).

### Q2 — Do supersession chains REPLACE goal-doc version numbering, or coexist?

**Pick: REPLACE. Drop the `MM-<slug>-goal.md` numeric version axis entirely. One
goal folder = one `<slug>-goal.md`. Intent pivots are expressed by superseding the
whole goal (close it, open a successor with `supersedes:`), not by dropping a new
numbered doc inside the same folder.**

Why: the idea text is right that "immutable goal → version number is pointless,"
but the deeper reason is **one mechanism, not two**. Today there are two
"how a goal changes" stories: (a) versioned goal docs (`01-…-goal.md` →
`02-…-goal.md`, highest wins) for the goal's own evolution, and (b) supersession
chains for arcs. That's redundant — both encode "the old framing is frozen,
here's the new one." Collapsing to supersession means **the same chain reasoning
covers arc-drift and goal-pivot**, the stream's `NN` numbering + `__…__` +
`supersedes:` already give full history, and a goal folder stops carrying an
internal mini-version-counter that the CLI has to sort (`ls *-goal.md | tail -1`).

Crucially: a goal *progressing* (items getting checked) is **not** a version
event at all under the new model — it's just arcs closing. Versioning only ever
fired on *pivots*, and pivots are now supersession. So the `MM` axis loses its
last job.

**Tradeoff:** lose the cheap in-place "amend the goal doc by dropping v02 next to
v01" affordance. Small wording fixes (typo in the goal line, clarify an item) now
have no blessed home — you'd either (a) edit in place (acceptable: the SPEC can
say *clarifying* edits are fine, *intent* changes require supersession), or
(b) supersede, which is heavyweight for a typo. Recommend: **allow in-place edits
for clarification; require supersession only when the `goal:` purpose or a
checklist item's meaning changes.** Draw the line at "would a reader's
understanding of what we're building change?" — yes → supersede.

### Q3 — Field shape for `prev:`/`supersedes:`/`closes:`; is `arcs supersede` needed?

**Field shape — values are stream references (the `NN-slug` folder name, minus
`__…__`), keys stay English:**

On an **arc.md** (sub-arc of a goal):
```markdown
# 03-integrate-stripe
goal:      wire Stripe checkout end-to-end
status:    done
closes:    integrate-stripe          ← checklist-item key in the parent goal
supersedes: 02-stripe-spike          ← (optional) the arc this one replaces
```

On a **goal doc** (`<slug>-goal.md`), when the goal itself is a successor:
```markdown
# payments-v2-goal — …
goal:       …
status:     active
supersedes: 04-@payments              ← the goal whose intent this pivots from
```

Decisions inside the shape:
- **`closes:` targets a checklist-item key, not "step N".** Today `closes:` is
  prose (`closes: goal <slug> step <N>`). Numeric steps are fragile — insert an
  item and every key shifts. Use a **stable slug key** per checklist item. The
  item line carries its key implicitly via its text-slug, OR explicitly:
  `- [ ] integrate stripe  {#integrate-stripe}`. Recommend implicit:
  derive the key by slugifying the item text; only add an explicit `{#key}` if two
  items would collide. Keeps authoring frictionless.
- **`supersedes:` and `prev:` — pick ONE name. Recommend `supersedes:`** (reads
  as a verb-relation, matches the user's "supersession" framing) and document
  `prev:` as a tolerated alias the parser also reads, for ergonomics. Don't invent
  two first-class fields doing the same job.
- **Reference format = bare folder slug** (`02-stripe-spike` or just
  `stripe-spike`), resolvable whether the target is open or `__…__`-closed. The
  parser strips `__`. Avoid full paths — keep it greppable and short.

**CLI — yes, add `arcs supersede`, and make it do the whole transition atomically:**
```
arcs supersede [-g <goal>] <old-slug> <new-slug> [item-or-purpose text]
```
What it does, in order:
1. **Closes** `<old>` (wrap `__…__`, `status: done`) — reusing `cmd_close`,
   but **without** the empty-`output/` guard for a superseded arc (a redirected
   arc legitimately has no shippable output; pass through `-f` semantics
   internally, or relax the guard when `supersedes` is set).
2. **Creates** `<new>` in the same scope (same stream for a goal, same goal
   substream for a sub-arc), via `cmd_new_arc`/`cmd_new_goal`.
3. **Writes** `supersedes: <old>` into the new one's `arc.md`/goal doc.
4. Optionally seeds the new one's `input/` with a `from-<old>.md` note (mirrors
   how `promote` moves the candidate into `input/`) so the lineage carries
   context, not just a link.

This is the one new verb. It is **not** a rename — rename would lose the
predecessor; the whole point is both exist, linked. It's close-old + open-new +
link, which is exactly the manual dance written down as one command.

### Q4 — What does `arcs status` show for checklist progress?

**Pick: per-goal `N/M ✓` summary on the goal line, plus the checklist items
rendered with computed `[x]`/`[ ]` and the closing arc appended.**

```
STREAM
  10-@payments                 [active]   wire payments end-to-end   (2/3 ✓)
      ✓ integrate stripe        → 03-integrate-stripe
      ✓ webhook handling        → 05-webhooks
      ○ refunds flow            (open)
      02-stripe-spike           [done]     superseded by 03-integrate-stripe
```

Rules for the renderer:
- `N/M ✓` = matched-closed items / total checklist items. Cheap, scannable, the
  headline the idea asked for.
- Each item line shows `✓`/`○` (computed from `closes:` matches among the goal's
  closed sub-arcs) and, when matched, `→ <arc>` so the trace is visible inline.
- Sub-arcs that don't `closes:` any item (spikes, superseded arcs) still list, but
  under their own line with their `supersedes:`/status, so chains stay visible.
- A goal with no `## Checklist` falls back to today's behavior (list sub-arcs
  raw) — backward compatible for the 1 existing goal until migrated.

---

## Field / CLI spec (concrete)

**Goal doc** (`<slug>-goal.md`, no `MM-` prefix):
```markdown
# <slug>-goal — <title>
goal:        <one line — the immutable purpose>
status:      active | done
supersedes:  <old-goal-ref>          # only if this goal is a successor

## Checklist
- [ ] <item one>                      # key = slugify(text), or explicit {#key}
- [ ] <item two> {#explicit-key}

## Where we are
<current bottleneck — free prose, still editable>
```
Removed: `version: NN (highest number = current)` line and the `MM-` filename
prefix.

**Sub-arc `arc.md`:**
```markdown
# NN-<slug>
goal:        <one line>
status:      active | blocked | done
closes:      <checklist-item-key>     # the item in the parent goal this satisfies
supersedes:  <old-arc-ref>            # optional; alias: prev:
## output → pointers
- output/... — …
```

**CLI additions / changes:**
| Command | Behavior |
|---|---|
| `arcs supersede [-g <g>] <old> <new> [text]` | close old (no output-guard) + create new + write `supersedes:` + seed `input/from-<old>.md`. The one new verb. |
| `arcs new-goal <slug>` | now scaffolds `<slug>-goal.md` (no `01-` prefix) with a `## Checklist` stub; drops the `version:` line. |
| `arcs close` | unchanged for arcs; for goals, finds `<slug>-goal.md` (single file, no more `ls | tail -1` over versions). |
| `arcs status` | join sub-arcs' `closes:` → checklist items; render `N/M ✓` + per-item `✓/○ → arc`; show `supersedes:` chains. |
| `arcs check <goal>` (optional, deferred) | write computed `[x]` back into the doc as a cached snapshot. |

Parser note: `cmd_status`'s `gdoc=$(ls "$d"*-goal.md | tail -1)` collapses to a
single match — keep the `tail -1` for safety during migration (tolerates a
lingering `01-` file) but the steady state is one file.

---

## Migration + risks

**Self-hosting reality:** this repo *is* its own first user. The change must
migrate the repo's own `.arcs/` or the method contradicts its own SPEC.

State today (from `.arcs/arcs/`):
- 9 closed arcs `__01__…__09__` (one gap — no `08` standalone; there's a
  `08-@immutable-goals-and-chains` **duplicate** of this very goal alongside `10-`).
- 1 closed goal `__06-@landing-essence-first__` with a versioned doc
  `01-landing-essence-first-goal.md` and one closed sub-arc.
- 2 OPEN goal folders that are the SAME idea: `08-@immutable-goals-and-chains`
  (skeletal — only `arcs/ output/ workspace/`, **no input/, no goal doc**) and
  `10-@immutable-goals-and-chains` (the real one, with goal doc + input). The
  `08` is a stray rescued-but-superseded copy.

Migration impact:
1. **Closed arcs (`__01__…`):** zero `closes:`/`supersedes:` today, no checklist.
   They stay valid — the new fields are *additive and optional*. No rewrite needed.
   `arcs status` renders them as before. ✓ low risk.
2. **`__06__` goal:** has `version: 01` line + `01-…-goal.md` filename. Migration
   = rename file to `landing-essence-first-goal.md`, drop the `version:` line.
   It's closed/historical so even this is optional — but doing it makes the repo
   exemplary. Its sub-arc has no `closes:` → renders raw (fallback path). ✓ low.
3. **The `08` duplicate goal is the real hazard.** It's an incomplete twin of the
   goal currently being designed. Under the new model this is *literally a
   supersession case*: `08` should be **superseded by `10`** —
   `arcs supersede 08-@immutable-goals-and-chains 10-@immutable-goals-and-chains`
   would be the dogfood demonstration, except `10` already exists. Practical fix:
   close `08` with `status: done` + add `supersedes`/`note` pointing to `10`, OR
   just delete `08` (it has no input/ and no goal doc — nothing to preserve). The
   commit log says `08` was "rescued from closed arc workspace"; it's vestigial.
   **Recommend: fold `08`'s number into the chain by closing it as superseded-by-`10`,
   to keep numbering immutable (the SPEC forbids freeing a number).** Don't just
   `rm` it — that violates "closing renames but never frees a number."

Backward-compat risks:
- **`closes:` semantics change** from "step N" prose to item-key. No existing arc
  uses the step form (grep shows none), so no breakage — but the SPEC text and any
  examples must update in lockstep, or the parser sees two grammars.
- **`arcs status` checklist render** must degrade gracefully for goals lacking
  `## Checklist` (the fallback path above). Ship that fallback or `__06__` breaks.
- **Numbering invariant** must be honored during `08` cleanup (close, don't delete).
- **`MM` removal** touches `goal_md()`, `cmd_new_goal`, `cmd_close`, `cmd_status`,
  SPEC.md, SKILL, landing examples — a wide blast radius for docs. The *code*
  change is small; the *doc* surface is large (this is the self-hosting tax).

---

## Drop / defer

- **DROP: `MM-` goal-doc version numbering.** Fully replaced by supersession
  (Decision 2). Its only job — capturing pivots — is now supersession's job.
- **DROP: `prev:` as a distinct field.** Fold into `supersedes:` (one relation);
  keep `prev:` only as a read-tolerated alias so the idea's original wording still
  parses. Two first-class fields for one concept is the kind of redundancy the
  method preaches against.
- **DROP: numeric `closes: ... step N`.** Replace with stable item-keys. Step
  numbers shift on insert and would silently re-point arcs at the wrong item.
- **DEFER: write-back of computed `[x]` into the goal doc (`arcs check`).** Nice
  ergonomics but it's a second writer to the doc — ship the read-side `arcs status`
  render first (source of truth = `closes:`), add the cache later only if the
  `[ ]`-in-doc vs `✓`-in-status divergence proves confusing in practice.
- **DEFER: cross-goal / top-level arc checklists.** Checklists belong to *goals*
  (multi-arc work). A standalone arc has no checklist — don't generalize the
  feature to plain arcs; YAGNI.
- **INCOHERENT in the idea, resolved:** the idea floats "marked by hand OR
  computed" as still-open and writes the example as a literal `- [x] … → 03-…`
  *in the doc*. Taken literally that's hand-marking, which fights the method's
  source-of-truth principle. Resolved: the `→ arc` linkage is **rendered by
  status from `closes:`**, the doc stores `- [ ]`. The idea's example is the
  *rendered view*, not the stored bytes.
