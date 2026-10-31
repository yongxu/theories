#!/bin/bash
# RR2's head claim: in the landing worktree, detached at main, board_rr2.py head and one commit of the board; then the
# fast-forward of the shared checkout, only if main has not moved and no clause holds the head.
# usage: head_rr2.sh WORKTREE
set -u
W=$1; R=/Users/ren/theories; K=$(cd "$(dirname "$0")" && pwd); B=_process/BECOMING-WORKBOARD.md
cd "$R" || exit 1
[ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD"; exit 3; }
base=$(git rev-parse main)
cd "$W" && git checkout -q -f --detach "$base" && [ -z "$(git status --porcelain)" ] || { echo "WORKTREE NOT CLEAN"; exit 2; }
python3 -B "$K/board_rr2.py" head || exit 2
[ "$(git diff --name-only)" = "$B" ] || { echo "UNEXPECTED PATHS"; git diff --name-only; exit 2; }
git commit -q -m "Board: RR2 at the head of the queue (landing now: Becoming.RevisionPlans joined to the core below Becoming.HeldForReading, which derives from it its balances, ties, thresholds and comparisons with an amount forgone, and ListingValuation.forgone_lt_iff from its order; one incremental core run; one new record, RF-M.2's, RR's and RF-M.3's amended; 07 §7, 03 §12, 08 §8 and the alignment dossier; the citing records re-pointed; render, strict check, links and tests, then the fast-forward)" -- $B
new=$(git rev-parse HEAD)
cd "$R"
[ "$(git rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; exit 4; }
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD; $new not landed"; exit 3; }
git merge --ff-only -q "$new" && echo "CLAIMED $new" || { echo "FF FAILED"; exit 5; }
