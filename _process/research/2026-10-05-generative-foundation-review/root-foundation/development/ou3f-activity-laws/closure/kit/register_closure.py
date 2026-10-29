#!/usr/bin/env python3
"""OU3f, closure: drop the register entries connectivity lists as no longer apart roots that this part's law gives a
consumer («闭含所闭», which kept_onward uses); stop on any other stale entry or any unregistered apart root.
usage (from the checkout root): python3 -B register_closure.py CONNECTIVITY_LOG"""
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
OURS = {'Becoming.«闭含所闭»'}
assert not unclassified, ('apart roots without a reason; for their owners', unclassified)
assert set(stale) <= OURS, ('stale entries not this part\'s; for their owners', sorted(set(stale) - OURS))
t = F.read_text(encoding='utf-8')
d = json.loads(t)
assert json.dumps(d, ensure_ascii=False, indent=1) + '\n' == t, 'the register no longer round-trips; edit it by hand'
for name in stale:
    del d['roots'][name]
F.write_text(json.dumps(d, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('register: dropped', stale)
