#!/bin/bash
# UE27's landing (land_ue26.sh's pattern, with no periphery), in a landing worktree detached at main with UE27's head
# clause committed (claim_head_ue27.sh): the steps rehearse_ue27.sh rehearsed, the checker writing its run into the
# repository, then the board's landed clause and one commit of every changed path. The fast-forward is ff_ue27.sh's.
# usage: UE27_ORDER='...' land_ue27.sh WORKTREE ASIDE   (ASIDE a folder outside the repository, for logs and the
# earlier records; UE27_ORDER the coordinator's sentence naming what comes after UE27, given verbatim at the slot)
set -u
W=$1; ASIDE=$2
: "${UE27_ORDER:?set UE27_ORDER to the sentence the coordinator gives at the slot}"
K=$(cd "$(dirname "$0")" && pwd)
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
STUDY=_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md
C=_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY.py
cd "$W" || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
[ -z "$(git status --porcelain)" ]; step clean $?
git show -s --format=%s HEAD | grep -q '^Board: UE27 at the head of the queue'; step head-claim $?
mkdir -p "$ASIDE"
N=$(( $(grep -E '^## [0-9]+\. ' $STUDY | tail -1 | sed -E 's/^## ([0-9]+)\..*/\1/') + 1 ))
echo "study section $N"
python3 -B "$K/make_records_ue27.py" --caps > "$ASIDE/caps.log" 2>&1; step caps $?
python3 -B "$K/integrate_ue27.py" > "$ASIDE/integrate.log" 2>&1; step integrate $?
python3 -B "$K/texts_ue27.py" "$N" > "$ASIDE/texts.log" 2>&1; step texts $?
BEFORE=$(ls $PKG/becoming-checks | tail -1)
(cd $PKG && LEAN_TIMEOUT=2400 python3 -B check_becoming.py > "$ASIDE/check.log" 2>&1); step checker $?
ID=$(ls $PKG/becoming-checks | tail -1)
[ "$ID" != "$BEFORE" ]; step new-receipt $?
echo "core receipt $ID, study section $N"
python3 -B "$K/reland_ue27.py" "$ID" "$N" "$ASIDE" > "$ASIDE/reland.log" 2>&1; step reland $?
python3 -B $C --check > "$ASIDE/conn1.log" 2>&1; echo "== connectivity before registering: exit $?"
python3 -B "$K/register_ue27.py" "$ASIDE/conn1.log" > "$ASIDE/register.log" 2>&1; step register $?
python3 -B $C --write > "$ASIDE/conn2.log" 2>&1; step connectivity-write $?
python3 -B $C --check > "$ASIDE/conn3.log" 2>&1; step connectivity-check $?
python3 -B tools/research/master_laws.py > "$ASIDE/master.log" 2>&1; step master-laws $?
make research-render > "$ASIDE/render1.log" 2>&1; echo "== render before re-pointing: exit $?"
python3 -B "$K/repoint_ue27.py" "$ID" > "$ASIDE/repoint-dry.log" 2>&1; step repoint-dry $?
python3 -B "$K/repoint_ue27.py" "$ID" --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
python3 -B "$K/board_ue27.py" land "$ID" "$N" "$UE27_ORDER" > "$ASIDE/board.log" 2>&1; step board $?
make research-render > "$ASIDE/render2.log" 2>&1; step render $?
for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
git commit -q -F - --pathspec-from-file="$ASIDE/paths.txt" <<MSG
UE27 landed: which blanket a thing has, and a formation's couplings as its blanket (\`Becoming.BlanketCouplings\` as a core leaf importing Blanket, Histories and IdentificationRuns, core receipt $ID, every axiom report empty; study §$N). The join, by construction: where a formation's couplings give the values of what couples into it, any model fed by them, with any policy and any environment, reading the act or not, is the agent of a blanketed law whose sensory course is the formation's own course through its couplings, two of its courses alike on the blanket before n + 2 exactly where their level histories are alike through the couplings up to n, in the open loop every reading of its internal course a selection through them; ThresholdDrain's join its case, checked; a construction, not a test, which forbids nothing of the course. The law a family shows, part by part: a part depending only on a reading exactly where the family is consistent under it, a law determined part by part admitting a family exactly where it is consistent part by part, Determined an equivalent case. The three levels at which a blanket's existence constrains: readings of the course (which course and the step, or the future) give every family a blanketed law, the step alone not enough; degenerate readings of the configuration give every family, or exactly the determined ones, the blanket's form, an injective one only those and not always; a sparse partition fixed apart from the family can be refuted by one run. The record a-formations-couplings-as-its-blanket (home 03 §1) and the blanket's record narrowed to a formation's own record as the internal part; 03 §1 (the blanket's last sentence and reading), 08 §8, the principle's page (In brief, claim table, §1, §2, §4, §5, Standing), the UE plan and FEP-INTEGRATION's item 12; the records citing the rewritten sections re-pointed, nothing they say changed; UE27's row in the history file. Independent reviews of the design and of the Lean, with probes, and of the landing texts and records, every finding taken. Render, strict check, links and tests pass.
MSG
step commit $?
git log --oneline -1 | cut -c1-120
