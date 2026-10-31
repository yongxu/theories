#!/bin/bash
# BD2's landing rehearsed in a scratch worktree (rehearse_rr.sh's pattern): detached at BD2's branch, main merged in
# without a commit, the receipt written outside the repository (BECOMING_OUT) and copied in, then every later step of
# the landing as it will run, the board's head and landed clauses included. Nothing is committed.
# usage: rehearse_bd2.sh WORKTREE ASIDE   (WORKTREE a scratch worktree detached at bd2-crossing and clean, ASIDE a
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
git merge --no-commit --no-ff -q main > "$ASIDE/merge.log" 2>&1; step merge $?
(cd $PKG && BECOMING_OUT="$ASIDE/out" python3 -B check_becoming.py > "$ASIDE/check.log" 2>&1); step checker $?
ID=$(ls "$ASIDE/out/becoming-checks" | grep -v '^_' | tail -1)
cp -Rp "$ASIDE/out/becoming-checks/$ID" $PKG/becoming-checks/ \
  && cp -p "$ASIDE/out/becoming-verification.json" $PKG/becoming-verification.json; step copy-receipt $?
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
python3 -B "$K/board_bd2.py" head > "$ASIDE/board-head.log" 2>&1; step board-head $?
python3 -B "$K/board_bd2.py" landed "$ID" "$N" > "$ASIDE/board.log" 2>&1; step board-landed $?
make research-render > "$ASIDE/render2.log" 2>&1; step render $?
for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
git status --porcelain --untracked-files=all > "$ASIDE/paths.txt"
echo "== rehearsed: receipt $ID, study section $N, $(wc -l < "$ASIDE/paths.txt") paths changed (nothing committed)"
