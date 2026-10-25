#!/usr/bin/env python3
"""MA4 records: write shaping-read-by-readers-drawn-from-the-selected (every declaration of Becoming.DrawnShaping), update
MA3's record (its next step, the related record and the scope item on the pool, history) and MA2's (a related record,
history), and add MA3's record and this one to the results of the goal generative-alignment (make_records_ma3.py).
usage (from the checkout root, after texts_ma4.py): python3 -B make_records_ma4.py RECEIPT N"""
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
CH2 = 'theories/becoming/chapters/02-MAP.md'
OVERVIEW = 'theories/becoming/THE-THEORY-OF-BECOMING.md'
META = 'theories/meta-attractor/README.md'
MOD = f'{PKG}/Becoming/DrawnShaping.lean'
SHAPING = f'{PKG}/Becoming/RuleShaping.lean'
CLOSED = f'{PKG}/Becoming/ClosedCapture.lean'
RULE = f'{PKG}/Becoming/RuleCapture.lean'
COUNTED = f'{PKG}/Becoming/ChoiceCountCapture.lean'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
KIT = RF + 'development/ma4-drawn-shaping/'
RECORDS = ROOT / 'theories/becoming/results/records'
GOAL = ROOT / '_process/goals/generative-alignment.json'
RID = 'shaping-read-by-readers-drawn-from-the-selected'
MA3 = 'shaping-the-rule-selected-by-what-comes-back'
MA2 = 'readers-drawn-from-the-selected'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
assert core['source_sha256']['Becoming.DrawnShaping'] == sha(MOD)
mod = next(m for m in core['modules'] if m['module'] == 'Becoming.DrawnShaping')
assert not any(mod['axiom_dependencies'].values())
names = {d['name'] for d in mod['declarations']}


def D(*short):
    out = ['Becoming.DrawnShaping.' + s for s in short]
    missing = [n for n in out if n not in names]
    assert not missing, missing
    return out


