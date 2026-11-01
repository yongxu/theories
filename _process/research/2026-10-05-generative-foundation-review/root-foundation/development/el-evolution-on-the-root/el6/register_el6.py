#!/usr/bin/env python3
"""EL6's landing (register_el.py's pattern): register the apart roots the connectivity check lists without a reason
that EL6's change explains, each with a category and a reason; stop on any other root, which belongs to its owner,
and on any stale entry, which is read first.

What EL6 explains: Web.ends_or_reaches, whose one use was the old proof of Web.degenerates_of_gone, now
Web.end_of_gone, proved from degeneration; and any of LineDegeneration's moved roots, under their modules. The two
renamed roots of the grammar part are already registered on the branch, under GrammarMap.
Textual edits, the rest of the file byte for byte.
usage (from the checkout root): python3 -B register_el6.py CONNECTIVITY_LOG"""
import json
import re
import sys
from pathlib import Path

F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
log = Path(sys.argv[1]).read_text(encoding='utf-8')
m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
stale = re.search(r"register entries no longer apart roots: (\[[^\]]*\])", log)
stale = [] if not stale else [s.strip().strip("'\"") for s in stale.group(1).strip('[]').split(',') if s.strip()]
assert not stale, ("stale entries EL6's change does not explain: read them", stale)

MI = 'Becoming.MapInstances'
REASONS = {
    'Becoming.Web.ends_or_reaches': (MI, 'general-structure',
        'where going on is decided at the points of a line, the line reaches an end or an occurrence at every later '
        'step: a law of the base\'s lines along any class; its one use was the old proof of Web.end_of_gone, which now '
        'follows from degeneration (EL6)'),
}
others = [n for n in unclassified if n not in REASONS]
assert not others, ("apart roots not registered here: read them; another session's belong to their owners", others)
t = F.read_text(encoding='utf-8')
block = ''
for name in unclassified:
    assert json.dumps(name, ensure_ascii=False) not in t, name
    module, cat, reason = REASONS[name]
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "' + module + '",\n   "category": "'
              + cat + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
if block:
    anchor = '  }\n },\n "instances": {'
    assert t.count(anchor) == 1
    t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
    json.loads(t)
    F.write_text(t, encoding='utf-8')
missing = sorted(set(REASONS) - set(unclassified))
print('register: added', len(unclassified), '; listed here but not apart roots now:', missing)
