#!/usr/bin/env python3
"""WRP2: register the apart roots the connectivity check lists without a reason that are WRP2's, each with a category
and a reason; stop on any other root, which belongs to its owner, and on a ProcessRepresentation or GrammarLaws root,
which this kit does not expect (ProcessRepresentation's statements read processes and frames; GrammarLaws' additions
are used by the laws of «迭» they carry).

* GrammarTransport's new roots are laws of every relation on any carrier: a grammar term kept by a one-to-one
  correspondence carrying what it reads. ProcessRepresentation uses the transport along maps it needs («保之像»); the
  correspondence lemmas for the terms it reads wait for a model reading them through a correspondence (general
  structure), as WRT2's do.

Textual edits, the rest of the file byte for byte (register_wrt2.py's pattern).
usage (from the checkout root): python3 -B register_wrp2.py CONNECTIVITY_LOG"""
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
added = json.loads((HERE.parent / 'signatures.json').read_text(encoding='utf-8'))['modules']
GT = set(added['Becoming.GrammarTransport']['added'])
WAIT = ('a law of every relation on any carrier, the grammar term kept by a one-to-one correspondence carrying what it '
        'reads; ProcessRepresentation reads the term on processes, and this one waits for a model reading it through '
        'a correspondence (WRP2)')
reasons = {}
for name in unclassified:
    if name in GT:
        reasons[name] = ('Becoming.GrammarTransport', 'general-structure', f"{name.replace('Becoming.', '')}: {WAIT}")
others = [n for n in unclassified if n not in reasons]
assert not others, ("apart roots not registered here: read them; another session's belong to their owners", others)
stale_names = [] if not stale else [s.strip().strip("'\"") for s in stale.group(1).strip('[]').split(',') if s.strip()]
assert not stale_names, ('stale entries: read them, and retire only those WRP2 made no longer apart', stale_names)
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
