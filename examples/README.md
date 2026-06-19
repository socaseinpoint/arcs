# Examples

## `basic/` — what a real `.arcs/` looks like

A tiny project with one goal (a newsletter, multi-arc) and one plain arc (a one-shot spike).
Files are filled in, not placeholders — so you can see the shape.

`.arcs/arcs/` is a single numbered stream. An arc is `NN-<slug>/` (work without a purpose);
a goal is `NN-@<slug>/` (an arc *with* a purpose — the `@` marks it). Arcs and goals share the
same numbering. A goal holds one immutable `<slug>-goal.md` status doc (no version number — its
intent is a `goal:` line plus a `## Checklist`) plus its own nested `arcs/` stream.

```
basic/.arcs/
  arcs/
    __01-spike-vite__/              plain arc, done (the __…__ marks it closed)
      arc.md
      output/verdict.md             ← the public interface (self-contained)
    02-@newsletter/                 a goal (@ = an arc with a purpose) + its own arcs
      newsletter-goal.md            immutable status: goal line + checklist + where we are
      arcs/
        __01-research__/            done sub-arc (closed) — wraps closes: research-stories
          arc.md                    closes: research-stories  ← ties the arc to a checklist item
          input/sources.md          what came in
          output/shortlist.md       ← what the next arc reads (and ONLY this)
  candidates/                       surfaced arc-candidates, not yet real arcs
    01-add-rss-feed.md              from: 02-@newsletter
```

Run the board from `basic/`:

```
$ arcs status
STREAM
  __01-spike-vite__                  [done]    check whether Vite 6 breaks our PostCSS setup
  02-@newsletter                     [active]  ship issue #1 of a weekly dev newsletter   (1/3 ✓)
      ✓ research-stories             → 01-research
      ○ draft-issue
      ○ ship-issue
CANDIDATES (surfaced arc-candidates — promote with: arcs promote <slug>)
  01-add-rss-feed                  from 02-@newsletter
```

The goal carries a `## Checklist`, so `arcs status` shows its progress computed from sub-arcs:
`(1/3 ✓)` on the goal line, then `✓ <key> → <arc>` for each item a closed sub-arc declares
`closes:` for, and `○ <key>` for the rest. Nothing is hand-ticked — close `02-draft` with
`closes: draft-issue` and the next item flips to `✓` on its own.

### What to notice
- **`output/` is the contract.** The drafting arc will read
  `02-@newsletter/arcs/__01-research__/output/shortlist.md` and nothing from its `workspace/`.
  Close an arc → its output stands on its own (the `__…__` marks it done).
- **Plain arc vs goal.** `01-spike-vite` is a throwaway question worth persisting → a plain arc
  (no `@`). The newsletter is sustained, multi-step → a goal (`02-@newsletter`) with its own arcs.
  Both live in the same numbered `.arcs/arcs/` stream.
- **The goal file is the "you are here".** Surfacing from a deep dive, you open
  `02-@newsletter/newsletter-goal.md` and immediately see the checklist, the bottleneck, and
  what's next. One immutable doc — no version numbers to chase; if the aim itself changed you'd
  `arcs supersede` it into a new linked goal rather than rewrite it.
- **`candidates/` is the backlog.** Ideas that surface mid-arc but aren't worth starting yet
  land here as `NN-<slug>.md` with a `from:` origin (here `01-add-rss-feed` came `from: 02-@newsletter`).
  Capture one with `arcs candidate`; when it's ready, `arcs promote add-rss-feed` turns it into a real arc.
