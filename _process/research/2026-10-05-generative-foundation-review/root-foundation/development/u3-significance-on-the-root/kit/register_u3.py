#!/usr/bin/env python3
"""U3: register the apart root the connectivity check lists without a reason that is U3's, with a category and a
reason; stop on any other root, which belongs to its owner, and on a stale entry, which U3 does not expect.

* Row 10's interface law, `Weighting.grammar_widens_iff_every_positive`, stands apart: nothing uses it, and its
  statement (the grammar's «广» of what two courses admit over a listing, and additive weights positive on the listed
  items) reaches neither base family, as `Weighting.mixedOn_iff` does not (support, OU3b). The five theorems of
  `Becoming.SignificanceStatements` reach the base through `Web.paths`.

Textual edits, the rest of the file byte for byte (register_u2.py's pattern).
usage (from the checkout root): python3 -B register_u3.py CONNECTIVITY_LOG"""
import json
import re
import sys
from pathlib import Path

F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
log = Path(sys.argv[1]).read_text(encoding='utf-8')
m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
stale = re.search(r"register entries no longer apart roots: (\[[^\]]*\])", log)
stale_names = [] if not stale else [s.strip().strip("'\"") for s in stale.group(1).strip('[]').split(',') if s.strip()]
assert not stale_names, ('stale entries: U3 retires none; their owners do', stale_names)
reasons = {
    'Becoming.Weighting.grammar_widens_iff_every_positive': (
        'Becoming.Weightings', 'support',
        "the grammar's «广» of what one course admits over another, over a listing with two-valued admission, is "
        "exactly what every additive natural-number weighting positive on the listed items ranks higher: row 10 "
        "stated on its own carrier, the representation of the order every positive weighting shares over a listing; "
        "the weights are amounts, a second sort the grammar has none of (U3)"),
}
others = [n for n in unclassified if n not in reasons]
assert not others, ("apart roots not registered here: read them; another session's belong to their owners", others)
t = F.read_text(encoding='utf-8')
block = ''
for name in unclassified:
    module, category, reason = reasons[name]
    assert json.dumps(name, ensure_ascii=False) not in t, name
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": ' + json.dumps(module) + ',\n'
              '   "category": ' + json.dumps(category) + ',\n   "reason": ' + json.dumps(reason, ensure_ascii=False)
              + '\n  },\n')
if block:
    anchor = '  }\n },\n "instances": {'
    assert t.count(anchor) == 1
    t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
    json.loads(t)
    F.write_text(t, encoding='utf-8')
print('register: added', len(unclassified), unclassified)
