#!/usr/bin/env python3
"""UE4 record: write eventual-widening (every declaration of Becoming.EventualWidening and
Becoming.EventualWideningInstances). Mirrors UE1's make_records_ue1.py.
usage (from the checkout root, after texts_ue4.py): python3 -B make_records_ue4.py RECEIPT N"""
import datetime
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT_ID, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
NOTE = RF + 'development/ue4-second-order/DESIGN.md'
CH7 = 'theories/becoming/chapters/07-SIGNIFICANCE.md'
MOD = f'{PKG}/Becoming/EventualWidening.lean'
INST = f'{PKG}/Becoming/EventualWideningInstances.lean'
REGIONS_LEAN = f'{PKG}/Becoming/Regions.lean'
CONTINUED = f'{PKG}/Becoming/ContinuedClasses.lean'
VERIFICATION = f'{PKG}/Becoming/Verification.lean'
HORIZON = f'{PKG}/Becoming/Horizon.lean'
WEIGHTINGS = f'{PKG}/Becoming/Weightings.lean'
ADMISSION = f'{PKG}/Becoming/Admission.lean'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
RID = 'eventual-widening'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
names_of = {}
for module, path in (('Becoming.EventualWidening', MOD), ('Becoming.EventualWideningInstances', INST)):
    assert core['source_sha256'][module] == sha(path), module
    mod = next(m for m in core['modules'] if m['module'] == module)
    assert not any(mod['axiom_dependencies'].values()), module
    names_of[module] = {d['name'] for d in mod['declarations']}
names = names_of['Becoming.EventualWidening'] | names_of['Becoming.EventualWideningInstances']
assert not (names_of['Becoming.EventualWidening'] & names_of['Becoming.EventualWideningInstances'])


def D(*short):
    out = ['Becoming.' + s for s in short]
    missing = [n for n in out if n not in names]
    assert not missing, missing
    return out


