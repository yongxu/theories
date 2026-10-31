#!/usr/bin/env python3
"""LA4's formal part: two new records, homed in 05 §7 (texts_la4.py writes the anchors), and the regions of the
records and of the two modules.

* the-test-season-meets-the-optimum-laws: Becoming.OptimumSeason, the season LA4 trains on and the optimum laws it
  meets (F04, beside what-an-optimum-does-beyond-what-couples-in);
* a-commuting-learner-drives-no-unread-choice: Becoming.WeightedCommuting, the weighted form of the commuting law and
  what it fixes for a learner (F01, beside what-a-commuting-law-keeps-apart).

Every declaration a law cites is in the module's receipt entry (or, with --caps, in the tree's source); style caps
and lint (tools/research/style.py) run on both records.
usage (from the checkout root, after integrate_la4.py and texts_la4.py):
       python3 -B make_records_la4.py RECEIPT N REVIEW   (writes)
       python3 -B make_records_la4.py --caps REVIEW      (checks only; writes nothing; reads the kit's tree)
REVIEW is the review of the Lean and the texts, a path relative to the checkout root."""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
sys.path.insert(0, str(ROOT))
from tools.research import style  # noqa: E402

CAPS_ONLY = sys.argv[1] == '--caps'
if CAPS_ONLY:
    RECEIPT_ID, N, REVIEW = '20261030T000000.000000Z', 0, sys.argv[2]
else:
    RECEIPT_ID, N, REVIEW = sys.argv[1], int(sys.argv[2]), sys.argv[3]
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
KITD = RF + 'development/la4-formal/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
NOTE = KITD + 'NOTE.md'
DESIGN = 'experiments/drain-beyond-the-reward/DESIGN.md'
CH5 = 'theories/becoming/chapters/05-COLLECTIVES.md'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
SEASON, WEIGHTED = 'Becoming.OptimumSeason', 'Becoming.WeightedCommuting'
BOUNDARIES = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
              'omission-not-refutation']


def src(module):
    return f'{PKG}/Becoming/{module.split(".", 1)[1]}.lean'


def sha(path):
    if CAPS_ONLY and path.startswith(f'{PKG}/Becoming/'):
        path = KITD + 'tree/Becoming/' + path.rsplit('/', 1)[1]  # the sources are not yet in the package
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def source_names(path):
    """Declaration names of a source, read with its namespaces (the --caps check only)."""
    names, stack = set(), []
    for line in path.read_text(encoding='utf-8').split('\n'):
        m = re.match(r'namespace (\S+)', line)
        if m:
            stack.append(m.group(1))
            continue
        m = re.match(r'end (\S+)', line)
        if m and stack and stack[-1] == m.group(1):
            stack.pop()
            continue
        m = re.match(r'(?:theorem|def|structure|inductive|abbrev)\s+([A-Za-z_][A-Za-z0-9_.\']*)', line)
        if m:
            names.add('.'.join(stack + [m.group(1)]))
    return names


assert (ROOT / REVIEW).exists(), REVIEW
NAMES, COUNTS = {}, {}
if CAPS_ONLY:
    tree = ROOT / KITD / 'tree/Becoming'
    for module in (SEASON, WEIGHTED):
        NAMES[module] = source_names(tree / f'{module.split(".", 1)[1]}.lean')
        COUNTS[module] = (0, len(NAMES[module]))
else:
    core = json.loads((ROOT / RECEIPT).read_text(encoding='utf-8'))
    assert core['status'] == 'passed'
    for module in (SEASON, WEIGHTED):
        assert core['source_sha256'][module] == sha(src(module)), (module, 'hash')
        m = next(x for x in core['modules'] if x['module'] == module)
        assert not any(m['axiom_dependencies'].values()), (module, 'axioms')
        NAMES[module] = {d['name'] for d in m['declarations']}
        COUNTS[module] = (m['theorems'], len(NAMES[module]))
text5 = (ROOT / CH5).read_text(encoding='utf-8')


def q(prefix, *short):
    return [f'{prefix}.{s}' for s in short]


