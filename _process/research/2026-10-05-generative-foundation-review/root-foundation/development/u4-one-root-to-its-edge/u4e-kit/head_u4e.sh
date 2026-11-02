#!/bin/bash
# U4e's head claim (head_u4d.sh's pattern): in U4e's worktree, detached at main, board_u4e.py head and one commit of
# the board; then the fast-forward of the shared checkout, only if main has not moved and no clause holds the head.
# The worktree is put back on its branch after. Run it from a copy of the kit outside the worktree: main may not
# hold it.
# usage: U4E_SLOT="…" head_u4e.sh WORKTREE   (U4E_SLOT the coordinator's word that U4e is next, quoted verbatim)
set -u
[ -n "${U4E_SLOT:-}" ] || { echo "NO WORD FROM THE COORDINATOR (U4E_SLOT)"; exit 6; }
W=$1; R=/Users/ren/theories; K=$(cd "$(dirname "$0")" && pwd); B=_process/BECOMING-WORKBOARD.md
cd "$R" || exit 1
[ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD"; exit 3; }
base=$(git rev-parse main)
cd "$W" && [ -z "$(git status --porcelain --untracked-files=no)" ] || { echo "WORKTREE NOT CLEAN"; exit 2; }
branch=$(git branch --show-current)
git checkout -q --detach "$base" || exit 2
python3 -B "$K/board_u4e.py" head || { git checkout -q "$branch"; exit 2; }
[ "$(git diff --name-only)" = "$B" ] || { echo "UNEXPECTED PATHS"; git diff --name-only; git checkout -q -- $B; git checkout -q "$branch"; exit 2; }
git commit -q -m "Board: U4e at the head of the queue (landing now: Identity's covering laws finished, Web.arisingFrom_not_stopping_covered re-proved as the root's «有覆而亡屡则生不止» and the four census recurrence laws and Web.persisting_census dropping the decision binders their proofs do not use, every other statement unchanged; one core run; render, strict check, links, tests and both dossier checks, then the fast-forward)" -- $B
new=$(git rev-parse HEAD)
git checkout -q "$branch"
cd "$R"
[ "$(git rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; exit 4; }
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD; $new not landed"; exit 3; }
git merge --ff-only -q "$new" && echo "CLAIMED $new" || { echo "FF FAILED"; exit 5; }
