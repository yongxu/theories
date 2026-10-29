#!/usr/bin/env python3
"""RF round 2, first landing (round 1's register_rf.py): register the apart roots the connectivity check lists without
a reason that are RF's, each with a category and a reason; stop on any other root, which belongs to its owner.

* The two modules' laws are laws of any types (a joint carrier of world and state, blanketed laws, a loop keeping
  candidates, responses to a published prediction): the base supplies no reading of their vocabulary yet (general
  structure). They wait for a model reading them on the base: a formation of the World as the internal part of a
  blanketed law, a public prediction read by a pool.
* The witnesses (PairwiseShared, Untested, ThresholdResponse, Negating, Reflecting) are facts about one constructed
  model (model witness).

Textual edits, the rest of the file byte for byte (register_wrt2.py's pattern).
usage (from the checkout root): python3 -B register_rf.py CONNECTIVITY_LOG"""
import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
log = Path(sys.argv[1]).read_text(encoding='utf-8')
m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
stale = re.search(r"register entries no longer apart roots: (\[[^\]]*\])", log)
assert not (stale and stale.group(1).strip('[]').strip()), ('stale entries are their owners\', not RF\'s', stale.group(1))
NAMES = {}
for mod in ('ReadingLoop', 'ReflexivePrediction'):
    audit = (HERE / f'tree/.build/Becoming{mod}AxiomAudit.lean').read_text(encoding='utf-8')
    for name in re.findall(r'^#print axioms (\S+)$', audit, re.M):
        NAMES[name] = f'Becoming.{mod}'
WAIT = {
    'Becoming.ReadingLoop': ('a law of any types (the reading loop: a joint carrier of world and state, blanketed laws, '
                             'a loop keeping candidate laws); it waits for a formation of the World read as the '
                             'internal part of a blanketed law (RF)'),
    'Becoming.ReflexivePrediction': ('a law of any type of values (a prediction read by what it predicts); it waits for '
                                     'a public prediction read by a pool on the base (RF)'),
}
WITNESS = {
    '.PairwiseShared.': 'three worlds and three acts, each good where it is not the act its world names (RF)',
    '.Untested.': 'two worlds alike on a known act and apart on an untried one, with candidates the two worlds (RF)',
    '.ThresholdResponse.': 'a threshold response on 0, 1, 2 with two right predictions (RF)',
    '.Negating.': 'Boolean negation, leaving no value fixed (RF)',
    '.Reflecting.': 'the reflection 2 - v on 0, 1, 2, reversing the order and leaving 1 fixed (RF)',
}
reasons = {}
for name in unclassified:
    mod = NAMES.get(name)
    if mod is None:
        continue
    witness = next((w for part, w in WITNESS.items() if part in name), None)
    if witness is not None:
        reasons[name] = (mod, 'model-witness', f"{name.replace('Becoming.', '')}: a fact about one constructed model, "
                                               f'{witness}')
    else:
        reasons[name] = (mod, 'general-structure', f"{name.replace('Becoming.', '')}: {WAIT[mod]}")
others = [n for n in unclassified if n not in reasons]
assert not others, ("apart roots not registered here: read them; another session's belong to their owners", others)
t = F.read_text(encoding='utf-8')
block = ''
for name in unclassified:
    assert json.dumps(name, ensure_ascii=False) not in t, name
    mod, cat, reason = reasons[name]
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "' + mod + '",\n   "category": "' + cat
              + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
if block:
    anchor = '  }\n },\n "instances": {'
    assert t.count(anchor) == 1
    t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
    json.loads(t)
    F.write_text(t, encoding='utf-8')
print('register: added', len(unclassified), unclassified)
