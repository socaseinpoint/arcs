# arcs — project coherence audit

Date: 2026-06-18 · Auditor pass over SPEC, CLI, README, CHANGELOG, skill, landing (docs/), DEPLOY,
hooks, install, rules, template, examples, and the self-hosted `.arcs/` state.

## Verdict
Core method is coherent and the CLI matches SPEC well; the live drift is concentrated in **stale
docs (`docs/DEPLOY.md` still teaches the dropped `.arcs/goals/` dir), a broken self-hosted goal
folder (`08-@immutable-goals-and-chains` — empty, untracked, duplicate of `10`), and a stale
`examples/README.md` board (`ARCS` not `STREAM`)** — fixable, but two of these actively mislead.

---

## Findings by severity

### CRITICAL

**C1 — `docs/DEPLOY.md` "Use it in a project" teaches the removed `.arcs/goals/` directory.**
`docs/DEPLOY.md` (section "## Use it in a project"):
```
arcs new-goal payments            # multi-arc work → .arcs/goals/01-payments/
```
The whole point of closed arc `__05-unify-goals-into-single-arc-stream__` was to **drop
`.arcs/goals/`** — goals now live in the single stream as `.arcs/arcs/NN-@<slug>/`. The deploy guide
(linked as "Full guide" from README, SPEC, and the landing) still documents the old layout, with the
old single-counter-violating `01-payments` numbering. A new user following DEPLOY builds the wrong
mental model and looks for a dir the CLI never creates. This is the single most misleading artifact
in the repo.

**C2 — Self-hosted `.arcs/arcs/08-@immutable-goals-and-chains/` is a broken, orphaned duplicate goal.**
On disk: `.arcs/arcs/08-@immutable-goals-and-chains/` contains only empty `arcs/ output/ workspace/`
— **no `MM-…-goal.md`, no `input/`**. It is **entirely untracked by git** (`git ls-files` returns
nothing; `git status` shows it absent). It does not even render in `arcs status` (no goal doc → the
status loop skips it). Meanwhile the *real* active goal is `10-@immutable-goals-and-chains/` (same
slug, full goal doc + input). History: commit `5c57742` created `08-@immutable-goals-and-chains` WITH
a 28-line goal doc ("rescued from closed arc workspace"); that goal doc is now gone from `08` and the
work was re-promoted as `10` via the candidate flow. The leftover `08` skeleton is dead state that
violates the method it's supposed to demonstrate (a goal folder with no goal doc, no input). For a
self-hosting method repo this is a coherence break in the showcase itself. Should be deleted.

### HIGH

**H1 — `examples/README.md` board uses the old `ARCS` header, not `STREAM`.**
`examples/README.md` (the `$ arcs status` block) prints:
```
$ arcs status
ARCS
  01-spike-vite ...
```
The CLI (`bin/arcs` `cmd_status`, line ~234) prints `echo "STREAM"`, and CHANGELOG explicitly says
"`arcs status` now prints one **STREAM** board." The landing's fig.02 already shows `STREAM`. The
example README is the one place still showing the pre-unify `ARCS` label — a sample output that
doesn't match real output.

**H2 — Stream numbering has a permanent gap / lost number (07 → 09 → 10) plus the `08` ghost.**
`arcs status` stream jumps `__07-…__` → `__09-…__` → `10-…`. SPEC's invariant (lines 182-185) says
"Closing renames but never frees a number; an arc and a goal never reuse one." There is no `08-*` in
the visible stream (the `08` ghost from C2 doesn't render and isn't a real entry). So number 08 is
effectively lost, and slug `immutable-goals-and-chains` appears under BOTH 08 (ghost) and 10 (live) —
the slug is reused across two numbers, which the single-stream model is meant to prevent. Cleaning up
C2 leaves a benign gap (08 simply skipped); leaving it is an active contradiction of the invariant the
repo teaches.

**H3 — `template/.arcs/goals/` still ships the removed directory.**
`template/.arcs/goals/.gitkeep` exists. The unify-goals arc dropped `.arcs/goals/`, SPEC line 21
states "There is no separate `goals/` directory", and `template/README.md` correctly documents only
the single stream — yet the template scaffold still carries an empty `goals/` dir. Anyone copying the
template (or reading it as canonical) re-introduces the dead dir. Note: the CLI's `arcs init` never
creates `goals/`, so this is template-only drift, but it directly contradicts the template's own README.

### MEDIUM

**M1 — `bin/arcs` header comment lists an outdated subcommand set and meta layout.**
`bin/arcs` lines 2-4: the banner lists "Subcommands: init · new-arc · new-goal · close · reopen ·
status · lang · rule · update · help" — **omits `candidate` and `promote`** (both implemented and
dispatched at lines 434-435). Line 4 says ".arcs/{arcs,rules}/" — omits `candidates/`. `cmd_help`
(the user-facing help) is correct and complete; only the top-of-file comment is stale. Low user
impact, but it's the file's own self-description drifting from its dispatch table.

**M2 — README footer links a different (stale) landing URL than the rest of the repo.**
`README.md` line 9 links the landing as `https://arcs-delta.vercel.app`; README line 77 (footer)
links `https://arcs-socaseinpoints-projects.vercel.app`. Two different URLs for "the landing" in one
file. CHANGELOG/commit `89b952e` indicates `arcs-delta.vercel.app` is the shipped prod URL, so the
footer link is the stale one.

