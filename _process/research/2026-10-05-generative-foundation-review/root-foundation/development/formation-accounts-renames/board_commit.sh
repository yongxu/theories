#!/bin/bash
# FA's board-only commits on main, made without a worktree (claim_head.sh's pattern in RV21c's kit): a copy of main's
# board edited by board_fa.py, a temporary index on main's tree, commit-tree, then the fast-forward of the shared
# checkout only if main has not moved. The board is never edited in the shared checkout.
#   claim:   FA's row after RV21c's, only in a gap with no head clause.
#   head:    FA's head clause, only with no other clause holding the head and the row on the board.
#   release: FA's head clause dropped (REASON one clause), when land.sh stops after the head claim.
# usage: board_commit.sh claim|head ASIDE  |  board_commit.sh release ASIDE REASON
set -u
MODE=$1; ASIDE=$(cd "$2" && pwd) || exit 1; WHY=${3:-}
R=/Users/ren/theories; B=_process/BECOMING-WORKBOARD.md
# board_fa.py beside this script, wherever the kit folder is (it is moved aside before ff.sh).
KD=$(cd "$(dirname "$0")" && pwd) || exit 1
cd "$R" || exit 1
[ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
[ -e .git/MERGE_HEAD ] && { echo "SHARED CHECKOUT MID-MERGE"; exit 7; }
git diff --quiet -- $B || { echo "THE SHARED CHECKOUT'S BOARD HAS UNCOMMITTED CHANGES"; exit 2; }
base=$(git rev-parse main)
case "$MODE" in
  claim) MSG="Board: FA claimed (RV21c's prerequisite, routed by the coordinator: formation/formal/FormationAccounts.lean brought to 51a975fdd's three renames, AccountLaw, credited and support_trace_balance, which that rename sweep missed, so formal/check.py has failed on main since 6 October and RV21c's older-layout step cannot renew; the three identifiers only, each a pure rename; its receipt renewed in place; no record and no core run; one short head for the landing)";;
  head) MSG="Board: FA at the head of the queue (landing now: formation/formal/FormationAccounts.lean brought to 51a975fdd's three renames, its formal receipt renewed in place and the README's count of the conditional module's audits; no other Lean, no record and no core run; then render, strict check, links and tests, then the fast-forward)";;
  release) case "$WHY" in ''|*'); '*|*$'\n'*|*' | '*) echo "REASON must be one clause"; exit 2;; esac
           MSG="Board: FA's head clause released ($WHY); nothing of FA landed, its fix kept on its branch";;
  *) echo "usage: board_commit.sh claim|head ASIDE | release ASIDE REASON"; exit 2;;
esac
git show "$base:$B" > "$ASIDE/board-$MODE.md"
if [ "$MODE" = release ]; then
  python3 -B "$KD/board_fa.py" release "$ASIDE/board-$MODE.md" "$WHY" || exit 2
else
  python3 -B "$KD/board_fa.py" "$MODE" "$ASIDE/board-$MODE.md" || exit 2
fi
# claim adds one line; head and release change the Queue line only.
want=2; [ "$MODE" = claim ] && want=1
[ "$(git show "$base:$B" | diff - "$ASIDE/board-$MODE.md" | grep -c '^[<>]')" = $want ] || { echo "UNEXPECTED BOARD DIFF"; exit 2; }
blob=$(git hash-object -w "$ASIDE/board-$MODE.md")
export GIT_INDEX_FILE="$ASIDE/index-$MODE"
rm -f "$GIT_INDEX_FILE"
git read-tree "$base" && git update-index --cacheinfo 100644,"$blob",$B && tree=$(git write-tree) || exit 2
unset GIT_INDEX_FILE
new=$(git commit-tree "$tree" -p "$base" -m "$MSG")
[ "$(git rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; exit 4; }
if [ "$MODE" != release ]; then
  git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD; $new not landed"; exit 3; }
fi
git merge --ff-only -q "$new" && echo "$MODE: $new" || { echo "FF FAILED"; exit 5; }
echo "$new" > "$ASIDE/$MODE.txt"
