#!/usr/bin/env python3
"""OU3e: the connectivity register after the bridges. OU3d's apart roots «迭内之接» and «存承之迭» now have consumers
(WithinMoves.after_course, Withholding.waitsAll_closed), so their entries go; any root the log lists without a reason
stops the script (it belongs to its owner), as does any other stale entry. The file round-trips through
json.dumps(indent=1), so it is edited as data.
usage (from the checkout root): python3 -B register_ou3e.py CONNECTIVITY_LOG"""
import json
import re
import sys
from pathlib import Path

F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
log = Path(sys.argv[1]).read_text(encoding='utf-8')


def listed(label):
    m = re.search(label + r"[^:]*: (\[[^\]]*\])", log)
    return [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]


unclassified = listed('apart roots without a reason in')
stale = listed('register entries no longer apart roots')
DROP = {'Becoming.«迭内之接»', 'Becoming.«存承之迭»'}
assert not unclassified, ('apart roots without a reason; for their owners', unclassified)
assert set(stale) <= DROP, ('stale entries not OU3e\'s', sorted(set(stale) - DROP))
t = F.read_text(encoding='utf-8')
d = json.loads(t)
assert json.dumps(d, ensure_ascii=False, indent=1) + '\n' == t, 'the register no longer round-trips; edit it by hand'
for name in stale:
    assert d['roots'][name]['module'] == 'Becoming.GrammarLaws', name
    del d['roots'][name]
F.write_text(json.dumps(d, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('register: dropped', len(stale), stale)