**M3 — SPEC localized goal template claims English keys include `version:` but text elsewhere frames
versioning as on its way out.** Not a current-state bug, but flagged for goal-v2: see "Relevant to
goal-v2" below. (No contradiction *today* — `version:` is a real field the CLI writes; noting it as a
drift surface, not an error.)

### LOW

**L1 — `bin/arcs` `cmd_help` / SKILL describe `arcs reopen` and `arcs lang <en|ru>` slightly unevenly.**
`cmd_init`'s generated project README (bin/arcs line 181) says "change language: `arcs lang <en|ru>`"
— omits `es`, though `es` is fully supported everywhere else (init, lang, templates). Cosmetic, but
the generated per-project README under-documents a supported language.

**L2 — `arcs status` "lang" line vs SPEC wording.** SPEC line 207 says `arcs status` "the single
STREAM board (also shows the language)". CLI also prints a `rules:` line (line 232). Minor: SPEC's
one-liner mentions language but not the rules line that status now also emits. Harmless under-doc.

**L3 — `arcs.md` passport: SPEC shows `closes: goal <NN-@slug> step <N>` field; CLI's generated
`arc.md` template never emits a `closes:` line.** SPEC line 46 documents a `closes:` field on the arc
passport for sub-arcs of a goal; `arc_md()` (bin/arcs lines 75-117) generates only `goal: / status: /
## input / ## output → pointers`. The field is spec-documented but never scaffolded, so in practice
no arc carries it. Either spec over-specifies or the template under-delivers. (Relevant to goal-v2,
which proposes `prev:`/`supersedes:`/`closes:` linkage — see below.)

---

## Drift hotspots (ranked)

1. **`docs/DEPLOY.md`** — the only doc still teaching `.arcs/goals/` + `01-payments` numbering (C1).
   Highest-traffic stale doc (linked as the "full guide" from SPEC/README/landing).
2. **Self-hosted `.arcs/` state** — the `08` ghost goal (C2) + the 07→09→10 numbering gap (H2).
   The method's own dogfood store contains a malformed goal.
3. **`examples/`** — `examples/README.md` still prints `ARCS` board header (H1); otherwise examples
   are current (single stream, `@`, candidates all correct).
4. **`template/`** — leftover `goals/` dir (H3).
5. **Self-description comments** — `bin/arcs` top banner (M1), README dual landing URL (M2),
   generated README lang list (L1).

**Clean (no drift found):** SPEC.md (matches CLI on numbering, `__…__` close, single stream,
`NN-@slug` goals, candidates, rules layer, encapsulation, empty-output refusal); `skill/SKILL.md`
(fully current — single stream, candidates, rules, close/reopen, `-f`); `docs/index.html` + landing
copy (explicitly says "no separate `goals/` anymore", shows `STREAM` board, candidates section,
rules-with-config-toggle); `rules/subagents.md`; `hooks/arcs-hook` + `hooks/arcs-gate`; `install.sh`;
CHANGELOG (Unreleased section accurately covers all 9 shipped arcs: rules layer, subagents default,
close-by-underscore, empty-output refusal, candidates, single-stream, landing rewrite).

---

## Relevant to goal-v2 ("immutable goals + supersession chains")

The active goal `10-@immutable-goals-and-chains` plans to (a) make goal intent immutable, (b) replace
`MM-…-goal.md` **version numbering** with supersession **chains** (`prev:`/`supersedes:`), and (c)
turn the goal doc into an **arc-linked checklist**. Places across the project that currently assume
the *mutable / version-numbered* model and will need to change (or already half-anticipate the new
one):

- **SPEC.md "Versioning a goal (by number, not by editing)"** (lines 96-104) — the canonical
  description of the to-be-replaced mechanism. The entire section is goal-v2's primary target.
- **`bin/arcs` `goal_md()`** (lines 119-164) — writes `version: $2 (highest number = current)` into
  every new goal doc, in all three languages. The `version:` field and the `MM-` filename axis are
  what goal-v2 wants to drop.
- **`cmd_new_goal` / `cmd_close` / `cmd_reopen`** — all resolve the goal status doc via
  `ls *-goal.md | sort | tail -1` (highest-number-wins). A checklist model that drops the `MM`
  version axis changes this resolution entirely.
- **`docs/index.html`** "Versioning a goal — by number, not by edit" block (lines 148-149) — landing
  copy teaching the exact mechanism goal-v2 reverses. Will need a rewrite when goal-v2 ships.
- **`examples/basic/.arcs/arcs/02-@newsletter/01-newsletter-goal.md`** — carries `version: 01
  (highest MM-…-goal.md number = current)`; the showcase example uses the old model.
- **SPEC `arc.md` passport `closes:` field (line 46) + L3** — goal-v2's `prev:`/`supersedes:`/
  arc-linked-checklist plan is the natural home for the `closes:` linkage that's spec'd but never
  scaffolded today. Good news: nothing yet *implements* a competing `prev:`/`supersedes:` field, so
  there's no conflicting half-built state to unwind — the design space is clean.
- **The `08` ghost (C2)** is itself goal-v2 debris: it's the first (failed) promotion of this very
  idea. Cleaning it up is in-scope housekeeping for this goal.

No artifact currently implements supersession chains, so goal-v2 is greenfield on the mechanism side;
the work is (1) deleting/rewriting the version-numbering story in SPEC + landing + CLI template, and
(2) migrating the two live `version:`-bearing goal docs (the newsletter example + any real goal).
