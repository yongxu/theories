#!/usr/bin/env python3
"""Write RM7's record coupled-webs (a theorem), note it in coupled-regimes (whose pair laws are now read off the web's) and
in the regime records that left more than two coupled conditions open (margin-of-a-regime,
where-a-run-of-a-regime-comes-to-rest, threshold-in-the-state-plane, regime-in-any-amounts), and give the coverage
file's degeneration row the record and its cascade law:
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION PREVIOUS_RECEIPT   (from the checkout root, after apply_text.py)

The laws cite exactly the declarations Becoming.RegimeMargin gained since the previous receipt. Every declaration cited
is resolved against the receipt's audited declarations, and the receipt must bind each cited module's current bytes."""
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
HEAD = f"## {N}. Coupled webs: support across a web, and the cascade of ends (RM7)"
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

RID = 'coupled-webs'
RM6 = 'coupled-regimes'
RM1 = 'margin-of-a-regime'
RM3 = 'where-a-run-of-a-regime-comes-to-rest'
RM4 = 'threshold-in-the-state-plane'
RM5 = 'regime-in-any-amounts'
RM = 'RegimeMargin'
I = 'Coupled.Indexed.'
C = 'Coupled.'

laws = [
    ('Any number of conditions, indexed by any type, each under its draw taken first, as much as there is, and giving a '
     'law of what is left of all, in any amounts with a draw; a level ends where it is nothing from some step on.',
     '任意多个条件，以任意类型为指标，各在其先取（有多少取多少）的汲取之下，各所给是所有所余之律，在任何带汲取的量中；一个水平自某步起为无即终结。',
     [(RM, [I + n for n in ['left', 'step', 'Below', 'Rises', 'Ends']])]),
    ('Under mutual support, every giving rising with what is left of each, the step keeps the order of states condition '
     'by condition, along runs too, so a level ending from a state ends from every state below it: raising any '
     'condition\'s level never ends one that held.',
     '相互支持下（各所给随每个所余而升），步逐个条件保持状态之序，沿运行亦然，故自一状态终结的水平自其下每个状态终结：升高任一条件的水平从不使一个维持者终结。',
     [(RM, [I + n for n in ['step_mono', 'run_below', 'ends_of_below']])]),
    ('Where i gives nothing wherever nothing is left of j, i drains once j stays within its draw; in whole numbers it falls '
     'by its draw at every step and, the draw positive, is nothing within as many steps as its level, so j\'s end ends i.',
     'i 在 j 一无所余处给无时，只要 j 留在其汲取之内，i 即流尽；在整数中它每步按汲取下降，汲取为正时至多经其水平之步数即为无，故 j 的终结终结 i。',
     [(RM, [I + n for n in ['DependsOn', 'drains', 'ends_after', 'ends_of_partner']])]),
    ('Along every chain of dependence, where every dependent\'s draw is positive, wherever a condition ends every '
     'condition downstream of it ends, and two conditions each downstream of the other end together or not at all.',
     '沿每条依赖之链，每个依赖者的汲取为正时，一个条件在何处终结，其下游的每个条件即终结；彼此互为下游的两个条件同终或皆不终。',
     [(RM, [I + n for n in ['Downstream', 'ends_downstream', 'ends_together']])]),
    ('The pair is the web indexed by Bool: at every step the web\'s run has the pair\'s levels, a pair\'s level ends exactly '
     'where the web\'s does, and the pair\'s mutual support is the web\'s; the pair\'s laws of order, ending and dependence '
     'are read off these.',
     '一对即以 Bool 为指标的网：每步网的运行具有一对的水平，一对的水平恰在网的水平终结处终结，一对的相互支持即网的；一对的序、终结与依赖之律由此读出。',
     [(RM, [C + n for n in ['pairGiving', 'pairDraw', 'ofPair', 'pair_run', 'ends_pair', 'pair_rises']])]),
    ('Witness, a chain: three conditions, the second giving one where at least one is left of the first, the third where '
     'at least one is left of the second, under draws of one; the third does not depend on the first, yet the first ends '
     'and so does the third. With no draw on the second, the third holds at two for ever.',
     '见证，一条链：三个条件，第二个在第一个所余至少为一处给一，第三个在第二个所余至少为一处给一，汲取为一；第三个不依赖第一个，但第一个终结，第三个亦终结。第二个无汲取时，第三个永远维持于二。',
     [(RM, [I + 'Chain.' + n for n in ['giving', 'start', 'first_falls', 'cascades', 'stopped']])]),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
new_by = {}
for mod in [RM]:
    old_names = {d['name'] for d in next(m for m in P['modules'] if m['module'] == f'Becoming.{mod}')['declarations']}
    full = decls(mod)
    assert old_names <= set(full), old_names - set(full)
    new = sorted(d for d in full if d not in old_names)
    cited = sorted(d for _, _, groups in laws for m, names in groups if m == mod for d in resolve(mod, names))
    assert cited == new, (mod, set(new) - set(cited), set(cited) - set(new))
    new_by[mod] = new
EARLIER = {RM: ['Becoming.RegimeMargin.Drawn', 'Becoming.RegimeMargin.Drawn.sub_mono', 'Becoming.RegimeMargin.Drawn.whole',
                'Becoming.RegimeMargin.Drawn.Rises', 'Becoming.RegimeMargin.Coupled.step', 'Becoming.RegimeMargin.Coupled.Ends',
                'Becoming.RegimeMargin.Coupled.step_mono', 'Becoming.RegimeMargin.Coupled.ends_of_below',
                'Becoming.RegimeMargin.Coupled.drains', 'Becoming.RegimeMargin.Coupled.ends_after',
                'Becoming.RegimeMargin.Coupled.ends_of_partner', 'Becoming.RegimeMargin.Coupled.ends_together']}
for mod, names in EARLIER.items():
    assert set(names) <= set(decls(mod)), set(names) - set(decls(mod))
USED = {'Recurrence': ['Becoming.Law.orbit', 'Becoming.Law.run'],
        'Lasting': ['Becoming.Lasting.orbit_mono'],
        'Amounts': ['Becoming.Amounts.add_le_add_left', 'Becoming.Amounts.add_zero', 'Becoming.Amounts.le_of_eq'],
        'Prelude': ['Becoming.sub_eq_zero_of_le', 'Becoming.Naturals.sub_sub']}
refs_used = []
for mod, names in USED.items():
    have = set(decls(mod))
    assert set(names) <= have, (mod, set(names) - have)
    refs_used.append((mod, sorted(names)))
n_new = sum(len(v) for v in new_by.values())
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Coupled webs: support across a web, and the cascade of ends', 'zh': '耦合之网：网中的支持与终结的级联'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Any number of conditions each giving from what is left of all: under mutual support raising any level never '
              'ends one that held; along every chain of total dependence, with positive draws, the end of one ends '
              'everything downstream, a dependence cycle ending together.',
        'zh': '任意多个条件各从所有所余中给出：相互支持下升高任一水平从不使一个维持者终结；沿每条完全依赖之链，汲取为正时，一个的终结终结其下游的一切，依赖之环同终。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': [d for m, names in groups for d in resolve(m, names)]}
             for en, zh, groups in laws],
    'hypotheses': [
        {'en': 'No axiom. Discrete steps; conditions indexed by any type; each draw taken first, as much as there is; each '
               'giving a law of what is left of all; amounts linearly ordered with a truncated difference, whole numbers '
               'for the drain\'s count and the cascade; each law\'s own premises as hypotheses: mutual support, total '
               'dependence (nothing given wherever nothing is left of the other), positive draws on dependents.',
         'zh': '不加公理。离散步；以任意类型为指标的条件；各汲取先取，有多少取多少；各所给是所有所余之律；量线性有序且有截断差，流尽之计数与级联需整数；各律自身的前提为假设：'
               '相互支持、完全依赖（他者一无所余处给无）、依赖者的汲取为正。'}],
    'does_not_show': [
        {'en': 'Rest and thresholds of webs: a web\'s state is a function of the conditions, and a still run would need '
               'equality of functions, an extensionality the pure core does not assume; the pair\'s are stated.',
         'zh': '网的静止与阈值：网的状态是条件的函数，静止的运行需要函数相等，纯核心不假设这种外延性；一对的已陈述。', 'kind': 'scope'},
        {'en': 'Partial dependence, where giving falls without stopping; the time of a cascade along a chain beyond each '
               'link\'s; webs with a recent giving; the reals and continuous time.',
         'zh': '部分依赖（所给下降而不停止）；链上级联的时间（逐环之外）；带近来所给的网；实数与连续时间。', 'kind': 'scope'},
        {'en': 'That measured webs have total dependence or positive draws on their chains: the cascade is proved under '
               'these premises; how far it reaches in a field web is untested.',
         'zh': '所测的网在其链上有完全依赖或为正的汲取：级联在这些前提下已证；在野外之网中它及于多远未经检验。', 'kind': 'non-implication'}],
    'counterexamples': [
        {'path': src(RM), 'detail': {
            'en': 'Coupled.Indexed.Chain.stopped: with no draw on the middle of a chain the first still ends, yet the '
                  'third, downstream of it, holds at two for ever: positive draws on dependents cannot be dropped.',
            'zh': 'Coupled.Indexed.Chain.stopped：链中间无汲取时第一个仍终结，但其下游的第三个永远维持于二：依赖者的汲取为正不可去掉。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {n_new} declarations '
              f'Becoming.RegimeMargin gained have empty axiom reports; the checker verifies core purity. Built and reviewed '
              f'in one session, with no separate reviewer; author review in study section {N}; not independently '
              f'reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.RegimeMargin 新增的 {n_new} 项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'Rest and thresholds of webs (stated on finitely many conditions read as a list); partial dependence with a '
              'rate; the time of a cascade along a chain; webs with a recent giving; a field web whose dependences are '
              'measured; an independent review.',
        'zh': '网的静止与阈值（以列表读出的有限多个条件上陈述）；带比率的部分依赖；链上级联的时间；带近来所给的网；依赖经测量的野外之网；独立审查。'},
    'correspondence': {
        'en': 'Cooperative (monotone) systems keep the order of states in any dimension, and their extinction sets are '
              'down-closed (Smith 1995; Hirsch and Smith 2005); secondary extinctions cascade through food webs, their '
              'reach set by the web\'s structure (Pimm 1980; Dunne, Williams and Martinez 2002); coextinction of '
              'dependents (Koh et al. 2004). On the spine, constructive and exact in its premises: the cascade along any '
              'chain of total dependence follows from one link\'s law, each link\'s steps counted, a dependence cycle ends '
              'together, and positive draws on dependents are shown needed by a witness; the pair is the web\'s case.',
        'zh': '合作（单调）系统在任意维数上保持状态之序，其灭绝集向下封闭（Smith 1995；Hirsch 与 Smith 2005）；次级灭绝经食物网级联，其所及由网的结构决定（Pimm 1980；'
              'Dunne、Williams 与 Martinez 2002）；依赖者的共灭绝（Koh 等 2004）。在脊柱上，构造性且在其前提上精确：沿任何完全依赖之链的级联由单环之律推出，'
              '每环步数可计，依赖之环同终，依赖者的汲取为正由见证表明不可少；一对是网的情形。'},
    'canonical_source': src(RM),
    'aliases': ['coupled webs', 'the cascade of ends', 'coextinction along a chain of dependence', '耦合之网',
                'Becoming.RegimeMargin.Coupled.Indexed.ends_downstream', 'Becoming.RegimeMargin.Coupled.Indexed.step_mono'],
    'dependencies': [
        {'id': RM6, 'relation': 'formal-reuse',
         'detail': {'en': 'The pair\'s step and its laws of order, ending and dependence are this record\'s case: the pair is '
                          'the web indexed by Bool, and its laws are now read off the web\'s.',
                    'zh': '一对的步及其序、终结与依赖之律是本记录的情形：一对即以 Bool 为指标的网，其律现由网的律读出。'},
         'interface': {
             'output': {'en': 'Coupled.step, Coupled.Ends.', 'zh': 'Coupled.step、Coupled.Ends。'},
             'input': {'en': 'Coupled.pair_run and ends_pair: RM6\'s laws re-derived from the web\'s.',
                       'zh': 'Coupled.pair_run 与 ends_pair：由网的律重新推出 RM6 之律。'},
             'conditions': {'en': 'Two conditions.', 'zh': '两个条件。'},
             'evidence': src(RM)}},
        {'id': RM5, 'relation': 'formal-reuse',
         'detail': {'en': 'Amounts with a draw, rising giving and sub_mono are reused; the web is stated in them.',
                    'zh': '沿用带汲取的量、上升的所给与 sub_mono；网在其中陈述。'},
         'interface': {
             'output': {'en': 'Drawn, Drawn.Rises, Drawn.sub_mono and Drawn.whole.',
                        'zh': 'Drawn、Drawn.Rises、Drawn.sub_mono 与 Drawn.whole。'},
             'input': {'en': 'The web\'s step and its order under mutual support in any amounts with a draw.',
                       'zh': '任何带汲取的量中网的步及其在相互支持下之序。'},
             'conditions': {'en': 'Linearly ordered amounts with a truncated difference.', 'zh': '带截断差的线性有序量。'},
             'evidence': src(RM)}}],
    'related': [{'id': 'groups-whose-conditions-are-coupled', 'detail': {
        'en': 'That record reads a family of coupled conditions as one and ends it by joint excess; here each condition of a '
              'web keeps its own giving law of what is left of all, and the end of one reaches what depends on it, link by link.',
        'zh': '该记录把一族耦合条件读作一个，以联合超出终结之；此处网的每个条件各保有以所有所余为变元的所给之律，一个的终结逐环及于依赖它者。'}}],
    'references': [{'path': src(RM), 'role': 'proof', 'declarations': sorted(new_by[RM] + EARLIER[RM]), 'sha256': sha(src(RM))}]
                  + [{'path': src(mod), 'role': 'proof', 'declarations': names, 'sha256': sha(src(mod))}
                     for mod, names in refs_used]
                  + [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                     {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                     {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                     {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
    'proof_bindings': [{'source': src(mod), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{mod}',
                        'success_pointer': '/status', 'success_value': 'passed'}
                       for mod in [RM] + [m for m, _ in refs_used]],
    'history': [{
        'en': f'21 October 2026: added (RM7), coupled webs: any number of conditions each giving from what is left of all; '
              f'under mutual support the order of states is kept and ending is down-closed; along every chain of total '
              f'dependence, with positive draws, the end of one ends everything downstream, a dependence cycle ending '
              f'together; the pair is the web\'s case and RM6\'s laws are read off the web\'s; study section {N}.',
        'zh': f'2026年10月21日：新增（RM7），耦合之网：任意多个条件各从所有所余中给出；相互支持下状态之序得保持，终结向下封闭；沿每条完全依赖之链，汲取为正时，一个的终结终结其下游的一切，'
              f'依赖之环同终；一对是网的情形，RM6 之律由网的律读出；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, (len(rec['statement']['en']), len(rec['statement']['zh']))
assert len(rec['correspondence']['en']) <= 1200 and len(rec['correspondence']['zh']) <= 500
for h in rec['hypotheses']:
    assert len(h['en']) <= 420, len(h['en'])
for h in rec['does_not_show']:
    assert len(h['en']) <= 240, len(h['en'])
assert len(rec['validation_scope']['zh']) <= 260, len(rec['validation_scope']['zh'])
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID, n_new, 'declarations')

notes = {
    RM6: dict(dns=[('More than two conditions, a web of them; coupled conditions with a recent giving',
                    'Coupled conditions with a recent giving'), ('多于两个条件或其网；带近来所给的耦合条件', '带近来所给的耦合条件')],
              nd=[('more than two conditions, a web; ', 'rest and thresholds of webs; '), ('多于两个条件、其网；', '网的静止与阈值；')]),
    RM1: dict(dns=[], nd=[('webs of conditions; ', ''), ('条件之网；', '')]),
    RM3: dict(dns=[], nd=[('coupled conditions with a recent giving, or more than two; ', 'coupled conditions with a recent giving; '),
                          ('带近来所给或多于两个的相互耦合条件；', '带近来所给的相互耦合条件；')]),
    RM4: dict(dns=[], nd=[('coupled conditions with a recent giving, or more than two; ', 'coupled conditions with a recent giving; '),
                          ('带近来所给或多于两个的相互耦合条件；', '带近来所给的相互耦合条件；')]),
    RM5: dict(dns=[], nd=[('coupled conditions with a recent giving, or more than two; ', 'coupled conditions with a recent giving; '),
                          ('带近来所给或多于两个的相互耦合条件；', '带近来所给的相互耦合条件；')]),
}
for rid, how in notes.items():
    p = RECORDS / f'{rid}.json'
    d = json.loads(p.read_text())
    for old, new in how['dns']:
        lang = 'zh' if re.search('[一-鿿]', old) else 'en'
        hits = [x for x in d['does_not_show'] if old in x[lang]]
        assert len(hits) == 1, (rid, old)
        hits[0][lang] = hits[0][lang].replace(old, new)
        if lang == 'en':
            hits[0][lang] = hits[0][lang].rstrip('.') + f'; record {RID} states webs of any number.'
            assert len(hits[0]['en']) <= 240, (rid, len(hits[0]['en']))
        else:
            hits[0][lang] = hits[0][lang].rstrip('。') + f'；记录 {RID} 陈述任意多个之网。'
    for old, new in how['nd']:
        lang = 'zh' if re.search('[一-鿿]', old) else 'en'
        assert d['next_delta'][lang].count(old) == 1, (rid, lang, old)
        d['next_delta'][lang] = d['next_delta'][lang].replace(old, new)
    if rid == RM6:
        assert all(r['id'] != RID for r in d.get('related', []))
        d['related'] = d.get('related', []) + [{'id': RID, 'detail': {
            'en': 'The pair is the web indexed by Bool: its laws of order, ending, draining, ending after and ending together '
                  'are read off the web\'s, whose cascade along chains of dependence the pair cannot show.',
            'zh': '一对即以 Bool 为指标的网：其序、终结、流尽、在后终结与同终之律由网的律读出，网沿依赖之链的级联是一对所不能显示的。'}}]
        note_en = (f'21 October 2026, RM7: more than two coupled conditions are stated as a web (record {RID}, study section '
                   f'{N}); this record\'s laws of order, ending, draining, ending after and ending together keep their '
                   f'statements and are now proved from the web\'s; what it does not show and its next delta say so.')
        note_zh = (f'2026年10月21日，RM7：多于两个的耦合条件已作为网陈述（记录 {RID}，研究第 {N} 节）；本记录的序、终结、流尽、在后终结与同终之律陈述不变，'
                   f'现由网的律证明；本记录所不表明者与其下一步已如此说明。')
    else:
        note_en = (f'21 October 2026, RM7: more than two coupled conditions are stated as a web under the regime\'s step '
                   f'(record {RID}, study section {N}); its next delta no longer lists them. Its laws are unchanged.')
        note_zh = (f'2026年10月21日，RM7：多于两个的耦合条件已作为体制之步下的网陈述（记录 {RID}，研究第 {N} 节）；其下一步不再列出。其规律不变。')
    d['history'].append({'en': note_en, 'zh': note_zh})
    p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('noted', rid)

cov = json.loads((ROOT / COVERAGE).read_text())
row = next(r for r in cov['rows'] if r['id'] == 'degeneration')
assert RID not in row['records'] and RM6 in row['records']
row['records'].insert(row['records'].index(RM6) + 1, RID)
row['declarations'].insert(row['declarations'].index('Becoming.RegimeMargin.Coupled.threshold_falls') + 1,
                           'Becoming.RegimeMargin.Coupled.Indexed.ends_downstream')
print('coverage row degeneration')
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
