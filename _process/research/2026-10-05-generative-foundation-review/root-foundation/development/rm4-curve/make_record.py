#!/usr/bin/env python3
"""Write RM4's record threshold-in-the-state-plane (a theorem), note it in regime-point-under-adjusting-giving
(whose open threshold in the plane of level and recent giving it states for adjustments rising in both arguments
within a band), and give the coverage file's degeneration row the record and its exact law:
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION PREVIOUS_RECEIPT   (from the checkout root, after apply_text.py)

The laws cite exactly the declarations Becoming.LastChange and Becoming.RegimeMargin gained since the previous receipt.
Every declaration cited is resolved against the receipt's audited declarations (a short name must match exactly one
declaration of the named module), and the receipt must bind each cited module's current bytes."""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
REVIEW = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md'
CHAPTER = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
COVERAGE = 'theories/becoming/results/completion/COVERAGE.json'
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N, previous = sys.argv[1], int(sys.argv[2]), sys.argv[3]
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
HEAD = f"## {N}. The threshold in the plane of level and recent giving (RM4)"
assert re.search('^' + re.escape(HEAD) + '$', (ROOT / STUDY).read_text(), re.M)


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def src(mod):
    return f'{PKG}/Becoming/{mod}.lean'


def decls(mod):
    m = next(m for m in core['modules'] if m['module'] == f'Becoming.{mod}')
    assert core['source_sha256'][f'Becoming.{mod}'] == sha(src(mod)), ('receipt does not bind', mod)
    assert not any(m['axiom_dependencies'].values())
    return [d['name'] for d in m['declarations']]


def resolve(mod, names):
    full = decls(mod)
    out = []
    for n in names:
        hits = [f for f in full if f == f'Becoming.{mod}.' + n]
        assert len(hits) == 1, (mod, n, hits)
        out.append(hits[0])
    return out


BOUNDS = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
          'omission-not-refutation']

RID = 'threshold-in-the-state-plane'
RM3 = 'where-a-run-of-a-regime-comes-to-rest'
RM2 = 'regime-point-under-adjusting-giving'
RM1 = 'margin-of-a-regime'
L1 = 'the-last-change-of-a-run'
LC, RM = 'LastChange', 'RegimeMargin'
AD, NO = 'Adjusted.', 'Notch.'