S = 'Becoming.Optimum.Season'
Wt = 'Becoming.Weighted'

season_laws = [
    ("The season as LA4's season.py runs it (a ground of ten renewing, at most four taken a step, a bay of six, two "
     "landing sites, ten steps): the ground's catch depends only on the takes asked of it, the bay gives the lesser of "
     "six and the fish asked of it, the landings depend only on the sites chosen, and any takes, any number of bay fish "
     "up to six and any number of landings up to ten combine in one season.",
     "季如 LA4 之 season.py 所运行（地十而更新，每步至多取四，湾六，二登陆之地，十步）：地之获只依所求于地之取，湾给六与所求鱼数之小者，"
     "登陆只依所择之地；任何取、至多六之湾鱼与至多十之登陆合于一季。",
     q(S, 'step', 'run', 'outcome', 'Eligible', 'run_caught', 'run_taken', 'run_landed', 'run_bay', 'takes_eq',
       'flagged', 'flagged_caught', 'flagged_asked', 'flagged_landings', 'outcome_ground', 'outcome_catch',
       'outcome_bay', 'outcome_site', 'eligible_of', 'eligible_parts')),
    ("The ground's best catch over a season is 34: a table of the best catch over n steps from each level is checked "
     "against every take at every level and step, bounds every run, and one season reaches it. So the catch is at most "
     "40, and at most 37 in a season leaving the bay at three or more.",
     "地一季之最佳获为 34：自每一水平 n 步之最佳获之表，于每一水平每一步对每一取查过，界住每一运行，且一季达之。故获至多 40，"
     "留湾三或以上之季至多 37。",
     q(S, 'ceiling', 'best', 'bellman', 'caught_le', 'best_ten', 'ground_le', 'topTakes', 'top_caught', 'catch_le',
       'bay_le', 'bay_catch', 'bay_catch_le', 'kept_catch_le')),
    ("The catch shares units with the bay, so every optimum of every order rising with the catch empties the bay. "
     "There is no room at the landing site: among the optima of the order by the catch alone are seasons landing "
     "beside the nests never and at every step, so an optimum need not stand at the site's least level.",
     "获与湾共享单位，故每一随获而升之序之每一最优皆空其湾。登陆之地无余地：只以获排序之最优中，有从不于巢旁登陆之季与每步皆登陆之季，故最优不必在此地之最低水平。",
     q(S, 'shared', 'drained_eligible', 'bay_drained', 'catchOrder', 'catch_rising', 'top_frontier', 'site_optima',
       'site_no_room', 'site_not_least')),
    ("Ranked by the ground's catch alone, the bay shares no units with what is ranked and has no room: the optima "
     "include a season keeping the bay at six and one emptying it.",
     "只以地之获排序时，湾与所排者不共享单位而无余地：最优中有留湾于六之季与空湾之季。",
     q(S, 'groundOrder', 'ground_rising', 'ground_bound', 'ground_frontier', 'unshared_optima', 'unshared_no_room')),
    ("Seven times the catch plus the bay left ranks eligible seasons exactly as the catch first and the bay second; "
     "that order rises with the catch, so the score's optima empty the bay.",
     "获之七倍加湾之余，排可选之季恰如先获后湾；此序随获而升，故此分之最优空其湾。",
     q(S, 'afterScore', 'afterOrder', 'lexOrder', 'lex_rising', 'seven_lt', 'after_iff', 'after_drained')),
    ("Valuing the catch only up to 26 does not rise with the catch, and its optima include a season keeping the bay at "
     "six and one emptying it.",
     "只计获至 26 者不随获而升，其最优中有留湾于六之季与空湾之季。",
     q(S, 'plateauOrder', 'plateau_not_rising', 'plateau_frontier', 'plateau_optima')),
    ("Over seasons with natural-number weights, the weighted bay left plus the weighted catch is at most 40 times the "
     "total weight, and the weighted catch plus three times the weight keeping the bay at three or more is at most 40 "
     "times it. So for a policy with rational probabilities, with ν the mean catch over 40 and p the probability of "
     "keeping, the mean bay left is at most 40(1 − ν), and ν ≤ 1 − 3p/40.",
     "于自然数加权之季上，加权之湾余加加权之获至多为总权之 40 倍；加权之获加留湾三或以上之权之三倍亦至多为其 40 倍。故对概率为有理数之策略，"
     "以 ν 为平均获除以 40、p 为留之概率，平均湾余至多 40(1 − ν)，且 ν ≤ 1 − 3p/40。",
     q(S, 'mass', 'mass_add', 'mass_le', 'mass_const', 'mix_bay_catch', 'keptMark', 'catch_kept_le', 'mix_kept')),
]

