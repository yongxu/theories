#!/usr/bin/env python3
"""UE18 records: write the-markov-blanket-as-a-coupling-structure (homed at 03 §1) and what-the-existence-claim-forbids
(homed at 03 §6), from Becoming.Blanket, each declaration cited once across the two; relate selection-through-couplings,
runaway-distance-uncoupled, capture-by-counted-choices, conditioning-by-restriction and free-energy-bounds-surprisal to
them, each with a related entry and a history note, no statement, next step or declaration of theirs changing. Asserts
the receipt's hash and empty axiom reports for the module, and the style caps and lint on every field written. Mirrors
UE16's make_records_ue16.py; runs after UE16 and UE17 have landed.
usage (from the checkout root, after texts_ue18.py): python3 -B make_records_ue18.py RECEIPT N
       python3 -B make_records_ue18.py --caps  (the caps, lint and the declaration cover against the kit's scratch
                                                audit; writes nothing)"""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT))
from tools.research import style  # noqa: E402

CAPS_ONLY = sys.argv[1] == '--caps'
RECEIPT_ID, N = ('20261029T000000.000000Z', 450) if CAPS_ONLY else (sys.argv[1], int(sys.argv[2]))
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
KITD = RF + 'development/ue18-blanket-and-existence/'
NOTE, REVIEW = KITD + 'NOTE.md', KITD + 'REVIEW-UE18.md'
CH3 = 'theories/becoming/chapters/03-KNOWING.md'
LEAN = {m: f'{PKG}/Becoming/{m}.lean' for m in ('Blanket', 'ConditionalWeights', 'Testing', 'Learning', 'Admission')}
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
RIDA = 'the-markov-blanket-as-a-coupling-structure'
RIDB = 'what-the-existence-claim-forbids'
RIDSEL = 'selection-through-couplings'
RIDLUMP = 'generalization-through-lumping'
RIDRUN = 'runaway-distance-uncoupled'
RIDU1 = 'capture-by-counted-choices'
RIDCOND = 'conditioning-by-restriction'
RIDFE = 'free-energy-bounds-surprisal'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
COUNT = 49
M = 'Becoming.Blanket'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def capped(field, pair, item=False):
    caps = style.ITEM_CAPS_V2 if item else style.CAPS_V2
    en, zh = caps[field][:2]
    assert len(pair['en']) <= en and len(pair['zh']) <= zh, (field, len(pair['en']), en, len(pair['zh']), zh, pair['en'][:60])
    return pair


if CAPS_ONLY:
    audit = (HERE.parent / 'tree/.build/BecomingBlanketAxiomAudit.lean').read_text(encoding='utf-8')
    names = set(re.findall(r'^#print axioms (\S+)$', audit, re.M))
else:
    core = json.loads((ROOT / RECEIPT).read_text())
    assert core['status'] == 'passed'
    assert core['source_sha256'][M] == sha(LEAN['Blanket']), M
    mod = next(x for x in core['modules'] if x['module'] == M)
    assert not any(mod['axiom_dependencies'].values()), M
    names = {d['name'] for d in mod['declarations']}
assert len(names) == COUNT, len(names)


def C(*short):
    out = [f'{M}.' + s for s in short]
    missing = [n for n in out if n not in names]
    assert not missing, missing
    return out


