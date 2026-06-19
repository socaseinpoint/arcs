# 28-arcs-self-migration-strategy

goal: decide how arcs evolves its on-disk format without breaking existing projects — pick the minimal migration strategy
status: done

## input
- idea: as arcs changes format (drop fields/blocks, rename folders), N drifting projects must keep working or auto-upgrade; want a changelog-driven self-heal. Surfaced while parking arc 07 (checklist-items-as-arcs) on the breaking/migration question.

## output → pointers
- output/verdict.md — 12-critic consortium roast + recommended minimal design (DECISION)
