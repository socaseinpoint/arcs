# Examples

## `basic/` — what a real `.arcs/` looks like

A tiny project with one goal (a newsletter, multi-arc) and one standalone arc (a one-shot spike).
Files are filled in, not placeholders — so you can see the shape.

```
basic/.arcs/
  arcs/
    01-spike-vite/                  standalone arc — one question, answered
      arc.md
      output/verdict.md             ← the public interface (self-contained)
  goals/
    01-newsletter/                  a goal = an arc with a purpose + its own arcs
      01-newsletter-goal.md         brief status: where we are, which arcs are open
      arcs/
        01-research/
          arc.md
          input/sources.md          what came in
          output/shortlist.md       ← what the next arc reads (and ONLY this)
```

Run the board from `basic/`:

```
$ arcs status
GOALS
  01-newsletter                    [active]  ship issue #1 of a weekly dev newsletter
      01-research                        [done]    gather candidate stories for issue #1

ARCS
  01-spike-vite                      [done]    check whether Vite 6 breaks our PostCSS setup
```

### What to notice
- **`output/` is the contract.** The drafting arc will read `01-research/output/shortlist.md` and
  nothing from its `workspace/`. Close an arc → its output stands on its own.
- **Standalone vs goal.** `01-spike-vite` is a throwaway question worth persisting → a root arc.
  The newsletter is sustained, multi-step → a goal with its own arcs.
- **The goal file is the "you are here".** Surfacing from a deep dive, you open
  `01-newsletter-goal.md` and immediately see the bottleneck and what's next.
