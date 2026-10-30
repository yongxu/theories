#!/usr/bin/env python3
"""GW1, GW2 and GW6: register the apart roots of the two new leaves that the connectivity check lists without a
reason, each with its category and reason. Textual edit at the head of the roots, the rest of the file byte for byte
(register_gw.py's pattern); stops on any unregistered root that is not GW's.
usage (from the checkout root): python3 -B <kit>/register_gw126.py CONNECTIVITY_LOG"""
import json
import re
import sys
from pathlib import Path

F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
log = Path(sys.argv[1]).read_text(encoding='utf-8')
m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
MR, WM = 'Becoming.MapRegions', 'Becoming.WideningOnTheMap'
MAP = ('A law of the map for every carrier, relation and pair of classes, read on no model; the World and the '
       'processes are its models (GW1, GW2)')
ONCE = ('A fact about one constructed model, the line that renews once and then stays (Map.once): at its start it is '
        'none of 生成, 守 and 退化 and keeps from some point on, the gap strict keeping leaves (GW1)')
MOVES = ('A fact about one constructed possible on a course\'s moments, holding one point at each moment and losing it '
         'at the next, or gaining one at each step: loss parts generation under the one from keeping widening (GW6)')
CHAIN = ('A law of every chain of predicates read on a course\'s moments, any type; the World reads it by name through '
         'Web.keepsWidening_itself_iff (GW6)')
OURS = {
    'Becoming.«传则粗不生»': (MR, 'general-structure', MAP),
    'Becoming.«生则或粗生或传»': (MR, 'general-structure', MAP),
    'Becoming.«后守退化不并»': (MR, 'general-structure', MAP),
    'Becoming.«守则后守»': (MR, 'general-structure', MAP),
    'Becoming.«三域之定当且仅当排中»': (MR, 'calibration', 'That every point of every model is 生成, 后守 or 退化 is exactly excluded middle; a lemma of GW1'),
    'Becoming.Map.Once.func': (MR, 'model-witness', ONCE),
    'Becoming.Map.Once.keepsAfter': (MR, 'model-witness', ONCE),
    'Becoming.Map.Once.not_degenerates': (MR, 'model-witness', ONCE),
    'Becoming.Map.Once.not_generates': (MR, 'model-witness', ONCE),
    'Becoming.Map.Once.not_keeps': (MR, 'model-witness', ONCE),
    'Becoming.Map.«生成之定则WLPO»': (MR, 'calibration', 'On a single line, deciding generation for the sequence that turns until p first holds gives WLPO for p, where deciding keeping from some point on gives LPO: to tell whether a line keeps from some point on is to decide whether it stops renewing (GW1)'),
    'Becoming.Map.«生成后守之定则LPO»': (MR, 'calibration', 'Placing the first step of the line in 生成 or 后守 for every sequence of truth values gives LPO, through Map.«后守之定则LPO» (GW1)'),
    'Becoming.Steps.same_class': (WM, 'general-structure', CHAIN),
    'Becoming.Steps.same_includes': (WM, 'general-structure', CHAIN),
    'Becoming.Steps.found_of_listed': (WM, 'general-structure', CHAIN),
    'Becoming.Steps.generation_of_reachingKeepsWidening': (WM, 'general-structure', CHAIN),
    'Becoming.Steps.keepsWidening_iff_generation_losing_nothing': (WM, 'general-structure', CHAIN),
    'Becoming.Steps.Moving.generation': (WM, 'model-witness', MOVES),
    'Becoming.Steps.Moving.not_generation_includes': (WM, 'model-witness', MOVES),
    'Becoming.Steps.Moving.not_keepsWidening': (WM, 'model-witness', MOVES),
    'Becoming.Steps.Growing.generation': (WM, 'model-witness', MOVES),
    'Becoming.Steps.forward_iff_wem': (WM, 'calibration', 'For every chain, keeping widening gives 全生成 at (nothing lost, the same possible) exactly where weak excluded middle holds: locating the step at which a point arrives needs each holding refuted or unrefuted (GW6)'),
    'Becoming.Steps.back_iff_em': (WM, 'calibration', 'For every chain, 全生成 at (nothing lost, the same possible) gives keeping widening exactly where excluded middle holds: exhibiting what a step adds, from its not being alike, needs what is unrefuted found (GW6)'),
    'Becoming.Steps.markov_of_keepsWidening_of_generation': (WM, 'calibration', 'Even on decided chains, the converse for every chain gives Markov\'s principle: exhibiting the point a step adds is an unbounded search (GW6)'),
}
assert set(unclassified) <= set(OURS), ('not GW\'s roots; their owners\'', sorted(set(unclassified) - set(OURS)))
text = F.read_text(encoding='utf-8')
head = ' "roots": {\n'
assert text.count(head) == 1
add = ''.join('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": ' + json.dumps(mod) + ',\n'
              '   "category": ' + json.dumps(cat) + ',\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n'
              for name, (mod, cat, reason) in OURS.items() if name in unclassified and f'"{name}"' not in text)
F.write_text(text.replace(head, head + add), encoding='utf-8')
json.loads(F.read_text(encoding='utf-8'))
print('registered', len([n for n in OURS if n in unclassified]))
