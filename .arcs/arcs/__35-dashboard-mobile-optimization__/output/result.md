# result — dashboard mobile optimization

The dashboard was desktop-only: a fixed 256px left rail + `1fr` body. On a phone the rail
stayed put and the body was pushed off the right edge, clipped (`before-mobile.png`). Made it
responsive — single source file, one `@media (max-width:760px)` block + an off-canvas rail.

## Changes (`dashboard/template.html`)
- **Mobile topbar** (`.topbar`, hidden ≥760px): sticky bar with a ☰ burger, the `arcs`
  brand, and a live "scope · view" label. Gives the body full width and a way to reach nav.
- **Off-canvas rail**: at ≤760px `.app` collapses to one column and `aside.rail` becomes a
  left drawer (`translateX(-100%)`), slid in by `body.nav-open` with a dimming `.nav-scrim`.
  Reused the existing drawer motion/easing. Picking any scope/view auto-closes it; scrim tap
  and `Esc` also close.
- **Reflowed content**: pulse tiles 2-up (`minmax(94px)`), NOW / project / digest / map grids
  → single column, narrower padding, smaller heads.
- **Arc rows**: 4-col grid (`id · title · meta · badge`) → 3-col on mobile; the secondary
  `.arc-meta` column is hidden (detail still in the drawer), keeping `id · title · status`
  legible without horizontal scroll.
- **Drawer** widened to 94vw on mobile.
- Small JS: burger/scrim/Esc wiring + a topbar label updated inside `renderRail()`.

Desktop layout is untouched — every rule lives behind the `max-width:760px` query; the topbar
and scrim are `display:none` above it.

## Verified (Playwright, real generated page)
- `before-mobile.png` (390px) — rail clipping the body (the bug).
- `after-mobile-portfolio.png` — topbar + 2-up pulse + full-width NOW/project cards.
- `after-mobile-nav.png` — burger opens the off-canvas rail over a dimmed scrim; all scope/
  view/display controls reachable.
- `after-mobile-board.png` — project board: nav auto-closed on select, stream rows reflowed,
  no horizontal overflow.
- Desktop re-checked at 1440px — unchanged.
- Console: **0 errors** across portfolio, nav, and board.

## Notes
- Lineage SVG keeps `min-width:720px` inside its `overflow:auto` shell — it scrolls
  horizontally on mobile by design (a graph can't usefully reflow to 360px).
- Regenerate with `arcs dashboard`; the template change flows into every project's view.