groups = [
    ("Eventual widening: one level path eventually widens another where, from some step on, it widens it on every "
     "tail, each read on the web from its first step (the web from a step on, as World.after reads a world). It is "
     "first-order widening read on late tails, not a comparison of growth. Read pointwise, it is inclusion from some "
     "step on with exceeding at arbitrarily late steps. Near-definitional.",
     '最终扩大：一条水平路径从某步起在每个尾段上扩大另一条，各尾段读于自其首步起的网（自某步起的网，如 World.after 读世界）。'
     '它是在晚期尾段上读的一阶扩大，不是对增长的比较。逐点读之，即从某步起的包含加上在任意晚的步上的超出。近乎定义。',
     D('Web.after', 'Web.tailFrom', 'Web.EventuallyWidens', 'Web.IncludesFrom', 'Web.ExceedsLate',
       'Web.eventuallyWidens_iff', 'Web.Includes.after', 'Web.ExceedsLate.exceeds', 'Web.Includes.not_exceedsLate')),
    ("Its order laws are widening's on tails: irreflexive, transitive and one-way. It never reverses widening or "
     "keeping the same, inclusion composes with it on either side, and widening or eventual widening is irreflexive "
     "and transitive. Widening whose exceeding recurs at arbitrarily late steps is eventual widening; where widening "
     "orders a pair, eventual widening agrees there and, classically, is silent otherwise. Wider up to a step is the "
     "comparison over a first stretch.",
     '其序律即尾段上扩大的序律：非自反、可传递、单向。它从不逆转扩大或保持相同，包含在两侧与之复合，扩大或最终扩大非自反且可传递。'
     '超出在任意晚的步上复现的扩大即最终扩大；扩大排序一对之处，最终扩大在彼处一致，经典地在其余处不置可否。截至某步更宽，是对首段的比较。',
     D('Web.EventuallyWidens.irrefl', 'Web.EventuallyWidens.trans', 'Web.EventuallyWidens.not_reverse',
       'Web.EventuallyWidens.not_included', 'Web.Widens.not_eventually_reversed', 'Web.Includes.trans_eventually',
       'Web.EventuallyWidens.trans_includes', 'Web.WidensOrEventually', 'Web.WidensOrEventually.irrefl',
       'Web.WidensOrEventually.trans', 'Web.WidensWithoutEnd', 'Web.WidensWithoutEnd.widens',
       'Web.WidensWithoutEnd.eventually', 'Web.WidensUpTo')),
    ("It reads only tails: level paths agreeing from some step on eventually widen, and are eventually widened, alike, "
     "so every finite stretch is ignored. A course admitting something at arbitrarily late steps eventually widens one "
     "that admits nothing from some step on.",
     '它只读尾段：从某步起一致的水平路径，最终扩大与被最终扩大皆同，故每个有限段都被忽略。在任意晚的步上有所纳的进程，'
     '最终扩大从某步起一无所纳的进程。',
     D('Web.EventuallyWidens.of_agree_left', 'Web.EventuallyWidens.of_agree_right', 'Web.eventually_of_vanishing')),
    ("Read on the runs of the process of all sequences of levels, where some level path eventually widens a second, "
     "eventually widening it and its complement are both dense, the first course varied and the second fixed; so the "
     "verdict is neither verifiable nor refutable, and a practice fixed by the record can keep it against every "
     "record. Instances of 03's density laws.",
     '读于一切水平序列之过程的运行：某水平路径最终扩大第二条之处，最终扩大它与其补皆稠密（变第一进程，第二进程固定）；'
     '故此判定既不可证实亦不可证伪，依记录而定的实践可对一切记录保持它。为 03 稠密之律的实例。',
     D('Web.splice', 'Web.splice_before', 'Web.splice_from', 'Web.eventually_dense', 'Web.not_eventually_dense',
       'Web.eventually_neither', 'Web.eventually_insulated')),
    ("A level path whose admissions a list holds eventually widens nothing, so the weighting characterization of C, "
     "which needs both courses' admissions listed, is silent on eventual widening.",
     '所纳被一列表所持的水平路径不最终扩大任何路径，故 C 的加权刻画（需两进程之所纳皆被列出）对最终扩大不置一词。',
     D('Web.stepBound', 'Web.lt_stepBound', 'Web.not_eventually_of_listed')),
    ("Keeping widening: along a continuation, from a step on, nothing admitted is lost across any stretch and after "
     "every step something is admitted that continues nothing admitted then. It holds from every later step and is "
     "unchanged by every re-identification carrying the continuation. By name over a listed type no range keeps "
     "widening (the pigeonhole). A course keeping widening by name eventually widens a range that admits alike from "
     "some step on what it admits at some step, nothing lost giving the inclusion; with the inclusion given, keeping "
     "opening suffices.",
     '持续扩大：沿一延续，从某步起任一段中所纳无失，且每步之后有所纳者不延续当时所纳的任何者。它自每一后步起皆成立，'
     '且不因承载该延续的任何重新识别而变。按名在列出的类型上，没有范围持续扩大（鸽笼）。按名持续扩大的进程，最终扩大一个从某步起'
     '一律同纳其于某步所纳者的范围，无失给出包含；包含既给，持续开出即足。',
     D('Web.IncludesAcrossFrom', 'Web.KeepsOpening', 'Web.KeepsWidening', 'Web.AdmitsAlikeFrom',
       'Web.KeepsWidening.later', 'Web.keepsWidening_reidentify', 'Web.KeepsWidening.gathers',
       'Web.KeepsWidening.not_listed', 'Web.KeepsOpening.eventually_widens',
       'Web.KeepsWidening.eventually_widens_of_within')),
    ("What carries a widening, provisionally: a flow's range is opened by the opened from a step where gains of "
     "support recur and every later gain is given, on a condition the gainer requires before the step and that rises "
     "across it, by a supported formation taking part that itself gained support after that step, earlier. Where "
     "nothing is supported from some step on, no flow is opened by the opened. Provisional: its first law, the uniform "
     "form of support passing on, would reach the giver only up to double negation.",
     '承载扩大者（暂定）：一流的范围从某步起由已开者所开，若支撑之获得复现，且其后每一获得，皆在获得者于该步之前所需、且跨步上升之条件上，'
     '由一参与的受支撑构成给予，而该构成本身在该步之后、更早时获得支撑。从某步起无一受支撑之处，无流由已开者所开。暂定：其第一律，'
     '即支撑传递之一致形式，只在双重否定下达到给予者。',
     D('Flow.OpenedByOpened', 'Flow.OpenedByOpened.not_of_unsupported')),
    ("Witnesses of the disagreement and of saturation (each formation requiring only its own condition at need one): "
     "a burst admitting formations 0 and 1 at step 0 and nothing after widens a rising course, admitting at step t the "
     "formations up to t, up to step 0; the two are mixed over every step; the rising course eventually widens the "
     "burst and keeps widening by name, the burst from no step. A saturated course widens and eventually widens the "
     "rising one and keeps widening from no step, so no order ranking each course that keeps widening above each that "
     "does not agrees with widening. On that web no flow is opened by the opened.",
     '分歧与饱和之见证（每一构成只需其自身条件，需求为一）：于第 0 步纳构成 0 与 1、此后一无所纳的突发进程，至第 0 步扩大于第 t 步'
     '纳至 t 诸构成的上升进程；二者在全部步上为混合；上升进程最终扩大突发进程且按名持续扩大，突发进程自无一步起持续扩大。饱和进程扩大且'
     '最终扩大上升进程，而自无一步起持续扩大，故凡把每个持续扩大的进程排在每个不持续扩大者之上的序，皆不合于扩大。该网上无流由已开者所开。',
     D('OwnCondition.rung', 'OwnCondition.rung_pos', 'OwnCondition.le_of_rung_pos', 'OwnCondition.rung_mono',
       'OwnCondition.rung_zero', 'OwnCondition.web', 'OwnCondition.admits_iff', 'OwnCondition.rising',
       'OwnCondition.burst', 'OwnCondition.full', 'OwnCondition.rising_iff', 'OwnCondition.burst_zero_iff',
       'OwnCondition.burst_later', 'OwnCondition.full_admits', 'OwnCondition.zero_of_le_zero',
       'OwnCondition.burst_widens_now', 'OwnCondition.mixed', 'OwnCondition.rising_eventually_widens_burst',
       'OwnCondition.rising_keeps_widening', 'OwnCondition.burst_not_opening', 'OwnCondition.burst_not_keeps_widening',
       'OwnCondition.disagreement', 'OwnCondition.full_widens_rising', 'OwnCondition.full_eventually_widens_rising',
       'OwnCondition.full_not_opening', 'OwnCondition.not_monotone', 'OwnCondition.not_opened')),
    ("Witness of a lag: a course admitting only formation t at step t, and a course admitting the formations below t. "
     "The second keeps widening by name and admits, at every step after it, every formation the first admits; yet "
     "neither eventually widens the other: one-step novelties against a course keeping each of them forever are "
     "mixed in every tail.",
     '滞后之见证：于第 t 步只纳构成 t 的进程，与纳小于 t 诸构成的进程。后者按名持续扩大，并于其后每步纳前者所纳的每一构成；'
     '然二者皆不最终扩大对方：一步之新，对永久保持其每一者的进程，在每个尾段上皆为混合。',
     D('LagWitness.travelling', 'LagWitness.lagging', 'LagWitness.lagging_iff', 'LagWitness.travelling_iff',
       'LagWitness.lagging_keeps_widening', 'LagWitness.kept_later', 'LagWitness.not_eventually_lagging',
       'LagWitness.not_eventually_travelling', 'LagWitness.lag')),
    ("Witness of a merge: over the two formations of Bool, along the continuation in which every formation continues "
     "as false, a course admitting the same at every step keeps widening, a formation re-formed at each step "
     "continuing nothing; by name it does not.",
     '合并之见证：于 Bool 的两个构成上，沿每一构成皆延续为 false 的延续，每步所纳相同的进程持续扩大，每步重新形成的构成不延续任何者；'
     '按名则不然。',
     D('MergedWitness.web', 'MergedWitness.merge', 'MergedWitness.steady', 'MergedWitness.admits',
       'MergedWitness.into_true_aux', 'MergedWitness.into_true', 'MergedWitness.to_false',
       'MergedWitness.keeps_widening_along_merge', 'MergedWitness.listed', 'MergedWitness.not_keeps_widening_by_name')),
    ("Witness of one range with two carriers: on one web whose levels are the rising course, a relay, in which each "
     "formation gives the next its unit, and a single giver both balance with only active formations giving and "
     "activity needing support; the relay's range is opened by the opened and the single giver's is not, while every "
     "admission is the same. Each unit is given from nothing, so neither flow meets the first law.",
     '一个范围两种承载者之见证：于水平即上升进程的同一网上，接力（每一构成给下一构成其单位）与单一给予者皆平衡，只有活跃者给予，'
     '活跃需支撑；接力的范围由已开者所开，单一给予者则否，而每一所纳皆同。每一单位皆从无中给予，故二流皆不合第一律。',
     D('OpeningChain.web', 'OpeningChain.level_rising', 'OpeningChain.supported_iff', 'OpeningChain.gains_iff',
       'OpeningChain.rises_next', 'OpeningChain.opening', 'OpeningChain.opening_pos', 'OpeningChain.relay',
       'OpeningChain.oneGiver', 'OpeningChain.balanced_step', 'OpeningChain.relay_balances',
       'OpeningChain.oneGiver_balances', 'OpeningChain.relay_acting', 'OpeningChain.oneGiver_acting',
       'OpeningChain.dependent', 'OpeningChain.relay_opened', 'OpeningChain.oneGiver_not_opened',
       'OpeningChain.carried')),
    ("Witness that ranking by opened by the opened reverses widening: the relay is opened by the opened and its levels "
     "are the rising course; a flow giving nothing, on a web where every condition stands at one throughout, is opened "
     "by the opened from no step, and its levels, the saturated course, widen the rising one on the same requirements.",
     '按由已开者所开排序会逆转扩大之见证：接力由已开者所开，其水平即上升进程；于每一条件始终立于一的网上一无所给的流，'
     '自无一步起由已开者所开，其水平即饱和进程，在同样的需求上扩大上升进程。',
     D('Saturated.web', 'Saturated.still', 'Saturated.level_full', 'Saturated.still_balances',
       'Saturated.still_not_opened', 'Saturated.reverses')),
    ("Witness of a closed cycle: two formations pass one unit around, the active one taking it from its own condition "
     "and giving it to the other's; the cycle balances, is opened by the opened with a gain at every step, and along "
     "the continuation in which each formation continues as the other nothing is lost and nothing is opened, while by "
     "name the range does not keep widening. Opened by the opened neither is nor gives widening.",
     '闭环之见证：两个构成传递一个单位，活跃者自其自身条件取之而给对方条件；此环平衡，每步皆有获得而由已开者所开；沿每一构成皆延续为'
     '对方的延续，无所失亦无所开，而按名范围不持续扩大。由已开者所开既不是扩大，也不给出扩大。',
     D('ClosedCycle.parity', 'ClosedCycle.mark', 'ClosedCycle.mark_pos_iff', 'ClosedCycle.mark_self',
       'ClosedCycle.mark_not_left', 'ClosedCycle.not_ne', 'ClosedCycle.web', 'ClosedCycle.flow',
       'ClosedCycle.supported_iff', 'ClosedCycle.gains_iff', 'ClosedCycle.balances', 'ClosedCycle.acting',
       'ClosedCycle.dependent', 'ClosedCycle.rises_at', 'ClosedCycle.give_pos', 'ClosedCycle.opened',
       'ClosedCycle.passing', 'ClosedCycle.linked_parity', 'ClosedCycle.linked_to', 'ClosedCycle.includes_across',
       'ClosedCycle.not_opening', 'ClosedCycle.listed', 'ClosedCycle.not_keeps_widening_by_name', 'ClosedCycle.cycle')),
]
cited = [n for _, _, ds in groups for n in ds]
assert len(cited) == len(set(cited))
assert set(cited) == names, sorted(names - set(cited))

