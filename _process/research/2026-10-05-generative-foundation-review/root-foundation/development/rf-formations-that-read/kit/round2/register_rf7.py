#!/usr/bin/env python3
"""RF round 2, RF7's landing (register_rf61.py's pattern): register the apart roots the connectivity check lists
without a reason that are RF's, each with a category and a reason; stop on any other root, which belongs to its owner.

* ReadStages' laws hold of any two-stage prospects in natural-number weights: the base supplies no reading of their
  vocabulary yet (general structure). They wait for a formation's own order and the selection a reading applies, on
  the base.
* The witnesses (ReadStages.Example) are facts about one constructed model (model witness).

Textual edits, the rest of the file byte for byte (register_wrt2.py's pattern).
usage (from the checkout root): python3 -B register_rf7.py CONNECTIVITY_LOG"""
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
for mod in ('ReadStages',):
    audit = (HERE / f'tree/.build/Becoming{mod}AxiomAudit.lean').read_text(encoding='utf-8')
    for name in re.findall(r'^#print axioms (\S+)$', audit, re.M):
        NAMES[name] = f'Becoming.{mod}'
WAIT = {
    'Becoming.ReadStages': ('a law of any two-stage prospects in natural-number weights (when complying when read and '
                            'acting by its own law when not is best); it waits for a formation\'s own order and the '
                            'selection a reading applies, on the base (RF)'),
}
WITNESS = {  # the first key a name contains gives its reason, so no_total's comes first
    '.Example.no_total': 'prospects with a total of 0, weights 1 and 0, a value of 1 and a loss of 100, not valid (RF)',
    '.Example.': 'prospects of a total of 10, weights 9 and 1, a value of 10 and a loss of 5, and their variations (RF)',
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
