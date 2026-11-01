#!/bin/bash
# BD4's head claim (head_bd4.sh's pattern): in BD4's worktree, detached at main, board_bd4.py head and one commit of the
# board; then the fast-forward of the shared checkout, only if main has not moved and no clause holds the head. The
# worktree is put back on its branch after. Run it from a copy of the kit outside the worktree: main may not hold it.
# usage: head_bd4.sh WORKTREE
set -u
W=$1; R=/Users/ren/theories; K=$(cd "$(dirname "$0")" && pwd); B=_process/BECOMING-WORKBOARD.md
cd "$R" || exit 1
[ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD"; exit 3; }
base=$(git rev-parse main)
cd "$W" && [ -z "$(git status --porcelain --untracked-files=no)" ] || { echo "WORKTREE NOT CLEAN"; exit 2; }
branch=$(git branch --show-current)
git checkout -q --detach "$base" || exit 2
python3 -B "$K/board_bd4.py" head || { git checkout -q "$branch"; exit 2; }
[ "$(git diff --name-only)" = "$B" ] || { echo "UNEXPECTED PATHS"; git diff --name-only; git checkout -q -- $B; git checkout -q "$branch"; exit 2; }
git commit -q -m "Board: BD4 at the head of the queue (landing now: Becoming.BalanceRegions extended, each closure under adjacency among the listed relata, the grammar's «所闭», decided as a test, the balance law read on each closure, and at the unit grain a case of «类之对当且仅当类类等数»; a core leaf, no other module changed; one incremental core run; an eighth law on balance-from-conservation-along-a-relation; 01 §8.4's sentence; render, strict check, links and tests, then the fast-forward)" -- $B
new=$(git rev-parse HEAD)
git checkout -q "$branch"
cd "$R"
[ "$(git rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; exit 4; }
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD; $new not landed"; exit 3; }
git merge --ff-only -q "$new" && echo "CLAIMED $new" || { echo "FF FAILED"; exit 5; }
