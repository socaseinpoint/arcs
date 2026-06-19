# Result — arcs close requires non-empty output/

`arcs close` now guards encapsulation: refuses to close an arc whose `output/` is empty.
A closed arc must carry a self-contained result, per the method.

## Shipped
- `cmd_close` checks `output/` is non-empty before closing; clear error otherwise.
- `-f` / `--force` flag overrides (rare intentional empty close).
- Arg parser reworked to accept `-g`, `-f`, and `<slug>` in any order.

## Pointers — changed files
- `bin/arcs` (cmd_close guard + flag parse, help line)
- `skill/SKILL.md`, `SPEC.md` (close line notes the output/ requirement)
- `CHANGELOG.md` (Unreleased)

## Verified
Temp-dir test: close empty → fails (exit 1); add output → closes; `close -f` on empty → closes.
