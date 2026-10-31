#!/usr/bin/env python3
"""BD2's landing (register_rr2.py's pattern): register the apart roots the connectivity check lists without a reason
that are BD2's, each with a category and a reason; stop on any other root, which belongs to its owner.

* GrammarCrossing's laws hold of every relation and region on any carrier: the base states its cut through
  Flow.cut_iff_notGoingOut and the crossing law through it (Becoming.ConveyanceBoundaries), and nothing on the base uses
  the others yet (general structure).
* «不出皆闭当且仅当排中» is the exact logical principle a stated law of the grammar needs (calibration in the
  register's sense: a lemma of the item that needs it, membership being any proposition).
* «闭而有入之例» is a fact about one constructed model (model witness).

Textual edits, the rest of the file byte for byte (register_rr2.py's pattern).
usage (from the checkout root): python3 -B register_bd2.py CONNECTIVITY_LOG"""
import json
import re
import sys
from pathlib import Path

F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
log = Path(sys.argv[1]).read_text(encoding='utf-8')
m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
stale = re.search(r"register entries no longer apart roots: (\[[^\]]*\])", log)
assert not (stale and stale.group(1).strip('[]').strip()), ("stale entries: read them; BD2's change may have made one",
                                                             stale.group(1))
GENERAL = ('a law of every relation and region on any carrier; the base states its cut as «不出» '
           '(Flow.cut_iff_notGoingOut), and nothing on it uses this law yet (BD2)')
REASONS = {
    'Becoming.«不出皆闭当且仅当排中»': ('calibration',
                                 'the exact logical principle a stated law of the grammar needs (excluded middle): '
                                 'that every region nothing goes out of is closed, membership being any proposition; '
                                 'a lemma of the item that needs it, «不外者内则不出当且仅当闭» (BD2)'),
    'Becoming.«闭而有入之例»': ('model-witness',
                           'a closed region come into along a relation that is not symmetric, on two occurrences: a '
                           'witness of Becoming.GrammarCrossing (BD2)'),
    'Becoming.«所闭不出»': ('general-structure', "an occurrence's closure is not gone out of, the closure law «所闭之界» "
                                            'read through «不出» and proved as it: ' + GENERAL),
    'Becoming.«逆之不出当且仅当外者不出»': ('general-structure',
                                    'nothing comes into a region exactly where nothing goes out of what lies outside '
                                    'it: ' + GENERAL),
    'Becoming.«对称则不出当且仅当逆不出»': ('general-structure',
                                    'along a symmetric relation nothing goes out exactly where nothing comes in: '
                                    + GENERAL),
    'Becoming.«内至外之线则非不出»': ('general-structure',
                                'a region a line leaves is not one nothing goes out of, with no decision: ' + GENERAL),
    'Becoming.«内至外之线有出步»': ('general-structure',
                               'where each step keeps to the region or goes out of it, a line from inside to outside '
                               'has a step going out, placed on it: ' + GENERAL),
    'Becoming.«定则内至外之线有出步»': ('general-structure',
                                 'where membership is decided, a line from inside to outside has a step going out, '
                                 'placed on it; «所经必同» is proved from it: ' + GENERAL),
    'Becoming.«不出当且仅当不外者闭»': ('general-structure',
                                 'not going out is exactly the closedness of what is not outside: ' + GENERAL),
}
others = [n for n in unclassified if n not in REASONS]
assert not others, ("apart roots not registered here: read them; another session's belong to their owners", others)
t = F.read_text(encoding='utf-8')
block = ''
for name in unclassified:
    assert json.dumps(name, ensure_ascii=False) not in t, name
    cat, reason = REASONS[name]
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "Becoming.GrammarCrossing",\n   "category": "'
              + cat + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
if block:
    anchor = '  }\n },\n "instances": {'
    assert t.count(anchor) == 1
    t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
    json.loads(t)
    F.write_text(t, encoding='utf-8')
print('register: added', len(unclassified), unclassified)
