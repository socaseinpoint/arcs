# Examples

## `basic/` — what a real `.arcs/` looks like

A tiny project with one goal (a newsletter, multi-arc) and one plain arc (a one-shot spike).
Files are filled in, not placeholders — so you can see the shape.

`.arcs/arcs/` is a single numbered stream. An arc is `NN-<slug>/` (work without a purpose);
a goal is `NN-@<slug>/` (an arc *with* a purpose — the `@` marks it). Arcs and goals share the
same numbering. A goal holds one immutable `<slug>-goal.md` status doc (no version number — its
intent is a `goal:` line plus a short "where we are") plus its own nested `arcs/` stream. The
goal's checklist *is* that nested stream: each sub-arc is an item, done when it's closed.

```
basic/.arcs/
  arcs/
    __01-spike-vite__/              plain arc, done (the __…__ marks it closed)
      arc.md
      output/verdict.md             ← the public interface (self-contained)
    02-@newsletter/                 a goal (@ = an arc with a purpose) + its own arcs
      newsletter-goal.md            immutable status: goal line + where we are
      arcs/                         the goal's checklist IS this stream of sub-arcs
        __01-research__/            done sub-arc (closed __…__) = a ticked item
          arc.md                    status: done
          input/sources.md          what came in
          output/shortlist.md       ← what the next arc reads (and ONLY this)
        02-draft/                   open sub-arc = an unchecked item
        03-ship/                    open sub-arc = an unchecked item
  candidates/                       surfaced arc-candidates, not yet real arcs
    01-add-rss-feed.md              from: 02-@newsletter
```

Run the board from `basic/`:

```
$ arcs status
STREAM
  __01-spike-vite__                  [done]    check whether Vite 6 breaks our PostCSS setup
  02-@newsletter                     [active]  ship issue #1 of a weekly dev newsletter   (1/3 ✓)
      ✓ 01-research                  gather candidate stories for issue #1
      ○ 02-draft                     [active]  write the issue copy from the shortlist
      ○ 03-ship                      [active]  send issue #1
CANDIDATES (surfaced arc-candidates — promote with: arcs promote <slug>)
  01-add-rss-feed                  from 02-@newsletter
```

A goal's checklist is just its sub-arcs, so `arcs status` computes progress from disk: `(1/3 ✓)`
on the goal line, then `✓` for each closed sub-arc and `○` for each open one. Nothing is
hand-ticked — close `02-draft` (it becomes `__02-draft__`) and the line flips to `✓` on its own.

### What to notice
- **`output/` is the contract.** The drafting arc will read
  `02-@newsletter/arcs/__01-research__/output/shortlist.md` and nothing from its `workspace/`.
  Close an arc → its output stands on its own (the `__…__` marks it done).
- **Plain arc vs goal.** `01-spike-vite` is a throwaway question worth persisting → a plain arc
  (no `@`). The newsletter is sustained, multi-step → a goal (`02-@newsletter`) with its own arcs.
  Both live in the same numbered `.arcs/arcs/` stream.
- **The goal file is the "you are here".** Surfacing from a deep dive, you open
  `02-@newsletter/newsletter-goal.md` and immediately see where you are and the bottleneck, with
  the checklist itself one `arcs status` away. One immutable doc — no version numbers to chase;
  if the aim itself changed you'd
  `arcs supersede` it into a new linked goal rather than rewrite it.
- **`candidates/` is the backlog.** Ideas that surface mid-arc but aren't worth starting yet
  land here as `NN-<slug>.md` with a `from:` origin (here `01-add-rss-feed` came `from: 02-@newsletter`).
  Capture one with `arcs candidate`; when it's ready, `arcs promote add-rss-feed` turns it into a real arc.
