# Roast synthesis — 12 adversarial lenses on idea-v1

Every claim below was grounded by a subagent in a real file:line. Convergence was high.

## What SURVIVED (kernel everyone agreed is sound)
- **The seam holds.** `profile:` is additive frontmatter; `scan.sh` greps only requested
  keys (goal/theme/release), numbering parses dirname, supersede matches `^(supersedes|prev):`.
  Unknown fields ignored → wire format genuinely safe, dashboard intact. NOT fatal anywhere.
- **close-requires-PROOF** (extending arc 04's close-requires-output) is a real improvement —
  *conditional on proof meaning something* (below).

## What the roast KILLED (multi-agent consensus)

### 1. Drop "profiles" as a shipped abstraction (agents 2,6,12)
Two of three profiles are empty: `light` undecided, `default` = today. "Profile" is a wrapper
over ONE real feature (the gate) + speculative config. Ship the gate, not the system.
→ **Reuse existing `rules:` machinery** (`rule_is_on`) — a `close-requires-proof` toggle,
off by default. No profile frontmatter, no config-default layer, until a 2nd preset exists.

### 2. Cut the proof-kind plugin list (agents 2,6)
shell/test/visual/review/manual = framework slide on a 655-line bash tool with no plugin
substrate. → Gate checks ONE invariant: `output/proof/` non-empty + referenced from arc.md.
*How* proof got there is the user's business. No enum, no adapters.

### 3. Cut autodetect — FATAL to that part (agents 4,7,8)
No reliable on-disk signal (`@` marks goal-structure, not criticality). Non-interactive agent
runs have no surface for a "suggestion" → drifts to silent (the magic the user feared).
Wrong-guess is asymmetric: heavy-on-throwaway = unclosable; light-on-critical = false confidence.
→ Explicit only. Add `auto` only if a bench-proven signal ever appears.

### 4. Proof-as-presence is theater + gameable (agents 3,9) — FATAL to the *claim*
- Same agent writes work AND proof → self-certifies. `echo > proof.log`, blank screenshot,
  `verify.sh=exit 0`. Gate confirms a file exists, not that work is correct.
- `arcs close` is voluntary + honors `-f` (bin/arcs:480-481). Arc 24 already concluded only the
  harness hook has teeth — and not even for Bash redirects. A self-administered gate is *more*
  bypassable. → Two fixes: **(a) gate EXECUTES the check live** (run verify.sh, capture exit
  itself — don't read a recorded log); **(b) independent verifier** (hook/CI/fresh subagent),
  author ≠ verifier. Ship honestly labeled as *declared-intent ceremony*, not hard enforcement.

### 5. Bench can't currently prove anything — FATAL to "bench will prove it" (agent 5)
Suite saturated (pass=100%, judge≈5 both arms) → zero headroom. Single LLM judge can't see
plausible-but-wrong. n=3, cache-read inflates the 3× token gap (cheap, not compute).
→ **Discriminating property: every task needs a HIDDEN adversarial failure mode**, correctness
graded by withheld verify.sh cases; report **pass/judge divergence** as the headline. n≥10,
report variance, separate fresh vs cache tokens.

### 6. Light is vacuous as a directory profile — FATAL to light-as-layout (agent 11)
The 3× overhead is **behavioral** (round-trips: agent reading docs + i/w/o tool calls), not
layout. A CLI profile can't delete turns the agent chooses. "default minus a directory" trims
structure the agent barely reads, leaves turn-count untouched, collapses toward `bare` (which
already wins at equal quality). → Light = a *prompt-level behavioral directive*, not a dir
shape; ships only if a bench arm lands strictly between bare and default on the cost/quality
frontier. Defer.

### 7. Proof only half-applies (agent 10)
Proof kinds are code/visual-shaped, but ~half this repo's arcs are design/decision/research
(12,23,27,28,33…). "Objective proof" forces fake artifacts there. → **Two meanings, one slot:**
code/visual arcs prove by *passing* (executed verify); decision/research arcs prove by *recording*
the reasoning the arc already produces (decision record, cited claims, verdict+dissent).
Proof = capture, not test, for non-code. Scope heavy's *correctness* claim to code/visual only.

### 8. Scope: too much for one arc — FATAL to idea-as-one-arc (agent 12)
8 coupled deliverables, half gated on an unrun bench, core abstraction justified by features
that don't exist. → This arc closes as a **design/decision verdict + slicing**, spawns narrow
arcs. NOT the implementation.

## Back-compat rules it must obey (agents 1,9,10,12 + arc 28)
- profile-less arc = **immutably `default`**; never stamp existing files (arc 28 no-touch).
- any `enforce` floor gates on arc **birth**, not close-time — else 37 open arcs get jailed.
- proof-kind declared at arc **open**, not close — so close can't surprise mid-flow.
- dashboard: `scan.sh` walks output first, caps at 24 files (scan.sh:205) — a noisy `proof/`
  could push real results out of the drawer → write one `output/proof/MANIFEST.md`. Treat
  "no profile" as first-class `default` facet, not null/error.
- proof gate is **net-new close logic** — `output/proof/` trivially satisfies the old
  non-empty guard (bin/arcs:480), so it can't be a tightening of it.
