# Result — landing benefits restored + docs mobile nav fixed

Two web-polish fixes. Static, vanilla, reusing the existing design system. No git commit.

## Files touched

- `docs/index.html` — landing: wove the four concrete benefits back in (agent-first framing kept).
- `docs/docs.html` — docs: section-nav wrapped in a `<details>` disclosure.
- `docs/style.css` — desktop label / mobile disclosure rules for `.docs-nav`.
- Cache-bust: `style.css?v=3` → `?v=4` in both HTML files.

## Fix 1 — Landing (`docs/index.html`)

The agent-first rewrite was correct but had lost the tangible payoffs. Restored, tight:

- **(a) `arcs init` as a benefit** — §03 step 2, payoff-led: opt the project in *once*; from then on
  the work **binds to that directory** (hidden `.arcs/`, code never cluttered, the thread lives with
  the repo not a chat). "One command you remember; everything after is the agent's job."
- **(b) the `.arcs/` file tree** — a new `figure` (reused `figure`/`pre`/`.figcap`) showing
  `.arcs/{config, candidates/, arcs/}` with an arc, a goal (`@`), and a sub-arc carrying
  `input/ workspace/ output/` + `arc.md`. Figcap: ".arcs/ — plain files, for humans and agents",
  with a follow-on line on legibility to both you and the agent.
- **(c) status persists across sessions** — §02 reason `// where did we stop?`: a fresh agent or
  you-tomorrow reads it from the files or one `arcs status`; a cold handoff that just resumes.
- **(d) candidates surface** — §02 reason `// ideas surface, don't leak`: `arcs candidate` parks a
  mid-task idea and it bubbles onto the board until promoted; future work doesn't evaporate.

§02 stays three tight cards (the old standalone "traceable" point folded into the agent-native
card). No new landing CSS — all reused components. Every `arcs` command/field shown matches
`bin/arcs` (`init`, `status`, `candidate`, the `@`/`__…__` conventions, the `.arcs/` layout).

## Fix 2 — Docs mobile nav (`docs/docs.html` + `docs/style.css`)

Chosen solution: a collapsed **`<details>` "on this page ▾"**, closed by default on mobile.

- The `.docs-nav` aside's contents now live in `<details class="docs-nav-disclosure">` with a
  `<summary>` label; the existing `<ol>` nav and back-link are unchanged inside it.
- **Desktop (>880px):** the `<details>` is purely structural — CSS reveals its children regardless
  of the `open` attribute, hides the marker/caret, and renders the summary as a plain label. The
  sticky scroll-spy nav behaves exactly as before (only the wrapper markup changed; `app.js`'s
  `.docs-nav a[href^="#"]` selector still matches all 9 links).
- **Mobile (≤880px):** a real disclosure — a single ~47px tappable line until opened, then a clean
  bordered panel with all 9 items + the back link. The nav is `position: sticky; top: 60px` (no more
  crooked static block); the caret rotates 180° on open and respects `prefers-reduced-motion`.
- Removed the old `@media (max-width:880px)` rule that turned the nav into the giant static block.

## Verification (real browser — Playwright over local HTTP servers)

Before = repo HEAD (port 8766), after = working tree (port 8765).

- **docs.html @375px:** closed nav = 47px single line, `scrollWidth 360 < 375` (no overflow); opened
  via click = contained 9-item panel. Before/after screenshots saved to `workspace/`.
- **docs.html @320px:** closed nav 47px, `scrollWidth 305 < 320` (no overflow).
- **docs.html desktop (1280px):** nav `position: sticky`, content `display: block` without the
  `open` attribute, summary is a label, caret hidden; scrolling to a section moves the scroll-spy
  `active` link. Scroll-spy intact.
- **index.html:** all four benefit elements present (asserted in DOM text); 0 broken internal hash
  links; no overflow at 320px (`pre` wraps via the existing mobile `white-space: pre-wrap` rule).
- Only site-wide console error is a pre-existing `favicon.ico` 404 — unrelated to these changes.

### Screenshots in `workspace/`
- `docs-mobile-375-before.png` — the broken big-block nav (before).
- `docs-mobile-375-after-closed.png` / `-after-open.png` — collapsed line / opened panel.
- `docs-mobile-320-after-closed.png` — 320px collapsed.
- `landing-start-section.png`, `landing-tree.png`, `landing-desktop-full.png` — restored benefits.
