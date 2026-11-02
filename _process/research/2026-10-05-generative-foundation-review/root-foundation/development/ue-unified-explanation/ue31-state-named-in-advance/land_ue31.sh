#!/bin/bash
# UE31 (land_ue30.sh's pattern, documents and dry runs only), from the branch ue31-design.
#   head WORKTREE: in the landing worktree, detached at main, the head clause and one commit of the board; then the
#     fast-forward of the shared checkout, only if main has not moved and no clause holds the head.
#   land WORKTREE ASIDE: on that head claim, the experiment folder and this kit from the branch, the experiments
#     index row and 08 section 8's dated limit inserted by script (both files are shared), the seven records binding 08
#     re-pointed after reading, the dry runs re-run and compared byte for byte, the board's landed clause and row state, render, strict
#     check, links and tests on the exact tree, then one commit of every changed path.
#   ff COMMIT: the fast-forward, only if main is the commit's parent and the head clause is this landing's.
# usage: land_ue31.sh head WORKTREE | land_ue31.sh land WORKTREE ASIDE | land_ue31.sh ff COMMIT
set -u
R=/Users/ren/theories; K=$(cd "$(dirname "$0")" && pwd); B=_process/BECOMING-WORKBOARD.md
DEV=_process/research/2026-10-05-generative-foundation-review/root-foundation/development
KIT=$DEV/ue-unified-explanation/ue31-state-named-in-advance
EXP=experiments/state-named-in-advance
M08=theories/becoming/chapters/08-METHOD.md
FILES="$EXP $KIT"
HEAD_RE='^- \*\*Queue:\*\* UE31 at the head of the queue (landing now'
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
case "${1:-}" in
head)
  W=$2; cd "$R" || exit 1
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD"; exit 3; }
  base=$(git rev-parse main)
  cd "$W" && git checkout -q -f --detach "$base" && [ -z "$(git status --porcelain)" ] || { echo "WORKTREE NOT CLEAN"; exit 2; }
  python3 -B "$K/board_ue31.py" head || exit 2
  [ "$(git diff --name-only)" = "$B" ] || { echo "UNEXPECTED PATHS"; git diff --name-only; exit 2; }
  git commit -q -m "Board: UE31 at the head of the queue (landing now, by readiness: documents and dry runs only, no data, no Lean and no core run: the design of a test of T2's three numbers against the flour beetle's life stages, frozen before any value is read, with 08 section 8's one limit dated and the seven records binding 08 re-pointed after reading; render, strict check, links and tests, then the fast-forward)" -- $B
  new=$(git rev-parse HEAD); cd "$R" || exit 1
  [ "$(git rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; exit 4; }
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD; $new not landed"; exit 3; }
  git merge --ff-only -q "$new" && echo "CLAIMED $new" || { echo "FF FAILED"; exit 5; } ;;
land)
  W=$2; ASIDE=$3
  cd "$W" || exit 1; mkdir -p "$ASIDE"
  [ -z "$(git status --porcelain)" ]; step clean $?
  git show -s --format=%s HEAD | grep -q "^Board: UE31 at the head of the queue"; step head-claim $?
  git checkout ue31-design -- $FILES; step design-and-kit $?
  python3 -B "$K/board_ue31.py" index; step index-row $?
  python3 -B "$K/board_ue31.py" dated; step dated-08 $?
  REASON="UE31, with the coordinator's fix of 3 November 2026: in 08 section 8's item Where the possible grows, 'The adjacent possible that cannot be prestated (Longo, Montevil and Kauffman 2012) is outside' became 'These laws do not yet reach' it, 'none is stated for a space of rules not given with the carrier' (01, Open), so that a current limit is dated as 01 dates it. The seven records binding 08 by its whole bytes have their home sections in sections 4, 6 and 7, untouched, and none cites the changed item; nothing they say changes."
  python3 -B tools/research/repoint.py --reason "$REASON" --paths $M08 > "$ASIDE/repoint-dry.log" 2>&1; step repoint-dry $?
  grep -q '"records": 7' "$ASIDE/repoint-dry.log"; step repoint-seven $?
  python3 -B tools/research/repoint.py --reason "$REASON" --paths $M08 --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
  (cd $EXP && python3 -I -B dry_runs.py > "$ASIDE/dry.out" 2>&1); step dry-runs $?
  git diff --quiet -- $EXP/results && cmp -s "$ASIDE/dry.out" $EXP/results/dry.out; step dry-runs-reproduce $?
  python3 -B "$K/board_ue31.py" land > "$ASIDE/board.log" 2>&1; step board $?
  make research-render > "$ASIDE/render.log" 2>&1; step render $?
  for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
  grep -q '^Ran [0-9]* tests' "$ASIDE/research-test.log"; step ran-tests $?
  git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
  grep -q '\.build/\|\.lake/\|__pycache__' "$ASIDE/paths.txt" && { echo "BUILD OUTPUT IN THE PATHS"; exit 8; }
  git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
  git commit -q -F "$K/message.txt" --pathspec-from-file="$ASIDE/paths.txt"; step commit $?
  git log --oneline -1 | cut -c1-120 ;;
ff)
  NEW=$2; cd "$R" || exit 1
  [ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
  [ "$(git rev-parse main)" = "$(git rev-parse "$NEW^")" ] || { echo "MAIN MOVED"; exit 4; }
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q "$HEAD_RE" || { echo "HEAD NOT THIS LANDING'S"; exit 3; }
  [ -e "$EXP" ] && { echo "EXPERIMENT FOLDER IN THE SHARED CHECKOUT: compare it with $NEW:$EXP, then move it aside"; exit 6; }
  git merge --ff-only -q "$NEW" && echo "LANDED $NEW" || { echo "FF FAILED"; exit 5; } ;;
*) sed -n '2,9p' "$0"; exit 1 ;;
esac
