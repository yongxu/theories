#!/bin/sh
# TI1+TI2 landing from a clean checkout of main (run from its root): join, check, connectivity, texts, record, re-point,
# render and checks. Each step must pass.
set -e
K=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ti1-training-installs
F=_process/research/2026-10-05-generative-foundation-review/root-foundation
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
TI1_ROOT=$PWD python3 -B $K/integrate.py
(cd $P && python3 -B check_becoming.py > ../../../../../../$K/checker.log 2>&1)
R=$(python3 -c "import json;print(json.load(open('$P/becoming-verification.json'))['utc'])")
python3 -B $K/register_roots.py
python3 -B $F/THEOREM-CONNECTIVITY.py --check > $K/connectivity.log 2>&1
N=$(python3 -B $K/apply_text.py "$R" $K/connectivity.log "$(git rev-parse HEAD)" | tee $K/apply_text.log | sed -n 's/^STUDY_SECTION //p')
python3 -B $K/make_record.py "$R" "$N" | tee $K/make_record.log
sh $K/repoint.sh > $K/repoint.log 2>&1
for t in render check links test; do make -s research-$t > $K/research-$t.log 2>&1; echo "$t passed"; done
echo "landed text for receipt $R, study section $N"
