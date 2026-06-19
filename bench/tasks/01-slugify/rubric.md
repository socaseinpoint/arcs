Score the `slugify.py` the candidate produced:

- 5 — correct on all rules + edge cases (empty, all-punctuation, unicode letters
  dropped to ascii); clean, idiomatic Python; no dead code or junk files.
- 4 — correct and clean, minor style nits.
- 3 — works on the common cases but mishandles an edge case or is sloppy
  (e.g. leaves trailing hyphens in some input, over-complex).
- 2 — partially works / wrong on several cases.
- 1 — missing or broken.
