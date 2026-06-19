# Ask

Rebuild the arcs landing (`docs/index.html` + `style.css` + `app.js`) so it is
**essence-first**: a visitor lands and immediately gets the point — the benefit and
how to start now. Everything else is opt-in / read-on-demand.

## User intent (verbatim, paraphrased)
- Enter → get the gist instantly. Rest is optional.
- Lead with the **payoff** and **how fast you can start** + what you need to know.
- The **main** payoff is working *through an agent* — right now that reads as merely
  "optional" in §03. Promote it. But stay honest: arcs works as a plain methodology
  even without an agent — get the framing right.
- Reference: https://www.onorca.dev/ — how they convey the essence and pull you to use fast.

## Reference takeaways (onorca.dev)
- Hero = ONE bold outcome line ("Ship 100x With The Agent IDE"), not a concept.
- Subline = concrete one-breath "what it is."
- CTA (get-started/download) lives *in the hero*, repeated at the bottom.
- Order: hero → social proof → feature scroll → comparison → FAQ → final CTA.
- Benefit-first, concept-later. Copy is outcome language, not architecture language.

## Constraints
- Keep RU/EN toggle (current default page lang = ru). Project arc lang = en.
- Static site, no build step (plain html/css/js), Vercel-deployed (`docs/`).
- Keep brand: mono/Space Grotesk, `.arcs` wordmark, section-number editorial style.
- Don't drop the real spec content — demote it to a "how it works" deep section, not delete.
