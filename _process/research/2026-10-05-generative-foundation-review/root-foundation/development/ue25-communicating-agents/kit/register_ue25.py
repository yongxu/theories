#!/usr/bin/env python3
"""UE25's landing (register_rr.py's pattern): register the apart roots the connectivity check lists without a reason
that are CountedCodes', each with a category and a reason; stop on any other root, which belongs to its owner.

* CountedCodes' laws hold of any counts agents hold of words for meanings, or of any natural counts and weights over a
  listing: the base supplies no reading of agents, meanings or words yet (general structure).
* The witnesses (CountedCodes.Witness) are facts about one constructed model (model witness).

Textual edits, the rest of the file byte for byte.
usage (from the checkout root): python3 -B register_ue25.py CONNECTIVITY_LOG"""
import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
M = 'Becoming.CountedCodes'
log = Path(sys.argv[1]).read_text(encoding='utf-8')
m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
stale = re.search(r"register entries no longer apart roots: (\[[^\]]*\])", log)
assert not (stale and stale.group(1).strip('[]').strip()), ('stale entries: read them', stale.group(1))
audit = (HERE / 'tree/.build/BecomingCountedCodesAxiomAudit.lean').read_text(encoding='utf-8')
NAMES = set(re.findall(r'^#print axioms (\S+)$', audit, re.M))
GENERAL = ('a law of any counts agents hold of words for meanings, or of any natural counts and weights over a listing '
           '(the code law for beliefs held as counts); the base supplies no reading of agents, meanings or words yet '
           '(UE25)')
WITNESS = 'a fact about one constructed model of two agents, two words and one meaning (UE25)'
reasons = {}
for name in unclassified:
    if name not in NAMES:
        continue
    short = name.replace('Becoming.', '')
    if '.Witness.' in name:
        reasons[name] = ('model-witness', f'{short}: {WITNESS}')
    else:
        reasons[name] = ('general-structure', f'{short}: {GENERAL}')
others = [n for n in unclassified if n not in reasons]
assert not others, ("apart roots not registered here: read them; another session's belong to their owners", others)
t = F.read_text(encoding='utf-8')
block = ''
for name in unclassified:
    assert json.dumps(name, ensure_ascii=False) not in t, name
    cat, reason = reasons[name]
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "' + M + '",\n   "category": "' + cat
              + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
if block:
    anchor = '  }\n },\n "instances": {'
    assert t.count(anchor) == 1
    t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
    json.loads(t)
    F.write_text(t, encoding='utf-8')
print('register: added', len(unclassified), unclassified)
