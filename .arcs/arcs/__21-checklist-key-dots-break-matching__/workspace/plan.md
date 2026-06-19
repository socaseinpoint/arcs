# plan — fix dotted checklist keys not matching closes:

## Repro (in /tmp/arcbug)
Checklist key `cut-release-0.2.0` + sub-arc `closes: cut-release-0.2.0`:
- badge shows `0/1 ✓` (no match)
- rendered key = `cut-release-0-2-0-cut-the-release` (whole text slugified)

## Root causes (bin/arcs)
1. `goal_item_keys` awk (line ~103): explicit-key regex `^[A-Za-z0-9][A-Za-z0-9-]*$`
   rejects dots → dotted leading token not recognized as the key → falls through to
   slugify(whole text), which folds in the description too.
2. `closing_arc_for` (line ~281): compares `read_closes` raw against `$key` with no
   shared normalization → dot-vs-dash representation drift never matches (e.g. a
   slugify-derived key `cut-release-0-2-0` vs a hand-written `closes: cut-release-0.2.0`).
3. `render_goal_substream` dedup (line ~329): same raw `$clo` vs `rendered_keys` compare
   → a normalized mismatch re-lists the closing arc as a stray.

## Fix (normalize both sides identically — candidate's recommendation)
- awk regex: allow `.` in the key token → `^[A-Za-z0-9][A-Za-z0-9.-]*$`. Dotted leading
  tokens become the key; spaces still reject (prose still slugifies whole text).
- `closing_arc_for`: compare `slugify(closes)` == `slugify(key)`.
- dedup: track + compare slugified keys.
Display keeps the human form (`cut-release-0.2.0`); only matching is normalized.

## Verify
Re-run the /tmp repro → expect `1/1 ✓` and `✓ cut-release-0.2.0 → 01-cut`.
Plus a prose-key variant (`- [ ] Cut release 0.2.0` + `closes: cut-release-0.2.0`).
