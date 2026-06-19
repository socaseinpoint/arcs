# notes — cli-goal-v2 implementation

## Design choices

- **Pure bash 3.2 (macOS).** The repo's `bin/arcs` runs under the system bash 3.2.57 (no
  associative arrays, no bash-4 features). My first pass used `declare -A` and it blew up
  (`declare: -A: invalid option`). Reworked to a per-key scan helper `closing_arc_for` — no maps.

- **Item-key derivation (3 tiers), all in `goal_item_keys()` awk + `item_key()` bash:**
  1. explicit `{#key}` in the item line wins;
  2. else if the item is the `<slug> — <desc>` form (the locked goal doc's shape, separator =
     em/en-dash or ` -- `/` - `) the leading slug-token is the key;
  3. else slugify the whole item text.
  Display shows the resolved KEY (a stable slug), never the raw description, so `closes: cli-goal-v2`
  matches the `- [ ] cli-goal-v2  — …` item, and ✓/○ lines read cleanly.

- **`read -r` IFS-tab bug.** awk emits `key<TAB>text`. `read -r key text` with `IFS=$'\t'` SKIPS a
  *leading* tab (tab is whitespace), so an empty-key row `\twebhook handling` swallowed the text into
  `key`. Fixed by reading the whole row (`IFS= read -r row`) and splitting by hand in `item_key()`
  via `${row%%$'\t'*}` / `${row#*$'\t'}`.

- **`closes:`/`supersedes:` are matched only when UNCOMMENTED.** Templates ship them as `# closes:` /
  `# supersedes:` placeholders; `read_closes`/`read_supersedes` grep `^closes:` / `^(supersedes|prev):`
  (no leading `#`), so the placeholder lines are ignored until a real value is written. `prev:` is a
  READ alias in `read_supersedes`; `cmd_supersede` only ever WRITES `supersedes:`.

- **Badge once.** `N/M ✓` renders on the goal line only (dropped the duplicate in-substream summary).
  Per-item lines: `✓ <key> → <arc>` (closed sub-arc declares `closes:<key>`) or `○ <key>`.

- **No-checklist fallback** kept verbatim (raw sub-arc list) so `__06-@landing-essence-first__` and
  any pre-v2 goal still render. `cmd_close`/`cmd_reopen` left untouched: their `ls *-goal.md | tail -1`
  already collapses to the single `<slug>-goal.md` and tolerates a lingering `MM-` file during migration.

- **`MM-` drop.** `goal_md()` signature changed `($path,$NN,$slug,$lang)` → `($path,$slug,$lang)`;
  writes `<slug>-goal.md`, no `version:` line, `## Checklist` stub replacing `## Arcs of this goal`.
  `cmd_new_goal` updated call + echo.

- **`supersede` is close-old(-f) + new-arc + write `supersedes:` + seed `input/from-<old>.md`.** Reuses
  `cmd_close -f` (relaxes the empty-output guard — a redirected arc may have no shippable output) and
  `cmd_new_arc`, same scope (`-g` passes through). Refs are bare slugs; `__` stripped on read.

## Deviations from spec
- None material. Spec floated an optional positional `[item-or-purpose text]` for `supersede`; I kept
  the verb to `<old> <new> [-g <goal>]` (the locked model's required shape) — free-text purpose can be
  written into the new arc.md/`from-<old>.md` by hand. The seed file already carries the lineage.

## Verification transcript (scratch dir under /tmp, torn down)

1. `bash -n bin/arcs` → SYNTAX OK; `./bin/arcs status` on the REAL board → clean render, all of
   01–12 including no-checklist `__06__` (raw fallback) and the v2 goal `10-` (`0/4 ✓` + ○ items).
2. Scratch `arcs init en` + `arcs new-goal payments` → produced `payments-goal.md` (NO `MM-` prefix,
   NO `version:` line, `## Checklist` stub). ✓
3. Authored a 3-item checklist (key-form, implicit-slug, explicit `{#refunds}`), `arcs new-arc -g
   payments integrate-stripe`, set `closes: integrate-stripe`, gave it output, `arcs close`:
   - before close: `(0/3 ✓)`, all `○`.
   - after close: `(1/3 ✓)`, `✓ integrate-stripe → 01-integrate-stripe`, `○ webhook-handling`,
     `○ refunds`. ✓ (slugify + explicit-key + key-form all correct)
4. `arcs new-arc stripe-spike` (no output) + `arcs supersede stripe-spike integrate-stripe-v2`:
   old closed WITHOUT the output guard tripping, new arc carried real `supersedes: stripe-spike`
   (commented template line removed), `input/from-stripe-spike.md` seeded. ✓
5. Goal-scoped: `arcs supersede -g payments webhook-spike webhook-handler` → chain inside the substream;
   hand-swapped the new arc's `supersedes:` → `prev:`, status still showed `supersedes webhook-spike`
   (read-alias honored). ✓
6. Tore down /tmp scratch; final `./bin/arcs status` on real board → clean; `git status` shows only
   `bin/arcs` modified by me (other dirty files predate this arc). ✓
