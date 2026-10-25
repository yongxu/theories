#!/bin/sh
# MA4b's landing: re-point the records that drift through MA4b's edits only. The drift list is filtered to the paths the
# landing changed, so another session's drift stays with its owner:
#   the root module, the checker, the package README rows (EN and ZH), 02-MAP, 08-METHOD, the overview (EN and ZH), the
#   meta-attractor page, the study, regions.json, the goal generative-alignment, and MA4's and MA2's records.
# Each changed source was read before re-pointing. No Lean file a record binds was changed, so no binding is rebound.
# usage (from the checkout root, after make_records_ma4b.py, register_ma4b.py and render): sh repoint_ma4b.sh
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
mine = {f'{P}/Becoming.lean', f'{P}/check_becoming.py', f'{P}/README.md', f'{P}/README.zh.md',
        'theories/becoming/chapters/02-MAP.md', 'theories/becoming/chapters/08-METHOD.md',
        'theories/becoming/THE-THEORY-OF-BECOMING.md', 'theories/becoming/THE-THEORY-OF-BECOMING.zh.md',
        'theories/meta-attractor/README.md', f'{RF}/BECOMING-RENEWAL-READING.md',
        'theories/becoming/results/data/regions.json', '_process/goals/generative-alignment.json',
        'theories/becoming/results/records/shaping-read-by-readers-drawn-from-the-selected.json',
        'theories/becoming/results/records/readers-drawn-from-the-selected.json'}
kept = [x for x in data.get('source_drift', []) if x['path'] in mine]
left = [(x['id'], x['path']) for x in data.get('source_drift', []) if x['path'] not in mine]
json.dump({'source_drift': kept}, open(f, 'w'))
print('re-pointing', len(kept), 'pairs; left to their owners:', left)
PY
python3 -B tools/research/repoint.py --reason "MA4b landed: Becoming.ReadInTime joined to the core (root module's import and doc, the checker's core list and scope, the package README rows EN and ZH); 02 §9 (the lead, the home section of loss-read-in-time-by-the-others, the clause of MA4's reading on the readers' timing, a reading, the Open item); the overview's capture paragraph EN and ZH; the meta-attractor page's status line; 08's counts; the study; regions.json; the goal generative-alignment's results; MA4's and MA2's records; read before re-pointing" \
  --drift-json "$F" --apply
rm -f "$D" "$F"
