#!/bin/sh
# OC4: re-point the records drifting by OC4's edits only. The drift list is filtered to the paths OC4 changed (07, the
# philosophers' dossier, DELEGATED-CHOICES and the package README rows), so another session's drift stays with its
# owner; each changed line was read before re-pointing (texts made exact after the second check, no law's statement
# changed). No Lean changed, so no proof binding is rebound.
# usage (from the checkout root, after texts_oc4.py): sh repoint_oc4.sh PFLETTERS   (PFLETTERS: the PF line's applied
# letters, or - for none)
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
mine = {'theories/becoming/chapters/07-SIGNIFICANCE.md', 'theories/becoming/review/PHILOSOPHY.md',
        f'{RF}/DELEGATED-CHOICES.md', f'{P}/README.md', f'{P}/README.zh.md'}
kept = [x for x in data.get('source_drift', []) if x['path'] in mine]
left = [(x['id'], x['path']) for x in data.get('source_drift', []) if x['path'] not in mine]
json.dump({'source_drift': kept}, open(f, 'w'))
print('re-pointing', len(kept), 'pairs:', [(x['id'], x['path'].split('/')[-1]) for x in kept])
print('left to their owners:', left)
PY
REASON="OC4: the crux's texts checked a second time (development/oc-own-class/REVIEW-OC4.md); wording made exact, no law's statement changed: D64's reading in 07 §4.3, P2, step 1, the conclusion and which class P2 reads in 07 §4.6, P-15, P-18 and P-20, D64 in DELEGATED-CHOICES"
if [ "${1:--}" != "-" ]; then
  REASON="$REASON; on the PF line owner's answer, its places ($1) in 07 §4.6, P-20, the dossier's introduction and the package README rows"
fi
python3 -B tools/research/repoint.py --reason "$REASON; read before re-pointing" --drift-json "$F" --apply
rm -f "$D" "$F"