B = 'Blanketed.'
T = 'ThresholdDrain.'
groups_a = [
    ("A blanketed law has four parts of one law, told apart by which part reads which: the internal and active parts "
     "read the internal, sensory and active parts, the sensory and external parts the sensory, active and external "
     "parts; its step moves all four, its course is the orbit (Blanketed, Parts, step, course, congr3).",
     "毯化之律有一律之四部分，以何部分读何部分相别：内部与主动部分读内部、感官与主动部分，感官与外部部分读感官、主动与外部部分；其步四者同移，其历程即轨道"
     "（Blanketed、Parts、step、course、congr3）。",
     C('Blanketed', 'Parts', B + 'step', B + 'course', 'congr3')),
    ("The agent is driven by its sensory course: from one internal and one active state, courses alike on the sensory "
     "part have one internal and one active course; the world is driven by the active course (agent_through_sensory, "
     "world_through_active).",
     "主体由其感官历程所驱动：自同一内部与主动状态起，感官部分相同之历程其内部与主动历程相同；外界由主动历程所驱动（agent_through_sensory、"
     "world_through_active）。",
     C(B + 'agent_through_sensory', B + 'world_through_active')),
    ("Each side's course is fixed by its start and the blanket's course, and every reading of the internal course is a "
     "selection through the blanket: the deterministic case of the time-unrolled blanket (BlanketAlike, "
     "internal_through_blanket, external_through_blanket, reads_through_blanket).",
     "每一侧之历程由其起点与毯之历程所定，内部历程之每一读数皆为经毯之选择：时间展开之毯之确定情形（BlanketAlike、internal_through_blanket、"
     "external_through_blanket、reads_through_blanket）。",
     C(B + 'BlanketAlike', B + 'internal_through_blanket', B + 'external_through_blanket', B + 'reads_through_blanket')),
    ("Where the sensory part reads the external part only through a map, two courses from one agent and sensory start "
     "whose external parts are alike through it have one internal, sensory and active course: generalization "
     "through a lumping on every blanketed law (through_reading).",
     "感官部分唯经一映射读外部部分，则自同一主体与感官起点、外部部分经之相同之二历程，其内部、感官与主动历程相同：经归并之推广于每一毯化之律"
     "（through_reading）。",
     C(B + 'through_reading')),
    ("A reading through the blanket separates at most what the blanket tells apart: an internal part reading nothing "
     "has one course while the blankets differ (Deaf.law, Deaf.lumps).",
     "经毯之读至多分其毯所分：不读任何物之内部部分，毯异而其历程相同（Deaf.law、Deaf.lumps）。",
     C('Deaf.law', 'Deaf.lumps')),
    ("The threshold witness: the internal part whether the system goes on, the sensory part reading the supply only by "
     "threshold, the supply draining by one; the blankets agree before step four, at step four the sensory parts "
     "differ while the internal parts agree, at step five one has ended, and the ended course rests (law and eight "
     "more).",
     "阈之例：内部部分为系统是否延续，感官部分唯以阈读供给，供给每步减一；第四步前毯相同，第四步感官部分相异而内部部分相同，第五步其一终结，终结之历程静止"
     "（law 等九项）。",
     C(T + 'law', T + 'short', T + 'long', T + 'reads_threshold', T + 'alike_before_four', T + 'sensed_at_break',
       T + 'ended', T + 'ended_rests', T + 'short_rests')),
    ("The witness's blanket is the World's coupling by threshold: its sensory part is the World's admission at need "
     "one, and its courses are blanket-alike before step n + 2 exactly where the supply histories are alike through the "
     "formation's couplings up to n (web and five more).",
     "例之毯即世界以阈之耦合：其感官部分即世界于需求一之容纳，其历程于第 n + 2 步前于毯相同，恰当供给之历史经形成之耦合至 n 相同（web 等六项）。",
     C(T + 'web', T + 'sensory_is_admission', T + 'external_course', T + 'sensory_succ', T + 'bool_eq_of_iff',
       T + 'blanket_iff_through')),
    ("With any model updated by any rule and any policy, from a supply of three and every supply of four or more, every "
     "reading of the internal course up to step four is alike, the sensory parts differing first at step four, while "
     "at step five the first has ended (modelLaw and five more).",
     "无论以何规则更新之任一模型与任一策略，自供给三与任一不少于四之供给，至第四步内部历程之每一读数皆相同，感官部分于第四步始异，而第五步前者已终结"
     "（modelLaw 等六项）。",
     C(T + 'modelLaw', T + 'start', T + 'sensed_alike', T + 'blanket_alike', T + 'any_model',
       T + 'sensory_apart_at_four')),
]
groups_b = [
    ("The point weighting on an outcome is the counting weighting restricted to the record of being it: read off a "
     "course of a determined law, the existence claim's model is conditioning on the course itself (point, isAt, "
     "point_is_restrict).",
     "置于一结果之点权重，即限于其记录之计数权重：读自确定律之历程，存在之主张之模型即以该历程本身为条件（point、isAt、point_is_restrict）。",
     C('point', 'isAt', 'point_is_restrict')),
    ("Under the point weighting a listed outcome weighs something, its share is the whole and no event's is greater, "
     "so it is of least surprisal, and every event not holding at it weighs nothing (point_whole, least_surprisal, "
     "point_forbids_rest, le_mass_of_mem).",
     "于点权重下，列出之结果有权重，其份额即整体，无事件之份额更大，故其惊异最小；凡不于其成立之事件权重为零（point_whole、least_surprisal、"
     "point_forbids_rest、le_mass_of_mem）。",
     C('point_whole', 'least_surprisal', 'point_forbids_rest', 'le_mass_of_mem')),
    ("The occupation weighting read off a run gives every visited, listed state a positive share, ending included, and "
     "every unvisited state no weight (visits and four more).",
     "读自运行之占据权重，给每一访问且列出之状态正份额（终结亦然），未访问之状态无权重（visits 等五项）。",
     C('visits', 'visits_le_succ', 'visits_pos', 'visits_zero', 'read_off_admits')),
    ("A listed outcome has the share nothing exactly where its weight is nothing: forbidding a course needs a weighting "
     "fixed apart from it (unweighted_share, forbids_iff).",
     "列出之结果份额为零，恰当其权重为零：禁一历程需与之无关而定之权重（unweighted_share、forbids_iff）。",
     C('unweighted_share', 'forbids_iff')),
]
cited_a = [d for _, _, ds in groups_a for d in ds]
cited_b = [d for _, _, ds in groups_b for d in ds]
cited = cited_a + cited_b
assert len(cited) == len(set(cited)) == COUNT, (len(cited), len(set(cited)))
assert set(cited) == names, sorted(names - set(cited))
laws_a = [capped('laws', {'en': en, 'zh': zh, 'declarations': ds}, item=True) for en, zh, ds in groups_a]
laws_b = [capped('laws', {'en': en, 'zh': zh, 'declarations': ds}, item=True) for en, zh, ds in groups_b]


