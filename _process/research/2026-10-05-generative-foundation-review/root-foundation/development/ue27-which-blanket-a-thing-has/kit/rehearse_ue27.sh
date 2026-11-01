#!/bin/bash
# UE27's landing rehearsed in a scratch worktree of main (rehearse_ue26.sh's pattern, with no periphery): the core
# receipt written outside the repository (BECOMING_OUT) and copied in, then every later step of the landing as it will
# run. Nothing is committed.
# usage: rehearse_ue27.sh WORKTREE ASIDE   (WORKTREE detached on main and clean, ASIDE a folder outside the repository)
set -u
W=$1; ASIDE=$2
K=$(cd "$(dirname "$0")" && pwd)
PKG=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
STUDY=_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md
C=_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY.py
cd "$W" || exit 1
step() { echo "== $1: exit $2"; [ "$2" = 0 ] || exit "$2"; }
mkdir -p "$ASIDE/out"
N=$(( $(grep -E '^## [0-9]+\. ' $STUDY | tail -1 | sed -E 's/^## ([0-9]+)\..*/\1/') + 1 ))
echo "study section $N"
python3 -B "$K/make_records_ue27.py" --caps > "$ASIDE/caps.log" 2>&1; step caps $?
python3 -B "$K/integrate_ue27.py" > "$ASIDE/integrate.log" 2>&1; step integrate $?
python3 -B "$K/texts_ue27.py" "$N" > "$ASIDE/texts.log" 2>&1; step texts $?
(cd $PKG && BECOMING_OUT="$ASIDE/out" LEAN_TIMEOUT=2400 python3 -B check_becoming.py > "$ASIDE/check.log" 2>&1); step checker $?
ID=$(ls "$ASIDE/out/becoming-checks" | tail -1)
cp -Rp "$ASIDE/out/becoming-checks/$ID" $PKG/becoming-checks/ && cp -p "$ASIDE/out/becoming-verification.json" $PKG/becoming-verification.json
python3 -B "$K/reland_ue27.py" "$ID" "$N" "$ASIDE" > "$ASIDE/reland.log" 2>&1; step reland $?
python3 -B $C --check > "$ASIDE/conn1.log" 2>&1; echo "== connectivity before registering: exit $?"
python3 -B "$K/register_ue27.py" "$ASIDE/conn1.log" > "$ASIDE/register.log" 2>&1; step register $?
python3 -B $C --write > "$ASIDE/conn2.log" 2>&1; step connectivity-write $?
python3 -B $C --check > "$ASIDE/conn3.log" 2>&1; step connectivity-check $?
python3 -B tools/research/master_laws.py > "$ASIDE/master.log" 2>&1; step master-laws $?
make research-render > "$ASIDE/render1.log" 2>&1; echo "== render before re-pointing: exit $?"
python3 -B "$K/repoint_ue27.py" "$ID" > "$ASIDE/repoint-dry.log" 2>&1; step repoint-dry $?
python3 -B "$K/repoint_ue27.py" "$ID" --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
make research-render > "$ASIDE/render2.log" 2>&1; step render $?
for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
echo "== rehearsed: core receipt $ID, study section $N"
