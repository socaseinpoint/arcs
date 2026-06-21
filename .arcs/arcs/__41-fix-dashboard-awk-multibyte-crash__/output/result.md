# Fix: dashboard awk multibyte crash

## Symptom
`arcs dashboard` printed `awk: towc: multibyte conversion failure on: '<byte>'`
and produced a broken page.

## Root cause
`scan.sh::read_capped` truncates file bodies with `head -c <max>`. That can cut a
multibyte UTF-8 char (Cyrillic arc text) mid-sequence. Under a UTF-8 locale, macOS
BWK awk (jstr_multi at scan.sh:21-24, and the injection awk in bin/arcs) tries to
decode the leftover byte and aborts with `towc: multibyte conversion failure`.

## Fix
Force byte locale where awk touches arbitrary file content:
- dashboard/scan.sh: `export LC_ALL=C LANG=C` after `set -euo pipefail`
- bin/arcs: `LC_ALL=C awk ...` on the template-injection call
C locale = raw bytes; UTF-8 passes through intact byte-for-byte, awk never converts.

## Verified
- scan.sh: exit 0, empty stderr (was: awk error on record 45)
- emitted JS parses in node (11 projects); embedded HTML data parses too
- `arcs dashboard` exit 0, placeholder replaced, 815KB page

## Files
- dashboard/scan.sh
- bin/arcs (cmd_dashboard injection awk)
