# 02-author-3-tasks — result

Authored 3 small Python coding tasks under `bench/tasks/`, each with an objective
`verify.sh` (tests-first) and an LLM-judge `rubric.md`. Identical input for every arm.

## Tasks

| dir | function | what it exercises |
|-----|----------|-------------------|
| `01-slugify`   | `slugify(text)`          | string transform; ASCII-only edge cases (unicode dropped, empty, all-punctuation) |
| `02-balanced`  | `is_balanced(s)`         | stack logic; mismatched nesting (`([)]`), ignore non-brackets |
| `03-csv-stats` | `stats.py <csv> <col>`   | file I/O + argv; mean/median(even count)/max; exact 2-decimal output |

Each dir: `prompt.md` (identical input) · `verify.sh` (exit 0 = pass) · `rubric.md` (1–5).
Runtime: python3 (present at /usr/bin/python3 3.9.6).

## Verified (tests-first)

- Every `verify.sh` **fails on an empty sandbox** (no file → exit 1). ✓
- A correct **reference implementation passes** each `verify.sh`. ✓
  (refs were throwaway — not shipped; the arms must generate the real solutions.)

## Discriminating power (why these tasks)

- slugify: a `\w`-based regex keeps unicode → fails the ASCII case; only the
  spec-correct `[^a-z0-9]+` passes. Separates careful from sloppy.
- balanced: count-only solutions pass naive cases but fail `([)]`; forces real
  nesting logic.
- csv-stats: index-hardcoding or wrong even-median passes the doc example but
  fails the odd/even verify cases.

## Next (sub-arc 03)

Run the full matrix (2 arms × 3 tasks × 3 reps = 18 cells, +18 judge calls) on
Sonnet via `bench/run.sh`, produce `results/<ts>/report.md`, write findings.
This spends real API tokens — confirm before launching.
