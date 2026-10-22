#!/usr/bin/env python3
"""UM3: update the record drawers-in-turn with drawing at once and the law's strict form.
usage (from the checkout root, after apply_text.py): python3 -B make_record.py CORE_RECEIPT STUDY_SECTION"""
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N = sys.argv[1], int(sys.argv[2])
R = json.loads((ROOT / PKG / 'becoming-checks' / core_id / 'verification.json').read_text())
assert R['status'] == 'passed'
assert f'## {N}. Drawing at once, the same law (UM3)' in (ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md').read_text()
full = {d['name'] for m in R['modules'] if m['module'] == 'Becoming.Optimum' for d in m['declarations']}
A = 'Becoming.Optimum.AtOnce.'
AT = [A + n for n in ['sumTo', 'pool', 'next', 'drawn', 'later', 'levels', 'Revises', 'Perfect', 'ReturnsLess',
                      'sumTo_congr', 'sumTo_zeros', 'sumTo_zero', 'sumTo_set', 'drawn_step', 'later_less',
                      'revisions_drain', 'drains', 'levels_drained']] + ['Becoming.Web.at_once_broken']
STRICT = 'Becoming.Optimum.InTurn.floor_of_less'
for n in AT + [STRICT]:
    assert n in full, n
p = RECORDS / 'drawers-in-turn.json'
d = json.loads(p.read_text())
law2 = [x for x in d['laws'] if 'Becoming.Optimum.InTurn.kept_returns' in x['declarations']]
assert len(law2) == 1
law2[0]['declarations'] = law2[0]['declarations'] + [STRICT]
law2[0]['en'] = law2[0]['en'].replace('so it leaves its floor where nothing it keeps returns',
                                      'so it leaves its floor where what it keeps returns less than one for one')
law2[0]['zh'] = law2[0]['zh'].replace('故无所回之处留下限', '故所回少于一对一之处留下限')
d['laws'].insert(len(d['laws']) - 1, {
    'en': 'Drawing at once, the same law: where the level is divided into portions and all draw at once, what a drawer leaves '
          'returns to it only through its portion; where that return is less than one for one, every perfect profile and '
          'every revision draws everything, and a dependence above what stands at nothing is broken.',
    'zh': '同时抽取，同一条律：水平分为份额、众者同时抽取时，抽取者所留只经其份额回到自身；此回报少于一对一时，每个完美组合与每次修订都全部抽取，高于零处所立者的依存被打破。',
    'declarations': AT})
for ref in d['references']:
    if ref['role'] == 'proof' and ref['path'].endswith('Optimum.lean'):
        ref['declarations'] = sorted(set(ref['declarations']) | set(AT) | {STRICT})
for lang, old, new in (('en', 'Drawing at once with a rule of sharing;', 'Drawing at once where a portion returns at least one for one;'),
                       ('zh', '按分享规则同时抽取；', '份额所回至少一对一时的同时抽取；')):
    assert d['does_not_show'][0][lang].count(old) == 1, (lang, old)
    d['does_not_show'][0][lang] = d['does_not_show'][0][lang].replace(old, new)
    assert d['next_delta'][lang].count(old) == 1, (lang, old)
    d['next_delta'][lang] = d['next_delta'][lang].replace(old, new)
d['history'].append({
    'en': f'22 October 2026, UM3: drawing at once from portions added as a second arrangement on the same law, the drain '
          f'holding where each portion returns less than one for one; the law\'s strict form (floor_of_less) stated, '
          f'leaves_floor its case (study section {N}).',
    'zh': f'2026年10月22日，UM3：自份额同时抽取作为同一条律的第二种安排加入，每份所回少于一对一时抽干成立；此律的严格形式（floor_of_less）陈述，leaves_floor 为其情形（研究第 {N} 节）。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('updated drawers-in-turn')
