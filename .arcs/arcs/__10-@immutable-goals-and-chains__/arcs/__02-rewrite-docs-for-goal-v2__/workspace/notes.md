# notes — rewrite-docs-for-goal-v2 (scratch)

Ground truth verified by reading bin/arcs + running `arcs status` on examples/basic.

## Key CLI facts that constrained the docs
- `closing_arc_for()` only matches `__[0-9][0-9]-*__` sub-arcs → a checklist item ticks `✓`
  ONLY when its closing sub-arc folder is `__…__`-wrapped (closed). An unwrapped but `status: done`
  sub-arc yields `(0/M ✓)`. This forced the example fix below.
- `render_goal_substream()` strips `__…__` when printing `✓ <key> → <arc>` (shows bare slug), but
  the TOP-stream board line (`cmd_status`) prints the folder name as-is → a closed standalone arc
  shows as `__01-spike-vite__` in the board. Docs samples updated to match real output.
- `closes:` value is a stable item key (slug), NOT "step N". `read_supersedes` accepts `prev:` as
  read-alias and strips `__`. `arc_md` ships `# closes:`/`# supersedes:` commented; supersede writes
  the real `supersedes:` line after `status:`.

## Example fix decision (in-scope correction)
examples/basic had done arcs left UNWRAPPED (`01-spike-vite`, `01-research`) despite `status: done`
— a pre-existing latent inaccuracy. goal-v2's checklist render DEPENDS on `__…__` closure, so I
wrapped both done arcs on disk (`__01-spike-vite__`, `__01-research__`) to make the `(1/3 ✓)` demo
real, then matched every doc sample/tree/path to the actual `arcs status` output. Verified.

## bin/arcs wording-only tweaks (no behavior change)
- arc_md `## input` placeholder → pointer cue `<input/… — one-line gist…>` (en/ru/es)
- goal_md `goal:` placeholder → added `≤12 words; long version in "Where we are"` cue (en/ru/es)

## CHANGELOG scope
- Added goal-v2 entries to [Unreleased] only. Left [0.1.0] historical text untouched (incl. its
  "versioned status doc" phrasing — that's an accurate record of what 0.1.0 shipped).
