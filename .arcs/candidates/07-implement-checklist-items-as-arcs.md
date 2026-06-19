# implement-checklist-items-as-arcs
from: 26-design-checklist-items-as-arcs

MODEL B (decided): checklist item == sub-arc; done = sub-arc closed (__); N/M from disk; closes:/keys/slugify/## Checklist all removed. Kills dotted-key bug (21) + typo-no-op (#4) + replaces candidate 04. OPEN QUESTIONS (resolve before build): (1) spikes — opt-out marker vs all count; (2) immutable contract — only goal: frozen + mutable sub-arc set vs whole set frozen; (3) migrate legacy goals 10/13 (## Checklist+closes:) — dual read path vs migrate vs stop rendering; (4) breaking? minor 0.4.0 keep-reading vs major 1.0.0 drop closes:+raise MIN_VERSION. Full notes: arc 26 output/design-notes.md + input/idea.md.