weighted_laws = [
    ("A weighted law goes from each configuration to finitely many successors, each with a weight of any type, no law "
     "of whose arithmetic is used. Where every weighted total over the successors of σ x is the total over those of x "
     "carried by σ, the expectation of any observable n steps on from σ x is that of the observable read through σ "
     "from x.",
     "加权之律自每一配置至有限多后继，各带任意类型之权，不用其算术之任何律。凡于 σ x 之后继上之每一加权总和，皆为 x 之后继经 σ 所携之总和时，"
     "任一可观测量自 σ x 起 n 步之期望，即经 σ 而读之可观测量自 x 起之期望。",
     q(Wt, 'total', 'total_congr', 'expect', 'Commutes', 'Commutes.carried')),
    ("From a configuration σ fixes, or from starting weights σ leaves unchanged, every observable's expectation equals "
     "its image's at every step; a deterministic law commuting with σ is a case.",
     "自 σ 所固定之配置，或自 σ 不改之起始之权出发，每一可观测量之期望于每一步皆等于其像之期望；与 σ 交换之决定性之律为其情形。",
     q(Wt, 'Commutes.fixed_expect', 'Unchanged', 'Commutes.start_expect', 'law', 'law_commutes')),
    ("A law drawing one of finitely many samples, with a weight read off the configuration, and moving by an update, "
     "commutes with σ where a map of the samples permutes them, a sample's weight at σ x is its image's weight at x, "
     "and the update at σ x is σ of the update at x from the image sample.",
     "自有限多样本中抽一、其权读自配置、依更新而移之律，于下述时与 σ 交换：样本之某一映射置换之，样本于 σ x 之权为其像于 x 之权，"
     "于 σ x 之更新为自像样本于 x 之更新之 σ。",
     q(Wt, 'over', 'total_map', 'over_congr', 'Commutes.of_samples')),
    ("Reinforcing, drawing a value in proportion to its count and adding one to it, commutes with exchanging the two "
     "values: from equal counts the expected counts stay equal at every step, yet a run drawing one value at every "
     "one of any number of steps has positive weight.",
     "强化之律，按计数之比抽一值并加一于其上，与二值之对换交换：自相等之计数，期望之计数每步皆相等；然任意步数中每步皆抽同一值之运行有正之权。",
     q(Wt, 'swap', 'Reinforcing.law', 'Reinforcing.commutes', 'Reinforcing.expect_equal', 'Reinforcing.oneSidedRun',
       'Reinforcing.oneSidedWeight', 'Reinforcing.oneSidedRun_eq', 'Reinforcing.oneSidedWeight_pos',
       'Reinforcing.oneSided')),
    ("Pooling, adding one to both values, commutes with the exchange; from counts of three and one, the share of the "
     "less-drawn value rises at every step and stays below one half.",
     "汇聚之律，加一于二值，与对换交换；自三与一之计数，较少者之份每步皆升而恒低于一半。",
     q(Wt, 'Pooling.step', 'Pooling.commutes', 'Pooling.run_counts', 'Pooling.share_rises',
       'Pooling.share_below_half')),
]

OPT_REC = 'what-an-optimum-does-beyond-what-couples-in'
COMM_REC = 'what-a-commuting-law-keeps-apart'
SEASON_REC = 'the-test-season-meets-the-optimum-laws'
WEIGHTED_REC = 'a-commuting-learner-drives-no-unread-choice'


