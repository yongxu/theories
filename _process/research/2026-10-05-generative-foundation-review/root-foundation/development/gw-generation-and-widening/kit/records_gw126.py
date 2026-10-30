"""GW1, GW2 and GW6: the record changes, applied to the records in the worktree. Run from the repository root.

GW1 and GW2 join generation-and-degeneration-at-two-grains (the map's record; its owner's yes, WHAT-REMAINS,
"OU's decisions on U4 and on GW1-GW2"). GW6 is a record of its own, keeping-widening-is-generation-losing-nothing:
it joins the map's generation to 07's keeping widening, a claim distinct from what keeping widening needs.
The validation scope, reviewed time, receipt bindings and the study section are set at landing
(land_records_gw126.py); this script writes the laws, statements, boundaries, references and history.
Each text is checked against RESULT-WORKFLOW's limits. Idempotent only on the records as main holds them.
"""
import json
import sys
from pathlib import Path

R = Path('theories/becoming/results/records')
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
MR = f'{PKG}/Becoming/MapRegions.lean'
WM = f'{PKG}/Becoming/WideningOnTheMap.lean'
LIMITS = {'statement': (300, 150), 'laws': (420, 190), 'hypotheses': (420, 190),
          'does_not_show': (240, 110), 'next_delta': (400, 180)}
B = 'Becoming.'
SECTION = sys.argv[1] if len(sys.argv) > 1 else 'NNN'
DATE = f'30 October 2026, board item GW (study section {SECTION})'
DATE_ZH = f'2026年10月30日，工作板条目 GW（研究第 {SECTION} 节）'

FAILS = []


def check(field, text):
    en, zh = LIMITS[field]
    if len(text['en']) > en or len(text['zh']) > zh:
        FAILS.append((field, len(text['en']), en, len(text['zh']), zh, text['en'][:60]))
    return text


def law(en, zh, decls):
    return dict(check('laws', {'en': en, 'zh': zh}), declarations=[B + d for d in decls])


def add_refs(rec, path, decls):
    for ref in rec['references']:
        if ref['path'] == path and ref.get('role') == 'proof':
            ref['declarations'] = sorted(set(ref['declarations']) | {B + d for d in decls})
            return
    rec['references'].append({'path': path, 'role': 'proof', 'declarations': sorted(B + d for d in decls)})


def load(name):
    return json.loads((R / f'{name}.json').read_text(encoding='utf-8'))


def save(name, rec):
    assert not FAILS, FAILS
    (R / f'{name}.json').write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


# ---- GW1 and GW2: generation-and-degeneration-at-two-grains ----------------------------------
t = load('generation-and-degeneration-at-two-grains')
assert not any(B + '«后守»' in l['declarations'] for l in t['laws']), 'already applied'
t['statement'] = check('statement', {
    'en': 'At a fine and a coarse class and on branches, the pattern goes on along some branch or ends on every branch; generation and keeping exclude degeneration and can share a point; with keeping from some point on, excluded middle makes the regions cover; telling going on from ending is excluded middle.',
    'zh': '以细类与粗类同读、按分支读，样式或沿某支而延，或于诸支皆尽；生成与守皆排斥退化，且可共处一点；以守读为自某点起之守，排中使诸域周遍；分辨延与尽即排中。'})
split = law(
    'The split of a beginning. A carrying renewal begins no line of the pattern; where the pattern has a predecessor, a beginning of a part is the end of a carrying renewal; so a beginning of a part is, as far as can be refuted, a beginning of the pattern or the end of a carrying renewal. No order between the classes is assumed. Near-definitional.',
    '起始之分。传不起样式之线；样式有前处，部分之起即一传之端；故部分之起，在可驳之限内，或为样式之起，或为一传之端。不设二类之序。近乎定义。',
    ['«传则粗不生»', '«粗有前则生为传»', '«生则或粗生或传»'])
