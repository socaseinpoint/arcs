# gate-enforcement-is-real
from: 23-roast-arcs-method-and-cli

GOAL. Gate is silently dead: arcs-gate:37 grep -r matches stale 'status: active' in closed arcs' artifacts -> gate open forever. Fix reader (glob open */arc.md + */*-goal.md, skip __*__). Also gate Bash + NotebookEdit (currently bypassable), tighten .arcs/ allowlist, stop docs calling it unqualifiedly 'hard'.
