# Plan — essence-first landing

## Diagnosis of current page
- Hero leads with concept ("Work lives in files, not in chat") — true but abstract,
  no payoff, no "why care."
- Agent benefit buried in §03 "tooling" + §03.1 enforcement, framed as optional add-on.
- No start-now block until §03 (~middle of a long dense page).
- Reads like a spec, not a pitch. Heavy prose blocks.

## New section order (top → bottom)
1. **Hero** — outcome line + one-breath what-it-is + start-now CTA + github.
   - Outcome candidate (EN): "Your agent never loses the thread."
   - Sub: "arcs keeps work in files, not in a dead chat — so any agent (or you) picks
     up exactly where the last one stopped. A file-based work method."
   - Two CTAs: [ start in 30s → ] (scrolls to quickstart) · [ github ↗ ]
2. **Why care / payoff strip** — 3 outcome cards, agent-forward:
   - agent resumes cold — output/ is the handoff, no chat history needed
   - you never get lost — surface to goal.md, see where you are
   - fan work across agents/sessions — folder is the contract
3. **Quickstart (start now)** — copy-paste: clone+install, `arcs init`, first goal/arc,
   `arcs status`. Highest-value block, kept high.
4. **How it works (the essence)** — arc / goal / .arcs/ — demoted spec, the concept.
5. **Works with or without an agent** — honest framing: method stands alone; agent +
   skill + hooks make it enforce itself. (folds old §03/§03.1 enforcement layers)
6. **Examples** — keep the real `.arcs/` tree + `arcs status` board (concrete proof).
7. **Closer + final CTA** — github / back to top.

## Honest agent framing (the nuance the user flagged)
- NOT "arcs is an agent tool." arcs = a method; files are the substrate.
- The agent is where the payoff is *largest* (cross-session/agent handoff), but the
  method is valuable solo too. Lead with agent benefit, qualify with "even solo."

## Build steps
- [ ] Rewrite hero in index.html (both langs)
- [ ] Add payoff strip section
- [ ] Move quickstart up, trim to the essential commands
- [ ] Demote essence + enforcement into "how it works" / "with or without agent"
- [ ] Keep examples + closer
- [ ] CSS: add styles for payoff cards / quickstart emphasis if needed
- [ ] Verify: open docs/index.html, check both lang toggles, no broken anchors
