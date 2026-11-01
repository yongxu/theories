#!/usr/bin/env python3
"""UE28's records: a-formations-couplings-as-its-blanket amended (no new record; home 03 §1 as before): six laws for a
formation's level as the internal part along one run, so that all 140 declarations of BlanketCouplings are cited once
in seventeen laws; the statement brought to the level within its cap; a hypothesis for the level's reading; the
correspondence's clause on single runs and the state-machine remark; does_not_show narrowed (the level is shown along
one run; other records, the world's clause across runs and self-bearing formations across runs stay open); next_delta;
validation_scope from the receipt with both items' reviews; the proof reference's declarations, all 140, with the new
hash, the receipt, and UE28's design and reviews as integration; a counterexample; an alias; a history entry. And the
blanket's record the-markov-blanket-as-a-coupling-structure: the does_not_show entry and next_delta UE27 wrote narrowed
the same way, and a history entry (no statement, law or declaration changed). Every old text is asserted as UE27 left
it, so a change stops the script. Asserts the core receipt's hash of BlanketCouplings and Blanket, the module's empty
axiom reports and that the receipt's declarations are the scratch audit's, and the style caps and lint
(tools/research/style.py) on every field written. Mirrors UE27's make_records_ue27.py.
usage (from the checkout root, after the texts are in place): python3 -B make_records_ue28.py CORE N
       python3 -B make_records_ue28.py --caps [PREVIEW]  (caps, lint and declaration cover against the scratch audit;
                                                writes nothing, or with PREVIEW the two records into that folder)
REVIEW-UE28-LANDING.md is cited where it exists; in a landing (CORE N) it must exist and LANDING_FINDINGS give its
count, unless UE28_REHEARSAL=1 (rehearse_ue28.sh), which lets a rehearsal run before the landing review."""
import datetime
import hashlib
import json
import os
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT))
from tools.research import style  # noqa: E402

CAPS_ONLY = sys.argv[1] == '--caps'
if CAPS_ONLY:
    CORE_ID_R, N = '20261101T000000.000000Z', 490
else:
    CORE_ID_R, N = sys.argv[1], int(sys.argv[2])
REHEARSAL = os.environ.get('UE28_REHEARSAL') == '1'
# the landing review's number of findings, in words, once REVIEW-UE28-LANDING.md is written (with its zh form)
LANDING_FINDINGS = ('eighteen', '十八')
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RFD = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RFD + 'BECOMING-RENEWAL-READING.md'
WORK = RFD + 'development/ue28-a-formations-level-as-the-internal-part/'
DESIGN, REVIEW, LEANREVIEW = WORK + 'DESIGN.md', WORK + 'REVIEW-UE28-DESIGN.md', WORK + 'REVIEW-UE28-LEAN.md'
LANDREVIEW = WORK + 'REVIEW-UE28-LANDING.md'
CH3 = 'theories/becoming/chapters/03-KNOWING.md'
PAGE = 'theories/becoming/FREE-ENERGY-PRINCIPLE.md'
LEAN = f'{PKG}/Becoming/BlanketCouplings.lean'
BLANKET = f'{PKG}/Becoming/Blanket.lean'
CORE_RECEIPT = f'{PKG}/becoming-checks/{CORE_ID_R}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
RID = 'a-formations-couplings-as-its-blanket'
BLANKET_RID = 'the-markov-blanket-as-a-coupling-structure'
P = 'Becoming.BlanketCouplings.'


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


audit = (HERE.parent / 'tree/.build/BecomingBlanketCouplingsAxiomAudit.lean').read_text(encoding='utf-8')
core_names = set(re.findall(r'^#print axioms (\S+)$', audit, re.M))
assert len(core_names) == 140, len(core_names)
COUNT = (99, 99)  # for --caps, counts of the width the receipt gives
if not CAPS_ONLY:
    core = json.loads((ROOT / CORE_RECEIPT).read_text())
    assert core['status'] == 'passed'
    assert core['source_sha256']['Becoming.BlanketCouplings'] == sha(LEAN)
    assert core['source_sha256']['Becoming.Blanket'] == sha(BLANKET)
    mod = next(x for x in core['modules'] if x['module'] == 'Becoming.BlanketCouplings')
    assert not any(mod['axiom_dependencies'].values())
    assert {d['name'] for d in mod['declarations']} == core_names, 'the receipt and the scratch audit differ'
    COUNT = (mod['theorems'], len(mod['declarations']))
