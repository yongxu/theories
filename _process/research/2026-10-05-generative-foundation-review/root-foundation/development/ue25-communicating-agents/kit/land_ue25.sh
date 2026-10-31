#!/bin/bash
# UE25's landing (land_rr.sh's pattern), in a landing worktree detached at main with UE25's head clause committed
# (claim_head_ue25.sh): the steps rehearse_ue25.sh rehearsed, the checker writing its run into the repository, then
# the board's landed clause and one commit of every changed path. The fast-forward is ff_ue25.sh's.
# usage: UE25_ORDER='...' land_ue25.sh WORKTREE ASIDE   (ASIDE a folder outside the repository, for logs and the
# earlier records; UE25_ORDER the coordinator's sentence naming what comes after UE25, given verbatim at the slot)
set -u
W=$1; ASIDE=$2
: "${UE25_ORDER:?set UE25_ORDER to the sentence the coordinator gives at the slot}"
K=$(cd "$(dirname "$0")" && pwd)
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
STUDY=_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md
C=_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY.py
cd "$W" || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
[ -z "$(git status --porcelain)" ]; step clean $?
git show -s --format=%s HEAD | grep -q '^Board: UE25 at the head of the queue'; step head-claim $?
mkdir -p "$ASIDE"
N=$(( $(grep -E '^## [0-9]+\. ' $STUDY | tail -1 | sed -E 's/^## ([0-9]+)\..*/\1/') + 1 ))
echo "study section $N"
python3 -B "$K/make_records_ue25.py" --caps > "$ASIDE/caps.log" 2>&1; step caps $?
python3 -B "$K/integrate_ue25.py" > "$ASIDE/integrate.log" 2>&1; step integrate $?
python3 -B "$K/texts_ue25.py" "$N" > "$ASIDE/texts.log" 2>&1; step texts $?
BEFORE=$(ls $PKG/becoming-checks | tail -1)
(cd $PKG && python3 -B check_becoming.py > "$ASIDE/check.log" 2>&1); step checker $?
ID=$(ls $PKG/becoming-checks | tail -1)
[ "$ID" != "$BEFORE" ]; step new-receipt $?
echo "receipt $ID, study section $N"
python3 -B "$K/reland_ue25.py" "$ID" "$N" "$ASIDE" > "$ASIDE/reland.log" 2>&1; step reland $?
python3 -B $C --check > "$ASIDE/conn1.log" 2>&1; echo "== connectivity before registering: exit $?"
python3 -B "$K/register_ue25.py" "$ASIDE/conn1.log" > "$ASIDE/register.log" 2>&1; step register $?
python3 -B $C --write > "$ASIDE/conn2.log" 2>&1; step connectivity-write $?
python3 -B $C --check > "$ASIDE/conn3.log" 2>&1; step connectivity-check $?
python3 -B tools/research/master_laws.py > "$ASIDE/master.log" 2>&1; step master-laws $?
make research-render > "$ASIDE/render1.log" 2>&1; echo "== render before re-pointing: exit $?"
python3 -B "$K/repoint_ue25.py" "$ID" > "$ASIDE/repoint-dry.log" 2>&1; step repoint-dry $?
python3 -B "$K/repoint_ue25.py" "$ID" --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
python3 -B "$K/board_ue25.py" land "$ID" "$N" "$UE25_ORDER" > "$ASIDE/board.log" 2>&1; step board $?
make research-render > "$ASIDE/render2.log" 2>&1; step render $?
for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
git commit -q -F - --pathspec-from-file="$ASIDE/paths.txt" <<MSG
UE25 landed: a code held as counts, learned from what is heard (\`Becoming.CountedCodes\` as a core leaf importing SharedCodes and FreeEnergyCounting, core receipt $ID, every axiom report empty, study §$N): under a determined law keeping the exchange of agents with a renaming of the words, from a start related to itself, two exchanged agents never hold one word as each one's uniquely greatest where the renaming moves every word and is onto, or the exchange is an involution; learning from what is heard keeps the relation where the speaker map commutes with the exchange and the rule reads count by count and commutes with renaming, adding what is heard among such rules, and so does a weight on what is heard read off the whole model where the renaming leaves it unchanged; the free-energy bound in counts is unchanged by a renaming permuting the words, and under weights a renaming moving every word fixes, with a positive total, a belief at the bound over a listing of every word names no word; witnesses for a preferred word and an asymmetric start. The record a-code-held-as-counts (home 05 §9) and UE1's record naming it among the third parts; the principle's page counts a fifth statement, the duet staying under the code law; 05's thesis, 08 §8, a correction section in UE1's search, the UE plan and FEP-INTEGRATION's item 10; the records citing the rewritten sections re-pointed, nothing they say changed; UE25's row in the history file. An independent adversarial review and its recheck, every point taken. Render, strict check, links and tests pass.
MSG
step commit $?
git log --oneline -1 | cut -c1-120
