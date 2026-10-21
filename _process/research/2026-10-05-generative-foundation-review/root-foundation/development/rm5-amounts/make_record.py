#!/usr/bin/env python3
"""Write RM5's record regime-in-any-amounts (a theorem), note it in where-a-run-of-a-regime-comes-to-rest and
threshold-in-the-state-plane (whose convergence over the reals it states), and give the coverage file's degeneration
row the record and its shape law:
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION PREVIOUS_RECEIPT PERIPHERY_RECEIPT   (from the checkout root,
after apply_text.py)

The laws cite exactly the declarations Becoming.RegimeMargin gained since the previous receipt and every declaration of
the periphery module RegimeReals. Every declaration cited is resolved against its receipt's audited declarations, and
each receipt must bind its modules' current bytes."""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
PERI = 'experiments/integrated-correction/general-framework/generative-basis/lean/regime'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
REVIEW = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md'
CHAPTER = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
COVERAGE = 'theories/becoming/results/completion/COVERAGE.json'
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N, previous, peri_id = sys.argv[1], int(sys.argv[2]), sys.argv[3], sys.argv[4]
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
PRECEIPT = f'{PERI}/regime-reals-checks/{peri_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
peri = json.loads((ROOT / PRECEIPT).read_text())
assert core['status'] == 'passed' and peri['status'] == 'passed'
HEAD = f"## {N}. The regime in any amounts, and its runs over the reals (RM5)"
assert re.search('^' + re.escape(HEAD) + '$', (ROOT / STUDY).read_text(), re.M)


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def src(mod):
    return f'{PKG}/Becoming/{mod}.lean'


PSRC = f'{PERI}/RegimeReals.lean'
assert peri['source_sha256']['RegimeReals'] == sha(PSRC), 'periphery receipt does not bind RegimeReals'
assert peri['source_sha256']['Becoming.RegimeMargin'] == core['source_sha256']['Becoming.RegimeMargin']
PDECLS = [d['name'] for d in peri['modules'][0]['declarations']]
assert set(a for v in peri['modules'][0]['axiom_dependencies'].values() for a in v) <= {
    'propext', 'Classical.choice', 'Quot.sound'}


def decls(mod):
    m = next(m for m in core['modules'] if m['module'] == f'Becoming.{mod}')
    assert core['source_sha256'][f'Becoming.{mod}'] == sha(src(mod)), ('receipt does not bind', mod)
    assert not any(m['axiom_dependencies'].values())
    return [d['name'] for d in m['declarations']]


def resolve(mod, names):
    full = PDECLS if mod == 'RegimeReals' else decls(mod)
    out = []
    for n in names:
        hits = [f for f in full if f == 'Becoming.RegimeMargin.' + n]
        assert len(hits) == 1, (mod, n, hits)
        out.append(hits[0])
    return out


BOUNDS = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
          'omission-not-refutation']

RID = 'regime-in-any-amounts'
RM4 = 'threshold-in-the-state-plane'
RM3 = 'where-a-run-of-a-regime-comes-to-rest'
RM2 = 'regime-point-under-adjusting-giving'
RM, RR = 'RegimeMargin', 'RegimeReals'
DR, RX = 'Drawn.', 'Drawn.Relaxation.'

