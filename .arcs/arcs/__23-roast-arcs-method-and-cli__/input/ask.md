# ask — roast the arcs project

User: "прожарим арку … дюжиной сабагентов, пусть найдут разные проблемы и что можно улучшить."

Roast the whole arcs project (method + CLI + docs + hooks + onboarding). A dozen subagents,
each a different lens, find real problems + improvements. Verify findings adversarially (drop
plausible-but-wrong ones). Synthesize a prioritized report: what to fix, what to improve, what
to leave.

## Surface (repo root /Users/socaseinpoint/Documents/projects/arcs)
- bin/arcs (640L) — the CLI (bash 3.2 / macOS)
- SPEC.md (250L) — the method spec
- skill/SKILL.md (108L) — agent-facing instructions
- rules/subagents.md (23L) — the one shipped rule
- hooks/arcs-gate, hooks/arcs-hook — enforcement
- install.sh (85L), VERSION, MIN_VERSION — install + version-aware update
- docs/index.html (landing), docs/docs.html + app.js + style.css (deep docs), docs/DEPLOY.md
- README.md, examples/basic, template/ — onboarding
- CHANGELOG.md — release log

## Out of scope
Closed arcs' internal content. The `.playwright-mcp/` scratch dir (just flag if it's committed).
