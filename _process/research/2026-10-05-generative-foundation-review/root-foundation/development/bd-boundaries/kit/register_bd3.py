#!/usr/bin/env python3
"""BD3's landing (register_bd2.py's pattern): register the apart roots the connectivity check lists without a reason
that are BD3's, each with a category and a reason; stop on any other root, which belongs to its owner, and on any
stale entry, which BD3's change (a leaf, no existing module changed) does not explain and is read first.

* closes_iff_closed is used on the base through closes_iff_notGoingOut, so it is expected connected; its reason is
  kept in case the measure places it apart.
* closes_iff_notComingIn reads the same family as a region not come into, the adjacency being symmetric; nothing on
  the base uses it (general structure).
* balancing_iff_notGoingOut is the one-step form for any levels; the base's case on webs, balancesOn_iff_notGoingOut,
  goes through balancesOn_iff_conserved, so nothing on the base uses it (general structure).

Textual edits, the rest of the file byte for byte (register_bd2.py's pattern).
usage (from the checkout root): python3 -B register_bd3.py CONNECTIVITY_LOG"""
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
assert not stale, ("stale entries BD3's change does not explain: read them", stale)
GENERAL = ('for every Bool relation and list of relata on any type; the base reads balance on regions through '
           'balancesOn_iff_notGoingOut, and nothing on it uses this law (BD3)')
REASONS = {
    'Becoming.Continuity.closes_iff_closed': ('general-structure',
                                              "Continuity's closed family is the grammar's «闭» along adjacency among "
                                              'the listed relata, membership a test: ' + GENERAL),
    'Becoming.Continuity.balancing_iff_notGoingOut': ('general-structure',
                                                      'relata listed without repetition and equality decided, transfers '
                                                      'balancing a step exist exactly where the total is conserved on '
                                                      'every region not gone out of along adjacency among the listed '
                                                      'relata, for any levels and every Bool relation on any type; the '
                                                      "base's case on webs, balancesOn_iff_notGoingOut, goes through "
                                                      'balancesOn_iff_conserved, so nothing on the base uses this law '
                                                      '(BD3)'),
    'Becoming.Continuity.closes_iff_notGoingOut': ('general-structure',
                                                   'a family the relation closes is exactly a region not gone out of '
                                                   'along that adjacency: ' + GENERAL),
    'Becoming.Continuity.closes_iff_notComingIn': ('general-structure',
                                                   'a family the relation closes is exactly a region not come into '
                                                   'along that adjacency, by «对称则不出当且仅当逆不出»: ' + GENERAL),
    'Becoming.Continuity.adjacentListed_symm': ('support', 'adjacency among the listed relata is symmetric: a one-line '
                                                           'unpacking of the module\'s own definitions and adj_symm (BD3)'),
    'Becoming.Continuity.balancesOn_iff_notGoingOut': ('general-structure',
                                                       'on a web, transfers balancing every step exist exactly where '
                                                       'the levels are conserved at every step on every region not '
                                                       'gone out of along that adjacency: ' + GENERAL),
}
others = [n for n in unclassified if n not in REASONS]
assert not others, ("apart roots not registered here: read them; another session's belong to their owners", others)
t = F.read_text(encoding='utf-8')
block = ''
for name in unclassified:
    assert json.dumps(name, ensure_ascii=False) not in t, name
    cat, reason = REASONS[name]
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "Becoming.BalanceRegions",\n   "category": "'
              + cat + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
if block:
    anchor = '  }\n },\n "instances": {'
    assert t.count(anchor) == 1
    t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
    json.loads(t)
    F.write_text(t, encoding='utf-8')
print('register: added', len(unclassified), unclassified)
