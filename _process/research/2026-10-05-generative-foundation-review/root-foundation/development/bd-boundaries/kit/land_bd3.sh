#!/bin/bash
# BD3's landing (land_bd2.sh's pattern), in BD3's worktree on its branch, once BD3 holds the head (head_bd3.sh): main
# merged in, the checker writing its run into the repository, the receipt and study section filled in, the
# connectivity and shared laws, the citing records re-pointed, the board's landed clause, and one commit of every
# changed path. The fast-forward is ff_bd3.sh's.
# usage: BD3_ORDER="…" land_bd3.sh WORKTREE ASIDE   (ASIDE a folder outside the repository, for logs; BD3_ORDER the
#        coordinator's order sentence for the landed clause, sent with its word, verbatim; required)
set -u
W=$1; ASIDE=$2
K=$(cd "$(dirname "$0")" && pwd)
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
STUDY=_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md
C=_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY.py
B=_process/BECOMING-WORKBOARD.md
cd "$W" || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
[ "$(git branch --show-current)" = bd3-regions ]; step branch $?
[ -n "${BD3_ORDER:-}" ] && ! printf %s "$BD3_ORDER" | grep -q BD3; step coordinator-order $?
[ -z "$(git status --porcelain --untracked-files=no)" ]; step clean $?
git show main:$B | grep -m1 '^- \*\*Queue:\*\*' | grep -q '^- \*\*Queue:\*\* BD3 at the head of the queue (landing now'; step head-claim $?
mkdir -p "$ASIDE"
git rev-parse main > "$ASIDE/main-at-merge.txt"
git merge --no-edit -q main > "$ASIDE/merge.log" 2>&1; step merge $?
BEFORE=$(ls $PKG/becoming-checks | grep -v '^_' | tail -1)
(cd $PKG && LEAN_TIMEOUT=2400 python3 -B check_becoming.py > "$ASIDE/check.log" 2>&1); step checker $?
ID=$(ls $PKG/becoming-checks | grep -v '^_' | tail -1)
[ "$ID" != "$BEFORE" ]; step new-receipt $?
N=$(( $(grep -E '^## [0-9]+\. ' $STUDY | tail -1 | sed -E 's/^## ([0-9]+)\..*/\1/') + 1 ))
echo "receipt $ID, study section $N"
python3 -B "$K/reland_bd3.py" "$ID" "$N" > "$ASIDE/reland.log" 2>&1; step reland $?
python3 -B $C --check > "$ASIDE/conn1.log" 2>&1; echo "== connectivity before registering: exit $?"
python3 -B "$K/register_bd3.py" "$ASIDE/conn1.log" > "$ASIDE/register.log" 2>&1; step register $?
python3 -B $C --write > "$ASIDE/conn2.log" 2>&1; step connectivity-write $?
python3 -B $C --check > "$ASIDE/conn3.log" 2>&1; step connectivity-check $?
python3 -B tools/research/master_laws.py > "$ASIDE/master.log" 2>&1; step master-laws $?
make research-render > "$ASIDE/render1.log" 2>&1; echo "== render before re-pointing: exit $?"
python3 -B "$K/repoint_bd3.py" "$ID" > "$ASIDE/repoint-dry.log" 2>&1; step repoint-dry $?
python3 -B "$K/repoint_bd3.py" "$ID" --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
python3 -B "$K/board_bd3.py" landed "$ID" "$N" > "$ASIDE/board.log" 2>&1; step board $?
make research-render > "$ASIDE/render2.log" 2>&1; step render $?
for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
git status --porcelain --untracked-files=all | cut -c4- > "$ASIDE/paths.txt"
git add --pathspec-from-file="$ASIDE/paths.txt"; step add $?
git commit -q -F - --pathspec-from-file="$ASIDE/paths.txt" <<MSG
BD3 landed: balance region by region, on the root (\`Becoming.BalanceRegions\` joined to the core as a leaf, core receipt $ID, every axiom report empty, study §$N). Continuity's closed families read on the grammar's «不出»: adjacency among the listed relata is a symmetric relation of the grammar, and a family the relation closes, membership a test, is exactly a region not gone out of along that adjacency, and exactly one closed under it; so, relata listed without repetition and equality decided, transfers along the relation that balance a step exist exactly where the total is conserved on every such region (\`Continuity.balancing_iff\` read on «不出»), and on a web at every step likewise. No existing module changed. A seventh law, a dependency on not-going-out-of-a-region and a history note on balance-from-conservation-along-a-relation; 01 §8.4's sentence; 08's counts; the root module's bullet, the checker's core list and scope, both package READMEs and regions.json; an independent AI reading, every finding taken (REVIEW-BD3.md); the connectivity register's new apart roots each with a reason; the records citing the changed sections re-pointed, nothing they say changed; BD3's row in the history file. Render, strict check, links and tests pass.
MSG
step commit $?
git log --oneline -1 | cut -c1-120
