#!/usr/bin/env python3
"""UE27's landing (register_ue26.py's pattern): register the apart roots the connectivity check lists without a
reason that are BlanketCouplings', each with a category and a reason; stop on any other root, which belongs to its
owner.

* BlanketCouplings' laws hold of any web, formation, couplings, model, policy and environment, or of any family of
  courses and any reading into four parts: the base supplies no blanketed reading of a formation yet (general
  structure).
* The witnesses (ReadsExternal, ThresholdCase, and parting, partingLate, clocked_witness, clock_only_fails and
  injective_converse_fails) are facts about one constructed model (model witness).

Textual edits, the rest of the file byte for byte.
usage (from the checkout root): python3 -B register_ue27.py CONNECTIVITY_LOG"""
import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
M = 'Becoming.BlanketCouplings'
WITNESS_SPACES = ('ReadsExternal', 'ThresholdCase')
WITNESS_NAMES = ('parting', 'partingLate', 'clocked_witness', 'clock_only_fails', 'injective_converse_fails')
log = Path(sys.argv[1]).read_text(encoding='utf-8')
m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
stale = re.search(r"register entries no longer apart roots: (\[[^\]]*\])", log)
assert not (stale and stale.group(1).strip('[]').strip()), ('stale entries: read them', stale.group(1))
audit = (HERE.parent / 'tree/.build/BecomingBlanketCouplingsAxiomAudit.lean').read_text(encoding='utf-8')
NAMES = set(re.findall(r'^#print axioms (\S+)$', audit, re.M))
GENERAL = ('a law of any web, formation, couplings, model, policy and environment, or of any family of courses and '
           'any reading into four parts (which blanket a thing has); the base supplies no blanketed reading of a '
           'formation yet (UE27)')
WITNESS = 'a fact about one constructed model: a run, a pair of courses or the threshold witness\'s web (UE27)'
reasons = {}
for name in unclassified:
    if name not in NAMES:
        continue
    short = name.replace('Becoming.', '')
    if any(f'{M}.{w}.' in name for w in WITNESS_SPACES) or name in {f'{M}.{w}' for w in WITNESS_NAMES}:
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
