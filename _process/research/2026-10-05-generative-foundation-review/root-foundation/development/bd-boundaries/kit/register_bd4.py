#!/usr/bin/env python3
"""BD4's landing (register_bd3.py's pattern): register the apart roots the connectivity check lists without a reason
that are BD4's, each with a category and a reason; stop on any other root, which belongs to its owner, and on any
stale entry, which BD4's change (BD3's leaf extended, no other module changed) does not explain and is read first.

* balancing_iff_closures is the one-step form for any levels; the base's case on webs, balancesOn_iff_closures, goes
  through balancesOn_iff_conserved, so nothing on the base uses it (general structure); likewise the web form.
* pairing_iff_closures and pairing_iff_closure_counts are the unit grain's case of the count law of a class; nothing on
  the base uses them (general structure).
* The other new declarations (the counting lemmas, the reach and its closure, the decomposition) are steps of these
  laws, so expected connected through them; their reasons are kept in case the measure places one apart.

Textual edits, the rest of the file byte for byte (register_bd3.py's pattern).
usage (from the checkout root): python3 -B register_bd4.py CONNECTIVITY_LOG"""
import json
import re
import sys
from pathlib import Path

F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
log = Path(sys.argv[1]).read_text(encoding='utf-8')
m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
stale = re.search(r"register entries no longer apart roots: (\[[^\]]*\])", log)
stale = [] if not stale else [s.strip().strip("'\"") for s in stale.group(1).strip('[]').split(',') if s.strip()]
assert not stale, ("stale entries BD4's change does not explain: read them", stale)
GENERAL = ('for every Bool relation and list of relata on any type, equality decided; the base reads balance '
           'through balancesOn_iff_conserved, and nothing on it uses this law (BD4)')
STEP = 'a step of the closure laws of BD4, for any type, used by them and by nothing on the base (BD4)'
C = 'Becoming.Continuity.'
REASONS = {
    C + 'balancing_iff_closures': ('general-structure',
                                   'relata listed without repetition and equality decided, transfers balancing a step '
                                   'exist exactly where the total is conserved on the closure of each listed relatum '
                                   '(«所闭» along the listed adjacency): ' + GENERAL),
    C + 'balancesOn_iff_closures': ('general-structure',
                                    'on a web, transfers balancing every step exist exactly where the levels are '
                                    'conserved at every step on the closure of each listed relatum: ' + GENERAL),
    C + 'pairing_iff_closures': ('general-structure',
                                 'at the unit grain, two lists are paired under the closure along the listed '
                                 'adjacency exactly where each closure keeps its count, a case of '
                                 '«类之对当且仅当类类等数»: ' + GENERAL),
    C + 'pairing_iff_closure_counts': ('general-structure',
                                       'for any symmetric relation whose closure a test decides, a pairing under the '
                                       'closure is the count kept on each closure, a case of «类之对当且仅当类类等数»; '
                                       'nothing on the base uses it (BD4)'),
    C + 'conservedOn_iff_closures': ('general-structure',
                                     'conservation on every family the relation closes is conservation on each '
                                     'closure: ' + GENERAL),
    C + 'closureListed_iff': ('general-structure',
                              'the closure along the listed adjacency, «所闭», decided as a test, for every relatum: '
                              + GENERAL),
    C + 'closureListed_closes': ('support', STEP),
    C + 'closureListed_closed': ('support', STEP),
    C + 'closureListed_inside': ('support', STEP),
    C + 'closureListed_self': ('support', STEP),
    C + 'reachedListed_within': ('support', STEP),
    C + 'reachedListed_add': ('support', STEP),
    C + 'reachedListed_stays': ('support', STEP),
    C + 'reachedListed_grows_or_stays': ('support', STEP),
    C + 'closes_and_not': ('support', STEP),
    C + 'within_split': ('support', STEP),
    C + 'conserved_of_absent': ('support', STEP),
    C + 'conserved_peel': ('support', STEP),
    C + 'conserved_of_closures': ('support', STEP),
    C + 'cond_le_cond': ('support', 'a count lemma on the grammar\'s «计», a step of the closure laws (BD4)'),
    C + 'count_le_count': ('support', 'a count lemma on the grammar\'s «计», a step of the closure laws (BD4)'),
    C + 'count_lt_count': ('support', 'a count lemma on the grammar\'s «计», a step of the closure laws (BD4)'),
    C + 'count_true': ('support', 'a count lemma on the grammar\'s «计», a step of the closure laws (BD4)'),
    C + 'counted_of_count': ('support', 'a count lemma on the grammar\'s «计», a step of the closure laws (BD4)'),
}
others = [n for n in unclassified if n not in REASONS]
assert not others, ("apart roots not registered here: read them; another session's belong to their owners", others)
t = F.read_text(encoding='utf-8')
block = ''
for name in unclassified:
    assert json.dumps(name, ensure_ascii=False) not in t, name
    cat, reason = REASONS[name]
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "Becoming.BalanceRegions",\n   "category": "'
              + cat + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
if block:
    anchor = '  }\n },\n "instances": {'
    assert t.count(anchor) == 1
    t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
    json.loads(t)
    F.write_text(t, encoding='utf-8')
print('register: added', len(unclassified), unclassified)
