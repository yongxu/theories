#!/bin/bash
# UE28's landing (land_ue27.sh's pattern, with no periphery), in a landing worktree detached at main with UE28's head
# clause committed (claim_head_ue28.sh): the steps rehearse_ue28.sh rehearsed, the checker writing its run into the
# repository, then the board's landed clause and one commit of every changed path. The fast-forward is ff_ue28.sh's.
# The landing needs the landing review (REVIEW-UE28-LANDING.md, LANDING_FINDINGS in make_records_ue28.py, the study
# section's paragraph on it) and the readings of the drifting records in repoint_ue28.py's READ.
# usage: UE28_ORDER='...' land_ue28.sh WORKTREE ASIDE   (ASIDE a folder outside the repository, for logs and the
# earlier records; UE28_ORDER the coordinator's sentence naming what comes after UE28, given verbatim at the slot)
set -u
W=$1; ASIDE=$2
: "${UE28_ORDER:?set UE28_ORDER to the sentence the coordinator gives at the slot}"
unset UE28_REHEARSAL
K=$(cd "$(dirname "$0")" && pwd)
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
STUDY=_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md
C=_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY.py
cd "$W" || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
[ -z "$(git status --porcelain)" ]; step clean $?
git show -s --format=%s HEAD | grep -q '^Board: UE28 at the head of the queue'; step head-claim $?
[ -e "$K/../REVIEW-UE28-LANDING.md" ]; step landing-review $?
mkdir -p "$ASIDE"
N=$(( $(grep -E '^## [0-9]+\. ' $STUDY | tail -1 | sed -E 's/^## ([0-9]+)\..*/\1/') + 1 ))
echo "study section $N"
python3 -B "$K/make_records_ue28.py" --caps > "$ASIDE/caps.log" 2>&1; step caps $?
python3 -B "$K/integrate_ue28.py" > "$ASIDE/integrate.log" 2>&1; step integrate $?
python3 -B "$K/texts_ue28.py" "$N" > "$ASIDE/texts.log" 2>&1; step texts $?
BEFORE=$(ls $PKG/becoming-checks | tail -1)
(cd $PKG && LEAN_TIMEOUT=2400 python3 -B check_becoming.py > "$ASIDE/check.log" 2>&1); step checker $?
ID=$(ls $PKG/becoming-checks | tail -1)
[ "$ID" != "$BEFORE" ]; step new-receipt $?
echo "core receipt $ID, study section $N"
python3 -B "$K/reland_ue28.py" "$ID" "$N" "$ASIDE" > "$ASIDE/reland.log" 2>&1; step reland $?
python3 -B $C --check > "$ASIDE/conn1.log" 2>&1; echo "== connectivity before registering: exit $?"
python3 -B "$K/register_ue28.py" "$ASIDE/conn1.log" > "$ASIDE/register.log" 2>&1; step register $?
python3 -B $C --write > "$ASIDE/conn2.log" 2>&1; step connectivity-write $?
python3 -B $C --check > "$ASIDE/conn3.log" 2>&1; step connectivity-check $?
python3 -B tools/research/master_laws.py > "$ASIDE/master.log" 2>&1; step master-laws $?
make research-render > "$ASIDE/render1.log" 2>&1; echo "== render before re-pointing: exit $?"
python3 -B "$K/repoint_ue28.py" "$ID" > "$ASIDE/repoint-dry.log" 2>&1; step repoint-dry $?
python3 -B "$K/repoint_ue28.py" "$ID" --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
python3 -B "$K/board_ue28.py" land "$ID" "$N" "$UE28_ORDER" > "$ASIDE/board.log" 2>&1; step board $?
make research-render > "$ASIDE/render2.log" 2>&1; step render $?
for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
DC=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/review-packet/check_dossiers.py
python3 -B $DC > "$ASIDE/dossiers-review.log" 2>&1; step dossiers-review $?
python3 -B $DC _process/research/2026-10-05-generative-foundation-review/root-foundation/development/ue8-sciences-dossier/SCIENCES.md > "$ASIDE/dossiers-sciences.log" 2>&1; step dossiers-sciences $?
git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
git commit -q -F - --pathspec-from-file="$ASIDE/paths.txt" <<MSG
UE28 landed: a formation's level as the internal part, along one run (\`Becoming.BlanketCouplings\` extended by a last part, the core leaf importing Blanket, Histories and IdentificationRuns, core receipt $ID, every axiom report empty; study §$N). Along one course with the step as the external part, some law determined part by part admits the course exactly where its agent is consistent, at any two steps alike on the internal, sensory and active states the next internal and active states agreeing; the world's half holds of every such course, the world's side the run read by the step; given the functions, the course is that of a blanketed law whose internal part moves by the sensory state at its own step, the converse not stated. On a balanced World run read with a formation's own level internal, a value across steps of what couples into it sensory (ValuesAcross; where admission is decided and the couplings listed, listed_values' value is one) and its act, its rows where it takes part, active, some law determined part by part admits the run exactly where at any two steps alike on its level, its admission, the levels coupled into it and its act, what is given to it at one step plus what is taken from it at the other is the same with the steps exchanged and its next acts agree, pairwise, with no subtraction, tested only where these recur. A drain in three phases from what does not couple in fails it for every value across steps; a drain and feed in two phases, the level recurring, meets it for any value, so whether what moves the level couples in does not decide the condition. Near-definitional, the elementary condition for one trajectory to come from a time-invariant deterministic state machine, stated on the World's exchange. The record a-formations-couplings-as-its-blanket amended (six laws, all 140 declarations cited once; statement, hypothesis, correspondence, does_not_show, a dependency and next step) and the blanket's record narrowed to a formation's other records, its level across a family of runs and a blanketed law for its level from consistency alone; 03 §1 (the blanket's reading, UE27's home section and a paragraph on the level), 08 §8, the principle's page (In brief, claim table, §1, §4, §5), the UE plan and FEP-INTEGRATION's item 13; the records citing the rewritten sections re-pointed, nothing they say changed; UE28's row in the history file. Independent reviews of the design and of the Lean, with probes, and of the landing texts and records, every finding taken. Render, strict check, links and tests pass.
MSG
step commit $?
git log --oneline -1 | cut -c1-120
