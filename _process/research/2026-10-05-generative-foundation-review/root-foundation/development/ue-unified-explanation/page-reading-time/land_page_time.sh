#!/bin/bash
# The principle's page's reading time (land_ue28.sh's pattern, documents only), in two parts.
#   claim WORKTREE: in the landing worktree, detached at main, the head clause and one commit of the board; then the
#     fast-forward of the shared checkout, only if main has not moved and no clause holds the head.
#   land WORKTREE ASIDE: on that head claim, the page and this kit from branch fep-reading-time, the four records'
#     re-points with their reading, the board's landed clause with ORDER (the coordinator's sentence, verbatim), render,
#     strict check, links, tests and both dossier checks on the exact tree, then one commit of every changed path.
#   ff COMMIT: the fast-forward, only if main is the commit's parent and the head clause is this landing's.
# usage: land_page_time.sh claim WORKTREE | ORDER='...' land_page_time.sh land WORKTREE ASIDE | land_page_time.sh ff COMMIT
set -u
R=/Users/ren/theories; K=$(cd "$(dirname "$0")" && pwd); B=_process/BECOMING-WORKBOARD.md
KIT=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue-unified-explanation/page-reading-time
PAGE=theories/becoming/FREE-ENERGY-PRINCIPLE.md
HEAD_RE="^- \*\*Queue:\*\* The principle's page's reading time at the head of the queue (landing now"
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
case "${1:-}" in
claim)
  W=$2; cd "$R" || exit 1
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD"; exit 3; }
  base=$(git rev-parse main)
  cd "$W" && git checkout -q -f --detach "$base" && [ -z "$(git status --porcelain)" ] || { echo "WORKTREE NOT CLEAN"; exit 2; }
  python3 -B "$K/board_page_time.py" head || exit 2
  [ "$(git diff --name-only)" = "$B" ] || { echo "UNEXPECTED PATHS"; git diff --name-only; exit 2; }
  git commit -q -m "Board: the principle's page's reading time at the head of the queue (landing now: documents only, no Lean, no result record and no core run: one line stating the page's reading time; the four records citing the page re-pointed; render, strict check, links, tests and both dossier checks, then the fast-forward)" -- $B
  new=$(git rev-parse HEAD); cd "$R" || exit 1
  [ "$(git rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; exit 4; }
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD; $new not landed"; exit 3; }
  git merge --ff-only -q "$new" && echo "CLAIMED $new" || { echo "FF FAILED"; exit 5; } ;;
land)
  W=$2; ASIDE=$3; : "${ORDER:?set ORDER to the sentence the coordinator gives}"
  cd "$W" || exit 1; mkdir -p "$ASIDE"
  [ -z "$(git status --porcelain)" ]; step clean $?
  git show -s --format=%s HEAD | grep -q "^Board: the principle's page's reading time at the head of the queue"; step head-claim $?
  git checkout fep-reading-time -- $PAGE $KIT; step page-and-kit $?
  [ "$(sed -n 3p $PAGE)" = "*About 50 minutes to read; in brief, about seven.*" ]; step the-line $?
  [ "$(git diff HEAD --numstat -- $PAGE)" = "$(printf '2\t0\t%s' $PAGE)" ]; step page-diff-two-lines $?
  REASON="the principle's page states its reading time, one line before its first section, by the AJ4 kit's measure; each of the four records citing the page by its whole bytes as an integration reference (a-code-held-as-counts, a-formations-couplings-as-its-blanket, the-blanket-at-a-steady-state, the-blanket-in-a-linear-steady-state) was read against it, the line adding no statement and changing none of the page's sections; nothing any of them says changed"
  python3 -B tools/research/repoint.py --reason "$REASON" --paths $PAGE > "$ASIDE/repoint-dry.log" 2>&1; step repoint-dry $?
  python3 -B -c "
import json,sys; d=json.load(open('$ASIDE/repoint-dry.log'))
want={'a-code-held-as-counts','a-formations-couplings-as-its-blanket','the-blanket-at-a-steady-state','the-blanket-in-a-linear-steady-state'}
assert set(d['by_record'])==want and d['records']==4, sorted(d['by_record'])
assert all(v['paths']==['$PAGE'] and v['rebound']==[] for v in d['by_record'].values())"; step repoint-exactly-four $?
  python3 -B tools/research/repoint.py --reason "$REASON" --paths $PAGE --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
  python3 -B "$K/board_page_time.py" land "$ORDER" > "$ASIDE/board.log" 2>&1; step board $?
  make research-render > "$ASIDE/render.log" 2>&1; step render $?
  for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
  grep -q '^Ran 305 tests' "$ASIDE/research-test.log"; step ran-305 $?
  DC=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/review-packet/check_dossiers.py
  python3 -B $DC > "$ASIDE/dossiers-review.log" 2>&1; step dossiers-review $?
  python3 -B $DC _process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue8-sciences-dossier/SCIENCES.md > "$ASIDE/dossiers-sciences.log" 2>&1; step dossiers-sciences $?
  git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
  git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
  git commit -q -F - --pathspec-from-file="$ASIDE/paths.txt" <<'MSG'
The principle's page states its reading time (documents only: no Lean, no result record and no core run). One line before its first section, "About 50 minutes to read; in brief, about seven.", by the AJ4 kit's measure (5,371 words, 41.3 to 53.7 minutes at 100 to 130 words a minute; In brief 772 words, 5.9 to 7.7), as AGENTS.md asks of each front; the page is already within an hour and its In brief within ten minutes, so nothing is cut. The four records citing the page by its whole bytes (a-code-held-as-counts, a-formations-couplings-as-its-blanket, the-blanket-at-a-steady-state, the-blanket-in-a-linear-steady-state) read against the line and re-pointed, nothing they say changed. The kit in the UE study (page-reading-time/). The board's landed clause with the coordinator's order, and the row in the history file. Render, strict check, links, the 305 tests and both dossier checks pass on this tree.
MSG
  step commit $?
  git log --oneline -1 | cut -c1-120 ;;
ff)
  NEW=$2; cd "$R" || exit 1
  [ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
  [ "$(git rev-parse main)" = "$(git rev-parse "$NEW^")" ] || { echo "MAIN MOVED"; exit 4; }
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q "$HEAD_RE" || { echo "HEAD NOT THIS LANDING'S"; exit 3; }
  [ -e "$KIT" ] && { echo "KIT FOLDER IN THE SHARED CHECKOUT: compare it with $NEW:$KIT, keep any difference under refs/salvage/, then move it aside"; exit 6; }
  git merge --ff-only -q "$NEW" && echo "LANDED $NEW" || { echo "FF FAILED"; exit 5; } ;;
*) sed -n '2,9p' "$0"; exit 1 ;;
esac
