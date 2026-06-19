# result — dashboard usefulness overhaul

Started as "the digest is inconvenient" and grew, over a live mobile session, into a full
usefulness pass on `arcs dashboard`. Driven by direct user feedback + a 3-subagent review
that scored every view (verdict: an inventory, not a decision tool; the real arc content on
disk was unreachable).

## Shipped (dashboard/scan.sh + dashboard/template.html)

**Digest → arc-event feed.** Dropped commit-subject noise. Now a dated feed of real arc
events (opened/closed, detected from git renames/adds across all projects), grouped **by
day** (today / yesterday / …), newest-first, each row clickable to its detail. **Surfaced
candidates** sit on top. A **show-more** button reveals older days. 7-day closed/opened
summary line. (Killed the "this week" two-line tab bug by removing the tabs.)

**Recent work.** Overview leads with the most-recently-touched arcs (title + short
description + relative age) — useful even when nothing is "in flight".

**Newest-on-top everywhere** — board stream, timeline, digest all sort newest-first
(`visible()` sorts by arc number desc).

**Clean board rows.** `36 title` instead of `__36-slug__`; the slug becomes the title when
no goal one-liner exists (no more "— blank —"); denser; active row pops green; **closed
goals are neutral grey + legible** (not colored like they're special), badged "goal done".

**Candidates on project boards** (and in the digest) — the backlog is visible, not hidden.

**Arc modal reads real content.** The drawer embeds and renders `arc.md` + every
`output/`/`workspace/`/`input/` file (24-file cap, 6 KB each, binaries skipped), as tabs.
Default tab is intent-aware: **closed → output** (the result), **active → workspace / a
goal's current state**; `arc.md` is the fallback, never the default. Copyable on-disk path,
clickable lineage. On mobile it's a **full-screen sheet** — background scroll locked, long
text wraps (no horizontal scroll).

**Scan.** Whole-`$HOME`, runs from any directory, **excludes arcs' own example/template
fixtures** (nested-project filter), emits per-arc last-activity timestamps + candidates.

**State persistence.** Scope + view live in the URL hash *and* localStorage, so reload /
reopen keeps your place (and links are shareable).

**Cache.** The local server now sends `no-store` — fixes the "I still see the old page"
loop at the source.

## Verified (Playwright, real generated page, mobile + desktop)
- Board newest-first (`36,35,34,…`); closed-goal stripe transparent, badge neutral; 1
  candidate shown on the arcs board.
- Digest: by-day feed, candidates on top, 14 closed / 14 opened in 7 days.
- Timeline: newest-first + clean titles (`10 lore-landing`, `09 …`).
- Drawer: real `result.md` content; mobile sheet — `bodyLocked:true`, 0 horizontal overflow.
- State: `#arcs/board` restores scope=arcs/view=board on load.
- **0 console errors** across every surface.

Screenshots in this dir: digest-after, drawer-desktop, modal-mobile.

## Notes / follow-ups
- Lineage/map stay near-empty until projects record `theme:`/`supersedes:` — honest degrade.
- Could add free-text search across arc titles/content (subagent's remaining top idea).
- Goal sub-arcs as a clickable list in the drawer needs the scanner to emit nested sub-arcs.