def validation(count):
    return capped('validation_scope', {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): {count} of the {COUNT} '
              f'declarations of {M}, the rest cited by its sibling record, each with an empty axiom report. Drafted by '
              f'an AI agent; an independent read-only review by another AI agent (REVIEW-UE18), whose probe the '
              f'revision adopted, and a re-check, study section {N}; not reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：{M} 之 {COUNT} 项声明中之 {count} 项，余者由其姊妹记录引用，公理报告皆空。由一 AI 代理起草；'
              f'另一 AI 代理作独立只读审查（REVIEW-UE18），修订采其探针，并复查，见研究第 {N} 节；未经人审。'})


title_a = capped('title', {'en': 'The Markov blanket as a coupling structure', 'zh': '马尔可夫毯作为耦合结构'})
statement_a = capped('statement', {
    'en': "On a determined law of internal, sensory, active and external parts, the agent's course is fixed by its "
          "start and its sensory course, bounded by what the sensory part reads of the world; so, with any model and "
          "policy, a supply read by threshold only is unseen before the break registers.",
    'zh': '于内部、感官、主动与外部四部分之确定律，主体之历程由其起点与感官历程所定，受感官部分所读之外界所限；故无论模型与策略，唯以阈读之供给于断裂登记前不可见。'})
hypotheses_a = [capped('hypotheses', x, item=True) for x in (
    {'en': "No axiom. Four parts of any types of one determined law, the internal and active parts reading the internal, "
           "sensory and active parts, the sensory and external parts the sensory, active and external parts.",
     'zh': '不加公理。一确定律之任意类型之四部分，内部与主动部分读内部、感官与主动部分，感官与外部部分读感官、主动与外部部分。'},
    {'en': "For the lumping law, the sensory part reads the external part only through a given map; for the witness, the "
           "supply drains by one and no action changes it, read by the threshold of need one.",
     'zh': '归并之律需感官部分唯经一所给映射读外部部分；于例，供给每步减一，无行动改之，以需求一之阈读之。'},
    {'en': "Modelling choices: discrete synchronous steps; the blanket as sparse coupling of a determined law, not "
           "conditional independence of a stationary density; for the join, the witness's supply as one condition of a "
           "web at need one.",
     'zh': '建模之选：离散同步之步；毯为确定律之稀疏耦合，非平稳密度之条件独立；于相接，例之供给为需求一之网之一条件。'})]
