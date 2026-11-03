#!/bin/bash
# UE31's run landed (land_t2.sh's pattern), from the branch ue31-run, merged so that its step commits stay in main's
# history (each step was committed before the next, DESIGN §9).
#   head WORKTREE: in the landing worktree, detached at main, the head clause and one commit of the board; then the
#     fast-forward of the shared checkout, only if main has not moved and no clause holds the head.
#   land WORKTREE ASIDE: on that head claim, the branch merged without committing (its own paths only: the experiment's
#     folder, the source note and this kit), the shared edits by script, the fourteen records binding 02 and 08
#     re-pointed after reading, the board's landed clause, render, strict check, links, tests and the dossiers' check
#     on the exact tree, then the merge committed.
#   ff COMMIT: the fast-forward, only if main is the commit's first parent and the head clause is this landing's.
# usage: land_ue31_run.sh head WORKTREE | land_ue31_run.sh land WORKTREE ASIDE | land_ue31_run.sh ff COMMIT
set -u
R=/Users/ren/theories; B=_process/BECOMING-WORKBOARD.md
KIT=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue-unified-explanation/ue31-state-named-in-advance
DEV=_process/research/2026-10-05-generative-foundation-review/root-foundation/development
M02=theories/becoming/chapters/02-MAP.md
M08=theories/becoming/chapters/08-METHOD.md
HEAD_RE="^- \*\*Queue:\*\* UE31's run at the head of the queue (landing now"
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
case "${1:-}" in
head)
  W=$2; cd "$R" || exit 1
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD"; exit 3; }
  base=$(git rev-parse main)
  cd "$W" && git checkout -q -f --detach "$base" && [ -z "$(git status --porcelain)" ] || { echo "WORKTREE NOT CLEAN"; exit 2; }
  git show ue31-run:$KIT/board_ue31_run.py > /dev/null || exit 2
  git show ue31-run:$KIT/board_ue31_run.py | python3 -B - head || exit 2
  [ "$(git diff --name-only)" = "$B" ] || { echo "UNEXPECTED PATHS"; git diff --name-only; exit 2; }
  git commit -q -m "Board: UE31's run at the head of the queue (landing now, by the coordinator's word, before the freeze: documents and data only, no Lean and no core run, nothing downloaded by the landing; the run's three steps from its branch and its result where readers were told it had not run, with the sciences dossier's stale quotation of 08's T2 row; the fourteen records binding 02 and 08 re-pointed after reading; render, strict check, links, tests and the dossiers' check, then the fast-forward)" -- $B
  new=$(git rev-parse HEAD); cd "$R" || exit 1
  [ "$(git rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; exit 4; }
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD; $new not landed"; exit 3; }
  git merge --ff-only -q "$new" && echo "CLAIMED $new" || { echo "FF FAILED"; exit 5; } ;;
land)
  W=$2; ASIDE=$3
  cd "$W" || exit 1; mkdir -p "$ASIDE"
  [ -z "$(git status --porcelain)" ]; step clean $?
  git show -s --format=%s HEAD | grep -q "^Board: UE31's run at the head of the queue"; step head-claim $?
  git merge --no-ff --no-commit ue31-run > "$ASIDE/merge.log" 2>&1; step merge $?
  [ -z "$(git diff --name-only --diff-filter=U)" ]; step no-conflicts $?
  git diff --cached --name-only > "$ASIDE/merged-paths.txt"
  grep -v "^experiments/state-named-in-advance/\|^$KIT/\|^sources/15-codex-theory-conversations/2026-11-03-ue31-download-and-run.md$" "$ASIDE/merged-paths.txt" && { echo "THE MERGE BROUGHT OTHER PATHS"; exit 6; }
  python3 -B "$KIT/board_ue31_run.py" edit > "$ASIDE/edit.log" 2>&1; step edit $?
  REASON="UE31's run, 3 November 2026: T2's line in 02 section 5 and T2's Standing cell in 08's thesis table now say the frozen test ran and decided nothing, the cultures under a set loss too short for its rules, and the sign's condition names dense cultures as the design does. The fourteen records binding 02 or 08 by their whole bytes have their home sections elsewhere in those chapters, untouched, and none cites T2; nothing they say changes."
  python3 -B tools/research/repoint.py --reason "$REASON" --paths $M02 $M08 > "$ASIDE/repoint-dry.log" 2>&1; step repoint-dry $?
  grep -q '"records": 14' "$ASIDE/repoint-dry.log"; step repoint-fourteen $?
  python3 -B tools/research/repoint.py --reason "$REASON" --paths $M02 $M08 --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
  python3 -B "$KIT/board_ue31_run.py" land > "$ASIDE/board.log" 2>&1; step board $?
  make research-render > "$ASIDE/render.log" 2>&1; step render $?
  for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
  grep -q '^Ran [0-9]* tests' "$ASIDE/research-test.log"; step ran-tests $?
  python3 -B $DEV/review-packet/check_dossiers.py > "$ASIDE/dossiers.log" 2>&1; step dossiers $?
  python3 -B $DEV/review-packet/check_dossiers.py $DEV/ue8-sciences-dossier/SCIENCES.md > "$ASIDE/sciences.log" 2>&1; step sciences-dossier $?
  git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
  grep -q '\.build/\|\.lake/\|__pycache__' "$ASIDE/paths.txt" && { echo "BUILD OUTPUT IN THE PATHS"; exit 8; }
  git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
  git commit -q -F "$KIT/message_run.txt"; step commit $?
  git log --oneline -1 | cut -c1-120 ;;
ff)
  NEW=$2; cd "$R" || exit 1
  [ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
  [ "$(git rev-parse main)" = "$(git rev-parse "$NEW^1")" ] || { echo "MAIN MOVED"; exit 4; }
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q "$HEAD_RE" || { echo "HEAD NOT THIS LANDING'S"; exit 3; }
  git merge --ff-only -q "$NEW" && echo "LANDED $NEW" || { echo "FF FAILED"; exit 5; } ;;
*) sed -n '2,11p' "$0"; exit 1 ;;
esac
