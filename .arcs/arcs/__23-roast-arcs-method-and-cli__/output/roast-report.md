# arcs — Roast Report

## Verdict

arcs is a tight, genuinely-thought-through file method with a single 640-line bash CLI and a real Claude Code hook — and it dogfoods itself, which is admirable and also how its worst bug got planted. The conceptual model is coherent but two things undercut it: (1) the one piece of "hard enforcement" the project repeatedly advertises is, in this very repo, **silently dead** — the gate's whole-tree grep matches stale `status: active` strings inside *closed* arcs' own artifacts, and Bash/NotebookEdit aren't gated at all; (2) the headline goal-progress feature (`closes:` → N/M checklist) **can never fire from the SKILL alone** because nothing — no command, no instruction — ever tells the agent to write `closes:` or the checklist items. The CLI itself is solid on the happy path but brittle at the edges: no slug sanitization, `set -u` crashes on missing flag operands, supersede corrupts arc.md on `&`, and goal/sub-arc operations break the moment a goal is closed. Most findings are real; several "CRITICAL/HIGH" labels are correctly graded but a handful were inflated and are dialed down below.

---

## CRITICAL

**1. The gate's status grep matches ANY file under `.arcs/` — closed arcs hold the gate permanently open**
`hooks/arcs-gate:37` — `grep -rqsE '^status: active' "$dir/.arcs"` recurses the *entire* tree, including `__closed__` dirs' workspace/output artifacts and template prose. **Verified live in this repo:** `__10-.../workspace/brainstorm-goal-v2.md` and `__12-.../output/result.md` both contain `status: active`, so the gate allows edits forever even with zero open arcs. The project's sole hard-enforcement mechanism is currently defeated by its own dogfooding output.
**Fix:** glob only open-arc canonical docs — `"$dir"/.arcs/arcs/*/arc.md` and `.../*/*-goal.md`, skip `__*__` names, `grep -m1` per file. Never `grep -r` the tree. This one change also fixes the unbounded per-edit cost (finding #41) and the "close can't re-arm the gate" symptom (#38) — *don't* try to fix it by rewriting artifacts on close; fix the reader.

---

## HIGH

**2. SKILL never tells the agent to set `closes:` or write the goal checklist — computed done-state is dead on arrival**
`skill/SKILL.md:62-63` advertises "done-state computed from sub-arcs that carry `closes:`" but no command sets `closes:` (it ships only as a commented template line, `bin/arcs:152`), and the SKILL never instructs the hand-edit; nor does it say to replace the `## Checklist` placeholder (`bin/arcs:206`) with real keyed items. An agent following only the SKILL closes sub-arcs and the goal stays `0/M` forever. (Human docs at `docs.html:517` get it right — the *agent* surface doesn't.) *Downgraded from CRITICAL: no data loss, arcs still work; it's a dead headline feature, not corruption.*
**Fix:** add to the goal flow — after `new-goal`, fill `goal:` and write real `## Checklist` items; after `new-arc -g`, set `closes: <key>`. Ideally add `arcs new-arc -g <goal> --closes <key> <slug>` so it's not a hand-edit.

**3. Bash tool is not gated — trivial silent bypass of the "hard" enforcement**
`hooks/arcs-gate:2` matcher is `Edit|Write|MultiEdit`. `cat >`, `tee`, `sed -i`, `printf >` mutate any file with no open arc. NotebookEdit (#34) slips through identically and, worse, its `notebook_path` param isn't even read by the extractor (`gate:15-17`), so a notebook under `.arcs/` gets wrongly *blocked*.
**Fix:** at minimum stop calling the gate unqualifiedly "hard" and state the Bash hole in the SessionStart reminder + DEPLOY.md. Add NotebookEdit to the matcher *and* read `notebook_path`.

**4. `closes:` keys are never validated against the goal checklist — a typo silently no-ops**
`bin/arcs:511,281` — close writes `status: done` and wraps the folder without ever checking the parent goal's keys. A misspelled `closes:` falls into the "non-closing" bucket, the item stays `○`, no error. This is exactly the silent drift the method exists to kill — invisible here because the source is computed.
**Fix:** at close (and/or in status), resolve `closes:` against `goal_item_keys` and warn on no-match (with a nearest-match hint).

**5. supersede silently downgrades a goal to a plain arc**
`bin/arcs:608` always calls `cmd_new_arc`, never `cmd_new_goal` — yet `SPEC.md:116` reserves supersede as *the* mechanism for a goal whose aim shifts. The replacement loses the `@`, the nested `arcs/` substream, and the `-goal.md`; the superseded goal becomes un-pursuable.
**Fix:** detect goal-ness from the closed dir (`__NN-@old__` / `*-goal.md`, the same signal `cmd_close` already uses) and dispatch `cmd_new_goal`, writing `supersedes:` into the new `-goal.md`.

**6. supersede corrupts arc.md when the old slug contains sed metachars (`&`, `|`, `\`)**
`bin/arcs:614` interpolates `$old` raw into a sed replacement. `supersede 'a&b' 'c&d'` produced `supersedes: astatus: activeb` — status line destroyed. `|` errors out, leaving the field silently missing. Reachable because slugs aren't sanitized on creation (#10).
**Fix:** escape the sed RHS or append the field via awk/printf with the literal value; slugify on creation removes the input class entirely.

**7. Numbering collides permanently past 99 (2-digit-only globs)**
`bin/arcs:54,66` and 7 lookup sites only match `[0-9][0-9]-`. After `100-y`, `next_num` falls back to 99 and re-issues `100`. Silent duplicate numbering breaks ordering, `sort|tail` selection, and uniqueness. *Latent — needs 100 entries in one stream (this repo is at ~23), so HIGH-leaning-MEDIUM, but silent when it hits.*
**Fix:** match `[0-9][0-9]*-*`, parse defensively, `printf %02d` for display only.

**8. All `-g <goal>` ops break once the goal is closed**
`bin/arcs:505,254` glob only open `[0-9][0-9]-@slug/`. After closing a goal, `new-arc -g`/`reopen -g`/etc. die with "goal not found" though `__NN-@slug__` exists. *Downgraded to MEDIUM by the verifier: clean one-command workaround exists (`arcs reopen <goal>` with no -g), and operating on a closed goal's substream is uncommon.*
**Fix:** make the error name the closed-goal case ("exists but closed — reopen it first").

**9. close/reopen by bare slug is ambiguous between an arc and same-named goal — lowest NN shadows the other**
`bin/arcs:523,543` fold both `NN-slug` and `NN-@slug` into one glob + `head -1`; the lower-numbered wins (not the goal per se — verifier corrected the mechanism). The shadowed target is unreachable by bare slug.
**Fix:** resolve arc and goal separately; if both match, die with disambiguation (or require `@slug` to target the goal). Same in reopen.

**10. User slugs are never slugified — spaces/special chars create broken dir names**
`slugify()` exists (`bin/arcs:73`) but is never applied in `cmd_new_arc/new-goal/candidate`. `new-arc "my cool arc"` makes a literal-spaces dir; a slug with `/` silently nests an orphan invisible to `status`. Root cause of #6 and #20.
**Fix:** `slug="$(slugify "$slug")"; [ -n "$slug" ] || die` at the top of all three creators.

**11. `ln -sfn` nested-symlink footgun when the skill target is a real dir**
`install.sh:32` (and `bin/arcs:430`): if `~/.claude/skills/arcs` already exists as a *real* directory (prior cp install, interrupted run), `ln -sfn` creates `skills/arcs/skill →` one level deep, leaving the stale dir in place; Claude Code loads stale skill content. Re-triggers on every `arcs update`.
**Fix:** `[ -d "$SKILLS/arcs" ] && [ ! -L "$SKILLS/arcs" ] && rm -rf "$SKILLS/arcs"` before linking, both sites.

**12. Flagship landing example `arcs close stripe` fails — sub-arc needs `-g`**
`docs/index.html:194` shows `arcs close stripe` for a sub-arc of goal `payments`; the CLI requires `arcs close -g payments stripe` (the project's own `docs.html:519` gets this right). The page's most copy-pasteable command errors on run.
**Fix:** `arcs close -g payments stripe` with a `# -g points at the goal` note.

**13. Whole page (incl. H1/LCP) is `opacity:0` until JS runs — no `<noscript>` fallback**
`docs/index.html:34` + `style.css:339`: every `.reveal` starts invisible; only `app.js` restores it. JS blocked/failed → blank `<main>`, zero LCP text. (Reduced-motion users are spared via `style.css:341`.) Violates the project's own perf/a11y rules.
**Fix:** `<noscript><style>.reveal{opacity:1;transform:none}</style></noscript>`, or flip to visible-by-default with a synchronous `js` class opting into the hidden state.

**14. Command reference table claims completeness but omits `version`/`check-update`**
`docs/docs.html:315` says "The full set, exactly as bin/arcs dispatches them" then drops both real subcommands. *HIGH only because it explicitly claims completeness; no functional impact.*
**Fix:** add two rows mirroring `bin/arcs:454-455`.

---

## MEDIUM

- **`-g` with no operand crashes `$2: unbound variable`** — `bin/arcs:250,515,539` use bare `$2` under `set -u`. The safe `${2:-}` pattern already exists at lines 579/600. Fix: copy it.
- **promote creates a duplicate-slug arc when one already exists** — `bin/arcs:588`, no same-slug guard; then bare-slug `close` resolves to the *lowest* NN (the wrong/old arc). Fix: refuse/warn on existing open same-slug arc in `cmd_new_arc` (promote + supersede inherit it).
- **new-arc/new-goal silently bootstrap a config-less `.arcs/`** — `bin/arcs:19-22` auto-creates without writing `rules=subagents`; 7 other commands `die` "run: arcs init". *Verifier note: lang half is identical (en default), only `rules` diverges → MEDIUM.* Fix: add the init guard, or seed default config in `base_dir()`.
- **close output-guard wrongly applied to goals** — `bin/arcs:527-529` refuses to close a goal with empty own `output/` (its real output is closed sub-arcs), and the message says "arc". Trains reflexive `-f`. Fix: reuse the `*-goal.md` check at line 531 to skip the guard and fix the noun.
- **Candidate primitive has no drop/reject verb** — `cmd_candidate` is capture/list only; the only exit is promote (forces a real arc). Backlog only grows. Fix: add `arcs candidate drop <slug>`.
- **arc-vs-goal split rests on "purpose," which is undecidable; no arc→goal migration path** — docs conflate "no purpose" with "fits one chunk." Fix: re-anchor the decision rule on multi-step/needs-sub-arcs; add an "arc outgrew itself" note. (Verifier killed the "@ rename collides with close semantics" sub-claim — different syntactic slots.)
- **Orphan rule slug in config: status shows it, `rule list` hides it** — `bin/arcs:340` echoes raw `rules=`; `rule list` (line 467) only iterates existing bodies. Realistic via `arcs update` removing a global body. Fix: flag bodyless-but-enabled slugs in both surfaces.
- **`rule add <global-slug>` silently shadows the global with an empty stub + wrong "enable with" hint** — `bin/arcs:487` only guards local existence. Fix: warn on global-name collision and/or seed with the global body; suppress the hint when already on.
- **No `arcs rule rm`** — `rule off` only flips the switch; the local stub shadows forever, recoverable only by manual `rm`. Fix: add `rule rm <slug>`; distinguish override-of-global vs local-only in `list`.
- **`.arcs/` allowlist is a loose substring** — `gate:20` `*".arcs/"*` matches `notes.arcs/x.md`. Fix: drop the redundant second pattern; `*"/.arcs/"*` covers the real (absolute) bookkeeping path.
- **Breaking-update flag is shared across all projects with no override** — `gate:31` reads one machine-wide `.arcs-update-required`; `cmd_update` (`bin/arcs:418-425`) runs `git pull --ff-only || die` *before* the `rm`, so an offline/non-ff pull freezes every project. Fix: clear the flag once install ≥ floor regardless of pull outcome; document a manual `rm` in the block message.
- **Offline/failed fetch still stamps the 24h throttle** — `bin/arcs:395-396` `touch`es unconditionally after `|| true`. A first offline run decides the breaking floor against never-fetched refs and won't recheck for a day. Fix: capture fetch exit status; stamp only on success.
- **Breaking floor reads `origin/main:MIN_VERSION` (branch HEAD), not the released tag** — `bin/arcs:403` can force-block all users from an untagged WIP bump; contradicts the file's own "bumped at release time" comment. Fix: read from `v$latest:MIN_VERSION`.
- **Hardcoded `origin/main`** — `bin/arcs:403,395` silently disable the floor (`rmin→0.0.0`) on forks/renamed-default/non-`origin` clones. Fix: resolve default branch dynamically or fall back across main/master; or just document the canonical-clone requirement.
- **`arcs update` swallows `install.sh` failures** — `bin/arcs:428` `>/dev/null 2>&1 && echo`; a half-wire reports success (version bump still prints). Fix: `if ! bash install.sh >log 2>&1; then echo "re-wire failed — see log" >&2; fi`.
- **install.sh hook dedup matches by absolute path** — `install.sh:53-58` is append-only; relocating/re-cloning the repo leaves stale broken hook entries + duplicates. Fix: prune by command substring `/hooks/arcs-{hook,gate}` before re-adding.
- **CLI does no slug validation** (generic `fix`, spaces) — `bin/arcs:251`; spaces break the NN-* globbing the CLI relies on. Fix: slugify on creation (same as #10).
- **CSS cache-buster drift** — `docs.html:11` pins `?v=7`, `index.html:11` ships `?v=8`, same stylesheet → stale CSS for returning visitors. Fix: bump to v=8; better, drive from one source.
- **Enforcement docs omit the breaking-update hard-block** — `docs.html:444` describes only the no-open-arc block, not the `.arcs-update-required` gate. Fix: add a clause + tie into Updating.
- **Versioning subsystem absent from user docs** — `version`/`check-update`/breaking floor only in DEPLOY.md (maintainer), not `docs.html`. Fix: short subsection under Updating.
- **SPEC CLI list omits `version`/`check-update`/`help`** — `SPEC.md:229`. Fix: add them.
- **Dual numbering (candidates vs stream) collides on the board** — partly mitigated by the `CANDIDATES` header; only the NN echo (`bin/arcs:360`) is the real nit. Fix: drop/mark the candidate NN. *LOW-leaning.*
- **Release process has no consistency gate / no RELEASING.md** — `DEPLOY.md:86-93` 3-step happy path; nothing asserts VERSION == CHANGELOG-top == tag, nor updates CHANGELOG footer compare-links. Fix: add RELEASING.md + a `release-check` script.
- **`new-arc -g` arg labeled `<step>`** — `SKILL.md:21` contradicts the descriptive-slug rule two lines below; invites `step1`. Fix: `<descriptive-slug>`.
- **init README drops `es`** — `bin/arcs:230` writes `<en|ru>` while everything else supports es. (Listed twice across lenses; one fix.)

---

## LOW (batch)

`--from`/`-g` as trailing flag exits 1 silently (`shift 2` under `set -e`, `bin/arcs:565,579,600`) · mktemp temp leak on sed failure (no trap; verifier note: the real adjacent bug is *stale-write-silent-success* on close/reopen/supersede) · close error always says "already closed?" even when never created · close/reopen take first match on slug collision · no `arcs path/open <slug>` command · promote help omits the optional `<new-arc-slug>` · check-update silent no-op on non-clone vs update hard-error (inconsistent) · `candidate list` blocks slug `list` · SPEC passport omits `## input` that the template emits · "immutable goal" overstated (status + Where-we-are are live) · superseded arc with empty output/ not carved out of Invariants · `blocked` status absent from SKILL (and vestigial across the whole CLI) · scroll-spy non-deterministic active section · mobile header drops nav (index.html only) · `~/arcs` clone collides on re-run · README omits `supersede` · settings.json `.bak` overwritten on second changed install · install.sh RC selection ignores other rc files · leftover `.arcs-update-stamp` in root (ignored) · redundant `docs/.gitignore` · examples NN-vs-bare-slug duality unexplained · example spike arc.md omits `## input`.

---

## Quick wins (cheap, high value)

1. **Slugify on creation** (`bin/arcs` ×3) — single helper already exists; kills #10, #6, #18 at once.
2. **Fix the gate grep** (`gate:37`) — scope to open arc.md/`*-goal.md`, skip `__*__`; fixes the CRITICAL #1 + perf #41 + #38 in one edit.
3. **`${2:-}` for the three `-g` sites** — pattern already in the file at 579/600.
4. **Add SKILL steps for checklist + `closes:`** — turns the dead headline feature on.
5. **Doc one-liners:** add `version`/`check-update` to the table + SPEC; bump CSS to `?v=8`; fix `arcs close -g payments stripe`; `<en|ru|es>` in init README; add `supersede` to README list.

## Leave it (looks like a problem, is fine)

- **promote's `sort|tail -1` re-glob** — reliable under normal use (new arc always carries the highest NN; lexical==numeric for 2-digit pad). The real risk is the *other* commands' `head -1`, not promote.
- **Candidate `list` reserved word / NN duplication** — header disambiguates; obscure-name collision, near-zero impact.
- **`.arcs-update-stamp` in root / redundant `docs/.gitignore`** — gitignored / fully covered by the unanchored root pattern; cosmetic.
- **"Works without an agent" overclaim** (#48) — §04 already frames solo use as "a discipline"; LOW copy polish, not a contradiction.
- **The `@`-rename-vs-close-semantics collision** (cited in #25) — not real; different syntactic slots.

---

## Recommended next arcs (priority order)

1. **`@gate-enforcement-is-real`** *(goal)* — fix the status grep (#1), gate Bash + NotebookEdit (#3/#34), tighten the `.arcs/` allowlist (#37), and stop the docs calling it unqualifiedly "hard." This is the project's central promise and it's currently false.
2. **`@goal-checklist-actually-fires`** *(goal)* — wire `closes:` end-to-end: SKILL instructions for checklist + `closes:` (#29/#28), optional `--closes` flag, and validate-on-close with a typo warning (#23). The headline feature, dead today.
3. **`harden-slug-and-arg-handling`** *(arc)* — slugify on creation (#10/#18), escape supersede's sed (#6), `${2:-}` guards (#2), guard `shift 2` (#5). One sweep over input handling.
4. **`fix-goal-lifecycle-ops`** *(arc)* — supersede preserves goals (#16), `-g` works on closed goals or errors clearly (#17), close goal-guard + noun (#10/close), bare-slug ambiguity (#9).
5. **`docs-and-install-truthfulness`** *(arc)* — `ln -sfn` real-dir guard (#11), surface install.sh failures (#43), landing `close -g` (#12), `<noscript>` fallback (#13), command-table + versioning docs (#14/#52/#53), CSS cachebust (#50).
