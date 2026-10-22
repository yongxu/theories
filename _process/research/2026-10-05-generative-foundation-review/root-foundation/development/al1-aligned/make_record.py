#!/usr/bin/env python3
"""AL1: update the record drawers-in-turn with the converse of the drain, whom restraint pays and the whole standpoint.
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
assert f'## {N}. When drawing at once drains, and whom restraint pays (AL1)' in (ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md').read_text()
full = {d['name'] for m in R['modules'] if m['module'] == 'Becoming.Optimum' for d in m['declarations']}
A = 'Becoming.Optimum.AtOnce.'
H = 'Becoming.Optimum.Holding.'
CONVERSE = [A + n for n in ['later_drained', 'steps_after', 'drain_perfect_iff', 'last_draws']] + ['Becoming.Web.drain_perfect_broken']
PAYS = [A + n for n in ['portion_falls', 'drain_most', 'drained_add_le', 'holding_draws_more']] + ['Becoming.Web.at_once_beyond']
WHOLE = [A + n for n in ['whole_not_drained', 'whole_perfect_iff']] + ['Becoming.Web.whole_drain_broken']
WIT = [H + n for n in ['half', 'half_le_succ', 'half_mono', 'half_double', 'half_le', 'halfMore', 'halves', 'leavesAllButOne',
                       'halves_return', 'halves_hold', 'halves_held', 'halves_race']]
ALL = CONVERSE + PAYS + WHOLE + WIT
for n in ALL:
    assert n in full, n
p = RECORDS / 'drawers-in-turn.json'
d = json.loads(p.read_text())
wit = [x for x in d['laws'] if H + 'gated_in_turn' in x['declarations']]
assert len(wit) == 1
at = d['laws'].index(wit[0])
d['laws'][at:at] = [
    {'en': 'The converse, exactly: drawing at once with no floor, drawing everything is perfect exactly where, at every step '
           'before the last, no drawer\'s portion of what stands next returns more than one for one on what it alone leaves '
           'while the others draw everything; a perfect profile draws everything at the last step; on a web the drain then '
           'breaks a dependence above what stands at nothing.',
     'zh': '确切的逆命题：无下限地同时抽取时，全部抽取是完美的，当且仅当在最后一步之前的每一步，没有抽取者的下一步份额对其在他者全部抽取时独留之量所回多于一对一；'
           '完美组合在最后一步全部抽取；在网上，此时抽干打破高于零处所立者的依存。',
     'declarations': CONVERSE},
    {'en': 'Whom restraint pays: where each portion returns less than one for one, in whole amounts a portion never rises with '
           'what is left, so along no profile does any drawer draw more than where all draw everything, and what the drain '
           'breaks lies beyond every drawer; where a profile holds the level and draws a drawer at every later step more than '
           'its portion of what stands at nothing, over a horizon at least two steps longer than its first portion it draws that '
           'drawer more.',
     'zh': '克制使谁得益：每份所回少于一对一时，以整数量计份额从不随所留而升，故沿任何组合，没有抽取者比众者全部抽取时多得，抽干所破者在每个抽取者之外；'
           '某组合保持水平、在此后每步给某抽取者多于其在零处所立者中的份额时，在比其首份长两步以上的视野上，它使该抽取者多得。',
     'declarations': PAYS},
    {'en': 'The standpoint of the whole as a case: a drawer whose portion is all that stands finds drawing everything imperfect '
           'wherever the whole returns more than one for one; one drawer given the whole drains exactly where the whole never '
           'does, and where it never does the drain is perfect for it and still breaks what depends on the base.',
     'zh': '全体的立场作为情形：份额为全部所立者的抽取者，在全体所回多于一对一处不以全部抽取为完美；得全体的单一抽取者恰在全体从不多回之处抽干，此时抽干对它完美而仍打破依存于基础者。',
     'declarations': WHOLE},
]
wit[0]['declarations'] = wit[0]['declarations'] + WIT
wit[0]['en'] = wit[0]['en'].rstrip('.') + ('; under halves, what both leave standing next with half of it again, drawing '
    'everything is perfect for the two and breaks the dweller, leaving all but one unit of each half holds the source at '
    'six, keeps the dweller and draws each drawer more, and for a single drawer given the whole draining is no best response.')
wit[0]['zh'] = wit[0]['zh'].rstrip('。') + '；对分之下，两者所留于下一步再加其半而立，全部抽取对二者完美并打破居者，各留其半而只取一单位则把源保持在六、保持居者并使每个抽取者多得，对得全体的单一抽取者，抽干不是最优回应。'
for ref in d['references']:
    if ref['role'] == 'proof' and ref['path'].endswith('Optimum.lean'):
        ref['declarations'] = sorted(set(ref['declarations']) | set(ALL))
# the receipt reference is added by repoint.py with the proof binding
for lang, old, new in (('en', 'Drawing at once where a portion returns at least one for one;',
                        'Drawing at once, which profiles are perfect where some portion returns more than one for one, and '
                        'whether every perfect profile of the halves draws each drawer less than holding;'),
                       ('zh', '份额所回至少一对一时的同时抽取；', '同时抽取时，某份所回多于一对一处何种组合完美，以及对分中每个完美组合是否都使每个抽取者少于保持所得；')):
    assert d['does_not_show'][0][lang].count(old) == 1, (lang, old)
    d['does_not_show'][0][lang] = d['does_not_show'][0][lang].replace(old, new)
for lang, old, new in (('en', 'Drawing at once where a portion returns at least one for one;',
                        'Perfect profiles drawing at once where some portion returns more than one for one;'),
                       ('zh', '份额所回至少一对一时的同时抽取；', '某份所回多于一对一时同时抽取的完美组合；')):
    assert d['next_delta'][lang].count(old) == 1, (lang, old)
    d['next_delta'][lang] = d['next_delta'][lang].replace(old, new)
d['correspondence']['en'] = d['correspondence']['en'].replace('the dynamic commons (Levhari and Mirman 1980);',
    'the common-property resource (Gordon 1954); the dynamic commons and the sole owner (Levhari and Mirman 1980);')
d['correspondence']['zh'] = d['correspondence']['zh'].replace('动态公地（Levhari 与 Mirman 1980）；',
    '公共财产资源（Gordon 1954）；动态公地与唯一所有者（Levhari 与 Mirman 1980）；')
d['history'].append({
    'en': f'22 October 2026, AL1: the open item on drawing at once where a portion returns at least one for one answered by '
          f'the exact converse of the drain (drain_perfect_iff); UM3\'s reading of ReturnsLess as a share of renewal below '
          f'one corrected: in whole amounts it means a unit left returns nothing, so the drain costs no drawer anything '
          f'(drain_most); whom holding pays and the standpoint of the whole added, with the halves as witness (study '
          f'section {N}).',
    'zh': f'2026年10月22日，AL1：份额所回至少一对一时同时抽取的未决项，由抽干的确切逆命题（drain_perfect_iff）回答；UM3 把 ReturnsLess 读作更新份额低于一，'
          f'此读法更正：以整数量计，它意味着留下一单位毫无所回，故抽干不使任何抽取者有所失（drain_most）；加入保持使谁得益与全体的立场，以对分为见证（研究第 {N} 节）。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('updated drawers-in-turn')
