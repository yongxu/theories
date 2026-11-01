#!/usr/bin/env python3
"""U4d's landing (register_el6.py's pattern): register the apart roots the connectivity check lists without a reason
that U4d's change explains, each with a category and a reason; stop on any other root, which belongs to its owner,
and on any stale entry not in U4D_STALE, which is read first. Stale entries U4d's change explains (helpers gone with
no consumer left) are removed. Textual edits, the rest of the file byte for byte.
usage (from the checkout root): python3 -B register_u4d.py CONNECTIVITY_LOG"""
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

GL = 'Becoming.GrammarLaws'
# set after reading the connectivity check of the rehearsal
REASONS = {}
U4D_STALE = set()
assert set(stale) <= U4D_STALE, ("stale entries U4d's change does not explain: read them", sorted(set(stale) - U4D_STALE))
others = [n for n in unclassified if n not in REASONS]
assert not others, ("apart roots not registered here: read them; another session's belong to their owners", others)
t = F.read_text(encoding='utf-8')
for name in stale:
    key = '  ' + json.dumps(name, ensure_ascii=False) + ': {\n'
    assert t.count(key) == 1, name
    i = t.index(key)
    j = t.index('\n  }', i) + len('\n  }')
    if t[j] == ',':
        t = t[:i] + t[j + 2:]
    else:
        assert t[i - 2:i] == ',\n', name
        t = t[:i - 2] + t[j:]
    json.loads(t)
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
print('register: added', len(unclassified), '; removed stale', len(stale), '; listed here but not apart roots now:',
      missing)
