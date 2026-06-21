#!/usr/bin/env bash
# scan.sh — read-only scanner over every .arcs/ project under the given roots.
# Emits a JS data block on stdout: const CLUSTERS={...}; const PROJECTS=[...]; const DIGEST={...};
# Pure bash + coreutils + git. NEVER writes into any scanned .arcs/. Part of the dashboard
# presentation layer (separate from arcs core) — see .arcs/.../33-arcs-dashboard-design.
set -euo pipefail

# Byte locale: read_capped truncates with `head -c`, which can cut a multibyte
# (e.g. Cyrillic) char mid-sequence. Under a UTF-8 locale macOS awk then dies with
# "towc: multibyte conversion failure". C locale treats input as raw bytes — the
# UTF-8 stays intact byte-for-byte in the emitted JS, and awk never converts.
export LC_ALL=C LANG=C

# --- helpers ---------------------------------------------------------------
# Emit a quoted JS string: escape \ and ", strip newlines/tabs/CR, collapse runs of space.
jstr() {
  local s="${1:-}"
  s="${s//\\/\\\\}"      # backslash first
  s="${s//\"/\\\"}"      # then double-quote
  s="${s//$'\n'/ }"; s="${s//$'\r'/ }"; s="${s//$'\t'/ }"
  printf '"%s"' "$s"
}

# JS string that PRESERVES line breaks (for embedding file content). Reads stdin,
# escapes \ and ", turns newlines into the literal \n escape. Caps at ~6KB.
jstr_multi() {   # reads stdin -> a quoted JS string literal
  awk 'BEGIN{n=0; printf "\""}
    { if(n++) printf "\\n";
      gsub(/\\/,"\\\\"); gsub(/"/,"\\\""); gsub(/\t/,"  "); gsub(/\r/,""); printf "%s",$0 }
    END{printf "\""}'
}
# read a text file, capped to a byte budget, only if it looks like text (md/txt/sh/json/etc)
read_capped() {   # <file> <maxbytes> -> text on stdout (empty if binary/too-weird)
  local f="$1" max="${2:-6000}"
  [ -f "$f" ] || return 0
  case "$f" in *.png|*.jpg|*.jpeg|*.gif|*.pdf|*.webp|*.zip|*.mp4|*.mov|*.bin) return 0 ;; esac
  # skip if it contains NULs (binary)
  LC_ALL=C grep -qI . "$f" 2>/dev/null || return 0
  head -c "$max" "$f" 2>/dev/null || true
}

# field <file> <key> -> first "key: value" value (leading template '<' / commented '#' skipped by caller)
field() { grep -m1 -E "^$2:" "$1" 2>/dev/null | sed -E "s/^$2:[[:space:]]*//" || true; }

# is a value a leftover template placeholder (starts with '<', or empty/dash)?
is_placeholder() { case "${1:-}" in ""|"<"*|"—"|"-") return 0 ;; *) return 1 ;; esac; }

