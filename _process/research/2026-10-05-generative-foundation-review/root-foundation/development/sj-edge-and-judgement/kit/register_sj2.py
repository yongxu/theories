#!/usr/bin/env python3
"""SJ's last landing (register_sj.py's pattern): the connectivity register after GuardHorizon's bridge.

GuardHorizon's two new theorems may be apart roots: uniform_policy_iff_common, a law of every reading of any type
(general structure), and ungiven_reading_not_uniform, a constructed witness (model witness); each is registered with
its reason if the check lists it. The re-proof of statewise_not_uniform from the leaf's witness, and the bridge's use of
the leaf's law along the reading itself, make five of SJ1's registered roots used by an apart theorem, so no longer
roots: those entries are removed, and only those (STALE_OK). Any other unregistered root or stale entry stops the
script, to be read first: it belongs to its owner.

Textual edits, the rest of the file byte for byte.
usage (from the checkout root): python3 -B register_sj2.py CONNECTIVITY_LOG"""
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
B, E = 'Becoming.', 'Becoming.«共应之例».'
STALE_OK = {B + '«依读而应则共应»', B + '«共应之细»', E + 'EachNotCommon.each', E + 'EachNotCommon.none',
            B + '«自反传递则共应当且仅当承遍»'}
bad = [n for n in stale if n not in STALE_OK]
assert not bad, ("stale entries SJ's last landing does not explain: read them", bad)

M = 'Becoming.GuardHorizon'
REASONS = {
    M + '.uniform_policy_iff_common': (M, 'general-structure',
        "a law of every reading of any type of configurations: given choice over the readings and every reading given, "
        "a choice from readings exists exactly where a response common over the reading's sameness does, through the "
        "core's «自反传递则共应当且仅当承遍» (SJ, GuardHorizon's bridge to the leaf); nothing on the base uses it"),
    M + '.ungiven_reading_not_uniform': (M, 'model-witness',
        "a fact about one constructed reading no configuration gives: a common response with no choice from readings, "
        "a witness that the bridge's second hypothesis does work (SJ)"),
}
others = [n for n in unclassified if n not in REASONS]
assert not others, ("apart roots not registered here: read them; another session's belong to their owners", others)

t = F.read_text(encoding='utf-8')
for name in stale:
    key = json.dumps(name, ensure_ascii=False)
    pat = re.compile(r'  ' + re.escape(key) + r': \{\n(?:   [^\n]*\n)+?  \},?\n')
    found = pat.findall(t)
    assert len(found) == 1, (name, len(found))
    t = t.replace(found[0], '', 1)
# a removed last entry would leave a trailing comma before the closing brace
t = re.sub(r'\},\n \},\n "instances"', '}\n },\n "instances"', t)
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
print('register: added', unclassified, '; removed', stale, '; listed here but not apart roots now:',
      sorted(set(REASONS) - set(unclassified)))