does_not_show_a = [capped('does_not_show', x, item=True) for x in (
    {'en': "Densities, the Helmholtz decomposition, nonequilibrium steady states, or that statistical and dynamical "
           "blankets coincide.",
     'zh': '密度、Helmholtz 分解、非平衡稳态，或统计之毯与动力之毯相合。', 'kind': 'scope'},
    {'en': "A World formation in general as the agent of a blanketed law: the join is proved for the witness only.",
     'zh': '一般之世界形成作为毯化之律之主体：相接只于例中得证。', 'kind': 'scope'},
    {'en': "Any free energy, or that a threshold-reading policy cannot draw on a larger supply.",
     'zh': '任何自由能，或以阈读之策略不能取用更大之供给。', 'kind': 'scope'},
    {'en': "That the principle is wrong: no sentence of its literature is forbidden here.",
     'zh': '原理有误：此处不禁其文献之任何语句。', 'kind': 'non-implication'})]
next_delta_a = capped('next_delta', {
    'en': "A World formation in general as the agent of a blanketed law, its sensory course its own course; the "
          "threshold-reading policy unable to draw on a larger supply; review by a person.",
    'zh': '一般之世界形成作为毯化之律之主体，其感官历程即其自身历程；以阈读之策略不能取用更大之供给；人之审查。'})
correspondence_a = capped('correspondence', {
    'en': "The free-energy principle's partition (Friston 2013; Kirchhoff, Parr, Palacios, Friston and Kiverstein 2018) "
          "on a determined law: the deterministic case of the time-unrolled Markov blanket (Virgo, Rosas and Biehl "
          "2022, Behavioral and Brain Sciences 45), the sensory and active courses Pearl's blanket (1988) of the "
          "internal course in the unrolled graph, the partition what Bruineberg, Dołęga, Dewhurst and Baltieri (2022) "
          "call a Friston blanket. Statistical and dynamical blankets need not coincide (Biehl, Pollock and Kanai 2021; "
          "Aguilera, Millidge, Tschantz and Buckley 2022). Self-evidencing blind to its break coming is T6's invisible "
          "half (runaway-distance-uncoupled) on a blanketed agent. Graded in UE18's NOTE.",
    'zh': '自由能原理之划分（Friston 2013；Kirchhoff、Parr、Palacios、Friston、Kiverstein 2018）于确定律：时间展开之马尔可夫毯之确定情形（Virgo、Rosas、'
          'Biehl 2022，Behavioral and Brain Sciences 45），感官与主动历程即展开图中内部历程之 Pearl 毯（1988），其划分即 Bruineberg、Dołęga、Dewhurst、'
          'Baltieri（2022）所称 Friston 毯。统计之毯与动力之毯未必相合（Biehl、Pollock、Kanai 2021；Aguilera、Millidge、Tschantz、Buckley 2022）。'
          '自证不见其断裂之将至，即 T6 不可见之半于毯化之主体（runaway-distance-uncoupled）。分级见 UE18 之 NOTE。'})
counterexamples_a = [
    {'en': "From a supply of three and of four or more, with any model and policy, the internal courses agree up to step "
           "four and at step five the first has ended (ThresholdDrain.any_model).",
     'zh': '自供给三与不少于四之供给，无论模型与策略，至第四步内部历程相同，第五步前者已终结（ThresholdDrain.any_model）。'},
    {'en': "An internal part reading nothing has one course while the blankets differ (Deaf.lumps).",
     'zh': '不读任何物之内部部分，毯异而其历程相同（Deaf.lumps）。'}]

title_b = capped('title', {'en': 'What the existence claim forbids', 'zh': '存在之主张所禁者'})
statement_b = capped('statement', {
    'en': "The point weighting on an outcome is conditioning on it, under which every listed course is of least "
          "surprisal and every event off it weighs nothing; a listed outcome has the share nothing exactly where its "
          "weight is nothing.",
    'zh': '置于一结果之点权重即以之为条件，其下每一列出之历程惊异最小，其外之事件权重为零；列出之结果份额为零，恰当其权重为零。'})
