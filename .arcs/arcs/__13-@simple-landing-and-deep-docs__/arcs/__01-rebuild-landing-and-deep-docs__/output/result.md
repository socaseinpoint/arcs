# Result — rebuilt landing + deep docs

Two static surfaces, deploying as-is from `docs/` (the Vercel site root). No build step, no
framework, vanilla JS. Design system reused and extended from the existing `style.css` (essence-first
dark aesthetic, reveal hero, type scale, tokens). Both pages are English-only (the old RU/EN toggle
was dropped to honor the `en` constraint and keep things lean).

## Landing — `docs/index.html` (rewritten, 7.7K)
Short, value-first, reads in well under a minute. Top to bottom:
- **Hero (§00)** — promise: "Your agent's work stops vanishing in the chat" + one-sentence subhead
  (input → workspace → output under `.arcs/`, trust + resume). CTAs: `get started →` (scrolls to #start),
  `read the docs` (→ docs.html), `github ↗`.
- **§01 What it is, in one breath** — one paragraph: tiny file method, agent runs it, you read results.
- **§02 Why it matters** — 3 one-line value props: work never lost · traceable (immutable goal chains)
  · agent-native (subagents rule).
- **§03 A 20-second start** — the ONE happy path: `git clone … ~/arcs && cd ~/arcs && ./install.sh`,
  then `arcs init` / `arcs status`. Full install variants deferred to docs (#install link).
- **§04 Works with an agent — or without** — the honest framing (discipline solo; self-enforcing with
  skill+hook+gate).
- **Closer** + footer CTAs: Docs · GitHub · Changelog.

## Deep docs — `docs/docs.html` (new, 26.9K, served at `/docs.html`)
Real documentation layout: sticky left section-nav (numbered ToC with scroll-spy active state) +
anchored sections, what/where/how/why throughout. Sections:
1. **What & why** — chat loses work → files are the record; encapsulation callout.
2. **Concepts** — single numbered stream; `.arcs/` tree; arc vs goal; input→workspace→output table
   (OOP analogy); descriptive slugs.
3. **Lifecycle** — open→work→output→close (`__…__` + status done, refuses empty output/, `-f`); reopen.
4. **Goals v2** (most room) — immutable contract; supersession chains (`arcs supersede`, `supersedes:`/
   `prev:` alias, seeds `input/from-<old>.md`); computed `## Checklist` (key resolution: `{#key}` →
   leading slug-token → slugify; `closes:` → `N/M ✓` + `✓ key → arc` / `○ key`).
5. **Rules layer** — global bodies in `<repo>/rules/`, `rules=` switch in `.arcs/config`, local override;
   `subagents` built-in (arc boundary = subagent boundary).
6. **Candidates** — `.arcs/candidates/NN-<slug>.md` (own numbering, `from:`), `arcs candidate` / `promote`.
7. **Command reference** — full table of every subcommand straight from `bin/arcs` dispatch.
8. **Install** — quick (one-command) + manual + enforcement layers (skill / arcs-hook / arcs-gate) +
   project usage + updating + requirements/.gitignore (from DEPLOY.md).
9. **Worked example** — `examples/basic`: tree + `arcs status` board showing `1/3 ✓`, with the end-to-end
   command sequence.

## Shared assets
- `docs/style.css` — extended with a `DOCS PAGE` block (docs-shell grid, sticky scroll-spy nav, callouts,
  def-grid, tables, ordered lists, focus-visible rings). Removed now-dead i18n CSS (`html[data-lang]`,
  `.lang` button styles).
- `docs/app.js` — rewritten: dropped i18n; kept reveal-on-scroll (reduced-motion guarded); added docs
  scroll-spy (IntersectionObserver, no-op when the nav is absent).

## Files touched
- `docs/index.html` (rewrite)
- `docs/docs.html` (new)
- `docs/style.css` (extend + prune)
- `docs/app.js` (rewrite)

## Verification
- **Links:** every internal anchor in docs.html resolves to a real section id (9/9); landing `#start`
  exists; landing ↔ docs cross-link both ways; GitHub → `https://github.com/socaseinpoint/arcs`;
  Changelog → `https://github.com/socaseinpoint/arcs/commits/main` (no CHANGELOG file/page exists in the
  repo — commit history is the de-facto changelog).
- **Command/field accuracy:** every `arcs` command and field name was cross-checked against `bin/arcs`
  (dispatch lines 559-575) and the template/parser functions — command names, `-g`/`-f` flags, the
  empty-`output/` close guard, `closes:`/`supersedes:`/`prev:`/`from:` fields, checklist key resolution,
  and the `N/M ✓` badge all match actual behavior.
- **Rendered (Playwright, served over HTTP):** both pages load 200 (index, docs, style.css, app.js);
  reveal fires on scroll (13/13 on landing); scroll-spy updates the active nav item; no horizontal
  overflow at 375px; docs nav collapses to a single-column card on mobile; one `<h1>` per page, headings
  in order; balanced section/figure/table tags. Only console error is a missing favicon (cosmetic).
  Screenshots in `workspace/` (landing-full, docs-full, docs-mobile).

## Follow-up (optional, out of scope)
- No favicon is served (404). Add `docs/favicon.ico` or a `<link rel="icon">` if desired.
- A dedicated changelog page could replace the GitHub-commits link later.
- Consider a `og:image` / social card for sharing.