def validation(module):
    t, d = COUNTS[module]
    return {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): {module}, {t} theorems '
              f'in {d} declarations, every declaration with an empty axiom report; the checker verifies core purity. '
              f'Reviewed before landing ({Path(REVIEW).name}); author review in study section {N}; not independently '
              f'reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：{module}，{d} 项声明中 {t} 条定理，公理报告皆空；检查器并核对核心纯净。'
              f'落地前经审（{Path(REVIEW).name}）；作者审查见研究第 {N} 节；未经人的独立审查。'}


def references(module, cited):
    refs = [{'path': src(module), 'role': 'proof', 'declarations': sorted(cited), 'sha256': sha(src(module))},
            {'path': REVIEW, 'role': 'review', 'sha256': sha(REVIEW)},
            {'path': NOTE, 'role': 'integration', 'sha256': sha(NOTE)},
            {'path': DESIGN, 'role': 'integration', 'sha256': sha(DESIGN)},
            {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
            {'path': CH5, 'role': 'statement', 'sha256': sha(CH5)}]
    if not CAPS_ONLY:
        refs.insert(1, {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)})
    return refs


def bindings(module):
    return [{'source': src(module), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/{module}',
             'success_pointer': '/status', 'success_value': 'passed'}]


def laws_of(module, laws):
    cited = set()
    for en, zh, decls in laws:
        missing = sorted(set(decls) - NAMES[module])
        assert not missing, (module, missing)
        assert not (set(decls) & cited), (module, 'cited twice', sorted(set(decls) & cited))
        cited |= set(decls)
    return [{'en': en, 'zh': zh, 'declarations': d} for en, zh, d in laws], cited


season_out, season_cited = laws_of(SEASON, season_laws)
weighted_out, weighted_cited = laws_of(WEIGHTED, weighted_laws)

