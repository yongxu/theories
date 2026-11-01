#!/bin/bash
# RR's landing rehearsed in a scratch worktree of main: the receipt written outside the repository (BECOMING_OUT) and
# copied in, then every later step of the landing as it will run. Nothing is committed.
# usage: rehearse_rr.sh WORKTREE ASIDE N   (WORKTREE detached on main and clean, ASIDE a folder outside the repository)
set -u
W=$1; ASIDE=$2; N=$3
K=$(cd "$(dirname "$0")" && pwd)
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
C=_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY.py
cd "$W" || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
(cd /Users/ren/theories && python3 -B "$K/make_records_rr.py" --caps); step caps $?
python3 -B "$K/integrate_rr.py"; step integrate $?
mkdir -p "$ASIDE/out"
(cd $PKG && BECOMING_OUT="$ASIDE/out" python3 -B check_becoming.py > "$ASIDE/check.log" 2>&1); step checker $?
ID=$(ls "$ASIDE/out/becoming-checks" | tail -1)
cp -Rp "$ASIDE/out/becoming-checks/$ID" $PKG/becoming-checks/ && cp -p "$ASIDE/out/becoming-verification.json" $PKG/becoming-verification.json
python3 -B "$K/reland_rr.py" "$ID" "$N" "$ASIDE" > "$ASIDE/reland.log" 2>&1; step reland $?
python3 -B $C --check > "$ASIDE/conn1.log" 2>&1; echo "== connectivity before registering: exit $?"
python3 -B "$K/register_rr.py" "$ASIDE/conn1.log" > "$ASIDE/register.log" 2>&1; step register $?
python3 -B $C --write > "$ASIDE/conn2.log" 2>&1; step connectivity-write $?
python3 -B $C --check > "$ASIDE/conn3.log" 2>&1; step connectivity-check $?
python3 -B tools/research/shared_laws.py > "$ASIDE/master.log" 2>&1; step master-laws $?
make research-render > "$ASIDE/render1.log" 2>&1; echo "== render before re-pointing: exit $?"
python3 -B "$K/repoint_rr.py" "$ID" > "$ASIDE/repoint-dry.log" 2>&1; step repoint-dry $?
python3 -B "$K/repoint_rr.py" "$ID" --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
make research-render > "$ASIDE/render2.log" 2>&1; step render $?
for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
echo "== rehearsed: receipt $ID, study section $N"
