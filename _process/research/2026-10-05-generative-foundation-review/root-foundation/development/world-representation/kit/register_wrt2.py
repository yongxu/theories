#!/usr/bin/env python3
"""WRT2: register the apart roots the connectivity check lists without a reason that are WRT2's, each with a category and
a reason; stop on any other root, which belongs to its owner, and on a WorldRepresentation root not named below.

* GrammarTransport's roots are laws of every relation on any carrier: a listed grammar term kept by a one-to-one
  correspondence of models. WorldRepresentation uses the ones its pattern needs; the others wait for consumers
  (general structure).
* WorldRepresentation's possible roots are named: the counter-model of F3 (a model witness) and the same-step class
  being a class (support).

Textual edits, the rest of the file byte for byte (register_ou3d.py's pattern).
usage (from the checkout root): python3 -B register_wrt2.py CONNECTIVITY_LOG"""
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
GT = set(re.findall(r'^#print axioms (\S+)$',
                    (HERE.parent / 'tree/.build/BecomingGrammarTransportAxiomAudit.lean').read_text(encoding='utf-8'),
                    re.M))
WAIT = ('a law of every relation on any carrier, the grammar term kept by a one-to-one correspondence carrying what it '
        'reads; WorldRepresentation uses the transport its pattern needs, and this one waits for a model reading the '
        'term through a correspondence (WRT2)')
NAMED = {
    'Becoming.Steps.along_endless': ('Becoming.WorldRepresentation', 'model-witness',
                                     'a line of steps under the class of a predicate holding everywhere goes on without '
                                     'end: the grammar model where every occurrence falls, the counter-model by which a '
                                     "line of falls ending is a condition of the World's image and no law of the grammar "
                                     '(WRT2)'),
    'Becoming.Web.sameStep_class': ('Becoming.WorldRepresentation', 'support',
                                    'being at the same step is a class: a one-line unpacking of Web.sameStep (WRT2)'),
}
reasons = {}
for name in unclassified:
    if name in GT:
        term = name.replace('Becoming.', '')
        reasons[name] = ('Becoming.GrammarTransport', 'general-structure', f'{term}: {WAIT}')
    elif name in NAMED:
        reasons[name] = NAMED[name]
others = [n for n in unclassified if n not in reasons]
assert not others, ("apart roots not registered here: read them; another session's belong to their owners", others)
t = F.read_text(encoding='utf-8')
# retire the entries no longer apart roots because WRT2 uses them on the base (F3 uses «尽则非不穷»)
RETIRE = ['Becoming.«尽则非不穷»']
stale_names = [] if not stale else [s.strip().strip("'\"") for s in stale.group(1).strip('[]').split(',') if s.strip()]
assert set(stale_names) <= set(RETIRE), ('stale entries not WRT2\'s: their owners retire them', stale_names)
for name in stale_names:
    start = t.index('  ' + json.dumps(name, ensure_ascii=False) + ': {\n')
    end = t.index('\n  },\n', start) + len('\n  },\n')
    t = t[:start] + t[end:]
    json.loads(t)
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
if not block and stale_names:
    F.write_text(t, encoding='utf-8')
print('register: added', len(unclassified), unclassified, '; retired', stale_names)