landing_review = (ROOT / LANDREVIEW).exists()
if landing_review:
    assert LANDING_FINDINGS, 'REVIEW-UE28-LANDING.md exists: set LANDING_FINDINGS to its count'
elif not CAPS_ONLY:
    assert REHEARSAL, 'no REVIEW-UE28-LANDING.md: the landing waits for the landing review'
    print('rehearsal: REVIEW-UE28-LANDING.md not yet written; the record leaves it out')


def law(en, zh, *decls):
    return capped('laws', {'en': en, 'zh': zh, 'declarations': [P + d for d in decls]}, item=True)


def pair(en, zh, field, item=False, **extra):
    return capped(field, {'en': en, 'zh': zh, **extra}, item=item)


# --- the record as UE27 left it ------------------------------------------------------------------------------------
path_r = RECORDS / f'{RID}.json'
record = json.loads(path_r.read_text(encoding='utf-8'))
assert len(record['laws']) == 11, ('the record has', len(record['laws']), 'laws: UE28\'s laws already in?')
ue27_cited = [d for x in record['laws'] for d in x['declarations']]
assert len(ue27_cited) == 76 and set(ue27_cited) <= core_names, len(ue27_cited)
assert not any('UE28' in h['en'] for h in record['history'])
OLD_STATEMENT = ("Any model fed by what couples into a formation is by construction the agent of a blanketed law whose "
                 "sensory course is the formation's own course; a degenerate reading refutes no family whose law is "
                 "determined, while a sparse partition fixed apart from the family can be refuted by one run.")
assert record['statement']['en'] == OLD_STATEMENT, record['statement']['en']
OLD_ND = ("The formation's own record as the internal part of a blanketed law; a blanketed law for a family consistent "
          "part by part, with a choice at the readings no course shows; review by a person.")
assert record['next_delta']['en'] == OLD_ND, record['next_delta']['en']
assert len(record['hypotheses']) == 3 and len(record['does_not_show']) == 5 and len(record['counterexamples']) == 4


def dns_at(rec, en):
    at = [i for i, x in enumerate(rec['does_not_show']) if x['en'] == en]
    assert len(at) == 1, (rec['id'], en[:60], at)
    return at[0]


