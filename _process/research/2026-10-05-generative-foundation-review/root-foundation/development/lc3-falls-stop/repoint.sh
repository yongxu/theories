#!/bin/zsh
# Re-point records whose cited sources changed, one reason per cause (after reading each change).
set -e
K=_process/research/2026-10-05-generative-foundation-review/root-foundation/development/lc3-falls-stop
P=experiments/integrated-correction/general-framework/generative-basis/lean/becoming
R=$1
python3 - $K <<'PY'
import json, sys
K = sys.argv[1]
t = open(f'{K}/render.log').read(); d = json.loads(t[t.index('{'):t.rindex('}') + 1])
mc1 = dict(d); mc1['source_drift'] = [x for x in d['source_drift'] if x['path'] == 'experiments/margin-measured/README.md']
own = dict(d); own['source_drift'] = [x for x in d['source_drift'] if x['path'] != 'experiments/margin-measured/README.md']
json.dump(mc1, open(f'{K}/drift-mc1.json', 'w')); json.dump(own, open(f'{K}/drift-lc3.json', 'w'))
print('mc1', len(mc1['source_drift']), 'own', len(own['source_drift']), sorted({x['path'] for x in own['source_drift']}))
PY
if python3 -c "import json,sys; sys.exit(0 if json.load(open('$K/drift-mc1.json'))['source_drift'] else 1)"; then
python3 -B tools/research/repoint.py --reason "MC1 (a82b71c66) rewrote experiments/margin-measured/README.md by finding; it still integrates RM1-RM5 and links these records, and nothing these records claim changed" --drift-json $K/drift-mc1.json --apply > $K/repoint-mc1.log
fi
python3 -B tools/research/repoint.py --reason "chapter changed by LC3 only in the modelling-choices row of section 0, the rest bullet and records lines of 1.3, the record table, the relation-to-known-results row 4, 8.1 item 6 and the section 9 receipt and counts; Becoming.LeastLoss changed only by the section naming the one premise of rest (FallsStop, no endless fall, least fall) and the finite-reading law's conclusion restated as FallsStop, the same proposition; nothing these records cite changed" --drift-json $K/drift-lc3.json --receipt $P/becoming-checks/$R/verification.json --lean $P/Becoming/LeastLoss.lean --apply > $K/repoint.log
