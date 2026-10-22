#!/usr/bin/env python3
"""Write CA1's record, note it in the records it continues (groups-formed-by-descent,
groups-whose-conditions-are-coupled), and give the coverage file's evolution row its record:
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION   (from the checkout root, after apply_text.py)

Every declaration cited is resolved against the receipt's audited declarations of Becoming.Founding (a short name must
match exactly one declaration), and the receipt must bind the module's current bytes."""
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
EVO = 'theories/becoming/chapters/THE-THEORY-OF-EVOLUTION.md'
OPENING = 'theories/becoming/OPENING.md'
COVERAGE = 'theories/becoming/results/completion/COVERAGE.json'
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
HEAD = f'## {N}. What cancer is, and what keeps a part from turning back (CA1)'
assert re.search('^' + re.escape(HEAD) + '$', (ROOT / STUDY).read_text(), re.M)


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def src(mod):
    return f'{PKG}/Becoming/{mod}.lean'


def decls(mod):
    m = next(m for m in core['modules'] if m['module'] == f'Becoming.{mod}')
    assert core['source_sha256'][f'Becoming.{mod}'] == sha(src(mod)), ('receipt does not bind', mod)
    assert not any(m['axiom_dependencies'].values())
    return m


def resolve(names):
    full = [d['name'] for d in decls('Founding')['declarations']]
    out = []
    for n in names:
        hits = [f for f in full if f == 'Becoming.Founding.' + n] or [f for f in full if f.endswith('.' + n)]
        assert len(hits) == 1, (n, hits)
        out.append(hits[0])
    return out


BOUNDS = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
          'omission-not-refutation']


def dep(rid, relation, en, zh, out_en, out_zh, in_en, in_zh, cond_en, cond_zh, evidence):
    return {'id': rid, 'relation': relation, 'detail': {'en': en, 'zh': zh},
            'interface': {'output': {'en': out_en, 'zh': out_zh}, 'input': {'en': in_en, 'zh': in_zh},
                          'conditions': {'en': cond_en, 'zh': cond_zh}, 'evidence': evidence}}


RID = 'confined-rise-within-a-whole'
GFD = 'groups-formed-by-descent'
CPL = 'groups-whose-conditions-are-coupled'
STG = 'selection-term-over-generations'
WHL = 'whole-persists-through-generation'
USED = {'GroupEnding': ['Becoming.GroupEnding.Flow.family_childless'],
        'SelectionLevels': ['Becoming.SelectionLevels.lineage', 'Becoming.SelectionLevels.lineage_within',
                            'Becoming.SelectionLevels.total_eq_of_mem'],
        'SelectionTerm': ['Becoming.SelectionTerm.Exact', 'Becoming.SelectionTerm.Generations.family',
                          'Becoming.SelectionTerm.Generations.raises_exact_iff',
                          'Becoming.SelectionTerm.Flow.Descended', 'Becoming.SelectionTerm.concord_alike',
                          'Becoming.SelectionTerm.discord_alike'],
        'Reproduction': ['Becoming.Reproduction.le_of_excess_zero'],
        'Continuation': ['Becoming.Flow.family_excess_ends']}
