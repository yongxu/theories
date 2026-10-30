#!/bin/bash
# RR's landing, in a landing worktree detached at main with RR's head clause committed (board_rr.py claim): the steps
# rehearse_rr.sh rehearsed, the checker writing its run into the repository, then the board's landed clause and one
# commit of every changed path. The fast-forward is ff_rr.sh's.
# usage: land_rr.sh WORKTREE ASIDE   (ASIDE a folder outside the repository, for logs and RF7's earlier record)
set -u
W=$1; ASIDE=$2
K=$(cd "$(dirname "$0")" && pwd)
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
STUDY=_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md
C=_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY.py
cd "$W" || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
[ -z "$(git status --porcelain)" ]; step clean $?
head -1 <(git show -s --format=%s HEAD) | grep -q '^Board: RR at the head of the queue'; step head-claim $?
mkdir -p "$ASIDE"
(cd /Users/ren/theories && python3 -B "$K/make_records_rr.py" --caps) > "$ASIDE/caps.log" 2>&1; step caps $?
python3 -B "$K/integrate_rr.py" > "$ASIDE/integrate.log" 2>&1; step integrate $?
BEFORE=$(ls $PKG/becoming-checks | tail -1)
(cd $PKG && python3 -B check_becoming.py > "$ASIDE/check.log" 2>&1); step checker $?
ID=$(ls $PKG/becoming-checks | tail -1)
[ "$ID" != "$BEFORE" ]; step new-receipt $?
N=$(( $(grep -E '^## [0-9]+\. ' $STUDY | tail -1 | sed -E 's/^## ([0-9]+)\..*/\1/') + 1 ))
echo "receipt $ID, study section $N"
python3 -B "$K/reland_rr.py" "$ID" "$N" "$ASIDE" > "$ASIDE/reland.log" 2>&1; step reland $?
python3 -B $C --check > "$ASIDE/conn1.log" 2>&1; echo "== connectivity before registering: exit $?"
python3 -B "$K/register_rr.py" "$ASIDE/conn1.log" > "$ASIDE/register.log" 2>&1; step register $?
python3 -B $C --write > "$ASIDE/conn2.log" 2>&1; step connectivity-write $?
python3 -B $C --check > "$ASIDE/conn3.log" 2>&1; step connectivity-check $?
python3 -B tools/research/master_laws.py > "$ASIDE/master.log" 2>&1; step master-laws $?
make research-render > "$ASIDE/render1.log" 2>&1; echo "== render before re-pointing: exit $?"
python3 -B "$K/repoint_rr.py" "$ID" > "$ASIDE/repoint-dry.log" 2>&1; step repoint-dry $?
python3 -B "$K/repoint_rr.py" "$ID" --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
python3 -B "$K/board_rr.py" landed "$ID" "$N" > "$ASIDE/board.log" 2>&1; step board $?
make research-render > "$ASIDE/render2.log" 2>&1; step render $?
for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
git commit -q -F - --pathspec-from-file="$ASIDE/paths.txt" <<MSG
RR landed: corrigibility on the map, a revision and the routes of keeping a law (\`Becoming.RevisionRoutes\` as a core leaf importing only the prelude, core receipt $ID, every axiom report empty, study §$N): the order of a gain and a loss; when no route of keeping a formation's law stands above letting a revision of it go through, ties included; its exits; robustness at every loss of the routes and every value; restoring the revised-from law as the lever. \`Becoming.ReadStages\` takes its order from it, every statement and name kept, with RF7's four plans as a revision with three routes and complying at both maximal exactly where k_C V = k_O V = c T = 0. The record when-no-route-stands-above-a-revision (home 07 §7) and RF7's record amended as its owner asked; 03 §11 with RF's two edits, 08, the overview, the alignment dossier's corrigibility bullet with RF-M.2's sentence kept, FAILURE-MODE-MAP §6 as its owner agreed; the records citing the rewritten sections re-pointed, nothing they say changed; RR's row in the history file. An independent cross-model review, every finding taken (REVIEW.md). Render, strict check, links and tests pass.
MSG
step commit $?
git log --oneline -1 | cut -c1-120
