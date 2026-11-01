# U4d's landing steps after the checker, shared by rehearse_u4d.sh and land_u4d.sh (steps_el6.sh's pattern; sourced;
# needs K, ASIDE, ID, N, step()). The board's landed clause takes U4D_ORDER; the signature audit reads main's side at
# U4D_BASE, the main merged in (main-at-merge.txt), not at the moving main.
C=_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY.py
D=_process/research/2026-10-05-generative-foundation-review/root-foundation/development
[ -n "${U4D_BASE:-}" ]; step base $?
python3 -B "$K/u4d_signatures.py" "$ID" > "$ASIDE/signatures.log" 2>&1; step signatures $?
python3 -B "$K/reland_u4d.py" "$ID" "$N" > "$ASIDE/reland.log" 2>&1; step reland $?
python3 -B $C --check > "$ASIDE/conn1.log" 2>&1; echo "== connectivity before registering: exit $?"
python3 -B "$K/register_u4d.py" "$ASIDE/conn1.log" > "$ASIDE/register.log" 2>&1; step register $?
python3 -B $C --write > "$ASIDE/conn2.log" 2>&1; step connectivity-write $?
python3 -B $C --check > "$ASIDE/conn3.log" 2>&1; step connectivity-check $?
cp -p theories/becoming/results/data/shared-laws.json "$ASIDE/shared-laws-before.json"
python3 -B tools/research/shared_laws.py > "$ASIDE/shared-laws.log" 2>&1; step shared-laws $?
python3 -B "$K/shared_laws_same.py" "$ASIDE/shared-laws-before.json" > "$ASIDE/shared-laws-same.log" 2>&1; step shared-laws-figures $?
make research-render > "$ASIDE/render1.log" 2>&1; echo "== render before re-pointing: exit $?"
python3 -B "$K/repoint_u4d.py" "$ID" > "$ASIDE/repoint-dry.log" 2>&1; step repoint-dry $?
python3 -B "$K/repoint_u4d.py" "$ID" --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
python3 -B "$K/board_u4d.py" landed "$ID" "$N" > "$ASIDE/board.log" 2>&1; step board-landed $?
make research-render > "$ASIDE/render2.log" 2>&1; step render $?
for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
grep -q "^Ran [0-9]* tests" "$ASIDE/research-test.log" && grep -q "^OK" "$ASIDE/research-test.log"; step tests-ran $?
python3 -B $D/review-packet/check_dossiers.py > "$ASIDE/dossiers.log" 2>&1; step dossiers $?
python3 -B $D/review-packet/check_dossiers.py $D/ue8-sciences-dossier/SCIENCES.md > "$ASIDE/dossiers-sciences.log" 2>&1; step dossiers-sciences $?
