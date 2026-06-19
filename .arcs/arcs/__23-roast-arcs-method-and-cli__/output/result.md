# result — roast of arcs (method + CLI + docs)

Multi-agent roast: 12 lenses → adversarial verify per finding → synthesis. 97 subagents,
74 findings survived a skeptical verify pass. Full report: `roast-report.md` (this dir).

## Headline (the two that undercut the project)
1. **CRITICAL — the gate is silently dead in this very repo.** `hooks/arcs-gate:37`
   `grep -rqsE '^status: active' "$dir/.arcs"` recurses the whole tree, so stale
   `status: active` strings inside *closed* arcs' workspace/output hold the gate open
   forever. The project's one hard-enforcement mechanism currently does nothing here.
   Fix the *reader*: glob only open `*/arc.md` + `*/*-goal.md`, skip `__*__`.
2. **HIGH — the headline checklist feature (`closes:` → N/M) can't fire from the SKILL.**
   Nothing tells the agent to write checklist items or `closes:`; it ships only as a
   commented template line. An agent following only the SKILL leaves goals at `0/M`.
   (We hit exactly this dogfooding 0.2.0 — arc 21.)

## Other confirmed clusters
- Input handling: slugs never slugified (#10) → spaces/`/` break globs; supersede's raw
  sed corrupts arc.md on `&`/`|` (#6); `$2` unbound under `set -u` on missing `-g` operand.
- Goal lifecycle: supersede downgrades a goal to a plain arc (#5); `-g` ops break once a
  goal is closed (#8); bare-slug close/reopen ambiguous arc-vs-goal (#9).
- Numbering caps at 99 (2-digit-only globs, latent #7).
- Update subsystem: breaking floor reads branch HEAD not the tag; offline run stamps the
  24h throttle anyway; hardcoded `origin/main`; `arcs update` swallows install failures.
- Docs/landing: `arcs close stripe` example missing `-g` (#12); whole page `opacity:0`
  until JS, no `<noscript>` (#13); command table claims completeness but omits
  `version`/`check-update`; CSS cachebuster drift v7 vs v8.
- Release: no RELEASING.md / consistency gate (VERSION == CHANGELOG-top == tag).

## Next arcs surfaced (captured as candidates)
1. `@gate-enforcement-is-real` (goal) — fix gate grep + gate Bash/NotebookEdit + truth in docs
2. `@goal-checklist-actually-fires` (goal) — wire `closes:` end-to-end (SKILL + flag + validate)
3. `harden-slug-and-arg-handling` (arc) — slugify on creation, escape sed, `${2:-}` guards
4. `fix-goal-lifecycle-ops` (arc) — supersede preserves goals, closed-goal `-g`, bare-slug
5. `release-culture-and-checks` (arc) — RELEASING.md + release-check (VERSION/CHANGELOG/tag)

## Pointers
- Input: `input/ask.md`. Plan/scope notes: none beyond input (workflow-driven).
- The 0.3.1 dotted-keys fix (arc 21) is one instance of the silent-drift class this roast
  catalogs (#4 closes-typo no-op).
