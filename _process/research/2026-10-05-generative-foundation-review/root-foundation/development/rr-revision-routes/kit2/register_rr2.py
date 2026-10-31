#!/usr/bin/env python3
"""RR2's landing (register_rr.py's pattern): register the apart roots the connectivity check lists without a reason
that are RR2's, each with a category and a reason; stop on any other root, which belongs to its owner.

* RevisionPlans' laws hold of any plans on any listing in natural-number weights: the base supplies no reading of
  their vocabulary yet (general structure). They wait for a formation's own model and a reading's revision of its law,
  on the base. HeldForReading's new laws (its moves and rules as plans) are of the same kind.
* The witnesses (RevisionPlans.Example) are facts about one constructed model (model witness).

Textual edits, the rest of the file byte for byte (register_wrt2.py's pattern).
usage (from the checkout root): python3 -B register_rr2.py CONNECTIVITY_LOG"""
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
assert not (stale and stale.group(1).strip('[]').strip()), ('stale entries: read them; RR2\'s change may have made one', stale.group(1))
NAMES = {}
for mod in ('RevisionPlans', 'HeldForReading'):
    audit = (HERE / f'tree/.build/Becoming{mod}AxiomAudit.lean').read_text(encoding='utf-8')
    for name in re.findall(r'^#print axioms (\S+)$', audit, re.M):
        NAMES[name] = f'Becoming.{mod}'
WAIT = {
    'Becoming.RevisionPlans': ('a law of any plans keeping a law going on and switching it off at a listing\'s '
                               'candidates in natural-number weights (when holding for a reading stands above a route of '
                               'keeping); it waits for a formation\'s own model and a reading\'s revision of its law, on '
                               'the base (RR2)'),
    'Becoming.HeldForReading': ('a law of any model\'s two moves and rules of stopping as plans in natural-number '
                                'weights; it waits for a formation\'s own model and the reading it holds for, on the base '
                                '(RF, RR2)'),
}
WITNESS = {  # the first key a name contains gives its reason
    'RevisionPlans.Example.': ('two candidates of weight one, keeping gaining three at one and switching off two at the '
                               'other, evading at loss one, and its variations (RR2)'),
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
