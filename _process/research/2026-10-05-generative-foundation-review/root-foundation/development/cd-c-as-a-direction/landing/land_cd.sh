#!/bin/bash
# CD's landing, from branch c-direction in its own worktree (documents only: no Lean, no core run).
#   head: wait until OG2 has landed and no clause holds the head, then write CD's head clause into a commit on main's tip (a temporary
#     index, no checkout) and fast-forward the shared checkout, only if main has not moved and no clause holds the head.
#   land WORKTREE ASIDE: merge main into c-direction (generated pages from main, re-rendered; the rebinds log kept from
#     both sides; any other conflict stops), the board's landed clause and CD's row state, the landing kit copied into
#     the study, render, strict check, links, tests and both dossier checks on the exact tree, then one commit.
#   ff COMMIT BASE: the fast-forward, only if main is still BASE (the main merged in), BASE is an ancestor of COMMIT
#     and the head clause on main is CD's.
# usage: land_cd.sh head | land_cd.sh land WORKTREE ASIDE | land_cd.sh ff COMMIT BASE
set -u
R=/Users/ren/theories; T=/Users/ren/tmp/ranking; B=_process/BECOMING-WORKBOARD.md
DEV=_process/research/2026-10-05-generative-foundation-review/root-foundation/development
KIT=$DEV/cd-c-as-a-direction
MSG_HEAD="Board: CD at the head of the queue (landing now, by readiness, before the freeze: documents only, no Lean and no core run: C as a direction, its order read from the difference between options; the names test's two record renames and the shared law's label; premise-free 'ranks' restated in 07, 08 and eleven records; an independent check's findings taken, 07 section 5's sentence on what C ranks among them; a registry fix for renamed records; 24 records re-pointed after reading; render, strict check, links, tests and both dossier checks, then the fast-forward)"
queue() { git -C "$R" show main:$B | grep -m1 '^- \*\*Queue:\*\*'; }
held() { queue | grep -q '(landing now'; }
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
GENERATED='^(README\.md|RESULTS\.md|GOALS\.md|DEPENDENCIES\.md|_process/architecture/generated-manifest\.json|.*/INDEX\.md|_process/research/README\.md|theories/becoming/results/(records/.*\.md|THEORY-GRAPH\.md|RESULT-REGISTER\.md|completion/COMPLETION\.md|data/theory-graph\.json))$'
case "${1:-}" in
head)
  n=0
  while :; do
    n=$((n + 1)); [ "$n" -gt 2880 ] && { echo "GAVE UP after 24 hours"; exit 9; }
    queue | grep -q '^- \*\*Queue:\*\* CD at the head' && { echo "ALREADY AT THE HEAD $(git -C "$R" rev-parse --short main)"; exit 0; }
    if held; then sleep 30; continue; fi
    # The coordinator's order (3 November 2026): CD's slot is after OG2's landing, by readiness; a file
    # $T/go-without-og2 says the coordinator has released that wait.
    if [ ! -e "$T/go-without-og2" ] && ! git -C "$R" log 049e14ca1..main --format=%s | grep -Eq '^OG2.{0,60}landed'; then sleep 30; continue; fi
    [ "$(git -C "$R" branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
    base=$(git -C "$R" rev-parse main); tmp=$(mktemp -d)
    git -C "$R" show "$base:$B" > "$tmp/board" && python3 -B "$T/board_cd.py" head "$tmp/board" || { echo "BOARD TOOL FAILED"; exit 2; }
    blob=$(git -C "$R" hash-object -w "$tmp/board")
    GIT_INDEX_FILE="$tmp/index" git -C "$R" read-tree "$base" &&
      GIT_INDEX_FILE="$tmp/index" git -C "$R" update-index --cacheinfo "100644,$blob,$B" || { echo "INDEX FAILED"; exit 2; }
    tree=$(GIT_INDEX_FILE="$tmp/index" git -C "$R" write-tree)
    new=$(git -C "$R" commit-tree "$tree" -p "$base" -m "$MSG_HEAD")
    [ "$(git -C "$R" diff --name-only "$base" "$new")" = "$B" ] || { echo "UNEXPECTED PATHS"; exit 2; }
    [ "$(git -C "$R" rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; sleep 5; continue; }
    held && { echo "HEAD HELD; $new not landed"; continue; }
    git -C "$R" merge --ff-only -q "$new" 2>/dev/null && { echo "CLAIMED HEAD $new"; exit 0; }
    echo "FF FAILED"; exit 5
  done ;;
land)
  W=$2; A=$3; mkdir -p "$A"; cd "$W" || exit 1
  [ "$(git branch --show-current)" = c-direction ]; step on-branch $?
  [ -z "$(git status --porcelain)" ]; step clean $?
  queue | grep -q '^- \*\*Queue:\*\* CD at the head'; step head-is-cd $?
  base=$(git rev-parse main); echo "$base" > "$A/base"
  git merge --no-edit main > "$A/merge.log" 2>&1; m=$?
  if [ "$m" != 0 ]; then
    git diff --name-only --diff-filter=U > "$A/conflicts.txt"
    while read -r f; do
      if [ "$f" = _process/architecture/rebinds.jsonl ]; then
        python3 - "$f" <<'EOF' || exit 2
import json, sys
p = sys.argv[1]; lines = open(p).read().split('\n')
out, mode, ours, theirs = [], None, [], []
for l in lines:
    if l.startswith('<<<<<<< '): mode = 'o'; continue
    if l == '=======' and mode == 'o': mode = 't'; continue
    if l.startswith('>>>>>>> ') and mode == 't': out += theirs + ours; ours, theirs, mode = [], [], None; continue
    (ours if mode == 'o' else theirs if mode == 't' else out).append(l)
assert mode is None
for l in out:
    if l.strip(): json.loads(l)
open(p, 'w').write('\n'.join(out))
EOF
        git add "$f"
      elif echo "$f" | grep -Eq "$GENERATED"; then
        git checkout --theirs -- "$f" && git add "$f"
      else
        echo "CONFLICT TO READ BY HAND: $f"; exit 6
      fi
    done < "$A/conflicts.txt"
    git commit -q --no-edit; step merge-resolved $?
  fi
  step merge 0
  python3 -B "$T/board_cd.py" land $B; step board $?
  mkdir -p $KIT/landing && cp "$T/board_cd.py" "$T/land_cd.sh" "$T/message.txt" $KIT/landing/; step kit $?
  make research-render > "$A/render.log" 2>&1; step render $?
  make research-check-strict > "$A/strict.log" 2>&1; step strict $?
  make research-links > "$A/links.log" 2>&1; step links $?
  grep -q '"broken": 0' "$A/links.log"; step links-zero $?
  make research-test > "$A/test.log" 2>&1; step test $?
  grep -E '^(Ran |OK)' "$A/test.log"
  python3 -B $DEV/review-packet/check_dossiers.py > "$A/dos1.log" 2>&1; step dossiers $?
  python3 -B $DEV/review-packet/check_dossiers.py $DEV/ue8-sciences-dossier/SCIENCES.md > "$A/dos2.log" 2>&1; step sciences-dossier $?
  git status --porcelain --untracked-files=all | cut -c4- > "$A/paths.txt"
  grep -q '\.build/\|\.lake/\|__pycache__' "$A/paths.txt" && { echo "BUILD OUTPUT IN THE PATHS"; exit 8; }
  git add --pathspec-from-file="$A/paths.txt"; step add $?
  git commit -q -F "$T/message.txt" --pathspec-from-file="$A/paths.txt"; step commit $?
  echo "COMMIT $(git rev-parse HEAD) BASE $base" ;;
ff)
  NEW=$2; BASE=$3
  [ "$(git -C "$R" branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
  [ "$(git -C "$R" rev-parse main)" = "$BASE" ] || { echo "MAIN MOVED"; exit 4; }
  git -C "$R" merge-base --is-ancestor "$BASE" "$NEW" || { echo "BASE NOT AN ANCESTOR"; exit 4; }
  queue | grep -q '^- \*\*Queue:\*\* CD at the head' || { echo "HEAD NOT CD'S"; exit 3; }
  git -C "$R" merge --ff-only -q "$NEW" && echo "LANDED $NEW" || { echo "FF FAILED"; exit 5; } ;;
*) sed -n '2,11p' "$0"; exit 1 ;;
esac
