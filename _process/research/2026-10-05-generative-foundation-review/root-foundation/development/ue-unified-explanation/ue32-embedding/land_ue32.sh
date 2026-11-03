#!/bin/bash
# UE32's design landed (land_ue31b.sh's pattern), from the branch ue32, merged so that its freeze commit stays in
# main's history.
#   head WORKTREE: in the landing worktree, detached at main, the head clause and one commit of the board; then the
#     fast-forward of the shared checkout, only if main has not moved and no clause holds the head.
#   land WORKTREE ASIDE: on that head claim, the branch merged without committing (its own paths only: the design's
#     folder and this kit), the shared edits by script, the rules checked on one small synthetic archive (the dry runs,
#     about 13,700 seconds of CPU, are not rerun here: their output is committed with the code that wrote it), the
#     board's landed clause, render, strict check, links and tests on the exact tree, then the merge committed.
#   ff COMMIT: the fast-forward, only if main is the commit's first parent and the head clause is this landing's.
# usage: land_ue32.sh head WORKTREE | land_ue32.sh land WORKTREE ASIDE | land_ue32.sh ff COMMIT
set -u
R=/Users/ren/theories; B=_process/BECOMING-WORKBOARD.md
KIT=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue-unified-explanation/ue32-embedding
EXP=experiments/state-against-embedding
HEAD_RE="^- \*\*Queue:\*\* UE32 at the head of the queue (landing now"
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
case "${1:-}" in
head)
  W=$2; cd "$R" || exit 1
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD"; exit 3; }
  base=$(git rev-parse main)
  cd "$W" && git checkout -q -f --detach "$base" && [ -z "$(git status --porcelain)" ] || { echo "WORKTREE NOT CLEAN"; exit 2; }
  git show ue32:$KIT/board_ue32.py | python3 -B - head || exit 2
  [ "$(git diff --name-only)" = "$B" ] || { echo "UNEXPECTED PATHS"; git diff --name-only; exit 2; }
  git commit -q -m "Board: UE32 at the head of the queue (landing now, by readiness: documents and dry runs only, no data read or downloaded, no Lean and no core run: T2's named state against the field's fitted delay embedding on MQ5's fish stocks, frozen before any series is read by it, its download and run Ren's; the board and the experiments index; render, strict check, links and tests, then the fast-forward)" -- $B
  new=$(git rev-parse HEAD); cd "$R" || exit 1
  [ "$(git rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; exit 4; }
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD; $new not landed"; exit 3; }
  git merge --ff-only -q "$new" && echo "CLAIMED $new" || { echo "FF FAILED"; exit 5; } ;;
land)
  W=$2; ASIDE=$3
  cd "$W" || exit 1; mkdir -p "$ASIDE"
  [ -z "$(git status --porcelain)" ]; step clean $?
  git show -s --format=%s HEAD | grep -q "^Board: UE32 at the head of the queue"; step head-claim $?
  git merge --no-ff --no-commit ue32 > "$ASIDE/merge.log" 2>&1; step merge $?
  [ -z "$(git diff --name-only --diff-filter=U)" ]; step no-conflicts $?
  git diff --cached --name-only > "$ASIDE/merged-paths.txt"
  grep -v "^$EXP/\|^$KIT/" "$ASIDE/merged-paths.txt" && { echo "THE MERGE BROUGHT OTHER PATHS"; exit 6; }
  python3 -B "$KIT/board_ue32.py" edit > "$ASIDE/edit.log" 2>&1; step edit $?
  python3 -I -B "$EXP/dry_runs_embed.py" "$ASIDE/dry-check.json" 1 t2 age-late > "$ASIDE/dry-check.out" 2>&1; step dry-check $?
  python3 -B "$KIT/board_ue32.py" land > "$ASIDE/board.log" 2>&1; step board $?
  make research-render > "$ASIDE/render.log" 2>&1; step render $?
  for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
  grep -q '^Ran [0-9]* tests' "$ASIDE/research-test.log"; step ran-tests $?
  git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
  grep -q '\.build/\|\.lake/\|__pycache__\|\.xlsx$\|\.zip$' "$ASIDE/paths.txt" && { echo "BUILD OUTPUT IN THE PATHS"; exit 8; }
  git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
  git commit -q -F "$KIT/message.txt"; step commit $?
  git log --oneline -1 | cut -c1-120 ;;
ff)
  NEW=$2; cd "$R" || exit 1
  [ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
  [ "$(git rev-parse main)" = "$(git rev-parse "$NEW^1")" ] || { echo "MAIN MOVED"; exit 4; }
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q "$HEAD_RE" || { echo "HEAD NOT THIS LANDING'S"; exit 3; }
  git merge --ff-only -q "$NEW" && echo "LANDED $NEW" || { echo "FF FAILED"; exit 5; } ;;
*) sed -n '2,12p' "$0"; exit 1 ;;
esac
