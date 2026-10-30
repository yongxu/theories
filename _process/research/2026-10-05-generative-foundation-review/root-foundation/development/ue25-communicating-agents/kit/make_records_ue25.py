#!/usr/bin/env python3
"""UE25's records: the new record a-code-held-as-counts (Becoming.CountedCodes, home 05 §9 after imposing a code),
each declaration of the module cited once; and UE1's record capture-by-counted-choices brought to the fifth third part
(its correspondence names the record, a related entry, a history entry; no statement, next step or declaration
changed). Asserts the core receipt's hash of the module and its empty axiom reports, and the style caps and lint
(tools/research/style.py) on every field written. Mirrors RR's make_records_rr.py.
usage (from the checkout root, after the texts are in place): python3 -B make_records_ue25.py RECEIPT N
       python3 -B make_records_ue25.py --caps  (caps, lint and declaration cover against the kit's scratch audit;
                                                writes nothing)"""
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
RECEIPT_ID, N = ('20261031T000000.000000Z', 470) if CAPS_ONLY else (sys.argv[1], int(sys.argv[2]))
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RFD = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RFD + 'BECOMING-RENEWAL-READING.md'
WORK = RFD + 'development/ue25-communicating-agents/'
NOTE, REVIEW, RECHECK = WORK + 'NOTE.md', WORK + 'REVIEW-UE25.md', WORK + 'RECHECK-UE25.md'
SEARCH = RFD + 'development/ue1-fep-bridge/THIRD-PART-SEARCH.md'
CH5 = 'theories/becoming/chapters/05-COLLECTIVES.md'
PAGE = 'theories/becoming/FREE-ENERGY-PRINCIPLE.md'
LEAN = f'{PKG}/Becoming/CountedCodes.lean'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
RID, UE1 = 'a-code-held-as-counts', 'capture-by-counted-choices'
P = 'Becoming.CountedCodes.'


def sha(path):
    if CAPS_ONLY and not (ROOT / path).exists():
        return '0' * 64
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


OVER = []


def capped(field, pair, item=False):
    caps = style.ITEM_CAPS_V2 if item else style.CAPS_V2
    en, zh = caps[field][:2]
    if not (len(pair['en']) <= en and len(pair['zh']) <= zh):
        OVER.append((field, len(pair['en']), en, len(pair['zh']), zh, pair['en'][:60]))
    return pair


def lint_errors(rec):
    found = style.lint(rec)
    for f in found:
        print('lint:', rec['id'], f['severity'], f['field'], f['rule'], f['detail'])
    return [f for f in found if f['severity'] == 'error']


if CAPS_ONLY:
    audit = (HERE / 'tree/.build/BecomingCountedCodesAxiomAudit.lean').read_text(encoding='utf-8')
    names = set(re.findall(r'^#print axioms (\S+)$', audit, re.M))
else:
    core = json.loads((ROOT / RECEIPT).read_text())
    assert core['status'] == 'passed'
    assert core['source_sha256']['Becoming.CountedCodes'] == sha(LEAN)
    mod = next(x for x in core['modules'] if x['module'] == 'Becoming.CountedCodes')
    assert not any(mod['axiom_dependencies'].values())
    names = {d['name'] for d in mod['declarations']}
    audit = (HERE / 'tree/.build/BecomingCountedCodesAxiomAudit.lean').read_text(encoding='utf-8')
    assert names == set(re.findall(r'^#print axioms (\S+)$', audit, re.M)), 'the receipt and the kit\'s audit differ'


def law(en, zh, *decls):
    return capped('laws', {'en': en, 'zh': zh, 'declarations': [P + d for d in decls]}, item=True)


