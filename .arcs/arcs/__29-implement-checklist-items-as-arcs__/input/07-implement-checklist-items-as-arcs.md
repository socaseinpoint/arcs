# implement-checklist-items-as-arcs
from: 26-design-checklist-items-as-arcs

MODEL B (decided): checklist item == sub-arc; done = sub-arc closed (__); N/M from disk; closes:/keys/slugify/## Checklist all removed. Kills dotted-key bug (21) + typo-no-op (#4) + replaces candidate 04.

OPEN QUESTIONS — status:
(1) spikes — RESOLVED: sub-arc set is mutable, N/M = "closed sub-arcs / total", no spike marker (YAGNI). Follows from (2).
(2) immutable contract — RESOLVED (leaning): freeze only goal:, sub-arc set is mutable; changed item = supersede that arc. (confirm at build)
(3) migrate legacy goals 10/13 — RESOLVED by arc 28: ship ZERO migration. Reader already degrades (no ## Checklist → raw sub-arc fallback; closes: greps return empty). 10/13 are CLOSED → gate skips them → leave untouched.
(4) breaking? — RESOLVED by arc 28: NOT a hard break. Drop closes:/## Checklist from TEMPLATES + one CHANGELOG line. Old goals keep reading (dual-read already exists). No MIN_VERSION bump, no doctor/stamp engine. If a real lossy break ever needs migration, see arc 28 Layer-2 (migrations/<ver>.sh).

BUILD = cheap: edit new-goal/new-arc templates (drop closes: line + ## Checklist block) + status N/M from sub-arc set + CHANGELOG. Demonstrate new shape as a one-time supervised arc, NOT an idempotent pass (arc 28 guard: structural reshape ≠ migration pass — next_num counts dirs, re-run would dup).

Full notes: arc 28 output/verdict.md (migration decision) + arc 26 output/design-notes.md + input/idea.md.
