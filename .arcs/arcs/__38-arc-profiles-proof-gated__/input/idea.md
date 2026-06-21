# Idea — arc profiles (proof-gated heavy / fast light)

## Seed (user)
Arcs core/skeleton stays fixed (what the dashboard scanner reads); add flexibility
*inside* an arc via a **profile**. Heavy profile enforces verification for complex
/critical work; light profile cuts ceremony so big tasks go faster. Base shared so
the dashboard keeps working across all projects.

## Constraint from prior turn — the seam
- **Wire format = frozen** (dashboard scans it): `NN-slug` dirs, `__…__`=closed,
  `NN-@slug`=goal, config location, input/workspace/output skeleton.
- **Flexibility lives ABOVE wire format**, never inside it. Profiles = config-gated
  policy presets, not new on-disk shapes. The dashboard is the forcing function:
  what the scanner reads is frozen; everything else is free.

## Quiz answers (this turn)
1. **What is "verify"** → a **proof stage**. The arc ends up *holding a proof* —
   objective evidence (screenshot-like) of what/why was done. Heavy can't close
   without the proof artifact recorded. (Evidence-in-arc, richer than a pass/fail gate.)
2. **Who picks the profile** → layered, mirroring the existing `rules: subagents`
   toggle: project default + autodetector + explicit per-arc override. Default →
   autodetector decides; enforce set → forced; user can also name the profile per arc.
3. **What the profile controls** → undecided by user; decide in design + roast.
4. **Light = speed?** → maybe current arcs IS the lightest already. Must figure out
   what can be cut for light — and **everything must be proven by benchmarks**. Not assumed.

## Method for this arc
brainstorm (done: quiz) → synthesize idea draft → adversarial roast by ~dozen
subagents → synthesize roasted idea → present design → spec. Stages, in this arc.