LAWS = [
    law("Counts and a unique greatest word: a belief gives each agent a count of each word for each meaning, in any "
        "order; a word is uniquely greatest where every other counts less. With the order irreflexive "
        "and transitive, two words are never both uniquely greatest; where a renaming is onto, a uniquely "
        "greatest word of renamed counts is carried to one of the counts; counts a renaming moving every word fixes "
        "have none.",
        "计数与唯一最大之词：信念予每主体于每义每词一计数，于任一序；一词为唯一最大，当他词皆严小于之。序非自反且传递时，二异词永不皆为唯一最大；"
        "改名为满射处，改名后之数之唯一最大词移为原数之一；改名移每词而不变之数无之。",
        'rename', 'UniqueGreatest', 'unique_greatest_not_two', 'unique_greatest_eq', 'unique_greatest_rename',
        'fixed_no_unique_greatest'),
    law("The relation: Renamed π σ X Y says that, count by count, Y is X with the agents exchanged by π and the "
        "words renamed by σ; a law keeping the exchange alone and the renaming alone keeps both together. In a "
        "state related to itself, where the renaming at a meaning is onto, an agent's uniquely greatest word, "
        "renamed, is that of the agent the exchange gives it; along the run of a law keeping the relation, at every "
        "step.",
        "关系：Renamed π σ X Y 谓逐数而言 Y 即 X 以 π 对换主体、以 σ 改名诸词；分保对换与改名之律合保二者。于自相关之态，一义处改名为满射时，"
        "一主体之唯一最大词经改名即对换所予主体之词；沿保此关系之律之运行，每步皆然。",
        'Renamed', 'keeps_both', 'unique_greatest_exchanged', 'unique_greatest_exchanged_run'),
    law("Never a shared uniquely greatest word: under a law keeping the relation, from a start related to itself, at "
        "a meaning where the renaming is onto and moves every word, two agents the exchange relates never hold one "
        "word as each one's uniquely greatest, the renaming need not be onto where the exchange is an involution; "
        "where the two hold the same counts there, those counts have none.",
        "永无共享之唯一最大词：于保此关系之律，始于自相关之态，于改名为满射且移每词之义，对换所关之二主体永不以一词各为其唯一最大；对换为对合时改名"
        "不必为满射；二者于彼处持同数，则其数无之。",
        'never_shared', 'never_shared_of_involution', 'shared_no_unique_greatest'),
    law("Joined to the code law: with the exchange an involution and the renaming onto, where each agent holds a "
        "uniquely greatest word at each meaning, the code of those words read off a state related to itself is a code "
        "related to itself in the code law's sense (SharedCodes.Relabels).",
        "接于码律：对换为对合且改名为满射，每主体于每义有唯一最大词处，自自相关之态读出之词码，依码律之义自相关（SharedCodes.Relabels）。",
        'read_relabels'),
    law("Learning from what is heard: each agent's new counts for a meaning come by a rule from its own counts "
        "and those of the agent it hears, the hearer given the meaning. This keeps the relation where the speaker map "
        "commutes with the exchange and the rule reads count by count and commutes with renaming; such a rule gives, "
        "from counts a renaming fixes, counts it fixes: a speaker it covers never names one word from a tie.",
        "由所闻而学：每主体于一义之新数，由一规则自其己数与所闻主体之数予之，闻者知其义。说者之映射与对换可交换、规则逐数而读且与改名可交换时，保此关系；"
        "此规则自改名所不变之数予其所不变之数，故其所涵之说者永不自平局名一词。",
        'hear', 'ReadsCountByCount', 'CommutesWithRenaming', 'hear_keeps', 'tied_hears_tied'),
    law("Adding what is heard in natural counts, the form of the principle's Dirichlet update, keeps the relation "
        "where the speaker map commutes with the exchange and what is heard reads count by count and commutes with "
        "renaming.",
        "于自然数之计数，加所闻之数（原理更新 Dirichlet 计数之形），说者映射与对换可交换、所闻逐数而读且与改名可交换时保此关系。",
        'addHeard', 'addHeard_keeps'),
    law("Adding the speaker's own counts, re-added unnormalized at every step, keeps the relation where the speaker "
        "map commutes with the exchange; with an involutive speaker map the two hold one model after one step and at "
        "every later step; with the exchange, an involution, as speaker map, from a start related to itself, that "
        "model has no uniquely greatest word where the renaming moves every word.",
        "加说者之己数（不归一，每步复加），说者映射与对换可交换时保此关系；说者映射为对合时二者一步后及其后每步持一模型；以对换（对合）为说者映射，"
        "始于自相关之态，改名移每词处其模型无唯一最大词。",
        'addSpeaker', 'addSpeaker_keeps', 'addSpeaker_shares', 'addSpeaker_shares_run', 'addSpeaker_tied'),
    law("Learning gated by the whole model: the counts heard enter with a weight the hearer's whole model gives, as an "
        "update weighted by the policy to update. Not of hear's form, since the weight reads every meaning, it keeps "
        "the relation where the speaker map commutes with the exchange, what is heard reads count by count and "
        "commutes with renaming, and the renaming leaves the weight unchanged.",
        "由全模型门控之学：所闻之数以闻者全模型所予之权入之，如以更新之策加权之更新。权读每义，故非 hear 之形；说者映射与对换可交换、所闻逐数而读且与"
        "改名可交换、改名不变其权时，保此关系。",
        'gatedHear', 'gatedHear_keeps'),
    law("Free-energy minimization is unchanged by a renaming that permutes the words: over a renamed listing the "
        "product of powers is that of the renamed weights and counts; totals and products of powers are unchanged by "
        "a permutation of the listing; so, over a listing the renaming permutes, a count belief reaches the bound in "
        "counts for some weights exactly where its renaming reaches it for the renamed weights.",
        "自由能最小化于置换诸词之改名下不变：于改名之列，幂之积即改名之权与数之幂之积；总和与幂之积于列之置换下不变；故于改名所置换之列，"
        "一计数信念于某权达计数之界，恰当其改名于改名之权达之。",
        'powerProduct_map', 'total_perm', 'powerProduct_perm', 'bound_invariant'),
    law("A minimizer under symmetric weights names no word: where the weights are unchanged by a renaming moving every "
        "word and their total is positive, a belief at the bound in counts over a listing of every word has no "
        "uniquely greatest word.",
        "对称之权下之最小者不名一词：权于移每词之改名下不变且总和为正时，于含每词之列达计数之界之信念无唯一最大词。",
        'minimizer_no_unique_greatest'),
    law("Joined to a run: under a law keeping the relation, from a start related to itself, where two exchanged agents "
        "hold the same counts for a meaning whose every word the renaming moves, a belief over which word to say at "
        "the bound for those counts as weights, over a listing of every word with a positive total, has no uniquely "
        "greatest word.",
        "接于运行：于保此关系之律，始于自相关之态，二对换主体于改名移每词之义持同数时，以其数为权、于含每词之列且总和为正、达界之言何词之信念无唯一最大词。",
        'shared_minimizer_no_unique_greatest'),
    law("Witness, a tie: two agents and two words, the exchange swapping the agents and the renaming the words, each "
        "an involution moving everything; opposite counts 2, 1 and 1, 2, related to themselves, each hold a uniquely "
        "greatest word, the two words different; one step of adding the speaker's counts gives both 3, 3, one model "
        "with no uniquely greatest word.",
        "见证（平局）：二主体二词，对换交换主体，改名交换诸词，皆为对合且移一切；相反之数 2, 1 与 1, 2 自相关，各有唯一最大词而二词相异；"
        "加说者之数一步，二者皆得 3, 3，一模型无唯一最大词。",
        'Witness.swap_involution', 'Witness.swap_moves', 'Witness.opposite', 'Witness.opposite_symmetric',
        'Witness.added_tie'),
    law("Witness, a preferred word: from no counts, related to themselves, a speaker saying the first word of "
        "greatest count, a tie going to the first word, with one count heard for the word said, brings both agents to "
        "hold that word as uniquely greatest after one hearing; that rule does not commute with renaming the words.",
        "见证（偏好之词）：始于无数（自相关），说者言数最大之首词，平局归首词，所闻为所言之词一数，一闻之后二主体皆以此词为唯一最大；此规则与改名诸词不可交换。",
        'Witness.zero', 'Witness.zero_symmetric', 'Witness.sayFirst', 'Witness.sayFirst_shared',
        'Witness.sayFirst_not_alike'),
    law("Witness, an asymmetric start: counts 1, 0 and 0, 0, which the exchange with the renaming does not relate to "
        "themselves, give both agents 1, 0 after one step of adding the speaker's counts, a shared uniquely greatest "
        "word.",
        "见证（不对称之始）：数 1, 0 与 0, 0（对换与改名不使之自相关），加说者之数一步后二主体皆得 1, 0，共享一唯一最大词。",
        'Witness.lead', 'Witness.lead_not_symmetric', 'Witness.asymmetric_shared'),
]
cited = [d for x in LAWS for d in x['declarations']]
assert len(cited) == len(set(cited)), 'a declaration cited twice'
assert set(cited) == names, (sorted(names - set(cited)), sorted(set(cited) - names))


