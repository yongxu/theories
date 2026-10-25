#!/bin/sh
# MA2's landing: re-point the records drifting by MA2's edits only. The drift list is filtered to the paths the
# landing changed (Becoming.ClosedCapture, the root module, the package README rows, 02-MAP, 05-COLLECTIVES, the
# overview EN and ZH, OPENING, the meta-attractor page, the study, the delegated choices EN and ZH, regions.json and
# the AJ source record), so another session's drift stays with its owner; each changed source was read before
# re-pointing. ClosedCapture's proof bindings are rebound to the landing receipt.
# usage (from the checkout root, after land.py): sh repoint.sh RECEIPT_ID
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
mine = {f'{P}/Becoming/ClosedCapture.lean', f'{P}/Becoming.lean', f'{P}/README.md', f'{P}/README.zh.md',
        'theories/becoming/chapters/02-MAP.md', 'theories/becoming/chapters/05-COLLECTIVES.md',
        'theories/becoming/THE-THEORY-OF-BECOMING.md', 'theories/becoming/THE-THEORY-OF-BECOMING.zh.md',
        'theories/becoming/OPENING.md', 'theories/meta-attractor/README.md',
        f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/DELEGATED-CHOICES.md', f'{RF}/DELEGATED-CHOICES.zh.md',
        'theories/becoming/results/data/regions.json',
        'sources/15-codex-theory-conversations/2026-10-24-alignment-of-the-joint-selection.md'}
kept = [x for x in data.get('source_drift', []) if x['path'] in mine]
left = [(x['id'], x['path']) for x in data.get('source_drift', []) if x['path'] not in mine]
json.dump({'source_drift': kept}, open(f, 'w'))
print('re-pointing', len(kept), 'pairs; left to their owners:', left)
PY
python3 -B tools/research/repoint.py --reason "MA2 landed: Becoming.ClosedCapture gained the readers drawn from the selected (Drawn, Thinned), its earlier statements unchanged; 02 §9 (home section, T7, a reading, the opening clause), the overview's capture paragraph EN and ZH, 05's cross-reference, OPENING's [^meta], the meta-attractor page, the package README rows, the root module's doc, the study, D67 EN and ZH, regions.json and the AJ source record; read before re-pointing" \
  --drift-json "$F" \
  --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/ClosedCapture.lean" --apply
rm -f "$D" "$F"
