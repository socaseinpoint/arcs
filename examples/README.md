# Examples

## `basic/` — what a real `.arcs/` looks like

A tiny project with one goal (a newsletter, multi-arc) and one plain arc (a one-shot spike).
Files are filled in, not placeholders — so you can see the shape.

`.arcs/arcs/` is a single numbered stream. An arc is `NN-<slug>/` (work without a purpose);
a goal is `NN-@<slug>/` (an arc *with* a purpose — the `@` marks it). Arcs and goals share the
same numbering. A goal holds a versioned `MM-<slug>-goal.md` status doc plus its own nested
`arcs/` stream.

```
basic/.arcs/
  arcs/
    01-spike-vite/                  plain arc — one question, answered
      arc.md
      output/verdict.md             ← the public interface (self-contained)
    02-@newsletter/                 a goal (@ = an arc with a purpose) + its own arcs
      01-newsletter-goal.md         versioned status: where we are, which arcs are open
      arcs/
        01-research/
          arc.md
          input/sources.md          what came in
          output/shortlist.md       ← what the next arc reads (and ONLY this)
```

Run the board from `basic/`:

```
$ arcs status
ARCS
  01-spike-vite                      [done]    check whether Vite 6 breaks our PostCSS setup
  02-@newsletter                     [active]  ship issue #1 of a weekly dev newsletter
      01-research                        [done]    gather candidate stories for issue #1
```

### What to notice
- **`output/` is the contract.** The drafting arc will read
  `02-@newsletter/arcs/01-research/output/shortlist.md` and nothing from its `workspace/`.
  Close an arc → its output stands on its own.
- **Plain arc vs goal.** `01-spike-vite` is a throwaway question worth persisting → a plain arc
  (no `@`). The newsletter is sustained, multi-step → a goal (`02-@newsletter`) with its own arcs.
  Both live in the same numbered `.arcs/arcs/` stream.
- **The goal file is the "you are here".** Surfacing from a deep dive, you open
  `02-@newsletter/01-newsletter-goal.md` and immediately see the bottleneck and what's next.
