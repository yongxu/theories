#!/usr/bin/env python3
"""RF round 1 (WRT2's register_wrt2.py): register the apart roots the connectivity check lists without a reason that are
RF's, each with a category and a reason; stop on any other root, which belongs to its owner.

* The three modules' laws are laws on any carrier (choice occasions, lumpings of occasions, members in turn): the base
  supplies no reading of their vocabulary yet (general structure). They wait for a model reading them on the base:
  a training's choices (RF round 2's mechanism), an overseer's schedule, a pool of members in turn.
* The witnesses (Untried, Cue, Copying) are facts about one constructed model (model witness).

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
for mod in ('ShownOrder', 'Unread', 'Cascade'):
    audit = (HERE / f'tree/.build/Becoming{mod}AxiomAudit.lean').read_text(encoding='utf-8')
    for name in re.findall(r'^#print axioms (\S+)$', audit, re.M):
        NAMES[name] = f'Becoming.{mod}'
WAIT = {
    'Becoming.ShownOrder': ('a law of every carrier of alternatives and every family of occasions (what choices show of '
                           'the order they come from); it waits for a model reading choices on the base, a training\'s '
                           'or a helper\'s (RF round 2) (RF)'),
    'Becoming.Unread': ('a law of every lumping of occasions (what readings fix of the unread); it waits for a model '
                        'reading an overseer\'s schedule on the base (RF)'),
    'Becoming.Cascade': ('a law of members in turn on any types (readers reading readers); it waits for a pool of members '
                         'in turn on the base (RF)'),
}
WITNESS = {
    'Becoming.ShownOrder': 'one occasion with a third alternative never met, and one search run with two orders (RF)',
    'Becoming.Unread': 'occasions with a cue and a content, read where the cue is up (RF)',
    'Becoming.Cascade': 'members copying the first act (RF)',
}
reasons = {}
for name in unclassified:
    mod = NAMES.get(name)
    if mod is None:
        continue
    if any(part in name for part in ('.Untried.', '.Cue.', '.Copying.')):
        reasons[name] = (mod, 'model-witness', f"{name.replace('Becoming.', '')}: a fact about one constructed model, "
                                               f'{WITNESS[mod]}')
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
