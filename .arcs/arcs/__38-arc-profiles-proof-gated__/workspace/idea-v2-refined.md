# Idea v2 — roasted & refined

The roast collapsed v1 from "3 profiles + proof-kinds + autodetect + enforce + facets"
(8 coupled features) down to a small, honest, bench-first kernel.

## One line
Don't ship "profiles" yet. Ship ONE thing: an optional **`close-requires-proof`** rule
(reusing the existing `rules:` toggle). Make proof *mean something* by executing the check
and separating author from verifier. Label it honestly as declared-intent, not hard
enforcement. Prove it pays with a discriminating bench BEFORE building it.

## The kernel that ships
1. **`close-requires-proof` rule** — `rules:` toggle (like `subagents`), off by default.
   When on, `arcs close` refuses unless `output/proof/` non-empty + referenced in arc.md.
   No "profile" abstraction, no config-default layer, no proof-kind enum.
2. **Proof must mean something** (else theater):
   - code/visual arcs: gate **executes** verify and captures exit live; prefer an
     **independent** verifier (hook/CI/fresh subagent), author ≠ verifier.
   - decision/research arcs: proof = the reasoning artifact already produced (decision
     record / cited claims / verdict+dissent). Proof = **capture**, not test.
3. **Honest labeling** — self-administered `arcs close` is ceremony, not enforcement
   (arc 24). Real teeth only at the hook/CI layer; say so.
4. **Selection = explicit only** — declared at arc *open*. No autodetect, no enforce-floor
   in v1. profile-less = `default`, immutable, no file touching (arc 28).

## Deferred (not killed — gated on evidence)
- **"Profile" naming + heavy/light menu** — only once a 2nd real preset exists.
- **`light`** — NOT a directory profile (overhead is behavioral round-trips, profile-immune).
  A prompt-level ceremony directive, shipped only if a bench arm beats bare at equal quality.
- **autodetect / enforce-floor** — only if a bench-proven signal appears; floor must live
  where the agent can't rewrite it mid-task (hook/CI), and gate on arc birth.

## Sequencing (the roast's biggest correction)
Building the gate before the bench that justifies it = assuming the conclusion.
1. **Promote candidate 01 → discriminating bench FIRST.** Tasks with HIDDEN adversarial
   failure modes; correctness via withheld verify.sh; **pass/judge divergence = headline**;
   n≥10, variance, fresh-vs-cache tokens split. This shows whether proof-gating buys
   correctness at all, and in which regime.
2. **Heavy/proof-gate design falls out** of what the bench shows proof catches.
3. **This arc (38) closes as a design+decision verdict + slicing** — spawns narrow arcs,
   is not itself the implementation.

## Spawned arcs/candidates (proposed)
- promote `01-benchmark-where-arcs-wins` → make the bench discriminating (gates everything).
- candidate: `close-requires-proof` rule (impl) — after bench.
- candidate: independent-verifier mechanism (hook/CI re-run) — the only real teeth.
- candidate: `light` behavioral directive — only if bench finds the niche.
