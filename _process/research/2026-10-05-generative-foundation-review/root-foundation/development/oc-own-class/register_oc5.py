#!/usr/bin/env python3
"""OC5: bring the apart-root register in line with what connectivity's `--check` names after OC5. It adds an entry for
each new root: OtherLeaves' three facts, the organism's case of the reach excluding an ending line, FinerWake's class
lemma, and «外分唯系出类之同», which «闭则外分无关» no longer uses now that it follows from the own form (rule 9); the
reach's laws are listed too, in case `--check` names one. It removes the entry of a root that OC5's laws now use
(«二分为类», which OtherLeaves uses), where `--check` names one. Textual edits; the rest of the file stays byte for byte.
usage (from the checkout root): python3 -B register_oc5.py NAME ... [--remove NAME ...] (the names `--check` gave)"""
import json
import re
import sys
from pathlib import Path

F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
t = F.read_text(encoding='utf-8')
M = 'Becoming.GrammarPath'
LAW = ': a law of every relation and class on any carrier'


def w(what):
    return what + ': a witness of Becoming.GrammarPath (OC5)'


KNOWN = {
    'Becoming.«后皆续当且仅当自与线皆闭»': ('general-structure', "everything downstream of a member lies on its line "
                                                       "exactly where the class holds the effects of the member and of "
                                                       "each stage of its line, with no regularity assumed: what the "
                                                       "path needs" + LAW),
    'Becoming.«亡而网续则后不皆续»': ('general-structure', "where a line from a member ends while its last stage still "
                                                  "conditions something, not everything downstream of the member lies "
                                                  "on its line, with no regularity assumed" + LAW),
    'Becoming.«外分唯系出类之同»': ('general-structure', "how what lies outside is divided bears on the condition at a "
                                                    "member's class only through what is alike to an effect that leaves "
                                                    "the class, with no hypothesis that the member conditions something; "
                                                    "«闭则外分无关» now follows from the own form, «外分唯系己出之同» "
                                                    "(rule 9), which needs it to" + LAW),
    'Becoming.OtherLeaves.reach_without_condition': ('model-witness', w("the class holds the member's effects and "
                                                                        "everything downstream of the member lies on its "
                                                                        "line, while the class fails the condition at "
                                                                        "the member's class")),
    'Becoming.OtherLeaves.other_not_held': ('model-witness', w("the occurrence alike to the member, off its line, does "
                                                               "not have its effects held")),
    'Becoming.OtherLeaves.other_off_line': ('model-witness', w("the occurrence alike to the member lies off its line, "
                                                               "nothing downstream of the member being that occurrence")),
    'Becoming.FiniteFamilies.member_no_reach': ('model-witness', w("under the organism's class not everything downstream "
                                                                   "of the first member's birth lies on its line, which "
                                                                   "ends at old age while that stage still conditions "
                                                                   "the second member's birth")),
    'Becoming.FinerWake.finer_class': ('support', "a one-line check that the finer witness's relation is a class"),
}
REMOVABLE = {'Becoming.«二分为类»'}
args = sys.argv[1:]
cut = args.index('--remove') if '--remove' in args else len(args)
names, removed = args[:cut], args[cut + 1:]
missing = [n for n in names if n not in KNOWN]
assert not missing, ('no reason written for', missing)
assert set(removed) <= REMOVABLE, set(removed) - REMOVABLE
for name in removed:
    entry = re.compile('  ' + re.escape(json.dumps(name, ensure_ascii=False)) + r': \{\n(?:   .*\n)*?  \},?\n')
    found = entry.findall(t)
    assert len(found) == 1, (name, len(found))
    assert found[0].endswith('},\n'), 'the last entry of roots; remove it by hand'
    t = t.replace(found[0], '')
block = ''
for name in names:
    cat, reason = KNOWN[name]
    assert json.dumps(name, ensure_ascii=False) not in t, name
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "' + M + '",\n   "category": "' + cat
              + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
if block:
    anchor = '  }\n },\n "instances": {'
    assert t.count(anchor) == 1
    t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
json.loads(t)
F.write_text(t, encoding='utf-8')
print('register: added', block.count('"module"'), '; removed', len(removed))
