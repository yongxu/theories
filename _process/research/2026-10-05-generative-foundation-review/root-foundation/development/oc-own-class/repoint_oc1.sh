#!/bin/sh
# OC1: re-point the records drifting by OC1's edits only. The drift list is filtered to the paths OC1 changed
# (Becoming.GrammarPath, the root module, the checker's scope, the package README rows, 07-SIGNIFICANCE, 08-METHOD, the
# study, regions.json and the philosophers' dossier), so another session's drift stays with its owner; each changed source
# was read before re-pointing. GrammarPath's proof bindings are rebound to the OC1 receipt.
# usage (from the checkout root, after make_record_oc1.py): sh repoint_oc1.sh RECEIPT_ID
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
mine = {f'{P}/Becoming/GrammarPath.lean', f'{P}/Becoming.lean', f'{P}/check_becoming.py', f'{P}/README.md',
        f'{P}/README.zh.md', 'theories/becoming/chapters/07-SIGNIFICANCE.md', 'theories/becoming/chapters/08-METHOD.md',
        f'{RF}/BECOMING-RENEWAL-READING.md', 'theories/becoming/results/data/regions.json',
        'theories/becoming/review/PHILOSOPHY.md'}
kept = [x for x in data.get('source_drift', []) if x['path'] in mine]
left = [(x['id'], x['path']) for x in data.get('source_drift', []) if x['path'] not in mine]
json.dump({'source_drift': kept}, open(f, 'w'))
print('re-pointing', len(kept), 'pairs; left to their owners:', left)
PY
python3 -B tools/research/repoint.py --reason "OC1: Becoming.GrammarPath gained constancy read at a member's class, PF's and PF2's statements unchanged and their proofs now through it; 07-SIGNIFICANCE §4.6 (P2 read at one's own class, the home section, step 4, the conclusion, the organism, which class P2 reads, the answered Open item removed), P-20's statement of P2, 08-METHOD's receipt and counts, the study, regions.json, the root module's bullet, the checker's scope and the package README rows; read before re-pointing" \
  --drift-json "$F" \
  --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/GrammarPath.lean" --apply
rm -f "$D" "$F"
