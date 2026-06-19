# Result — simple landing + deep docs + 0.2.0 release

Split the web presence into two surfaces (onorca.dev pattern) and shipped 0.2.0.

## What landed
- **Landing** (`docs/index.html`, rewritten) — short value-first onboarding for a newcomer with an
  agent: the promise (agent work stops vanishing in chat → trustworthy resumable files), one-breath
  "what it is", three value props, one 20-second start, honest "with/without an agent" line, footer.
- **Deep docs** (`docs/docs.html`, new, `/docs.html`) — full what/where/how/why with section nav +
  scroll-spy: concepts, lifecycle, goals v2, rules, candidates, full command reference, install,
  worked example. Landing ↔ docs cross-linked. Shared design system (`style.css`/`app.js` extended).
- **Release 0.2.0** — CHANGELOG cut + footer links; tags `v0.1.0` (retroactive) + `v0.2.0`; pushed.

## Pointers
- Web build: `arcs/__01-rebuild-landing-and-deep-docs__/output/result.md` (Playwright-verified).
- Release: `arcs/__02-cut-release-0.2.0__/output/result.md`.
- Vercel auto-deploys `docs/` on push (arcs-delta.vercel.app + `/docs.html`).

## Dogfood finding (captured, not fixed here)
Checklist keys with dots (`0.2.0`) don't round-trip against `closes:` — captured as candidate
`checklist-key-dots-break-matching`. Worked around by using a dot-free key (`cut-release`).
