#!/bin/bash
# RV21c: the worktree put back to where land.sh began, after a stop past the merge (release_head.sh first, if the head
# is held). The merge is aborted if it is still open; the changes land.sh made are saved as a patch and every
# untracked file it wrote is moved, both into ASIDE/attempt-N/; then the branch is reset to the commit land.sh
# recorded before merging (ASIDE/pre-land-head.txt), the run commit gates.sh passed. Nothing is deleted: the
# reset discards only land.sh's own edits, which the patch keeps.
# usage: reset_land.sh WORKTREE ASIDE
set -u
W=$(cd "$1" && pwd) || exit 1; ASIDE=$(cd "$2" && pwd) || exit 1
PRE=$(cat "$ASIDE/pre-land-head.txt") || exit 1
cd "$W" || exit 1
[ "$(git branch --show-current)" = rv21c ] || { echo "NOT ON rv21c"; exit 2; }
git merge-base --is-ancestor "$PRE" HEAD || { echo "THE RECORDED COMMIT IS NOT IN THE BRANCH"; exit 2; }
n=1; while [ -e "$ASIDE/attempt-$n" ]; do n=$((n + 1)); done
A="$ASIDE/attempt-$n"; mkdir -p "$A"
[ -e "$(git rev-parse --git-dir)/MERGE_HEAD" ] && { git merge --abort || exit 3; }
git diff "$PRE" > "$A/changes.patch"
git log --oneline "$PRE..HEAD" > "$A/commits.txt"
git ls-files --others --exclude-standard | while IFS= read -r f; do
  mkdir -p "$A/files/$(dirname "$f")" && mv "$f" "$A/files/$f"
done
git reset -q --hard "$PRE" || exit 4
[ -z "$(git status --porcelain)" ] && echo "RESET to $(git rev-parse --short=9 HEAD); land.sh's attempt kept in $A" || { git status --short | head; exit 5; }
