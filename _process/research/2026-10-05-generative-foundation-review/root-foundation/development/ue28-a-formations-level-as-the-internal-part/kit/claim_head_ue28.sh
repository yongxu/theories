#!/bin/bash
# UE28's head claim (claim_head_ue27.sh's pattern): in the landing worktree, detached at main, board_ue28.py head and
# one commit of the board; then the fast-forward of the shared checkout, only if main has not moved and no clause holds
# the head.
# usage: claim_head_ue28.sh WORKTREE
set -u
W=$1; R=/Users/ren/theories; K=$(cd "$(dirname "$0")" && pwd); B=_process/BECOMING-WORKBOARD.md
cd "$R" || exit 1
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD"; exit 3; }
base=$(git rev-parse main)
cd "$W" && git checkout -q -f --detach "$base" && [ -z "$(git status --porcelain)" ] || { echo "WORKTREE NOT CLEAN"; exit 2; }
python3 -B "$K/board_ue28.py" head || exit 2
[ "$(git diff --name-only)" = "$B" ] || { echo "UNEXPECTED PATHS"; git diff --name-only; exit 2; }
git commit -q -m "Board: UE28 at the head of the queue (landing now: Becoming.BlanketCouplings extended with a formation's level as the internal part, along one run; one incremental core run; the record a-formations-couplings-as-its-blanket and the blanket's record amended; 03 §1, 08 §8 and the principle's page; the citing records re-pointed; render, strict check, links and tests, then the fast-forward)" -- $B
new=$(git rev-parse HEAD)
cd "$R"
[ "$(git rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; exit 4; }
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD; $new not landed"; exit 3; }
git merge --ff-only -q "$new" && echo "CLAIMED $new" || { echo "FF FAILED"; exit 5; }
