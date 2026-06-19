Score the `stats.py` the candidate produced:

- 5 — correct mean/median/max with proper even-count median and 2-decimal
  formatting; reads CSV by header name; clean idiomatic Python (csv/statistics
  modules ok); handles argv; no junk files.
- 4 — correct and clean, minor style nits.
- 3 — works on the example but fragile (e.g. hardcodes column index, wrong median
  on even counts but passes by luck, sloppy formatting).
- 2 — partially works / wrong on one statistic.
- 1 — missing or broken.
