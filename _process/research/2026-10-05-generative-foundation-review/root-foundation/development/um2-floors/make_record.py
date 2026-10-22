#!/usr/bin/env python3
"""UM2: update the record drawers-in-turn for the generalized drain (from the study section and the receipt).
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
assert f'## {N}. Where floors bind: two drawers with no floor drain (UM2)' in (ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md').read_text()
full = {d['name'] for m in R['modules'] if m['module'] == 'Becoming.Optimum' for d in m['declarations']}
I = 'Becoming.Optimum.InTurn.'
REMAP = {I + 'levels_of_first': I + 'levels_through'}
GONE = [I + n for n in ['pass_of_first', 'others_draw_nothing', 'revisions_end', 'perfect_ends', 'perfect_of_zero',
                        'revised_draw_all']]
NEW3 = [I + n for n in ['pass_zero', 'pass_through', 'after_draw_nothing', 'floor_after', 'floor_through',
                        'revisions_reach_floors', 'perfect_at_floors', 'floors_perfect', 'bestUpTo', 'bestUpTo_le',
                        'bestUpTo_max', 'best_from', 'revise', 'revise_revises', 'revised', 'revised_leaves',
                        'revised_at_floors']]
for n in NEW3 + list(REMAP.values()):
    assert n in full, n
p = RECORDS / 'drawers-in-turn.json'
d = json.loads(p.read_text())
d['statement'] = {
    'en': 'Drawers in turn are one model, each with a floor, on one law of best response: what a drawer keeps above its '
          'floor returns to it at least one for one; so where two drawers have no floor, revision and perfection both come '
          'to the floors, whatever the others\' floors.',
    'zh': '轮流的抽取者是一个模型，各有下限，依一条最优回应之律：抽取者在下限之上所留至少一对一地回到自身；故两个抽取者无下限时，不论其他下限，修订与完美都达到下限组合。'}
law3 = [x for x in d['laws'] if I + 'revisions_end' in x['declarations']]
assert len(law3) == 1
law3[0].update({
    'en': 'Where two drawers have no floor, whatever the others\' floors, what any drawer keeps passes through one of them, '
          'so nothing returns: every sequence of revisions reaches the floor profile, a revision always exists, and every '
          'perfect profile is the floor profile, which is perfect; with no floor anywhere that is drawing everything.',
    'zh': '两个抽取者无下限时，不论其他下限，任一抽取者所留经过其一，故不回到自身：每个修订序列达到下限组合，修订总存在，每个完美组合即下限组合且它完美；处处无下限即全部抽取。',
    'declarations': NEW3})
for law in d['laws']:
    law['declarations'] = [REMAP.get(x, x) for x in law['declarations']]
    law['en'] = law['en'].replace('Where the first drawer leaves nothing', 'Where a drawer leaves nothing')
    law['zh'] = law['zh'].replace('第一者不留之处', '某抽取者不留之处')
for x in d['laws']:
    assert not any(g in x['declarations'] for g in GONE), x['en'][:40]
for ref in d['references']:
    if ref['role'] == 'proof' and ref['path'].endswith('Optimum.lean'):
        ref['declarations'] = sorted(({REMAP.get(x, x) for x in ref['declarations']} - set(GONE)) | set(NEW3))
h = d['hypotheses'][0]
for lang, old, new in (('en', 'for the drain and the revision no floor and k at least two',
                        'for the drain and the revision two drawers with no floor'),
                       ('zh', '抽干与修订无下限且 k 至少为二', '抽干与修订两个抽取者无下限')):
    assert h[lang].count(old) == 1, (lang, old)
    h[lang] = h[lang].replace(old, new)
x = d['does_not_show'][0]
for lang, old, new in (('en', 'which profiles are perfect where a floor binds away from the last step',
                        'which profiles are perfect where at most one drawer has no floor, away from the last step'),
                       ('zh', '下限起作用时最后一步之外何种组合完美', '至多一个抽取者无下限时最后一步之外何种组合完美')):
    assert x[lang].count(old) == 1, (lang, old)
    x[lang] = x[lang].replace(old, new)
for lang, old, new in (('en', 'perfect profiles where a floor binds', 'perfect profiles where at most one drawer is free'),
                       ('zh', '下限起作用时的完美组合', '至多一个抽取者无下限时的完美组合')):
    assert d['next_delta'][lang].count(old) == 1, (lang, old)
    d['next_delta'][lang] = d['next_delta'][lang].replace(old, new)
d['aliases'] = [I + 'revisions_reach_floors' if a == I + 'revisions_end' else a for a in d['aliases']]
d['history'].append({
    'en': f'22 October 2026, UM2: the drain\'s premise generalized from no floor anywhere to two drawers with no floor, '
          f'whatever the others\' floors; every perfect profile is then the floor profile and revision reaches it; the laws '
          f'with no floor anywhere replaced by their general forms (study section {N}).',
    'zh': f'2026年10月22日，UM2：抽干的前提由处处无下限推广为两个抽取者无下限，不论其他下限；此时每个完美组合即下限组合，修订达到它；处处无下限之律由其一般形式取代（研究第 {N} 节）。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('updated drawers-in-turn')
