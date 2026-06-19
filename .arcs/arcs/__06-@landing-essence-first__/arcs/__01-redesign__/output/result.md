# Result — essence-first landing

Rebuilt `docs/index.html` (only file changed; `style.css`/`app.js` untouched, reused
existing class vocab). CSS cache-bust bumped `?v=1` → `?v=2`.

## What changed
New section order, benefit-first:
1. **Hero** — outcome line "Your agent never loses the thread / Агент не теряет нить",
   one-breath what-it-is, honest "works without an agent too," CTA `[ start in 30s → ]`.
2. **§01 Why** — 3 payoff cards (agent starts cold · you don't get lost · scale across a fleet).
3. **§02 Start now** — copy-paste quickstart pulled high: install → `arcs init` → work.
4. **§03 How it works** — the essence (arc/goal/.arcs + encapsulation), demoted from hero.
5. **§04 With or without an agent** — honest framing + three enforcement layers (skill/hook/gate).
6. **§05 Examples** — kept real `.arcs/` tree + `arcs status` board.
7. **Closer** — CTA back to start + github.

## Honest agent framing (the nuance requested)
Lead with the agent payoff (cold cross-session/agent handoff) but qualify: arcs is a
method, valuable solo as discipline; agent + skill + hooks make it enforce itself.

## Verified
- Anchors ↔ ids consistent (#start #how #examples all resolve).
- Rendered via local http: hero (EN) + §01 payoff grid (RU) screenshot-checked — layout clean,
  RU/EN toggle works, 3-col grids intact.
- Note: full-page screenshot shows blank below fold — `.reveal` opacity:0 until the
  IntersectionObserver fires on scroll; cosmetic-of-capture only, real scroll reveals.

## Pointers
- Changed: `docs/index.html`
- Not committed (user hasn't asked).