# --- the six laws --------------------------------------------------------------------------------------------------
NEW_LAWS = [
    law("With the step as the external part, one course is consistent part by part, and admitted by some law "
        "determined part by part, exactly where its agent is consistent: at any two steps alike on the internal, "
        "sensory and active states, the next internal and active states agree; the world's half holds of every such "
        "course; tested only where the three states recur (stepExternal_admitted_iff and three more).",
        "步为外部部分，则一历程逐部分一致、且为某逐部分确定之律所容，恰当其主体一致：于内部、感官与作为之态皆相同之任二步，次内部态与次作为态皆相合；世界之半于每一此历程皆成；"
        "唯于三态复现处受检（stepExternal_admitted_iff 等四项）。",
        'stepExternal', 'AgentConsistent', 'stepExternal_consistent_iff', 'stepExternal_admitted_iff'),
    law("Given functions for the next internal and active states at every step, the course is the course of a "
        "blanketed law whose internal part moves by the sensory state at its own step, whose sensory part is the "
        "given course at the next step and whose external part is the step; its world's side is the open loop at that "
        "course; the converse, the functions from consistency alone, is not stated (stepLaw, stepLaw_course).",
        "若诸函数于每步予次内部态与次作为态，则该历程为一毯化之律之历程，其内部部分依其本步之感官态而移，感官部分为下一步之所给历程，外部部分为步；其世界一侧为该历程之开环；"
        "逆向（仅由一致得诸函数）未陈（stepLaw、stepLaw_course）。",
        'stepLaw', 'stepLaw_course'),
    law("A value across steps: two levels at any two steps have one value exactly where they admit the formation "
        "alike, each at its step, and agree on what couples into it by level; it gives the values at each step "
        "(ValuesThrough), which compare one step only and which a value carrying the step meets; where admission is "
        "decided and the couplings listed, listed_values' value meets it (listed_valuesAcross and two more).",
        "跨步之值：任二步之二层级同值，恰当其各于其步同准入该形成，且于以层级耦合入者相合；其予每步之值（ValuesThrough），后者唯比一步，携步之值满足之；准入已定且耦合已列处，"
        "listed_values 之值满足之（listed_valuesAcross 等三项）。",
        'ValuesAcross', 'ValuesAcross.through', 'listed_valuesAcross'),
    law("One balanced run, read with a formation's level internal, a value across steps sensory, its act active "
        "and the step external, is admitted by some law determined part by part exactly where, at any two steps j "
        "and k alike on its level, admission, coupled levels and act, given at j plus taken at k equals given at k "
        "plus taken at j and next acts agree; tested only where these recur (levelParts_admitted_iff and six more).",
        "一平衡之运行，以一形成之层级为内部、跨步之值为感官、其作为为作为部分、步为外部而读，为某逐部分确定之律所容，恰当于其层级、准入、耦合入之层级与作为皆相同之任二步 j、k，"
        "j 之所予加 k 之所取等于 k 之所予加 j 之所取，且次作为相合；唯于诸态复现处受检（levelParts_admitted_iff 等七项）。",
        'next_level_alike_iff', 'levelParts', 'rowAct', 'presentRow', 'DecidesPresence',
        'agentConsistent_iff_exchange', 'levelParts_admitted_iff'),
    law("A drain in three phases fails the level's condition for every value across steps: nothing couples into "
        "the formation; the other relatum, whose level is its phase, takes one unit from the formation at its first "
        "phase and gives one at its second, balanced at every step; at steps 2 and 3 the formation's level, value "
        "and act agree and its next levels are one and nothing (PhasedDrain.not_admitted and twenty-three more).",
        "三相之耗于每一跨步之值皆不满足层级之条件：无物耦合入该形成；另一关系项（其层级即其相）于其第一相取该形成一单位、于第二相予之一单位，每步皆平衡；于第 2、3 步该形成之"
        "层级、值与作为相合，而次层级为一与无（PhasedDrain.not_admitted 等二十四项）。",
        'TwoRelata', 'TwoRelata.g_not_mem_h', 'PhasedDrain.phase', 'PhasedDrain.gLevel', 'PhasedDrain.hLevel',
        'PhasedDrain.hTakesG', 'PhasedDrain.hGivesG', 'PhasedDrain.hTakesH', 'PhasedDrain.hGivesH',
        'PhasedDrain.take', 'PhasedDrain.give', 'PhasedDrain.flow', 'PhasedDrain.level', 'PhasedDrain.web',
        'PhasedDrain.balance_g', 'PhasedDrain.balance_h', 'PhasedDrain.balances', 'PhasedDrain.uncoupled',
        'PhasedDrain.one_value', 'PhasedDrain.values', 'PhasedDrain.presence', 'PhasedDrain.presence_decides',
        'PhasedDrain.act', 'PhasedDrain.not_admitted'),
    law("A drain and feed in two phases meets the level's condition for any value, the level recurring: the other "
        "relatum, not coupling in, takes one unit when on and gives one when off, and the next level is fixed by the "
        "level. With the drain in three phases, whether what moves the level couples in does not decide the "
        "condition (Alternating.admitted and twenty-three more).",
        "二相之耗与供于任一值皆满足层级之条件，层级复现：另一关系项不耦合入，开时取一单位、关时予一单位，次层级由层级所定。与三相之耗并观，移层级者是否耦合入不定此条件"
        "（Alternating.admitted 等二十四项）。",
        'Alternating.phase', 'Alternating.gLevel', 'Alternating.hLevel', 'Alternating.hTakesG',
        'Alternating.hGivesG', 'Alternating.hTakesH', 'Alternating.hGivesH', 'Alternating.take', 'Alternating.give',
        'Alternating.flow', 'Alternating.level', 'Alternating.web', 'Alternating.balance_g', 'Alternating.balance_h',
        'Alternating.balances', 'Alternating.uncoupled', 'Alternating.values', 'Alternating.presence',
        'Alternating.presence_decides', 'Alternating.act', 'Alternating.gLevel_inj', 'Alternating.recurs',
        'Alternating.agentConsistent', 'Alternating.admitted'),
]
assert len(NEW_LAWS) == 6
LAWS = record['laws'] + NEW_LAWS
cited = [d for x in LAWS for d in x['declarations']]
assert len(cited) == len(set(cited)), 'a declaration cited twice'
assert set(cited) == core_names, (sorted(core_names - set(cited)), sorted(set(cited) - core_names))
core_cited = sorted(cited)
cc = f'{COUNT[0]} theorems in {COUNT[1]} declarations'
cc_zh = f'{COUNT[0]} 条定理，{COUNT[1]} 项声明'
if landing_review:
    REVIEWED = ("Reviewed by other AI agents, every finding taken: UE27's design, Lean and landing texts (fifteen, "
                f"fifteen and twenty-two findings) and UE28's (fifteen, thirteen and {LANDING_FINDINGS[0]})")
    REVIEWED_ZH = (f'他 AI 代理审之，凡所见皆取：UE27 之设计、Lean 与落地文本（十五、十五、二十二条），UE28 者（十五、十三、'
                   f'{LANDING_FINDINGS[1]}条）')