season = {
    'schema_version': 2,
    'id': SEASON_REC,
    'title': {'en': "LA4's test season meets the optimum laws", 'zh': 'LA4 之检验季合于最优之律'},
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F04',
    'reviewed_at_utc': NOW,
    'statement': {
        'en': "In the season LA4 trains on, the catch shares units with the bay, so every optimum of every order rising "
              "with the catch empties the bay. The landing site, and the bay when only the ground's catch counts, give "
              "no room; ranked by the catch or the ground's alone, the optima include keeping and ending.",
        'zh': 'LA4 所训练之季中，获与湾共享单位，故每一随获而升之序之每一最优皆空其湾。登陆之地，及只计地之获时之湾，无余地；只以获或只以地之获排序者，其最优兼有留与尽。'},
    'laws': season_out,
    'hypotheses': [{
        'en': "No axiom. The season as season.py runs it: natural-number levels, the ground renewing by y + ⌊(y(10 − y) "
              "+ 5)/10⌋ capped at ten, a take capped at four and at the level, a bay giving one fish a step while it "
              "has any, ten discrete steps; the colony read as the bay left; weights are natural numbers.",
        'zh': '不加公理。季如 season.py 所运行：自然数之水平；地依 y + ⌊(y(10 − y) + 5)/10⌋ 更新，以十为顶；取以四与其水平为顶；'
              '湾有鱼时每步给一；十个离散之步；群落读作湾之余；权为自然数。'}],
    'does_not_show': [
        {'en': 'That a trained system drains the bay: these are laws of optima over the outcomes, and the clause on '
               'trained systems is what LA4 tests.',
         'zh': '训练出的系统耗尽其湾：此为结果上之最优之律，训练出的系统之条款是 LA4 所检验者。', 'kind': 'non-implication'},
        {'en': 'That the season stands for an actual fishery, bay or colony.',
         'zh': '此季代表实有之渔场、湾或群落。', 'kind': 'correspondence'},
        {'en': "Room over a course of steps with the learner choosing again at each: room here is over a season's "
               "outcomes.",
         'zh': '学习者每步重选之过程上之余地：此处之余地在一季之结果上。', 'kind': 'scope'}],
    'counterexamples': [],
    'standard_boundaries': BOUNDARIES,
    'validation_scope': validation(SEASON),
    'next_delta': {
        'en': "LA4's learner runs on a machine suited to them; a season whose bay renews; room over a course of steps.",
        'zh': 'LA4 之学习者于合宜之机器上运行；湾自更新之季；一过程之步上之余地。'},
    'correspondence': {
        'en': "LA4's season.py: its exhaustive checks of the season's outcomes agree with every law here; its count of "
              "the eligible outcomes is not restated, since the three parts give them. The rising and unshared cases "
              "are the two cases of what-an-optimum-does-beyond-what-couples-in's law on one constructed season: "
              "shared units with the catch, and no units shared with what is ranked.",
        'zh': 'LA4 之 season.py：其对季之结果之穷举查验与此处每一律相合；其可选结果之计数不重述，因三部分直接给出之。'
              '随获而升与不共享之二情形，是 what-an-optimum-does-beyond-what-couples-in 之律于一构造之季上之二情形：与获共享单位，'
              '与所排者不共享单位。'},
    'canonical_source': src(SEASON),
    'aliases': ["LA4's test season meets the optimum laws", 'LA4 之检验季合于最优之律', 'Becoming.Optimum.Season.bay_drained',
                'Becoming.Optimum.Season.site_no_room'],
    'dependencies': [
        {'id': OPT_REC, 'relation': 'formal-reuse',
         'detail': {'en': 'Optimum.Shared, Shared.room, least_of_shared, Room, Least, Rising and Rising.mono, with '
                          'Requirement.Frontier for the optima.',
                    'zh': 'Optimum.Shared、Shared.room、least_of_shared、Room、Least、Rising 与 Rising.mono，最优用 Requirement.Frontier。'}}],
    'related': [
        {'id': WEIGHTED_REC,
         'detail': {'en': "What a learner's symmetry fixes at the landing site, from a start preferring neither site.",
                    'zh': '学习者之对称自不偏任一地之起点于登陆之地所定者。'}}],
    'references': references(SEASON, NAMES[SEASON]),
    'proof_bindings': bindings(SEASON),
    'history': [{'en': f'{DATE_EN}: added (LA4, its formal part), the design\'s checks by enumeration restated as '
                       f'theorems; study section {N}.',
                 'zh': f'{DATE_ZH}：新增（LA4 之形式部分），设计中以穷举所作之查验重述为定理；研究第 {N} 节。'}],
}

