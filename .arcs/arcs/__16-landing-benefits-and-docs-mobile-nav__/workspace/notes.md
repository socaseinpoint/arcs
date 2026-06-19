# Working notes — arc 16

## Fix 1 — Landing (docs/index.html)

Kept the agent-first spine (hero, §01 one-breath, §03 "install once / talk to your agent").
Wove the four concrete benefits back in:

- **(c) status-persists** → §02 "why" reason `// where did we stop?` — cold handoff, fresh
  agent/you-tomorrow reads it from files or `arcs status`, no chat-scrolling.
- **(d) candidates-surface** → §02 reason `// ideas surface, don't leak` — `arcs candidate`
  parks a mid-task idea, it bubbles onto the board until promoted. (Replaced the old
  `// work is never lost` + `// traceable` reasons; traceability folded into the agent-native one
  so §02 stays 3 tight cards.)
- **(a) init-as-benefit** → §03 step 2, payoff-first: "opt your project in — once. Run `arcs init`
  in the project directory and the work *binds to that directory* (hidden `.arcs/`, code never
  cluttered, thread lives with the repo not a chat)."
- **(b) .arcs/ tree** → new `figure` (reused existing `figure`/`pre`/`.figcap` component) showing
  `my-project/.arcs/{config,candidates/,arcs/}` with an arc, a goal (`@`), a sub-arc with
  `input/ workspace/ output/` + arc.md. Figcap: ".arcs/ — plain files, for humans and agents".
  Followed by a "legible to you and the agent" prose line.

Mined the previous landing (`git show b204104~1:docs/index.html`) for framing: §03 concept cards,
§05 tree example, §01 "where did we stop"/"you are here" copy.

Grounded on real `bin/arcs`: `arcs init`, `arcs status`, `arcs candidate`, the `@`-marks-goal +
`__…__`-marks-closed conventions, `.arcs/{config,candidates,arcs}` layout — all match the CLI.

No new CSS for the landing — reused `why`/`reason`, `figure`/`pre`/`.figcap`, `body-grid`.

## Fix 2 — Docs mobile nav (docs/docs.html + docs/style.css)

Converted `.docs-nav` aside contents into a single `<details class="docs-nav-disclosure">`:
`<summary class="docs-nav-label">on this page ▾</summary>` + the existing `<ol>` nav + back link.

- **Desktop (>880px):** `<details>` is purely structural. CSS reveals non-summary children
  regardless of the `open` attribute (`.docs-nav-disclosure > *:not(summary){display:revert}`),
  hides the marker + caret, makes the summary a non-interactive label. Sticky scroll-spy nav is
  byte-for-byte the same behavior — only the markup wrapper changed, and `app.js`'s
  `.docs-nav a[href^="#"]` selector still matches all 9 links.
- **Mobile (≤880px):** real disclosure. Closed by default = one tappable line (`on this page ▾`,
  ~47px). Open → bordered panel with the 9-item list + back link. Caret rotates 180° (respects
  `prefers-reduced-motion`). Nav is `position: sticky; top: 60px` so it follows under the header
  without the old crooked static block.

Removed the old `@media (max-width:880px){ .docs-nav{position:static; border; padding} }` block
that produced the giant block.

Bumped `style.css?v=3` → `?v=4` on both pages for cache-bust on deploy.

## Verification (Playwright, local HTTP servers)

before: port 8766 (HEAD version) · after: port 8765 (working tree)

- docs.html @375px: closed `<details>` = 47px single line, scrollWidth 360 < 375 (no overflow).
  Opened via click = full 9-item panel, contained. Screenshots in workspace/.
- docs.html @320px: closed nav 47px, scrollWidth 305 < 320 (no overflow).
- docs.html desktop (1280): nav `position:sticky`, content `display:block` w/o `open`, summary is
  label, caret hidden; scroll to #goals → scroll-spy set active link (#lifecycle at that offset).
  9 links present.
- index.html: all four benefit flags true (init-benefit, tree, status-persists, candidates);
  0 broken internal hash links; no overflow at 320px (305<320) — `pre` wraps via existing
  `white-space:pre-wrap` mobile rule.
- Only console error site-wide is a pre-existing favicon.ico 404 (no favicon in repo) — unrelated.
