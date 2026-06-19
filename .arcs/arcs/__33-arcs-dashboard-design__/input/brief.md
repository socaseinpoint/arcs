# Brief — arcs dashboard

A simple, good-looking dashboard built **on top** of arcs: a tooling/presentation
layer to look at arcs from several perspectives. Brainstormed live by reacting to
working prototypes rather than abstract questions.

## Hard constraint (repeated by the user, twice)
The dashboard is **tooling on top — a presentation layer. It must NOT be confused
with, or mixed into, the arcs core** (the method, the CLI, the `.arcs/` on-disk
format). The instrument can change freely; the core stays untouched. The dashboard
only **reads** `.arcs/`, never writes to it.

## What the user asked for, in order
1. Define the *core* of the dashboard — not abstractly, by seeing a prototype.
2. More than one view — "look from different perspectives", with display settings.
3. lineage cleaner + more informative.
4. More info to read inside a card (the detail drawer).
5. board is the boring tab — make it the interesting **home** (pulse + in-flight).
6. Multi-project: show **all** arcs projects on the machine; drill into one.
7. A **digest** — an interpreted "what did I do today / this week / what's left".
8. Distribution: how to ship to users — desktop app? → decided: **local CLI static**.
9. Update the landing where needed — but keep core vs presentation layer separate.