else:
    REVIEWED = ("Reviewed by other AI agents, every finding taken: UE27's design, Lean and landing texts (fifteen, "
                "fifteen and twenty-two findings) and UE28's design and Lean (fifteen and thirteen)")
    REVIEWED_ZH = '他 AI 代理审之，凡所见皆取：UE27 之设计、Lean 与落地文本（十五、十五、二十二条），UE28 之设计与 Lean（十五、十三条）'

# --- the amended fields --------------------------------------------------------------------------------------------
record['reviewed_at_utc'] = NOW
record['statement'] = pair(
    "A formation's couplings make any model they feed a blanketed agent; degenerate readings refute no determined "
    "family, sparse ones fixed apart can fail on one run; there, step external, its level is internal to a law "
    "determined part by part exactly where level, what couples in and act fix the next.",
    '一形成之耦合使以之为食之任一模型成毯化之主体；退化之读不驳律确定之族，独立而定之稀疏之读可为一运行所驳；于此，步为外部，其层级为某逐部分确定之律之内部，恰当层级、耦合入者与'
    '作为逐对定其次。',
    'statement')
record['laws'] = LAWS
record['hypotheses'].append(pair(
    "For a formation's level: one run of a World (World.of R L W), balanced where the exchange form is used, the "
    "step the external part; a value across steps (ValuesAcross), the step entering only through admission at each "
    "step; the act its rows on listed relata at the steps a presence course marks, which may decide where it takes "
    "part (DecidesPresence); amounts in Nat.",
    '形成之层级：一世界（World.of R L W）之一运行，用交换之形处平衡，步为外部部分；一跨步之值（ValuesAcross），步唯经各步之准入而入；作为为其于一参与历程所标之步、'
    '于所列关系项之行，该历程可定其参与与否（DecidesPresence）；量在 Nat。',
    'hypotheses', item=True))
OLD_OWN = "The formation's own record as the internal part: the agent is a model fed by what couples in."
record['does_not_show'][dns_at(record, OLD_OWN)] = pair(
    "A formation's records other than its level as the internal part: for these the agent is a model fed by what "
    "couples in.",
    '形成之层级以外之记录为内部部分：于此主体乃以耦合入者为食之模型。', 'does_not_show', item=True, kind='scope')
OLD_EXCHANGE = ("The World's own exchange as an environment: the World's case is the open loop, the closed loop a model "
                "beside it.")
record['does_not_show'][dns_at(record, OLD_EXCHANGE)] = pair(
    "The World's own exchange as an environment: the join's World case is the open loop, the closed loop a model "
    "beside it; along one run the level's reading carries the exchange in the level, the rest entering only "
    "through the step.",
    '世界自身之交换为环境：相接之世界情形为开环，闭环为其旁之模型；沿一运行，层级之读以层级载其交换，余者唯经步而入。', 'does_not_show', item=True,
    kind='scope')
OLD_FAMILY = ("A blanketed law for every family consistent part by part: a next state at every reading no course "
              "shows is needed.")
at_family = dns_at(record, OLD_FAMILY)
record['does_not_show'].insert(at_family, pair(
    "A formation's level as the internal part across a family of runs, or with the step off the world's side, "
    "where the world's half is a condition; for self-bearing formations, whose own level couples in, nothing beyond "
    "one run with the step.",
    '形成之层级于一族运行、或步不在世界一侧时为内部部分，此时世界之半成一条件；自持之形成（其自身层级耦合入）于一运行持步之外无所示。', 'does_not_show', item=True,
    kind='scope'))
