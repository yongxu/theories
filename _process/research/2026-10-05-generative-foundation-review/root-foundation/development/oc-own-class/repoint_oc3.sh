#!/bin/sh
# OC3: re-point the records drifting by OC3's edits only. The drift list is filtered to the paths OC3 changed (07,
# the philosophers' dossier, DELEGATED-CHOICES and, with a receipt, Becoming.GrammarPath), so another session's drift
# stays with its owner; each changed line was read before re-pointing ("goes on past" → "continues past", no statement
# changed). With a receipt, GrammarPath's proof bindings are rebound to it.
# usage (from the checkout root, after texts_oc3.py): sh repoint_oc3.sh [RECEIPT_ID]
set -e
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
RF=_process/research/2026-10-05-generative-foundation-review/root-foundation
D=$(mktemp); F=$(mktemp)
python3 -B tools/research/research.py check > "$D" 2>/dev/null || true
python3 - "$D" "$F" "$P" "$RF" "${1:-}" <<'PY'
import json, sys
d, f, P, RF, receipt = sys.argv[1:6]
text = open(d).read()
data = json.loads(text[text.index('{'):text.rindex('}') + 1])
mine = {'theories/becoming/chapters/07-SIGNIFICANCE.md', 'theories/becoming/review/PHILOSOPHY.md',
        f'{RF}/DELEGATED-CHOICES.md'}
if receipt:
    mine.add(f'{P}/Becoming/GrammarPath.lean')
kept = [x for x in data.get('source_drift', []) if x['path'] in mine]
left = [(x['id'], x['path']) for x in data.get('source_drift', []) if x['path'] not in mine]
json.dump({'source_drift': kept}, open(f, 'w'))
print('re-pointing', len(kept), 'pairs:', [(x['id'], x['path'].split('/')[-1]) for x in kept])
print('left to their owners:', left)
PY
REASON="OC3: \"goes on past\" an end replaced by \"continues past\", the sense of «过亡而续» (the glossary keeps \"goes on\" for 延); wording only, no statement changed: D64's reading in 07 §4.3, P-15's quote of it, D64 in DELEGATED-CHOICES"
if [ -n "$1" ]; then
  python3 -B tools/research/repoint.py --reason "$REASON; on the PF line owner's answer, the title of 07 §4.6's step 2, P-20's step 2 and the first sentence of Becoming.GrammarPath's module doc (a comment; core receipt $1); read before re-pointing" \
    --drift-json "$F" --receipt "$P/becoming-checks/$1/verification.json" --lean "$P/Becoming/GrammarPath.lean" --apply
else
  python3 -B tools/research/repoint.py --reason "$REASON; read before re-pointing" --drift-json "$F" --apply
fi
rm -f "$D" "$F"
