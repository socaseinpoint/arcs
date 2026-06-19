# arcs self-migration — DECISION (consortium verdict)

How arcs evolves its on-disk format without breaking existing projects. Decided by a
12-critic jury (distinct lenses, each read the real `bin/arcs` + `.arcs/` tree) plus a
synthesis chair. **Result: 12/12 said the first proposal was over-engineered. Verdict =
SIMPLIFY. Zero votes to keep as-is.**

## Origin
Surfaced while parking arc 07 (checklist-items-as-arcs) on its breaking/migration question
(open Qs 3 & 4: migrate legacy goals / minor-vs-major). Generalized to "what is arcs'
upgrade strategy across the user's several drifting projects". First proposal (rejected
below) was a 5-piece engine: integer schema stamp + bidirectional version gate +
changelog-as-machine-DSL + `arcs doctor --fix` + whole-tree clean-git gate.

## Facts the jury found in the real code (these drive the decision)
- **The reader is forgiving.** `grep || true`; `render_goal_substream` falls back to a raw
  sub-arc list when there is no `## Checklist`; `read_closes`/field greps return empty when
  a field is absent. → **Dropping `closes:` / `## Checklist` does NOT break old goals.** The
  premise "old-format projects break" is mostly false for this tool.
- **Legacy goals 10 & 13 are CLOSED** (`__…__`) → the gate already skips them → frozen
  history. Rewriting them edits the record for zero functional gain.
- **`MIN_VERSION` is still 0.0.0, never fired.** A data-from-the-future floor already exists
  (`MIN_VERSION` + `.arcs-update-required` + `arcs-gate`, exit 2). A second gate is a dup.
- **One binary per machine** (`repo_dir()` resolves the script's own dir; VERSION lives at
  install root, not per-project). "Data newer than tool" needs a deliberate downgrade →
  near-impossible in practice. The schema stamp guards a threat the architecture prevents.
- **`.arcs/` IS git-tracked** (only `.arcs-update-required`/`.arcs-update-stamp` are
  ignored). So a git diff is a real review/rollback surface — but the tree is perpetually
  dirty (workspace churn; untracked `27-research/workspace` right now), so a whole-tree
  clean-git gate would fire constantly and force agents to stash unrelated work.

## DECISION — minimal design, two layers

### Layer 1 — arc 07 specifically: ship ZERO migration
Drop `closes:` + the `## Checklist` block from the templates + one CHANGELOG line. Goals
10/13 keep rendering untouched (dual-read you already accidentally have). If you want the
new shape demonstrated, do it as a **one-time supervised arc** that converts a sample in its
own `workspace/` and reviews via git diff — NOT an idempotent pass. → arc 07 becomes cheap.

### Layer 2 — reusable mechanism: build ONLY when a break is genuinely lossy (not now)
A versioned `migrations/<version>.sh` of tested, shape-idempotent, single-file-rewrite
functions, run at the END of `arcs update` (after the git pull). No new subcommand, no
meta file, no second gate, no changelog DSL.

**Mandatory guards baked in (the jury's additions):**
1. **Backup before bytes:** `cp -r .arcs .arcs/.backup-<version>-<ts>/` + print the restore
   command. Cheapest insurance, independent of git state (covers non-git / dirty `.arcs`).
2. **mktemp + mv on every rewrite** (as `cmd_close`/`config_set` already do) → crash
   mid-write can't truncate a file.
3. **OPEN arcs only.** Closed `__…__` arcs are frozen; never rewrite.
4. **FORBID create-folder steps.** `next_num` counts open+closed dirs → a crash between
   "created sub-arc" and "deleted block" makes a re-run mint a SECOND arc (duplicate /
   number inflation). → **Structural reshapes (checklist-item → sub-arc) MUST be a one-shot
   supervised arc, never an idempotent doctor/migration pass.**
5. **Parse canonical `arc.md`/`*-goal.md` frontmatter, NEVER `grep -r` the tree.** Lesson
   arcs already learned twice (0.3.1 dotted keys, 0.3.2 prose `status:`). Goal 10's own doc
   literally quotes the string `## Checklist`.
6. **Detect what to migrate by SHAPE**, no schema stamp. For data-from-the-future, reuse the
   existing `MIN_VERSION` floor — add nothing.

### Policy (write into RELEASING.md)
Define the deprecation window: a format break ships read-old + a changelog note AND is the
trigger to consider bumping `MIN_VERSION`; old-format readers get deleted at a NAMED future
version, owner = maintainer. Otherwise "migrate, don't accrete" silently becomes
dual-read-forever with no sunset.

### Multi-project fan-out
One shared tool, N project data trees. Accept lazy per-project migration on next edit (the
floor already does this); document it. Do NOT build a cross-project scanner.

## CUT from the first proposal (unanimous / near-unanimous)
- Integer schema stamp `.arcs/meta` — **cut 12/12** (only wrong-able mutable state in a
  derive-from-shape tool; dup of MIN_VERSION's job).
- New per-project data>tool / data<tool gate — cut (dup of shipped floor).
- `arcs doctor` as a standing subcommand — cut (fold into `arcs update` / surface drift in
  `arcs status`).
- Whole-tree clean-git gate as hard precondition — cut (fires constantly; scope safety to
  `.arcs/` via the cp backup instead).
- CHANGELOG-as-executable-DSL — cut (keep prose; ship steps as code).
- Down-migrations, per-migration ledger, checksums — stay cut (DB cargo-cult in a no-DB tool).

## Open disagreements (NOT resolved — decide on build)
1. **Does arc 07 need any migration at all?** 4 critics: zero (reader degrades gracefully,
   10/13 are closed/skipped). Others: build the mechanism now for the next, truly-lossy
   break. → Layer 1 sides with "zero for 07"; Layer 2 defers the rest.
2. **Mechanism = a `migrations/*.sh` dir, or just an arc?** Soul-guardian: the most
   arcs-shaped answer is the migration IS a one-time arc (hand-convert in workspace/, git
   diff = rollback, zero new code). Maintainer/agent: a tested `migrations/<version>.sh` run
   by `arcs update`. Both reject the doctor engine.
3. **data>tool — hard refuse or loud warn?** Lazy-human/onboarding: warn (refusing to edit
   your own readable markdown is a self-inflicted outage / bad first impression).
   SemVer/data-loss: keep a hard floor. Both agree: reuse MIN_VERSION, not a new axis.

## Net
No `.arcs/meta`, no second gate, no `doctor` subcommand, no whole-tree clean gate, no
changelog DSL. For 07: ship templates+changelog only. For the future: one optional
`migrations/` dir invoked from `update`, guarded by cp-backup + mktemp+mv + open-only +
no-create-folder + canonical-frontmatter parsing, gated on the existing floor.

## Pointers
- Full 12 verdicts + synthesis JSON: workflow run `wf_d234445b-f8c`
  (task `w09dnmjgc.output`).
- First (rejected) proposal + the simpler-vs-detect debate: this session's brainstorm.
- Feeds back into arc 07 (candidate `07-implement-checklist-items-as-arcs`): its Qs 3 & 4
  are now answered — ship zero migration, drop fields from templates, one CHANGELOG line.