groups = [
    ("MA3's rule after shaping read by readers drawn from the population as it counts them, each shaper among the "
     "readers reading it with hi coming back to the shapers alone and each other with lo, both with the same a, p and "
     "c: the rule read reads the share monotonically exactly where lo ≤ hi, and against the share where hi ≤ lo. The "
     "loop's premise is moved to who reads, not removed.",
     '以取自群体、依群体计数之读者读 MA3 塑规后之规则：读者中每一塑规者以 hi 为独返于塑规者者读之，每一他者以 lo 读之，二者 a、p、c 相同：'
     '所读之规则随份额单调恰当 lo ≤ hi，hi ≤ lo 时则逆份额而读。回路之前提移至谁读，而非去除。',
     D('drawn', 'drawnRead', 'drawnCourse', 'shaped_le_iff', 'drawn_reads_iff', 'drawn_against')),
    ("At a share x the rule read favours the shapers (weakly) exactly where x.carrier · c + x.other · c ≤ "
     "x.carrier · hi + x.other · lo, and the others strictly exactly where the reverse inequality is strict, whatever a "
     "and p; with lo ≤ c ≤ hi, exactly where x.other · (c − lo) ≤ x.carrier · (hi − c); with lo = hi = s, exactly "
     "where c ≤ s, at every share alike.",
     '于份额 x，所读之规则（弱）偏向塑规者恰当 x.carrier · c + x.other · c ≤ x.carrier · hi + x.other · lo，严格偏向他者恰当反向不等式严格，'
     '与 a、p 无关；lo ≤ c ≤ hi 时，恰当 x.other · (c − lo) ≤ x.carrier · (hi − c)；lo = hi = s 时，恰当 c ≤ s，于每一份额皆同。',
     D('mul_split', 'drawn_split', 'drawn_favours_iff', 'drawn_lt_iff', 'drawn_favours_alike', 'critical_iff',
       'alike_favours_iff')),
    ("The regimes, exactly. With no hypothesis on the readers, the rule read favours the shapers at every share "
     "exactly where c ≤ lo and c ≤ hi, and the others strictly at every share exactly where lo < c and hi ≤ c; with "
     "lo ≤ hi, it favours the shapers at some share and the others strictly at another exactly where lo < c < hi.",
     '诸区，恰如其分。于读者不设假设，所读之规则于每一份额皆偏向塑规者恰当 c ≤ lo 且 c ≤ hi，于每一份额皆严格偏向他者恰当 lo < c 且 hi ≤ c；'
     'lo ≤ hi 时，其于某一份额偏向塑规者、于另一份额严格偏向他者，恰当 lo < c < hi。',
     D('noShapers', 'favours_everywhere_iff', 'disfavours_strictly_everywhere_iff', 'critical_mass_iff')),
    ("One loop, either way. With lo ≤ hi, under every schedule of reading, from a start under the rule read there: "
     "where that rule favours the shapers, every configuration of the course is locked and neither the share nor the "
     "rule in force is ever below the start; where it favours the others, every configuration is locked the other way "
     "and neither is ever above the start; so every such course is locked one way at every step. Strictly favoured at "
     "the start, the shapers' share rises strictly at every step, the shapers present; strictly disfavoured, it falls "
     "strictly at every step, the shapers present at the start. Carriers present stay present along every course "
     "whose reading gives each carrier an offspring.",
     '一回路，两向皆然。lo ≤ hi 时，对任一读之安排，自彼处所读之规则下之起点：该规则偏向塑规者处，进程之每一构型皆锁定，份额与所行之规则永不低于起点；'
     '其偏向他者处，每一构型皆反向锁定，二者永不高于起点；故每一此类进程每步皆锁于一向。起点严格偏向时，塑规者之份额每步严格升（有塑规者）；'
     '严格不偏向时，每步严格降（初时有塑规者）。凡读法予每一携带者以后代之进程，携带者在则恒在。',
     D('drawn_locks', 'drawn_from_below', 'drawn_locked_either', 'upper_strictly', 'drawn_rises', 'drawn_carrier_pos',
       'present_along_course', 'drawn_falls')),
    ("Witnesses: with a = 1, nothing shared, a cost of one, three read as coming back where a shaper reads and none "
     "where another does, one shaper to one other leaves five offspring to four, the course locked from the start and "
     "the share rising at every step; one to three leaves seven to eight, the course locked the other way and the share "
     "falling at every step; at one to two each kind leaves six and the share stays. Read against the share (hi = 0, "
     "lo = 3), a start favouring the shapers five to four is not locked at step 1, and the rule in force at step 2, "
     "twenty-one to eighteen, is below the start's.",
     '见证：a = 1、无同得、成本为一、塑规者读时所返为三而他者读时为零：一塑规者对一他者，后代五比四，进程自起点锁定，份额每步皆升；'
     '一对三，七比八，进程反向锁定，份额每步皆降；一对二，二类各留六，份额不变。逆份额而读（hi = 0、lo = 3）时，偏向塑规者五比四之起点'
     '于第一步不锁定，第二步所行之规则二十一比十八，低于起点之规则。',
     D('CriticalMass.one_pos', 'CriticalMass.even', 'CriticalMass.oneToTwo', 'CriticalMass.oneToThree',
       'CriticalMass.even_favours', 'CriticalMass.few_disfavours', 'CriticalMass.at_mass', 'CriticalMass.even_locks',
       'CriticalMass.even_rises', 'CriticalMass.few_locks', 'CriticalMass.few_falls', 'CriticalMass.at_mass_stays',
       'Against.not_locked')),
]
cited = [n for _, _, ds in groups for n in ds]
assert len(cited) == len(set(cited))
assert set(cited) == names, sorted(names ^ set(cited))

