# Result — close arcs with __underscore__ marker

Closing an arc now renames its folder to `__NN-slug__` so done-state is visible at a glance
in `ls`, while `arc.md status: done` stays the machine source of truth.

## Shipped
- **`arcs close [-g <goal>] <slug>`**: rename `NN-slug` → `__NN-slug__` + set `status: done`.
- **`arcs reopen [-g <goal>] <slug>`**: undo (`__NN-slug__` → `NN-slug`, status back to active).
- **`next_num()` fix**: numbering counts both open `NN-*` and closed `__NN-*__` → numbers never reused.
- **`arcs status`** shows closed arcs with the `__...__` name + `[done]`.

## Pointers — changed files
- `bin/arcs` (next_num, cmd_close, cmd_reopen, _arc_searchdir helper, help, dispatch)
- `skill/SKILL.md` + `SPEC.md` (close/reopen documented; numbering invariant reconciled)

## Verified
Temp-dir test: closed `01-alpha` → `__01-alpha__`, next arc became `02-beta` (no reuse),
reopen restored `01-alpha`. Board renders closed rows correctly.