# first real bullet/line under a "## <heading>" section in an arc.md (strip leading "- ")
section_first() {   # <file> <heading-regex>
  local f="$1" h="$2" line
  line=$(awk -v h="$h" '
    $0 ~ "^## " h { grab=1; next }
    grab && /^## / { exit }
    grab && /^[[:space:]]*$/ { next }
    grab { sub(/^[[:space:]]*[-*][[:space:]]*/,""); print; exit }
  ' "$f" 2>/dev/null || true)
  echo "$line"
}

read_supersedes() {   # <arc.md> -> bare slug from real (uncommented) supersedes:/prev:, '__' stripped
  local v
  v=$(grep -m1 -E '^(supersedes|prev):' "$1" 2>/dev/null \
        | sed -E 's/^(supersedes|prev):[[:space:]]*//' || true)
  v="${v#__}"; v="${v%__}"; echo "$v"
}

# strip NN- prefix and surrounding __ from a dir basename, KEEPING a leading @ (goal marker)
arc_slug() {   # <dirname> -> slug
  local n="$1"; n="${n#__}"; n="${n%__}"; n="${n#*-}"; echo "$n"
}
arc_num() {    # <dirname> -> integer NN (10# so leading zeros aren't octal)
  local n="$1"; n="${n#__}"; n="${n%%-*}"; echo "$((10#$n))"
}

# count sub-arc dirs inside a goal dir's arcs/ (open + closed)
count_subs() {   # <goal dir>
  local g="$1" c=0 d
  for d in "$g"/arcs/[0-9][0-9]*-*/ "$g"/arcs/__[0-9][0-9]*-*__/; do
    [ -d "$d" ] && c=$((c+1)) || true
  done
  echo "$c"
}

# --- theme palette (cycled across the template's existing --c-* vars) ------
THEME_VARS=(var\(--c-landing\) var\(--c-method\) var\(--c-cli\) var\(--c-release\) \
            var\(--c-quality\) var\(--c-infra\) var\(--c-bench\))
PROJ_PALETTE=(var\(--accent\) var\(--open\) var\(--goal\) var\(--accent-2\))

# --- discover projects -----------------------------------------------------
# bash 3.2 (macOS default) — no associative arrays; use plain indexed arrays + grep tables.
PROJ_DIRS=()
for root in "$@"; do
  [ -d "$root" ] || continue
  while IFS= read -r ad; do
    [ -n "$ad" ] || continue
    PROJ_DIRS+=("$(cd "$(dirname "$ad")/.." && pwd)")   # ad=<proj>/.arcs/arcs -> <proj>
    # prune heavy/irrelevant trees so a whole-$HOME scan stays fast; depth 8 covers
    # typical layouts (~/code/foo, ~/Documents/projects/foo) without trawling caches.
  done < <(find "$root" -maxdepth 8 \
             \( -name node_modules -o -name Library -o -name .Trash -o -name .git \
                -o -name .cache -o -name .npm -o -name .cargo -o -name Pictures \) -prune \
             -o -type d -name arcs -path '*/.arcs/arcs' -print 2>/dev/null || true)
done
# dedup, stable (newline-joined "seen" string)
DEDUP=()
SEEN=$'\n'
for p in "${PROJ_DIRS[@]:-}"; do
  [ -n "$p" ] || continue
  case "$SEEN" in *$'\n'"$p"$'\n'*) continue ;; esac
  SEEN="$SEEN$p"$'\n'; DEDUP+=("$p")
