#!/usr/bin/env python3
"""OU3f, laws of steps: register the apart roots connectivity lists without a reason that are this part's (the laws of
steps the lineage laws will use), each with a category and a reason; stop on any other root or stale entry. The register
round-trips through json.dumps(indent=1), so it is edited as data.
usage (from the checkout root): python3 -B register_laws.py CONNECTIVITY_LOG"""
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
WAIT = ', a law of every relation on any carrier, stated before the models\' lineage laws (Identity) use it (OU3f\'s next part)'
REASONS = {
    'Becoming.«迭之分»': 'steps split as they compose, the converse of «迭之接»' + WAIT,
    'Becoming.«迭之逆»': 'steps read backward are steps of the converse' + WAIT,
    'Becoming.«或有后则或迭»': 'where whatever is reached in fewer than n steps has a successor as far as can be refuted, n steps exist as far as can be refuted' + WAIT,
}
assert not (set(unclassified) - set(REASONS)), ('apart roots not this part\'s; for their owners', sorted(set(unclassified) - set(REASONS)))
assert not stale, ('stale entries; for their owners', stale)
t = F.read_text(encoding='utf-8')
d = json.loads(t)
assert json.dumps(d, ensure_ascii=False, indent=1) + '\n' == t, 'the register no longer round-trips; edit it by hand'
for name in unclassified:
    assert name not in d['roots'], name
    d['roots'][name] = {'module': 'Becoming.GrammarLaws', 'category': 'general-structure', 'reason': REASONS[name]}
F.write_text(json.dumps(d, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('register: added', len(unclassified), unclassified)
