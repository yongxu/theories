#!/usr/bin/env python3
"""OC1: register the apart roots that connectivity lists for the declarations OC1 added to Becoming.GrammarPath, and the
one PF2 law that OC1's generalization left unused. Textual edits, the rest of the file byte for byte (PF2's
register_pf2.py). usage (from the checkout root): python3 -B register_oc1.py NAME ... (the roots `--check` named)"""
import json
import sys
from pathlib import Path

F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
t = F.read_text(encoding='utf-8')
M = 'Becoming.GrammarPath'
LAW = ': a law of every relation and class on any carrier'


def w(what):
    return what + ': a witness of Becoming.GrammarPath (OC1)'


KNOWN = {
    'Becoming.«至终有常之逐类»': ('general-structure', "constancy up to the net's end is that at every member's class" + LAW),
    'Becoming.«闭则外分无关»': ('general-structure', "where the class holds the effects of a member that conditions something, "
                                                    "how what lies outside is divided is idle" + LAW),
    'Becoming.«本类之常至二分»': ('general-structure', "where a predicate decides a member's class, the condition at it under any "
                                                      "class gives it under the split" + LAW),
    'Becoming.«二分本类常当且仅当内外皆随»': ('general-structure', "under the split, the condition at a member's class is that "
                                                              "what stays and what leaves follow every alike step" + LAW),
    'Becoming.«出类随行»': ('general-structure', "what leaves the class follows each alike step, under constancy up to the "
                                                "net's end: PF2's form, kept as the corollary of «本类出类随行» (rule 9)" + LAW),
    'Becoming.«亡而网续则不至终有常»': ('general-structure', "a relation under which a line ends at an occurrence that still "
                                                          "conditions something is not constant up to the net's end, for any "
                                                          "relation: PF's form, kept; its witnesses now go through the form "
                                                          "at a member's class" + LAW),
    'Becoming.«二分为类»': ('support', 'a one-line check that the split by a predicate is a class'),
    'Becoming.FinerOutside.finer_class': ('support', "a one-line check that the finer witness's relation is a class"),
    'Becoming.FinerOutside.same_class': ('model-witness', w("both divisions give the member the same class")),
    'Becoming.FinerOutside.split_constant_at': ('model-witness', w("under the split the class meets the condition at the member")),
    'Becoming.FinerOutside.not_held': ('model-witness', w("the split does not hold the member's effects")),
    'Becoming.FinerOutside.finer_not_constant_at': ('model-witness', w("dividing what lies outside more finely breaks the condition")),
    'Becoming.UnevenOutside.finer_class': ('support', "a one-line check that the finer witness's relation is a class"),
    'Becoming.UnevenOutside.same_class': ('model-witness', w("both divisions give the member the same class")),
    'Becoming.UnevenOutside.split_constant_at': ('model-witness', w("under the split the class meets the condition at the member")),
    'Becoming.UnevenOutside.held': ('model-witness', w("the split holds the member's effects")),
    'Becoming.UnevenOutside.split_not_constant_to_end': ('model-witness', w("the split is not constant up to the net's end")),
    'Becoming.UnevenOutside.finer_constant_to_end': ('model-witness', w("a finer division is constant up to the net's end")),
}
names = sys.argv[1:]
missing = [n for n in names if n not in KNOWN]
assert not missing, ('no reason written for', missing)
block = ''
for name in names:
    cat, reason = KNOWN[name]
    assert json.dumps(name, ensure_ascii=False) not in t, name
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "' + M + '",\n   "category": "' + cat
              + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
anchor = '  }\n },\n "instances": {'
assert t.count(anchor) == 1
t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
json.loads(t)
F.write_text(t, encoding='utf-8')
print('register: added', block.count('"module"'))
