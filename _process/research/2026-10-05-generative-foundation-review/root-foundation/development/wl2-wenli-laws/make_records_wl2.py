#!/usr/bin/env python3
"""WL2 records: extend the-split-that-makes-sense (the coarsest class, one law) and a-code-formed-between-formations (the
course of forms, and Law.KeepsRelation moved to IdentificationRuns), write a-formations-own-course, and note
wenli-on-the-spine.
python3 -B make_records_wl2.py CORE_RECEIPT STUDY_SECTION STUDY_SLUG PREVIOUS_RECEIPT   (from the checkout root, after
apply_text_wl2.py)

Every cited declaration is resolved against the receipt, the receipt must bind each module's current bytes, and
together the records cite exactly the declarations the two modules gained."""
import datetime
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
CHAPTER = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
WL = 'theories/becoming/chapters/WENLI-AND-BECOMING.md'
ZHB = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING-ZHONGHUA.md'
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N, slug, previous = sys.argv[1], int(sys.argv[2]), sys.argv[3], sys.argv[4]
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
P = json.loads((ROOT / f'{PKG}/becoming-checks/{previous}/verification.json').read_text())
MODS = ['IdentificationRuns', 'SharedCodes']
MOVED = {'Becoming.Law.KeepsRelation', 'Becoming.Law.KeepsRelation.run'}
REMOVED = MOVED


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def src(mod):
    return f'{PKG}/Becoming/{mod}.lean'


full, new = {}, set()
for mod in MODS:
    m = next(m for m in core['modules'] if m['module'] == f'Becoming.{mod}')
    assert core['source_sha256'][f'Becoming.{mod}'] == sha(src(mod)), mod
    assert not any(m['axiom_dependencies'].values())
    names = [d['name'] for d in m['declarations']]
    old = {d['name'] for d in next(x for x in P['modules'] if x['module'] == f'Becoming.{mod}')['declarations']}
    assert not (old - set(names) - REMOVED), old - set(names)
    for n in names:
        full[n] = mod
    new |= {n for n in names if n not in old}
assert MOVED <= new and all(full[n] == 'IdentificationRuns' for n in MOVED)


def R(names):
    out = []
    for n in names:
        assert 'Becoming.' + n in full, n
        out.append('Becoming.' + n)
    return out


def load(rid):
    return json.loads((RECORDS / f'{rid}.json').read_text(encoding='utf-8'))


