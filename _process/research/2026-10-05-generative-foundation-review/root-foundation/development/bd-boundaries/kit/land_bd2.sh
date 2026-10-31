#!/bin/bash
# BD2's landing (land_rr2.sh's pattern), in BD2's worktree on its branch, once BD2 holds the head (head_bd2.sh): main
# merged in, the checker writing its run into the repository, the receipt and study section filled in, the
# connectivity and master laws, the citing records re-pointed, the board's landed clause, and one commit of every
# changed path. The fast-forward is ff_bd2.sh's.
# usage: land_bd2.sh WORKTREE ASIDE   (ASIDE a folder outside the repository, for logs)
set -u
W=$1; ASIDE=$2
K=$(cd "$(dirname "$0")" && pwd)
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
STUDY=_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md
C=_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY.py
B=_process/BECOMING-WORKBOARD.md
cd "$W" || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
[ "$(git branch --show-current)" = bd2-crossing ]; step branch $?
[ -z "$(git status --porcelain --untracked-files=no)" ]; step clean $?
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '^- \*\*Queue:\*\* BD2 at the head of the queue (landing now'; step head-claim $?
mkdir -p "$ASIDE"
git rev-parse main > "$ASIDE/main-at-merge.txt"
git merge --no-edit -q main > "$ASIDE/merge.log" 2>&1; step merge $?
BEFORE=$(ls $PKG/becoming-checks | grep -v '^_' | tail -1)
(cd $PKG && python3 -B check_becoming.py > "$ASIDE/check.log" 2>&1); step checker $?
ID=$(ls $PKG/becoming-checks | grep -v '^_' | tail -1)
[ "$ID" != "$BEFORE" ]; step new-receipt $?
N=$(( $(grep -E '^## [0-9]+\. ' $STUDY | tail -1 | sed -E 's/^## ([0-9]+)\..*/\1/') + 1 ))
echo "receipt $ID, study section $N"
python3 -B "$K/reland_bd2.py" "$ID" "$N" > "$ASIDE/reland.log" 2>&1; step reland $?
python3 -B $C --check > "$ASIDE/conn1.log" 2>&1; echo "== connectivity before registering: exit $?"
python3 -B "$K/register_bd2.py" "$ASIDE/conn1.log" > "$ASIDE/register.log" 2>&1; step register $?
python3 -B $C --write > "$ASIDE/conn2.log" 2>&1; step connectivity-write $?
python3 -B $C --check > "$ASIDE/conn3.log" 2>&1; step connectivity-check $?
python3 -B tools/research/master_laws.py > "$ASIDE/master.log" 2>&1; step master-laws $?
make research-render > "$ASIDE/render1.log" 2>&1; echo "== render before re-pointing: exit $?"
python3 -B "$K/repoint_bd2.py" "$ID" > "$ASIDE/repoint-dry.log" 2>&1; step repoint-dry $?
python3 -B "$K/repoint_bd2.py" "$ID" --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
python3 -B "$K/board_bd2.py" landed "$ID" "$N" > "$ASIDE/board.log" 2>&1; step board $?
make research-render > "$ASIDE/render2.log" 2>&1; step render $?
for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
git commit -q -F - --pathspec-from-file="$ASIDE/paths.txt" <<MSG
BD2 landed: not going out of a region, on the root (\`Becoming.GrammarCrossing\` and \`Becoming.ConveyanceBoundaries\` joined to the core, core receipt $ID, every axiom report empty, study §$N). The grammar's «不出», nothing in a region going out of it along a relation: a closed region, a closure among them, is not gone out of; not going out is the closedness of what is not outside, with no decision, and being closed where membership is settled, the two coinciding for every region exactly under excluded middle; nothing comes in exactly where nothing goes out of the outside, the two one along a symmetric relation, and a closed region can be come into along one that is not; a line from inside to outside goes out, its step going out placed on the line by the mark law with keeping to the region as what the ends fail. \`Flow.Cut\` is «不出» at a valuation's relation by definition, and a continuing family's region is no boundary of any event's self along conveyance; «所经必同» is proved from the step going out (rule 9, its statement unchanged). The record not-going-out-of-a-region (home 01 §9.9), a sixth law on conveyance-crosses-the-boundary, a history note on what-a-line-holds-and-a-regularity-takes-in; 01 §9.9 (BD's reading citing the Lean), 04 §1, 07 §4.6, the glossary row, 08's counts, the root module's bullets, the checker's core list and scope and both package READMEs, the Chinese Boundaries row and the checker's Boundaries scope brought to the continuation condition; BD's note §6; an independent AI review and its re-check, every finding taken (REVIEW.md); the records citing the changed sections re-pointed, nothing they say changed; BD2's row in the history file. Render, strict check, links and tests pass.
MSG
step commit $?
git log --oneline -1 | cut -c1-120
