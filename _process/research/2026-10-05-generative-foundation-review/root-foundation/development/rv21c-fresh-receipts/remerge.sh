#!/bin/bash
# RV21c: when main moves between land.sh and ff.sh by board-only commits (other sessions' claims under a held head),
# merge it into the landing branch again, check that the merge brought only board and history-file changes, render,
# run the strict check and links, commit what the render changed, and print the ff.sh line for the new main. Any
# other change on main, a conflict or a failed check stops it; then release the head and settle it.
# usage: remerge.sh WORKTREE ASIDE
set -u
W=$(cd "$1" && pwd) || exit 1; ASIDE=$(cd "$2" && pwd) || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || { echo "RV21c holds the head: release_head.sh $ASIDE '<reason>'"; exit "$2"; }; }
cd "$W" || exit 1
[ "$(git branch --show-current)" = rv21c ] && [ -z "$(git status --porcelain)" ]; step clean-branch $?
OLD=$(cat "$ASIDE/merged-main.txt") || exit 1; MAIN=$(git rev-parse main)
[ "$OLD" != "$MAIN" ] || { echo "main has not moved: ff.sh $(git rev-parse HEAD) $MAIN"; exit 0; }
git show main:_process/BECOMING-WORKBOARD.md | grep -m1 '^- \*\*Queue:\*\*' | grep -q '^- \*\*Queue:\*\* RV21c at the head of the queue (landing now'; step head-still-rv21c $?
git diff --name-only "$OLD" "$MAIN" | grep -v -e '^_process/BECOMING-WORKBOARD.md$' -e '^_process/history/workboard/' && { echo "MAIN CHANGED MORE THAN THE BOARD (above)"; step board-only 6; }
git merge -q --no-edit "$MAIN" > "$ASIDE/remerge.log" 2>&1; M=$?; cat "$ASIDE/remerge.log"
[ $M = 0 ] && [ -z "$(git diff --name-only --diff-filter=U)" ]; step merge $?
make research-render > "$ASIDE/remerge-render.log" 2>&1; step render $?
for t in research-check-strict research-links; do make $t > "$ASIDE/remerge-$t.log" 2>&1; step $t $?; done
if [ -n "$(git status --porcelain)" ]; then
  git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths-remerge.txt"
  git add --pathspec-from-file="$ASIDE/paths-remerge.txt" && git commit -q -m "RV21c: main merged again after board-only commits, the generated views rendered" --pathspec-from-file="$ASIDE/paths-remerge.txt"; step commit $?
fi
echo "$MAIN" > "$ASIDE/merged-main.txt"
echo "next: ff.sh $(git rev-parse HEAD) $MAIN"