record['does_not_show'][dns_at(record, OLD_FAMILY)] = pair(
    "A blanketed law for every family consistent part by part, or functions for a consistent course: a next state "
    "at every reading no course shows is needed.",
    '每一逐部分一致之族皆有毯化之律，或一致之历程有诸函数：需于无历程所示之每一读择一次态。', 'does_not_show', item=True, kind='scope')
record['counterexamples'].append({'path': LEAN, 'detail': {
    'en': "A drain in three phases: nothing couples into the formation and the run balances, yet at steps 2 and 3 its "
          "level, value and act agree and its next levels differ, so for every value across steps no law determined "
          "part by part admits the run read with its level internal (PhasedDrain.not_admitted).",
    'zh': '三相之耗：无物耦合入该形成，运行平衡，然于第 2、3 步其层级、值与作为相合而次层级相异，故于每一跨步之值，以其层级为内部而读之运行不为任何逐部分确定之律所容'
          '（PhasedDrain.not_admitted）。'}})
record['validation_scope'] = pair(
    f"Pure core, every axiom report empty (core receipt {CORE_ID_R}): BlanketCouplings ({cc}) imports Blanket, "
    "Histories and IdentificationRuns, a leaf; no decide. Near-definitional; the delta is the classification and, "
    f"for a formation's level, the condition on the World's exchange, pairwise. {REVIEWED}; study sections 488 and "
    f"{N}; not reviewed by a person.",
    f'纯核，公理报告皆空（核心回执 {CORE_ID_R}）：BlanketCouplings（{cc_zh}）引 Blanket、Histories 与 IdentificationRuns，为叶。'
    f'近乎定义；增量为分类，及形成之层级于世界之交换上之逐对条件。{REVIEWED_ZH}；研究第 488 与 {N} 节；未经人审。',
    'validation_scope')
record['next_delta'] = pair(
    "A formation's records other than its level as the internal part of a blanketed law; its level as that part "
    "across a family of runs, where the world's half is a condition, or along one run without functions given; a "
    "blanketed law for a family consistent part by part, with a choice at the readings no course shows; review by "
    "a person.",
    '形成之层级以外之记录为毯化之律之内部部分；其层级于一族运行（世界之半为条件）、或沿一运行而无所给之函数，为此部分；逐部分一致之族之毯化之律（于无历程所示之读择之）；'
    '人之审查。',
    'next_delta')
OLD_CORR_EN = ("since that blanket compares courses from one start, a single run constrains nothing under it. The "
               "single-run witness is of the kind of Hexagram.runsOrder_reads.")
OLD_CORR_ZH = '该毯比较同一起点之诸历程，故其下单一运行无所约束。单一运行之见证与 Hexagram.runsOrder_reads 同类。'
assert record['correspondence']['en'].count(OLD_CORR_EN) == 1 and record['correspondence']['zh'].count(OLD_CORR_ZH) == 1
record['correspondence'] = pair(
    "The principle defines a thing by its Markov blanket (Friston 2013, 2019; Kirchhoff and others 2018). That a "
    "blanket depends on how a partition is read is argued in words: Pearl's blankets, fixed within a model, against "
    "Friston's, read as a thing's boundary (Bruineberg, Dołęga, Dewhurst and Baltieri 2022). Wider: a formalism for "
    "any domain explains life and mind less than claimed (Raja and others 2021); statistical and dynamical blankets "
    "differ (Biehl, Pollock and Kanai 2021); its proponents concede the existence claim is not strictly falsifiable "
    "(Ramstead and others 2023). The coupling form is the deterministic time-unrolled blanket (Virgo, Rosas and "
    "Biehl 2022), which compares courses from one start, so a single run constrains nothing under it; a single run "
    "can refute a law the same at every step on the agent's side, which that blanket does not require, read by a "
    "partition fixed apart (ReadsExternal, of Hexagram.runsOrder_reads' kind; for a formation's level, "
    "PhasedDrain). The level's condition is the elementary one for one trajectory of a time-invariant "
    "deterministic state machine, here on the World's exchange. AI reading: which blanket a thing has is how its "
    "parts are read.",
    '原理以马尔可夫毯定一物（Friston 2013、2019；Kirchhoff 等 2018）。毯依分之读法，已以言论之：Pearl 之毯定于模型之内，与 Friston 之毯读为物之界相对（Bruineberg、'
    'Dołęga、Dewhurst、Baltieri 2022）。更广：适用于任何领域之形式，于生命与心智所释较所称为少（Raja 等 2021）；统计与动力之毯不同（Biehl、Pollock、Kanai 2021）；'
    '倡之者认存在之主张严格言之不可证伪（Ramstead 等 2023）。耦合之形即确定之时间展开之毯（Virgo、Rosas、Biehl 2022），其比较同一起点之诸历程，故其下单一运行无所约束；'
    '而单一运行可驳主体一侧每步皆同（该毯不要求此）、以独立而定之分读之之律（ReadsExternal，与 Hexagram.runsOrder_reads 同类；形成之层级则 PhasedDrain）。层级之条件即'
    '单一轨迹合于时不变确定状态机之初等条件，此处陈于世界之交换。AI 之读：物有何毯，在其诸部分如何读。',
    'correspondence')
