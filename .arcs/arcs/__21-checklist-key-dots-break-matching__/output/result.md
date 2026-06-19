# result — dotted checklist keys now match closes:

## What was broken
A checklist item whose key contained dots (e.g. `cut-release-0.2.0`) never matched a sub-arc's
`closes:` value → the goal badge read `0/1 ✓` and the item rendered as a garbage slug of the whole
line. The 0.2.0 release dodged it by stripping dots from the key (`cut-release`), which is why it
shipped.

## Root causes (bin/arcs)
1. `goal_item_keys` key-extraction regex `^[A-Za-z0-9][A-Za-z0-9-]*$` rejected `.`, so a dotted
   leading token wasn't taken as the key — it fell through to `slugify(whole text)`, folding the
   description into the "key".
2. `closing_arc_for` compared `read_closes` raw against the key with no shared normalization, so
   dot-vs-dash drift could never match.
3. `render_goal_substream` dedup compared raw `closes:` against rendered keys — same drift re-listed
   a closing arc as a stray.

## Fix
- Key regex now allows dots: `^[A-Za-z0-9][A-Za-z0-9.-]*$` (spaces still reject, so prose still
  slugifies the whole text as before).
- Match normalizes both sides through `slugify()` in `closing_arc_for` and in the dedup, so
  `cut-release-0.2.0` ↔ `cut-release-0-2-0` round-trip. Display keeps the human form.

## Changed files
- `bin/arcs` — 4 edits (key regex; `closing_arc_for` normalize; dedup normalize + rendered-keys store)
- `CHANGELOG.md` — Unreleased > Fixed entry

## Verified
`/tmp/arcbug`: dotted explicit key + prose-derived key both reach `2/2 ✓`, no stray re-list.
Real repo regression: goals 10 (3/3) and 13 (2/2) unchanged.
