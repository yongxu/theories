#!/bin/sh
# EC6c and EC6d's landing: re-point the records that drift through their edits only, and bind Flow's and Optimum's
# proofs to the landing receipt. The drift list is filtered to the paths the landing changed, so another session's
# drift stays with its owner. Each changed source was read before re-pointing: Flow gains a named clause and an
# Iff.rfl theorem, Optimum's Outcome is spelled with it, every statement unchanged.
# usage (from the checkout root, after render): sh repoint_ec6c.sh RECEIPT
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
RF=_process/research/2026-10-05-generative-foundation-review/root-foundation
D=$(mktemp); F=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 - "$D" "$F" "$P" "$RF" <<'PY'
import json, sys
d, f, P, RF = sys.argv[1:5]
text = open(d).read()
data = json.loads(text[text.index('{'):text.rindex('}') + 1])
mine = {f'{P}/Becoming/Flow.lean', f'{P}/Becoming/Optimum.lean', f'{RF}/BECOMING-RENEWAL-READING.md',
        'theories/becoming/chapters/08-METHOD.md', f'{RF}/THEOREM-CONNECTIVITY.json',
        'theories/becoming/results/completion/COVERAGE.json'}
kept = [x for x in data.get('source_drift', []) if x['path'] in mine]
left = [(x['id'], x['path']) for x in data.get('source_drift', []) if x['path'] not in mine]
json.dump({'source_drift': kept}, open(f, 'w'))
print('re-pointing', len(kept), 'pairs; left to their owners:', left)
PY
python3 -B tools/research/repoint.py --reason "EC6c and EC6d (EC6's audit): Flow.BalancesBetween named beside Flow.Balances with Flow.balances_iff_between by Iff.rfl, Optimum's Outcome spelled with it, every statement unchanged; COVERAGE's actor row citing PartForms.goAlike; the study's new section; 08 section 7's counts; the connectivity report; read before re-pointing" \
  --drift-json "$F" --receipt "$P/becoming-checks/$1/verification.json" \
  --lean "$P/Becoming/Flow.lean" "$P/Becoming/Optimum.lean" --apply
rm -f "$D" "$F"