record = {
    'schema_version': 2,
    'id': RID,
    'title': {'en': 'What comes back to the shapers, read by readers drawn from the selected',
              'zh': '返于塑规者者，由取自被选者之读者读之'},
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F01',
    'reviewed_at_utc': NOW,
    'statement': {
        'en': "Where the rule's readers are drawn from those it selects and the shapers among them read at least as much "
              "coming back to the shapers as the others among them do, the selection of the capacity to shape the rule "
              "and the lock of the rule it shapes are one loop, either way: above a critical mass, located exactly by "
              "who reads and the cost, the capacity rises and the rule stays locked in its favour; below it the "
              "capacity falls and the rule stays locked against it.",
        'zh': '规则之读者取自其所选者、且其中塑规者读返于塑规者者不少于其中他者时，塑规之能之被选与其所塑规则之锁定为一回路，两向皆然：'
              '在由谁读与成本所恰定之临界量之上，其能升而规则锁定于其利；其下，其能降而规则锁定于其不利。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': ds} for en, zh, ds in groups],
    'hypotheses': [{
        'en': "No axiom and no premise beyond each law's own: discrete steps, natural counts and others present "
              "(RuleCapture's counts); a positive; two kinds, shapers and others, offspring carrying their parent's kind "
              "(transmission, a premise as in Becoming.Capture); the rule read as the pool of two readings, the readers "
              "counted as the population counts them (ClosedCapture.Drawn.pool); both kinds of reader reading the same a, "
              "p and c and differing only in what comes back to the shapers alone; hi, lo, p and c constants; for the "
              "loop, lo ≤ hi and a start under the rule read there; no noise.",
        'zh': '不加公理，除各律所带者外不加前提：离散之步、自然数计数、他者恒在（RuleCapture 之计数）；a 为正；二类，塑规者与他者，后代携其亲之类'
              '（传递，如 Becoming.Capture 之前提）；所读之规则为二读之池，读者依群体计数（ClosedCapture.Drawn.pool）；二类读者所读之 a、p、c 相同，'
              '唯独返于塑规者者有别；hi、lo、p、c 为常数；于回路，lo ≤ hi 且起点在彼处所读之规则下；无噪声。'}],
    'does_not_show': [
        {'en': 'That actual rules are read by readers drawn from those they select, each kind counted as the population '
               'counts it, or that the shapers among the readers read at least as much coming back to the shapers as the '
               'others do: within the model the loop\'s premise is equivalent to that comparison (drawn_reads_iff), so the '
               'premise is moved to who reads, not removed, and its calibration to the present world is not established.',
         'zh': '实有之规则由取自其所选者之读者读之、每类依群体计数，或读者中塑规者读返于塑规者者不少于他者：于模型之内，回路之前提等价于此比较'
               '（drawn_reads_iff），故前提移至谁读，而非去除；其与当今世界之校准未立。',
         'kind': 'correspondence'},
        {'en': 'That control over the selection left unselected and a lock left in time are independent conditions: in '
               'this model, whose rule is read from the share alone, every course from the rule read at its start is '
               'locked one way or the other (drawn_locked_either), so control not selected does not by itself give a lock '
               'left in time, and the converse cannot be shown here; leaving needs a reading beyond the share '
               '(ClosedCapture.Thinned), which is not joined.',
         'zh': '控制不被选与及时离开锁定为相互独立之条件：此模型之规则唯读自份额，自起点所读之规则起之每一进程皆锁于一向或另一向'
               '（drawn_locked_either），故控制不被选本身不予及时离开之锁定，其逆于此不能示；离开须读份额之外者（ClosedCapture.Thinned），未接。',
         'kind': 'non-implication'},
        {'en': 'Courses with noise, or convergence to either boundary state: the laws give the direction at every step on '
               'each side of the critical mass and the lock. In such a coordination game, under rare mutation in a large '
               'finite population the long-run state is the risk-dominant one (Kandori, Mailath and Rob 1993; Young 1993), '
               'here the shapers\' where lo < c < hi and 2c < hi + lo, as in the witness; the critical mass bounds courses '
               'without noise only.',
         'zh': '有噪声之进程，或收敛于任一边界状态：诸律予临界量两侧每步之方向与锁定。于此类协调博弈，大而有限之群体在稀少突变之下，长期状态为风险占优者'
               '（Kandori、Mailath、Rob 1993；Young 1993），此处 lo < c < hi 且 2c < hi + lo 时为塑规者之状态，如见证；临界量唯约束无噪声之进程。',
         'kind': 'scope'},
        {'en': 'Readers who learn (hi and lo changing with the share), a cost changing with the share, readers not counted '
               'as the population counts them, starts not under the rule read there (a rule in force against the reading '
               'can carry the share across the mass, RuleCapture.Reversed.not_absorbed), a loss read by part of the '
               'readers once the shapers pass the mass (ClosedCapture.Thinned, not joined), and the mixed point where '
               'lo > hi and hi < c ≤ lo.',
         'zh': '会学之读者（hi、lo 随份额而变）、随份额而变之成本、不依群体计数之读者、不在彼处所读之规则下之起点（与所读相反之所行规则可携份额越过临界量，'
               'RuleCapture.Reversed.not_absorbed）、塑规者越过临界量后由部分读者所读之损失（ClosedCapture.Thinned，未接），及 lo > hi 且 hi < c ≤ lo 之混合点。',
         'kind': 'scope'},
        {'en': 'That capture damages or supports 生生, or that a course below the critical mass is better than one above '
               'it: no evaluation enters, and ranking courses needs C.',
         'zh': '捕获损害或支持生生，或临界量之下之进程优于其上者：不入评价，排序进程须 C。', 'kind': 'non-implication'}],
    'counterexamples': [
        {'path': MOD, 'detail': {
            'en': 'The same reading of what comes back does not decide: in every start of the witness the shapers among '
                  'the readers read three times the cost as coming back, yet from one to three the capacity falls at every '
                  'step (CriticalMass.few_disfavours, CriticalMass.few_falls) while from one to one it rises '
                  '(CriticalMass.even_favours, CriticalMass.even_rises).',
            'zh': '同一所返之读不定其向：见证之每一起点，读者中塑规者皆读所返为成本之三倍，然自一对三起其能每步皆降'
                  '（CriticalMass.few_disfavours、CriticalMass.few_falls），自一对一起则升（CriticalMass.even_favours、CriticalMass.even_rises）。'}},
        {'path': MOD, 'detail': {
            'en': 'Without lo ≤ hi a strictly favoured start is not locked: with hi = 0 and lo = 3, from one to one the rule '
                  'read favours the shapers five to four, yet the course is not locked at step 1 and the rule in force at '
                  'step 2 is below the start\'s (Against.not_locked).',
            'zh': '无 lo ≤ hi，严格偏向之起点不锁定：hi = 0、lo = 3 时，自一对一起所读之规则偏向塑规者五比四，然进程于第一步不锁定，'
                  '第二步所行之规则低于起点者（Against.not_locked）。'}},
        {'path': MOD, 'detail': {
            'en': 'Control not selected does not leave the lock: below the critical mass the capacity falls, yet the course '
                  'is locked the other way at every step (CriticalMass.few_locks, drawn_locked_either).',
            'zh': '控制不被选不离锁定：临界量之下其能降，然进程每步皆反向锁定（CriticalMass.few_locks、drawn_locked_either）。'}}],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical',
                            'names-provisional', 'omission-not-refutation'],
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.DrawnShaping, '
              f'{len(names)} declarations, every one with an empty axiom report, all cited here. Built in one session; '
              f'one independent read-only review by a separate AI agent (sixteen findings, no unsound Lean), taken as the '
              f'kit note says, study section {N}; not reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：Becoming.DrawnShaping，{len(names)} 项声明，公理报告皆空，本记录全引。'
              f'于一会话中构建；另一 AI 代理作一次独立只读审查（十六项意见，无不健全之 Lean），依工作包说明采纳，见研究第 {N} 节；未经人审。'},
    'next_delta': {
        'en': 'A loss read by the others among the readers once the shapers pass the critical mass, the readers\' timing '
              '(ClosedCapture.Thinned) joined to the rise; readers who learn; a cost changing with the share; noise and '
              'the long-run state; the generic lock at a start read there, upper_strictly and present_along_course lifted '
              'into RuleCapture (rule 9, its owner\'s call); an independent review by a person.',
        'zh': '塑规者越过临界量后由读者中他者所读之损失，读者之时序（ClosedCapture.Thinned）接于其升；会学之读者；随份额而变之成本；噪声与长期状态；'
              '彼处所读起点之一般锁定、upper_strictly 与 present_along_course 提入 RuleCapture（规则 9，由其所有者定）；人之独立审查。'},
    'correspondence': {
        'en': "Where lo < c < hi the model is the stag hunt in which the second strategy's payoff does not depend on the "
              "partner: a shaper meeting a shaper leaves a + p + hi, a shaper meeting an other a + p + lo, an other "
              "meeting anyone a + p + c. The critical mass is its mixed equilibrium, at the shapers' share "
              "(c − lo)/(hi − lo), and risk dominance compares hi + lo with 2c (Harsanyi and Selten 1988; Skyrms 2004). "
              "Both readings give each other a + c + p, so the rule read is the frequency-weighted mean of the two "
              "readings up to a common factor, and reading at every step is discrete-time replicator selection up to a "
              "lag of one step (Hofbauer and Sigmund 1998). The threshold is the critical mass of binary choices with "
              "externalities (Schelling 1973; Schelling 1978, chapters 3 and 7; Granovetter 1978, whose thresholds are "
              "distributed where here there is one; Oliver, Marwell and Teixeira 1985, for the term), and the lock is "
              "the lock-in of increasing returns (Arthur 1989), here decided by the start rather than by random "
              "arrivals; under noise the risk-dominant state is selected in the long run (Kandori, Mailath and Rob 1993; "
              "Young 1993). A biological comparator for readers favouring their own kind is the greenbeard (Gardner and "
              "West 2010; only the bibliographic record verified). Read on the meta-attractor (theories/meta-attractor), "
              "this joins its second order, selection for control over selection, to its closed loop. The lock half is "
              "near-definitional (RuleCapture's locked_stays and locked_not_below at a start read there), and "
              "drawn_reads_iff is a two-step composition (ClosedCapture.Drawn.pool_reads_iff, then shaped_le_iff); what "
              "is new on the spine is the critical-mass computation, which is elementary.",
        'zh': 'lo < c < hi 时，此模型即猎鹿博弈，其第二策略之所得不依于对手：塑规者遇塑规者留 a + p + hi，塑规者遇他者留 a + p + lo，他者遇任何者留 a + p + c。'
              '临界量即其混合均衡，于塑规者份额 (c − lo)/(hi − lo)；风险占优比较 hi + lo 与 2c（Harsanyi、Selten 1988；Skyrms 2004）。'
              '二读皆予他者 a + c + p，故所读之规则至一公因子即二读之频率加权平均，每步皆读即离散时间之复制者选择，至一步之滞后（Hofbauer、Sigmund 1998）。'
              '门槛即带外部性之二元选择之临界量（Schelling 1973；Schelling 1978，第 3、7 章；Granovetter 1978，其门槛为分布者，此处唯一；'
              'Oliver、Marwell、Teixeira 1985，用此名）；锁定即递增回报之锁入（Arthur 1989），此处由起点而非随机到达所定；有噪声时，长期选风险占优之状态'
              '（Kandori、Mailath、Rob 1993；Young 1993）。偏向本类之读者，其生物学对照为绿胡须（Gardner、West 2010；唯核其书目）。读于元吸引子'
              '（theories/meta-attractor），此接其第二阶，即对选择之控制之选择，于其封闭回路。锁定之半近乎定义（RuleCapture 之 locked_stays 与 '
              'locked_not_below 于彼处所读之起点），drawn_reads_iff 为二步之合成（ClosedCapture.Drawn.pool_reads_iff，继以 shaped_le_iff）；'
              '主干上所新者为临界量之计算，属初等。'},
    'canonical_source': MOD,
    'aliases': ['What comes back to the shapers, read by readers drawn from the selected', '返于塑规者者，由取自被选者之读者读之',
                'the critical mass of shapers among the readers', 'Becoming.DrawnShaping.critical_iff'],
    'dependencies': [
        {'id': 'capture-through-the-rule', 'relation': 'formal-reuse',
         'detail': {'en': 'CarrierCounts, its order, favours, disfavours, select, raises, lowers, upper, lower, '
                          'rises_strictly_along; ReadsShare and its reverse, Locked, locked_stays, locked_not_below, '
                          'reverse; paced_fast_succ; Pace.paced_succ and Pace.turn.',
                    'zh': 'CarrierCounts 及其序、favours、disfavours、select、raises、lowers、upper、lower、rises_strictly_along；'
                          'ReadsShare 及其逆、Locked、locked_stays、locked_not_below、reverse；paced_fast_succ；Pace.paced_succ 与 Pace.turn。'}},
        {'id': MA2, 'relation': 'formal-reuse',
         'detail': {'en': 'ClosedCapture.Drawn.pool, pool_reads_iff and pool_against: the rule read as the pool of two '
                          'readings, the readers counted as the population counts them.',
                    'zh': 'ClosedCapture.Drawn.pool、pool_reads_iff 与 pool_against：所读之规则为二读之池，读者依群体计数。'}},
        {'id': MA3, 'relation': 'formal-reuse',
         'detail': {'en': 'RuleShaping.shaped, present_of_le and falls_strictly; its byBack laws are not used.',
                    'zh': 'RuleShaping.shaped、present_of_le 与 falls_strictly；其 byBack 诸律未用。'}},
        {'id': 'capture-by-counted-choices', 'relation': 'formal-reuse',
         'detail': {'en': 'ChoiceCountCapture.lower_strict alone, whose mirror upper_strictly is stated here.',
                    'zh': '唯 ChoiceCountCapture.lower_strict，其镜像 upper_strictly 于此陈述。'}}],
    'related': [
        {'id': 'closed-capture',
         'detail': {'en': 'The loop whose every level reads only the share; here every course read from the share alone is '
                          'locked one way or the other, and leaving needs a reading beyond it.',
                    'zh': '每一层皆只读份额之回路；此处唯读自份额之每一进程皆锁于一向或另一向，离开须读其外者。'}},
        {'id': 'a-reading-against-the-share-does-not-ratchet',
         'detail': {'en': 'Where hi ≤ lo the rule read reads against the share (drawn_against).',
                    'zh': 'hi ≤ lo 时所读之规则逆份额而读（drawn_against）。'}}],
    'references': [{'path': MOD, 'role': 'proof', 'declarations': sorted(names), 'sha256': sha(MOD)},
                   {'path': SHAPING, 'role': 'proof', 'sha256': sha(SHAPING)},
                   {'path': CLOSED, 'role': 'proof', 'sha256': sha(CLOSED)},
                   {'path': RULE, 'role': 'proof', 'sha256': sha(RULE)},
                   {'path': COUNTED, 'role': 'proof', 'sha256': sha(COUNTED)},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': KIT + 'NOTE.md', 'role': 'integration', 'sha256': sha(KIT + 'NOTE.md')},
                   {'path': KIT + 'REVIEW-MA4.md', 'role': 'review', 'sha256': sha(KIT + 'REVIEW-MA4.md')},
                   {'path': CH2, 'role': 'statement', 'sha256': sha(CH2)},
                   {'path': OVERVIEW, 'role': 'statement', 'sha256': sha(OVERVIEW)},
                   {'path': META, 'role': 'statement', 'sha256': sha(META)}],
    'proof_bindings': [{'source': MOD, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.DrawnShaping',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{'en': f'26 October 2026: added (MA4), the join of the capacity to shape the rule with the readers drawn '
                       f'from the selected, after one independent review; study section {N}.',
                 'zh': f'2026年10月26日：新增（MA4），塑规之能与取自被选者之读者之接合，经一次独立审查；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists()
path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

# MA3's record: the join is no longer missing
path = RECORDS / f'{MA3}.json'
d = json.loads(path.read_text(encoding='utf-8'))
old_next = ("a gain growing with the number of domains captured (the ratchet); gains passing between domains; a theorem "
            "joining what comes back to the shapers with MA2's readers drawn from the selected; a frozen test")
assert d['next_delta']['en'].count(old_next) == 1
d['next_delta']['en'] = d['next_delta']['en'].replace(old_next, "a gain growing with the number of domains captured (the "
                                                      "ratchet); gains passing between domains; a frozen test")
old_next_zh = '领域间相传之所得；接返于塑规者者与 MA2 取自被选者之读者之定理；所返是否定向之冻结检验'
assert d['next_delta']['zh'].count(old_next_zh) == 1
d['next_delta']['zh'] = d['next_delta']['zh'].replace(old_next_zh, '领域间相传之所得；所返是否定向之冻结检验')
rel = [x for x in d['related'] if x['id'] == MA2]
assert len(rel) == 1
rel[0]['detail'] = {
    'en': 'MA2: ReadsShare from a pool of readers drawn from the selected; here ReadsShare is equivalent to what comes back '
          'to the shapers being monotone in their share. The two are joined in ' + RID + ' (MA4), where the pool of two '
          'rules after shaping reads the share exactly where lo ≤ hi.',
    'zh': 'MA2：自取自被选者之读者池得 ReadsShare；此处 ReadsShare 等价于返于塑规者者随其份额单调。二者接于 ' + RID + '（MA4）：'
          '二塑规后规则之池随份额而读恰当 lo ≤ hi。'}
assert not any(x['id'] == RID for x in d['related'])
d['related'].append({'id': RID, 'detail': {
    'en': 'MA4: this module\'s rule after shaping read by readers drawn from the selected; the threshold assumed here '
          '(thresholdBack) is replaced there by a critical mass located by who reads and the cost.',
    'zh': 'MA4：本模块塑规后之规则由取自被选者之读者读之；此处所设之门槛（thresholdBack）于彼处代以由谁读与成本所定之临界量。'}})
scope = [x for x in d['does_not_show'] if 'a pool of readers drawn from the selected (board item MA2)' in x['en']]
assert len(scope) == 1
scope[0]['en'] = scope[0]['en'].replace(
    'real-valued shares, noise, and what comes back read through a pool of readers drawn from the selected (board item '
    'MA2).', 'real-valued shares and noise; what comes back read through a pool of readers drawn from the selected is '
    'stated in ' + RID + ' (board item MA4).')
assert RID in scope[0]['en'], scope[0]['en']
scope[0]['zh'] = scope[0]['zh'].replace('实数份额、噪声，以及经由取自被选者之读者池而读之所返（看板项 MA2）。',
                                        '实数份额与噪声；经由取自被选者之读者池而读之所返，见 ' + RID + '（看板项 MA4）。')
assert RID in scope[0]['zh'], scope[0]['zh']
d['history'].append({
    'en': f'26 October 2026 (MA4, study section {N}): joined with the readers drawn from the selected in {RID}; the next '
          'step, the related record and the scope item on the pool updated. The laws are unchanged.',
    'zh': f'2026年10月26日（MA4，研究第 {N} 节）：与取自被选者之读者接于 {RID}；下一步、相关记录及关于读者池之范围条目随之更新。诸律不变。'})
path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

# MA2's record: a related record
path = RECORDS / f'{MA2}.json'
d = json.loads(path.read_text(encoding='utf-8'))
assert not any(x['id'] == RID for x in d['related'])
d['related'].append({'id': RID, 'detail': {
    'en': 'MA4: the pool of two of RuleShaping\'s rules after shaping, hi coming back where a shaper reads and lo where an '
          'other does; there ReadsShare is equivalent to lo ≤ hi, and a critical mass decides the direction.',
    'zh': 'MA4：RuleShaping 二塑规后规则之池，塑规者读时所返为 hi、他者读时为 lo；于彼 ReadsShare 等价于 lo ≤ hi，临界量定其向。'}})
d['history'].append({
    'en': f'26 October 2026 (MA4, study section {N}): related record {RID} added. The laws are unchanged.',
    'zh': f'2026年10月26日（MA4，研究第 {N} 节）：增相关记录 {RID}。诸律不变。'})
path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

# the goal's results: MA3's record, as its source record said, and this one
g = json.loads(GOAL.read_text(encoding='utf-8'))
for rid in (MA3, RID):
    assert rid not in g['result_ids'], rid
    g['result_ids'].append(rid)
GOAL.write_text(json.dumps(g, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('records:', RID, len(names), 'declarations; MA3 and MA2 records updated; goal results', len(g['result_ids']))