hypotheses_b = [capped('hypotheses', x, item=True) for x in (
    {'en': "No axiom. Natural weightings of listed outcomes, equality of outcomes decided; for the occupation weighting, "
           "a run's first n states.",
     'zh': '不加公理。列出之结果之自然数权重，结果之相等可判定；于占据权重，运行之前 n 状态。'},
    {'en': "Modelling choices: surprisal read as the reciprocal share, with no logarithm; a course's weighting read off "
           "it as the point weighting, a steady state's as the occupation weighting.",
     'zh': '建模之选：惊异读作倒数份额，无对数；历程之权重读作点权重，稳态之权重读作占据权重。'})]
does_not_show_b = [capped('does_not_show', x, item=True) for x in (
    {'en': "The principle's own density, a steady-state density of a stochastic law, or its Helmholtz decomposition.",
     'zh': '原理自身之密度、随机律之稳态密度或其 Helmholtz 分解。', 'kind': 'scope'},
    {'en': "That the principle is empty: its proponents concede it is not falsifiable alone, and its content lies in the "
           "models it is construed with.",
     'zh': '原理为空：其倡导者承认其单独不可证伪，其内容在其所解释之模型。', 'kind': 'non-implication'},
    {'en': "The claim's average form, the weighting read off a course maximizing its likelihood, in counting form.",
     'zh': '主张之平均形式（读自历程之权重使其似然最大）之计数形式。', 'kind': 'scope'})]
next_delta_b = capped('next_delta', {
    'en': "The average form in counting form, N^N·∏ a^n ≤ A^N·∏ n^n (the bound UE17 states over the reals); review by a "
          "person.",
    'zh': '平均形式之计数形式 N^N·∏ a^n ≤ A^N·∏ n^n（UE17 于实数上所述之界）；人之审查。'})
correspondence_b = capped('correspondence', {
    'en': "The existence claim (Friston 2013; 2019, arXiv:1906.10184): whatever persists appears to minimize free "
          "energy. Its proponents class it with principles of stationary action, not falsifiable strictly speaking "
          "(Ramstead and others 2023, Interface Focus 13); Andrews (2021) defends it as a formal structure whose content "
          "lies in its models; the critics' worry is breadth (Raja and others 2021; Bruineberg and others 2022). The "
          "counting form here is near-definitional and conceded. Graded in UE18's NOTE.",
    'zh': '存在之主张（Friston 2013；2019，arXiv:1906.10184）：凡持存者皆显若最小化自由能。其倡导者归之于驻定作用之原理，严格言之不可证伪（Ramstead 等 2023，'
          'Interface Focus 13）；Andrews（2021）辩之为形式结构，其内容在其模型；批评者所忧在其宽泛（Raja 等 2021；Bruineberg 等 2022）。此处之计数形式近乎定义，'
          '且为所承认。分级见 UE18 之 NOTE。'})
counterexamples_b = [
    {'en': "The ended threshold witness rests at a fixed point of its law (ThresholdDrain.short_rests); read as a steady "
           "state with a trivial blanket, the claim's antecedent holds of the ended system too.",
     'zh': '已终结之阈之例静止于其律之不动点（ThresholdDrain.short_rests）；读作具平凡之毯之稳态，主张之前件于已终结之系统亦成立。'}]


def lint_errors(rec):
    found = style.lint(rec)
    for f in found:
        print('lint:', rec['id'], f['severity'], f['field'], f['rule'], f['detail'])
    return [f for f in found if f['severity'] == 'error']


for rid, title, statement, laws, hypotheses, dns, cex, nd, corr, count in (
        (RIDA, title_a, statement_a, laws_a, hypotheses_a, does_not_show_a, counterexamples_a, next_delta_a,
         correspondence_a, len(cited_a)),
        (RIDB, title_b, statement_b, laws_b, hypotheses_b, does_not_show_b, counterexamples_b, next_delta_b,
         correspondence_b, len(cited_b))):
    assert not lint_errors({'schema_version': 2, 'id': rid, 'title': title, 'statement': statement, 'laws': laws,
                            'hypotheses': hypotheses, 'does_not_show': dns,
                            'counterexamples': [{'detail': x} for x in cex],
                            'validation_scope': validation(count), 'next_delta': nd, 'correspondence': corr})

