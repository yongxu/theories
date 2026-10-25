#!/bin/sh
# IV3l: re-point the records drifting by IV3l's edits only. The drift list is filtered to the paths IV3l changed
# (Becoming.Weightings and the root module, 07-SIGNIFICANCE, 08-METHOD, the study, the delegated choices and the package
# README rows), so another session's drift stays with its owner; each changed source was read before re-pointing.
# Weightings' proof bindings are rebound to the IV3l receipt.
# usage (from the checkout root, after update_records_j.py): sh repoint_j.sh RECEIPT_ID
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
mine = {f'{P}/Becoming/Weightings.lean', f'{P}/Becoming.lean', f'{P}/README.md', f'{P}/README.zh.md',
        'theories/becoming/chapters/07-SIGNIFICANCE.md', 'theories/becoming/chapters/08-METHOD.md',
        f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/DELEGATED-CHOICES.md', 'theories/becoming/results/data/regions.json', 'theories/becoming/THE-THEORY-OF-BECOMING.md', 'theories/becoming/THE-THEORY-OF-BECOMING.zh.md'}
kept = [x for x in data.get('source_drift', []) if x['path'] in mine]
left = [(x['id'], x['path']) for x in data.get('source_drift', []) if x['path'] not in mine]
json.dump({'source_drift': kept}, open(f, 'w'))
print('re-pointing', len(kept), 'pairs; left to their owners:', left)
PY
python3 -B tools/research/repoint.py --reason "IV3l: the independent review's fixes: Becoming.Weightings gained Routing.possible and corrected docs, its earlier statements unchanged; 07 §4.3 and §4.6, 08 item 12 and counts, the overview, D64, the study (§396 and §397 corrected in place, new section) and the package README rows; read before re-pointing" \
  --drift-json "$F" \
  --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/Weightings.lean" --apply
rm -f "$D" "$F"
