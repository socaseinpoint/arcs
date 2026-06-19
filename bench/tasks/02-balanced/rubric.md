Score the `balanced.py` the candidate produced:

- 5 — correct stack-based solution handling all three pairs, mismatched nesting,
  and the empty string; clean idiomatic Python; ignores non-bracket chars; no junk.
- 4 — correct and clean, minor style nits.
- 3 — works on common cases but fragile (e.g. only counts brackets without
  checking nesting order, yet happens to pass) or sloppy.
- 2 — partially works / wrong on nesting cases like "([)]".
- 1 — missing or broken.
