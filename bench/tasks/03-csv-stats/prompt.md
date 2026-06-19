Create a file named `stats.py` in the current directory.

When run as `python3 stats.py <csv_path> <column>`, it reads the CSV file (which
has a header row), takes the named column, treats its values as numbers, and
prints exactly one line to stdout:

    mean=<mean> median=<median> max=<max>

Each number is formatted to exactly 2 decimal places. Median of an even count is
the average of the two middle values (after sorting).

Example — given `data.csv`:

    name,score
    a,10
    b,20
    c,30
    d,40

Running `python3 stats.py data.csv score` prints:

    mean=25.00 median=25.00 max=40.00
