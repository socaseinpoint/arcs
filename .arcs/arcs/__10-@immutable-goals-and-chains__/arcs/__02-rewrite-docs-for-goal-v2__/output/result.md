# result — rewrite-docs-for-goal-v2

Every prose/doc surface now describes goal-v2: immutable goals, supersession chains via
`arcs supersede`, a `## Checklist` whose done-state is computed from sub-arcs' `closes:`, and dropped
goal-doc version numbering. All claims verified against shipped `bin/arcs` (read + `arcs status` run).

## Per-surface changes (file · section · what)

- **SPEC.md**
  - `arc.md` passport block — replaced `closes: goal <NN> step <N>` with key-based `closes:` +
    `supersedes:` and a one-paragraph gloss (slug keys, not step numbers; `prev:` alias).
  - close-marker paragraph + goal table row + invariants + "Why this way" — `MM-<slug>-goal.md` →
    `<slug>-goal.md`; "versioned status doc" → "immutable status doc".
  - Replaced "Versioning a goal (by number)" section with "A goal is an immutable contract":
    supersession chains (`arcs supersede`, `supersedes:`/`prev:`), the `## Checklist` + computed
    render (`N/M ✓`, `✓ key → arc` / `○ key`), back-compat fallback. Added `arcs supersede` to the CLI list.

- **skill/SKILL.md**
  - "Two primitives" goal bullet — rewrote to immutable contract: `<slug>-goal.md` (no version),
    `arcs supersede`, never-hand-tick checklist + computed `N/M ✓`, `goal:` ≤12 words.
  - "The arc is the record" — added the review's PROCESS rules: workspace is disposable; delete a
    workspace note that merely restates output; anything a later arc consumes must be an `output/` file.
  - Commands list — added `arcs supersede [-g <goal>] <old> <new>`.

- **docs/index.html** (landing)
  - goal concept card — "versioned status doc `NN-<slug>-goal.md`" → "immutable status doc
    `<slug>-goal.md` — a `goal:` line plus a `## Checklist`".
  - Replaced the "Versioning a goal — by number" prose with two paragraphs: immutable goal +
    `arcs supersede` chain, and computed-not-hand-ticked checklist (ru+en).
  - fig.01 tree + fig.02 board + "you are here" note — goal-v2 names, `(1/3 ✓)` checklist render,
    closed arcs shown `__…__` to match real `arcs status` output.
  - `app.js`, `style.css` — no goal/versioning content; untouched.

- **examples/** (basic)
  - Renamed `01-newsletter-goal.md` → `newsletter-goal.md`; dropped `version:` line; added a 3-item
    `## Checklist` (research-stories / draft-issue / ship-issue) + "Where we are".
  - Sub-arc `arc.md`: `closes: goal 02-@newsletter step 1` → `closes: research-stories`.
  - Wrapped the two done arcs on disk (`__01-spike-vite__`, `__01-research__`) so the checklist
    actually renders `(1/3 ✓)` — see "Correction" below.
  - **examples/README.md** — tree, `arcs status` sample, and narrative rewritten to goal-v2 +
    checklist render + supersession note; paths updated to the wrapped names.

- **CHANGELOG.md**
  - `[Unreleased]` Added — two entries: immutable goals + supersession chains (`arcs supersede`,
    `closes:`/`supersedes:`/`prev:`); computed goal checklists (`N/M ✓`, never hand-ticked).
  - `[Unreleased]` Changed — entry on dropped goal-doc version numbering (one immutable
    `<slug>-goal.md`). `[0.1.0]` left untouched (historical record).

- **README.md** (repo root, not in spec list but contradicted the CLI)
  - "In 20 seconds" tree + the surface line — `NN-slug-goal.md (version=leading number)` →
    `slug-goal.md` (immutable, goal: line + checklist); added `arcs supersede` + computed-checklist line.

- **bin/arcs** (template WORDING only — no behavior change)
  - `arc_md()` `## input` placeholder → pointer cue `<input/… — one-line gist of what came in>` (en/ru/es).
  - `goal_md()` `goal:` placeholder → added `≤12 words; long version goes in "Where we are"` cue (en/ru/es).

## Doc claim corrected against the CLI
- The checklist `✓` render is gated on `__…__`-CLOSED sub-arcs (`closing_arc_for` matches only
  `__NN-*__`). examples/basic previously left done arcs UNWRAPPED, so a literal `arcs status` there
  printed `(0/3 ✓)`, not the `(1/3 ✓)` the docs want to teach. Fix: wrapped both done arcs on disk
  and matched every doc sample to real output. Verified with `arcs status` from `examples/basic/`:
  `(1/3 ✓)`, `✓ research-stories → 01-research`, top board shows `__01-spike-vite__`.

## Follow-up (out of scope here)
- `.arcs/` self-hosted goal/arc docs (this repo's own `version:` lines, `MM-` goal files) are NOT
  touched — that's the parallel `migrate-existing-self-hosted-state` arc.
- The example now demonstrates closed-arc `__…__` wrapping for the first time; if a later arc wants a
  separate "open vs closed example", that's a candidate, not done here.
