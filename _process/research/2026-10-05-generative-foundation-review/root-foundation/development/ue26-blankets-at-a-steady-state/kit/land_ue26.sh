#!/bin/bash
# UE26's landing (land_ue25.sh's pattern), in a landing worktree detached at main with UE26's head clause committed
# (claim_head_ue26.sh): the steps rehearse_ue26.sh rehearsed, both checkers writing their runs into the repository,
# then the board's landed clause and one commit of every changed path. The fast-forward is ff_ue26.sh's.
# usage: UE26_ORDER='...' land_ue26.sh WORKTREE ASIDE   (ASIDE a folder outside the repository, for logs and the
# earlier records; UE26_ORDER the coordinator's sentence naming what comes after UE26, given verbatim at the slot)
set -u
W=$1; ASIDE=$2
: "${UE26_ORDER:?set UE26_ORDER to the sentence the coordinator gives at the slot}"
K=$(cd "$(dirname "$0")" && pwd)
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
FE=experiments/integrated-correction/general-framework/generative-basis/lean/free-energy
STUDY=_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md
C=_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY.py
cd "$W" || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
[ -z "$(git status --porcelain)" ]; step clean $?
git show -s --format=%s HEAD | grep -q '^Board: UE26 at the head of the queue'; step head-claim $?
mkdir -p "$ASIDE"
N=$(( $(grep -E '^## [0-9]+\. ' $STUDY | tail -1 | sed -E 's/^## ([0-9]+)\..*/\1/') + 1 ))
echo "study section $N"
python3 -B "$K/make_records_ue26.py" --caps > "$ASIDE/caps.log" 2>&1; step caps $?
python3 -B "$K/integrate_ue26.py" > "$ASIDE/integrate.log" 2>&1; step integrate $?
python3 -B "$K/texts_ue26.py" "$N" > "$ASIDE/texts.log" 2>&1; step texts $?
BEFORE=$(ls $PKG/becoming-checks | tail -1)
(cd $PKG && python3 -B check_becoming.py > "$ASIDE/check.log" 2>&1); step checker $?
ID=$(ls $PKG/becoming-checks | tail -1)
[ "$ID" != "$BEFORE" ]; step new-receipt $?
(cd $FE && python3 -B check_linear_blankets.py > "$ASIDE/check-linear.log" 2>&1); step periphery-checker $?
LID=$(ls $FE/linear-blankets-checks | tail -1)
echo "core receipt $ID, periphery receipt $LID, study section $N"
python3 -B "$K/reland_ue26.py" "$ID" "$LID" "$N" "$ASIDE" > "$ASIDE/reland.log" 2>&1; step reland $?
python3 -B $C --check > "$ASIDE/conn1.log" 2>&1; echo "== connectivity before registering: exit $?"
python3 -B "$K/register_ue26.py" "$ASIDE/conn1.log" > "$ASIDE/register.log" 2>&1; step register $?
python3 -B $C --write > "$ASIDE/conn2.log" 2>&1; step connectivity-write $?
python3 -B $C --check > "$ASIDE/conn3.log" 2>&1; step connectivity-check $?
python3 -B tools/research/master_laws.py > "$ASIDE/master.log" 2>&1; step master-laws $?
make research-render > "$ASIDE/render1.log" 2>&1; echo "== render before re-pointing: exit $?"
python3 -B "$K/repoint_ue26.py" "$ID" > "$ASIDE/repoint-dry.log" 2>&1; step repoint-dry $?
python3 -B "$K/repoint_ue26.py" "$ID" --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
python3 -B "$K/board_ue26.py" land "$ID" "$LID" "$N" "$UE26_ORDER" > "$ASIDE/board.log" 2>&1; step board $?
make research-render > "$ASIDE/render2.log" 2>&1; step render $?
for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
git commit -q -F - --pathspec-from-file="$ASIDE/paths.txt" <<MSG
UE26 landed: the blanket at a steady state, conditional independence and what holds it (\`Becoming.BlanketWeights\` as a core leaf importing Blanket and Flow, core receipt $ID, every axiom report empty; \`LinearBlankets\` in the periphery, receipt $LID, Lean's standard axioms; study §$N). In the pure core: conditional independence given the blanket on the theory's conditioning is the cross form on listings listing each state once, restrict_independent its case at one blanket state; with positive weights, detailed balance of the internal moves within one closure of moves present at every external state, each move's rate ratio reading no external state, gives it, Kelly's proof at the internal site, sufficient and not necessary; witnesses: a lag relay losing it, a turning chain circulating and keeping it, moves reading the external state losing it, a synchronous copy keeping it exact and losing it with a miss. In the periphery, on real matrices: the Lyapunov equation as the Helmholtz form; footnote 13 as a law for any set of coordinates; the term-by-term corollaries of the 2023 paper's eq. 9; the Euler step of a sparsely coupled drift a blanketed law, with noise the agent's course fixed by its start, its noise and its sensory course; the synchronous steady precision keeping the four-part zero without circulation, and a circulating witness losing it, even under footnote 13 and eq. 9, a loss of the discrete step. Two records at 03 §1 and the blanket's record naming them; 08 §8, the principle's page (In brief, claim table, §1, §2, §5, Standing), the UE plan and FEP-INTEGRATION's item 11; the records citing the rewritten sections re-pointed, nothing they say changed; UE26's row in the history file. An independent review, a literature check, a recheck and a review of the Lean and the landing texts, every finding taken. Render, strict check, links and tests pass.
MSG
step commit $?
git log --oneline -1 | cut -c1-120
