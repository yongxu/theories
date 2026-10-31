#!/bin/bash
# RR2's landing, in a landing worktree detached at main with RR2's head clause committed (head_rr2.sh): the steps
# rehearse_rr2.sh rehearsed, the checker writing its run into the repository, then the board's landed clause and one
# commit of every changed path. The fast-forward is ff_rr2.sh's.
# usage: land_rr2.sh WORKTREE ASIDE   (ASIDE a folder outside the repository, for logs and the amended records' earlier copies)
set -u
W=$1; ASIDE=$2
K=$(cd "$(dirname "$0")" && pwd)
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
STUDY=_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md
C=_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY.py
cd "$W" || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
[ -z "$(git status --porcelain)" ]; step clean $?
head -1 <(git show -s --format=%s HEAD) | grep -q '^Board: RR2 at the head of the queue'; step head-claim $?
mkdir -p "$ASIDE"
(cd /Users/ren/theories && python3 -B "$K/make_records_rr2.py" --caps) > "$ASIDE/caps.log" 2>&1; step caps $?
python3 -B "$K/integrate_rr2.py" > "$ASIDE/integrate.log" 2>&1; step integrate $?
BEFORE=$(ls $PKG/becoming-checks | tail -1)
(cd $PKG && python3 -B check_becoming.py > "$ASIDE/check.log" 2>&1); step checker $?
ID=$(ls $PKG/becoming-checks | tail -1)
[ "$ID" != "$BEFORE" ]; step new-receipt $?
N=$(( $(grep -E '^## [0-9]+\. ' $STUDY | tail -1 | sed -E 's/^## ([0-9]+)\..*/\1/') + 1 ))
echo "receipt $ID, study section $N"
python3 -B "$K/reland_rr2.py" "$ID" "$N" "$ASIDE" > "$ASIDE/reland.log" 2>&1; step reland $?
python3 -B $C --check > "$ASIDE/conn1.log" 2>&1; echo "== connectivity before registering: exit $?"
python3 -B "$K/register_rr2.py" "$ASIDE/conn1.log" > "$ASIDE/register.log" 2>&1; step register $?
python3 -B $C --write > "$ASIDE/conn2.log" 2>&1; step connectivity-write $?
python3 -B $C --check > "$ASIDE/conn3.log" 2>&1; step connectivity-check $?
python3 -B tools/research/master_laws.py > "$ASIDE/master.log" 2>&1; step master-laws $?
make research-render > "$ASIDE/render1.log" 2>&1; echo "== render before re-pointing: exit $?"
python3 -B "$K/repoint_rr2.py" "$ID" > "$ASIDE/repoint-dry.log" 2>&1; step repoint-dry $?
python3 -B "$K/repoint_rr2.py" "$ID" --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
python3 -B "$K/board_rr2.py" landed "$ID" "$N" > "$ASIDE/board.log" 2>&1; step board $?
make research-render > "$ASIDE/render2.log" 2>&1; step render $?
for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
git commit -q -F - --pathspec-from-file="$ASIDE/paths.txt" <<MSG
RR2 landed: holding for a reading against the routes of keeping a law, one order (\`Becoming.RevisionPlans\` joined to the core below \`Becoming.HeldForReading\`, core receipt $ID, every axiom report empty, study §$N): plans keeping a law going on and switching it off at a model's candidates, each with a loss of its own, on RR's order of a gain and a loss; the balance, every two plans splitting the weights gaining the same with their excesses, so that between them one stands above another exactly where its loss with its excess is below the other's; RR's revision and routes as plans on one candidate. \`HeldForReading\` derives from it its balances, ties, thresholds and comparisons with an amount forgone, holding for a rule being a plan whose excess is the rule's shortfall, every statement and name kept, its direct proofs gone (rule 9), and \`ListingValuation.forgone_lt_iff\` comes from its order, the change reviewed with RF's owner. The record when-holding-for-a-reading-stands-above-a-route (home 07 §7); RF-M.2's, RR's and RF-M.3's records amended; 03 §12, 07 §7, 08 §8 (with X19 of RF-M.3's cold read: RR's bullet points to the next), the alignment dossier, the root module's bullets, the checker's scope and both READMEs; RR's note §10; the records citing the rewritten sections re-pointed, nothing they say changed; RR2's row in the history file. An independent cross-model review and its re-check, every finding taken (REVIEW.md). Render, strict check, links and tests pass.
MSG
step commit $?
git log --oneline -1 | cut -c1-120
