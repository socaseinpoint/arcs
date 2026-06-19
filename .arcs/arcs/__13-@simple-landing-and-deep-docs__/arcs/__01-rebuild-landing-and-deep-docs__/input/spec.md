# Spec — simple landing + separate deep docs

Split the web presence into two surfaces, mirroring onorca.dev's onboarding pattern:
**landing pulls you in with value; a separate deep-docs page holds the depth.**

## Reference pattern (onorca.dev, studied)
Value/outcome-first hero → why it works → remove friction → defer install + spec to SEPARATE pages
(`/docs`, `/changelog`). The landing assumes the visitor grasps the VALUE before reaching docs.
Tone: confident, engineer-to-engineer, concrete (real command names, no hype).

## Audience split (the whole point)
- **Landing** = a beginner who has an agent (Claude Code / Codex / etc.) and 30 seconds. They should
  leave knowing WHAT arcs gives them, WHY it matters, and the ONE command to start — nothing more.
- **Deep docs** = someone who already wants in and needs the full mental model: what / where / how / why.

## Surface 1 — LANDING (`docs/index.html`, rewrite; reuse `docs/style.css` + `docs/app.js` design system)
Keep the existing essence-first aesthetic (the reveal hero, the type scale, the tokens) — do NOT
ship a generic template. Trim the current spec-heavy sections OFF the landing (they move to docs).
Sections, top to bottom:
1. **Hero** — value outcome in one line. The core promise: your agent's work stops vanishing in the
   chat scroll — it becomes structured files you and the agent can both trust and resume. Headline +
   one-sentence subhead + primary CTA ("Get started" → scrolls to the 20-sec start) + GitHub link +
   a "Docs" link (to surface 2).
3. **What it is, in one breath** — arcs is a tiny file method: every task is an `input → workspace →
   output` folder under a hidden `.arcs/`. The agent runs it; you read results. One short paragraph.
4. **Why it matters** — 3 value props, each one line:
   (a) work never lost — it lives in files, not chat;
   (b) traceable — goals are immutable and form chains, so you see how the thinking evolved;
   (c) agent-native — the agent structures and parallelizes the work itself (the `subagents` rule).
5. **20-second start** — the minimal path: `git clone https://github.com/socaseinpoint/arcs ~/arcs &&
   cd ~/arcs && ./install.sh`, then in your project just tell your agent to start — it runs `arcs init`
   and opens the first arc. Keep it to the ONE happy path; full install variants live in docs.
6. **Honest framing** — works with or without an agent (keep the existing honest line).
7. **Footer CTA** — Docs · GitHub · Changelog links.
Keep it short. If a block is reference-grade detail, it belongs in docs, not here.

## Surface 2 — DEEP DOCS (new `docs/docs.html`, served at `/docs.html`; reuse style.css, add a docs layout)
A real documentation page: left/top section nav + anchored sections, what/where/how/why throughout.
Source content = `SPEC.md` (the canonical method), `docs/DEPLOY.md` (install), `skill/SKILL.md`
(agent workflow). Re-author for the web; do NOT just paste markdown. Sections:
1. **What & why** — the problem (chat loses work; no source of truth) → the model (files are the record).
2. **Concepts** — the single numbered STREAM; arc (work, no purpose) vs goal (`@`, a purpose with a
   sub-stream); `input → workspace → output` + encapsulation (outside reads only `output/`).
3. **Lifecycle** — open before working → notes flow into workspace → write output → `arcs close`
   (wraps `NN-slug` → `__NN-slug__`, refuses empty output); reopen.
4. **Goals v2** — immutable contract; `## Checklist` with COMPUTED done-state (sub-arc `closes: <key>`,
   `arcs status` renders `N/M ✓`); supersession chains (`arcs supersede <old> <new>`, `supersedes:` /
   `prev:` alias). This is the newest, most important concept — give it room.
5. **Rules layer** — global rule bodies + `rules=` toggle in `.arcs/config`; the `subagents` rule.
6. **Candidates** — surfaced future work in `.arcs/candidates/`; `arcs candidate` / `promote`.
7. **Command reference** — full table of every `arcs` subcommand (read them from `bin/arcs` dispatch).
8. **Install** — the full set from DEPLOY.md (one-command + manual).
9. **Worked example** — a short end-to-end: init → open a goal with a checklist → a sub-arc closes an
   item → status shows `1/N ✓`. Pull from `examples/`.
Cross-link both ways: landing ↔ docs (and both link GitHub + Changelog).

## Constraints
- Static, deploys as-is on Vercel (the `docs/` dir is the site root; `docs/docs.html` → `/docs.html`).
  Keep JS minimal/vanilla (extend `app.js` only if needed). No build step, no framework.
- Honor the user's design-quality bar: intentional hierarchy, real hover/focus states, not a default
  template. Match the existing palette/type in `style.css`; extend tokens, don't fork the look.
- Accessibility: semantic HTML, headings in order, keyboard-navigable nav, reduced-motion respected.
- Ground every command/field claim in the actual `bin/arcs` behavior — verify before writing.
- `en` prose, humanized (no marketing-press tone). Do NOT git commit (orchestrator handles release).

## Verify before done
- Open both pages logically (check links resolve: index ↔ docs.html, GitHub, Changelog).
- Every `arcs` command/field on either page matches `bin/arcs`.
- Landing is genuinely SHORT (a beginner can read it in under a minute); depth is in docs.

Write notes → workspace/, output/result.md (what each surface contains + files touched + any follow-up).
Fill arc.md `goal:` + `closes: rebuild-landing-and-deep-docs` + output pointers (leave status active).
