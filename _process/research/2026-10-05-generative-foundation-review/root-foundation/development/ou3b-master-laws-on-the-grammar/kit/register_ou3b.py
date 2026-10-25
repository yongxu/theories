#!/usr/bin/env python3
"""OU3b: the connectivity register. Registers, each with a category and a reason, the apart roots that OU3b makes
(the laws of Becoming.GrammarLaws the models do not use, the representation theorems nothing on the base uses, and
the model lemmas whose only user is now proved from the grammar), and drops the two entries of Becoming.Grammar that
are no longer apart roots (now used through Becoming.GrammarLaws, which Becoming.Frame imports). Every root the log
lists must be in the table below and every listed stale entry must be one of the two, so a root another landing made
stops the script for its owner. Textual edits, the rest of the file byte for byte (UE4's register_ue4.py, GS6's
register_gs6.py).
usage (from the checkout root): python3 -B <kit>/register_ou3b.py CONNECTIVITY_CHECK_LOG"""
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

A = 'Becoming.GrammarLaws'
LAW = ('a law of every relation on any carrier (a master law on the grammar, OU3b); the models use the forms '
       'they need, and this one nothing on the base uses')
GLOBAL = ('the global form of a local law of every relation on any carrier (OU3b); the models use the local or '
          'other forms, so nothing on the base uses this one')
WITNESS = 'a fact about one constructed relation: a witness that a hypothesis of a master law on the grammar cannot be omitted, or that two of its notions differ (OU3b)'
UNPACK = "a one-line unpacking of the grammar's own definitions (OU3b)"
BALANCE = ('a law of pairings under every relation (balance on the grammar, OU3b); the base reads balance in numbers, '
           'represented on the grammar at one step and over a family in Flow, and its consumers stay arithmetic, so '
           'nothing on the base uses this one')
