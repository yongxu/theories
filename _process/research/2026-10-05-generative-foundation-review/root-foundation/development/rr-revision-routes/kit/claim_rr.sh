#!/bin/bash
# RR's head claim: in the landing worktree, detached at main, board_rr.py claim and one commit of the board; then the
# fast-forward of the shared checkout, only if main has not moved and no clause holds the head.
# usage: claim_rr.sh WORKTREE
set -u
W=$1; R=/Users/ren/theories; K=$(cd "$(dirname "$0")" && pwd); B=_process/BECOMING-WORKBOARD.md
cd "$R" || exit 1
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD"; exit 3; }
base=$(git rev-parse main)
cd "$W" && git checkout -q -f --detach "$base" && [ -z "$(git status --porcelain)" ] || { echo "WORKTREE NOT CLEAN"; exit 2; }
python3 -B "$K/board_rr.py" claim || exit 2
[ "$(git diff --name-only)" = "$B" ] || { echo "UNEXPECTED PATHS"; git diff --name-only; exit 2; }
git commit -q -m "Board: RR at the head of the queue (landing now: Becoming.RevisionRoutes joined as a core leaf importing only the prelude, with Becoming.ReadStages taking its order from it; one incremental core run; one new record and RF7's amended; 07 §7, 03 §11, 08, the overview, the alignment dossier and FAILURE-MODE-MAP §6; the citing records re-pointed; render, strict check, links and tests, then the fast-forward)" -- $B
new=$(git rev-parse HEAD)
cd "$R"
[ "$(git rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; exit 4; }
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD; $new not landed"; exit 3; }
git merge --ff-only -q "$new" && echo "CLAIMED $new" || { echo "FF FAILED"; exit 5; }
