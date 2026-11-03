#!/bin/bash
# UE30 (land_page_time.sh's pattern, documents only), on the branch ue30-hang-off merged with main.
#   head WORKTREE: in the landing worktree, detached at main, the head clause and one commit of the board; then the
#     fast-forward of the shared checkout, only if main has not moved and no clause holds the head.
#   land WORKTREE ASIDE: on that head claim, the texts and this kit from the branch, the records' re-points with their
#     reading, the board's landed clause with ORDER (the coordinator's sentence, verbatim), render, strict check, links,
#     tests and both dossier checks on the exact tree, then one commit of every changed path.
#   ff COMMIT: the fast-forward, only if main is the commit's parent and the head clause is this landing's.
# usage: land_ue30.sh head WORKTREE | ORDER='...' land_ue30.sh land WORKTREE ASIDE | land_ue30.sh ff COMMIT
set -u
R=/Users/ren/theories; K=$(cd "$(dirname "$0")" && pwd); B=_process/BECOMING-WORKBOARD.md
DEV=_process/research/2026-10-05-generative-foundation-review/root-foundation/development
KIT=$DEV/ue-unified-explanation/ue30-hang-off
PAGE=theories/becoming/FREE-ENERGY-PRINCIPLE.md
M08=theories/becoming/chapters/08-METHOD.md
M01=theories/becoming/chapters/01-ROOT.md
SCI=$DEV/ue8-sciences-dossier/SCIENCES.md
FILES="$PAGE $M08 $M01 $SCI $DEV/ue8-sciences-dossier/README.md $KIT"
HEAD_RE='^- \*\*Queue:\*\* UE30 at the head of the queue (landing now'
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
case "${1:-}" in
head)
  W=$2; cd "$R" || exit 1
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD"; exit 3; }
  base=$(git rev-parse main)
  cd "$W" && git checkout -q -f --detach "$base" && [ -z "$(git status --porcelain)" ] || { echo "WORKTREE NOT CLEAN"; exit 2; }
  python3 -B "$K/board_ue30.py" head || exit 2
  [ "$(git diff --name-only)" = "$B" ] || { echo "UNEXPECTED PATHS"; git diff --name-only; exit 2; }
  git commit -q -m "Board: UE30 at the head of the queue (landing now: documents only, no Lean, no result record and no core run: the principle's page and the sciences dossier hung off the one path; 08 section 8's count of the principle's third parts; what would defeat the central reading, argued in a note with its home in 08 section 9 and 01's two sentences on the claim; the records citing the page, 08 and 01 re-pointed after reading; render, strict check, links, tests and both dossier checks, then the fast-forward)" -- $B
  new=$(git rev-parse HEAD); cd "$R" || exit 1
  [ "$(git rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; exit 4; }
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD; $new not landed"; exit 3; }
  git merge --ff-only -q "$new" && echo "CLAIMED $new" || { echo "FF FAILED"; exit 5; } ;;
land)
  W=$2; ASIDE=$3; : "${ORDER:?set ORDER to the sentence the coordinator gives}"
  cd "$W" || exit 1; mkdir -p "$ASIDE"
  [ -z "$(git status --porcelain)" ]; step clean $?
  git show -s --format=%s HEAD | grep -q "^Board: UE30 at the head of the queue"; step head-claim $?
  [ -z "$(git diff HEAD ue30-hang-off --name-only -- $M08 | head -1)" ] || git merge-base --is-ancestor HEAD^ ue30-hang-off; step branch-holds-main $?
  git checkout ue30-hang-off -- $FILES; step texts-and-kit $?
  REASON="UE30: the principle's page gains a line up to the path, In brief re-cut into short lists with every condition kept, what forbids nothing on both sides and a section on what would count against it; 08 section 8 counts the principle's containment's five third parts, as the page does; 08 section 9 gains the explanatory reading as a philosophical thesis with what would defeat each of its senses; 01's two sentences on that claim now say so. Each record citing the page, 08 or 01 by its whole bytes read against the new text: the page's four as integrations of laws it still states, 08's seven and 01's twelve with their home sections elsewhere in the file and untouched; none cites the changed sentences; nothing they say changes."
  python3 -B tools/research/repoint.py --reason "$REASON" --paths $PAGE $M08 $M01 > "$ASIDE/repoint-dry.log" 2>&1; step repoint-dry $?
  python3 -B tools/research/repoint.py --reason "$REASON" --paths $PAGE $M08 $M01 --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
  python3 -B "$K/board_ue30.py" land "$ORDER" > "$ASIDE/board.log" 2>&1; step board $?
  make research-render > "$ASIDE/render.log" 2>&1; step render $?
  for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
  grep -q '^Ran [0-9]* tests' "$ASIDE/research-test.log"; step ran-tests $?
  DC=$DEV/review-packet/check_dossiers.py
  python3 -B $DC > "$ASIDE/dossiers-review.log" 2>&1; step dossiers-review $?
  python3 -B $DC $SCI > "$ASIDE/dossiers-sciences.log" 2>&1; step dossiers-sciences $?
  git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
  grep -q '\.build/\|\.lake/' "$ASIDE/paths.txt" && { echo "BUILD OUTPUT IN THE PATHS"; exit 8; }
  git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
  git commit -q -F "$K/message.txt" --pathspec-from-file="$ASIDE/paths.txt"; step commit $?
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
