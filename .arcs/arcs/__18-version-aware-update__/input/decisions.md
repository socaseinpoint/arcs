# Request

End users on a git-clone of arcs should learn when a new release ships and update.
Some releases must be forced (breaking changes).

## Decisions (locked by user)

1. **Hardness**: soft-notice always + hard-force only on breaking releases.
   - Every session, if behind latest release → print a one-line nudge (non-blocking).
   - If local version < a remote-declared MIN_VERSION (breaking floor) → hard-block edits
     until `arcs update`.
2. **Version semantics**: SemVer git tags. "New version" = latest remote tag > local VERSION.
   Aligns with existing CHANGELOG + v0.1.0/v0.2.0 tags.
3. **Install model**: git-clone only. `arcs update` = `git pull` (as today). No curl-install.

## Gaps in current state

- No version baked into the CLI (`arcs version` is empty).
- `arcs update` pulls blindly — never tells the user something new exists.
- No "breaking floor" concept, so no way to force.
