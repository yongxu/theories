#!/bin/bash
# U4e's claim row on main, in a gap (no head clause standing): the board read from main, board_u4e.py claim run on a
# copy outside the repository, the new board committed on main by plumbing (a temporary index, one path), then the
# shared checkout fast-forwarded, only if main has not moved, no clause holds the head and the shared checkout's
# board has no local change. Run from a copy of the kit outside the worktree: main does not hold it.
# usage: claim_u4e.sh
set -u
R=/Users/ren/theories; B=_process/BECOMING-WORKBOARD.md; K=$(cd "$(dirname "$0")" && pwd)
cd "$R" || exit 1
[ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
base=$(git rev-parse main)
git show "$base:$B" | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD"; exit 3; }
T=$(mktemp -d) || exit 2
mkdir -p "$T/_process" && git show "$base:$B" > "$T/$B" || exit 2
(cd "$T" && python3 -B "$K/board_u4e.py" claim) || exit 2
blob=$(git hash-object -w "$T/$B") || exit 2
GIT_INDEX_FILE="$T/index" git read-tree "$base" || exit 2
GIT_INDEX_FILE="$T/index" git update-index --cacheinfo "100644,$blob,$B" || exit 2
tree=$(GIT_INDEX_FILE="$T/index" git write-tree) || exit 2
[ "$(git diff-tree --name-only -r "$base" "$tree")" = "$B" ] || { echo "UNEXPECTED PATHS"; exit 2; }
new=$(git commit-tree "$tree" -p "$base" -m "Board: U4e claimed (Identity's covering laws finished: Web.arisingFrom_not_stopping_covered a case of the root's «有覆而亡屡则生不止»; the four census recurrence laws and Web.persisting_census without the decision binders their proofs do not use; RootForms.some_depends stating its witness and the certificates' docstrings; three core modules, one core run on the coordinator's word)") || exit 2
[ "$(git rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; exit 4; }
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD; $new not landed"; exit 3; }
git diff --quiet -- "$B" && git diff --cached --quiet -- "$B" || { echo "BOARD CHANGED LOCALLY IN THE SHARED CHECKOUT"; exit 8; }
git merge --ff-only -q "$new" && echo "CLAIMED $new" || { echo "FF FAILED"; exit 5; }
