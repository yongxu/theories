#!/bin/bash
# RR2's claim: in a worktree detached at main, the request's source file, the board row and the rendered indexes, one
# commit of those paths; then the fast-forward of the shared checkout, only if main has not moved and no clause holds
# the head. The shared checkout's untracked copy of the source is moved to ASIDE first and compared after.
# usage: claim_row_rr2.sh WORKTREE ASIDE
set -u
W=$1; ASIDE=$2; R=/Users/ren/theories; K=$(cd "$(dirname "$0")" && pwd); B=_process/BECOMING-WORKBOARD.md
S=sources/15-codex-theory-conversations/2026-10-31-join-and-unify.md
cd "$R" || exit 1
[ "$(git branch --show-current)" = main ] || { echo "SHARED CHECKOUT NOT ON MAIN"; exit 7; }
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD"; exit 3; }
base=$(git rev-parse main)
mkdir -p "$ASIDE"
cd "$W" && git checkout -q -f --detach "$base" && [ -z "$(git status --porcelain)" ] || { echo "WORKTREE NOT CLEAN"; exit 2; }
cp "$R/$S" "$S" || exit 2
python3 -B "$K/board_rr2.py" row || exit 2
make research-render > "$ASIDE/render.log" 2>&1 || { echo "RENDER FAILED"; exit 2; }
for t in research-check research-links; do make $t > "$ASIDE/$t.log" 2>&1 || { echo "$t FAILED"; exit 2; }; done
git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
cat "$ASIDE/paths.txt"
grep -qx "$B" "$ASIDE/paths.txt" && grep -qx "$S" "$ASIDE/paths.txt" || { echo "EXPECTED PATHS MISSING"; exit 2; }
git add --pathspec-from-file="$ASIDE/paths.txt" || exit 2
git commit -q --pathspec-from-file="$ASIDE/paths.txt" -m "Board: RR2 claimed (holding for a reading against the routes of keeping, one order): Becoming.RevisionPlans, a core module below HeldForReading, puts RR's routes of keeping a law and RF-M.2's value of holding an act for a reading on RR's order of a gain and a loss; its balance, every two plans splitting the weights gaining the same with their excesses, makes the order between them that of each one's own loss with its excess; RR's revision and routes are plans on one candidate, and HeldForReading proves from it its balances, ties, thresholds and comparisons with an amount forgone, every statement kept, the direct proofs gone (rule 9, with RF's owner); scratch build: RevisionPlans 33 theorems in 48 declarations, HeldForReading 97 in 127, every axiom report empty; core slot after RF-M.3; RR's note §10; record working title when-holding-for-a-reading-stands-above-a-route; the request of 31 October recorded as a source; indexes rendered" || exit 2
new=$(git rev-parse HEAD)
cd "$R"
[ "$(git rev-parse main)" = "$base" ] || { echo "MAIN MOVED; $new not landed"; exit 4; }
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '(landing now' && { echo "HEAD HELD; $new not landed"; exit 3; }
mv "$S" "$ASIDE/source.md" || exit 6
if git merge --ff-only -q "$new"; then
  echo "CLAIMED $new"; cmp "$ASIDE/source.md" "$S" && echo "same: source"
else
  mv "$ASIDE/source.md" "$S"; echo "FF FAILED; source put back"; exit 5
fi
