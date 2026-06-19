# Input gist

Full authoritative spec: `../spec.md` (this arc's input/spec.md).

Split the web presence into two surfaces:
- **Landing** (`docs/index.html`, rewrite) — value-first, SHORT, for a beginner with an agent + 30s.
- **Deep docs** (`docs/docs.html`, new, served at `/docs.html`) — full mental model.

Reuse the existing `docs/style.css` design system; extend tokens, don't fork. Static, vanilla JS,
no build step, deploys as-is on Vercel (`docs/` is site root). Ground every `arcs` command/field in
actual `bin/arcs` behavior. `en`, humanized prose. Cross-link landing ↔ docs both ways.

Sources: `SPEC.md` (method), `docs/DEPLOY.md` (install), `skill/SKILL.md` (agent workflow),
`bin/arcs` (ground truth), `examples/basic/` (worked example).
