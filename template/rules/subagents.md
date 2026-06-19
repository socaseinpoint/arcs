# subagents
enabled: true

Delegate arc execution to subagents; keep the orchestrator's context lean.

An arc is already an encapsulated unit — `input → workspace → output`, where the outside
reads only `output/`. That boundary IS a subagent boundary. So:

- **One arc → one subagent.** When you execute an arc, dispatch a subagent scoped to it.
  Give it the arc's `input/` + the task. It does the work in `workspace/`, then writes
  `output/` and updates `arc.md`. You (the orchestrator) read back **only `output/`** —
  the workspace churn never enters your context.
- **Independent arcs → parallel subagents.** If two arcs have no output→input dependency,
  run them as concurrent subagents in a single batch.
- **Pipelined arcs → sequential.** If `output` of arc N is the `input` of arc N+1, run them
  in order; each still isolated, each handing off via its `output/` only.
- **Orchestrator stays thin.** Hold the goal's `NN-<slug>-goal.md` + the arcs' `output/`.
  Don't pull a subagent's `workspace/` into your own context unless something failed and
  you need to debug it.

This is the agentic execution of the method. The method itself is unchanged and still works
without subagents (run the arcs inline) — this rule just says: when an agent CAN delegate,
it SHOULD, so coordination stays cheap and parallel.
