#!/bin/bash
# GC2's board commits on main (claim_head_v13b.sh's pattern): in the check worktree, detached at main, board_gc2.py
# MODE (claim or head) and one commit of the board; then the fast-forward of the shared checkout, only if main has not
# moved and no clause holds the head.
# usage: claim_gc2.sh WORKTREE MODE
set -u
W=$1; MODE=$2; R=/Users/ren/theories; S=$(cd "$(dirname "$0")" && pwd); B=_process/BECOMING-WORKBOARD.md
case "$MODE" in
  claim) MSG="Board: GC2 claimed (the generativity chain's open proposals decided in one revision through its maintenance record: A1–A8, batch B's option, the retired labels, B1–B6 and DF's two registration-sense id renames, on the coordinator's word; documents only, no Lean, no new record and no core run)";;
  head) MSG="Board: GC2 at the head of the queue (landing now: the generativity chain's open proposals decided in one revision through its maintenance record, the two registration-sense ids renamed by research.py rename-id, every pending source read and the table rendered; documents only, no Lean, no new record and no core run; render, strict check, links, tests and both dossier checks, then the fast-forward)";;
  *) echo "MODE?"; exit 1;;
esac
cd "$R" || exit 1
[ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | cut -c14- | awk -F'; ' '{print $1}' | grep -q 'at the head' && { echo "HEAD HELD"; exit 3; }
base=$(git rev-parse main)
cd "$W" || exit 1
git checkout -q -f --detach "$base" && [ -z "$(git status --porcelain)" ] || { echo "WORKTREE NOT CLEAN"; exit 2; }
python3 -B "$S/board_gc2.py" "$MODE" "$B" || exit 2
[ "$(git diff --name-only)" = "$B" ] || { echo "UNEXPECTED PATHS"; git diff --name-only; exit 2; }
git diff --stat
git commit -q -m "$MSG" -- $B || exit 2
new=$(git rev-parse HEAD)
cd "$R" || exit 1
[ "$(git rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; exit 4; }
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | cut -c14- | awk -F'; ' '{print $1}' | grep -q 'at the head' && { echo "HEAD HELD; $new not landed"; exit 3; }
git merge --ff-only -q "$new" && echo "DONE $MODE $new" || { echo "FF FAILED"; exit 5; }