done
# drop nested + example/template projects: a project inside another project's tree
# (arcs' own examples/, template/, distribution/ fixtures) is not a real portfolio entry.
PROJECTS_UNIQ=()
for p in "${DEDUP[@]:-}"; do
  [ -n "$p" ] || continue
  case "$p" in */examples/*|*/template|*/template/*|*/node_modules/*) continue ;; esac
  nested=""
  for q in "${DEDUP[@]:-}"; do
    [ -n "$q" ] && [ "$q" != "$p" ] || continue
    case "$p" in "$q"/*) nested=1; break ;; esac
  done
  [ -n "$nested" ] && continue
  PROJECTS_UNIQ+=("$p")
done

# --- theme registry (filled as we scan) ------------------------------------
THEME_ORDER=()                  # insertion order
THEME_SEEN=$'\n'
note_theme() {
  local t="$1"
  case "$THEME_SEEN" in *$'\n'"$t"$'\n'*) return 0 ;; esac
  THEME_SEEN="$THEME_SEEN$t"$'\n'; THEME_ORDER+=("$t")
}

# --- per-project arc emission ----------------------------------------------
# emit_arcs <project dir> -> JS array elements (comma-separated objects), into stdout
emit_arcs() {
  local pd="$1" base="$pd/.arcs/arcs" d name slug n st isGoal goal sup theme rel inp out ws sub first=1
  # pass 1: index slug<TAB>n table (so supersedes can resolve to a numeric arc within the project)
  local NUM_TABLE=""
  for d in "$base"/[0-9][0-9]*-*/ "$base"/__[0-9][0-9]*-*__/; do
    [ -d "$d" ] || continue
    name=$(basename "$d"); slug=$(arc_slug "$name"); n=$(arc_num "$name")
    NUM_TABLE="$NUM_TABLE$slug	$n"$'\n'
  done
  # pass 1.5: last-activity per arc number (latest git commit touching its dir), one git
  # call for the whole project. Reverse-chron, so the first time we see an arc number is newest.
  local TS_TABLE=""
  if git -C "$pd" rev-parse --git-dir >/dev/null 2>&1; then
    TS_TABLE=$(git -C "$pd" log --format='C%ct' --name-only -- .arcs/arcs 2>/dev/null | awk '
      /^C[0-9]+$/ {ts=substr($0,2); next}
      index($0,".arcs/arcs/") {
        p=$0; sub(/.*\.arcs\/arcs\//,"",p); seg=p; sub(/\/.*/,"",seg);
        g=seg; sub(/^__/,"",g); sub(/-.*/,"",g); g=g+0;
        if(g>0 && !(g in seen)){seen[g]=ts}
      }
      END{for(k in seen)print k"\t"seen[k]}' || true)
  fi
  # pass 2: emit
  for d in "$base"/[0-9][0-9]*-*/ "$base"/__[0-9][0-9]*-*__/; do
    [ -d "$d" ] || continue
    name=$(basename "$d")
    slug=$(arc_slug "$name"); n=$(arc_num "$name")
    case "$name" in __*__) st="closed" ;; *) st="active" ;; esac
    case "$slug" in @*) isGoal=1 ;; *) isGoal=0 ;; esac

    # status/goal doc: goal arcs carry <slug>-goal.md, plain arcs carry arc.md
    local md=""
    if [ "$isGoal" = 1 ]; then md=$(ls "$d"/*-goal.md 2>/dev/null | sort | tail -1 || true); fi
    [ -n "$md" ] || md="$d/arc.md"

    goal=""; sup=""; theme="untagged"; rel="—"; inp=""; out=""; ws=0; sub=""
    if [ -f "$md" ]; then
      goal=$(field "$md" goal); is_placeholder "$goal" && goal=""
      theme=$(field "$md" theme); is_placeholder "$theme" && theme="untagged"
      rel=$(field "$md" release); is_placeholder "$rel" && rel="—"
      sup=$(read_supersedes "$md")
    fi
    # input/output first bullets come from arc.md (goals don't have ## input/## output)
    if [ -f "$d/arc.md" ]; then
      inp=$(section_first "$d/arc.md" 'input'); is_placeholder "$inp" && inp=""
      out=$(section_first "$d/arc.md" 'output'); is_placeholder "$out" && out=""
    fi
    # workspace file count
    if [ -d "$d/workspace" ]; then
      ws=$(find "$d/workspace" -type f 2>/dev/null | wc -l | tr -d ' ' || true)
      case "$ws" in ''|*[!0-9]*) ws=0 ;; esac
    fi
    # goal: count sub-arcs
    if [ "$isGoal" = 1 ]; then sub=$(count_subs "$d"); fi

    note_theme "$theme"

    # resolve from: superseding source arc's n within this project (omit if unresolvable)
    local fromN=""
    if [ -n "$sup" ]; then
      fromN=$(printf '%s' "$NUM_TABLE" | grep -m1 -F "$sup	" 2>/dev/null | cut -f2 || true)
    fi

    # full body text (the goal/arc.md the user actually reads) + on-disk path
    local dpath="${d%/}"
    local body=""; [ -f "$md" ] && body=$(read_capped "$md" 4000)
    # files: output (the result) → workspace (all current work, incl. nested) → input.
    # each {p:relpath,t:text}. cap 24 files/arc so a big workspace is fully readable.
    local files_js="" ffirst=1 fcount=0 sd ff rel_p txt
    for sd in output workspace input; do
      [ -d "$dpath/$sd" ] || continue
      while IFS= read -r ff; do
        [ -n "$ff" ] || continue
        [ "$fcount" -ge 24 ] && break
        txt=$(read_capped "$ff" 6000); [ -n "$txt" ] || continue
        rel_p="${ff#"$dpath"/}"
        [ "$ffirst" = 1 ] || files_js+=","
        ffirst=0; fcount=$((fcount+1))
        files_js+=$(printf '{p:%s,t:%s}' "$(jstr "$rel_p")" "$(printf '%s' "$txt" | jstr_multi)")
      done < <(find "$dpath/$sd" -maxdepth 3 -type f 2>/dev/null | sort || true)
    done

    [ "$first" = 1 ] || printf ',\n'
    first=0
    printf '  {n:%d,slug:%s,goal:%s,st:%s,cl:%s,rel:%s' \
      "$n" "$(jstr "$slug")" "$(jstr "$goal")" "$(jstr "$st")" "$(jstr "$theme")" "$(jstr "$rel")"
    [ "$isGoal" = 1 ] && printf ',isGoal:true,sub:%d' "$sub"
    [ -n "$inp" ] && printf ',inp:%s' "$(jstr "$inp")"
    [ -n "$out" ] && printf ',out:%s' "$(jstr "$out")"
    printf ',ws:%d' "$ws"
    [ -n "$fromN" ] && printf ',from:%d' "$fromN"
    # last-activity unix seconds (git); fall back to dir mtime
    local ts; ts=$(printf '%s' "$TS_TABLE" | grep -m1 -E "^$n	" 2>/dev/null | cut -f2 || true)
    [ -n "$ts" ] || ts=$(stat -f %m "$d" 2>/dev/null || stat -c %Y "$d" 2>/dev/null || true)
    [ -n "$ts" ] && printf ',ts:%s' "$ts"
    printf ',path:%s' "$(jstr "$dpath")"
    [ -n "$body" ] && printf ',body:%s' "$(printf '%s' "$body" | jstr_multi)"
    [ -n "$files_js" ] && printf ',files:[%s]' "$files_js"
    printf '}'
  done
}

# --- digest (git-derived facts) --------------------------------------------
# git commit count for a project since a given date (0 if no git)
git_count() {   # <proj dir> <since>  -> single integer
  local pd="$1" since="$2" c=0
  if git -C "$pd" rev-parse --git-dir >/dev/null 2>&1; then
    c=$(git -C "$pd" log --since="$since" --oneline -- . 2>/dev/null | wc -l | tr -d ' ' || true)
  fi
  case "$c" in ''|*[!0-9]*) c=0 ;; esac
  printf '%s' "$c"
}
# strip a conventional-commit prefix (feat:, fix(cli):, chore!: …) + trim
clean_subj() { printf '%s' "$1" | sed -E 's/^[a-zA-Z]+(\([^)]*\))?!?:[[:space:]]*//; s/^[[:space:]]+//'; }

# arcs CLOSED in span — a close renames NN-slug/ → __NN-slug__/, seen as a rename whose
# new path's dir is __…__ and whose file is arc.md or *-goal.md. (awk note: no '/' inside
# a [...] class — BWK awk on macOS treats it as the regex terminator — so we split on '/'.)
git_closed() {   # <pd> <since> -> lines "NN-slug" (deduped, max 8)
  local pd="$1" since="$2"
  git -C "$pd" rev-parse --git-dir >/dev/null 2>&1 || return 0
  git -C "$pd" log --since="$since" -M --name-status --diff-filter=R -- .arcs/arcs 2>/dev/null \
    | awk -F'\t' '$1 ~ /^R/ {
        nf=split($3,a,"/"); last=a[nf]; dir=a[nf-1];
        if ((last=="arc.md" || last ~ /-goal\.md$/) && dir ~ /^__.*__$/)
          print substr(dir,3,length(dir)-4) }' \
    | awk '!seen[$0]++' | head -8 || true
}
# arcs OPENED in span — a new arc.md / *-goal.md added (dir is NN-slug, not the __…__ form)
git_opened() {   # <pd> <since> -> lines "NN-slug"
  local pd="$1" since="$2"
  git -C "$pd" rev-parse --git-dir >/dev/null 2>&1 || return 0
  git -C "$pd" log --since="$since" --name-status --diff-filter=A -- .arcs/arcs 2>/dev/null \
    | awk -F'\t' '$1=="A" {
        nf=split($2,a,"/"); last=a[nf]; dir=a[nf-1];
        if ((last=="arc.md" || last ~ /-goal\.md$/) && dir ~ /^[0-9]/ && dir !~ /^__/)
          print dir }' \
    | awk '!seen[$0]++' | head -8 || true
}
# real release/ship subjects in span (version bump or release/publish wording; never a "close")
git_ships() {   # <pd> <since> -> lines "subject"
  local pd="$1" since="$2"
  git -C "$pd" rev-parse --git-dir >/dev/null 2>&1 || return 0
  git -C "$pd" log --since="$since" --pretty=format:'%s' -- . 2>/dev/null \
    | grep -iE 'release|publish|\bv?[0-9]+\.[0-9]+(\.[0-9]+)?\b' \
    | grep -ivE '\bclos(e|ed|ing)\b' \
    | awk '!seen[$0]++' | head -3 || true
}
# a couple of cleaned recent subjects, for a busy project with no arc/ship signal
git_recent() {   # <pd> <since> -> lines "subject"
  local pd="$1" since="$2"
  git -C "$pd" rev-parse --git-dir >/dev/null 2>&1 || return 0
  git -C "$pd" log --since="$since" --pretty=format:'%s' -- . 2>/dev/null | head -2 || true
}