DEP = 'testing-within-couplings'
assert DEP not in {x['id'] for x in record['dependencies']}
record['dependencies'].append({'id': DEP, 'relation': 'formal-reuse', 'detail': {
    'en': "Flow.BalancedHistory and Web.CoupledInto: the balanced history the level's condition reads, and the "
          "coupling the witnesses deny.",
    'zh': 'Flow.BalancedHistory 与 Web.CoupledInto：层级之条件所读之平衡之史，及见证所否之耦合。'}})
record['aliases'] += ["a formation's level as the internal part", 'Becoming.BlanketCouplings.levelParts_admitted_iff']

# references: the proof's declarations, all 140, with the new hash; the receipt; UE28's design and reviews
refs = record['references']
proof = [r for r in refs if r['role'] == 'proof']
assert len(proof) == 1 and proof[0]['path'] == LEAN and len(proof[0]['declarations']) == 76
proof[0]['declarations'], proof[0]['sha256'] = core_cited, sha(LEAN)
receipt = [r for r in refs if r['role'] == 'receipt']
assert len(receipt) == 1 and receipt[0]['path'].startswith(f'{PKG}/becoming-checks/')
receipt[0]['path'], receipt[0]['sha256'] = CORE_RECEIPT, sha(CORE_RECEIPT)
for r in refs:
    if r['path'] in (STUDY, CH3, PAGE):  # the texts this landing changes, read against the record as written here
        r['sha256'] = sha(r['path'])
    elif r['role'] == 'integration':  # UE27's design and reviews: unchanged, so not rehashed
        assert r['sha256'] == sha(r['path']), ('a cited file drifted: read it', r['path'])
assert not any(WORK in r['path'] for r in refs)
at_ch3 = [i for i, r in enumerate(refs) if r['path'] == CH3]
assert len(at_ch3) == 1
ue28_refs = [{'path': p, 'role': 'integration', 'sha256': sha(p)} for p in (DESIGN, REVIEW, LEANREVIEW)]
if landing_review:
    ue28_refs.append({'path': LANDREVIEW, 'role': 'integration', 'sha256': sha(LANDREVIEW)})
refs[at_ch3[0]:at_ch3[0]] = ue28_refs
assert len(record['proof_bindings']) == 1
record['proof_bindings'][0]['receipt'] = CORE_RECEIPT
record['history'].append({
    'en': f'{DATE_EN}, board item UE28 (study section {N}): a formation\'s level as the internal part along one run, '
          'the step external: admitted by a law determined part by part exactly where its next level and act agree '
          'wherever its level, a value across steps of what couples in and its act agree, on the World\'s records '
          'an equation between what is given to it and taken from it at the two steps, tested only where these '
          'recur; a drain in three phases fails it, a drain and feed in two phases meets it; six laws (64 '
          'declarations) added, the statement, a hypothesis, the correspondence, does_not_show, a dependency and '
          'the next step brought to it; after reviews of the design and the Lean'
          + (' and of the landing texts' if landing_review else '') + ', every finding taken.',
    'zh': f'{DATE_ZH}，工作板条目 UE28（研究第 {N} 节）：形成之层级沿一运行为内部部分，步为外部：为某逐部分确定之律所容，恰当其层级、耦合入者跨步之值与作为相合之处，'
          '其次层级与次作为皆相合，于世界之记录即二步所予所取之等式，唯于诸态复现处受检；三相之耗不满足之，二相之耗与供满足之；新增六律（64 项声明），陈述、一前提、对应、'
          f'所不示、一依赖与下一步随之；经设计与 Lean ' + ('及落地文本' if landing_review else '') + '之审查，凡所见皆取。'})