TABLE = {
    # Becoming.GrammarLaws
    'Becoming.«闭含所闭»': (A, 'support', UNPACK),
    'Becoming.«定后之逐点»': (A, 'support', UNPACK),
    'Becoming.«定前之逐点»': (A, 'support', UNPACK),
    'Becoming.«定前即逆之定后»': (A, 'support', UNPACK),
    'Becoming.«广则不则»': (A, 'support', UNPACK),
    'Becoming.«广非自»': (A, 'support', UNPACK),
    'Becoming.«齐即谓»': (A, 'support', UNPACK),
    'Becoming.«对之逆»': (A, 'general-structure', BALANCE),
    'Becoming.«对之程»': (A, 'general-structure', BALANCE),
    'Becoming.«程守数当且仅当可对»': (A, 'general-structure',
                              'the count law over a stretch is exactly a pairing of units over it, both ways (OU3b); '
                              'it represents the prelude\'s stretch balance (balance_over_stretch_on), which lies below '
                              'the grammar\'s laws and stays arithmetic, so nothing on the base uses it'),
    'Becoming.«定后环则所及皆返»': (A, 'general-structure', GLOBAL),
    'Becoming.«同行当且仅当有常»': (A, 'general-structure', GLOBAL),
    'Becoming.«局定后则有常当且仅当同行可续»': (A, 'general-structure',
                                  'with the successor fixed where a relation leads, constancy is exactly going alike with '
                                  'a successor available: the exact gap between the two, a law of every relation on any '
                                  'carrier (OU3b); the models use its two directions, not the equivalence'),
    'Becoming.«同行于迭»': (A, 'general-structure', LAW),
    'Becoming.«类同行遍后则含于核»': (A, 'general-structure',
                              'a class going alike under a relation with a successor everywhere lies inside its own '
                              'core: a law of every relation on any carrier (OU3b) joining lumping to the core; nothing '
                              'on the base uses it'),
    'Becoming.«无后者不入亦不返»': (A, 'general-structure',
                             'without a successor an occurrence is neither drawn nor reaches itself, so the successor '
                             'hypothesis of the law of being drawn cannot be omitted: a law of every relation on any '
                             'carrier (OU3b)'),
    'Becoming.«四比之周»': (A, 'general-structure',
                         'where inclusion or exceeding is decided both ways, two relations widen, keep or are mixed: '
                         'the four cases on the grammar, a law of every relation on any carrier (OU3b); the base '
                         'states its own four cases (four-cases-of-a-part)'),
    'Becoming.«则逾之定当且仅当排中»': (A, 'calibration',
                             'the exact logical principle (excluded middle) that deciding inclusion against exceeding '
                             'for every pair of relations needs; a lemma of the four cases on the grammar (OU3b)'),
    'Becoming.«等长而不对之例»': (A, 'model-witness', WITNESS),
    'Becoming.«入而返之例»': (A, 'model-witness', WITNESS),
    'Becoming.«非定后返而不入之例»': (A, 'model-witness', WITNESS),
    'Becoming.«止而不入之例»': (A, 'model-witness',
                           'a fact about one constructed relation: a place at rest and not drawn, so rest is not a '
                           'case of being drawn (OU3b)'),
    'Becoming.«入而屡之例»': (A, 'model-witness',
                          'a fact about one constructed relation: a place drawn in while its marked steps recur, so '
                          'being drawn is not rest (OU3b)'),
    # the models: representation theorems nothing on the base uses, and lemmas whose user is now the grammar's law
    'Becoming.closedUnder_iff_closed': ('Becoming.Frame', 'support',
                                        "Frame's closed region is the grammar's «闭», by definition (Iff.rfl): the "
                                        'representation of closure, documenting it (OU3b)'),
    'Becoming.withinClosure_iff_within': ('Becoming.Frame', 'support',
                                          "Frame's closure is the grammar's «所闭», by definition (Iff.rfl): the "
                                          'representation of closure, documenting it (OU3b)'),
    'Becoming.split_at_head': ('Becoming.Recurrence', 'support',
                               'a list lemma kept by name as an alias of GrammarLaws.split_at_head, its one proof '
                               '(OU3b); the pigeonhole revisits_within no longer uses this alias'),
    'Becoming.Law.absorbing_ahead': ('Becoming.Attraction', 'general-structure',
                                     'what lies ahead of a configuration under a determined law is absorbing: a law '
                                     'of every map on any type; since OU3b being drawn is proved from the grammar\'s '
                                     'law (Law.drawn_iff_not_returns), so nothing on the base uses it'),
    'Becoming.withinClosure_of_line': ('Becoming.GrammarScope', 'general-structure',
                                       'a line under the one of a relation lies within the closure along it, from '
                                       'the grammar\'s «所闭当且仅当同一或及» (OU3b): a law of every relation on any '
                                       'carrier; nothing on the base uses it'),
    'Becoming.Amounts.loses_times': ('Becoming.Amounts', 'general-structure',
                                     'the losses accumulated at m recurrences of a least loss, over any amounts; '
                                     'since OU3b the law of rest is proved from the grammar\'s (Amounts.falls_end '
                                     'and «尽则不或屡»), so nothing on the base uses this different law'),
    'Becoming.Amounts.fallsStop_iff': ('Becoming.InAmounts', 'support',
                                       "an amount's strict falls stopping is the grammar's non-recurrence «或屡» of "
                                       'strict falls along it, by definition (Iff.rfl): the representation of the '
                                       'premise of rest, documenting it (OU3b)'),
    'Becoming.Amounts.fallsStop_of_ends': ('Becoming.InAmounts', 'general-structure',
                                           'over any amounts, falls whose courses end stop: the grammar\'s law of '
                                           'rest at the amounts (OU3b); the rest theorems take the stopping as their '
                                           'premise, so nothing on the base uses it'),
    'Becoming.Weighting.mixedOn_iff': ('Becoming.Weightings', 'support',
                                       'mixed over a listing is the grammar\'s «杂» of the coreflexive relations '
                                       'admitted, both ways: the representation of order over a listing (OU3b)'),
    'Becoming.Weighting.WidensOn.not_reverse': ('Becoming.Weightings', 'general-structure',
                                                'widening over a listing goes one way, from the grammar\'s «广不可逆»: '
                                                'a law of any finite listing, with no world (OU3b)'),
    'Becoming.Weighting.WidensOn.trans': ('Becoming.Weightings', 'general-structure',
                                          'widening over a listing is transitive, from the grammar\'s «广之传递»: a law '
                                          'of any finite listing, with no world (OU3b)'),
}
DROP = {'Becoming.«一之续»': 'Becoming.Grammar', 'Becoming.«则之传递»': 'Becoming.Grammar'}

missing = [n for n in unclassified if n not in TABLE]
assert not missing, ('apart roots not OU3b\'s; for their owners', missing)
unexpected = [n for n in stale if n not in DROP]
assert not unexpected, ('stale entries not OU3b\'s', unexpected)

t = F.read_text(encoding='utf-8')
for name in stale:
    key = '  ' + json.dumps(name, ensure_ascii=False) + ': {\n'
    assert t.count(key) == 1, name
    i = t.index(key)
    j = t.index('  },\n', i) + len('  },\n')
    assert t[i:j].count(f'"module": "{DROP[name]}"') == 1, name
    t = t[:i] + t[j:]
block = ''
for name in unclassified:
    assert json.dumps(name, ensure_ascii=False) not in t, name
    module, category, reason = TABLE[name]
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "' + module + '",\n   "category": "'
              + category + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
if block:
    anchor = '  }\n },\n "instances": {'
    assert t.count(anchor) == 1
    t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
json.loads(t)
F.write_text(t, encoding='utf-8')
print('register: added', len(unclassified), {c: sum(1 for n in unclassified if TABLE[n][1] == c)
                                            for c in ('general-structure', 'support', 'model-witness', 'calibration')},
      '; dropped', len(stale), stale)
