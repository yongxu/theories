#!/bin/bash
# RV21c's head claim, after run.sh: one board-only commit on main made without a worktree (a temporary index and
# commit-tree on main's tree), then the fast-forward of the shared checkout, only if main has not moved and no clause
# holds the head. The board is never edited in the shared checkout. Before claiming, on main as it is now: the bytes
# every new receipt binds (sources and checkers) are still main's (verify_runs.py --no-write against main), and main's
# 08 §3 still names the core receipt the runs began from (texts.py --check on a copy of it), so nothing that would stop
# land.sh is found only after the head is held. The clause's counts come from the worktree's out/status.json.
# It also requires that run.sh's gates passed on the branch as it now stands (ASIDE/gates-passed, written by
# gates.sh), and checks the coordinator's order sentence and RV21c's row and the history file on copies of main's
# (board_rv21c.py check), so land.sh's board step cannot stop on them after the head is held; the sentence is kept in
# ASIDE/order.txt for land.sh.
# usage: claim_head.sh WORKTREE ASIDE ORDER   (ORDER: "Then, in the coordinator's order: ...; ask the coordinator
#        for a slot."; if a later step fails: release_head.sh ASIDE REASON)
set -u
W=$(cd "$1" && pwd) || exit 1; ASIDE=$(cd "$2" && pwd) || exit 1; ORDER=${3:-}
R=/Users/ren/theories; B=_process/BECOMING-WORKBOARD.md
H=_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md
K=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rv21c-fresh-receipts
ID=$(cat "$ASIDE/core-utc.txt") || exit 1
BASE=$(sed -n 's/^main //p' "$ASIDE/base.txt"); [ -n "$BASE" ] || exit 1
[ -n "$ORDER" ] || { echo "ORDER NOT GIVEN"; exit 2; }
[ "$(git -C "$W" branch --show-current)" = rv21c ] && [ -z "$(git -C "$W" status --porcelain)" ] || { echo "WORKTREE NOT CLEAN ON rv21c"; exit 2; }
[ -f "$ASIDE/gates-passed" ] && [ "$(cat "$ASIDE/gates-passed")" = "$(git -C "$W" rev-parse HEAD)" ] || { echo "RUN.SH'S GATES HAVE NOT PASSED ON THIS COMMIT (gates.sh)"; exit 2; }
cd "$R" || exit 1
[ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
[ -e .git/MERGE_HEAD ] && { echo "SHARED CHECKOUT MID-MERGE"; exit 7; }
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD"; exit 3; }
base=$(git rev-parse main)
# No toolchain or package file changed since the runs began.
git diff --name-only "$BASE" "$base" -- '*lean-toolchain' '*lakefile*' '*lake-manifest.json' | grep . && { echo "TOOLCHAIN OR PACKAGE FILES CHANGED"; exit 8; }
(cd "$W" && RV21C_CACHE="$ASIDE/lean-cache" python3 -B "$K/verify_runs.py" "$ID" "$base" --no-write) > "$ASIDE/verify-claim.txt" 2>&1 \
  || { tail -30 "$ASIDE/verify-claim.txt"; echo "BOUND BYTES DIFFER ON MAIN"; exit 8; }
git show "$base:theories/becoming/chapters/08-METHOD.md" > "$ASIDE/08-main.md"
(cd "$W" && python3 -B "$K/texts.py" --check "$ID" "$BASE" --chapter "$ASIDE/08-main.md" \
 ) > "$ASIDE/texts-claim.txt" 2>&1 \
  || { tail -5 "$ASIDE/texts-claim.txt"; echo "08 §3 ON MAIN"; exit 8; }
git show "$base:$B" > "$ASIDE/board-check.md"; git show "$base:$H" > "$ASIDE/history-check.md"
(cd "$W" && python3 -B "$K/board_rv21c.py" check "$ASIDE/board-check.md" "$ASIDE/history-check.md" "$ORDER") || { echo "ORDER OR BOARD NOT AS land() NEEDS"; exit 2; }
printf '%s\n' "$ORDER" > "$ASIDE/order.txt"
git show "$base:$B" > "$ASIDE/board-head.md"
(cd "$W" && python3 -B "$K/board_rv21c.py" head "$ASIDE/board-head.md") || exit 2
[ "$(git show "$base:$B" | diff - "$ASIDE/board-head.md" | grep -c '^[<>]')" = 2 ] || { echo "UNEXPECTED BOARD DIFF"; exit 2; }
git diff --quiet -- $B || { echo "THE SHARED CHECKOUT'S BOARD HAS UNCOMMITTED CHANGES"; exit 2; }
MSG="Board: RV21c at the head of the queue ($(python3 -B -c "import sys; sys.path.insert(0, '$W/$K'); import board_rv21c; print(board_rv21c.head_text())"))"
blob=$(git hash-object -w "$ASIDE/board-head.md")
export GIT_INDEX_FILE="$ASIDE/index-head"
rm -f "$GIT_INDEX_FILE"
git read-tree "$base" && git update-index --cacheinfo 100644,"$blob",$B && tree=$(git write-tree) || exit 2
unset GIT_INDEX_FILE
new=$(git commit-tree "$tree" -p "$base" -m "$MSG")
[ "$(git rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; exit 4; }
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD; $new not landed"; exit 3; }
git merge --ff-only -q "$new" && echo "CLAIMED $new" || { echo "FF FAILED"; exit 5; }
echo "$new" > "$ASIDE/head-claim.txt"