after = law(
    'Keeping from some point on (后守): along some branch the pattern goes on and, from a point of that branch reached from the start, no carrying renewal lies on it. Keeping gives it, and so does 全守 with the whole line as the branch; it goes on along its branch, so it excludes degeneration; where each occurrence conditions at most one other, it excludes generation.',
    '自某点起之守（后守）：沿某支样式而延，且自此支上自起点所及之一点起，支上无传。守给出之，全守以全线为支亦然；它沿其支而延，故排斥退化；每一事至多为另一事之缘处，它排斥生成。',
    ['«后守»', '«守则后守»', '«全守则后守»', '«后守则延»', '«后守退化不并»', '«单行则生成后守不并»'])
cover = law(
    'The regions cover. With excluded middle as a hypothesis every point is 生成, 后守 or 退化, and on single lines exactly one; that this holds at every point of every model is exactly excluded middle. A line that renews once and then stays is none of 生成, 守 and 退化 at its start, and is 后守 and 全守 there: the gap strict keeping leaves.',
    '诸域周遍。以排中为前提，每一点或生成、或后守、或退化，单行之上恰居其一；其于每一模型之每一点皆成立，恰即排中。一线更新一次而后静止，其起点不在生成、守、退化之任一，而为后守与全守：严格之守所留之隙。',
    ['«三域之周»', '«三域之定当且仅当排中»', 'Map.Stage', 'Map.once', 'Map.Once.func', 'Map.Once.renews',
     'Map.Once.third_not_renews', 'Map.Once.third_next', 'Map.Once.stays_third', 'Map.Once.family',
     'Map.Once.endless', 'Map.Once.not_generates', 'Map.Once.not_keeps', 'Map.Once.not_degenerates',
     'Map.Once.keeping', 'Map.Once.keepsAfter'])
lpo = law(
    'Telling whether a line keeps from some point on is deciding whether it stops renewing. On the steps under the one, read with the class of a sequence of truth values, 生成 at the first step is changing at arbitrarily late steps, 后守 being constant from some step on. Deciding 后守 for one sequence decides whether a given one ever holds (LPO), deciding 生成 gives only WLPO, and placing every sequence gives LPO.',
    '于一线上分辨其是否自某点起而守，即判定其是否止于更新。于一之下沿诸步、以一真值序列之类读之，首步生成即序列于任意晚处变，后守即自某步起不变。对一序列判定后守，即判定某序列是否曾真（对其之 LPO）；判定生成只得 WLPO；置每一序列于二者之一给出 LPO。',
    ['Map.«后守之定则LPO»', 'Map.«生成之定则WLPO»', 'Map.«生成后守之定则LPO»', 'Map.generates_iff_changes',
     'Map.keepsAfter_iff_settles', 'Map.step_func', 'Map.step_reached_le', 'Map.step_reaches',
     'Map.step_reaches_of_le', 'Map.step_family', 'Map.Settles.seen', 'Map.Settles.turning', 'Map.Settles.sequence',
     'Map.Settles.seen_succ', 'Map.Settles.seen_of_le', 'Map.Settles.seen_of', 'Map.Settles.seen_witness',
     'Map.Settles.sequence_seen', 'Map.Settles.sequence_unseen', 'Map.Settles.turning_turns'])
ix = next(i for i, l in enumerate(t['laws']) if B + '«单行则生守不并»' in l['declarations'])
t['laws'][ix + 1:ix + 1] = [split, after, cover, lpo]
t['hypotheses'][0] = check('hypotheses', {
    'en': 'None beyond the grammar: every carrier, every relation read as 缘, a fine and a coarse class; the covering laws take excluded middle as a hypothesis, and the calibration on a line reads sequences of truth values on the steps.',
    'zh': '除文法外无前提：每个载体、读作缘的每个关系、一个细类与一个粗类；覆盖之律以排中律为假设，一线上之校准读诸步上之真值序列。'})