def save(rid, d):
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def bind(d, mod, decls):
    """Add decls to the record's proof reference for mod (creating it), rehash it, and bind it to the receipt."""
    s = src(mod)
    refs = [r for r in d['references'] if r['path'] == s and r['role'] == 'proof']
    if refs:
        refs[0]['declarations'] = sorted(set(refs[0].get('declarations', [])) | set(decls))
        refs[0]['sha256'] = sha(s)
    else:
        k = max(i for i, r in enumerate(d['references']) if r['role'] == 'proof') + 1
        d['references'].insert(k, {'path': s, 'role': 'proof', 'declarations': sorted(decls), 'sha256': sha(s)})
    if not any(r['path'] == RECEIPT for r in d['references']):
        d['references'].append({'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)})
    pb = [b for b in d['proof_bindings'] if b['source'] == s]
    binding = {'source': s, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{mod}',
               'success_pointer': '/status', 'success_value': 'passed'}
    if pb:
        pb[0].update(binding)
    else:
        d['proof_bindings'].append(binding)


cited = set()
SL = f'{STUDY}#{slug}'

# --- the-split-that-makes-sense: the coarsest class, one law
d = load('the-split-that-makes-sense')
lawA = R(['Law.KeepsRelation', 'Law.KeepsRelation.run', 'Law.KeepsAndCarries', 'Law.sameFuture_coarsest',
          'Law.KeepsAndCarries.of_exact', 'Law.coarser_of_exact', 'Law.coarsest_iff'])
lawB = R(['Law.coarsest_class'])
if not any('Becoming.Law.coarsest_iff' in l['declarations'] for l in d['laws']):
    d['laws'] += [
        {'en': "The coarsest class, one law: the same course through the map is the coarsest relation keeping the map's values that the law keeps, with no premise; for a class keeping the values and carrying the law, being coarser than every such relation, merging every two configurations with the same course, merging exactly those and making sense are one, and it is then coarser than every other such class.",
         'zh': '最粗之类，一条律：经象文同是守象之值、为法所守之最粗关系，不加前提；守值载法之类，粗于每一如此关系、并凡文同之二状、恰并文同之状、'
               '为正名，四者是一；恰并文同之类粗于每一守值载法之类。',
         'declarations': lawA},
        {'en': 'Where a list holds every configuration the names keep the values, carry the law and merge exactly the '
               'configurations with the same course, and a class keeping the values and carrying the law is coarser than '
               'every such class into the universe of the values exactly where it merges exactly those.',
         'zh': '一列表尽其状时，名守值、载法、恰并文同之状；守值载法之类，粗于每一值在同一 universe 之守值载法之类，恰当它恰并文同之状。',
         'declarations': lawB}]
cited |= set(lawA) | set(lawB)
d['statement'] = {
    'en': "For a determined law, the coarsest class keeping the map's values and carrying the law merges exactly the "
          "configurations with the same course and makes sense; a part alone makes sense exactly where the rest makes no "
          "difference to its next value; every history of values is a determined law.",
    'zh': '确定的律下，守映射之值并承载规律的最粗之类，恰并经映射未来相同之配置，且有意义；值的一部分单独有意义，恰当其余对它的下一值不造成差别；'
          '每段值的历史是一条确定的律。'}
for x in d['does_not_show']:
    if x['en'].startswith('That a description making sense exists as values is not stated'):
        x['en'] = 'For a law on any type no class merging exactly the configurations with the same course is constructed: that the quotient merges them takes Quot.sound. The relation needs no premise; a class is given where a list holds every configuration.'
        x['zh'] = '对任一类型上的律，恰并未来相同之配置的类未构造：商并之须 Quot.sound。其关系不加前提；一列表尽其状时类亦给出。'
        break
else:
    sys.exit('the-split-that-makes-sense: does_not_show entry on naming not found')
d['hypotheses'].append({
    'en': 'Law.coarsest_iff takes a class keeping the values and carrying the law (Law.KeepsAndCarries); Law.coarsest_class '
          'a list holding every configuration, and compares classes into the universe of the map\'s values.',
    'zh': 'Law.coarsest_iff 设一类守值而载法（Law.KeepsAndCarries）；Law.coarsest_class 设一列表尽其状，所比之类其值与映射之值同一 universe。'})
bind(d, 'IdentificationRuns', lawA + lawB)
d['validation_scope'] = {
    'en': f'Machine-checked by the consolidated Lean 4.29.1 checker: each cited module\'s current bytes are bound to a '
          f'passing receipt (proof_bindings), every source declaration has an empty axiom report, and core purity is '
          f'verified; the coarsest-class laws WL2 added by receipt {core_id}. Author counterreview in the integration '
          f'notes (for WL2 study section {N}, with an independent AI review), which state the scope of the independent '
          f'review.',
    'zh': f'Lean 4.29.1 合并检查器实查：所引各模块之当前字节绑定于通过之回执（proof_bindings），源声明公理报告全空，并核对核心纯净；WL2 所加'
          f'最粗之类诸律由回执 {core_id} 检查。作者反审见整合文档（WL2 见研究第 {N} 节，并经一次独立的 AI 审查），其中也说明独立审查的范围。'}
d['reviewed_at_utc'] = NOW
d['history'].append({
    'en': f'22 October 2026, WL2: the coarsest class keeping the values and carrying the law stated as one law, with the '
          f'coarsest relation (no premise) and the class where a list holds every configuration (Law.sameFuture_coarsest, '
          f'Law.coarsest_iff, Law.coarser_of_exact, Law.coarsest_class); it gathers sameFuture_of_law, identifiesAlike_of_law '
          f'and alike_iff_sameFuture, and adds the coarsest property; Law.KeepsRelation moved here from SharedCodes; the '
          f'statement and the scope note on naming revised; study section {N}.',
    'zh': f'2026年10月22日，WL2：守值载法之最粗之类作一条律，含最粗之关系（无设）与一列表尽其状时之类（Law.sameFuture_coarsest、'
          f'Law.coarsest_iff、Law.coarser_of_exact、Law.coarsest_class）；它合 sameFuture_of_law、identifiesAlike_of_law 与 '
          f'alike_iff_sameFuture，并加最粗之性；Law.KeepsRelation 自 SharedCodes 移来；改陈述与命名之范围注；研究第 {N} 节。'})
save('the-split-that-makes-sense', d)

# --- a-code-formed-between-formations: the course of forms; KeepsRelation moved
d = load('a-code-formed-between-formations')
lawC = R(['SharedCodes.course_states_iff', 'SharedCodes.course_read', 'SharedCodes.code_read_every'])
if not any('Becoming.SharedCodes.course_read' in l['declarations'] for l in d['laws']):
    d['laws'].append({
        'en': 'The course of forms: through a code, the course of forms of every course of senses is one state at exactly the moments the course of senses is, exactly where the code tells senses apart; where resolution reads every encoded sequence, it reads the course of forms of every course of words as its course of meanings step by step, and a code read back so tells senses apart.',
        'zh': '名之文：经一码，凡义之文，其名之文恰在义之文同状之步同状，恰当此码辨诸义；以通意读出每一串时，逐步把词之名之文读为义之文，名之文二步同则义之文'
              '二步同；如此读回之码辨诸义。',
        'declarations': lawC})
cited |= set(lawC)
sc = src('SharedCodes')
for r in d['references']:
    if r['path'] == sc and r['role'] == 'proof':
        r['declarations'] = sorted(set(r['declarations']) - MOVED)
bind(d, 'SharedCodes', lawC)
bind(d, 'IdentificationRuns', sorted(MOVED))
d['hypotheses'].append({
    'en': 'For the course of forms: the premises of CrossSituational.reads_every_iff (grouping recovers the words of every '
          'encoded sequence, a repertoire without repeats, decided equality of meanings).',
    'zh': '名之文：CrossSituational.reads_every_iff 之前提（分组复原每一串编码之词，义项之族各异，义项之同异定然否）。'})
if not any(x['id'] == 'acquired-binding-compositional-use' for x in d['dependencies']):
    d['dependencies'].append({'id': 'acquired-binding-compositional-use', 'relation': 'formal-reuse', 'detail': {
        'en': 'CrossSituational.reads_every_iff, reading every encoded sequence by resolution.',
        'zh': 'CrossSituational.reads_every_iff，以通意读出每一串编码。'}})
d['validation_scope']['en'] += (f' The course of forms (WL2) is checked by receipt {core_id}, with empty axiom reports; '
                                f'study section {N}.')
d['validation_scope']['zh'] += f' 名之文（WL2）由回执 {core_id} 检查，公理报告为空；研究第 {N} 节。'
d['reviewed_at_utc'] = NOW
d['history'].append({
    'en': f'22 October 2026, WL2: the course of forms through a code and read by cross-situational resolution added '
          f'(SharedCodes.course_states_iff, course_read, code_read_every); Law.KeepsRelation and Law.KeepsRelation.run moved '
          f'to Becoming.IdentificationRuns, cited there; study section {N}.',
    'zh': f'2026年10月22日，WL2：增经码与通意之名之文（SharedCodes.course_states_iff、course_read、code_read_every）；'
          f'Law.KeepsRelation 与 Law.KeepsRelation.run 移至 Becoming.IdentificationRuns，于彼引之；研究第 {N} 节。'})
save('a-code-formed-between-formations', d)

# --- a-formations-own-course: new
laws = [
    ("Where value gives the values of what couples into a formation (at each step two levels take one value exactly where "
     "they admit it alike and the conditions coupled in by level stand alike), its own course under a level history is the "
     "value at each step of what couples in then; where admission is decided and the conditions coupled in by level are "
     "listed, whether it is admitted and the listed levels give such values.",
     '值给出感入一待者者（每步二组积同值，恰当其同容或同不容、以积感入者其积亦同）时，其自身之文是每步感入者之值；容已定、以积感入者列尽时，容否与所列诸积即给出如此之值。',
     ['Web.ValuesThrough', 'Web.courseThrough', 'Web.listed_values']),
    ('Being alike through its couplings at a step is one value of its own course there, and up to a step one prefix of '
     'it; two histories are selected alike by every selection through its couplings exactly where the prefixes agree.',
     '一步缘其感无异即其自身之文于此步同值，至某步无异即其往同；二历被每一缘其感之择同样地择，恰当其往同。',
     ['Web.alikeThrough_iff', 'Web.alikeThroughUpTo_iff_prefix', 'Web.selects_alike_iff_prefix']),
    ('A selection is through its couplings up to a step exactly where it selects each history by the prefix of its own '
     'course before the next step.',
     '一择缘其感至某步，恰当它依其自身之文至此步之往而择。',
     ['Web.selectsThrough_iff_prefix']),
    ("Where its own courses under two histories have at most N and N' states and the histories are alike through its "
     "couplings before N + N' - 1, they are alike at every step and every selection through its couplings selects them "
     "alike; where the two courses read together have at most P states, alike before P is enough.",
     '其自身之文于二历下各不过 N、N′ 状，二历于 N＋N′－1 步前缘其感无异，则永无异，凡缘其感之择皆同择之；二文合读不过 P 状时，P 步前无异即足。',
     ['Web.alike_of_bounded', 'Web.selects_alike_of_bounded', 'IdentificationRuns.joint_agree',
      'Web.alike_of_joint_bounded']),
    ("The bound is attained in a web of one condition read by its level: for every M and M' two histories whose own courses "
     "have at most M + 1 and M' + 1 states are alike before M + M' and apart at M + M'. In the same web, read with the "
     "step, a constant history's own course has more than every bound of states, and read by the level one.",
     '此界于一所待之网（以积读之）中达到：对每一 M、M′，二历其文各不过 M＋1、M′＋1 状，于 M＋M′ 前无异、于 M＋M′ 有异。同网中连步数读之，积恒定之历其文之状多于每一界，以积读之则一状。',
     ['Web.oneCondition', 'Web.oneCondition_values', 'Web.bounded_exact', 'Web.states_by_reading']),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
decls = [x for _, _, names in laws for x in R(names)]
cited |= set(decls)
rec = {
    'schema_version': 2, 'id': 'a-formations-own-course',
    'title': {'en': "A formation's own course", 'zh': '待者自身之文'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F04', 'reviewed_at_utc': NOW,
    'statement': {
        'en': "Where what couples into a formation is read as values, being alike through its couplings up to a step is one "
              "prefix of its own course, a selection through them selects by that prefix, and own courses with at most N and "
              "N' states fix what it tells apart within N + N' - 1 steps, a bound attained.",
        'zh': '感读作值之处，缘待者之感至某步无异即其自身之文之往同，缘感之择即依此往而择；自身之文不过 N、N′ 状者，所分者于 N＋N′－1 步内分尽，此界达到。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': R(names)} for en, zh, names in laws],
    'hypotheses': [{
        'en': "No axiom. A reading of what couples in as values (ValuesThrough), given; where admission at the formation is "
              "decided and the conditions coupled in by level are listed, one is given (listed_values). For the bounds, at "
              "most N and N' states of the own courses, or P of the two read together, under that reading; discrete steps, "
              "natural levels.",
        'zh': '不加公理。感读作值（ValuesThrough）是所给的；容已定、以积感入者列尽时，有一种给出（listed_values）。界之律设自身之文于此读下各不过 N、N′ 状，或合读不过 P 状；离散步，自然数之积。'}],
    'does_not_show': [
        {'en': 'That what couples in is a value in general: being alike through the couplings is a relation (admission is a '
               'claim, the conditions coupled in by level may be infinitely many), and a reading as values for every web '
               'is not constructed.',
         'zh': '一般而言感入者是值：缘感无异是关系（容是一辞，以积感入者可以无穷），对每一网读作值者没有构造。', 'kind': 'scope'},
        {'en': 'That the states of an own course are fixed by the coupling: they compare values at different steps and depend '
               'on the reading (Web.states_by_reading); the bounded laws are as strong as the reading with the fewest states.',
         'zh': '自身之文之状由感而定：它们比较异步之值，随读而定（Web.states_by_reading）；界之律之强，在于状最少之读。', 'kind': 'scope'},
        {'en': 'That a formation reads, learns or predicts its own course: the laws say what a selection through its '
               'couplings can depend on.',
         'zh': '待者读、学或预测其自身之文：诸律只说缘其感之择能依于什么。', 'kind': 'non-implication'}],
    'counterexamples': [],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical',
                            'names-provisional', 'omission-not-refutation'],
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): every declaration cited has an '
              f'empty axiom report; the checker verifies core purity. Built in one session, with an independent AI review '
              f'applied; author review in study section {N}; not independently reviewed by a person. The definitional laws '
              f'(alikeThrough_iff and the prefix form) unpack ValuesThrough; the content is the selection by the prefix, the '
              f'bounds with their attainment, and the dependence of the states on the reading.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：所引每项声明公理报告为空；检查器并核对核心纯净。在一个会话中构建，并经一次独立的 AI 审查；'
              f'作者审查见研究第 {N} 节；未经人的独立审查。定义性之律（alikeThrough_iff 与往之形）只是展开 ValuesThrough；内容在依往而择、界及其达到、'
              f'状随读而定。'},
    'next_delta': {'en': 'A reading as values derived from the web where admission is decided; an independent review.',
                   'zh': '容已定之处由网导出感之值之读；独立审查。'},
    'correspondence': {
        'en': '识 (D45): a formation\'s own further course read through what couples into it; 缘感无异, read as values, is '
              'the same prefix of its own course (文, D63).',
        'zh': '识（D45）：一待者自身之后程经其感而读；缘感无异读作值时，即其自身之文（D63）之往同。'},
    'canonical_source': src('IdentificationRuns'),
    'aliases': ["A formation's own course", '待者自身之文', 'Becoming.Web.courseThrough'],
    'dependencies': [
        {'id': 'selection-through-couplings', 'relation': 'formal-reuse', 'detail': {
            'en': 'Web.AlikeThroughUpTo, Web.SelectsThrough and selects_alike_iff.',
            'zh': 'Web.AlikeThroughUpTo、Web.SelectsThrough 与 selects_alike_iff。'}},
        {'id': 'identification-where-bounded', 'relation': 'formal-reuse', 'detail': {
            'en': 'Identification.bounded_agree, bounded_agree_exact and prefix_eq_iff.',
            'zh': 'Identification.bounded_agree、bounded_agree_exact 与 prefix_eq_iff。'}}],
    'related': [
        {'id': 'wenli-on-the-spine', 'detail': {'en': 'States the open Lean item of its §六 (识 and 缘感无异).',
                                                'zh': '陈述其 §六 所列之 Lean 项（识与缘感无异）。'}},
        {'id': 'testing-within-couplings', 'detail': {'en': 'Web.AlikeThrough and the coupling into a formation.',
                                                      'zh': 'Web.AlikeThrough 与感入一待者者。'}},
        {'id': 'the-split-that-makes-sense', 'detail': {'en': 'States read off a course; the coarsest value-keeping class.',
                                                        'zh': '自文读状；守值之最粗之类。'}}],
    'references': [
        {'path': src('IdentificationRuns'), 'role': 'proof', 'declarations': sorted(decls), 'sha256': sha(src('IdentificationRuns'))},
        {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
        {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
        {'path': WL, 'role': 'statement', 'sha256': sha(WL)},
        {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)},
        {'path': ZHB, 'role': 'statement', 'sha256': sha(ZHB)}],
    'proof_bindings': [{'source': src('IdentificationRuns'), 'receipt': RECEIPT,
                        'sha256_pointer': '/source_sha256/Becoming.IdentificationRuns', 'success_pointer': '/status',
                        'success_value': 'passed'}],
    'history': [{'en': f'22 October 2026: added (WL2), for the open Lean item of WENLI-AND-BECOMING §六; study section {N}.',
                 'zh': f'2026年10月22日：新增（WL2），补 WENLI-AND-BECOMING §六 所列之 Lean 项；研究第 {N} 节。'}],
}
assert not (RECORDS / 'a-formations-own-course.json').exists()
save('a-formations-own-course', rec)

# --- wenli-on-the-spine: noted
d = load('wenli-on-the-spine')
if not any(x['id'] == 'a-formations-own-course' for x in d['related']):
    d['related'].append({'id': 'a-formations-own-course', 'detail': {
        'en': 'WL2: 识 reads the prefix of its own course where what couples in is read as values.',
        'zh': 'WL2：感读作值时，识所读者是其自身之文之往。'}})
for x in d['related']:
    if x['id'] == 'the-split-that-makes-sense':
        x['detail'] = {'en': 'alike_moments_iff and coarsest_iff: states read off a course; the coarsest value-keeping class '
                             'merges exactly the states with the same course, one law (WL2).',
                       'zh': 'alike_moments_iff 与 coarsest_iff：自文读状；守值之最粗之类恰并文同之状，一条律（WL2）。'}
d['progress'].append({'en': 'WL2: the open Lean items proved (the coarsest value-keeping class as one law, a formation\'s '
                            'own course, the course of names read back).',
                      'zh': 'WL2：所列 Lean 项已证（守值之最粗之类作一条律，待者自身之文，名之文之读回）。',
                      'source': SL})
d['history'].append({'en': f'22 October 2026, WL2: the chapter\'s open Lean items proved and cited in place of its caveats; '
                           f'study section {N}.',
                     'zh': f'2026年10月22日，WL2：本章所列之 Lean 项已证，于原注之处引之；研究第 {N} 节。'})
d['reviewed_at_utc'] = NOW
save('wenli-on-the-spine', d)

missing = new - cited
assert not missing, sorted(missing)
print('records: the-split-that-makes-sense, a-code-formed-between-formations, a-formations-own-course (new), '
      'wenli-on-the-spine; cited', len(cited), 'new', len(new))
