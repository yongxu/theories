#!/usr/bin/env python3
"""RF round 2, second part, RF-M.2's landing (register_rf7.py's pattern): register the apart roots the connectivity check lists
without a reason that are RF's, each with a category and a reason; stop on any other root, which belongs to its owner.

* HeldForReading's laws hold of any finite model of candidates with natural-number weights, acts and values: the base
  supplies no reading of their vocabulary yet (general structure). They wait for a formation's own valuation and the
  reading formation's state, on the base (RF-M.3).
* The witness (HeldForReading.SignLoop) is a fact about one constructed loop (model witness).

Textual edits, the rest of the file byte for byte (register_wrt2.py's pattern).
usage (from the checkout root): python3 -B register_rfm2.py CONNECTIVITY_LOG"""
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
stale = [] if not stale else [s.strip().strip("'\"") for s in stale.group(1).strip('[]').split(',') if s.strip()]
# An entry no longer apart because HeldForReading now uses it is RF's to remove; any other stays with its owner.
HELD = (HERE / 'tree/Becoming/HeldForReading.lean').read_text(encoding='utf-8')
USED = {'Becoming.ListTests.all_mem': 'ListTests.all_mem'}
assert all(name in USED and USED[name] in HELD for name in stale), ("stale entries are their owners', not RF's", stale)
NAMES = {}
for mod in ('HeldForReading',):
    audit = (HERE / f'tree/.build/Becoming{mod}AxiomAudit.lean').read_text(encoding='utf-8')
    for name in re.findall(r'^#print axioms (\S+)$', audit, re.M):
        NAMES[name] = f'Becoming.{mod}'
WAIT = {
    'Becoming.HeldForReading': ('a law of any finite model of candidates with natural-number weights, acts and values '
                                '(what holding an act for a reading is worth); it waits for a formation\'s own valuation '
                                'and the reading formation\'s state, on the base (RF)'),
}
WITNESS = {  # the first key a name contains gives its reason
    '.SignLoop.': ('the reading loop whose candidates are the signs of going on, a held act answered by the true sign, '
                   'in an unmoving world (RF)'),
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
for name in stale:
    d = json.loads(t)
    assert name in d['roots'], name
    entry = '  ' + json.dumps(name, ensure_ascii=False) + ': ' + json.dumps(d['roots'][name], ensure_ascii=False, indent=1).replace('\n', '\n  ')
    assert t.count(entry) == 1, ('entry text', name)
    after = t.index(entry) + len(entry)
    if t.startswith(',\n', after):
        t = t[:t.index(entry)] + t[after + 2:]
    else:
        before = t.rindex(',\n', 0, t.index(entry))
        t = t[:before] + t[after:]
    d2 = json.loads(t)
    assert name not in d2['roots'] and len(d2['roots']) == len(d['roots']) - 1
if block:
    anchor = '  }\n },\n "instances": {'
    assert t.count(anchor) == 1
    t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
    json.loads(t)
    F.write_text(t, encoding='utf-8')
print('register: added', len(unclassified), unclassified, '; removed, now used by HeldForReading:', stale)