def pair(en, zh, field, item=False, **extra):
    return capped(field, {'en': en, 'zh': zh, **extra}, item=item)


record = {
    'schema_version': 2, 'id': RID,
    'title': pair('A code held as counts, learned from what is heard', '以计数持之码，由所闻而学', 'title'),
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': pair(
        "Agents with counts, under a determined law keeping the exchange of agents with a renaming of words, stay "
        "related from a related start, so their uniquely greatest words differ where the renaming moves every word, "
        "onto or with the exchange an involution; learning from what is heard keeps the symmetry.",
        '于保对换主体并改名诸词之确定之律，始于自相关之态，凡改名移每词（满射，或对换为对合）处，持计数之主体永不共享唯一最大词；由所闻而学保此对称。',
        'statement'),
    'laws': LAWS,
    'hypotheses': [
        pair("Counts of each word for each meaning in any type with an order, irreflexive and transitive for the "
             "precision laws; natural counts for adding what is heard and for free energy, read as counts added to a "
             "common positive prior every renaming fixes.",
             '每义每词之计数于任一有序之型，精度之律需序非自反且传递；加所闻与自由能用自然数之计数，读作加于每一改名皆不变之公共正先验之数。',
             'hypotheses', item=True),
        pair("Discrete synchronous steps of a determined law; a renaming of the words for each meaning, the same at "
             "every step; relations of counts stated count by count, the pure core assuming no function "
             "extensionality.",
             '确定之律之离散同步之步；每义一改名，每步相同；数之关系逐数而陈，纯核不设函数外延性。', 'hypotheses', item=True),
        pair("Learning from what is heard: the hearer given the meaning; the speaker map commuting with the exchange; "
             "the rule reading count by count and commuting with renaming; for a weight on what is heard read off the "
             "whole model, the weight unchanged by the renaming.",
             '由所闻而学：闻者知其义；说者映射与对换可交换；规则逐数而读且与改名可交换；所闻之权读自全模型者，其权于改名下不变。', 'hypotheses', item=True),
        pair("For the headline: a law keeping the relation, a start related to itself, and at the meaning a renaming "
             "onto and moving every word, or moving every word with the exchange an involution.",
             '主律：保此关系之律、自相关之始，且于该义改名为满射并移每词，或对换为对合而改名移每词。', 'hypotheses', item=True),
        pair("For free energy: natural weights and counts over a listing the renaming permutes; for the minimizer, a "
             "listing of every word, weights the renaming fixes and a positive total.",
             '自由能：于改名所置换之列之自然数之权与数；最小者需含每词之列、改名所不变之权与正之总和。', 'hypotheses', item=True),
        pair("A unique greatest count as the reading of a word named for a meaning, weaker than the sparse, "
             "unambiguous mappings the principle calls precise; that no word is uniquely greatest holds in either "
             "sense.",
             '以唯一最大之数读一义所名之词，弱于原理所谓精确之稀疏无歧之映射；无词为唯一最大于二义皆成。', 'hypotheses', item=True),
    ],
    'does_not_show': [
        pair("That federated inference's own law over the reals, with its normalized predictive, its weighting by "
             "expected free energy and its forgetting, keeps the relation: that is a reading.",
             '联邦推断于实数之律（归一之预测、以期望自由能加权、遗忘）保此关系：此为读。', 'does_not_show', item=True,
             kind='non-implication'),
        pair("Speaking by sampling: reinforcement with sampled signals reaches a signalling system (Argiento and "
             "others 2009); no invariant law for sampled speech is stated here.",
             '以抽样而言：以抽样之信号强化达一信号系统（Argiento 等 2009）；此处不陈抽样之言之不变律。', 'does_not_show', item=True,
             kind='scope'),
        pair("The hearer inferring the meaning from the words; a renaming is then a symmetry only where it is the same "
             "for every meaning.",
             '闻者自词推其义；其时改名唯于每义皆同处为对称。', 'does_not_show', item=True, kind='scope'),
        pair("That a paper's simulation fails: federated inference starts from random parameters, and the duet, in "
             "continuous states, is not stated in these terms.",
             '某论文之模拟失败：联邦推断始于随机参数，二重唱处于连续状态，不以此诸语陈之。', 'does_not_show', item=True,
             kind='non-implication'),
        pair("How long agreement takes, which asymmetry actual conventions start from, or whether they form this way.",
             '相合需时几何、实际之约定始于何种不对称，或是否如此而成。', 'does_not_show', item=True, kind='scope'),
        pair("That Dirichlet concentration is precision in this sense: adding the speaker's counts re-adds them at "
             "every step, so the concentration grows with no new datum and no uniquely greatest word.",
             'Dirichlet 之集中即此义之精度：加说者之数每步复加之，故集中渐增而所闻未增、无唯一最大词。', 'does_not_show', item=True,
             kind='non-implication'),
        pair("Free energy over parameters or models; the counting form covers beliefs in counts.",
             '参数或模型上之自由能；计数形式仅涵计数之信念。', 'does_not_show', item=True, kind='scope'),
    ],
    'counterexamples': [
        {'path': LEAN, 'detail': {
            'en': "A preferred word breaks the symmetry: from no counts, saying the first word of greatest count brings "
                  "both agents to one uniquely greatest word, its rule not commuting with renaming "
                  "(Witness.sayFirst_shared, Witness.sayFirst_not_alike).",
            'zh': '偏好之词破对称：始于无数，言数最大之首词使二主体共一唯一最大词，其规则与改名不可交换（Witness.sayFirst_shared、Witness.sayFirst_not_alike）。'}},
        {'path': LEAN, 'detail': {
            'en': "An asymmetric start breaks it: counts 1, 0 and 0, 0 give both 1, 0 after one step of adding the "
                  "speaker's counts (Witness.lead_not_symmetric, Witness.asymmetric_shared).",
            'zh': '不对称之始破之：数 1, 0 与 0, 0 加说者之数一步后皆得 1, 0（Witness.lead_not_symmetric、Witness.asymmetric_shared）。'}},
    ],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical',
                            'names-provisional', 'omission-not-refutation'],
    'validation_scope': pair(
        "Pure core, every axiom report empty: CountedCodes imports SharedCodes and FreeEnergyCounting, a leaf; the "
        "relation stated count by count, with no function extensionality; permutations by Lean's List.Perm, its "
        "induction axiom-free; cancellation by Nat.eq_of_mul_eq_mul_right; the witnesses evaluate by rfl and decide. "
        "An independent adversarial review compiled the first round with ten probes, every finding taken, and a "
        "recheck of the second, its points taken.",
        '纯核，公理报告皆空：CountedCodes 引 SharedCodes 与 FreeEnergyCounting，为叶；关系逐数而陈，不设函数外延性；置换以 Lean 之 '
        'List.Perm，其归纳无公理；约去以 Nat.eq_of_mul_eq_mul_right；见证以 rfl 与 decide 求值。独立对抗审查以十探针编译首轮，所见皆取，复核次轮，其点皆取。',
        'validation_scope'),
    'next_delta': pair(
        "An invariant law for sampled speech, UE24's kernel law for the exchange of agents with a renaming of words; "
        "federated inference's law over the reals shown by a theorem to keep the relation; the hearer inferring the "
        "meaning; the time agreement takes; review by a person.",
        '抽样之言之不变律（UE24 之核律，于对换主体并改名诸词）；以定理示联邦推断于实数之律保此关系；闻者推其义；相合所需之时；人之审查。',
        'next_delta'),
    'correspondence': pair(
        "Curie's principle (1894) for codes held as counts: a symmetric cause, the start and the law, gives a symmetric "
        "effect. Conventions are equilibria symmetry does not select (Lewis 1969); signalling dynamics reach one by "
        "chance or an asymmetry (Skyrms 2010), with sampled reinforcement in the two-state Lewis game (Argiento, "
        "Pemantle, Skyrms and Volkov 2009). The Dirichlet update is the principle's learning of the likelihood "
        "(Friston, FitzGerald, Rigoli, Schwartenbeck, O'Doherty and Pezzulo 2016). AI reading: against language as an "
        "emergent property of free-energy minimization (Friston, Parr and others 2024), read universally, with the "
        "ecosystems paper's §4.1 (Friston, Ramstead and others 2024) as its general form; the paper's simulation, from "
        "random parameters, stands; the duet (Friston and Frith 2015) stays under the code law. The readings are the "
        "AI's, in development/ue25-communicating-agents/NOTE.md, the review in REVIEW-UE25.md.",
        '于以计数持之码之 Curie 原理（1894）：对称之因（始与律）予对称之果。约定为对称所不择之均衡（Lewis 1969）；信号之动力以偶然或不对称达之'
        '（Skyrms 2010），二态 Lewis 博弈中抽样之强化亦然（Argiento、Pemantle、Skyrms、Volkov 2009）。Dirichlet 之更新即原理之似然之学'
        '（Friston 等 2016）。AI 之读：反对普遍而读之「语言为自由能最小化之涌现性质」（Friston、Parr 等 2024），以生态系统论文 §4.1 为其一般形式；'
        '其模拟始于随机参数而立；二重唱留于码律之下。读法皆 AI 之读，载于 NOTE.md，审查见 REVIEW-UE25.md。',
        'correspondence'),
    'canonical_source': LEAN,
    'aliases': ['a code held as counts', '以计数持之码', 'counted codes', 'communicating agents in the principle\'s terms',
                'language as an emergent property of free-energy minimization', 'Becoming.CountedCodes.never_shared',
                'Becoming.CountedCodes.hear_keeps', 'Becoming.CountedCodes.bound_invariant'],
    'dependencies': [
        {'id': 'a-code-formed-between-formations', 'relation': 'formal-reuse', 'detail': {
            'en': 'Law.KeepsRelation and its run law, and SharedCodes.Relabels: the code law stated for counts, and '
                  'read_relabels reading the code of uniquely greatest words as a code related to itself in its sense.',
            'zh': 'Law.KeepsRelation 及其运行之律与 SharedCodes.Relabels：码律于计数之陈述，read_relabels 读唯一最大词之码为依其义自相关之码。'}},
        {'id': 'free-energy-bound-in-counts', 'relation': 'formal-reuse', 'detail': {
            'en': 'total, powerProduct and proportional_of_bound_eq: the bound in counts, its invariance under a '
                  'renaming permuting the words, and its minimizer under symmetric weights.',
            'zh': 'total、powerProduct 与 proportional_of_bound_eq：计数之界、其于置换诸词之改名下之不变，及对称之权下之最小者。'}},
    ],
    'related': [
        {'id': 'imposing-a-code-breaks-the-symmetry', 'detail': {
            'en': 'An imposed code breaks the symmetry by privileging forms; here a preferred word in the order of '
                  'speaking does (Witness.sayFirst_not_alike).',
            'zh': '所施之码以偏重诸形破对称；此处言之次序中之偏好之词亦然（Witness.sayFirst_not_alike）。'}},
        {'id': 'identical-cells-under-a-descent-treating-them-alike', 'detail': {
            'en': 'The same symmetry argument for identical cells: a third part of the principle\'s containment.',
            'zh': '同一细胞之同一对称论证：原理包含之第三部分。'}},
        {'id': 'identical-cells-under-noise', 'detail': {
            'en': 'Under noise the deterministic law gives way to an exchangeable law; for codes held as counts that '
                  'step is open.',
            'zh': '有噪声时确定之律让位于可交换之律；于以计数持之码此步尚开。'}},
        {'id': UE1, 'detail': {
            'en': 'A third part of the free-energy principle\'s containment: a statement of its literature, read as a '
                  'guarantee, that a landed law forbids on a model in its terms.',
            'zh': '自由能原理包含之第三部分：其文献之一陈述，读作保证，已落地之律于其语汇之模型上禁之。'}},
    ],
    'references': [{'path': LEAN, 'role': 'proof', 'declarations': sorted(cited), 'sha256': sha(LEAN)},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': NOTE, 'role': 'integration', 'sha256': sha(NOTE)},
                   {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                   {'path': RECHECK, 'role': 'integration', 'sha256': sha(RECHECK)},
                   {'path': CH5, 'role': 'statement', 'sha256': sha(CH5)},
                   {'path': PAGE, 'role': 'integration', 'sha256': sha(PAGE)},
                   {'path': SEARCH, 'role': 'integration', 'sha256': sha(SEARCH)}],
    'proof_bindings': [{'source': LEAN, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.CountedCodes',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{'en': f'{DATE_EN}: added (UE25), the code law for beliefs held as counts and learned from what is '
                       'heard, joined to the free-energy bound in counts; the fifth statement the principle\'s page '
                       'counts; after an independent adversarial review and a recheck, every finding taken; study '
                       f'section {N}.',
                 'zh': f'{DATE_ZH}：新增（UE25），以计数持之、由所闻而学之信念之码律，接于计数之自由能界；原理一页所计之第五陈述；'
                       f'经独立对抗审查与复核，凡所见皆取；研究第 {N} 节。'}],
}
assert not lint_errors({k: record[k] for k in ('schema_version', 'id', 'title', 'statement', 'laws', 'hypotheses',
                                               'does_not_show', 'validation_scope', 'next_delta', 'correspondence')}
                       | {'counterexamples': [{'detail': x['detail']} for x in record['counterexamples']]}), RID
