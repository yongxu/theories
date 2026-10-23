#!/bin/sh
# IV3d: re-point the records drifting by IV3d's edits only. The drift list is filtered to the paths IV3d changed
# (Becoming.Weightings and the root module, THE-STEP-OF-INVARIANCE, the canonical chapter (EN, ZH) through §9, the
# study, the delegated choices and the package README rows), so another session's drift stays with its owner; each
# changed source was read before re-pointing. Weightings' proof bindings are rebound to the IV3d receipt.
# usage (from the checkout root, after update_records_d.py): sh repoint_d.sh RECEIPT_ID
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
        'theories/becoming/chapters/THE-STEP-OF-INVARIANCE.md', 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md',
        'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md', f'{RF}/BECOMING-RENEWAL-READING.md',
        f'{RF}/DELEGATED-CHOICES.md'}
kept = [x for x in data.get('source_drift', []) if x['path'] in mine]
left = [(x['id'], x['path']) for x in data.get('source_drift', []) if x['path'] not in mine]
json.dump({'source_drift': kept}, open(f, 'w'))
print('re-pointing', len(kept), 'pairs; left to their owners:', left)
PY
python3 -B tools/research/repoint.py --reason "IV3d: Becoming.Weightings gained a step's demand, the least flow, the flows read off a web with capacities, the exact law of feeding alone with capacities and need by shortfall, its earlier statements unchanged; THE-STEP-OF-INVARIANCE §4.4 and §8, the canonical chapter's dependence bullet and §9 (EN, ZH), the study, D64 and the package README rows; read before re-pointing" \
  --drift-json "$F" \
  --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/Weightings.lean" --apply
rm -f "$D" "$F"
