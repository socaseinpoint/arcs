# Ask

User: closing an arc should rename its folder with `__` at the start and end —
`NN-slug` → `__NN-slug__` — so the closed/done state is visible at a glance in the
filesystem (`ls`), not only inside `arc.md`.

Verbatim (ru): "арки можно закрывать и я бы их закрывал добавив __ (два underscore)
в начале и в конце и так удобно было бы видеть статус арок"

## Design
- `arcs close <slug>` (and `arcs close -g <goal> <slug>`): rename dir to `__NN-slug__`
  AND set `status: done` in arc.md. (Optionally `arcs reopen` to undo — nice-to-have.)
- The `__...__` name is the at-a-glance done marker; `arc.md status: done` stays the
  machine source of truth. Both agree.

## Interaction to handle (important)
- `next_num()` globs `[0-9][0-9]-*/` — a closed `__01-slug__` would NOT match, so the
  next arc could reuse number 01. FIX: numbering must count closed arcs too (scan both
  `NN-*` and `__NN-*__`, strip the `__`).
- `arcs status` lists `*/arc.md`; `__NN-slug__/arc.md` still matches → shown with the
  `__` in the name. Good — that's the visible marker. (Could dim closed rows later.)
- Goals could later get the same treatment; out of scope for now (arcs only).
