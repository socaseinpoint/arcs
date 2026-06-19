# benchmark-where-arcs-wins
from: 32-benchmark-pluggable-structures

First bench run showed arcs is pure overhead on TRIVIAL tasks (input x3, time x2, quality flat-to-worse) — the floor, not a verdict. Follow-up: build a NON-TRIVIAL / multi-step task suite where structure should actually pay off (the regime arcs is for); possibly simplify the arcs-default arm (less bureaucracy: init+doc-read cost ~3x tokens); add alt-structure arms once CLI pluggability lands; consider multi-vote judge. Goal: find the example where arcs demonstrably wins. See __32-@benchmark-pluggable-structures__/ outputs.