laws = [
    ('Where a family of conditions ran into excess under the coupled gate, every member of a later generation of '
     'descent is the offspring of a member that depended on no condition of the family at the gate\'s need, and a '
     'lineage every later member of which depends on the family has no member after its end.',
     '一族条件在耦合门控下遭遇过度后，此后各代的每个成员都是某个在门控之需上不依存于该族之成员的后代；此后每个成员都依存于该族的世系在其终结后不再有成员。',
     ['Flow.survivors_independent', 'Flow.confined_ends', 'nil_of_none']),
    ('A rise: a lineage marked by an amount that selection within goes for before the end, taking from the family '
     'during its excess, the family\'s renewal gated and in excess. Confined (every later member depending on the '
     'family), it has no member after the end, whatever selection within had raised it to.',
     '上升：由组内选择在终结前所偏向之量标记、在该族过度期间汲取它、该族更新受门控且过度的世系。若局限（此后每个成员都依存于该族），无论组内选择曾把它抬到多高，终结后它不再有成员。',
     ['Flow.Rise', 'Flow.ConfinedRise', 'Flow.ConfinedRise.ends']),
    ('In generations founded uniform, exact transmission keeps every later member at the founding value, so nothing '
     'is selected within; wherever offspring number is concordant or discordant with the amount at a step, '
     'transmission raised or lowered it at some step before.',
     '由均匀者奠基的世代中，精确的传递使此后每个成员保持奠基值，故组内无选择；某步后代数与该量一致或不一致时，此前某步的传递升高或降低了它。',
     ['uniform_until', 'none_within_until', 'exact_of_none', 'changed_or_none', 'varied_before', 'of_mem_single']),
    ('Over wholes each founded by one part, transmission across a generation of wholes is how far the next founders '
     'moved from their founder within the whole; where they carry the founder\'s value, the mean founding value rises '
     'exactly where selection among wholes goes for it.',
     '在每个整体由一个部分奠基的读法中，跨整体世代的传递即下一批奠基者在整体内离开其奠基者的距离；下一批奠基者携带原奠基者之值时，平均奠基值恰在整体间选择为它时上升。',
     ['Nested', 'Nested.Founded', 'Nested.Sequestered', 'Nested.raised_carried', 'Nested.lowered_carried',
      'Nested.raises_iff_carried', 'Nested.exact_of_sequestered', 'Nested.raises_iff_among', 'Nested.varied_within']),
    ('Witness Body: two lineages each meet every clause of a rise on one body; the confined one ends, the one whose '
     'descendant depends on a condition outside the body still has a member a generation after every part depending '
     'on the body has ended.',
     '见证 Body：两个世系都在同一身体上满足上升的每一条件；局限者终结，后代依存于身体之外条件者在依存于身体的一切部分终结后一代仍有成员。',
     ['Body.balances', 'Body.acting', 'Body.dependent', 'Body.descended', 'Body.confined_marks', 'Body.confined_rise',
      'Body.confined_ended', 'Body.spread_marks', 'Body.spread_rise', 'Body.spread_unconfined', 'Body.body_ended',
      'Body.spread_outlasts']),
    ('Witness Germline: a variant not holding back arises within a whole and is selected for within it; with the next '
     'founder from the line carrying the founder\'s value the mean founding value rises from a half to one, with the '
     'founders from the variants it falls from a half to none although selection among wholes goes for holding back.',
     '见证 Germline：整体内产生不保留的变体并在其中被选择；下一奠基者来自携带原奠基者之值的系时平均奠基值由一半升到一，来自变体时由一半降为零，尽管整体间选择偏向保留。',
     ['Germline.within_against', 'Germline.sequestered_founded', 'Germline.sequestered_sequestered',
      'Germline.sequestered_rises', 'Germline.unsequestered_founded', 'Germline.unsequestered_falls']),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))

rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'A confined rise within a whole, and what a founding carries', 'zh': '整体内局限的上升与一次奠基所携带者'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'A lineage confined to a whole\'s conditions in excess has no member once they end, whatever selection '
              'within raised; selection within a whole founded uniform needs variation arisen in it; where next founders '
              'carry their founder\'s value, selection among wholes decides the rise.',
        'zh': '局限于过度之整体条件的世系在其终结后不再有成员，无论组内选择抬高了什么；由均匀者奠基的整体内的选择需要在其中产生的变异；下一批奠基者携带原奠基者之值时，由整体间选择决定是否上升。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(names)} for en, zh, names in laws],
    'hypotheses': [{
        'en': 'No axiom. On the base, balance, only active formations giving, activity needing support, descent, the '
              'coupled gate on the family and n steps of its excess from a stock below n + m; confinement as a '
              'hypothesis of the lineage law. For varied_before, a first generation uniform in the amount. For the '
              'founding laws, one founder per whole carrying the whole\'s value and next founders among its members '
              '(Founded), and for the among-wholes law, foundings carrying the founder\'s value (Sequestered).',
        'zh': '不加公理。在基上，平衡、只有活跃的形成给予、活动需要支持、世系、该族上的耦合门控及其从低于 n + m 的存量起 n 步的过度；局限是世系定律的假设。varied_before 需第一代在该量上均匀。奠基定律需每个整体一个携带其值的奠基者、下一批奠基者是其成员（Founded），整体间定律另需奠基者携带奠基值（Sequestered）。'}],
    'does_not_show': [
        {'en': 'How parts first come to live as one (the major transitions themselves): the laws hold of a whole once '
               'formed and of its foundings.',
         'zh': '部分如何初次成为一体（重大转变本身）：定律只对已形成的整体及其奠基成立。', 'kind': 'scope'},
        {'en': 'That a given tumour meets the clauses of ConfinedRise, or that a given germ line is sequestered: '
               'empirical. Confinement, the excess and how founders are drawn are hypotheses wherever they enter.',
         'zh': '某一肿瘤满足 ConfinedRise 的各条件，或某一生殖系是隔离的：属经验问题。局限、过度与奠基者如何抽取在出现处都是假设。', 'kind': 'scope'},
        {'en': 'Wholes founded by several parts (colonial and aggregative routes), removal of parts by the whole\'s '
               'rule (policing in the literature), and a lineage founding a new whole elsewhere are not stated; the '
               'spreading witness has a member for one generation past the end.',
         'zh': '由多个部分奠基的整体（群体与聚合途径）、整体之规则移除部分，以及在别处奠基新整体的世系未陈述；扩散见证在终结之后只有一代有成员。', 'kind': 'scope'},
        {'en': 'Sequestered states an outcome (each next founder carries its founder\'s value), not a mechanism; germ '
               'lines do vary, and the rise\'s drawing clause says the lineage takes from the family during the excess, '
               'not that it causes it.',
         'zh': 'Sequestered 陈述的是结果（每个下一奠基者携带其奠基者之值），而非机制；生殖系确有变异；上升的汲取条件只说世系在过度期间汲取该族，并不说它造成过度。', 'kind': 'scope'},
        {'en': 'That a lineage ending with its whole is worse, or that sequestration is better: the counts read who '
               'leaves descendants; ranking goes through the comparison C.',
         'zh': '世系随其整体终结更坏、隔离更好：计数只读出谁留下后代；排序经由比较 C。', 'kind': 'non-implication'}],
    'counterexamples': [{'path': src('Founding'), 'detail': {
        'en': 'Confinement is needed: in Body the spreading lineage is a rise on the same body (Body.spread_rise), its '
              'descendant depends on a condition outside the body, and it has a member after the body\'s parts end '
              '(Body.spread_unconfined, Body.spread_outlasts). Sequestration is needed for the among-wholes law: in Germline with the founders '
              'from the variants the mean founding value falls although selection among wholes goes for holding back '
              '(Germline.unsequestered_falls).',
        'zh': '局限是必要的：Body 中扩散的世系是同一身体上的上升（Body.spread_rise），其后代依存于身体之外的条件，在身体的部分终结后仍有成员（Body.spread_unconfined、Body.spread_outlasts）。整体间定律需要隔离：Germline 中奠基者来自变体时，平均奠基值下降，尽管整体间选择偏向保留（Germline.unsequestered_falls）。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): every declaration of '
              'Becoming.Founding has an empty axiom report; the checker verifies core purity. Built and reviewed in '
              f'one session, with no separate reviewer; author review in study section {N}; not independently '
              'reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Founding 的每项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'Wholes founded by several parts (with assortment below one); removal of parts by the whole\'s rule; '
              'how parts first come to live as one; a review by a person.',
        'zh': '由多个部分奠基的整体（聚合低于一）；整体之规则移除部分；部分如何初次成为一体；人的审查。'},
    'correspondence': {
        'en': 'Buss 1987 and Michod 1999 (with Michod and Roze 2001) read the transitions in individuality through '
              'selection within and among organisms: a single-cell bottleneck (Grosberg and Strathmann 1998) reduces '
              'variation within, a sequestered germ line reduces the within-organism change in what founding '
              'transmits, and within-organism selection enters the organism level as transmission bias (the '
              'transmission term of Price 1970, 1972). Aktipis et al. 2015 read cancer as cheating on the foundations '
              'of multicellular cooperation; Metzger et al. 2015 report transmissible cancers. Readings (the AI\'s): '
              'ConfinedRise as cancer, Sequestered as a germ line where it does not vary, Founded with one founder as '
              'the bottleneck, a rise whose confinement fails as a transmissible cancer.',
        'zh': 'Buss 1987 与 Michod 1999（及 Michod 与 Roze 2001）经由生物体内与生物体间的选择读个体性转变：单细胞瓶颈（Grosberg 与 Strathmann 1998）减少体内变异，隔离的生殖系减少奠基所传递者中的体内变化，体内选择以传递偏差（Price 1970、1972 的传递项）进入生物体层面。Aktipis 等 2015 把癌读作对多细胞合作之基础的欺骗；Metzger 等 2015 报告可传播的癌。读法（AI 的）：ConfinedRise 读作癌，Sequestered 读作不变异时的生殖系，单个奠基者的 Founded 读作瓶颈，局限失败的上升读作可传播的癌。'},
    'canonical_source': src('Founding'),
    'aliases': ['confined rise', 'rise within a whole', 'cancer', 'germ line', 'sequestration', 'single-cell bottleneck',
                'transmissible cancer', 'turning back', '局限的上升', '癌', '生殖系', '隔离', '单细胞瓶颈',
                'Becoming.Founding.Flow.confined_ends', 'Becoming.Founding.Nested.raises_iff_among',
                'Becoming.Founding.varied_before'],
    'dependencies': [
        dep(CPL, 'formal-reuse',
            'The base laws read family_childless by lineage: a member depending on a condition of a family whose '
            'gated renewal ran into excess leaves no descendant.',
            '基上的定律按世系读 family_childless：依存于其门控更新遭遇过度之族中某条件的成员不留后代。',
            'Members depending on a family in excess leave no descendant.', '依存于过度之族的成员不留后代。',
            'A confined lineage ending, and survivors independent of the family.', '局限世系的终结，以及不依存于该族的幸存者。',
            'Balance, acting, dependence, the coupled gate, the excess, descent.', '平衡、行动、依存、耦合门控、过度、世系。',
            src('GroupEnding')),
        dep(GFD, 'formal-reuse',
            'The lineage of a group and its staying within the generations are those of groups formed by descent.',
            '组的世系及其留在各代之内，即由世系形成之组的世系。',
            'Lineages over listed generations.', '列出世代上的世系。',
            'The lineage a confined rise is read on.', '局限的上升所读的世系。',
            'A group of the first generation.', '第一代中的一个组。', src('SelectionLevels')),
        dep(STG, 'formal-reuse',
            'The founding laws are the selection term with exact transmission one level up (raises_exact_iff), and '
            'varied_before reads its transmission term.',
            '奠基定律即高一层的、传递精确的选择项（raises_exact_iff），varied_before 读其传递项。',
            'The mean\'s course over generations with its transmission term.', '均值在世代中的进程及其传递项。',
            'What a founding carries; variation since the founding.', '一次奠基所携带者；奠基以来的变异。',
            'Founded, and Sequestered for the among-wholes law.', 'Founded，整体间定律另需 Sequestered。',
            src('SelectionTerm'))],
    'related': [
        {'id': GFD, 'detail': {'en': 'Groups formed by descent from uniform founders: the bottleneck\'s other half, '
                                     'among groups.',
                               'zh': '由均匀奠基者的世系形成的组：瓶颈在组间的另一半。'}},
        {'id': CPL, 'detail': {'en': 'Groups on one family of conditions ending together; here a lineage within a '
                                     'whole read on its family.',
                               'zh': '在同一族条件上的组一同终结；此处读整体内依于其族的世系。'}},
        {'id': WHL, 'detail': {'en': 'A whole goes on only as parts keep arising; here what its parts\' lineages can '
                                     'carry past it.',
                               'zh': '整体只在部分不断生起时延续；此处是其部分的世系能越过它携带什么。'}}],
    'references': [{'path': src('Founding'), 'role': 'proof',
                    'declarations': sorted(d['name'] for d in decls('Founding')['declarations']),
                    'sha256': sha(src('Founding'))}
                   ] + [{'path': src(mod), 'role': 'proof', 'declarations': names, 'sha256': sha(src(mod))}
                        for mod, names in USED.items()] + [
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)},
                   {'path': EVO, 'role': 'statement', 'sha256': sha(EVO)},
                   {'path': OPENING, 'role': 'statement', 'sha256': sha(OPENING)}],
    'proof_bindings': [{'source': src(mod), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{mod}',
                        'success_pointer': '/status', 'success_value': 'passed'}
                       for mod in ['Founding'] + list(USED)],
    'history': [{
        'en': f'22 October 2026: added (CA1), what cancer is and what keeps a part from turning back: a confined rise '
              f'has no member once the conditions it draws on end, selection within a whole founded uniform needs '
              f'variation arisen in it, and where next founders carry their founder\'s value the mean founding value '
              f'rises exactly where selection among wholes goes for it; an independent review applied; OPENING '
              f'[^transitions] restated; study section {N}.',
        'zh': f'2026年10月22日：新增（CA1），癌是什么以及什么使部分不回头：局限的上升在其所汲取的条件终结后不再有成员，由均匀者奠基的整体内的选择需要在其中产生的变异，'
              f'下一批奠基者携带原奠基者之值时，平均奠基值恰在整体间选择为它时上升；已采纳独立审查；OPENING [^transitions] 重述；研究第 {N} 节。'}],
}
assert len(rec['statement']['en']) <= 300, len(rec['statement']['en'])
for mod, names in USED.items():
    have = {d['name'] for d in decls(mod)['declarations']}
    assert set(names) <= have, (mod, set(names) - have)
