#!/usr/bin/env python3
"""OC2: bring the apart-root register in line with what connectivity's `--check` names after OC2. It adds an entry for
each new root, and for PF2's law that OC2's derivation left unused (CleanStep's global failure now goes through the
form at the member's class). It removes the entries of roots that OC2 now uses (`«二分本类常当且仅当内外皆随»`, used
by `«内外皆缘则二分本类常»`; `Inconstant.same_class`, used by `Inconstant.not_constant_at`). Textual edits; the rest of
the file stays byte for byte.
usage (from the checkout root): python3 -B register_oc2.py NAME ... [--remove NAME ...] (the names `--check` gave)"""
import json
import re
import sys
from pathlib import Path

F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
t = F.read_text(encoding='utf-8')
M = 'Becoming.GrammarPath'
LAW = ': a law of every relation and class on any carrier'


def w(what):
    return what + ': a witness of Becoming.GrammarPath (OC2)'


KNOWN = {
    'Becoming.«出类不随则不至终有常»': ('general-structure', "where an occurrence alike to a member conditions something but "
                                                          "nothing alike to an effect that leaves the class, the class is "
                                                          "not constant up to the net's end: PF2's form, kept as the "
                                                          "corollary of «出类不随则本类不至终有常» (rule 9)" + LAW),
    'Becoming.CleanStep.ends_where_net_ends': ('model-witness', w("every line from the member ends only where the net "
                                                                  "does, though the class fails the condition at the "
                                                                  "member")),
    'Becoming.FinerWake.same_class': ('model-witness', w("both divisions give the member the same class")),
    'Becoming.FinerWake.split_constant_at': ('model-witness', w("under the split the class meets the condition at the "
                                                                "member, every alike occurrence staying and leaving")),
    'Becoming.FinerWake.finer_not_constant_at': ('model-witness', w("dividing what lies outside more finely breaks the "
                                                                    "condition even there")),
}
REMOVABLE = {'Becoming.«二分本类常当且仅当内外皆随»', 'Becoming.Inconstant.same_class'}
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
