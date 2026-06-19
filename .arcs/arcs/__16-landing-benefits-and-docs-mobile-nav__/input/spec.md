# Spec — restore landing benefits + fix docs mobile nav

Two web-polish fixes from user feedback on the live site.

## Fix 1 — LANDING (`docs/index.html`): the agent-first rewrite stripped too much benefit
The current landing is correct (agent-first) but lost the CONCRETE, tangible payoffs the previous
version had. The user misses these specifically — weave them back IN (keep agent-first framing, stay
reasonably short, don't revert to the old long page):

a. **`arcs init` in the project directory, framed as a BENEFIT — not a dry step.** The one thing the
   user has to remember: `arcs init` opts a project in; the work binds to THAT directory (a hidden
   `.arcs/` at its root, code never cluttered). The flow is setup → `init` → work, but lead with the
   payoff: "your project opts in once; from then on the work lives with the repo, not in a chat."

b. **Show the `.arcs/` structure visually** (a small file tree) — this was a highlight: it makes
   concrete that the work is plain files, legible to BOTH humans and agents. A compact tree, e.g.
   `.arcs/` → `arcs/` → `NN-@goal/` with `input/ workspace/ output/` + `arc.md`. Mine the previous
   version for the exact framing/copy: `git show b204104~1:docs/index.html` (its §03 concept cards +
   §05 ".arcs/ tree" example). Re-author tastefully; don't paste the whole old page.

c. **Status persists across sessions — the headline agent benefit.** A fresh session/agent (or you,
   tomorrow) can ask "where did we stop?" and get a clear answer straight from the files / `arcs status`
   board — no scrolling back through chat. Cold handoff between sessions and agents. (Old copy: "the
   agent starts cold → output/ is self-contained"; "you don't get lost".)

d. **Candidates surface instead of leaking away.** An idea that pops up mid-task isn't lost in the
   chat — `arcs candidate` parks it and it BUBBLES UP onto the board (`arcs status`) until promoted.
   Future work surfaces; it doesn't evaporate.

- "For humans and agents" should come through (the files are legible to people; the agent keeps them).
- Keep the agent-first start section from the current page; enrich the WHY/benefits around it. Reuse
  the existing components/classes (`why`/`reason`, `concept`, `pre` tree, etc. — they already exist in
  style.css from the old page, check before adding new CSS).

## Fix 2 — DOCS mobile nav (`docs/docs.html` + `docs/style.css`): the sticky section-nav looks broken
On mobile the section nav (`.docs-nav`, 9 items) becomes a big static block above the content at
`≤880px` (`style.css:192-194`) — the user sees a large crooked block stuck near the top. Fix it to be
clean on phones:
- Make it COMPACT on mobile. Preferred: a collapsed `<details>`-style "On this page ▾" that's closed by
  default (so it's a single line until tapped), OR a slim sticky horizontal chip strip, OR hide it
  entirely on small screens (sections are short). Pick the cleanest; closed `<details>` is the safe choice.
- Whatever you pick must look intentional at **375px** (and check 320px): no overflow, not a giant
  9-line block shoving content down, no half-sticky overlap.
- Keep the desktop sticky scroll-spy nav exactly as is (only the mobile breakpoint changes).

## Constraints
- Static, vanilla JS, reuse + extend the existing design system; intentional, not template.
- Ground any `arcs` command/field on the landing in real `bin/arcs` behavior.
- `en`, humanized. Semantic HTML, keyboard-nav, `prefers-reduced-motion` respected. Do NOT git commit.

## Verify (MUST, with a browser at real widths)
- Serve `docs/` locally; open the landing — the four benefit elements (init-as-benefit, the `.arcs/`
  tree, status-persists/"where did we stop", candidates-surface) are present and read well; page still
  feels tight, not bloated.
- Open `docs.html` at 375px AND 320px — the section nav is compact and clean, no crooked block, no
  overflow. At desktop width the sticky scroll-spy nav still works.
- All internal links still resolve. Save before/after mobile screenshots of docs.html into workspace/.

Write notes → workspace/, output/result.md (what changed per surface + files). Fill arc.md `goal:` +
output pointers (leave status active; orchestrator closes + the push auto-deploys).
