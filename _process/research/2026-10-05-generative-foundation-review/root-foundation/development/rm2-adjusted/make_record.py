#!/usr/bin/env python3
"""Write RM2's record regime-point-under-adjusting-giving (a theorem), note it in margin-of-a-regime (whose laws on
ending and holding are now the regime's case of the adjusted laws, and whose removed lemmas are cited by their general
forms), and give the coverage file's degeneration row the record and its run law:
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION PREVIOUS_RECEIPT   (from the checkout root, after apply_text.py)

The laws cite exactly the declarations Becoming.RegimeMargin gained since the previous receipt. Every declaration
cited is resolved against the receipt's audited declarations (a short name must match exactly one declaration of the
named module), and the receipt must bind each cited module's current bytes."""
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
HEAD = f"## {N}. The regime's point over every adjustment of giving (RM2)"
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

RID = 'regime-point-under-adjusting-giving'
RM1 = 'margin-of-a-regime'
MOD = 'RegimeMargin'
AD = 'Adjusted.'
CR = 'Crossing.'

laws = [
    ('A condition whose giving adjusts has as its state its level x and its recent giving r; the draw H takes first, '
     'and the giving is a law A of what is left and of the recent giving: the next state is (x - H + A (x - H) r, '
     'A (x - H) r). The regime\'s step is the case A e r = g e, along every run its level the regime\'s run; the '
     'frozen rest is the case A e r = r, which lies between the recent and the regime\'s giving.',
     '所给调整的条件，其状态是水平 x 与近来所给 r；汲取 H 先取，所给是所剩与近来所给之律 A：下一状态为 (x - H + A (x - H) r, A (x - H) r)。'
     '体制之步是 A e r = g e 的情形，沿每一运行其水平即体制的运行；冻结之静是 A e r = r 的情形，介于近来所给与体制所给之间。',
     [AD + n for n in ['step', 'StaysShort', 'StaysMet', 'RestsAtDraw', 'FromNothing', 'Keeps', 'Between', 'Settles',
                       'orbit_regime', 'regime_staysShort', 'regime_staysMet', 'regime_fromNothing', 'regime_keeps',
                       'frozen_between']]),
    ('Where A rests at the draw exactly where the regime gives the draw, a state at or above the draw is left as it is '
     'exactly where its recent giving is the draw and the regime\'s step leaves its level, and its run stays where it '
     'started exactly where the regime\'s run from its level does; every giving between the recent and the regime\'s '
     'that moves wherever it differs from the regime\'s has that property.',
     'A 恰在体制给出汲取处静于汲取时，汲取及其上的状态恰在其近来所给为汲取且体制之步不动其水平时不动，其运行恰在体制自其水平的运行停留时停留于起点；'
     '介于近来所给与体制所给之间、凡与体制所给不同处皆移动的每个所给都有此性质。',
     [AD + n for n in ['rest_iff', 'rests_iff', 'frozen_rests', 'Between.restsAtDraw', 'Between.rests_iff']]),
    ('Below the point of no return, with the recent giving short of the draw and A short of it where the recent and '
     'the regime\'s giving are, a positive level falls at every step and is nothing after as many steps as it stood '
     'where A gives nothing from nothing, and stays nothing; whatever A gives from nothing, with y positive, the level '
     'is at most the draw from x - H steps on.',
     '在不可回返点之下，近来所给不足汲取、且近来所给与体制所给皆不足处 A 亦不足时，正的水平每步下降，在 A 无中不生有时于其所立的步数之后为无并保持为无；'
     '无论 A 自无给出什么，y 为正时，自 x - H 步起水平至多为汲取。',
     [AD + n for n in ['draw_pos', 'left_falls', 'left_below', 'step_below', 'from_zero', 'orbit_bound', 'ends_below',
                       'stays_ended', 'left_bound', 'taken_whole']]),
    ('At or above the point, with the recent giving meeting the draw and A meeting it where the recent and the '
     'regime\'s giving do, the level never falls below its start; the point is exact on the state: where the recent '
     'giving falls short of the draw exactly where the level is below H + y, the condition ends exactly from below '
     'it, for every giving between the recent and the regime\'s too.',
     '在此点及其上，近来所给满足汲取、且两者皆满足处 A 亦满足时，水平永不低于其起点；此点在状态上是确切的：近来所给恰在水平低于 H + y 时不足汲取者，'
     '条件恰在起点低于它时终结，对介于两者之间的每个所给亦然。',
     [AD + n for n in ['step_holds', 'holds', 'holds_from', 'ends_iff_below', 'Between.staysShort',
                       'Between.staysMet', 'Between.ends_iff_below']]),
    ('Witnesses: giving gated at two under a draw of three, the point five. Moving one unit a step toward the '
     'regime\'s giving, from four with recent giving six the level is at least seven from the second step on, and '
     'from five with recent giving nothing it is nothing, where the regime\'s step ends four and holds five; the '
     'frozen rest\'s run stays at four with recent giving three.',
     '见证：门限于二的所给、汲取三，此点为五。每步向体制所给移动一单位时，自四、近来所给六，第二步起水平至少为七；自五、近来所给为无，则为无；'
     '而体制之步终结四、维持五；冻结之静自四、近来所给三的运行停留于四。',
     [CR + n for n in ['giving', 'toward', 'fromNothing', 'root', 'meets_from', 'toward_between', 'toward_settles',
                       'crosses', 'frozen_stays']]),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
old_names = {d['name'] for d in next(m for m in P['modules'] if m['module'] == f'Becoming.{MOD}')['declarations']}
full = decls(MOD)
# The regime forms of lemmas no law reads any more: their general forms in Adjusted replace them (rule 9).
REMOVED = {f'Becoming.{MOD}.{old}': f'Becoming.{MOD}.Adjusted.{general}' for old, general in [
    ('step_zero', 'from_zero'), ('step_of_lt', 'step_below'), ('step_falls', 'step_below'),
    ('step_below', 'step_below'), ('orbit_bound', 'orbit_bound'), ('orbit_from_zero', 'from_zero'),
    ('step_holds', 'step_holds')]}
assert old_names - set(full) == set(REMOVED), (old_names - set(full)) ^ set(REMOVED)
assert set(REMOVED.values()) <= set(full)
new = sorted(d for d in full if d not in old_names)
cited = sorted(d for _, _, names in laws for d in resolve(MOD, names))
assert cited == new, (set(new) - set(cited), set(cited) - set(new))
EARLIER = [f'Becoming.{MOD}.{n}' for n in ['step', 'Short', 'Meets', 'Keeps', 'FromNothing', 'Root', 'ends_below',
                                           'stays_ended', 'holds', 'ends_iff_below']]
assert set(EARLIER) <= old_names & set(full), set(EARLIER) - (old_names & set(full))
USED = {'Recurrence': ['Becoming.Law.orbit', 'Becoming.Law.orbit_add', 'Becoming.Law.orbit_mul']}
refs_used = []
for mod, names in USED.items():
    have = set(decls(mod))
    assert set(names) <= have, (mod, set(names) - have)
    refs_used.append((mod, sorted(names)))
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'The regime\'s point under giving that adjusts', 'zh': '所给调整下的体制之点'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Where giving adjusts, reading what is left and the recent giving, every rest of the state at or above '
              'the draw is the regime\'s if the adjustment rests at the draw where the regime gives it; the point '
              'decides the fate where recent giving lies on the level\'s side.',
        'zh': '所给调整、读所剩与近来所给时，若调整在体制给出汲取处静于汲取，汲取及其上的每个静止状态都是体制的；近来所给在水平一侧时，此点决定命运。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(MOD, names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': 'No axiom. Whole-number amounts and discrete steps; one condition; the draw taken first, as much as there '
               'is; the state the level and one recent giving, with no further hidden state; RM1\'s premises on the '
               'regime\'s giving (Short, Meets, Keeps) and each law\'s own premises on the adjustment (RestsAtDraw, '
               'StaysShort, StaysMet, FromNothing, Keeps, Between, Settles) as hypotheses.',
         'zh': '不加公理。整数量与离散步；一个条件；汲取先取，有多少取多少；状态是水平与一个近来所给，无其他隐藏状态；RM1 关于体制所给的前提'
               '（Short、Meets、Keeps）与各律关于调整的前提（RestsAtDraw、StaysShort、StaysMet、FromNothing、Keeps、Between、Settles）为假设。'}],
    'does_not_show': [
        {'en': 'That a run comes to rest, or how fast: the laws say where a run can rest and which fates the state '
               'decides, not that the state converges.',
         'zh': '运行会静止，或多快静止：这些规律说运行能在何处静止、状态决定哪些命运，不说状态收敛。', 'kind': 'scope'},
        {'en': 'The threshold in the plane of level and recent giving where recent giving lies on the other side of the '
               'draw; a state with a further lag; coupled conditions.',
         'zh': '近来所给在汲取另一侧时，水平与近来所给之平面上的阈值；带再一个滞后的状态；相互耦合的条件。', 'kind': 'scope'},
        {'en': 'That MQ3\'s failed check F3 is explained: the reading that the point separates fates on the state, not '
               'the level alone, is post hoc and untested.',
         'zh': 'MQ3 未通过的检验 F3 已被解释：此点按状态而非单按水平区分命运这一读法是事后的，未经检验。', 'kind': 'non-implication'}],
    'counterexamples': [
        {'path': src(MOD), 'detail': {
            'en': 'Crossing.frozen_stays: the frozen rest lies between the recent and the regime\'s giving, yet its run '
                  'from four with recent giving three stays at four, where the regime\'s step ends the condition; '
                  'Crossing.crosses: with recent giving on the other side, five, the point, ends and four, below it, holds.',
            'zh': 'Crossing.frozen_stays：冻结之静介于近来所给与体制所给之间，但其自四、近来所给三的运行停留于四，而体制之步终结此条件；'
                  'Crossing.crosses：近来所给在另一侧时，五（此点）终结，四（其下）维持。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {len(new)} declarations '
              f'Becoming.RegimeMargin gained have empty axiom reports; the checker verifies core purity. Built and '
              f'reviewed in one session, with no separate reviewer; author review in study section {N}; not '
              'independently reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.RegimeMargin 新增的 {len(new)} 项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'Whether and how fast a run comes to rest; the threshold curve in the plane of level and recent giving; a '
              'state with a further lag; a frozen test, on stocks no analysis has read, of whether below-point episodes '
              'with recent giving short of the catch fall more often than those with it met; an independent review.',
        'zh': '运行是否与多快静止；水平与近来所给之平面上的阈值曲线；带再一个滞后的状态；在未经任何分析读过的存量上冻结检验：近来所给不足捕捞的点下片段'
              '是否比满足者更常下降；独立审查。'},
    'correspondence': {
        'en': 'Partial adjustment, a quantity moving at a rate toward its target, rests where the target does (Nerlove '
              '1958); delay-difference models share the equilibria of their yield curve (Deriso 1980; Schnute 1985); '
              'with a second state variable a threshold is a curve that transients cross (Hastings 2004). On the spine, '
              'exact over every adjustment with named properties: the rest law needs that the adjustment rests at the '
              'draw where the regime does, the fates that giving stays on the side of the draw where the recent and the '
              'regime\'s giving lie, each shown needed by a witness. MQ5\'s law, under a standing draw met in full, is '
              'A e r = (phi - lam) r + (1 - phi) g e + lam H, phi = 0.96, lam = 0.55: over the reals it rests at the '
              'draw where the regime does and keeps both sides, but is not between; a correspondence by premises.',
        'zh': '部分调整（一个量按速率向其目标移动）静于目标所静之处（Nerlove 1958）；延迟差分模型与其产量曲线共有平衡（Deriso 1980；Schnute 1985）；'
              '有第二个状态变量时，阈值是瞬态可越过的曲线（Hastings 2004）。在脊柱上，对具名性质的每个调整都精确：静止之律需调整在体制给出汲取处静于汲取，'
              '命运之律需所给保持在近来所给与体制所给所在的汲取一侧，各由见证表明不可少。MQ5 之律在全额满足的常设汲取下为 '
              'A e r = (phi - lam) r + (1 - phi) g e + lam H（phi = 0.96，lam = 0.55）：在实数上它在体制处静于汲取并保持两侧，但不在两者之间；'
              '这是按前提的对应。'},
    'canonical_source': src(MOD),
    'aliases': ['the regime\'s point under giving that adjusts', 'giving that adjusts', 'rests of an adjusting giving',
                '所给调整下的体制之点', 'Becoming.RegimeMargin.Adjusted.rests_iff',
                'Becoming.RegimeMargin.Adjusted.ends_iff_below', 'Becoming.RegimeMargin.Crossing.crosses'],
    'dependencies': [{
        'id': RM1, 'relation': 'formal-reuse',
        'detail': {'en': 'RM1\'s laws on ending and holding restated over every adjustment of giving; they are now the '
                         'regime\'s case, and RM1\'s premises on the regime\'s giving are reused.',
                   'zh': 'RM1 关于终结与维持的规律对每个所给调整重述；它们现为体制的情形，RM1 关于体制所给的前提被沿用。'},
        'interface': {
            'output': {'en': 'The regime\'s step, Short, Meets, Keeps and Root, and the point of no return H + y.',
                       'zh': '体制之步、Short、Meets、Keeps 与 Root，以及不可回返点 H + y。'},
            'input': {'en': 'The same point on the state of level and recent giving, under any adjustment.',
                      'zh': '同一点在水平与近来所给的状态上，在任何调整下。'},
            'conditions': {'en': 'Whole-number amounts; the draw taken first.', 'zh': '整数量；汲取先取。'},
            'evidence': src(MOD)}}],
    'related': [
        {'id': RM1, 'detail': {'en': 'With giving read off the level alone, the point of no return is exact on the level; '
                                     'with giving that adjusts, it is exact on the state where recent giving lies on the '
                                     'level\'s side, and every rest at or above the draw is the regime\'s.',
                               'zh': '所给只读自水平时，不可回返点在水平上是确切的；所给调整时，近来所给在水平一侧处它在状态上是确切的，'
                                     '汲取及其上的每个静止都是体制的。'}}],
    'references': [{'path': src(MOD), 'role': 'proof', 'declarations': sorted(new + EARLIER), 'sha256': sha(src(MOD))}]
                  + [{'path': src(mod), 'role': 'proof', 'declarations': names, 'sha256': sha(src(mod))}
                     for mod, names in refs_used]
                  + [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                     {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                     {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                     {'path': README, 'role': 'integration', 'sha256': sha(README)},
                     {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
    'proof_bindings': [{'source': src(mod), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{mod}',
                        'success_pointer': '/status', 'success_value': 'passed'}
                       for mod in [MOD] + [m for m, _ in refs_used]],
    'history': [{
        'en': f'21 October 2026: added (RM2), the regime\'s point over every adjustment of giving: RM1\'s laws on ending '
              f'and holding hold over any law of what is left and of the recent giving, the regime\'s step the case; '
              f'every rest at or above the draw is the regime\'s where the adjustment rests at the draw where the '
              f'regime gives it; study section {N}.',
        'zh': f'2026年10月21日：新增（RM2），每个所给调整下的体制之点：RM1 关于终结与维持的规律对所剩与近来所给之任一律成立，体制之步是其情形；'
              f'调整在体制给出汲取处静于汲取时，汲取及其上的每个静止都是体制的；研究第 {N} 节。'}],
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
print('written', RID, len(new), 'declarations')

# RM1's record: a note; its laws on ending and holding keep their statements, now the regime's case, and the removed
# regime forms are cited by their general forms.


def remap(names):
    out = []
    for n in names:
        n = REMOVED.get(n, n)
        if n not in out:
            out.append(n)
    return out


p = RECORDS / f'{RM1}.json'
d = json.loads(p.read_text())
moved = 0
for law in d['laws']:
    moved += sum(n in REMOVED for n in law['declarations'])
    law['declarations'] = remap(law['declarations'])
for ref in d['references']:
    if 'declarations' in ref:
        ref['declarations'] = remap(ref['declarations'])
d['aliases'] = remap(d.get('aliases', []))
text = json.dumps(d, ensure_ascii=False)
left = [n for n in REMOVED if re.search(re.escape(n) + r'(?![\w.])', text)
        and REMOVED[n] != n]
assert not left, left
d['related'] = d.get('related', []) + [{'id': RID, 'detail': {
    'en': 'Giving that adjusts: these laws on ending and holding hold over any law of what is left and of the recent '
          'giving, and every rest at or above the draw is the regime\'s where the adjustment rests where the regime does.',
    'zh': '所给调整：这些关于终结与维持的规律对所剩与近来所给之任一律成立；调整在体制处静于汲取时，汲取及其上的每个静止都是体制的。'}}]
d['history'].append({
    'en': f'21 October 2026, RM2: this record\'s laws on ending and holding hold over every adjustment of giving '
          f'(RegimeMargin.Adjusted; record {RID}, study section {N}), the regime\'s step the case. They keep their '
          f'statements, each proof now one line; the regime forms of lemmas no law reads any more were removed, and '
          f'this record cites their general forms ({moved} law citations moved, the proof references with them).',
    'zh': f'2026年10月21日，RM2：本记录关于终结与维持的规律对每个所给调整成立（RegimeMargin.Adjusted；记录 {RID}，研究第 {N} 节），'
          f'体制之步是其情形。陈述不变，每个证明现为一行；不再被任何规律读取的体制形式已移除，本记录改引其一般形式（规律中移动 {moved} 处引用，证明引用随之）。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('noted', RM1, moved)

cov = json.loads((ROOT / COVERAGE).read_text())
row = next(r for r in cov['rows'] if r['id'] == 'degeneration')
assert RID not in row['records'] and RM1 in row['records']
row['records'].insert(row['records'].index(RM1) + 1, RID)
row['declarations'].insert(row['declarations'].index('Becoming.RegimeMargin.ends_iff_below') + 1,
                           'Becoming.RegimeMargin.Adjusted.ends_iff_below')
print('coverage row degeneration')
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
