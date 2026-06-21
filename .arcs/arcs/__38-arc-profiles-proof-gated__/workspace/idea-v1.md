# Idea v1 — proof-gated arc profiles

## One line
An arc carries a **profile** (policy preset above the frozen wire format). `heavy`
refuses to close without a recorded **proof** of done; `light` cuts ceremony for
speed. Selection is layered (config default + autodetect + per-arc override), exactly
like the `rules:` toggle. The dashboard keeps scanning every project because the
wire format never changes.

## The seam (non-negotiable)
- **Frozen (scanner reads it):** `NN-slug` dirs, `__…__`=closed, `NN-@slug`=goal,
  `.arcs/config` location, `input/workspace/output` skeleton.
- **Free (profiles live here):** how much ceremony, what close demands, doc/rules weight.
- `profile:` is *additive frontmatter* in arc.md; proof lives in `output/`. Scanner
  ignores unknown fields → dashboard-safe. Profile/proof can later become dashboard
  *facets* (filter, badge). Additive, never breaking.

## The three profiles (small menu, not config soup)
- **light** — minimal ceremony, fast. For big/exploratory work where speed matters.
  *What exactly is cut is UNDECIDED — must be bench-discovered, not assumed.*
- **default** — today's arc: input/workspace/output + close-requires-non-empty-output.
- **heavy** — default + **proof gate**: `arcs close` refuses unless a proof artifact
  is recorded in the arc. Proof = objective evidence of what/why done.

## Heavy = "close-requires-PROOF" (extends arc 04's close-requires-output)
Pluggable proof kinds, gate only checks "a declared proof exists + is referenced":
- shell: `verify.sh` exits 0, log saved to `output/proof/`
- test: test cmd passes, output captured
- visual: screenshot/file in `output/proof/`
- review: subagent verdict(s) recorded
- manual: human confirmation token

## Selection (layered, mirrors `rules: subagents`)
- `.arcs/config` → project default profile.
- `auto` → autodetector *suggests* (e.g. `@goal`/critical-signal → heavy). Suggestive,
  not silent-magic (user feared magic).
- `--profile heavy` at `new-arc` → writes `profile: heavy` into arc.md (explicit override).
- `enforce` → config forces a floor project-wide (no downgrade).

## How it subsumes open threads
- **Speed** → `light` profile (bench-gated; ships only if an arm dominates).
- **Flexibility vs shared-structure** → profiles are policy ABOVE frozen wire format.
- **Dashboard** → profile+proof are additive facets; nothing breaks.
- **Candidate 01 (where-arcs-wins)** → `heavy` is the hypothesized winning arm —
  it should win where bare/light produce plausible-but-wrong output (pass/judge diverge).

## Ship order (proposed)
1. `heavy` profile + proof gate (designable now, clear value).
2. `light` profile — only after bench finds + proves what's cuttable.
Everything (light AND heavy's cost/benefit) validated by the bench. Nothing assumed.