t['does_not_show'].append(dict(check('does_not_show', {
    'en': 'That the three regions partition where lines branch: 生成 and 后守 overlap there, as 生成 and 守 do.',
    'zh': '分支之处三域互斥：其处生成与后守相重，如生成与守。'}),
    kind='non-implication', witness=B + 'Map.«生守相杂»'))
t['counterexamples'].append({'path': MR, 'detail': {
    'en': 'A line that renews once and then stays (Map.once) is, at its start, none of 生成, 守 and 退化, and is 后守 and 全守 (Map.Once.not_generates, Map.Once.not_keeps, Map.Once.not_degenerates, Map.Once.keepsAfter, Map.Once.keeping).',
    'zh': '一线更新一次而后静止（Map.once），其起点不在生成、守、退化之任一，而为后守与全守（Map.Once.not_generates、Map.Once.not_keeps、Map.Once.not_degenerates、Map.Once.keepsAfter、Map.Once.keeping）。'}})
for a in ['keeping from some point on', '后守', 'coverage of the regions', '三域之周']:
    if a not in t['aliases']:
        t['aliases'].append(a)
add_refs(t, MR, sorted({d[len(B):] for l in (split, after, cover, lpo) for d in l['declarations']}))
t['history'].append({
    'en': f'{DATE}: GW1 and GW2 in Becoming.MapRegions, a core leaf importing GrammarMap only: the split of a beginning on the root; keeping from some point on, with which excluded middle makes the regions cover and on single lines partition; the gap strict keeping leaves; on a single line, deciding keeping from some point on is LPO and deciding generation WLPO. Statement, four laws, the hypothesis, a does-not-show item and a counterexample changed.',
    'zh': f'{DATE_ZH}：GW1 与 GW2 于 Becoming.MapRegions（只导入 GrammarMap 之核心叶）：根上起始之分；自某点起之守，以之排中使诸域周遍、单行之上互斥；严格之守所留之隙；单行之上，判定后守即 LPO，判定生成即 WLPO。陈述、四律、前提、一项不示与一反例有变。'})
save('generation-and-degeneration-at-two-grains', t)

# ---- GW6: keeping-widening-is-generation-losing-nothing --------------------------------------
NEW = 'keeping-widening-is-generation-losing-nothing'
assert not (R / f'{NEW}.json').exists(), 'already applied'
grains = law(
    'The two places on a course\'s moments. Read along the next step with what is held at each moment as a chain of predicates, nothing lost is a preorder in the coarse place, whose line goes on exactly while nothing held is lost; a symmetric relation there could not tell loss from gain. The same possible is a class finer than it, and a line under it begins exactly where a step changes what is held.',
    '进程诸时刻上之两处。沿下一步读、各时刻所持为谓词之链，不失为居粗处之预序，其线恰于所持无所失时而延；对称之关系居此不能分失与得。同可能为细于它之类，其下之线恰起于一步改变所持之处。',
    ['Steps.includes', 'Steps.same', 'Steps.KeepsWideningFrom', 'Steps.same_class', 'Steps.same_includes',
     'Steps.includes_refl', 'Steps.includes_trans', 'Steps.begins_iff', 'Steps.reached_le', 'Steps.reaches_of_buqiong',
     'Steps.buqiong_includes_iff', 'Steps.includesFrom_iff'])
join = law(
    'The representation, both ways. Nothing lost is keeping widening\'s own inclusion half. Where each holding is refuted or unrefuted, keeping widening from a moment gives 全生成 at (nothing lost, the same possible), the step located with its point; where something new is found after each step after which not all held was held before, the converse holds; with neither, 全生成 gives nothing lost and such a step after each step.',
    '双向之表示。不失即持续扩大自身之含纳一半。各所持或被驳或未被驳处，自一时刻之持续扩大给出其处于（不失，同可能）之全生成，其步连同其点可定位；凡一步之后所持非皆先前所持处其新者可得，则反之亦然；二者皆无时，全生成给出不失及每步之后有此一步。',
    ['Steps.change_located', 'Steps.generation_of_keepsWidening', 'Steps.includes_not_back_of_generation',
     'Steps.keepsWidening_of_generation', 'Steps.generation_iff_keepsWidening', 'Steps.new_in_list_or_none',
     'Steps.found_of_listed', 'Steps.keepsWideningFrom_iff_shift', 'Steps.keepsWidening_iff_from_zero',
     'Steps.generation_of_reachingKeepsWidening'])
