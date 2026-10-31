"""Critic: a names-only discharge check (the recovery's proof names no theorem of the run but F) on U4's 3fd7dad75 forms,
using draft 2's own walk (lib.walk, §3.0 'the theorems a proof names'), merged into the run's pickle."""
import json, sys
sys.path.insert(0, '/private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad/recheck-bf')
import lib
from lib import C
for l in open('/private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad/recheck-bf/u4c.jsonl'):
    d = json.loads(l)
    if d['m'] == 'U4C.Boundary':
        C[d['n']] = d
U = 'Becoming.U4Boundary.'
for R, F, row in [(U+'no_new_dependence_at_model', U+'descent_forms_no_dependence', 'Becoming.Flow.no_new_dependence'),
                  (U+'all_end_at_model', U+'outside_leaves_no_offspring', 'Becoming.GroupEnding.Flow.all_end')]:
    w = lib.walk(R)
    print(R.split('.')[-1], 'theorems its proof names (draft 2 walk):', sorted(w))
    print('   other than F:', sorted(w - {F}))
    st = C[row]['t']
    print('   row statement names Dependence.level/Flow.taken/Flow.given:',
          [x for x in ('Becoming.Dependence.level','Becoming.Flow.taken','Becoming.Flow.given') if x in st],
          '; Flow anchors in statement closure:', [a for a in lib.FLOW if a in lib.closure(st)])
