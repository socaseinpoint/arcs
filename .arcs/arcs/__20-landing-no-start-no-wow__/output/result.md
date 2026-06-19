# 20 — landing now has a wow + a concrete first move

The landing had install steps but no felt payoff and no concrete "how to start". Fixed both.

## What changed (`docs/index.html` + `docs/style.css`)

1. **Wow band — before → after (`§ 00b`, right after the hero).** A two-column contrast strip on the
   one moment the method pays off: a cold session days later.
   - *Without arcs*: "continue the checkout work" → "which checkout work?" → re-explain, redo, drift.
   - *With arcs*: "continue" → agent reads `.arcs/` → resumes mid-`workspace`, nothing re-explained.
   Pain on the left, relief on the right, in the same mono/editorial voice as the rest. This lands the
   payoff before the reader scrolls past.
2. **Concrete first move (§03 "start").** Added a `your first move — say this in Claude Code` block with
   the literal sentence to type ("Set up arcs here, then build me a Stripe checkout.") and the four
   `agent →` lines that follow, ending on `arcs status`. Onboarding is now one copy-pasteable sentence,
   not abstract "describe the work".

## CSS

New `.contrast` / `.contrast-grid` / `.cc` / `.scene` rules (reusing the existing `pre .k/.a/.c`
highlight classes). `figure .scene` drops the inner border. Bumped `style.css?v=7 → v8`.

## Verified (Playwright, localhost)

- Desktop 1280: band present, 2 equal columns (527px), relief tag = accent `#ffb454`, all cells
  opacity 1, doc overflow 0.
- Mobile 375: grid collapses to 1 column, scene panes wrap, doc + scene overflow 0.
- Only console error is a pre-existing `favicon.ico` 404 (no favicon in repo) — not a regression.

## Deploy

Pushed to `main` → Vercel auto-deploy (arc 15) serves `docs/`.