for x in record['related'] + record['dependencies']:
    assert (RECORDS / f"{x['id']}.json").exists(), x['id']
assert not OVER, OVER
print(f'caps: {RID} ok; {len(cited)} declarations in {len(LAWS)} laws')

# --- UE1's record: the fifth third part ----------------------------------------------------------------------------------
path = RECORDS / f'{UE1}.json'
d = json.loads(path.read_text(encoding='utf-8'))
c = d['correspondence']
OLD_EN = 'identical cells, risk minimization and what seeking cannot separate.'
OLD_ZH = '同一细胞、风险最小化与探求所不能分者。'
assert c['en'].count(OLD_EN) == 1 and c['zh'].count(OLD_ZH) == 1
c['en'] = c['en'].replace(OLD_EN, 'identical cells, risk minimization, what seeking cannot separate and a code held '
                                  'as counts.')
c['zh'] = c['zh'].replace(OLD_ZH, '同一细胞、风险最小化、探求所不能分者与以计数持之码。')
assert RID not in [x['id'] for x in d['related']]
d['related'].append({'id': RID, 'detail': {
    'en': 'A code held as counts: the third part against language as an emergent property of free-energy minimization, '
          'read universally.',
    'zh': '以计数持之码：反对普遍而读之语言为自由能最小化之涌现性质之第三部分。'}})
d['history'].append({
    'en': f'{DATE_EN}, board item UE25 (study section {N}): related to {RID}; the correspondence names it among the '
          'containment\'s third parts; no statement, next step or declaration changed.',
    'zh': f'{DATE_ZH}，工作板条目 UE25（研究第 {N} 节）：与 {RID} 相关联；对应将其列于包含之第三部分；无一陈述、下一步或声明改变。'})
assert not lint_errors({k: d[k] for k in ('schema_version', 'id', 'title', 'statement', 'laws', 'hypotheses',
                                          'does_not_show', 'validation_scope', 'next_delta', 'correspondence')}
                       | {'counterexamples': [{'detail': x['detail']} for x in d['counterexamples']]}), UE1
print(f'caps: {UE1} ok')
if CAPS_ONLY:
    raise SystemExit(0)

path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record amended:', UE1)
out = RECORDS / f'{RID}.json'
assert not out.exists(), out
out.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', RID, len(cited), 'declarations in', len(LAWS), 'laws')
