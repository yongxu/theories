#!/bin/bash
# SJ's last landing rehearsed in a scratch worktree (rehearse_el.sh's pattern): detached at SJ1's branch, main merged in
# on the detached HEAD (no branch moves), the receipt written outside the repository (BECOMING_OUT) and copied in, then every later step of
# the landing as it will run, the board's head and landed clauses included. Nothing is committed to a branch.
# usage: rehearse_sj.sh WORKTREE ASIDE   (WORKTREE a scratch worktree detached at sj-claim and clean, ASIDE a
#        folder outside the repository)
set -u
W=$1; ASIDE=$2
K=$(cd "$(dirname "$0")" && pwd)
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
STUDY=_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md
C=_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY.py
cd "$W" || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
[ -z "$(git branch --show-current)" ]; step detached $?
[ -z "$(git status --porcelain --untracked-files=no)" ]; step clean $?
mkdir -p "$ASIDE/out"
git rev-parse main > "$ASIDE/main-at-merge.txt"
# the merge is committed on the detached HEAD (no branch moves): while a merge is in progress HEAD lacks main's
# reviewed versions and research.py reports false drift (RESULT-WORKFLOW, "Markdown drift")
git merge --no-edit -q main > "$ASIDE/merge.log" 2>&1; step merge $?
(cd $PKG && LEAN_TIMEOUT=2400 BECOMING_OUT="$ASIDE/out" python3 -B check_becoming.py > "$ASIDE/check.log" 2>&1); step checker $?
ID=$(ls "$ASIDE/out/becoming-checks" | grep -v '^_' | tail -1)
cp -Rp "$ASIDE/out/becoming-checks/$ID" $PKG/becoming-checks/ \
  && cp -p "$ASIDE/out/becoming-verification.json" $PKG/becoming-verification.json; step copy-receipt $?
N=$(( $(grep -E '^## [0-9]+\. ' $STUDY | tail -1 | sed -E 's/^## ([0-9]+)\..*/\1/') + 1 ))
echo "receipt $ID, study section $N"
python3 -B "$K/reland_sj2.py" "$ID" "$N" > "$ASIDE/reland.log" 2>&1; step reland $?
python3 -B $C --check > "$ASIDE/conn1.log" 2>&1; echo "== connectivity before registering: exit $?"
python3 -B "$K/register_sj2.py" "$ASIDE/conn1.log" > "$ASIDE/register.log" 2>&1; step register $?
python3 -B $C --write > "$ASIDE/conn2.log" 2>&1; step connectivity-write $?
python3 -B $C --check > "$ASIDE/conn3.log" 2>&1; step connectivity-check $?
python3 -B tools/research/shared_laws.py > "$ASIDE/master.log" 2>&1; step master-laws $?
make research-render > "$ASIDE/render1.log" 2>&1; echo "== render before re-pointing: exit $?"
python3 -B "$K/repoint_sj2.py" "$ID" > "$ASIDE/repoint-dry.log" 2>&1; step repoint-dry $?
python3 -B "$K/repoint_sj2.py" "$ID" --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
python3 -B "$K/free_head_rehearsal.py" "$ASIDE/held-clause.txt" > "$ASIDE/free-head.log" 2>&1; step free-head $?
python3 -B "$K/board_sj2.py" head > "$ASIDE/board-head.log" 2>&1; step board-head $?
# the coordinator sends the order sentence with its word; the rehearsal writes a placeholder in its place
SJ_ORDER="${SJ_ORDER:-the order the coordinator sends with its word (rehearsal placeholder)}" \
  python3 -B "$K/board_sj2.py" landed "$ID" "$N" > "$ASIDE/board.log" 2>&1; step board-landed $?
make research-render > "$ASIDE/render2.log" 2>&1; step render $?
for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
D=_process/research/2026-10-05-generative-foundation-review/root-foundation/development
python3 -B $D/review-packet/check_dossiers.py > "$ASIDE/dossiers.log" 2>&1 && grep -q '^0 problem(s)' "$ASIDE/dossiers.log"; step dossiers $?
python3 -B $D/review-packet/check_dossiers.py $D/ue8-sciences-dossier/SCIENCES.md > "$ASIDE/dossiers-sciences.log" 2>&1 && grep -q '^0 problem(s)' "$ASIDE/dossiers-sciences.log"; step dossiers-sciences $?
git status --porcelain --untracked-files=all > "$ASIDE/paths.txt"
echo "== rehearsed: receipt $ID, study section $N, $(wc -l < "$ASIDE/paths.txt") paths changed (nothing committed)"
