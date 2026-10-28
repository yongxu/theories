#!/usr/bin/env python3
"""OU3d: register the apart roots connectivity lists without a reason that are OU3d's (the laws of steps counted on
the grammar, stated before any consumer bridges to them), each with a category and a reason; stop on any other root,
which belongs to its owner. Textual edits, the rest of the file byte for byte (register_ou3c.py's pattern).
usage (from the checkout root): python3 -B register_ou3d.py CONNECTIVITY_LOG"""
import json
import re
import sys
from pathlib import Path

F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
log = Path(sys.argv[1]).read_text(encoding='utf-8')
m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
stale = re.search(r"register entries no longer apart roots: (\[[^\]]*\])", log)
AWAITING = ('stated before the models\' step-indexed laws (Withholding, Tolerance, Labelled) bridge to it, so nothing '
            'on the base uses it yet (OU3d)')
REASONS = {
    'Becoming.«迭之末步»': ('Becoming.GrammarLaws', 'general-structure', 'n + 1 steps are n steps and then the last, a law of '
                         'every relation on any carrier: the grammar\'s steps read last step last, which the law of '
                         'taking on uses; ' + AWAITING),
    'Becoming.«迭内之接»': ('Becoming.GrammarLaws', 'general-structure', 'within m steps and then within n is within '
                          'm + n, a law of every relation on any carrier; ' + AWAITING),
    'Becoming.«迭内即静或缘之迭»': ('Becoming.GrammarLaws', 'general-structure', 'within n steps is n steps each of which '
                              'stays or steps, a law of every relation on any carrier, by which the law with memory is the '
                              'law without; ' + AWAITING),
    'Becoming.«承之迭»': ('Becoming.GrammarLaws', 'general-structure', 'a course of regions taking on at each round what '
                         'every condition held holds at round n where everything reaching in n steps held at the '
                         'start, a law of every relation on any carrier; ' + AWAITING),
    'Becoming.«存承之迭»': ('Becoming.GrammarLaws', 'general-structure', 'with memory, within n steps: the law of '
                          'taking on under staying or a step, a law of every relation on any carrier; ' + AWAITING),
}
others = [n for n in unclassified if n not in REASONS]
assert not others, ('apart roots not OU3d\'s; they belong to their owners', others)
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