weighted = {
    'schema_version': 2,
    'id': WEIGHTED_REC,
    'title': {'en': 'A commuting learner drives no choice whose values nothing it reads tells apart',
              'zh': '交换之学习者不驱动其所读皆不分二值之选择'},
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F01',
    'reviewed_at_utc': NOW,
    'statement': {
        'en': "Where a weighted law commutes with a map, every expectation n steps on from a configuration's image is "
              "that of the observable read through the map, so from a start the map leaves unchanged expectations "
              "stay symmetric. A sampling learner commutes where the map carries its weights and update.",
        'zh': '加权之律与一映射交换时，自一配置之像起 n 步之每一期望，即经此映射而读之可观测量之期望；故自映射不改之起点，期望每步皆对称。'
              '抽样之学习者，其权与更新为映射所携时即交换。'},
    'laws': weighted_out,
    'hypotheses': [{
        'en': 'No axiom. Weights of any type with addition, multiplication and zero, no law of them used; finitely many '
              'listed weighted successors; discrete steps; commuting, a fixed configuration or unchanged starting '
              'weights as each law names. The two witnesses use natural-number counts.',
        'zh': '不加公理。权为任意带加、乘与零之类型，不用其任何律；有限多列出之加权后继；离散之步；交换、固定之配置或不改之起始之权，'
              '如各律所列。二见证用自然数之计数。'}],
    'does_not_show': [
        {'en': "That a given learner commutes: its parametrization, baseline, optimizer and inputs are properties of "
               "its code, which LA4's mirror test checks.",
         'zh': '某一学习者交换：其参数化、基线、优化器与输入是其代码之性质，由 LA4 之镜像检验查之。', 'kind': 'correspondence'},
        {'en': "Anything of a single run: in Reinforcing, runs drawing one value for any number of steps have positive "
               "weight while the expectations stay equal.",
         'zh': '单一运行之任何事：强化之律中，任意步数皆抽同一值之运行有正之权，而期望仍相等。', 'kind': 'non-implication'},
        {'en': "That a choice the learner reads, though nothing rewards it, goes undriven: in LA4's exact flow an "
               "uncounted bay the policy reads rises.",
         'zh': '学习者所读而无所奖之选择不被驱动：LA4 之精确流中，策略所读而不计之湾上升。', 'kind': 'scope'},
        {'en': 'What a learner does from a start preferring one value, or that noise wears such a preference away '
               'beyond the Pooling witness.',
         'zh': '学习者自偏一值之起点所为，或噪声于汇聚之见证之外磨去此偏。', 'kind': 'scope'},
        {'en': 'That the weights are probabilities: they are of any type and need not sum to one.',
         'zh': '权为概率：权为任意类型，不必和为一。', 'kind': 'scope'}],
    'counterexamples': [],
    'standard_boundaries': BOUNDARIES,
    'validation_scope': validation(WEIGHTED),
    'next_delta': {
        'en': "LA4's mirror test on each Stage A family; erosion of a start's preference as a law of sampled gradient "
              "learners; groups of symmetries in the weighted form.",
        'zh': 'LA4 之镜像检验于第一阶段每一族；起点之偏之磨损作为抽样梯度学习者之律；加权形式中之对称群。'},
    'correspondence': {
        'en': "An equivariant Markov kernel keeps invariant expectations, standard in probability; here exact over "
              "finitely many weighted successors, with no law of the weights' arithmetic. Reinforcing is Pólya's urn. "
              "A policy-gradient learner meets the hypotheses for exchanging a choice's two values where nothing it "
              "reads tells them apart and its parametrization, baseline and optimizer treat them alike. Reading (the "
              "AI's): T3's second forbidden case, a systematic drive on a condition sharing no units with anything "
              "rewarded, as first worded, fails where the learner reads the condition: in LA4's exact flow an uncounted bay the "
              "policy reads rises. Stated for a choice whose values nothing rewarded and nothing the learner reads "
              "tells apart, it is a theorem in expectation from a start the exchange leaves unchanged, and stays "
              "conjectured from a start preferring one value.",
        'zh': '等变之马尔可夫核保持不变之期望，概率论中之常识；此处于有限多加权后继上精确成立，不用权之算术之任何律。强化之律即 Pólya 之瓮。'
              '策略梯度学习者，凡其所读皆不分一选择之二值、其参数化、基线与优化器同等对待之时，即合对换此二值之假设。读法（AI 的）：'
              'T3 之第二禁例，初述为对与任何所奖者皆不共享单位之条件之系统驱动，于学习者读此条件处不成立：LA4 之精确流中，策略所读而不计之湾上升。'
              '述为一选择之二值为所奖者与学习者所读者皆不分者，则自对换不改之起点，于期望中为定理；自偏一值之起点仍为猜想。'},
    'canonical_source': src(WEIGHTED),
    'aliases': ['A commuting learner drives no choice whose values nothing it reads tells apart',
                '交换之学习者不驱动其所读皆不分二值之选择', "what a learner's symmetry fixes",
                'Becoming.Weighted.Commutes.carried', 'Becoming.Weighted.Commutes.of_samples'],
    'dependencies': [
        {'id': COMM_REC, 'relation': 'formal-reuse',
         'detail': {'en': 'Law.Commutes, of which law_commutes makes the deterministic case, and Law.run for Pooling.',
                    'zh': 'Law.Commutes，law_commutes 以之为决定性之情形；汇聚之律用 Law.run。'}}],
    'related': [
        {'id': SEASON_REC,
         'detail': {'en': 'The season whose landing site this law settles for learners treating the sites alike.',
                    'zh': '此律为同等对待二地之学习者所定其登陆之地之季。'}},
        {'id': 'selection-through-a-model-of-the-options',
         'detail': {'en': 'Relabel.Equivariant.tied keeps a tie through an exchange in one selection; this law keeps '
                          'an expectation through an exchange along a weighted course.',
                    'zh': 'Relabel.Equivariant.tied 于一次选择中经对换保持并列；此律沿加权之过程经对换保持期望。'}}],
    'references': references(WEIGHTED, NAMES[WEIGHTED]),
    'proof_bindings': bindings(WEIGHTED),
    'history': [{'en': f"{DATE_EN}: added (LA4, its formal part), the law that settles which of the design's "
                       f"predictions follow from a learner's symmetry; study section {N}.",
                 'zh': f'{DATE_ZH}：新增（LA4 之形式部分），定设计之预测中何者出自学习者之对称之律；研究第 {N} 节。'}],
}

