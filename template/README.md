# <project>

Follows the **arcs** method — see `../arcs/SPEC.md`.

- `.arcs/arcs/` — one numbered stream: arcs (`NN-<slug>/`) and goals (`NN-@<slug>/`, the `@` marks a goal)
- `.arcs/candidates/` — backlog of surfaced arc-candidates (`NN-<slug>.md`, each with a `from:` origin)
- `.arcs/config` — `lang=` and the `rules=` switch
- closed arcs/goals are wrapped `__NN-…__`

Session entry point: open the current goal's `<NN-slug>-goal.md` (or `arcs status`).
Status board: `arcs status`.
