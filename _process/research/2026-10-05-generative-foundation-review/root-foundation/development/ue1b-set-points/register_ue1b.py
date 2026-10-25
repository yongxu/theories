#!/usr/bin/env python3
"""UE1b: register the apart roots of Becoming.SetPointOptimum that connectivity lists without a reason, each with a
category and a reason; textual edits, the rest of the file byte for byte (UE1's register_ue1.py).

A root is placed in the module only where the receipt lists it among Becoming.SetPointOptimum's declarations, since the
module's names share the namespaces Optimum, Optimum.Drain and Flow with Becoming.Optimum. An apart root of any other
module stops the script: it is not UE1b's to register. The three general laws of the exchange that Becoming.Optimum
gains state Flow.Outcome and Above, so they reach the base and are not apart.

usage (from the checkout root of the landing worktree, after a connectivity run whose --check output is saved):
  python3 -B <kit>/register_ue1b.py CONNECTIVITY_LOG RECEIPT"""
import json
import re
import sys
from pathlib import Path

PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
MODULE = 'Becoming.SetPointOptimum'
log = Path(sys.argv[1]).read_text(encoding='utf-8')
core = json.loads(Path(f'{PKG}/becoming-checks/{sys.argv[2]}/verification.json').read_text())
assert core['status'] == 'passed'
names = {d['name'] for d in next(m for m in core['modules'] if m['module'] == MODULE)['declarations']}
m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
mine = [n for n in unclassified if n in names]
others = [n for n in unclassified if n not in names]
assert not others, ('apart roots of other modules unclassified; not UE1b\'s to register', others)

O = 'Becoming.Optimum.'
WITNESS = {
    O + 'Spread.': ('two ways of reaching a set point, one emptying a condition beyond: a witness that the order by '
                    'distance with the beyond counted after leaves the most beyond in total, not at each condition '
                    '(Becoming.SetPointOptimum, UE1b)'),
    O + 'Skew.': ('an order by a measure of deviation from two that weighs each unit over three times and each unit '
                  'under once: a witness that a nearing order need not weigh both sides alike (Becoming.SetPointOptimum, '
                  'UE1b)'),
    O + 'Drain.': 'a witness of orders with a set point on the splits of three units (Becoming.SetPointOptimum, UE1b)',
    O + 'Topped.': ('a witness of orders with a set point in one step of exchange from a store at its set point '
                    '(Becoming.SetPointOptimum, UE1b)'),
    O + 'TwoStores.': 'a witness of the joint draw of two nearing takers (Becoming.SetPointOptimum, UE1b)',
    O + 'HeldPair.': 'a witness of joint excess for two formations holding stores (Becoming.SetPointOptimum, UE1b)',
}
ARITHMETIC = 'an arithmetic or list lemma used by the module\'s laws (Becoming.SetPointOptimum, UE1b)'
arithmetic = {O + 'sub_le_sub_iff', O + 'sub_lt_sub_iff', O + 'total_le_of_only'}
UNPACK = 'a one-line unpacking of the module\'s own definitions (Becoming.SetPointOptimum, UE1b)'
unpack = {O + s for s in ('setPoint_between', 'gapTo_eq_zero', 'total_gapTo_eq_zero', 'atSetPoint_single',
                          'gapTo_of_upTo', 'Nearer.gaps', 'byGapThen_asymm', 'nearer_of_atSetPoint')}
LAW = ('a law of every order nearing a set point, over any outcomes: the base states no such order, so nothing on it '
       'uses this law (Becoming.SetPointOptimum, UE1b)')


def classify(name):
    for space, reason in WITNESS.items():
        if name.startswith(space):
            return 'model-witness', reason
    if name in arithmetic:
        return 'support', ARITHMETIC
    if name in unpack:
        return 'support', UNPACK
    return 'general-structure', LAW


t = F.read_text(encoding='utf-8')
block = ''
for name in mine:
    assert json.dumps(name, ensure_ascii=False) not in t, name
    cat, reason = classify(name)
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "' + MODULE + '",\n   "category": "'
              + cat + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
if block:
    anchor = '  }\n },\n "instances": {'
    assert t.count(anchor) == 1
    t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
    json.loads(t)
    F.write_text(t, encoding='utf-8')
print('register: added', len(mine), {c: sum(1 for n in mine if classify(n)[0] == c) for c in
                                      ('general-structure', 'support', 'model-witness')})