loss = law(
    'The join, parted by exactly loss. With both classes fixed apart, 全生成 at (nothing lost, the same possible) is 全生成 at (the one, the same possible) with nothing lost; so under the two premises keeping widening is generation under the one that loses nothing. A possible holding one point at each moment, lost at the next, is 全生成 under the one and keeps widening from none; one gaining a point at each step has both.',
    '恰以失而分之接。二类皆独立于扩大而定，于（不失，同可能）之全生成即于（一，同可能）之全生成加不失；故于二前提下，持续扩大即一之下不失之生成。各时刻持一点而于下一时刻失之之可能，于一之下全生成而自无一时刻起持续扩大；每步得一点者二者兼有。',
    ['Steps.generation_includes_iff', 'Steps.keepsWidening_iff_generation_losing_nothing', 'Steps.moving',
     'Steps.Moving.generation', 'Steps.Moving.not_generation_includes', 'Steps.Moving.not_keepsWidening',
     'Steps.growing', 'Steps.Growing.keepsWidening', 'Steps.Growing.generation'])
need = law(
    'What each premise says about the course. Generation is known by refutation, widening by exhibition. For every chain the forward direction is exactly weak excluded middle: the step generation names tells a proposition refuted or not. The converse is exactly excluded middle, and even on decided chains exhibiting the new point is Markov\'s principle, an unbounded search. Calibrations of the logic.',
    '各前提于进程所言。生成以驳而知，扩大以示而知。对每一链，正向恰为弱排中：生成所指之步告一命题被驳与否。逆向恰为排中；即于可判定之链，示其新点亦为 Markov 原理，即无界之搜寻。逻辑之校准。',
    ['Steps.forward_iff_wem', 'Steps.wem_of_generation_of_keepsWidening', 'Steps.twice', 'Steps.le_twice',
     'Steps.arriving', 'Steps.Arriving.includes', 'Steps.Arriving.early', 'Steps.Arriving.late',
     'Steps.Arriving.keepsWidening', 'Steps.Arriving.tells', 'Steps.back_iff_em',
     'Steps.dne_of_keepsWidening_of_generation', 'Steps.found_of_em', 'Steps.dawning', 'Steps.Dawning.generation',
     'Steps.marked', 'Steps.markov_of_keepsWidening_of_generation'])
world = law(
    'On the World, by name. Along each formation continuing itself, the World\'s keeping widening is the chain\'s, read on what the levels admit, from the landed chain law and the shift; so under the premises on admission it is 全生成 of the course\'s moments at (nothing lost, the same possible), both ways, while on the occurrences each formation admitted is 全守 from nothing lost alone: two carriers, not two grains of one.',
    '于世界上按名。沿每一构成自续，世界之持续扩大即诸水平所纳之链之持续扩大（由已落之链律与平移）；故于纳之前提下，它即进程诸时刻于（不失，同可能）之全生成，双向成立；而于诸事之上，所纳之每一构成仅由不失即全守：二载体，非一载体之两粒度。',
    ['Web.keepsWidening_itself_iff', 'Web.generation_of_keepsWidening_byName',
     'Web.keepsWidening_byName_iff_generation', 'Web.kept_by_name_and_generation_on_moments'])
