#!/usr/bin/env python3
"""OU3c: register the apart roots connectivity lists without a reason that are OU3c's (the two relation laws moved into
the grammar, the image's fixed successor of a law), each with a category and a reason; stop on any other root, which
belongs to its owner. Textual edits, the rest of the file byte for byte (register_ou3b.py's pattern).
usage (from the checkout root): python3 -B register_ou3c.py CONNECTIVITY_LOG"""
import json
import re
import sys
from pathlib import Path

F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
log = Path(sys.argv[1]).read_text(encoding='utf-8')
m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
stale = re.search(r"register entries no longer apart roots: (\[[^\]]*\])", log)
REASONS = {
    'Becoming.strictJoin_trans': ('Becoming.GrammarLaws', 'support', 'a statement using only the prelude: a law of any '
                                  'two relations (a transitive one joined to the strict part of a transitive one containing '
                                  'it), beside the order laws of the grammar; the lagged orders are proved from it'),
    'Becoming.strictJoin_irrefl': ('Becoming.GrammarLaws', 'support', 'a statement using only the prelude: the join of an '
                                   'irreflexive relation with the strict part of any relation is irreflexive'),
    'Becoming.Learning.lumped_iff_fixed_image': ('Becoming.LearningRuns', 'support', "a one-line unpacking: a determined "
                                                 "law's lumping along a map is its image's fixed successor"),
}
others = [n for n in unclassified if n not in REASONS]
assert not others, ('apart roots not OU3c\'s; they belong to their owners', others)
t = F.read_text(encoding='utf-8')
block = ''
for name in unclassified:
    assert json.dumps(name, ensure_ascii=False) not in t, name
    mod, cat, reason = REASONS[name]
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "' + mod + '",\n   "category": "' + cat
              + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
if block:
    anchor = '  }\n },\n "instances": {'
    assert t.count(anchor) == 1
    t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
    json.loads(t)
    F.write_text(t, encoding='utf-8')
print('register: added', len(unclassified), unclassified, '; stale entries reported:', stale.group(1) if stale else None)
