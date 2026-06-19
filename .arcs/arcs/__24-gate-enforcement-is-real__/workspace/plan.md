# plan — make the gate real

## The CRITICAL (roast #1)
`hooks/arcs-gate:37` `grep -rqsE '^status: active' "$dir/.arcs"` recurses the WHOLE tree.
Closed arcs' workspace/output artifacts quote `status: active` → gate stays open with zero
open arcs. Reproduces live (`__10-...__/workspace`, `__12-...__/output`).

## Fix the READER (not the artifacts)
Check only canonical open-arc docs, skip closed `__*__` dirs at any level:
- `.arcs/arcs/*/arc.md`, `.arcs/arcs/*/*-goal.md`
- `.arcs/arcs/*/arcs/*/arc.md`, `.arcs/arcs/*/arcs/*/*-goal.md` (goal substreams)
- skip any path with `/__` (closed). grep one file at a time, no `-r`.
Also fixes unbounded per-edit cost (#41) and "close can't re-arm gate" (#38).

## Also in scope (cheap, same file)
- NotebookEdit (#34): extractor reads `notebook_path` too; add NotebookEdit to the matcher
  (install.sh source + live settings.json).
- Allowlist (#37): `*".arcs/"*` is a loose substring (matches `notes.arcs/x`). Keep only
  `*"/.arcs/"*`.

## Out of scope (capture as follow-up)
Gating Bash write-redirects (`cat >`, `sed -i`) — needs command parsing, separate design.
Stop docs/SKILL calling the gate unqualifiedly "hard" — doc-truth sweep, fold into the
docs-truthfulness candidate.

## Verify
Drive JSON into the gate in a temp project:
- zero open arcs but a closed arc whose output quotes `status: active` → EXIT 2 (was 0). 
- one open arc → exit 0.
- edit to a `.arcs/` path → exit 0.
- NotebookEdit outside arc → exit 2; NotebookEdit under `.arcs/` → exit 0.
Then confirm against THIS repo (currently all closed → should now block a non-.arcs edit).
