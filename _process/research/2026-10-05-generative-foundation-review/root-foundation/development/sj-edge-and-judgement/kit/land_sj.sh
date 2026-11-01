#!/bin/bash
# SJ1's landing (land_el.sh's pattern), in SJ1's worktree on its branch, once SJ1 holds the head (head_sj.sh): main
# merged in, the checker writing its run into the repository, the receipt and study section filled in, the
# connectivity and shared laws, the citing records re-pointed, the board's landed clause, and one commit of every
# changed path. The fast-forward is ff_sj.sh's.
# usage: SJ_ORDER="…" land_sj.sh WORKTREE ASIDE   (ASIDE a folder outside the repository, for logs; SJ_ORDER the
#        coordinator's order sentence for the landed clause, sent with its word, verbatim; required; SJ_HISTORY_ROW
#        the landing's row for the board history, board_sj.py history's, required)
set -u
W=$1; ASIDE=$2
K=$(cd "$(dirname "$0")" && pwd)
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
STUDY=_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md
C=_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY.py
B=_process/BECOMING-WORKBOARD.md
cd "$W" || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
[ "$(git branch --show-current)" = sj-claim ]; step branch $?
[ -n "${SJ_ORDER:-}" ] && ! printf %s "$SJ_ORDER" | grep -qwE "SJ1?"; step coordinator-order $?
[ -z "$(git status --porcelain --untracked-files=no)" ]; step clean $?
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '^- \*\*Queue:\*\* SJ1 at the head of the queue (landing now'; step head-claim $?
mkdir -p "$ASIDE"
git rev-parse main > "$ASIDE/main-at-merge.txt"
git merge --no-edit -q main > "$ASIDE/merge.log" 2>&1; step merge $?
BEFORE=$(ls $PKG/becoming-checks | grep -v '^_' | tail -1)
(cd $PKG && LEAN_TIMEOUT=2400 python3 -B check_becoming.py > "$ASIDE/check.log" 2>&1); step checker $?
ID=$(ls $PKG/becoming-checks | grep -v '^_' | tail -1)
[ "$ID" != "$BEFORE" ]; step new-receipt $?
N=$(( $(grep -E '^## [0-9]+\. ' $STUDY | tail -1 | sed -E 's/^## ([0-9]+)\..*/\1/') + 1 ))
echo "receipt $ID, study section $N"
python3 -B "$K/reland_sj.py" "$ID" "$N" > "$ASIDE/reland.log" 2>&1; step reland $?
python3 -B $C --check > "$ASIDE/conn1.log" 2>&1; echo "== connectivity before registering: exit $?"
python3 -B "$K/register_sj.py" "$ASIDE/conn1.log" > "$ASIDE/register.log" 2>&1; step register $?
python3 -B $C --write > "$ASIDE/conn2.log" 2>&1; step connectivity-write $?
python3 -B $C --check > "$ASIDE/conn3.log" 2>&1; step connectivity-check $?
python3 -B tools/research/shared_laws.py > "$ASIDE/master.log" 2>&1; step master-laws $?
make research-render > "$ASIDE/render1.log" 2>&1; echo "== render before re-pointing: exit $?"
python3 -B "$K/repoint_sj.py" "$ID" > "$ASIDE/repoint-dry.log" 2>&1; step repoint-dry $?
python3 -B "$K/repoint_sj.py" "$ID" --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
python3 -B "$K/board_sj.py" landed "$ID" "$N" > "$ASIDE/board.log" 2>&1; step board $?
python3 -B "$K/board_sj.py" history "$ID" "$N" > "$ASIDE/history.log" 2>&1; step board-history $?
make research-render > "$ASIDE/render2.log" 2>&1; step render $?
for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
git commit -q -F - --pathspec-from-file="$ASIDE/paths.txt" <<MSG
SJ1 landed: a response common over a reading, on the root (one core leaf, core receipt $ID, every axiom report empty, study §$N; Viability's two kernel laws re-proved from it with their statements unchanged). \`Becoming.CommonResponse\`, importing GrammarLaws only: the occurrences whose closure under a relation stays in a region, the grammar's «承» along the converse of «所闭», form its largest part closed under the relation («所闭之承最大»), for every carrier and relation; at a process's steps it is the invariance kernel (\`Viability.kernel_iff_held\`), and \`Viability.Certificate.kernel\` and \`Viability.kernel_certificate\` are proved from it, so \`kernel_iff_certificate\`, \`kernel_largest\` and everything above them follow unedited. A response common over a reading within a requirement («共应»: a region for each act, inside its requirement, closed under the reading, covering the situations) exists exactly where the acts' kernels cover the situations («共应当且仅当所闭之承遍»), with no choice and no decision: 03 §3's judgment is viability indexed by acts. Along the reading without its closure exactly reflexivity and transitivity are needed, each by a witness; finer readings keep a common response; under staying the same it is the requirement covering, under the reading that tells nothing apart, on an inhabited carrier, one act everywhere; a rule from what a map reads gives one with no choice, the converse asking for a choice over the readings, which plans are shown to need (\`Viability.plans_iff_choice\`, cited by analogy), not proved needed here. With exactly one act at each situation, on a carrier keeping situations and acts apart, a common response over a map's sameness exists exactly where the image of the response relation along the map has a fixed successor, through the lumping law; at an act map the condition is \`Learning.Lumped\`, unfolded; witnesses that covering, one act and the sum carrier each do work, and that an act at every situation, or one shared by every two, need not give one (none under the reading that tells nothing apart). One new record, a-response-common-over-a-reading (home 03 §12, the section's opening counting its laws, 03's bases line naming it); 05 §10's row names the kernel's home; 08's counts; the root module's import and bullets, the checker's core list and scope, both package READMEs and regions.json; three reviews, of the design, of the Lean and the map, and of the landing texts (REVIEW-3: 8 agents, 34 of 41 findings confirmed and taken), every confirmed finding taken; the names provisional for the grammar's owner; GuardHorizon's bridge and re-proof left to a ring slot after ND; the connectivity register's new apart roots each with a reason; the invariance-kernel correction carried with it (Viability.Kernel holds where every course stays in the guard: "viability kernel" corrected to "invariance kernel" in Viability's, Keeping's and Lasting's docstrings, no declaration changed, and in the two market records with their history notes); the records citing the changed texts re-pointed and the proof bindings to Viability, Keeping and Lasting rebound, nothing they say changed. Render, strict check, links and tests pass.
MSG
step commit $?
git log --oneline -1 | cut -c1-120