laws = [
    ('A run still from a step stays at its configuration there, so a run still from two steps is at one '
     'configuration at both: a run has at most one rest.',
     '自某步起静止的运行停留于该步的构形，故自两步起皆静止的运行在两步处是同一构形：一个运行至多有一个静止。',
     [(LC, ['still_stays', 'still_same'])]),
    ('Where the adjustment rises with what is left and with the recent giving and keeps a band up to hi, a state at or '
     'below one within the band whose run comes to rest below the draw comes to rest below it too, and whether the run '
     'from a state up to hi does is decided at step 3 hi + 3.',
     '调整随所剩与近来所给而升且保持至 hi 的带时，处于或低于一个运行静于汲取之下的带内状态者，其运行也静于汲取之下；自至 hi 的状态出发的运行是否如此，'
     '在第 3 hi + 3 步可判定。',
     [(RM, [AD + n for n in ['RestsBelow', 'falls_of_below', 'falls_iff']])]),
    ('For each recent giving up to hi the threshold, the length of the leading run of levels whose runs are below the '
     'draw at step 3 hi + 3, is at most hi + 1; the run from a level up to hi rests below the draw exactly where the '
     'level is below it, and a larger recent giving has a threshold no higher.',
     '对至 hi 的每个近来所给，阈值即其运行在第 3 hi + 3 步低于汲取的水平之前导段长，至多为 hi + 1；自至 hi 的水平出发的运行恰在水平低于它时静于汲取之下，'
     '较大的近来所给的阈值不更高。',
     [(RM, ['leading', 'leading_le', 'leading_true', 'leading_false']
       + [AD + n for n in ['falling', 'threshold', 'threshold_le', 'falls_iff_below', 'threshold_falls']])]),
    ('Every run from a state up to hi is still from some step at most 3 hi + 3: below the threshold at a rest below '
     'the draw with level and recent giving equal, at a recent giving the adjustment returns from nothing; from it on '
     'at the draw with a level the regime\'s step leaves as it is.',
     '自至 hi 的状态出发的每个运行至多自第 3 hi + 3 步起静止：低于阈值者静于汲取之下，水平与近来所给相等，且该近来所给为调整自无所返回者；'
     '自阈值起者静于汲取，水平为体制之步所不动。',
     [(RM, [AD + 'fates'])]),
    ('Where giving rises with what is left, falls short of the draw below y, meets it from y up to the band\'s top, '
     'gives nothing from nothing and the step keeps a band up to hi reaching the point, the threshold is the point of '
     'no return H + y at every recent giving up to hi.',
     '所给随所剩而升、在 y 之下不及汲取、自 y 至带顶满足汲取、自无给无，且步保持至 hi 并达到此点的带时，在至 hi 的每个近来所给，阈值皆为不归点 H + y。',
     [(RM, ['threshold_regime'])]),
    ('Witness: giving that is two from one and nothing from any other level keeps every state up to four within four '
     'under a draw of two, yet the run from four rests at nothing and the run from three at three, so no least level '
     'separates the runs resting below the draw from the rest.',
     '见证：自一给二、自其余水平给无的所给在汲取二下使至四的每个状态保持在四之内，但自四的运行静于无，自三的运行静于三，故没有最小水平把静于汲取之下的运行'
     '与其余分开。',
     [(RM, [NO + n for n in ['giving', 'keeps', 'stays_three', 'ends_four', 'no_threshold']])]),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
new_by = {}
for mod in [LC, RM]:
    old_names = {d['name'] for d in next(m for m in P['modules'] if m['module'] == f'Becoming.{mod}')['declarations']}
    full = decls(mod)
    assert old_names <= set(full), old_names - set(full)
    new = sorted(d for d in full if d not in old_names)
    cited = sorted(d for _, _, groups in laws for m, names in groups if m == mod for d in resolve(mod, names))
    assert cited == new, (mod, set(new) - set(cited), set(cited) - set(new))
    new_by[mod] = new
EARLIER = {LC: ['Becoming.LastChange.StillFrom'],
           RM: ['Becoming.RegimeMargin.step', 'Becoming.RegimeMargin.Short', 'Becoming.RegimeMargin.Meets',
                'Becoming.RegimeMargin.Keeps', 'Becoming.RegimeMargin.FromNothing', 'Becoming.RegimeMargin.holds',
                'Becoming.RegimeMargin.ends_below', 'Becoming.RegimeMargin.Adjusted.step',
                'Becoming.RegimeMargin.Adjusted.RestsAtDraw', 'Becoming.RegimeMargin.Adjusted.orbit_regime',
                'Becoming.RegimeMargin.Adjusted.draw_pos', 'Becoming.RegimeMargin.Adjusted.Rises',
                'Becoming.RegimeMargin.Adjusted.Below', 'Becoming.RegimeMargin.Adjusted.Band',
                'Becoming.RegimeMargin.Adjusted.step_mono', 'Becoming.RegimeMargin.Adjusted.comes_to_rest']}
for mod, names in EARLIER.items():
    assert set(names) <= set(decls(mod)), set(names) - set(decls(mod))
USED = {'Recurrence': ['Becoming.Law.orbit', 'Becoming.Law.orbit_add', 'Becoming.Law.orbit_mul',
                       'Becoming.Law.orbit_shift', 'Becoming.Law.run'],
        'Lasting': ['Becoming.Lasting.orbit_mono'],
        'Prelude': ['Becoming.Naturals.add_sub_of_le']}
refs_used = []
for mod, names in USED.items():
    have = set(decls(mod))
    assert set(names) <= have, (mod, set(names) - have)
    refs_used.append((mod, sorted(names)))
n_new = sum(len(v) for v in new_by.values())
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'The threshold in the plane of level and recent giving', 'zh': '水平与近来所给之平面上的阈值'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Under an adjustment rising with what is left and with the recent giving, within a band, the runs that '
              'rest below the draw are exactly those from levels below a least level for each recent giving, decided; '
              'that level does not rise as the recent giving rises.',
        'zh': '调整随所剩与近来所给而升时，在带内，静于汲取之下的运行恰是自低于每个近来所给之最小水平出发者，可判定；该水平不随近来所给上升而升。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': [d for m, names in groups for d in resolve(m, names)]}
             for en, zh, groups in laws],
    'hypotheses': [
        {'en': 'No axiom. Whole-number amounts and discrete steps; one condition; the draw taken first, as much as there '
               'is; the state the level and one recent giving; each law\'s own premises as hypotheses: the '
               'adjustment rising with what is left and with the recent giving, a band the step keeps, and for the '
               'regime\'s case giving short of the draw below y, meeting it from y, nothing from nothing, and the band '
               'reaching the point.',
         'zh': '不加公理。整数量与离散步；一个条件；汲取先取，有多少取多少；状态是水平与一个近来所给；各律自身的前提为假设：调整随所剩与近来所给而升，'
               '步所保持的带，以及体制情形中所给在 y 之下不及汲取、自 y 满足汲取、自无给无、带达到此点。'}],
    'does_not_show': [
        {'en': 'The threshold over the reals: in whole numbers within a band the fates are decided at a fixed step; over '
               'the reals a run converges, and neither the convergence nor the curve is stated.',
         'zh': '实数上的阈值：在整数中、带内，命运在固定步可判定；在实数上运行收敛，收敛与曲线皆未陈述。', 'kind': 'scope'},
        {'en': 'That measured adjustments rise in both arguments over their band, or how often below-point episodes '
               'with recent giving short of the catch fall in the field: the curve\'s direction is proved under the '
               'premises, its field frequency untested.',
         'zh': '所测的调整在其带上于两个变元上皆升，或野外点下片段中近来所给不足捕捞者多常下降：曲线的方向是前提下的定理，其野外频率未经检验。',
         'kind': 'non-implication'},
        {'en': 'The threshold beyond the band, where the search stops at hi + 1; a state with a further lag; coupled '
               'conditions.',
         'zh': '带外的阈值（搜索止于 hi + 1）；带再一个滞后的状态；相互耦合的条件。', 'kind': 'scope'}],
    'counterexamples': [
        {'path': src(RM), 'detail': {
            'en': 'Notch.no_threshold: giving that does not rise with what is left keeps a band, yet the run from four '
                  'rests below the draw and the run from three, below it, does not, so no least level separates them.',
            'zh': 'Notch.no_threshold：不随所剩而升的所给保持一个带，但自四的运行静于汲取之下，自其下的三出发者却不然，故没有最小水平把它们分开。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {n_new} declarations '
              f'Becoming.LastChange and Becoming.RegimeMargin gained have empty axiom reports; the checker verifies core '
              f'purity. Built and reviewed in one session, with no separate reviewer; author review in study section '
              f'{N}; not independently reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.LastChange 与 Becoming.RegimeMargin 新增的 {n_new} 项声明公理报告为空；'
              f'检查器并核对核心纯净。在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'The curve and convergence over the reals; a frozen test, on stocks no analysis has read, of whether '
              'below-point episodes with recent giving short of the catch fall more often; whether measured adjustments '
              'rise in both over their bands; a state with a further lag; coupled conditions; an independent review.',
        'zh': '实数上的曲线与收敛；在未经任何分析读过的存量上冻结检验：近来所给不足捕捞的点下片段是否更常下降；所测的调整在其带上是否于两者皆升；'
              '带再一个滞后的状态；相互耦合的条件；独立审查。'},
    'correspondence': {
        'en': 'For order-preserving maps the boundary between basins of attraction is unordered, so in the plane it is '
              'a curve along which one coordinate falls as the other rises (Hirsch and Smith 2005); a point of no return '
              'as a level: depensation and the fold of the harvested equilibrium (Clark 1976; May 1977). On the spine, '
              'constructive and exact in its premises: the basins are resting below the draw and resting at the '
              'regime\'s point, decided at a fixed step, and the curve is the least level a finite search finds, with no '
              'omniscience; its regime case is the point H + y. Rising giving is shown needed by a witness.',
        'zh': '对保序映射，吸引域之间的边界是无序的，故在平面上是一条一个坐标随另一个上升而下降的曲线（Hirsch 与 Smith 2005）；作为水平的不归点：'
              '减补偿与收获平衡的折叠（Clark 1976；May 1977）。在脊柱上，构造性且在其前提上精确：吸引域即静于汲取之下与静于体制之点，在固定步可判定，'
              '曲线是有限搜索找到的最小水平，无需全知；其体制情形即点 H + y。所给上升由见证表明不可少。'},
    'canonical_source': src(RM),
    'aliases': ['the threshold in the plane of level and recent giving', 'the point of no return as a falling curve',
                'a run has at most one rest', '水平与近来所给之平面上的阈值', 'Becoming.RegimeMargin.Adjusted.falls_iff_below',
                'Becoming.RegimeMargin.Adjusted.threshold_falls', 'Becoming.RegimeMargin.threshold_regime'],
    'dependencies': [
        {'id': RM3, 'relation': 'formal-reuse',
         'detail': {'en': 'Every run of a rising adjustment within a band comes to rest; with order kept, the fates are '
                          'down-closed and decided.',
                    'zh': '带内上升调整的每个运行都静止；序得保持时，命运向下封闭且可判定。'},
         'interface': {
             'output': {'en': 'Adjusted.Rises, Below, Band, step_mono and comes_to_rest.',
                        'zh': 'Adjusted.Rises、Below、Band、step_mono 与 comes_to_rest。'},
             'input': {'en': 'For each recent giving, a least level below which exactly the runs rest below the draw.',
                       'zh': '对每个近来所给，一个最小水平，恰在其下运行静于汲取之下。'},
             'conditions': {'en': 'The adjustment rising in both arguments; a band.', 'zh': '调整于两个变元上皆升；一个带。'},
             'evidence': src(RM)}},
        {'id': RM2, 'relation': 'formal-reuse',
         'detail': {'en': 'The adjusted step, RestsAtDraw, the regime\'s run and the positive draw below the point are '
                          'reused; the threshold it left open in the plane is stated for rising adjustments.',
                    'zh': '沿用调整之步、RestsAtDraw、体制的运行与点下为正的汲取；它在平面上留下的阈值，对上升的调整已陈述。'},
         'interface': {
             'output': {'en': 'Adjusted.step, RestsAtDraw, orbit_regime and draw_pos.',
                        'zh': 'Adjusted.step、RestsAtDraw、orbit_regime 与 draw_pos。'},
             'input': {'en': 'The threshold in the plane, falling as the recent giving rises.',
                       'zh': '平面上的阈值，随近来所给上升而下降。'},
             'conditions': {'en': 'Whole-number amounts; the draw taken first.', 'zh': '整数量；汲取先取。'},
             'evidence': src(RM)}},
        {'id': RM1, 'relation': 'formal-reuse',
         'detail': {'en': 'The regime\'s step, its premises and its laws below and from the point are reused; the '
                          'threshold is the point H + y at every recent giving.',
                    'zh': '沿用体制之步、其前提及其点下与点起之律；阈值在每个近来所给皆为点 H + y。'},
         'interface': {
             'output': {'en': 'step, Short, Meets, Keeps, FromNothing, holds and ends_below.',
                        'zh': 'step、Short、Meets、Keeps、FromNothing、holds 与 ends_below。'},
             'input': {'en': 'Under the regime\'s step the threshold is H + y.', 'zh': '在体制之步下阈值为 H + y。'},
             'conditions': {'en': 'Giving rising with what is left; the band reaching the point.',
                            'zh': '所给随所剩而升；带达到此点。'},
             'evidence': src(RM)}},
        {'id': L1, 'relation': 'formal-reuse',
         'detail': {'en': 'StillFrom is reused; a run still from a step stays there, so it has at most one rest.',
                    'zh': '沿用 StillFrom；自某步起静止的运行停留于此，故至多一个静止。'},
         'interface': {
             'output': {'en': 'StillFrom.', 'zh': 'StillFrom。'},
             'input': {'en': 'A run has at most one rest, so a rest found at a fixed step is the run\'s rest.',
                       'zh': '运行至多一个静止，故在固定步找到的静止就是运行的静止。'},
             'conditions': {'en': 'A run of any process.', 'zh': '任一过程的运行。'},
             'evidence': src(LC)}}],
    'related': [],
    'references': [{'path': src(RM), 'role': 'proof', 'declarations': sorted(new_by[RM] + EARLIER[RM]), 'sha256': sha(src(RM))},
                   {'path': src(LC), 'role': 'proof', 'declarations': sorted(new_by[LC] + EARLIER[LC]), 'sha256': sha(src(LC))}]
                  + [{'path': src(mod), 'role': 'proof', 'declarations': names, 'sha256': sha(src(mod))}
                     for mod, names in refs_used]
                  + [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                     {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                     {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                     {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
    'proof_bindings': [{'source': src(mod), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{mod}',
                        'success_pointer': '/status', 'success_value': 'passed'}
                       for mod in [RM, LC] + [m for m, _ in refs_used]],
    'history': [{
        'en': f'21 October 2026: added (RM4), the threshold in the plane of level and recent giving: under an adjustment '
              f'rising in both arguments within a band, the runs resting below the draw are exactly those from levels '
              f'below a least level for each recent giving, decided at step 3 hi + 3, and that level does not rise as '
              f'the recent giving rises; under the regime\'s step it is H + y; study section {N}.',
        'zh': f'2026年10月21日：新增（RM4），水平与近来所给之平面上的阈值：带内于两个变元上皆升的调整下，静于汲取之下的运行恰是自低于每个近来所给之最小水平'
              f'出发者，在第 3 hi + 3 步可判定，该水平不随近来所给上升而升；在体制之步下为 H + y；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, (len(rec['statement']['en']), len(rec['statement']['zh']))
assert len(rec['correspondence']['en']) <= 1200 and len(rec['correspondence']['zh']) <= 500, (
    len(rec['correspondence']['en']), len(rec['correspondence']['zh']))
for h in rec['hypotheses']:
    assert len(h['en']) <= 420, len(h['en'])
for h in rec['does_not_show']:
    assert len(h['en']) <= 240, len(h['en'])
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID, n_new, 'declarations')

p = RECORDS / f'{RM2}.json'
d = json.loads(p.read_text())
hits = [x for x in d['does_not_show'] if x['en'].startswith('The threshold in the plane of level and recent giving')]
assert len(hits) == 1
hits[0]['en'] = ('The threshold in the plane for adjustments that do not rise in both arguments: record '
                 f'{RID} states it, a falling curve, for those that do within a band; a state with a further lag; '
                 'coupled conditions.')
hits[0]['zh'] = (f'不在两个变元上皆升的调整在平面上的阈值：记录 {RID} 对带内皆升者陈述它是一条下降曲线；带再一个滞后的状态；相互耦合的条件。')
assert len(hits[0]['en']) <= 240, len(hits[0]['en'])
for lang, old, new in [('en', 'the threshold curve in the plane of level and recent giving; ',
                        'the threshold in the plane for adjustments that do not rise in both arguments; '),
                       ('zh', '水平与近来所给之平面上的阈值曲线；', '不在两个变元上皆升的调整在平面上的阈值；')]:
    assert d['next_delta'][lang].count(old) == 1, lang
    d['next_delta'][lang] = d['next_delta'][lang].replace(old, new)
assert all(r['id'] != RID for r in d.get('related', []))
d['related'] = d.get('related', []) + [{'id': RID, 'detail': {
    'en': 'Where the adjustment rises with what is left and with the recent giving within a band, the runs resting below '
          'the draw are exactly those from levels below a least level for each recent giving, which falls as the recent '
          'giving rises; under the regime\'s step it is H + y.',
    'zh': '调整在带内随所剩与近来所给而升时，静于汲取之下的运行恰是自低于每个近来所给之最小水平出发者，该水平随近来所给上升而降；在体制之步下为 H + y。'}}]
d['history'].append({
    'en': f'21 October 2026, RM4: the threshold in the plane of level and recent giving, left open here, is stated for '
          f'adjustments rising in both arguments within a band (record {RID}, study section {N}); what this record does '
          f'not show and its next delta now say so. Its laws are unchanged.',
    'zh': f'2026年10月21日，RM4：此处留下的水平与近来所给之平面上的阈值，对带内在两个变元上皆升的调整已陈述（记录 {RID}，研究第 {N} 节）；'
          f'本记录所不表明者与其下一步现已如此说明。其规律不变。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('noted', RM2)

cov = json.loads((ROOT / COVERAGE).read_text())
row = next(r for r in cov['rows'] if r['id'] == 'degeneration')
assert RID not in row['records'] and RM3 in row['records']
row['records'].insert(row['records'].index(RM3) + 1, RID)
row['declarations'].insert(row['declarations'].index('Becoming.RegimeMargin.Adjusted.comes_to_rest') + 1,
                           'Becoming.RegimeMargin.Adjusted.falls_iff_below')
print('coverage row degeneration')
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
