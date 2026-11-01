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
# set after reading the connectivity check of the rehearsal (1 November 2026)
REASONS = {
    'Becoming.«有覆而亡屡则生不止»': (GL, 'general-structure',
        'a law of every relation on any carrier (a shared law on the grammar, U4d): with lists covering arbitrarily '
        'late stages and nothing splitting, endings recurring leave beginnings never stopping, with no decision; '
        'Identity\'s arisingFrom_not_stopping_covered reaches the same through «所覆后亡屡则生未否» at one covering '
        'list, and nothing on the base uses this form'),
    'Becoming.Covers.ceasing_steps_within': ('Becoming.Locality', 'general-structure',
        'with a list covering what holds at a step and nothing coming to be across a stretch from it, no more steps '
        'of the stretch see something cease than the list has members, with no decision: the root\'s '
        '«间无生则间亡不过所覆» at a relatum\'s occurrences (laws-of-one-step); since the covering laws became the '
        'root\'s cases (U4d) nothing in the package uses it'),
    'Becoming.comes_once': ('Becoming.Decidedness', 'general-structure',
        'while a determination does not cease, what came to be does not come to be again, with no decision '
        '(recurrence-without-decidedness, law 2); its one use was the direct proof of the family\'s count, now the '
        'root\'s stretch form (U4d)'),
    'Becoming.ceases_once_of': ('Becoming.Decidedness', 'general-structure',
        'while a determination does not come to be, what ceased does not cease again, with no decision '
        '(recurrence-without-decidedness, law 2); its one use was the direct proof of the family\'s count, now the '
        'root\'s stretch form (U4d)'),
    'Becoming.gaining_of_losing_from': ('Becoming.Prelude', 'support',
        'an arithmetic lemma: from a step on, a count ending each step with what it loses at most where it started '
        'with what it gains has losses recurring only with gains recurring; its uses were the old proofs of the '
        'census of a run and of the census recurrence laws, which now go through the root\'s count on lines (U4d)'),
    'Becoming.losing_of_gaining_from': ('Becoming.Prelude', 'support',
        'an arithmetic lemma, the mirror of gaining_of_losing_from with the count bounded; its use was the old proof '
        'of the census recurrence law\'s converse, which now goes through the root\'s count on lines (U4d)'),
}
# Steps.along_sheng_zero, registered as unused, is used now by Locality's supports of the covering laws' cases
U4D_STALE = {'Becoming.Steps.along_sheng_zero'}
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
