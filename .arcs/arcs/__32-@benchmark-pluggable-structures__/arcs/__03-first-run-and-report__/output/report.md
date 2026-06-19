# Benchmark report

Source: `/Users/socaseinpoint/Documents/projects/arcs/bench/results/20260619-013344/runs.csv`

## Per arm (means)

| arm | runs | in_tok | out_tok | cost $ | dur ms | tests pass % | judge avg |
|-----|------|--------|---------|--------|--------|--------------|-----------|
| bare | 12 | 103822 | 365 | 0.1785 | 13830 | 100% | 5.00 |
| arcs-default | 12 | 308148 | 964 | 0.2710 | 30407 | 100% | 4.83 |

## Per arm × task (means)

| arm | task | runs | out_tok | cost $ | dur ms | pass % | judge |
|-----|------|------|---------|--------|--------|--------|-------|
| arcs-default | 01-slugify | 3 | 1033 | 0.2732 | 30949 | 100% | 5.00 |
| arcs-default | 03-csv-stats | 3 | 1022 | 0.2723 | 29963 | 100% | 5.00 |
| bare | 02-balanced | 3 | 456 | 0.1839 | 14248 | 100% | 5.00 |
| bare | 03-csv-stats | 3 | 432 | 0.1833 | 16168 | 100% | 5.00 |
| arcs-default | 00-stub | 3 | 952 | 0.2904 | 33794 | 100% | 4.33 |
| arcs-default | 02-balanced | 3 | 848 | 0.2479 | 26920 | 100% | 5.00 |
| bare | 00-stub | 3 | 344 | 0.1936 | 15019 | 100% | 5.00 |
| bare | 01-slugify | 3 | 229 | 0.1532 | 9882 | 100% | 5.00 |

_in_tok = total input incl. cache (fresh + cache-creation + cache-read);
cost $ is the money truth (prices cache tiers correctly). Means hide variance —
check runs.csv for per-rep spread before drawing conclusions._
