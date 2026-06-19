# Plan — rebuild landing + deep docs

## Goal
Split web presence into two surfaces:
- `docs/index.html` — SHORT value-first landing (beginner with an agent + 30s).
- `docs/docs.html` — deep documentation (full mental model).

Reuse `docs/style.css` design system; extend tokens, don't fork. Vanilla JS.

## Verified ground-truth against bin/arcs (cmd dispatch lines 559-575)
Commands that EXIST (exact spelling):
- `arcs init [en|ru|es]` — writes `.arcs/config` with `lang=` + `rules=subagents`, creates `.arcs/arcs/`, seeds README.md.
- `arcs lang [en|ru|es]` — show/change project arc language.
- `arcs new-arc <slug>` / `arcs new-arc -g <goal> <slug>` — creates `NN-<slug>/{input,workspace,output}` + arc.md. With -g, goes in goal's nested arcs/.
- `arcs new-goal <slug>` — creates `NN-@<slug>/{input,workspace,output,arcs}` + `<slug>-goal.md`.
- `arcs close [-g <goal>] [-f] <slug>` — refuses empty output/ unless -f; renames NN-slug -> __NN-slug__; sets status: done.
- `arcs reopen [-g <goal>] <slug>` — strips __…__, status -> active.
- `arcs supersede [-g <goal>] <old> <new>` — close old with -f (no output guard), create new with supersedes: <old>, seed input/from-<old>.md.
- `arcs rule [list|on|off|add] <slug>` — toggle; bodies global in <repo>/rules/, switch in .arcs/config rules=.
- `arcs candidate <slug> [--from <arc>] [text]` / `arcs candidate list` — capture into .arcs/candidates/NN-<slug>.md (own numbering, from: field).
- `arcs promote [-g <goal>] <NN-or-slug> [<new-slug>]` — candidate -> real arc, moves file into input/.
- `arcs status` — board. STREAM + CANDIDATES sections.
- `arcs update` — git pull + re-wire install.sh.
- `arcs help`.

Fields (parser, English keys always):
- `goal:`, `status: active|blocked|done`
- `closes: <key>` (sub-arc closes a checklist item key)
- `supersedes: <slug>` (alias read: `prev:`)
- `from: <arc>` (candidate origin)
- Goal doc `<slug>-goal.md`: `goal:` + `## Checklist` (items `- [ ]`) + `## Where we are`.

Checklist key resolution (goal_item_keys awk): explicit `{#key}` wins; else leading slug-token of `<key> — <desc>`; else slugify whole text.
Badge: `N/M ✓` on goal line; `✓ key → arc` (closed) / `○ key` (open).

Install (DEPLOY.md): one-command `git clone … ~/arcs && cd ~/arcs && ./install.sh`; manual = clone + PATH export + optional skill symlink. Hooks: arcs-hook (SessionStart+UserPromptSubmit), arcs-gate (PreToolUse Edit|Write|MultiEdit). Requirements: bash + coreutils.

## Changelog target
No CHANGELOG file or page in repo. Point "Changelog" -> https://github.com/socaseinpoint/arcs/commits/main (commit history is the de-facto changelog).

## Worked example (examples/basic)
- stream: `__01-spike-vite__` (closed arc) + `02-@newsletter` (goal, 1/3 ✓).
- goal checklist: research-stories / draft-issue / ship-issue.
- `__01-research__` sub-arc closes: research-stories -> ticks item -> status shows 1/3 ✓ + ✓ research-stories → 01-research.
- candidate: 01-add-rss-feed from 02-@newsletter.

## Decisions
- Landing kept bilingual EN/RU? Spec says `en` prose. Existing site is RU/EN toggle. To match constraint "en, humanized" + keep things short, I'll make BOTH pages English-only and drop the RU/EN toggle (simplifies app.js, honors `en` constraint). Keep reveal + lang persistence removed. Actually: keep app.js reveal; drop i18n.
- docs.html gets a sticky side ToC (anchored sections), scroll-spy via IntersectionObserver (extend app.js, guard reduced-motion).
