#!/usr/bin/env python3
"""Write RM1's record margin-of-a-regime:
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION   (from the checkout root, after apply_text.py)

Every declaration cited is resolved against the receipt's audited declarations of Becoming.RegimeMargin (a short
name must match exactly one declaration by suffix), and the receipt must bind the module's current bytes."""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
CHAPTER = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
EXPERIMENT = 'experiments/margin-measured/README.md'
RECORDS = ROOT / 'theories/becoming/results/records'
MOD = 'RegimeMargin'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
HEAD = f'## {N}. The margin of a regime: giving read off the level under a standing draw (RM1)'
assert re.search('^' + re.escape(HEAD) + '$', (ROOT / STUDY).read_text(), re.M)


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def src(mod):
    return f'{PKG}/Becoming/{mod}.lean'


def decls(mod):
    m = next(m for m in core['modules'] if m['module'] == f'Becoming.{mod}')
    assert core['source_sha256'][f'Becoming.{mod}'] == sha(src(mod)), ('receipt does not bind', mod)
    return m


def resolve(mod, names):
    full = [d['name'] for d in decls(mod)['declarations']]
    out = []
    for n in names:
        hits = [f for f in full if f == f'Becoming.{mod}.' + n]
        assert len(hits) == 1, (mod, n, hits)
        out.append(hits[0])
    return out


m = decls(MOD)
assert not any(m['axiom_dependencies'].values())
n_decl, n_thm = len(m['declarations']), sum(1 for d in m['declarations'] if d.get('kind') == 'theorem')

RID = 'margin-of-a-regime'
laws = [
    ('A condition gives by a law of its level, g, from what a standing draw H leaves: the next level is (x - H) + '
     'g(x - H). Where giving falls short of the draw at every level below y and nothing gives from nothing, a positive '
     'level below H + y falls at every step, is nothing after as many steps as it stood, and stays nothing.',
     '条件按其水平的规律 g、从常设汲取 H 所留下者给出：下一水平为 (x - H) + g(x - H)。所给在 y 之下的每个水平都不足汲取、且无中不生有时，'
     '低于 H + y 的正水平每步下降，在其所立的步数之后为无，并保持为无。',
     ['step', 'Short', 'FromNothing', 'step_falls', 'step_below', 'orbit_bound', 'ends_below', 'stays_ended']),
    ('Where giving meets the draw from y up to a top the step keeps, a level from H + y up to the top never falls below '
     'its start; so the point of no return is exact: from a level up to the top, the condition ends exactly where it '
     'starts below H + y. A draw beyond all giving ends the condition from every level.',
     '所给从 y 起直到步所保持的上限都满足汲取时，从 H + y 到上限的水平永不低于其起点；故不可回返点是确切的：从上限之内的水平，条件恰在起点低于 '
     'H + y 时终结。超出一切所给的汲取从每个水平终结条件。',
     ['Meets', 'Keeps', 'step_holds', 'holds', 'ends_iff_below', 'ends_beyond_giving']),
    ('The need is the regime\'s. Where giving stops below a need m, every level at which giving meets a positive draw '
     'is at least m, so the point of no return is at least the draw above the need; it is more than that exactly where '
     'giving at the need falls short of the draw; and a larger draw, giving no more, raises it by at least the difference.',
     '需求属于体制。所给在需求 m 之下停止时，所给满足正汲取的每个水平不低于 m，故不可回返点至少高出需求一份汲取；恰在需求处所给不足汲取时更高；'
     '更大的汲取、所给不增时，使之至少升高两者之差。',
     ['Gated', 'Root', 'Lowered', 'root_above_need', 'beyond_draw_iff', 'root_mono', 'rises_by_draw']),
    ('Giving lowered by the regime raises the need beyond what removal alone gives: under the same draw, the least '
     'level meeting it under lowered giving is no lower, and higher exactly where the lowered giving falls short of '
     'the draw at the old least level. MQ2 measured giving falling with the draw on real yeast.',
     '体制降低所给，即把需求抬高到仅由移除所致者之上：同一汲取下，降低的所给满足它的最低水平不更低，恰在降低的所给于旧的最低水平处不足汲取时更高。'
     'MQ2 在真实酵母上测得所给随汲取下降。',
     ['lowered_raises', 'lowered_raises_strictly']),
    ('Draws add, harms do not. Where giving under the joint draw is subadditive above the need and no greater than '
     'under either draw, and the least levels meeting H1, H2 and H1 + H2 lie a, b and c above the need, '
     'a + b <= c + 1: the rise of the point of no return under the joint draw is at least the sum of the rises under '
     'each, less one whole unit.',
     '汲取相加，损害不然。联合汲取下的所给在需求之上次可加且不大于各自汲取下的所给，且满足 H1、H2 与 H1 + H2 的最低水平高出需求 a、b、c 时，'
     'a + b <= c + 1：联合汲取下不可回返点的升高至少是各自升高之和减一个整单位。',
     ['SubadditiveAbove', 'harms_superadditive']),
    ('The time to break lies in a band: the level stays at or above b at every step n with b + H n <= x; where giving is '
     'at most Y and Y <= H <= b, it falls below b within any n with x < b + (H - Y) n.',
     '破断的时间在一个区间内：在 b + H n <= x 的每一步 n，水平不低于 b；所给至多为 Y 且 Y <= H <= b 时，'
     '在 x < b + (H - Y) n 的任何 n 步之内降到 b 之下。',
     ['AtMost', 'step_ge', 'orbit_ge', 'not_before', 'step_falls_by', 'falls_or_bound', 'falls_within']),
    ('Witnesses: Concave gives min(2z, z + 2); the least levels meeting 4 and 8 are 2 and 6, so the joint rise 14 '
     'exceeds the sum 12. Peaked gives min(z, 8 - z): each draw of 3 holds alone from every level from 6 to 8, and '
     'the two together, beyond all giving, end the condition from every level.',
     '见证：Concave 给出 min(2z, z + 2)；满足 4 与 8 的最低水平为 2 与 6，故联合升高 14 超过和 12。Peaked 给出 min(z, 8 - z)：'
     '3 的每份汲取单独从 6 到 8 的每个水平都得以维持，两者合起来超出一切所给，从每个水平终结条件。',
     ['Concave.giving', 'Concave.roots', 'Peaked.giving', 'Peaked.fromNothing', 'Peaked.atMost',
      'Peaked.each_holds', 'Peaked.together_ends']),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))

rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'The margin of a regime', 'zh': '一个体制的余量'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'With giving read off the level under a standing draw, the condition holds exactly from a least level up, which lies more than '
              'the draw above the need where giving there falls short of it, rises with the draw, and harms of joint '
              'draws are super-additive up to one unit.',
        'zh': '在常设汲取下所给读自水平时，不可回返点是确切的；在需求处所给不足汲取时高出需求不止一份汲取；随汲取升高；联合汲取的损害在一单位之内超可加。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(MOD, names)} for en, zh, names in laws],
    'hypotheses': [{
        'en': 'No axiom. Whole-number amounts and discrete steps; one condition; the draw taken first, as much as there '
              'is; giving a function of what is left, with no hidden state; each law\'s own premises (Short, Meets, '
              'Keeps, Gated, SubadditiveAbove, AtMost) as hypotheses.',
        'zh': '不加公理。整数量与离散步；一个条件；汲取先取，有多少取多少；所给是所留者的函数，无隐藏状态；各规律自身的前提（Short、Meets、Keeps、Gated、SubadditiveAbove、AtMost）为假设。'}],
    'does_not_show': [
        {'en': 'How giving depends on the draw, or that a system\'s giving is read off its level within a regime: MQ1 '
               'and MQ2 measured both on Dai et al.\'s yeast; neither is a theorem.',
         'zh': '所给怎样依赖于汲取，或某系统在一个体制内的所给读自其水平：MQ1 与 MQ2 在 Dai 等的酵母上测得两者；两者都不是定理。',
         'kind': 'scope'},
        {'en': 'Super-additivity for every concave giving law: the hypothesis is subadditivity above the need, and the '
               'whole numbers lose one unit.',
         'zh': '对每个凹的所给规律都超可加：假设是需求之上的次可加，整数还要付出一个单位。',
         'kind': 'scope'},
        {'en': 'The fold over the reals, or the other order of a step (giving before the draw): neither is stated.',
         'zh': '实数上的折叠，或步的另一种次序（先给后取）：两者都未陈述。',
         'kind': 'scope'},
        {'en': 'That drawing beyond the margin is worse: these laws locate where a condition ends, and order nothing.',
         'zh': '超出余量的汲取更坏：这些规律定位条件在何处终结，不定任何次序。',
         'kind': 'non-implication'}],
    'counterexamples': [{'path': src(MOD), 'detail': {
        'en': 'Peaked: two draws of 3, each held alone from every level from 6 to 8, together end the condition from '
              'every level (Peaked.each_holds, Peaked.together_ends); the frozen-rest comparison that adds draws does '
              'not show it.',
        'zh': 'Peaked：两份 3 的汲取，各自单独从 6 到 8 的每个水平得以维持，合起来从每个水平终结条件（Peaked.each_holds、Peaked.together_ends）；把汲取相加的冻结其余的核算看不出这一点。'}}],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical',
                            'names-provisional'],
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {n_decl} declarations of '
              f'Becoming.{MOD}, {n_thm} of them theorems, have empty axiom reports; the checker verifies core purity. '
              f'Built and reviewed in one session, with no separate reviewer; author review in study section {N}; not '
              'independently reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.{MOD} 的 {n_decl} 项声明（{n_thm} 项定理）公理报告为空；'
              f'检查器并核对核心纯净。在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'A frozen test of a draw-dependent giving law on data not yet read; the join to Flow.Balances; the fold '
              'over Archimedean amounts; several conditions coupled; an independent review.',
        'zh': '在尚未读过的数据上对依赖汲取的所给规律做冻结检验；与 Flow.Balances 相接；阿基米德量上的折叠；多个相互耦合的条件；独立审查。'},
    'correspondence': {
        'en': 'Harvesting theory: depensation and critical depensation, the fold of the harvested equilibrium (Clark, '
              'Mathematical Bioeconomics, 1976; May, Nature 1977); Allee effects under harvest (Courchamp, Berec and '
              'Gascoigne 2008); catastrophic shifts (Scheffer et al. 2001). Super-additive joint harm is the convexity '
              'of the inverse of a concave, increasing renewal. MQ1 (study section 253) measured each law in a '
              'simulated Allee yeast and in a gridworld; MQ2 (section 266) found on real yeast that the need predicted '
              'from a fitted growth map separates fates in held-out regimes, and that giving falls with the draw.',
        'zh': '收获理论：减损性与临界减损性，被收获平衡的折叠（Clark《数学生物经济学》1976；May，Nature 1977）；收获下的 Allee 效应（Courchamp、Berec 与 Gascoigne 2008）；灾变性转变（Scheffer 等 2001）。联合损害的超可加即凹的增函数更新之逆的凸性。MQ1（研究第 253 节）在模拟的 Allee 酵母与网格世界中测量了每条规律；MQ2（第 266 节）在真实酵母上发现，由拟合的生长映射预测的需求在留出体制中区分命运，且所给随汲取下降。'},
    'canonical_source': src(MOD),
    'aliases': ['margin of a regime', '一个体制的余量', 'point of no return under a standing draw',
                'the need is the regime\'s', 'harms super-additive', 'Becoming.RegimeMargin.ends_iff_below',
                'Becoming.RegimeMargin.beyond_draw_iff', 'Becoming.RegimeMargin.harms_superadditive'],
    'dependencies': [],
    'related': [
        {'id': 'four-cases-of-a-part', 'detail': {
            'en': 'The margin law compares levels with the rest\'s exchanges held as they were; this record reads the '
                  'margin with the condition\'s own giving responding to its level, where measurement can test it.',
            'zh': '余量之律在其余交换保持原样时比较水平；本记录读条件自身的所给随水平回应时的余量，测量可以检验之处。'}},
        {'id': 'own-count-misses-joint-excess', 'detail': {
            'en': 'Own draws within what is given can jointly exceed it; Peaked shows two draws each held alone that '
                  'together end the condition, with giving read off the level.',
            'zh': '各自在所给之内的汲取合起来可超出之；Peaked 显示在所给读自水平时，各自单独得以维持的两份汲取合起来终结条件。'}}],
    'references': [{'path': src(MOD), 'role': 'proof', 'declarations': sorted(d['name'] for d in m['declarations']),
                    'sha256': sha(src(MOD))},
                   {'path': src('Recurrence'), 'role': 'proof', 'sha256': sha(src('Recurrence'))},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': EXPERIMENT, 'role': 'integration', 'sha256': sha(EXPERIMENT)},
                   {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
    'proof_bindings': [{'source': src(MOD), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{MOD}',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{
        'en': f'20 October 2026: added (RM1), the margin with the condition\'s own giving read off its level, after MQ1 '
              f'found the frozen-rest margin an identity on measured data; comparisons across draws take one giving law '
              f'per draw after MQ2; study section {N}.',
        'zh': f'2026年10月20日：新增（RM1），条件自身的所给读自其水平时的余量，此前 MQ1 发现冻结其余的余量在测量数据上是恒等式；研究第 {N} 节。'}],
}
assert len(rec['statement']['en']) <= 300, len(rec['statement']['en'])
assert len(rec['statement']['zh']) <= 150, len(rec['statement']['zh'])
assert len(rec['correspondence']['en']) <= 1200, len(rec['correspondence']['en'])
assert len(rec['correspondence']['zh']) <= 500, len(rec['correspondence']['zh'])
for x in rec['does_not_show']:
    assert len(x['en']) <= 240 and len(x['zh']) <= 110, (x['en'][:40], len(x['en']), len(x['zh']))
assert len(rec['hypotheses'][0]['en']) <= 420 and len(rec['hypotheses'][0]['zh']) <= 190
assert len(rec['validation_scope']['en']) <= 600 and len(rec['validation_scope']['zh']) <= 260
assert len(rec['next_delta']['en']) <= 400 and len(rec['next_delta']['zh']) <= 180
path = RECORDS / f'{RID}.json'
assert not path.exists(), ('record exists', RID)
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID)