laws = [
    ('Amounts with a draw are the core\'s amounts linearly ordered, with what is left once a draw is taken, as much as '
     'there is; the adjusted step reads in them, what is left rises with the level, and in whole numbers the step, its '
     'rising adjustments and its order are the adjusted step\'s.',
     '带汲取的量是核心之量加线性序，以及取走一份汲取（有多少取多少）之后的所剩；调整之步在其中可读，所剩随水平而升；在整数中，此步、其上升的调整与其序即调整之步者。',
     [(RM, [DR + n for n in ['step', 'add_cancel', 'sub_mono', 'whole', 'whole_run']] + ['Drawn'])]),
    ('Where the adjustment rises with what is left and with the recent giving, the step keeps the order of states, so a '
     'run that raises or lowers both the level and the recent giving at one step does so at every later step.',
     '调整随所剩与近来所给而升时，步保持状态之序，故在某一步使水平与近来所给同升（同降）的运行，此后每步皆如此。',
     [(RM, [DR + n for n in ['Rises', 'Below', 'step_mono', 'rising_on', 'falling_on']])]),
    ('From the first step on, a step that neither raises nor lowers both climbs (the level up strictly, the recent giving '
     'down strictly toward the draw from above) or sinks (the mirror, from below), whatever the adjustment, and the next '
     'such step is of the same kind.',
     '自首步起，既不同升也不同降的一步攀升（水平严格升、近来所给自上方严格降向汲取）或下沉（自下方的镜像），无论调整为何；下一个这样的步同类。',
     [(RM, [DR + n for n in ['Climbs', 'Sinks', 'given_le_level', 'level_up_iff', 'level_down_iff', 'level_of_low',
                             'climbs_or_sinks', 'climbs_next', 'sinks_next', 'run_shape']])]),
    ('A run from a state within a band the step keeps stays within it, and a run is still from a step exactly where its '
     'state there is the regime\'s point or a state within the draw with level and recent giving equal.',
     '自步所保持之带内状态出发的运行留在带内；运行恰在其状态为体制之点、或为汲取之内且水平与近来所给相等的状态处，自该步起静止。',
     [(RM, [DR + n for n in ['Band', 'run_within', 'rest_iff', 'still_iff']])]),
    ('Over the non-negative reals, amounts with a draw, every run of a rising adjustment from a state within a band '
     'converges: its level and recent giving are each monotone from some step on and bounded.',
     '在非负实数（带汲取的量）上，上升调整自带内状态出发的每个运行都收敛：其水平与近来所给自某步起各自单调且有界。',
     [(RR, [DR + n for n in ['reals', 'reals_step', 'tendsto_of_rising', 'tendsto_of_falling', 'converges']])]),
    ('Where the adjustment is continuous, the limit is a rest: the regime\'s point, or within the draw with level and '
     'recent giving equal.',
     '调整连续时，极限是一个静止：体制之点，或汲取之内水平与近来所给相等者。',
     [(RR, [DR + n for n in ['limit_rest', 'limit_fates']])]),
    ('Limits keep the order of the states run from, so a state at or below one whose run converges below the draw '
     'converges below it too, and at one level a larger recent giving never turns a fall into a hold.',
     '极限保持出发状态之序，故处于或低于一个其运行收敛于汲取之下的状态者亦收敛于汲取之下；在同一水平，较大的近来所给从不使下降变为持守。',
     [(RR, [DR + n for n in ['limits_below', 'Falls', 'falls_of_below', 'falls_given']])]),
    ('Witness: giving moving halfway from the recent giving to a draw of one rises in both and keeps a band up to one, '
     'and the run from nothing converges and is still from no step.',
     '见证：自近来所给向汲取一移动一半的所给于两者皆升且保持至一的带，自无出发的运行收敛，却无一步起静止。',
     [(RR, [RX + n for n in ['giving', 'rises', 'step_low', 'band', 'course', 'never_rests']])]),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
old_names = {d['name'] for d in next(m for m in P['modules'] if m['module'] == 'Becoming.RegimeMargin')['declarations']}
full = decls(RM)
assert old_names <= set(full), old_names - set(full)
new_rm = sorted(d for d in full if d not in old_names)
cited_rm = sorted(d for _, _, groups in laws for m, names in groups if m == RM for d in resolve(m, names))
assert cited_rm == new_rm, (set(new_rm) - set(cited_rm), set(cited_rm) - set(new_rm))
cited_rr = sorted(d for _, _, groups in laws for m, names in groups if m == RR for d in resolve(m, names))
assert cited_rr == sorted(PDECLS), (set(PDECLS) - set(cited_rr), set(cited_rr) - set(PDECLS))
EARLIER = ['Becoming.RegimeMargin.Adjusted.step', 'Becoming.RegimeMargin.Adjusted.Rises',
           'Becoming.RegimeMargin.Adjusted.Below', 'Becoming.RegimeMargin.Adjusted.comes_to_rest',
           'Becoming.RegimeMargin.Adjusted.rest_iff']
assert set(EARLIER) <= set(full), set(EARLIER) - set(full)
USED = {'Amounts': ['Becoming.Amounts', 'Becoming.Amounts.whole', 'Becoming.Amounts.add_le_add_left',
                    'Becoming.Amounts.le_add_left', 'Becoming.Amounts.le_of_eq'],
        'Recurrence': ['Becoming.Law.orbit', 'Becoming.Law.orbit_add', 'Becoming.Law.orbit_mul', 'Becoming.Law.run'],
        'Lasting': ['Becoming.Lasting.orbit_mono'],
        'LastChange': ['Becoming.LastChange.StillFrom'],
        'Prelude': ['Becoming.add_sub_of_le', 'Becoming.sub_eq_zero_of_le']}
refs_used = []
for mod, names in USED.items():
    have = set(decls(mod))
    assert set(names) <= have, (mod, set(names) - have)
    refs_used.append((mod, sorted(names)))
n_new = len(new_rm) + len(PDECLS)
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'The regime in any amounts, and its runs over the reals', 'zh': '任何量中的体制，及其在实数上的运行'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'The regime\'s order, the shape of its runs and its rests hold in any linearly ordered amounts with a '
              'draw; over the reals every run of a rising adjustment within a band converges, to a rest where the '
              'adjustment is continuous, and need not come to rest.',
        'zh': '体制之序、其运行的形状及其静止在任何带汲取的线性有序量中成立；在实数上，带内上升调整的每个运行都收敛，调整连续时收敛于一个静止，且不必到达静止。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': [d for m, names in groups for d in resolve(m, names)]}
             for en, zh, groups in laws],
    'hypotheses': [
        {'en': 'No axiom in the core; the periphery\'s laws use Lean\'s standard axioms through Mathlib. Discrete steps; '
               'one condition; the draw taken first, as much as there is; the state the level and one recent giving; '
               'amounts linearly ordered with a truncated difference; each law\'s own premises as hypotheses: the '
               'adjustment rising in both arguments for the order, a band, continuity for the limit a rest.',
         'zh': '核心不加公理；外围之律经 Mathlib 用 Lean 的标准公理。离散步；一个条件；汲取先取，有多少取多少；状态是水平与一个近来所给；'
               '量线性有序且有截断差；各律自身的前提为假设：序需调整于两个变元上皆升，带，极限为静止需连续。'}],
    'does_not_show': [
        {'en': 'That a run converges, in the core: convergence of a bounded monotone sequence is an omniscience '
               'principle, so the core states the shape of a run and the periphery the convergence over the reals.',
         'zh': '在核心中运行收敛：有界单调序列的收敛是一个全知原理，故核心陈述运行的形状，外围陈述实数上的收敛。', 'kind': 'scope'},
        {'en': 'The threshold over the reals as a computed level, or the regime\'s case H + y there: the fates are stated '
               'as down-closed and falling with the recent giving.',
         'zh': '实数上作为计算出的水平的阈值，或其中体制情形 H + y：命运被陈述为向下封闭且随近来所给而降。', 'kind': 'scope'},
        {'en': 'Continuous time; a state with a further lag; coupled conditions; that measured adjustments rise in both '
               'over their band.',
         'zh': '连续时间；带再一个滞后的状态；相互耦合的条件；所测的调整在其带上于两者皆升。', 'kind': 'scope'}],
    'counterexamples': [
        {'path': PSRC, 'detail': {
            'en': 'Drawn.Relaxation.never_rests: giving moving halfway toward a draw of one rises in both and keeps a '
                  'band, and its run from nothing converges and is still from no step, so over the reals a run need not '
                  'come to rest.',
            'zh': 'Drawn.Relaxation.never_rests：向汲取一移动一半的所给于两者皆升且保持带，其自无出发的运行收敛却无一步起静止，故在实数上运行不必到达静止。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked: the core\'s {len(new_rm)} new declarations of Becoming.RegimeMargin by the consolidated '
              f'Lean 4.29.1 checker (receipt {core_id}), with empty axiom reports; the periphery module RegimeReals\'s '
              f'{len(PDECLS)} declarations by its own checker with Lean 4.30.0-rc2 and the pinned Mathlib (receipt '
              f'{peri_id}), each on Lean\'s standard axioms only, its core modules matching passed receipts. Built and '
              f'reviewed in one session, with no separate reviewer; author review in study section {N}; not '
              f'independently reviewed by a person.',
        'zh': f'机器检查：核心 Becoming.RegimeMargin 新增的 {len(new_rm)} 项声明由 Lean 4.29.1 合并检查器实查（回执 {core_id}），公理报告为空；'
              f'外围模块 RegimeReals 的 {len(PDECLS)} 项声明由其自身检查器以 Lean 4.30.0-rc2 与固定的 Mathlib 实查（回执 {peri_id}），'
              f'只用 Lean 标准公理，核心模块与已通过回执相符。一个会话中构建并审查，无另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'A computed threshold and the regime\'s case H + y over the reals; continuous time; a state with a further '
              'lag; coupled conditions; whether measured adjustments rise in both over their bands; an independent '
              'review.',
        'zh': '实数上计算出的阈值与体制情形 H + y；连续时间；带再一个滞后的状态；相互耦合的条件；所测的调整在其带上是否于两者皆升；独立审查。'},
    'correspondence': {
        'en': 'Orbits of planar cooperative (order-preserving) maps are eventually componentwise monotone under '
              'regularity conditions, so bounded orbits converge (Smith 1998; Hirsch and Smith 2005); convergence of a '
              'bounded monotone sequence is not constructive (Bridges and Richman 1987); partial adjustment and '
              'delay-difference models of renewal (Deriso 1980; Schnute 1985). On the spine the shape needs no '
              'regularity condition: the level moves by the new giving less the draw, so every step neither up nor '
              'down moves the recent giving toward the draw, whatever the adjustment; the core states it '
              'constructively in any amounts, the periphery the convergence over the reals.',
        'zh': '平面合作（保序）映射的轨道在正则条件下终将逐分量单调，故有界轨道收敛（Smith 1998；Hirsch 与 Smith 2005）；有界单调序列的收敛不是构造性的'
              '（Bridges 与 Richman 1987）；更新的部分调整与延迟差分模型（Deriso 1980；Schnute 1985）。在脊柱上形状无需正则条件：水平按新所给减汲取而动，'
              '故每个既不同升也不同降的步使近来所给移向汲取，无论调整为何；核心在任何量中构造性地陈述它，外围陈述实数上的收敛。'},
    'canonical_source': src(RM),
    'aliases': ['the regime in any amounts', 'the shape of a run of the adjusted step', 'runs of the regime over the reals',
                '任何量中的体制', 'Becoming.RegimeMargin.Drawn.run_shape', 'Becoming.RegimeMargin.Drawn.converges',
                'Becoming.RegimeMargin.Drawn.Relaxation.never_rests'],
    'dependencies': [
        {'id': RM3, 'relation': 'formal-reuse',
         'detail': {'en': 'The adjusted step and its rising adjustments are read in any amounts; whole numbers are an '
                          'instance, where every run within a band comes to rest.',
                    'zh': '调整之步及其上升的调整在任何量中可读；整数是其实例，其中带内每个运行都静止。'},
         'interface': {
             'output': {'en': 'Adjusted.step, Rises, Below and comes_to_rest.',
                        'zh': 'Adjusted.step、Rises、Below 与 comes_to_rest。'},
             'input': {'en': 'The order, the shape of a run and its rests in any amounts; convergence over the reals.',
                       'zh': '任何量中的序、运行的形状及其静止；实数上的收敛。'},
             'conditions': {'en': 'Amounts linearly ordered with a truncated difference.', 'zh': '量线性有序且有截断差。'},
             'evidence': src(RM)}},
        {'id': RM4, 'relation': 'formal-reuse',
         'detail': {'en': 'Down-closed fates falling with the recent giving hold over the reals, with convergence in place '
                          'of a rest decided at a fixed step.',
                    'zh': '向下封闭且随近来所给而降的命运在实数上成立，以收敛代替在固定步可判定的静止。'},
         'interface': {
             'output': {'en': 'The fates below the draw down-closed, falling with the recent giving.',
                        'zh': '汲取之下的命运向下封闭，随近来所给而降。'},
             'input': {'en': 'The same order of fates over the reals.', 'zh': '实数上相同的命运之序。'},
             'conditions': {'en': 'The adjustment rising in both; a band.', 'zh': '调整于两者皆升；带。'},
             'evidence': PSRC}}],
    'related': [
        {'id': RM2, 'detail': {'en': 'The rest law: at or above the draw every rest is the regime\'s, here in any amounts.',
                               'zh': '静止之律：汲取及其上的每个静止都是体制的，此处在任何量中。'}}],
    'references': [{'path': src(RM), 'role': 'proof', 'declarations': sorted(new_rm + EARLIER), 'sha256': sha(src(RM))},
                   {'path': PSRC, 'role': 'proof', 'declarations': PDECLS, 'sha256': sha(PSRC)}]
                  + [{'path': src(mod), 'role': 'proof', 'declarations': names, 'sha256': sha(src(mod))}
                     for mod, names in refs_used]
                  + [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                     {'path': PRECEIPT, 'role': 'receipt', 'sha256': sha(PRECEIPT)},
                     {'path': f'{PERI}/check_regime_reals.py', 'role': 'integration',
                      'sha256': sha(f'{PERI}/check_regime_reals.py')},
                     {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                     {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                     {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
    'proof_bindings': [{'source': src(mod), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{mod}',
                        'success_pointer': '/status', 'success_value': 'passed'}
                       for mod in [RM] + [m for m, _ in refs_used]]
                      + [{'source': PSRC, 'receipt': PRECEIPT, 'sha256_pointer': '/source_sha256/RegimeReals',
                          'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{
        'en': f'21 October 2026: added (RM5), the regime in any amounts, and its runs over the reals: the order, the '
              f'shape of a run and its rests in any linearly ordered amounts with a draw; over the non-negative reals '
              f'every run of a rising adjustment within a band converges, to a rest where the adjustment is continuous, '
              f'with fates down-closed, and need not rest; study section {N}.',
        'zh': f'2026年10月21日：新增（RM5），任何量中的体制及其在实数上的运行：任何带汲取的线性有序量中的序、运行的形状及其静止；在非负实数上，'
              f'带内上升调整的每个运行都收敛，调整连续时收敛于一个静止，命运向下封闭，且不必到达静止；研究第 {N} 节。'}],
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


def note(rid, dns_old_start, dns_new, nd_old, nd_new, hist):
    p = RECORDS / f'{rid}.json'
    d = json.loads(p.read_text())
    hits = [x for x in d['does_not_show'] if x['en'].startswith(dns_old_start)]
    assert len(hits) == 1, (rid, len(hits))
    hits[0]['en'], hits[0]['zh'] = dns_new
    assert len(hits[0]['en']) <= 240, len(hits[0]['en'])
    for lang in ['en', 'zh']:
        assert d['next_delta'][lang].count(nd_old[lang]) == 1, (rid, lang)
        d['next_delta'][lang] = d['next_delta'][lang].replace(nd_old[lang], nd_new[lang])
    d['history'].append(hist)
    p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('noted', rid)


note(RM3, 'Convergence over the reals',
     ('Rest in finitely many steps over the reals: in whole numbers each change moves an amount by at least one; over '
      f'the reals a run converges and need not rest (record {RID}).',
      f'实数上有限步内的静止：在整数中每次变化至少移动一个单位；在实数上运行收敛而不必静止（记录 {RID}）。'),
     {'en': 'Convergence over the reals; whether', 'zh': '实数上的收敛；'},
     {'en': 'Whether', 'zh': ''},
     {'en': f'21 October 2026, RM5: convergence over the reals, left open here, is stated for rising adjustments within '
            f'a band, with a witness that a run need not rest (record {RID}, study section {N}); what this record does '
            f'not show and its next delta now say so. Its laws are unchanged.',
      'zh': f'2026年10月21日，RM5：此处留下的实数上的收敛，对带内上升的调整已陈述，并有运行不必静止的见证（记录 {RID}，研究第 {N} 节）；'
            f'本记录所不表明者与其下一步现已如此说明。其规律不变。'})
note(RM4, 'The threshold over the reals',
     ('The threshold over the reals as a computed level: there a run converges, and record '
      f'{RID} states the fates as down-closed and falling with the recent giving, not the level.',
      f'实数上作为计算出的水平的阈值：在实数上运行收敛，记录 {RID} 把命运陈述为向下封闭且随近来所给而降，而非水平。'),
     {'en': 'The curve and convergence over the reals; ', 'zh': '实数上的曲线与收敛；'},
     {'en': 'A computed threshold over the reals; ', 'zh': '实数上计算出的阈值；'},
     {'en': f'21 October 2026, RM5: over the reals every run of a rising adjustment within a band converges and the fates '
            f'below the draw are down-closed and fewer as the recent giving rises (record {RID}, study section {N}); '
            f'what this record does not show and its next delta now say so. Its laws are unchanged.',
      'zh': f'2026年10月21日，RM5：在实数上，带内上升调整的每个运行都收敛，汲取之下的命运向下封闭且随近来所给上升而减少（记录 {RID}，研究第 {N} 节）；'
            f'本记录所不表明者与其下一步现已如此说明。其规律不变。'})

cov = json.loads((ROOT / COVERAGE).read_text())
row = next(r for r in cov['rows'] if r['id'] == 'degeneration')
assert RID not in row['records'] and RM4 in row['records']
row['records'].insert(row['records'].index(RM4) + 1, RID)
row['declarations'].insert(row['declarations'].index('Becoming.RegimeMargin.Adjusted.falls_iff_below') + 1,
                           'Becoming.RegimeMargin.Drawn.run_shape')
print('coverage row degeneration')
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
