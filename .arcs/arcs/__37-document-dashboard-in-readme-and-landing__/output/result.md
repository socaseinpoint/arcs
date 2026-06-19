# result — dashboard docs + round-2 polish

## Docs (the original ask)
- **README.md** — new "## Dashboard" section: what `arcs dashboard` does, the command,
  where it writes, and that it's a read-only presentation layer.
- **docs/index.html** (landing) — new "§ 05 — See all your work, in one glance" section,
  presentation-layer framing, before the closer.
- **docs/docs.html** (deep docs) — new "§ 10 Dashboard" section + nav entries (top + sidebar)
  + an `arcs dashboard` row in the command-reference table.

## Round-2 dashboard polish (asked across the session)
- **Candidates everywhere** — surfaced on project boards and project cards (count chip), not
  just the digest. Each candidate is **clickable** → a detail drawer (idea text + full file
  body + a copyable `arcs promote <slug>`). Scanner now embeds candidate body.
- **Ordering** — candidates sit above closed arcs on the board (after in-flight); newest-first
  throughout.
- **i18n (en / ru / es)** — the whole UI chrome is localized via a string table + `T()` and a
  `[data-t]` sweep. A language switcher in the rail; choice persists in localStorage. Arc
  *content* stays in its own language; only the chrome translates.
- Closed goals render neutral (not colored); state persists across reload (URL hash +
  localStorage); the local server sends `no-store` so reloads are always fresh.

## Verified (Playwright, real generated page)
- README/landing/docs sections present.
- Language switch: `ru` → "обзор" + Russian pulse labels; `es` → "resumen". Persists.
- Candidate chip on digest → opens drawer titled "benchmark-where-arcs-wins" with content.
- Candidates on project cards + board; **0 console errors**.

## Note on scope
This arc started as "document the dashboard" and absorbed a round-2 polish pass over one
live session — its goal line was widened mid-flight to match. Distinct dashboard arcs
(34 cli · 35 mobile · 36 usefulness) shipped earlier; this one carries docs + the polish.
