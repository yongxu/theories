# EL6's landing steps after the checker, shared by rehearse_el6.sh and land_el6.sh (sourced; needs K, ASIDE, ID, N,
# step()). The board's landed clause takes EL6_ORDER.
C=_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY.py
D=_process/research/2026-10-05-generative-foundation-review/root-foundation/development
python3 -B "$K/el6_signatures.py" "$ID" > "$ASIDE/signatures.log" 2>&1; step signatures $?
python3 -B "$K/reland_el6.py" "$ID" "$N" > "$ASIDE/reland.log" 2>&1; step reland $?
python3 -B $C --check > "$ASIDE/conn1.log" 2>&1; echo "== connectivity before registering: exit $?"
python3 -B "$K/register_el6.py" "$ASIDE/conn1.log" > "$ASIDE/register.log" 2>&1; step register $?
python3 -B $C --write > "$ASIDE/conn2.log" 2>&1; step connectivity-write $?
python3 -B $C --check > "$ASIDE/conn3.log" 2>&1; step connectivity-check $?
python3 -B tools/research/master_laws.py > "$ASIDE/master.log" 2>&1; step master-laws $?
make research-render > "$ASIDE/render1.log" 2>&1; echo "== render before re-pointing: exit $?"
python3 -B "$K/repoint_el6.py" "$ID" > "$ASIDE/repoint-dry.log" 2>&1; step repoint-dry $?
python3 -B "$K/repoint_el6.py" "$ID" --apply > "$ASIDE/repoint.log" 2>&1; step repoint $?
python3 -B "$K/board_el6.py" landed "$ID" "$N" > "$ASIDE/board.log" 2>&1; step board-landed $?
make research-render > "$ASIDE/render2.log" 2>&1; step render $?
for t in research-check-strict research-links research-test; do make $t > "$ASIDE/$t.log" 2>&1; step $t $?; done
grep -q "^Ran [0-9]* tests" "$ASIDE/research-test.log" && grep -q "^OK" "$ASIDE/research-test.log"; step tests-ran $?
python3 -B $D/review-packet/check_dossiers.py > "$ASIDE/dossiers.log" 2>&1; step dossiers $?
python3 -B $D/review-packet/check_dossiers.py $D/ue8-sciences-dossier/SCIENCES.md > "$ASIDE/dossiers-sciences.log" 2>&1; step dossiers-sciences $?