# emit the per-span DIGEST object: <key> <since> <date label>
emit_digest_span() {
  local key="$1" since="$2" label="$3"
  local total=0 activeProj=0 pd
  # collect ACTIVE projects as "count<TAB>json" so we can sort by activity; idle ones listed apart
  local rows="" idle_js="" ifirst=1 left_js="" lfirst=1
  local busiest_id="" busiest_c=0
  for pd in "${PROJECTS_UNIQ[@]:-}"; do
    [ -n "$pd" ] || continue
    local id; id=$(basename "$pd")
    local c; c=$(git_count "$pd" "$since")
    if [ "$c" -le 0 ]; then
      [ "$ifirst" = 1 ] || idle_js+=","; ifirst=0; idle_js+=$(jstr "$id")
      continue
    fi
    total=$((total + c)); activeProj=$((activeProj+1))
    [ "$c" -gt "$busiest_c" ] && { busiest_c=$c; busiest_id=$id; } || true
    # build bullets from real outcomes: ship → close → open → fallback recent (cap 5)
    local bullets_js="" bfirst=1 nb=0 nclosed=0 nopened=0 line
    add_bullet() { [ "$nb" -ge 5 ] && return 0; nb=$((nb+1))
      [ "$bfirst" = 1 ] || bullets_js+=","; bfirst=0
      bullets_js+=$(printf '{k:%s,t:%s}' "$(jstr "$1")" "$(jstr "$2")"); }
    while IFS= read -r line; do [ -n "$line" ] || continue; add_bullet ship "$(clean_subj "$line")"; done < <(git_ships "$pd" "$since")
    while IFS= read -r line; do [ -n "$line" ] || continue; nclosed=$((nclosed+1)); add_bullet close "closed $line"; done < <(git_closed "$pd" "$since")
    while IFS= read -r line; do [ -n "$line" ] || continue; nopened=$((nopened+1)); add_bullet open "opened $line"; done < <(git_opened "$pd" "$since")
    if [ -z "$bullets_js" ]; then
      while IFS= read -r line; do [ -n "$line" ] || continue; add_bullet feat "$(clean_subj "$line")"; done < <(git_recent "$pd" "$since")
    fi
    # head: commits + a closed/opened tally when present
    local head="$c commit$([ "$c" -gt 1 ] && echo s)"
    [ "$nclosed" -gt 0 ] && head="$head · ${nclosed} closed"
    [ "$nopened" -gt 0 ] && head="$head · ${nopened} opened"
    rows+="$c"$'\t'"$(printf '{id:%s,head:%s,bullets:[%s]}' "$(jstr "$id")" "$(jstr "$head")" "$bullets_js")"$'\n'
    # what's-left: this project's currently-active arcs (from disk, span-independent)
    local base="$pd/.arcs/arcs" ad an aslug an2
    for ad in "$base"/[0-9][0-9]*-*/; do
      [ -d "$ad" ] || continue
      an=$(basename "$ad"); aslug=$(arc_slug "$an"); an2=$(arc_num "$an")
      [ "$lfirst" = 1 ] || left_js+=","; lfirst=0
      left_js+=$(jstr "$id · $(printf '%02d' "$an2")-$aslug")
    done
  done
  # sort active projects by commit count desc, join their json
  local proj_js; proj_js=$(printf '%s' "$rows" | sort -t$'\t' -k1,1 -rn | cut -f2- | paste -sd, - 2>/dev/null || true)
  # narrative: facts only — totals, busiest, idle count
  local idleN=0; [ -n "$idle_js" ] && idleN=$(printf '%s' "$idle_js" | awk -F'","' '{print NF}')
  local narr="<b>$total</b> commit$([ "$total" = 1 ] || echo s) across <b>$activeProj</b> active project$([ "$activeProj" = 1 ] || echo s)."
  [ -n "$busiest_id" ] && [ "$activeProj" -gt 1 ] && narr="$narr Busiest: <b>$busiest_id</b> ($busiest_c)."
  [ "$idleN" -gt 0 ] && narr="$narr $idleN idle."
  printf '%s:{date:%s,commits:%d,narr:%s,proj:[%s],idle:[%s],left:[%s]}' \
    "$key" "$(jstr "$label")" "$total" "$(jstr "$narr")" "$proj_js" "$idle_js" "$left_js"
}

