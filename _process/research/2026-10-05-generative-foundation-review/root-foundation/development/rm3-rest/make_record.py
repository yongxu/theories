#!/usr/bin/env python3
"""Write RM3's record where-a-run-of-a-regime-comes-to-rest (a theorem), note it in regime-point-under-adjusting-giving
(whose open question, whether a run comes to rest, it answers for rising adjustments within a band) and in
the-last-change-of-a-run (whose open premise under which settling is decided it states for a law's run), and give the
coverage file's degeneration row the record and its run law:
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
README = 'experiments/margin-measured/README.md'
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N, previous = sys.argv[1], int(sys.argv[2]), sys.argv[3]
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
HEAD = f"## {N}. Where a run of a regime comes to rest (RM3)"
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

RID = 'where-a-run-of-a-regime-comes-to-rest'
RM2 = 'regime-point-under-adjusting-giving'
RM1 = 'margin-of-a-regime'
L1 = 'the-last-change-of-a-run'
LC, RM = 'LastChange', 'RegimeMargin'
AD, CR, AL = 'Adjusted.', 'Crossing.', 'Alternation.'

laws = [
    ('A law\'s run is fixed by its law: where the law leaves a configuration as it is, the run stays there. Where a '
     'quantity never falls along a law\'s run, rises at every change and stays at most d above its start, the run is '
     'still from some step at most d, decided at each step, with no omniscience.',
     '定律的运行由其定律决定：定律不动一个构形处，运行停留于此。一个量沿定律的运行永不下降、每次变化皆上升、且至多高出起点 d 时，运行至多自第 d 步起静止；'
     '每步皆可判定，无需全知。',
     [(LC, ['still_of_fixed', 'still_succ', 'still_within'])]),
    ('Where giving rises with what is left, the regime\'s step keeps the order of levels, so a run moves one way only, '
     'and within a band up to hi every run from a level up to hi is still from some step at most hi.',
     '所给随所剩而升时，体制之步保持水平之序，故运行只朝一个方向；在至 hi 的带内，自至 hi 的水平出发的每个运行至多自第 hi 步起静止。',
     [(RM, ['step_mono', 'rests_within'])]),
    ('Where the adjustment rises with what is left and with the recent giving, the adjusted step keeps the order of '
     'states; a run whose first step lowers neither its level nor its recent giving never lowers either and, within a '
     'band, is still within 2 hi - (x + r) steps; one whose first step raises neither is still within x + r steps.',
     '调整随所剩与近来所给而升时，调整之步保持状态之序；首步不降水平也不降近来所给的运行两者皆永不降，在带内至多 2 hi - (x + r) 步后静止；'
     '首步两者皆不升的运行至多 x + r 步后静止。',
     [(RM, [AD + n for n in ['Rises', 'Below', 'Band', 'step_mono', 'sum_lt_of_below', 'given_le_level', 'in_band',
                             'run_rises', 'run_falls', 'rests_rising', 'rests_falling']])]),
    ('A step that neither raises nor lowers both the level and the recent giving lowers a count bounded by the recent '
     'giving\'s distance from the draw, so every run from a level and a recent giving up to hi within a band is still '
     'within 3 hi + 3 steps, at rest: at the draw with a level the regime\'s step leaves as it is, or below the draw '
     'with level and recent giving equal.',
     '水平与近来所给不同升也不同降的一步，使一个以近来所给与汲取之距为界的计数下降；故带内自至 hi 的水平与近来所给出发的每个运行至多 3 hi + 3 步后静止：'
     '静于汲取且水平为体制之步所不动，或静于汲取之下且水平与近来所给相等。',
     [(RM, [AD + n for n in ['unordered', 'unordered_below', 'unordered_le', 'unordered_falls', 'rests_from', 'AtRest',
                             'fixed_iff', 'comes_to_rest']])]),
    ('Witnesses: giving two from nothing and nothing from more keeps a band up to two under a draw of one, yet the run '
     'from one moves between one and two at every step; with no band, the gated giving\'s run from five rises at every '
     'step; a constant giving of one rests below a draw of two.',
     '见证：自无给二、多则给无的所给在汲取一下保持至二的带，但自一的运行每步在一与二之间移动；无带时，门限所给自五的运行每步上升；常给一者静于汲取二之下。',
     [(RM, [AL + n for n in ['giving', 'keeps', 'returns', 'alternates']]
       + [CR + n for n in ['giving_rises', 'climbs', 'rises_without_rest']] + [AD + 'rests_short'])]),
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
EARLIER = {LC: ['Becoming.LastChange.StillFrom', 'Becoming.LastChange.lpo_iff_settles'],
           RM: ['Becoming.RegimeMargin.step', 'Becoming.RegimeMargin.Keeps', 'Becoming.RegimeMargin.Adjusted.step',
                'Becoming.RegimeMargin.Adjusted.RestsAtDraw', 'Becoming.RegimeMargin.Adjusted.FromNothing',
                'Becoming.RegimeMargin.Adjusted.rest_iff', 'Becoming.RegimeMargin.Adjusted.orbit_regime',
                'Becoming.RegimeMargin.Crossing.giving']}
for mod, names in EARLIER.items():
    assert set(names) <= set(decls(mod)), set(names) - set(decls(mod))
USED = {'Recurrence': ['Becoming.Law.orbit', 'Becoming.Law.orbit_mul', 'Becoming.Law.orbit_shift', 'Becoming.Marks'],
        'Lasting': ['Becoming.Lasting.orbit_mono'],
        'Optimum': ['Becoming.Optimum.sub_le_sub_left_of_le'],
        'Frontier': ['Becoming.Requirement.Formation.sub_lt_sub_of_lt']}
refs_used = []
for mod, names in USED.items():
    have = set(decls(mod))
    assert set(names) <= have, (mod, set(names) - have)
    refs_used.append((mod, sorted(names)))
n_new = sum(len(v) for v in new_by.values())
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Where a run of a regime comes to rest', 'zh': '一个体制的运行静于何处'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Every run of an adjustment of giving rising with what is left and with the recent giving, within a band '
              'up to hi, comes to rest within 3 hi + 3 steps, at the regime\'s point or below the draw; whether it '
              'changes again is decided at each step.',
        'zh': '所给之调整随所剩与近来所给而升时，至 hi 的带内每个运行至多 3 hi + 3 步后静止，静于体制之点或汲取之下；是否再变每步可判定。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': [d for m, names in groups for d in resolve(m, names)]}
             for en, zh, groups in laws],
    'hypotheses': [
        {'en': 'No axiom. Whole-number amounts and discrete steps; one condition; the draw taken first, as much as there '
               'is; the state the level and one recent giving; for each law its own premises as hypotheses: giving, or '
               'the adjustment, rising with what is left (and with the recent giving), and a band the step keeps. '
               'RestsAtDraw only names the regime, since every adjustment A satisfies it for g e = A e H.',
         'zh': '不加公理。整数量与离散步；一个条件；汲取先取，有多少取多少；状态是水平与一个近来所给；各律自身的前提为假设：所给或调整随所剩（与近来所给）而升，'
               '以及步所保持的带。RestsAtDraw 只为体制命名，因每个调整 A 对 g e = A e H 皆满足它。'}],
    'does_not_show': [
        {'en': 'Convergence over the reals: in whole numbers each change moves an amount by at least one, so a run rests '
               'in finitely many steps; over the reals the corresponding statement is convergence, not stated.',
         'zh': '实数上的收敛：在整数中每次变化至少移动一个单位，故运行在有限步内静止；在实数上相应的陈述是收敛，未被陈述。', 'kind': 'scope'},
        {'en': 'That measured giving rises over its band: MQ5\'s law rises in both arguments exactly where its regime\'s '
               'giving rises with what is left, which is not checked on the data.',
         'zh': '所测的所给在其带上上升：MQ5 之律恰在其体制所给随所剩而升时于两个变元上皆升，这未在数据上检查。', 'kind': 'non-implication'},
        {'en': 'That 3 hi + 3 is the least bound; a state with a further lag; coupled conditions.',
         'zh': '3 hi + 3 是最小的界；带再一个滞后的状态；相互耦合的条件。', 'kind': 'scope'}],
    'counterexamples': [
        {'path': src(RM), 'detail': {
            'en': 'Alternation.alternates: giving that falls as what is left rises keeps a band, yet its run alternates for '
                  'ever; Crossing.rises_without_rest: with no band a rising run climbs at every step; '
                  'Adjusted.rests_short: a rest below the draw where something is given from nothing.',
            'zh': 'Alternation.alternates：随所剩上升而下降的所给保持一个带，其运行却永远交替；Crossing.rises_without_rest：无带时上升的运行每步攀升；'
                  'Adjusted.rests_short：自无有所给时，静于汲取之下。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {n_new} declarations '
              f'Becoming.LastChange and Becoming.RegimeMargin gained have empty axiom reports; the checker verifies core '
              f'purity. Built and reviewed in one session, with no separate reviewer; author review in study section '
              f'{N}; not independently reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.LastChange 与 Becoming.RegimeMargin 新增的 {n_new} 项声明公理报告为空；'
              f'检查器并核对核心纯净。在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'Convergence over the reals; whether measured giving laws rise over their bands; the least bound; a state '
              'with a further lag; coupled conditions; an independent review.',
        'zh': '实数上的收敛；所测的所给之律在其带上是否上升；最小的界；带再一个滞后的状态；相互耦合的条件；独立审查。'},
    'correspondence': {
        'en': 'Compensatory renewal settles and overcompensating renewal cycles (Beverton and Holt 1957; May 1976); '
              'orbits of planar cooperative maps are eventually componentwise monotone under regularity conditions '
              '(Smith 1998; Hirsch and Smith 2005); deciding where a bounded monotone sequence stops is an omniscience '
              'principle (Bridges and Richman 1987). On the spine, constructive and exact in its premises: a law\'s run '
              'still for one step is still for ever, so a bounded mark decides its rest; the adjusted step need not be '
              'one to one, and its own structure, moving the level by the new giving less the draw, bounds the steps '
              'before its run moves one way only. Rising giving and the band are each shown needed by a witness.',
        'zh': '补偿性更新会安定，过度补偿的更新会循环（Beverton 与 Holt 1957；May 1976）；平面合作映射的轨道在正则条件下终将逐分量单调（Smith 1998；'
              'Hirsch 与 Smith 2005）；判定有界单调序列何处停止是一个全知原理（Bridges 与 Richman 1987）。在脊柱上，构造性且在其前提上精确：'
              '定律的运行静止一步即永远静止，故有界的标记判定其静止；调整之步未必一一对应，其自身结构（水平按新所给减汲取而动）界定了运行只朝一向之前的步数。'
              '所给上升与带各由见证表明不可少。'},
    'canonical_source': src(RM),
    'aliases': ['where a run of a regime comes to rest', 'every run of a rising adjustment comes to rest',
                'a law\'s run with a bounded mark', '一个体制的运行静于何处', 'Becoming.RegimeMargin.Adjusted.comes_to_rest',
                'Becoming.RegimeMargin.rests_within', 'Becoming.LastChange.still_within'],
    'dependencies': [
        {'id': RM2, 'relation': 'formal-reuse',
         'detail': {'en': 'The adjusted step, RestsAtDraw and the rest law at or above the draw are reused; the rest law '
                          'is extended below the draw and the run is shown to reach it.',
                    'zh': '沿用调整之步、RestsAtDraw 与汲取及其上的静止之律；静止之律扩展到汲取之下，并表明运行会到达它。'},
         'interface': {
             'output': {'en': 'Adjusted.step, RestsAtDraw, rest_iff and orbit_regime.',
                        'zh': 'Adjusted.step、RestsAtDraw、rest_iff 与 orbit_regime。'},
             'input': {'en': 'Every run of a rising adjustment within a band comes to rest at such a point or below '
                             'the draw.', 'zh': '带内上升调整的每个运行都静于此种点或汲取之下。'},
             'conditions': {'en': 'Whole-number amounts; the draw taken first.', 'zh': '整数量；汲取先取。'},
             'evidence': src(RM)}},
        {'id': L1, 'relation': 'formal-reuse',
         'detail': {'en': 'StillFrom is reused; for a law\'s run a bounded mark decides settling, a premise the last-change '
                          'laws left open.',
                    'zh': '沿用 StillFrom；对定律的运行，有界的标记判定安定，这是最后变化之律留下的开放前提。'},
         'interface': {
             'output': {'en': 'StillFrom, and settling for every process as the limited principle of omniscience.',
                        'zh': 'StillFrom，以及对每个过程的安定即有限全知原理。'},
             'input': {'en': 'A law\'s run with a bounded mark is still within the bound, decided.',
                       'zh': '有有界标记的定律运行在界内静止，可判定。'},
             'conditions': {'en': 'Decidable configurations; a deterministic law.', 'zh': '可判定的构形；确定的定律。'},
             'evidence': src(LC)}}],
    'related': [
        {'id': RM1, 'detail': {'en': 'The regime\'s step: with giving rising with what is left, every run within a band '
                                     'comes to rest within hi steps.',
                               'zh': '体制之步：所给随所剩而升时，带内每个运行至多 hi 步后静止。'}}],
    'references': [{'path': src(RM), 'role': 'proof', 'declarations': sorted(new_by[RM] + EARLIER[RM]), 'sha256': sha(src(RM))},
                   {'path': src(LC), 'role': 'proof', 'declarations': sorted(new_by[LC] + EARLIER[LC]), 'sha256': sha(src(LC))}]
                  + [{'path': src(mod), 'role': 'proof', 'declarations': names, 'sha256': sha(src(mod))}
                     for mod, names in refs_used]
                  + [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                     {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                     {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                     {'path': README, 'role': 'integration', 'sha256': sha(README)},
                     {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
    'proof_bindings': [{'source': src(mod), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{mod}',
                        'success_pointer': '/status', 'success_value': 'passed'}
                       for mod in [RM, LC] + [m for m, _ in refs_used]],
    'history': [{
        'en': f'21 October 2026: added (RM3), where a run of a regime comes to rest: a law\'s run with a bounded mark '
              f'rests within the bound, decided; every run of an adjustment rising in both arguments within a band rests '
              f'within 3 hi + 3 steps, at the regime\'s point or below the draw; study section {N}.',
        'zh': f'2026年10月21日：新增（RM3），一个体制的运行静于何处：有有界标记的定律运行在界内静止，可判定；带内在两个变元上皆升的调整的每个运行至多 '
              f'3 hi + 3 步后静止，静于体制之点或汲取之下；研究第 {N} 节。'}],
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


def note(rid, dns_old_start, dns_new, nd_old, nd_new, related, hist):
    p = RECORDS / f'{rid}.json'
    d = json.loads(p.read_text())
    hits = [x for x in d['does_not_show'] if x['en'].startswith(dns_old_start)]
    assert len(hits) == 1, (rid, len(hits))
    hits[0]['en'], hits[0]['zh'] = dns_new
    assert len(hits[0]['en']) <= 240, len(hits[0]['en'])
    for lang in ['en', 'zh']:
        assert d['next_delta'][lang].count(nd_old[lang]) == 1, (rid, lang)
        d['next_delta'][lang] = d['next_delta'][lang].replace(nd_old[lang], nd_new[lang])
    assert all(r['id'] != RID for r in d.get('related', []))
    d['related'] = d.get('related', []) + [{'id': RID, 'detail': related}]
    d['history'].append(hist)
    p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('noted', rid)


note(RM2, 'That a run comes to rest, or how fast',
     ('That a run comes to rest, or how fast: these laws say where a run can rest, not that it does; record '
      f'{RID} states that it does for adjustments rising in both arguments within a band.',
      f'运行会静止，或多快静止：这些规律说运行能在何处静止，不说它会静止；记录 {RID} 对带内在两个变元上皆升的调整陈述它会静止。'),
     {'en': 'Whether and how fast a run comes to rest; ', 'zh': '运行是否与多快静止；'},
     {'en': 'Which adjustments that do not rise still bring every run to rest; ',
      'zh': '哪些不上升的调整仍使每个运行静止；'},
     {'en': 'Where the adjustment rises with what is left and with the recent giving and a band keeps the state, every run '
            'comes to rest within 3 hi + 3 steps, at the regime\'s point or below the draw.',
      'zh': '调整随所剩与近来所给而升且带保持状态时，每个运行至多 3 hi + 3 步后静止，静于体制之点或汲取之下。'},
     {'en': f'21 October 2026, RM3: whether a run comes to rest, left open here, is answered for adjustments rising in both '
            f'arguments within a band (record {RID}, study section {N}); what this record does not show and its next '
            f'delta now say so. Its laws are unchanged.',
      'zh': f'2026年10月21日，RM3：此处留下的运行是否静止，对带内在两个变元上皆升的调整已得回答（记录 {RID}，研究第 {N} 节）；'
            f'本记录所不表明者与其下一步现已如此说明。其规律不变。'})
note(L1, 'Settling without LPO',
     ('Settling without LPO for a process\'s runs: the count of changes is bounded, the step of the last change is not. '
      f'For a law\'s run a bounded mark of its changes decides it (LastChange.still_within, {RID}).',
      '过程之运行在没有有限全知原理时的安定：变化次数有界，最后变化之步不是；定律的运行由其变化的有界标记判定（LastChange.still_within）。'),
     {'en': 'A premise the core accepts under which settling is decided; ', 'zh': '核心接受的、使安定可判定的前提；'},
     {'en': 'A premise the core accepts under which settling of a process\'s runs, not only a law\'s, is decided; ',
      'zh': '核心接受的、使过程之运行（不只定律之运行）的安定可判定的前提；'},
     {'en': 'For a law\'s run, a quantity marking its changes and bounded along it decides settling with no omniscience.',
      'zh': '对定律的运行，标记其变化且沿之有界的量判定安定，无需全知。'},
     {'en': f'21 October 2026, RM3: LastChange gained still_of_fixed, still_succ and still_within, a law\'s run with a '
            f'bounded mark coming to rest within the bound, decided (record {RID}, study section {N}); what this record '
            f'does not show and its next delta now say that this premise is stated for a law\'s run. Its laws are unchanged.',
      'zh': f'2026年10月21日，RM3：LastChange 新增 still_of_fixed、still_succ 与 still_within，有有界标记的定律运行在界内静止，可判定'
            f'（记录 {RID}，研究第 {N} 节）；本记录所不表明者与其下一步现已说明此前提对定律的运行已陈述。其规律不变。'})

cov = json.loads((ROOT / COVERAGE).read_text())
row = next(r for r in cov['rows'] if r['id'] == 'degeneration')
assert RID not in row['records'] and RM2 in row['records']
row['records'].insert(row['records'].index(RM2) + 1, RID)
row['declarations'].insert(row['declarations'].index('Becoming.RegimeMargin.Adjusted.ends_iff_below') + 1,
                           'Becoming.RegimeMargin.Adjusted.comes_to_rest')
print('coverage row degeneration')
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
