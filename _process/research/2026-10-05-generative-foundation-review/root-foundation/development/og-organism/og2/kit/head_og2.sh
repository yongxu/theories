#!/bin/bash
# OG2's head claim (head_bd4.sh's pattern): in OG2's worktree, detached at main, board_og2.py head and one commit of the
# board; then the fast-forward of the shared checkout, only if main has not moved and no clause holds the head. The
# worktree is put back on its branch after. Run it from a copy of the kit outside the worktree: main may not hold it.
# usage: head_og2.sh WORKTREE
set -u
W=$1; R=/Users/ren/theories; K=$(cd "$(dirname "$0")" && pwd); B=_process/BECOMING-WORKBOARD.md
cd "$R" || exit 1
[ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD"; exit 3; }
base=$(git rev-parse main)
cd "$W" && [ -z "$(git status --porcelain --untracked-files=no)" ] || { echo "WORKTREE NOT CLEAN"; exit 2; }
branch=$(git branch --show-current)
git checkout -q --detach "$base" || exit 2
python3 -B "$K/board_og2.py" head || { git checkout -q "$branch"; exit 2; }
[ "$(git diff --name-only)" = "$B" ] || { echo "UNEXPECTED PATHS"; git diff --name-only; git checkout -q -- $B; git checkout -q "$branch"; exit 2; }
git commit -q -m "Board: OG2 at the head of the queue (landing now: Becoming.RuleRebuilding, a new instance of the ring on the grammar, no other module changed; one incremental core run; a new record with home 05 §12, 01's test-systems bullet, the status sentence on the one page and overview in both editions, 08's ring sentence and counts; then render, strict check, links, tests and both dossier checks, then the fast-forward)" -- $B
new=$(git rev-parse HEAD)
git checkout -q "$branch"
cd "$R"
[ "$(git rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; exit 4; }
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD; $new not landed"; exit 3; }
git merge --ff-only -q "$new" && echo "CLAIMED $new" || { echo "FF FAILED"; exit 5; }