for record in (season, weighted):
    assert (RECORDS / f"{OPT_REC}.json").exists() and (RECORDS / f"{COMM_REC}.json").exists()
    for rel in record['related']:
        assert (RECORDS / f"{rel['id']}.json").exists() or rel['id'] in (SEASON_REC, WEIGHTED_REC), rel['id']
    for lang in ('en', 'zh'):
        assert len(record['statement'][lang]) <= style.STATEMENT_CAP[lang == 'zh'], (record['id'], lang,
                                                                                       len(record['statement'][lang]))
        assert len(record['title'][lang]) <= style.CAPS_V2['title'][lang == 'zh'], (record['id'], 'title', lang)
    for key, (en_cap, zh_cap, most) in style.ITEM_CAPS_V2.items():
        items = record.get(key, [])
        assert len(items) <= most, (record['id'], key)
        for item in items:
            assert len(item['en']) <= en_cap and len(item['zh']) <= zh_cap, (record['id'], key, item['en'][:50],
                                                                             len(item['en']), len(item['zh']))
    findings = style.lint(record)
    for f in findings:
        print('lint:', record['id'], f['severity'], f['field'], f['rule'], f['detail'])
    assert not [f for f in findings if f['severity'] == 'error'], record['id']
    if not CAPS_ONLY:
        assert f'id="r-{record["id"]}"' in text5, (record['id'], 'home anchor missing in 05')
        path = RECORDS / f"{record['id']}.json"
        assert not path.exists(), path
        path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

regions_path = ROOT / 'theories/becoming/results/data/regions.json'
regions = json.loads(regions_path.read_text(encoding='utf-8'))
new_records = {SEASON_REC: {'region': 'collective', 'base': 'general', 'note': "LA4's season; the optimum laws met"},
               WEIGHTED_REC: {'region': 'collective', 'base': 'general',
                              'note': "LA4; a weighted law commuting with a map keeps expectations"}}
new_modules = {SEASON: {'region': 'collective', 'base': 'general',
                        'note': "LA4: the season season.py runs, the optimum laws it meets (record " + SEASON_REC + ")"},
               WEIGHTED: {'region': 'collective', 'base': 'general',
                          'note': "LA4: the weighted commuting law and the sampling learner (record " + WEIGHTED_REC + ")"}}
for key, new in (('records', new_records), ('modules', new_modules)):
    for name, entry in new.items():
        assert regions[key].get(name) in (None, entry), (key, name)
        regions[key][name] = entry
    regions[key] = dict(sorted(regions[key].items()))
if not CAPS_ONLY:
    regions_path.write_text(json.dumps(regions, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')

print(f"{'checked' if CAPS_ONLY else 'written'}: {SEASON_REC} ({len(season_out)} laws, {len(season_cited)} cited of "
      f"{len(NAMES[SEASON])}), {WEIGHTED_REC} ({len(weighted_out)} laws, {len(weighted_cited)} cited of "
      f"{len(NAMES[WEIGHTED])}); regions of two records and two modules")
