# enforce-arc-before-work
from: remove-duplicate-landing

## problem
Agent did a full cleanup task (delete landing, commit) WITHOUT opening an arc first, despite the
SessionStart + UserPromptSubmit hooks reminding every prompt. The arc was created retroactively.
Reminders are advisory — they don't stop work, so a focused agent skips them.

## why it happened
- `arcs-hook` (SessionStart + UserPromptSubmit) only *reminds*; it injects text, never blocks.
- `arcs-gate` (PreToolUse) is supposed to hard-block edits until an arc is open — but it didn't fire
  here. Open question: does the gate cover Bash mutations (`git rm`, `rm`, `git commit`) or only the
  Edit/Write tools? If it only guards Edit/Write, any file op done through Bash bypasses the gate
  entirely. That's the likely hole.

## directions to think about later
- Extend `arcs-gate` to also match destructive/committing Bash (`rm`, `git rm`, `git commit`,
  `vercel deploy`) — not just Edit/Write — so there's no Bash escape hatch.
- Or: a softer "no open arc → confirm intent" prompt instead of a hard block, to avoid friction on
  truly trivial ops.
- Decide what counts as "trivial enough to skip an arc" and encode it, instead of leaving it to agent
  judgment (which failed here).

## related
- ties into the gate-enforcement work in __24-gate-enforcement-is-real__