# candidates surfaced in a project (.arcs/candidates/NN-slug.md) -> JS array elements
emit_cands() {   # <pd>
  local cdir="$1/.arcs/candidates" f slug from text first=1
  [ -d "$cdir" ] || return 0
  for f in "$cdir"/*.md; do [ -f "$f" ] || continue
    slug=$(basename "$f" .md)
    from=$(field "$f" from); is_placeholder "$from" && from=""
    text=$(grep -vE '^(#|from:)' "$f" 2>/dev/null | grep -m1 . || true)
    local body; body=$(read_capped "$f" 4000)
    [ "$first" = 1 ] || printf ','
    first=0
    printf '{slug:%s,from:%s,text:%s,body:%s}' "$(jstr "$slug")" "$(jstr "$from")" "$(jstr "$text")" "$(printf '%s' "$body" | jstr_multi)"
  done
}

# dated arc EVENTS across all projects (last 60 days): opened + closed, newest-first.
# each: {ts, k:"opened"|"closed", pid, slug}. Front-end groups by day + resolves arc detail.
emit_events() {
  local first=1 pd id ts k slug
  for pd in "${PROJECTS_UNIQ[@]:-}"; do
    [ -n "$pd" ] || continue
    id=$(basename "$pd")
    git -C "$pd" rev-parse --git-dir >/dev/null 2>&1 || continue
    while IFS=$'\t' read -r ts k slug; do
      [ -n "$slug" ] || continue
      [ "$first" = 1 ] || printf ','
      first=0
      printf '{ts:%s,k:%s,pid:%s,slug:%s}' "$ts" "$(jstr "$k")" "$(jstr "$id")" "$(jstr "$slug")"
    done < <(git -C "$pd" log --since="60 days ago" --format='C%ct' -M --name-status -- .arcs/arcs 2>/dev/null | awk '
      /^C[0-9]+$/ {ts=substr($0,2); next}
      $1 ~ /^R/ {
        nf=split($3,a,"/"); last=a[nf]; dir=a[nf-1];
        if((last=="arc.md"||last ~ /-goal\.md$/) && dir ~ /^__.*__$/){
          s=dir; sub(/^__/,"",s); sub(/__$/,"",s); sub(/^[0-9]+-/,"",s);
          key="C"ts"|"s; if(!(key in seen)){seen[key]=1; print ts"\tclosed\t"s} }
        next }
      $1=="A" {
        nf=split($2,a,"/"); last=a[nf]; dir=a[nf-1];
        if((last=="arc.md"||last ~ /-goal\.md$/) && dir ~ /^[0-9]/ && dir !~ /^__/){
          s=dir; sub(/^[0-9]+-/,"",s);
          key="O"ts"|"s; if(!(key in seen)){seen[key]=1; print ts"\topened\t"s} }
        next }')
  done
}

# --- assemble output -------------------------------------------------------
# 1) PROJECTS array (+ candidates)
PROJECTS_JS=""
pi=0
for pd in "${PROJECTS_UNIQ[@]:-}"; do
  [ -n "$pd" ] || continue
  id=$(basename "$pd")
  # path with $HOME -> ~
  path="$pd"; case "$path" in "$HOME"*) path="~${path#"$HOME"}" ;; esac
  pc="${PROJ_PALETTE[$((pi % ${#PROJ_PALETTE[@]}))]}"
  pi=$((pi+1))
  arcs_js="$(emit_arcs "$pd")"
  cands_js="$(emit_cands "$pd")"
  [ -n "$PROJECTS_JS" ] && PROJECTS_JS+=","
  PROJECTS_JS+=$(printf '{id:%s,name:%s,path:%s,pc:"%s",candidates:[%s],arcs:[\n%s\n]}' \
    "$(jstr "$id")" "$(jstr "$id")" "$(jstr "$path")" "$pc" "$cands_js" "$arcs_js")
done

# 2) CLUSTERS from themes actually seen (always include untagged)
CLUSTERS_JS=""; ci=0
add_cluster() {   # <key> <name> <cc>
  [ -n "$CLUSTERS_JS" ] && CLUSTERS_JS+=","
  CLUSTERS_JS+=$(printf '%s:{name:%s,cc:"%s"}' "$1" "$(jstr "$2")" "$3")
}
for t in "${THEME_ORDER[@]:-}"; do
  [ -n "$t" ] || continue
  [ "$t" = "untagged" ] && continue
  cc="${THEME_VARS[$((ci % ${#THEME_VARS[@]}))]}"
  ci=$((ci+1))
  add_cluster "$t" "$t" "$cc"
done
add_cluster "untagged" "untagged" "var(--ink-faint)"

# 3) DIGEST — a dated arc-event feed (opened/closed), newest-first; front-end groups by day
EVENTS_JS="$(emit_events)"

# --- print the JS block ----------------------------------------------------
printf 'const CLUSTERS={%s};\n' "$CLUSTERS_JS"
printf 'const PROJECTS=[%s];\n' "$PROJECTS_JS"
printf 'const DIGEST={events:[%s]};\n' "$EVENTS_JS"