record = {
    'schema_version': 2,
    'id': RID,
    'title': {'en': 'Widening on late tails, and what carries a widening',
              'zh': '在晚期尾段上读的扩大，以及承载扩大者'},
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F07',
    'reviewed_at_utc': NOW,
    'statement': {
        'en': "Eventual widening is first-order widening on late tails: with widening a strict partial order, never reversing it, reading only tails, dense both ways and insulable against every record. Widening sees neither keeping widening nor what carries a range. Near-definitional; 生生's second order stays open.",
        'zh': '最终扩大是晚期尾段上的一阶扩大：与扩大合为严格偏序，从不逆转扩大，只读尾段，其判定两向皆稠密、可对一切记录隔绝。扩大既看不见持续扩大，也看不见承载一个范围者。近乎定义；生生的二阶方向仍未定。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': ds} for en, zh, ds in groups],
    'hypotheses': [{
        'en': "No axiom and no premise beyond the representation: discrete steps on one unbounded index, natural-number "
              "levels, and one web for the two level paths compared (its requirements read on each tail by the web from "
              "that step). The frame laws hold where some level path eventually widens the second course, and vary the "
              "first course only. Keeping widening reads a supplied continuation, or names. The carrier witnesses "
              "balance, with only active formations giving and activity needing support, and give from nothing.",
        'zh': '不加公理，除表示外不加前提：一条无界指标上的离散之步、自然数水平、所比较的两条水平路径共用一网（其需求在每个尾段上由自该步起的网读出）。'
              '框架之律在某水平路径最终扩大第二进程之处成立，只变第一进程。持续扩大读一给定的延续，或按名。承载者之见证平衡，只有活跃者给予，'
              '活跃需支撑，且从无中给予。'}],
    'does_not_show': [
        {'en': 'The second-order direction of 生生, a range whose widening keeps widening compared with one merely wider '
               'now: eventual widening needs no growth (a steady course eventually widens one that collapses) and is '
               'silent on a lag. It stays open, and the study names what a next attempt needs.',
         'zh': '生生的二阶方向，即扩大持续扩大的范围与仅当下更宽者之比较：最终扩大无需增长（稳定的进程最终扩大崩溃者），且对滞后不置一词。'
               '它仍未定，研究列出下一次尝试所需。',
         'kind': 'scope'},
        {'en': 'That eventual widening is better: calling it better is a premise beyond C (C∞ in the study), named and '
               'not asserted. It would discount every loss confined to a finite stretch, its verdicts can be insulated '
               'against every record, and it is the unlimited continuation priority that the priority of basic '
               'conditions rejects.',
         'zh': '最终扩大更好：称其更好是 C 之外的前提（研究中的 C∞），已命名而未断言。它会贬低一切限于有限段的损失，其判定可对一切记录隔绝，'
               '且即基本条件优先所拒的无限延续优先。',
         'kind': 'non-implication'},
        {'en': 'That keeping widening or being opened by the opened is 生生, a direction or a ranking: ranking by either '
               'runs against widening (OwnCondition.not_monotone, Saturated.reverses).',
         'zh': '持续扩大或由已开者所开即生生、方向或排序：按二者之一排序皆与扩大相悖（OwnCondition.not_monotone、Saturated.reverses）。',
         'kind': 'non-implication'},
        {'en': 'A law relating 生成 to widening (02 stays open), or any gain, renewal or giver law; comparisons over '
               'branching courses; novelty; and that eventual widening entails overtaking as a theorem, which is an '
               'argument under finitely many admissions at each step.',
         'zh': '关于生成与扩大的律（02 仍未定），或任何增益、更新或给予者之律；对分支进程的比较；新颖；以及最终扩大蕴涵超越作为定理，'
               '那只是在每步所纳有限下的论证。',
         'kind': 'scope'},
        {'en': 'Which actual courses meet any of these readings; and the definition of opened by the opened is '
               'provisional until its first law fixes its form.',
         'zh': '哪些实有进程合于这些读法；由已开者所开之定义在其第一律定其形式之前为暂定。',
         'kind': 'correspondence'}],
    'counterexamples': [
        {'path': INST, 'detail': {
            'en': 'A lag defeats eventual widening: a course keeping widening, and keeping every formation of another '
                  'from one step later, is mixed with it in every tail (LagWitness.lag).',
            'zh': '滞后挫败最终扩大：持续扩大、且自晚一步起保持另一进程每一构成的进程，与之在每个尾段上皆为混合（LagWitness.lag）。'}},
        {'path': INST, 'detail': {
            'en': 'Keeping widening is not kept by widening: a saturated course widens a course that keeps widening and '
                  'keeps widening from no step (OwnCondition.not_monotone).',
            'zh': '持续扩大不为扩大所保持：饱和进程扩大一持续扩大的进程，而自无一步起持续扩大（OwnCondition.not_monotone）。'}},
        {'path': INST, 'detail': {
            'en': 'What carries a range is invisible to widening: a relay and a single giver give the same admissions, '
                  'only the relay opened by the opened (OpeningChain.carried); a closed cycle is opened by the opened '
                  'with no widening (ClosedCycle.cycle).',
            'zh': '承载一个范围者对扩大不可见：接力与单一给予者给出相同的所纳，唯接力由已开者所开（OpeningChain.carried）；'
                  '闭环由已开者所开而无扩大（ClosedCycle.cycle）。'}}],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical',
                            'names-provisional', 'omission-not-refutation'],
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.EventualWidening '
              f'and Becoming.EventualWideningInstances, {len(names)} declarations, every one with an empty axiom report, '
              f'all cited here. Built in one session; an independent read-only review by a separate AI agent, its '
              f'findings taken and the revision re-checked, in study section {N}; not reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：Becoming.EventualWidening 与 Becoming.EventualWideningInstances，'
              f'{len(names)} 项声明，公理报告皆空，本记录全引。于一会话中构建；另一 AI 代理作独立只读审查，其所见皆采，修订复查，'
              f'见研究第 {N} 节；未经人审。'},
    'next_delta': {
        'en': 'The gain bridge (a range keeping widening on the actual levels, requirements in a finite family, passing every bound, fed from beyond) or the givers law (under upkeep, a range keeping widening needs its givers to multiply), each a candidate no neighbouring field states; the uniform form of support passing on; widening of what can be reached over branching courses; review by a person.',
        'zh': '增益之桥（于实有水平上持续扩大、需求在一有限族内、超出一切界并由外而喂的范围）或给予者之律（有维持时，持续扩大的范围需其给予者增多），'
              '二者皆为邻域未述之结果的候选；支撑传递之一致形式；对分支进程的可达之扩大；人之独立审查。'},
    'correspondence': {
        'en': "A tail criterion in inclusion form: a criterion reading only tails is a dictatorship of the future "
              "(Chichilnisky 1996, 'An axiomatic approach to sustainable development', Social Choice and Welfare 13); "
              "on counts, with finitely many admissions at each step, eventual widening entails the overtaking criterion "
              "(von Weizsäcker 1965; Gale 1967), an argument not proved in Lean. The density of its verdicts is liveness "
              "in the sense of Alpern and Schneider (1985, 'Defining liveness', Information Processing Letters 21). The "
              "question it answers in part is THE-CORE's: a range whose widening keeps widening against one merely wider "
              "now, whose nearest neighbour is Kauffman's adjacent possible (Investigations, 2000). The readings are the "
              "AI's, stated in development/ue4-second-order/DESIGN.md with the review in REVIEW-UE4.md.",
        'zh': '包含形式的尾段准则：只读尾段的准则是未来的独裁（Chichilnisky 1996）；于计数上、每步所纳有限时，最终扩大蕴涵超越准则'
              '（von Weizsäcker 1965；Gale 1967），此为论证，未在 Lean 中证明。其判定之稠密即 Alpern 与 Schneider（1985）意义上的活性。'
              '它部分回答的问题是 THE-CORE 的：扩大持续扩大的范围与仅当下更宽者之比较，其最近之邻为 Kauffman 的相邻可能（2000）。'
              '读法皆 AI 之读，载于 development/ue4-second-order/DESIGN.md，审查见 REVIEW-UE4.md。'},
    'canonical_source': MOD,
    'aliases': ['Widening on late tails, and what carries a widening', '在晚期尾段上读的扩大，以及承载扩大者',
                'eventual widening', 'keeping widening', 'opened by the opened', 'widening on late tails',
                'Becoming.Web.EventuallyWidens', 'Becoming.Web.KeepsWidening'],
    'dependencies': [
        {'id': 'four-cases-of-a-part', 'relation': 'formal-reuse',
         'detail': {'en': 'Web.Admits, Web.Includes, Web.Exceeds, Web.Widens, Web.Mixed; Widens.not_reverse, Widens.trans, '
                          'Includes.trans, Includes.not_exceeded, from which the order laws on tails are derived.',
                    'zh': 'Web.Admits、Web.Includes、Web.Exceeds、Web.Widens、Web.Mixed；Widens.not_reverse、Widens.trans、'
                          'Includes.trans、Includes.not_exceeded，尾段上的序律由之推出。'}},
        {'id': 'widening-along-a-reading', 'relation': 'formal-reuse',
         'detail': {'en': 'Web.IncludesAcross, Web.ExceedsAcross, includesAcross_itself_iff, exceedsAcross_itself_iff, '
                          'includesAcross_reidentify, exceedsAcross_reidentify, Web.Linked.itself_of_le.',
                    'zh': 'Web.IncludesAcross、Web.ExceedsAcross、includesAcross_itself_iff、exceedsAcross_itself_iff、'
                          'includesAcross_reidentify、exceedsAcross_reidentify、Web.Linked.itself_of_le。'}},
        {'id': 'classes-along-a-continuation', 'relation': 'formal-reuse',
         'detail': {'en': 'Web.Linked, Web.itself, Web.exists_steps_between, Reidentify.carry.',
                    'zh': 'Web.Linked、Web.itself、Web.exists_steps_between、Reidentify.carry。'}},
        {'id': 'what-a-finite-stretch-verifies', 'relation': 'formal-reuse',
         'detail': {'en': 'Dense, Practice, ByRecord, Insulates, insulates_iff_dense.',
                    'zh': 'Dense、Practice、ByRecord、Insulates、insulates_iff_dense。'}},
        {'id': 'what-a-finite-history-refutes', 'relation': 'formal-reuse',
         'detail': {'en': 'Verifiable, Refutable, Adheres, not_verifiable_of_adheres, not_refutable_of_adheres; '
                          'Sequences.process, Sequences.run, Sequences.agree_iff.',
                    'zh': 'Verifiable、Refutable、Adheres、not_verifiable_of_adheres、not_refutable_of_adheres；'
                          'Sequences.process、Sequences.run、Sequences.agree_iff。'}},
        {'id': 'widening-as-what-every-weighting-ranks', 'relation': 'formal-reuse',
         'detail': {'en': 'Web.ListsAdmitted, the hypothesis of Web.widens_iff_every_weighting.',
                    'zh': 'Web.ListsAdmitted，即 Web.widens_iff_every_weighting 之假设。'}},
        {'id': 'support-from-the-supported', 'relation': 'formal-reuse',
         'detail': {'en': 'Web.GainsSupport and Web.Supported, the vocabulary of opened by the opened.',
                    'zh': 'Web.GainsSupport 与 Web.Supported，由已开者所开之词汇。'}},
        {'id': 'more-needs-renewers', 'relation': 'formal-reuse',
         'detail': {'en': 'length_le_of_sub and Distinct, the pigeonhole of KeepsWidening.not_listed.',
                    'zh': 'length_le_of_sub 与 Distinct，KeepsWidening.not_listed 之鸽笼。'}}],
    'related': [
        {'id': 'support-passed-on',
         'detail': {'en': 'Flow.support_passes_on gives, up to double negation and at arbitrarily late steps, a gain given '
                          'by a newer gainer; its uniform form, proposed, would fix the form of opened by the opened.',
                    'zh': 'Flow.support_passes_on 在双重否定下、于任意晚的步上给出由更新的获得者给予之获得；其一致形式（所拟）将定由已开者所开之形式。'}},
        {'id': 'renewing-consuming-formation',
         'detail': {'en': 'A comparison in the long run in counts, under a supplied wear law: consuming forms more at '
                          'first, renewing more past a bound.',
                    'zh': '在计数中、于给定磨损律下的长程比较：消耗者起初形成更多，更新者过界后更多。'}}],
    'references': [{'path': MOD, 'role': 'proof', 'declarations': sorted(names_of['Becoming.EventualWidening']),
                    'sha256': sha(MOD)},
                   {'path': INST, 'role': 'proof', 'declarations': sorted(names_of['Becoming.EventualWideningInstances']),
                    'sha256': sha(INST)},
                   {'path': REGIONS_LEAN, 'role': 'proof', 'sha256': sha(REGIONS_LEAN)},
                   {'path': CONTINUED, 'role': 'proof', 'sha256': sha(CONTINUED)},
                   {'path': VERIFICATION, 'role': 'proof', 'sha256': sha(VERIFICATION)},
                   {'path': HORIZON, 'role': 'proof', 'sha256': sha(HORIZON)},
                   {'path': WEIGHTINGS, 'role': 'proof', 'sha256': sha(WEIGHTINGS)},
                   {'path': ADMISSION, 'role': 'proof', 'sha256': sha(ADMISSION)},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': NOTE, 'role': 'integration', 'sha256': sha(NOTE)},
                   {'path': CH7, 'role': 'statement', 'sha256': sha(CH7)}],
    'proof_bindings': [{'source': MOD, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.EventualWidening',
                        'success_pointer': '/status', 'success_value': 'passed'},
                       {'source': INST, 'receipt': RECEIPT,
                        'sha256_pointer': '/source_sha256/Becoming.EventualWideningInstances',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{'en': f'25 October 2026: added (UE4), widening on late tails and what carries a widening, '
                       f'near-definitional; the second-order direction of 生生 stays open; study section {N}.',
                 'zh': f'2026年10月25日：新增（UE4），在晚期尾段上读的扩大与承载扩大者，近乎定义；生生的二阶方向仍未定；研究第 {N} 节。'}],
}
for rid in ('four-cases-of-a-part', 'widening-along-a-reading', 'classes-along-a-continuation',
            'what-a-finite-stretch-verifies', 'what-a-finite-history-refutes', 'widening-as-what-every-weighting-ranks',
            'support-from-the-supported', 'more-needs-renewers', 'support-passed-on', 'renewing-consuming-formation'):
    assert (RECORDS / f'{rid}.json').exists(), rid
path = RECORDS / f'{RID}.json'
assert not path.exists()
path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', RID, len(names), 'declarations')