LINTED = ('schema_version', 'id', 'title', 'statement', 'laws', 'hypotheses', 'does_not_show', 'validation_scope',
          'next_delta', 'correspondence')
assert not lint_errors({k: record[k] for k in LINTED}
                       | {'counterexamples': [{'detail': x['detail']} for x in record['counterexamples']]}), RID
assert len(record['does_not_show']) <= style.ITEM_CAPS_V2['does_not_show'][2]
assert len(record['hypotheses']) <= style.ITEM_CAPS_V2['hypotheses'][2]
for x in record['related'] + record['dependencies']:
    assert (RECORDS / f"{x['id']}.json").exists(), x['id']

# --- the blanket's record: the formation's own record narrowed -----------------------------------------------------
path = RECORDS / f'{BLANKET_RID}.json'
d = json.loads(path.read_text(encoding='utf-8'))
assert not any('UE28' in h['en'] for h in d['history'])
OLD_B_DNS = ("A formation's own record as the internal part of a blanketed law: for any formation the agent is a model "
             "fed by what couples in (a-formations-couplings-as-its-blanket).")
d['does_not_show'][dns_at(d, OLD_B_DNS)] = pair(
    "A formation's other records, or its level across a family of runs, as the internal part of a blanketed law; "
    "along one run, a blanketed law for its level from the consistency condition alone "
    "(a-formations-couplings-as-its-blanket).",
    '形成之其他记录、或其层级于一族运行，为毯化之律之内部部分；沿一运行，仅由一致之条件得其层级之毯化之律（a-formations-couplings-as-its-blanket）。',
    'does_not_show', item=True, kind='scope')
OLD_B_ND = ("A formation's own record as the internal part of a blanketed law; the threshold-reading policy unable to "
            "draw on a larger supply; review by a person.")
assert d['next_delta']['en'] == OLD_B_ND, d['next_delta']['en']
d['next_delta'] = pair(
    "A formation's records other than its level as the internal part of a blanketed law; its level as that part "
    "across a family of runs, or along one run from the consistency condition alone, without functions given; the "
    "threshold-reading policy unable to draw on a larger supply; review by a person.",
    '形成之层级以外之记录为毯化之律之内部部分；其层级于一族运行、或沿一运行仅由一致之条件而无所给之函数，为此部分；以阈读之策略不能取用更大之供给；人之审查。', 'next_delta')
assert RID in {x['id'] for x in d['related']}
d['history'].append({
    'en': f'{DATE_EN}, board item UE28 (study section {N}): a formation\'s own record as the internal part, not shown, '
          f'narrowed to its records other than its level and its level across a family of runs, its level along one '
          f'run being the internal part of a law determined part by part exactly where its next level and act agree wherever its level, what couples '
          f'in and its act agree ({RID}); next step brought to it; no statement, law or declaration changed.',
    'zh': f'{DATE_ZH}，工作板条目 UE28（研究第 {N} 节）：形成自身之记录为内部部分（未示）收窄为其层级以外之记录及其层级于一族运行，其层级沿一运行为某逐部分确定之律之内部部分，'
          f'恰当其层级、耦合入者与作为相合之处，其次层级与次作为皆相合（{RID}）；下一步随之；无一陈述、律或声明改变。'})
assert not lint_errors({k: d[k] for k in LINTED}
                       | {'counterexamples': [{'detail': x['detail']} for x in d['counterexamples']]}), BLANKET_RID
assert not OVER, OVER
print(f'caps: {RID} ok, {len(core_cited)} declarations in {len(LAWS)} laws (six new); {BLANKET_RID} ok')
if CAPS_ONLY and len(sys.argv) > 2:  # --caps PREVIEW: the two records written to PREVIEW for review
    preview = Path(sys.argv[2])
    preview.mkdir(parents=True, exist_ok=True)
    for rec in (record, d):
        (preview / f"{rec['id']}.json").write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n',
                                                  encoding='utf-8')
    print('preview written to', preview)
if CAPS_ONLY:
    raise SystemExit(0)

path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record amended:', BLANKET_RID)
path_r.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record amended:', RID)
