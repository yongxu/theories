#!/usr/bin/env python3
"""U4e's landing (register_u4d.py's pattern): the root form «有覆而亡屡则生不止», registered by U4d as an apart root with
no use on the base, is used now by Identity's Web.arisingFrom_not_stopping_covered, so its entry is stale and goes.
Any apart root without a reason, and any other stale entry, stops the script: they are read first and belong to
their owners. Textual edits, the rest of the file byte for byte.
usage (from the checkout root): python3 -B register_u4e.py CONNECTIVITY_LOG"""
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
U4E_STALE = {'Becoming.«有覆而亡屡则生不止»'}
assert not unclassified, ("apart roots without a reason: read them; another session's belong to their owners",
                          unclassified)
assert set(stale) == U4E_STALE, ('stale entries other than the root form U4e uses: read them', sorted(stale))
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
F.write_text(t, encoding='utf-8')
print('register: removed stale', stale)
