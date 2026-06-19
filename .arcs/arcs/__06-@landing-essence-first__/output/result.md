# Result — essence-first landing (goal)

Landing rebuilt essence-first and shipped to production.

- Live: https://arcs-delta.vercel.app
- Source: `docs/index.html` (+ style.css/app.js reused unchanged).
- Hero leads with the payoff ("your agent never loses the thread"), honest with/without-agent
  framing, quickstart pulled high, the method spec demoted to "how it works".
- Kept current through the later model changes: single-stream tree + STREAM board figures,
  `@`-goal marker, `arcs close`, global-rules/config-toggle copy.

## Arcs of this goal
- __01-redesign__ [done] — the initial essence-first rewrite.
  (Later landing edits — rules/close mentions, model sync — were folded in directly as the
  method evolved across the session, then re-verified in-browser and redeployed.)

## Pointers
- Deployed commit: ccdc613. Vercel project "arcs" is CLI-linked (deploy = `vercel --prod`).