laws = [grains, join, loss, need, world]
k = {
    'schema_version': 2,
    'id': NEW,
    'title': {'en': 'Keeping widening is generation that loses nothing', 'zh': '持续扩大即不失之生成'},
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F07',
    'reviewed_at_utc': None,
    'statement': check('statement', {
        'en': "On a course's moments, keeping widening is generation under the one that loses nothing, both ways under premises of deciding, so loss is what parts them; with nothing lost in the coarse place it is 全生成, a representation. The premises are exactly weak excluded middle forward and excluded middle back.",
        'zh': '于进程诸时刻，持续扩大即一之下不失之生成，于判定之前提下双向成立，故失即分二者者；以不失居粗处读之即全生成，为一表示。其前提恰为正向之弱排中与逆向之排中。'}),
    'laws': laws,
    'hypotheses': [check('hypotheses', {
        'en': 'Discrete moments read along the next step; what is held at a moment a predicate. The forward direction needs each holding refuted or unrefuted at each moment, weak excluded middle on what is held; the converse needs something new found after each step after which not all held was held before, which a listing of each moment\'s holding with deciding gives. The World law reads continuation by name.',
        'zh': '离散之时刻沿下一步读；一时刻之所持为一谓词。正向需各时刻之各所持或被驳或未被驳，即所持上之弱排中；逆向需凡一步之后所持非皆先前所持处其新者可得，各时刻所持可列而可判定时即然。世界之律按名读延续。'})],
    'does_not_show': [
        dict(check('does_not_show', {
            'en': "That keeping widening along a continuation other than by name is generation on the moments: only chains and the World by name.",
            'zh': '按名以外之延续上之持续扩大为诸时刻之生成：只及链与按名之世界。'}), kind='non-implication'),
        dict(check('does_not_show', {
            'en': 'That generation under the one is widening: a possible that moves changes at every step and loses all it held.',
            'zh': '一之下之生成即扩大：移动之可能每步皆变而失其所持。'}),
            kind='non-implication', witness=B + 'Steps.Moving.not_keepsWidening'),
        dict(check('does_not_show', {
            'en': 'That the iff at (nothing lost, the same possible) joins two notions fixed apart: nothing lost is keeping widening\'s own inclusion half.',
            'zh': '于（不失，同可能）之等价接合二独立之概念：不失即持续扩大自身之含纳一半。'}), kind='non-implication'),
        dict(check('does_not_show', {
            'en': 'That widening or generation is better: calling widening better is C\'s, and the comparison of two courses stays open.',
            'zh': '扩大或生成为更好：称扩大为更好属 C，二进程之比较仍待。'}), kind='non-implication'),
    ],
    'counterexamples': [{'path': WM, 'detail': {
        'en': 'A possible holding one point at each moment and losing it at the next is 全生成 at (the one, the same possible) at every moment, is 全生成 at (nothing lost, the same possible) at none, and keeps widening from none (Steps.Moving.generation, Steps.Moving.not_generation_includes, Steps.Moving.not_keepsWidening).',
        'zh': '各时刻持一点而于下一时刻失之之可能，于（一，同可能）每一时刻皆全生成，于（不失，同可能）无一时刻全生成，且自无一时刻起持续扩大（Steps.Moving.generation、Steps.Moving.not_generation_includes、Steps.Moving.not_keepsWidening）。'}}],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical',
                            'names-provisional', 'omission-not-refutation'],
    'validation_scope': None,
    'next_delta': check('next_delta', {
        'en': "Keeping widening along a continuation other than by name read on the moments, with what is kept read along the continuation; the comparison of two courses; review by a person.",
        'zh': '按名以外之延续上之持续扩大读于诸时刻，所守沿延续读之；二进程之比较；人之审查。'}),
    'correspondence': {
        'en': 'None claimed beyond the theory\'s own notions: the map\'s two grains (generation-and-degeneration-at-two-grains) and 07\'s keeping widening. Read informally, a possible that grows while nothing of it is lost is close to an adjacent possible that keeps expanding (Kauffman 2000); no statement of that literature is restated here.',
        'zh': '除本理论自有之概念外不称对应：图谱之两粒度（generation-and-degeneration-at-two-grains）与 07 之持续扩大。非正式读之，所失无而增长之可能近于不断扩张之邻近可能（Kauffman 2000）；此处不重述该文献之任何陈述。'},
    'canonical_source': WM,
    'aliases': ['keeping widening is generation that loses nothing', '持续扩大即不失之生成',
                'widening and generation joined both ways', '扩大与生成双向相接',
                'generation under the one that loses nothing', '一之下不失之生成',
                B + 'Steps.generation_iff_keepsWidening', B + 'Steps.keepsWidening_iff_generation_losing_nothing'],
    'dependencies': [
        {'id': 'generation-and-degeneration-at-two-grains', 'relation': 'formal-reuse', 'detail': {
            'en': '«全生成», «传» and «所及»: generation read at a fine and a coarse class.',
            'zh': '«全生成»、«传» 与 «所及»：以细类与粗类读之生成。'}},
        {'id': 'where-the-possible-grows', 'relation': 'formal-reuse', 'detail': {
            'en': 'Steps.generation_iff_begins: 全生成 under the one on the line of moments is a beginning after every moment.',
            'zh': 'Steps.generation_iff_begins：时刻之线上一之下之全生成即每一时刻之后皆有所起。'}},
        {'id': 'what-a-course-keeps-reachable', 'relation': 'formal-reuse', 'detail': {
            'en': 'Reaching.KeepsWidening and Web.keepsWidening_iff_chain: keeping widening as a chain of predicates, and by name as the chain shifted.',
            'zh': 'Reaching.KeepsWidening 与 Web.keepsWidening_iff_chain：以谓词之链读之持续扩大，按名即平移之链。'}},
        {'id': 'what-keeping-widening-needs', 'relation': 'formal-reuse', 'detail': {
            'en': 'Web.kept_of_includes_by_name: by name, on the occurrences, nothing lost gives 全守 and no occurrence is 全生成.',
            'zh': 'Web.kept_of_includes_by_name：按名，于诸事之上，不失给出全守，无一事全生成。'}},
    ],
    'related': [
        {'id': 'where-the-possible-grows', 'detail': {
            'en': 'Its law on the map, 全生成 at (the one, what is held) where the held possible keeps widening, runs one way; at (the one, the same possible) the reason is that the one does not count loss, and its held class is a further fine class, whose converse fails on Oscillating.',
            'zh': '其图谱上之律（持守时之可能持续扩大处于（一，所持守者）全生成）只一向；于（一，同可能），其故在一不计失；其所持之类更为细类，其逆于 Oscillating 失效。'}},
        {'id': 'what-keeping-widening-needs', 'detail': {
            'en': 'What keeping widening needs along a reading of formations, and the kind relay on which it and 全生成 hold together; here the join is exact on the moments.',
            'zh': '沿构成之读法持续扩大所需，及其与全生成并立之种类接力；此处于诸时刻之接为确切。'}},
    ],
    'references': [{'path': WM, 'role': 'proof',
                    'declarations': sorted({d for l in laws for d in l['declarations']})}],
    'proof_bindings': [],
    'history': [{
        'en': f'{DATE}: added (GW6), keeping widening read on the map: generation under the one that loses nothing, both ways under premises of deciding, so exactly loss parts the two; the representation at (nothing lost, the same possible); the premises calibrated as weak excluded middle and excluded middle; by name, kept on the occurrences while the moments generate; in Becoming.WideningOnTheMap, a core leaf.',
        'zh': f'{DATE_ZH}：新增（GW6），持续扩大读于图谱：于判定之前提下即一之下不失之生成，双向成立，故恰以失分二者；于（不失，同可能）之表示；前提校准为弱排中与排中；按名，于诸事上被守而诸时刻生成；于 Becoming.WideningOnTheMap（核心叶）。'}],
}
save(NEW, k)
print('records written; section', SECTION)
