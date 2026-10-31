#!/bin/bash
# BD2's head claim (head_rr2.sh's pattern): in BD2's worktree, detached at main, board_bd2.py head and one commit of the
# board; then the fast-forward of the shared checkout, only if main has not moved and no clause holds the head. The
# worktree is put back on its branch after.
# usage: head_bd2.sh WORKTREE
set -u
W=$1; R=/Users/ren/theories; K=$(cd "$(dirname "$0")" && pwd); B=_process/BECOMING-WORKBOARD.md
cd "$R" || exit 1
[ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD"; exit 3; }
base=$(git rev-parse main)
cd "$W" && [ -z "$(git status --porcelain --untracked-files=no)" ] || { echo "WORKTREE NOT CLEAN"; exit 2; }
branch=$(git branch --show-current)
git checkout -q --detach "$base" || exit 2
python3 -B "$K/board_bd2.py" head || { git checkout -q "$branch"; exit 2; }
[ "$(git diff --name-only)" = "$B" ] || { echo "UNEXPECTED PATHS"; git diff --name-only; git checkout -q -- $B; git checkout -q "$branch"; exit 2; }
git commit -q -m "Board: BD2 at the head of the queue (landing now: Becoming.GrammarCrossing, the grammar's not going out, and Becoming.ConveyanceBoundaries, the World's cut as it by definition and 04 §1's law on 07 §4.1's boundaries, joined to the core; «所经必同» proved from the step going out; one incremental core run; the record not-going-out-of-a-region and two records amended; 01 §9.9, 04 §1, 07 and the glossary; the records citing the changed sections re-pointed; render, strict check, links and tests, then the fast-forward)" -- $B
new=$(git rev-parse HEAD)
git checkout -q "$branch"
cd "$R"
[ "$(git rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; exit 4; }
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD; $new not landed"; exit 3; }
git merge --ff-only -q "$new" && echo "CLAIMED $new" || { echo "FF FAILED"; exit 5; }
