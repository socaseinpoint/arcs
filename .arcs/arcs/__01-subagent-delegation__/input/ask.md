# Ask

User: arcs should use subagents and work in parallel where possible, so the
orchestrator stays free and doesn't fill its context.

Verbatim (ru): "я бы хотел чтобы arcs юзал сабагентов и работал паралельно когда
можно, чтобы оркестратор оставался свободным и не забивал контекст если можно"

## Insight
The arc boundary IS a subagent boundary:
- arc = input → workspace → output, encapsulated. Dispatch a subagent scoped to one arc;
  it churns in workspace/, writes output/; orchestrator reads ONLY output/ back.
- The workspace mess never enters orchestrator context → context stays lean.
- Independent arcs (no output→input dependency) → parallel subagents.
- Pipelined arcs (output N = input N+1) → sequential, each still isolated.
- Orchestrator becomes a thin coordinator holding goal.md + arcs' output/ only.

## Scope
Encode this into the method, not just remember it:
- skill/SKILL.md — add a "Delegate arcs to subagents; parallelize" section (operational).
- SPEC.md — note the subagent mapping under "Why this way" (conceptual).
Keep tooling-independence: subagents are the *typical* execution, not required by the method.
