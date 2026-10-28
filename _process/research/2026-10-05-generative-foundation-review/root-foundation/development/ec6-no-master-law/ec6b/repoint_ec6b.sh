#!/bin/sh
# EC6b's landing: re-point the records that drift through EC6b's edits only, and bind the six re-proved modules'
# proofs to the landing receipt. The drift list is filtered to the paths the landing changed, so another session's
# drift stays with its owner: the six modules, the study, 08-METHOD and the connectivity report.
# Each changed source was read before re-pointing: the modules changed in proofs only, every statement unchanged.
# usage (from the checkout root, after render): sh repoint_ec6b.sh RECEIPT
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
mine = {f'{P}/Becoming/{m}.lean' for m in ('Pace', 'RuleCapture', 'Lasting', 'RegimeMargin', 'Closing', 'Decidedness')}
mine |= {f'{RF}/BECOMING-RENEWAL-READING.md', 'theories/becoming/chapters/08-METHOD.md', f'{RF}/THEOREM-CONNECTIVITY.json'}
kept = [x for x in data.get('source_drift', []) if x['path'] in mine]
left = [(x['id'], x['path']) for x in data.get('source_drift', []) if x['path'] not in mine]
json.dump({'source_drift': kept}, open(f, 'w'))
print('re-pointing', len(kept), 'pairs; left to their owners:', left)
PY
python3 -B tools/research/repoint.py --reason "EC6b (EC6's cases of closure and balance derived, board rule 9): Pace, RuleCapture, Lasting, RegimeMargin, Closing and Decidedness re-proved through the closure law (Invariant.reach, WithinClosure) and the stretch balance (balance_over_stretch_on), every statement unchanged; the study's new section; 08 section 7's counts; the connectivity report; read before re-pointing" \
  --drift-json "$F" --receipt "$P/becoming-checks/$1/verification.json" \
  --lean "$P/Becoming/Pace.lean" "$P/Becoming/RuleCapture.lean" "$P/Becoming/Lasting.lean" "$P/Becoming/RegimeMargin.lean" \
  "$P/Becoming/Closing.lean" "$P/Becoming/Decidedness.lean" --apply
rm -f "$D" "$F"
