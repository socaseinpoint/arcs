# fix-goal-lifecycle-ops — result

All five goal-lifecycle defects in `bin/arcs` fixed. Syntax-checked, release-check green,
exercised in a throwaway temp dir.

## What was broken → what changed

### 1. `supersede` downgraded a goal to a plain arc
`cmd_supersede` always called `cmd_new_arc` for `<new>`, so superseding a goal `@old` produced
a plain arc `<new>` (no `@`, no goal-doc) — goal-ness was lost.

- `cmd_supersede` now detects whether `<old>` is a goal (open `NN-@old` or closed
  `__NN-@old__`) before closing it, then branches (`bin/arcs:560-583`):
  - goal → `cmd_new_goal "$new"`; writes `supersedes:` into the new `<slug>-goal.md`.
  - arc  → `cmd_new_arc` as before; writes `supersedes:` into `arc.md`.
- The `input/from-<old>.md` pointer now says "goal" or "arc" to match (`bin/arcs:595-597`).
- Detection note: `ls A B` exits non-zero when *either* glob operand is unmatched, so the two
  goal globs are checked in separate `ls` calls (`bin/arcs:563-565`) — a combined `ls` made
  the very first goal-supersede test silently fall through to the arc branch; fixed.
- Verified: `supersede "my-big-goal" "bigger goal"` → new dir `03-@bigger-goal/` with
  `bigger-goal-goal.md` carrying `supersedes: my-big-goal`; predecessor closed as
  `__02-@my-big-goal__` (sub-arcs preserved underneath).

### 2. `-g` ops didn't work on closed goals
`_arc_searchdir` only matched open `NN-@goal`, so `close -g`/`reopen -g`/`supersede -g`
against a closed goal failed with "goal not found".

- `_arc_searchdir` now falls back to closed `__NN-@goal__` (`bin/arcs:449-453`) so lifecycle
  `-g` ops resolve the goal's substream whether the goal is open or closed.
- `new-arc -g` into a *closed* goal still refuses (you shouldn't add work to a closed goal),
  but now with an actionable message: "goal '<x>' is closed — reopen it first" (`:227-231`).

### 3. close-goal output-guard + 'arc' noun
The empty-`output/` guard already covered goals (it checks `$dir/output` regardless of kind),
so a goal can't be closed empty either. Confirmed the close path uses the 'arc' noun
consistently in the guard message and that closing a goal hits the same guard.
Verified: `close dup` on a goal with empty `output/` is refused; succeeds after a file is
written, with `closed NN-@dup -> __NN-@dup__`.

### 4. bare-slug close/reopen arc-vs-goal ambiguity
`close`/`reopen` listed both the arc glob and the goal glob into one `ls ... | head -1`, so
when both `NN-foo` (arc) and `NN-@foo` (goal) existed it picked whichever sorted first — a
non-deterministic coin-flip.

- Both commands now resolve goal and arc separately and **prefer the goal** when the slug
  names one, else the plain arc (`cmd_close` `:466-469`, `cmd_reopen` `:497-500`).
- Verified: with both `04-dup` (arc) and `05-@dup` (goal) open, `close dup` deterministically
  closes the goal `05-@dup`; the arc `04-dup` stays open.

### 5. numbering past 99
Every `NN` glob was hard-coded to `[0-9][0-9]` (exactly two digits), so a 3-digit dir
(`100-foo`) was invisible to `next_num`, `close`, `reopen`, `supersede`, `promote`, and
`_arc_searchdir`.

- Wildcard scans (`next_num`, `next_num_file`) broadened to `[0-9][0-9]*-` so 2+ digit NN are
  counted (`bin/arcs:66,78`); numeric max is still parsed via `$((10#$n))`.
- Exact-slug lookups broadened to `[0-9][0-9]*-<slug>` everywhere. The `*` sits between the
  leading digits and the anchored `-<slug>/` ending, so it matches 2- and 3-digit prefixes
  without false-matching a hyphenated slug or a `@goal` dir (checked: arc glob never catches a
  goal dir, since `12-@foo` has no `-foo` segment).
- Verified: a fabricated `99-ninetynine` → next is `100-hundredth` → `101-oneoone`; close +
  reopen of the 3-digit arc work; `status` renders them. (Cosmetic: `status` iterates `*/`
  which sorts `99` after `100` lexically — a pre-existing display-only quirk, not introduced.)

## Verification
- `bash -n bin/arcs` → OK
- `./release-check.sh` → OK (0.4.0 consistent)
- Temp-dir smoke (mktemp, not the real `.arcs/`): goal supersede preserves goal-ness;
  `-g` ops on a closed goal resolve; close output-guard refuses empty then succeeds;
  bare-slug `close dup` picks the goal; numbering 99→100→101 with close/reopen/status.

## Not done / caveats
- `status` display order past 99 is lexical (99 after 100). Pre-existing, cosmetic; fixing it
  needs a numeric sort of the stream listing — out of scope for these lifecycle fixes.