path = RECORDS / f'{RID}.json'
assert not path.exists(), ('record exists', RID)
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID)

for rid, en, zh in (
        (GFD, 'Within one whole founded by one part, a lineage confined to its conditions in excess has no member once '
              'they end, and where next founders carry their founder\'s value the mean founding value rises exactly '
              'where selection among wholes goes for it.',
         '在由一个部分奠基的整体内，局限于过度之条件的世系在其终结后不再有成员；下一批奠基者携带原奠基者之值时，平均奠基值恰在整体间选择为它时上升。'),
        (CPL, 'A lineage within a whole confined to one family of conditions in excess has no member once it ends, '
              'whatever selection within had raised it to.',
         '整体内局限于一族过度之条件的世系在其终结后不再有成员，无论组内选择曾把它抬到多高。')):
    p = RECORDS / f'{rid}.json'
    d = json.loads(p.read_text())
    assert all(r['id'] != RID for r in d['related'])
    d['related'].append({'id': RID, 'detail': {'en': en, 'zh': zh}})
    d['history'].append({
        'en': f'22 October 2026, CA1: related to {RID} (study section {N}); this record\'s laws and statements are '
              'unchanged.',
        'zh': f'2026年10月22日，CA1：与 {RID} 相关（研究第 {N} 节）；本记录的定律与陈述不变。'})
    p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('noted', rid)

cov = json.loads((ROOT / COVERAGE).read_text())
row = next(r for r in cov['rows'] if r['id'] == 'evolution')
assert RID not in row['records']
row['records'].insert(row['records'].index(GFD) + 1, RID)
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
print('coverage row evolution')