if CAPS_ONLY:
    print(f'caps: ok; {len(cited_a)} + {len(cited_b)} declarations in {len(laws_a)} + {len(laws_b)} laws; statements',
          len(statement_a['en']), len(statement_a['zh']), len(statement_b['en']), len(statement_b['zh']),
          '; correspondences', len(correspondence_a['en']), len(correspondence_a['zh']), len(correspondence_b['en']),
          len(correspondence_b['zh']), '; laws max', max(len(x['en']) for x in laws_a + laws_b),
          max(len(x['zh']) for x in laws_a + laws_b))
    raise SystemExit(0)

common_refs = [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
               {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
               {'path': NOTE, 'role': 'integration', 'sha256': sha(NOTE)},
               {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
               {'path': CH3, 'role': 'statement', 'sha256': sha(CH3)}]
binding = [{'source': LEAN['Blanket'], 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/{M}',
            'success_pointer': '/status', 'success_value': 'passed'}]
history_new = {
    RIDA: {'en': f'{DATE_EN}: added (UE18), the Markov blanket as a coupling structure: the agent driven by its sensory '
                 f'course on a blanketed law, bounded by what the sensory part reads (lumping); with any model and '
                 f'policy a threshold-read supply unseen before the break registers, the witness joined to the World\'s '
                 f'coupling; after a review whose probe the revision adopted, and a re-check; study section {N}.',
           'zh': f'{DATE_ZH}：新增（UE18），马尔可夫毯作为耦合结构：于毯化之律主体由其感官历程所驱动，受感官部分所读所限（归并）；无论模型与策略，唯以阈读之供给'
                 f'于断裂登记前不可见，例与世界之耦合相接；经审查（修订采其探针）与复查；研究第 {N} 节。'},
    RIDB: {'en': f'{DATE_EN}: added (UE18), what the existence claim forbids: the point weighting conditioning on the '
                 f'outcome, every listed course of least surprisal under it and every event off it weighing nothing; the '
                 f'occupation weighting admitting every visited state; a listed outcome forbidden exactly where its '
                 f'weight is nothing; after a review and a re-check; study section {N}.',
           'zh': f'{DATE_ZH}：新增（UE18），存在之主张所禁者：点权重即以结果为条件，其下每一列出之历程惊异最小，其外之事件权重为零；占据权重容纳每一访问之状态；'
                 f'列出之结果被禁恰当其权重为零；经审查与复查；研究第 {N} 节。'},
}
dependencies = {
    RIDA: [{'id': RIDSEL, 'relation': 'formal-reuse',
            'detail': {'en': 'Web.AlikeThroughUpTo and Web.Admits: alike through a formation\'s couplings, and '
                             'admission at a need.',
                       'zh': 'Web.AlikeThroughUpTo 与 Web.Admits：经形成之耦合相同，及于一需求之容纳。'}},
           {'id': RIDLUMP, 'relation': 'formal-reuse',
            'detail': {'en': 'Learning.Lumped: a map read only through another.',
                       'zh': 'Learning.Lumped：唯经另一映射而读之映射。'}}],
    RIDB: [{'id': RIDCOND, 'relation': 'formal-reuse',
            'detail': {'en': 'restrict, share, mass_congr, mass_none and share_within: conditioning by restriction and '
                             'shares.',
                       'zh': 'restrict、share、mass_congr、mass_none 与 share_within：以限制为条件与份额。'}}],
}
aliases = {
    RIDA: ['The Markov blanket as a coupling structure', '马尔可夫毯作为耦合结构', 'Markov blanket', 'self-evidencing',
           'time-unrolled blanket', f'{M}.Blanketed.agent_through_sensory', f'{M}.ThresholdDrain.any_model'],
    RIDB: ['What the existence claim forbids', '存在之主张所禁者', 'existence claim', 'as-if reading',
           f'{M}.point_is_restrict', f'{M}.forbids_iff'],
}
spec = {RIDA: (title_a, statement_a, laws_a, hypotheses_a, does_not_show_a, counterexamples_a, next_delta_a,
               correspondence_a, cited_a, [LEAN['Admission'], LEAN['Testing'], LEAN['Learning']]),
        RIDB: (title_b, statement_b, laws_b, hypotheses_b, does_not_show_b, counterexamples_b, next_delta_b,
               correspondence_b, cited_b, [LEAN['ConditionalWeights']])}
for rid, (title, statement, laws, hypotheses, dns, cex, nd, corr, decl, lean) in spec.items():
    record = {
        'schema_version': 2, 'id': rid, 'title': title, 'kind': 'theorem', 'status': 'recorded-checked',
        'family': 'F01', 'reviewed_at_utc': NOW, 'statement': statement, 'laws': laws, 'hypotheses': hypotheses,
        'does_not_show': dns,
        'counterexamples': [{'path': LEAN['Blanket'], 'detail': x} for x in cex],
        'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'formal-not-empirical', 'names-provisional',
                                'omission-not-refutation'],
        'validation_scope': validation(len(decl)), 'next_delta': nd, 'correspondence': corr,
        'canonical_source': LEAN['Blanket'], 'aliases': aliases[rid], 'dependencies': dependencies[rid],
        'related': [{'id': RIDB if rid == RIDA else RIDA,
                     'detail': {'en': 'The free-energy principle\'s blanket and existence claim, stated in the same module.',
                                'zh': '同一模块所述之自由能原理之毯与存在之主张。'}}],
        'references': [{'path': LEAN['Blanket'], 'role': 'proof', 'declarations': sorted(decl),
                        'sha256': sha(LEAN['Blanket'])}]
                      + [{'path': p, 'role': 'proof', 'sha256': sha(p)} for p in lean] + common_refs,
        'proof_bindings': binding,
        'history': [history_new[rid]],
    }
    for dep in [x['id'] for x in record['dependencies']]:
        assert (RECORDS / f'{dep}.json').exists(), dep
    path = RECORDS / f'{rid}.json'
    assert not path.exists(), path
    path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print('record:', rid, len(decl), 'declarations in', len(laws), 'laws')


def load(rid):
    return json.loads((RECORDS / f'{rid}.json').read_text(encoding='utf-8'))


def save(rid, d):
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


RELATED = {
    RIDSEL: (RIDA, {'en': 'The Markov blanket as a coupling structure: on a blanketed law the agent is a selection through '
                          'its sensory course, joined to these couplings for a threshold witness.',
                    'zh': '马尔可夫毯作为耦合结构：于毯化之律主体为经其感官历程之选择，于阈之例与此耦合相接。'}),
    RIDRUN: (RIDA, {'en': 'The Markov blanket as a coupling structure: the distance to the break unseen by a blanketed '
                          'agent with any model and policy, reading its supply by threshold.',
                    'zh': '马尔可夫毯作为耦合结构：以阈读供给之毯化主体，无论模型与策略，皆不见至断裂之距离。'}),
    RIDU1: (RIDA, {'en': 'The Markov blanket as a coupling structure: in the agent form no action need be listed among what '
                         'couples in.',
                   'zh': '马尔可夫毯作为耦合结构：于主体之形式，无需将行动列于所耦合者之中。'}),
    RIDCOND: (RIDB, {'en': 'What the existence claim forbids: the point weighting read off a course is this restriction '
                           'to the course itself.',
                     'zh': '存在之主张所禁者：读自一历程之点权重，即限于该历程本身之此限制。'}),
    RIDFE: (RIDB, {'en': 'What the existence claim forbids: the claim with the model read off the course, in counting '
                         'form; its average form is this bound.',
                   'zh': '存在之主张所禁者：模型读自历程之主张之计数形式；其平均形式即此界。'}),
}
for rid, (new, detail) in RELATED.items():
    d = load(rid)
    assert new not in [x['id'] for x in d['related']]
    d['related'].append({'id': new, 'detail': detail})
    d['history'].append({'en': f'{DATE_EN}, board item UE18 (study section {N}): related to {new}; no statement, next '
                               f'step or declaration changed.',
                         'zh': f'{DATE_ZH}，工作板条目 UE18（研究第 {N} 节）：与 {new} 相关联；无一陈述、下一步或声明改变。'})
    save(rid, d)
print('records related here:', ', '.join(RELATED))
