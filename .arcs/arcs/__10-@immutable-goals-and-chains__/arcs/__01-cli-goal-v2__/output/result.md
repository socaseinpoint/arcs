# result — cli-goal-v2

goal-v2 implemented in `bin/arcs` as one coherent change (pure bash 3.2, existing idioms).
Verified by hand on a /tmp scratch board (torn down); the real board renders clean.

## What shipped
1. **Dropped `MM-` goal-doc versioning** → one `<slug>-goal.md`, no `version:` line; goal template now
   ships a `## Checklist` stub instead of `## Arcs of this goal`.
2. **Computed checklist render** in `arcs status`: `N/M ✓` badge on the goal line + per-item
   `✓ <key> → <arc>` / `○ <key>`, driven by closed sub-arcs' `closes:`. No-checklist goals fall back to
   the raw sub-arc list (back-compat).
3. **`arcs supersede <old> <new>`** + `supersedes:` field (with `prev:` as read-alias); `closes:` and
   `supersedes:` added as commented optional fields to `arc_md()` (en/ru/es).

## Pointers into bin/arcs (function — line range)
- `slugify()` — **73–76** (item-text → stable slug key)
- `read_supersedes()` — **78–83** (reads `supersedes:`; `prev:` read-alias; strips `__`)
- `read_closes()` — **85–87** (reads uncommented `closes:`)
- `goal_item_keys()` — **89–113** (awk: parse `## Checklist` items → `key<TAB>text`; explicit `{#key}` or `<slug> — desc` leading token)
- `arc_md()` — **115–163** (added `# closes:` + `# supersedes:` commented fields, all 3 langs)
- `goal_md()` — **165–215** (sig `($path,$slug,$lang)`; writes `<slug>-goal.md`; no `version:`; `## Checklist` stub; `# supersedes:`; all 3 langs)
- `cmd_new_goal()` — **266–276** (updated `goal_md` call + echo, no `MM-`)
- `closing_arc_for()` — **278–287** (bash-3.2 map-free: closed sub-arc declaring `closes:<key>`)
- `item_key()` — **289–295** (split `key<TAB>text`; slugify text when key empty — avoids `read` IFS-tab leading-skip bug)
- `goal_progress_badge()` — **296–306** (`N/M ✓`)
- `render_goal_substream()` — **308–333** (per-item ✓/○ lines + non-closing/superseded sub-arc list; raw fallback when no checklist)
- `cmd_status()` — **335–376** (goal branch now calls badge + substream renderer)
- `cmd_help()` — line **387** (added `arcs supersede` usage)
- `cmd_supersede()` — **533–557** (close old `-f` + new-arc + write `supersedes:` + seed `input/from-<old>.md`)
- dispatch `supersede)` — line **567**; top-of-file subcommand comment — line **3**

## New / changed syntax (for the docs arc to document)
- **Goal doc:** `<slug>-goal.md` (no `MM-` prefix, no `version:` line). Carries `## Checklist` with
  `- [ ] <item>` lines. Item key = explicit `{#key}`, else leading slug-token of a `<key> — <desc>`
  line, else slugify of the whole text. Optional `supersedes:` field when the goal is a successor.
- **Sub-arc `arc.md`:** optional `closes: <checklist-item-key>` and `supersedes: <old-slug>`
  (alias `prev:` accepted on READ only). Shipped commented in the template.
- **`arcs status`:** goal WITH a checklist → `(N/M ✓)` on the goal line, then `✓ <key> → <arc>` /
  `○ <key>` per item, then any non-closing/superseded sub-arcs with their `[status]` + `supersedes <ref>`.
  Goal WITHOUT a checklist → unchanged raw sub-arc list.
- **`arcs supersede [-g <goal>] <old-slug> <new-slug>`:** closes `<old>` (no output guard), creates
  `<new>` in the same scope, writes `supersedes: <old>` into `<new>/arc.md`, seeds
  `<new>/input/from-<old>.md`. Refs are bare slugs (`__` tolerated).

## Deviation
- Spec's optional trailing `[item-or-purpose text]` arg to `supersede` not implemented; kept the verb to
  `<old> <new>`. Free-text rationale goes in the seeded `from-<old>.md` / new arc.md. No behavior lost.

## For the docs arc (rewrite-docs-for-goal-v2)
- SPEC.md / SKILL / landing examples must drop `MM-`/`version:`, document `## Checklist` +
  computed render, `closes:`/`supersedes:`/`prev:`-alias, and `arcs supersede`.
- `arcs status` is the canonical checklist VIEW — the goal doc stores `- [ ]` always; `[x]` is never
  hand-written (write-back / `arcs check` deferred per the locked model).
- Migration of this repo's own goal docs (`__06__`'s `01-…-goal.md`, the `10-` goal's `version:` line)
  is a SEPARATE arc — not touched here.
