# result — the gate is real again

Fixed the CRITICAL from the roast (arc 23, finding #1): the gate was silently dead — a
recursive `grep -r` matched stale `status: active` prose inside *closed* arcs' artifacts, so
it stayed open with zero open arcs. Reproduced live in this repo before the fix.

## Changed
- `hooks/arcs-gate`
  - **Reader (the fix):** replaced `grep -rqsE '^status: active' "$dir/.arcs"` with a bounded
    loop over canonical open-arc docs only — `*/arc.md` and `*/*-goal.md` at the stream level
    and inside goal substreams — skipping closed `__*__` dirs at any depth. Never recurses the
    tree, so workspace/output prose can't hold the gate open. (Also kills the unbounded
    per-edit cost #41 and the "close can't re-arm" symptom #38.)
  - **NotebookEdit (#34):** extractor now reads `notebook_path` as well as `file_path`; a
    notebook under `.arcs/` is allowed, one outside an open arc is blocked.
  - **Allowlist (#37):** anchored to `*"/.arcs/"*` (dropped the loose `*".arcs/"*` that matched
    a sibling like `notes.arcs/x`).
  - **Honesty:** header no longer calls it unqualified "hard enforcement" — states plainly
    that Bash write-redirects (`cat >`, `sed -i`) are NOT gated.
- `install.sh` — gate matcher is now `Edit|Write|MultiEdit|NotebookEdit`, and the registrar
  *reconciles* the matcher on an already-registered gate (so existing installs pick up
  NotebookEdit on `arcs update`, not only fresh installs). Ran it → live settings.json updated.

## Verified (temp project /tmp/gatetest, JSON driven into the gate)
- all-closed + closed arc quoting "status: active" → **BLOCK (exit 2)** ✓ (was exit 0)
- edit a `.arcs/` file → allow ✓ · sibling `notes.arcs/x` → block (correctly not allowlisted) ✓
- one open arc → allow ✓ · open goal via `-goal.md` → allow ✓ · open nested sub-arc → allow ✓
- NotebookEdit under `.arcs/` → allow ✓ · NotebookEdit outside, no open arc → block ✓
- live matcher reconciled to `Edit|Write|MultiEdit|NotebookEdit` ✓

## Deferred (not this arc)
- Gating Bash write-redirects — needs command parsing; separate design.
- Sweeping "hard"/airtight claims out of SKILL.md + docs.html — folded into the
  docs-truthfulness follow-up (roast candidates).
