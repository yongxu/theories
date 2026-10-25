#!/usr/bin/env python3
"""MA3 record: write shaping-the-rule-selected-by-what-comes-back (every declaration of Becoming.RuleShaping).
usage (from the checkout root, after texts_ma3.py): python3 -B make_records_ma3.py RECEIPT N"""
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
MOD = f'{PKG}/Becoming/RuleShaping.lean'
RULE = f'{PKG}/Becoming/RuleCapture.lean'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
RID = 'shaping-the-rule-selected-by-what-comes-back'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
assert core['source_sha256']['Becoming.RuleShaping'] == sha(MOD)
mod = next(m for m in core['modules'] if m['module'] == 'Becoming.RuleShaping')
assert not any(mod['axiom_dependencies'].values())
names = {d['name'] for d in mod['declarations']}


def D(*short):
    out = ['Becoming.RuleShaping.' + s for s in short]
    missing = [n for n in out if n not in names]
    assert not missing, missing
    return out


groups = [
    ("Shapers leave a + s + p offspring and others a + c + p, with s what comes back to the shapers alone, p what comes "
     "to every member alike, c the cost and a positive: at a step the rule favours the shapers (weakly) exactly where "
     "c ≤ s and disfavours them (weakly) exactly where s ≤ c, whatever p.",
     '塑规者各留 a + s + p 后代、他者各留 a + c + p（s 为独返于塑规者者，p 为众人同得者，c 为成本，a 为正）：一步之内，规则（弱）偏向塑规者'
     '恰当 c ≤ s，（弱）偏向他者恰当 s ≤ c，与 p 无关。',
     D('shaped', 'eq_of_counts', 'favours_iff', 'disfavours_iff', 'favours_alike')),
    ("The shared part pulls the rule toward even: a larger one gives a rule not higher in the share order where c ≤ s, "
     "strictly lower where c < s and it is strictly larger, and not lower where s ≤ c; a smaller cost gives a rule not "
     "lower; the rule with a shared part p is the rule over the base a + p with nothing shared.",
     '同得部分使规则趋平：c ≤ s 时，同得愈大，规则于份额之序中不升，c < s 且严格更大时严格更低；s ≤ c 时不降；成本更低，规则不降；'
     '带同得部分 p 之规则，即以 a + p 为基而无同得之规则。',
     D('shared_lowers', 'shared_lowers_strictly', 'shared_raises', 'lower_c_raises', 'shaped_shift')),
    ("With nothing coming back and a positive cost, the shapers' share falls strictly at every step of the run, the "
     "shapers present at the start; with no cost to the shapers alone the rule favours them whatever comes back, and "
     "with nothing coming back as well selection leaves the share where it is.",
     '无所独返而成本为正，塑规者之份额沿此进程每步皆严格下降（初时有塑规者）；塑规者无独担之成本时，规则偏向之，无论所返几何；'
     '若亦无所独返，选择使份额不变。',
     D('falls_strictly', 'present_along', 'present_of_le', 'nothing_back_falls', 'c_zero_favours', 'neutral_steady')),
    ("Selection by two rules in turn is selection by the two in one, their counts multiplied, and the run under a rule "
     "is selection by the rule held, its counts raised to the number of steps; carriers present, selection does not "
     "lower the share exactly where the rule favours, and raises it strictly exactly where it favours strictly.",
     '依次以二规则选择，即以合一之规则选择，其计数相乘；在一规则下之进程，即以持守之规则选择，其计数自乘步数之次；有携带者时，'
     '选择不降份额恰当规则偏向之，严格升之恰当严格偏向之。',
     D('thenBy', 'select_thenBy', 'pow_pos_of_pos', 'held', 'orbit_held', 'le_select_iff', 'lt_select_iff')),
    ("Across m steps before anything comes back and n steps with it, the shapers present, their share does not fall "
     "exactly where (a + c + p)^m (a + c + p)^n ≤ (a + p)^m (a + s + p)^n, and rises strictly exactly where the "
     "inequality is strict; only how many steps of each kind matters. One more step before anything comes back never "
     "helps the shapers; one more step with it never hurts them where it covers the cost.",
     '先 m 步无所返、后 n 步有之，有塑规者时，其份额不降恰当 (a + c + p)^m (a + c + p)^n ≤ (a + p)^m (a + s + p)^n，严格升恰当不等式严格；'
     '唯各类步之数要紧。无所返之步多一步，于塑规者无益；所返覆盖成本时，有所返之步多一步，于塑规者无损。',
     D('stretch_eq', 'stretch_iff', 'stretch_lt_iff', 'wait_not_more', 'back_longer_not_less')),
    ("On the reading of what comes back from the shapers' share at each reading step, the rule read is a monotone "
     "function of the share exactly where what comes back is monotone in it; monotone and covering the cost at every "
     "share, from a start whose rule covers it, the share falls at no step and the course is locked from the step after "
     "its first reading step.",
     '所返于每读之步读自塑规者之份额时，所读之规则随份额单调，恰当所返随份额单调；所返单调且于每一份额皆覆盖成本，起点之规则亦覆盖之，'
     '则份额无一步下降，自首次读之步之后一步起进程锁定。',
     D('byBack', 'byBack_reads_iff', 'covering_locks')),
    ("At a threshold, what comes back hi where the shapers are at least as many as the others and lo where they are "
     "fewer, lo ≤ hi: from a start above with c ≤ hi, under the rule read there, the shapers' share is never again "
     "below its start and the rule in force stays the one read above; from a start below with lo ≤ c, never again "
     "above it and the rule stays the one read below; with lo < c < hi, from above the share rises strictly at every "
     "step and from below it falls strictly at every step, the shapers present; under every schedule of reading.",
     '门槛处，所返于塑规者不少于他者时为 hi、少于他者时为 lo，lo ≤ hi：自门槛之上起且 c ≤ hi，在彼时所读之规则下，塑规者之份额永不低于起点，'
     '所行之规则恒为上方所读者；自门槛之下起且 lo ≤ c，永不高于起点，规则恒为下方所读者；lo < c < hi 时，自上则份额每步严格升，'
     '自下则每步严格降（有塑规者）；对任一读之安排皆然。',
     D('thresholdBack', 'thresholdBack_above', 'thresholdBack_below', 'thresholdBack_mono', 'threshold_from_above',
       'threshold_from_below', 'threshold_rule_above', 'threshold_rule_below', 'threshold_rises',
       'threshold_present_below', 'threshold_falls')),
    ("Witnesses: with s + p = 5 to each shaper and a cost of one, the rule favours the shapers where two of the five "
     "come back to them alone and disfavours them where none does, and from one shaper to each other their share "
     "rises in the first case and falls in the second. With a = 1, c = 1, s = 2, two steps before and three with what "
     "comes back lower the shapers' share with nothing shared and raise it with one to every member. With a = 2, "
     "c = 1, s = 2: one step before and two with it raise the share; two and two, or one and one, lower it; after five "
     "steps before, seven with it lower the share and eight raise it.",
     '见证：每塑规者 s + p = 5、成本为一，五中二独返于塑规者时规则偏向之，无一独返时偏向他者；自一对一起，前者份额升，后者降。'
     'a = 1、c = 1、s = 2 时，先二步无所返、后三步有之：无同得则塑规者份额降，每人同得一则升。a = 2、c = 1、s = 2 时：先一后二则升；'
     '二与二、或一与一则降；先五步后，有所返七步则降，八步则升。',
     D('Split.one_pos', 'Split.even', 'Split.favours', 'Split.shared_disfavours', 'Split.rises', 'Split.falls',
       'SharedFlips.one_pos', 'SharedFlips.without_falls', 'SharedFlips.with_rises',
       'Timing.two_pos', 'Timing.soon_rises', 'Timing.late_falls', 'Timing.shorter_falls', 'Timing.seven_falls',
       'Timing.eight_rises')),
]
cited = [n for _, _, ds in groups for n in ds]
assert len(cited) == len(set(cited))
assert set(cited) == names, sorted(names - set(cited))

record = {
    'schema_version': 2,
    'id': RID,
    'title': {'en': 'The capacity to shape the rule, selected by what comes back to it',
              'zh': '塑规之能，以独返于塑规者之所得被选'},
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F01',
    'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Where the carriers of a selection shape its rule, at a step the rule favours them exactly where what comes back to them alone covers its cost, whatever all receive; across a stretch the counts of steps before and with it decide; monotone in their share and covering the cost, the loop locks.',
        'zh': '选择之携带者塑其规则时，一步之内规则偏向之恰当独返于塑规者之所得覆盖其成本，与众人同得者无关；跨一段，有所返之前与之同时之步数定之；所返随份额单调且覆盖成本，则回路锁定。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': ds} for en, zh, ds in groups],
    'hypotheses': [{
        'en': "No axiom and no premise beyond each law's own: discrete steps, natural counts and others present "
              "(RuleCapture's counts); a positive; two kinds, shapers and others, offspring carrying their parent's kind "
              "(transmission, a premise as in Becoming.Capture); for the loop, what comes back read at reading steps as "
              "a function of the share; for the tipping point, the threshold where the shapers are at least as many as "
              "the others.",
        'zh': '不加公理，除各律所带者外不加前提：离散之步、自然数计数、他者恒在（RuleCapture 之计数）；a 为正；二类，塑规者与他者，后代携其亲之类'
              '（传递，如 Becoming.Capture 之前提）；于回路，所返于读之步为份额之函数；于转折点，门槛在塑规者不少于他者处。'}],
    'does_not_show': [
        {'en': 'That actual practices, institutions or trained systems carry a capacity to shape their rule from parent to '
               'offspring, or that what comes back to them is read from their share: these are premises, and their '
               'calibration to the present world is not established.',
         'zh': '实有之实践、制度或受训之系统由亲及子携带塑其规则之能，或其所返读自其份额：此皆前提，其与当今世界之校准未立。',
         'kind': 'correspondence'},
        {'en': 'That capture damages or supports 生生, or that open rule-making is better than capture: no evaluation '
               'enters, and ranking courses needs C.',
         'zh': '捕获损害或支持生生，或开放之立规优于捕获：不入评价，排序进程须 C。', 'kind': 'non-implication'},
        {'en': 'Graded capacities, a return growing with the number of domains captured, returns passing between domains, '
               'real-valued shares, noise, and what comes back read through a pool of readers drawn from the selected '
               '(board item MA2).',
         'zh': '分级之能、随所捕获之领域数而增之所返、领域间相传之所返、实数份额、噪声，以及经由取自被选者之读者池而读之所返（看板项 MA2）。',
         'kind': 'scope'},
        {'en': 'That the shared part leaves a stretch unchanged: it is part of the base (shaped_shift) and can turn the '
               'verdict (SharedFlips).',
         'zh': '同得部分不改一段之结果：其并入基数（shaped_shift），可改结论（SharedFlips）。', 'kind': 'non-implication'},
        {'en': 'A gain made by the shapers and divided among all: s and p are constants of the rule, so the shared part '
               'reaches every member even with no shapers present and does not grow with their number; the cost is borne '
               'at every step, with what comes back or not.',
         'zh': '塑规者所得而由众人分享之益：s 与 p 为规则之常数，故同得部分即无塑规者亦及每人，且不随其数而增；成本每步皆担，有所返与否皆然。',
         'kind': 'scope'},
        {'en': 'That the timing law\'s verdict is fixed by c, s, m and n alone: it depends on the base a, and so on whether '
               'the cost is read as what the others leave more or what the shapers leave less (with 3 left before shaping, '
               'c = 1, s = 2, three steps before and four with what comes back fall, the case a = 2 here).',
         'zh': '时序律之结论唯由 c、s、m、n 所定：其依于基数 a，故依于成本读作他者多留或塑规者少留（塑规前各留 3、c = 1、s = 2，先三后四则降，即此处 a = 2 之情形）。',
         'kind': 'non-implication'}],
    'counterexamples': [
        {'path': MOD, 'detail': {
            'en': 'A large gain to each shaper does not select the capacity: with s + p = 5 to each shaper at a cost of '
                  'one, the rule disfavours the shapers where none of the five comes back to them alone, and from one to '
                  'one their share falls (Split.shared_disfavours, Split.falls), while two of the five coming back '
                  'favours them (Split.favours, Split.rises).',
            'zh': '每塑规者所得大，不必选此能：每塑规者 s + p = 5、成本为一，五中无一独返时规则偏向他者，自一对一起其份额降'
                  '（Split.shared_disfavours、Split.falls）；五中二独返时则偏向塑规者（Split.favours、Split.rises）。'}},
        {'path': MOD, 'detail': {
            'en': 'What comes back exceeding the cost need not select the capacity across a stretch: with a = 2, c = 1, '
                  's = 2, one step before and two with it raise the shapers\' share, while two before and two with it, or '
                  'one and one, lower it (Timing.soon_rises, Timing.late_falls, Timing.shorter_falls).',
            'zh': '所返超过成本，跨一段不必选此能：a = 2、c = 1、s = 2 时，先一后二则塑规者份额升，先二后二或一与一则降'
                  '（Timing.soon_rises、Timing.late_falls、Timing.shorter_falls）。'}},
        {'path': MOD, 'detail': {
            'en': 'The shared part, which does not decide the direction at a step, can turn a stretch: with a = 1, c = 1, '
                  's = 2, two steps before and three with what comes back lower the shapers\' share with nothing shared '
                  'and raise it with one to every member (SharedFlips.without_falls, SharedFlips.with_rises).',
            'zh': '同得部分一步之内不定其向，跨一段则可改之：a = 1、c = 1、s = 2，先二后三，无同得则塑规者份额降，每人同得一则升'
                  '（SharedFlips.without_falls、SharedFlips.with_rises）。'}}],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical',
                            'names-provisional', 'omission-not-refutation'],
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.RuleShaping, '
              f'{len(names)} declarations, every one with an empty axiom report, all cited here. Built in one session; '
              f'one independent read-only review by a separate AI agent, taken in study section {N}; not reviewed by a '
              f'person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：Becoming.RuleShaping，{len(names)} 项声明，公理报告皆空，本记录全引。'
              f'于一会话中构建；另一 AI 代理作一次独立只读审查，见研究第 {N} 节；未经人审。'},
    'next_delta': {
        'en': 'Graded capacities; a gain made by the shapers and divided among all; a gain growing with the number of '
              'domains captured (the ratchet); gains passing between domains; a theorem joining what comes back to the '
              'shapers with MA2\'s readers drawn from the selected; a frozen test of whether what comes back decides the '
              'direction; an independent review by a person.',
        'zh': '分级之能；塑规者所得而由众人分享之益；随所捕获之领域数而增之所得（棘轮）；领域间相传之所得；接返于塑规者者与 MA2 取自被选者之读者之定理；'
              '所返是否定向之冻结检验；人之独立审查。'},
    'correspondence': {
        'en': "The meta-attractor's second order (theories/meta-attractor, 'Selection for control over selection', 2 "
              "October 2026): recursive selection favours greater control over future selection where the capacity "
              "varies and is retained, has real influence, and returns to the practice soon enough to outweigh its cost; "
              "its continuous gradient Γ_T − C′(q) is zero where nothing comes back (χ = 0) or the feedback stage is one "
              "step, and its levers act on how much of what rule-making gives comes back to the rule-makers (χ) and on "
              "how fast the support shaping builds decays (δ). Here in counts at a step: s for what comes back, p for "
              "what every member receives; across a stretch, m and n steps before and with what comes back. Price (1970) keeps the accounts of such selection; Olson (1965) "
              "on why a benefit shared by all selects nothing in those who bear its cost; niche construction "
              "(Odling-Smee, Laland and Feldman 2003) on organisms changing the selection they face; rent-seeking "
              "(Tullock 1967; Krueger 1974) and regulatory capture (Stigler 1971) on spending to shape rules; the "
              "persistence of elites (Acemoglu and Robinson 2008); power-seeking of optimal policies (Turner and others "
              "2021); natural selection among AI agents (Hendrycks 2023); influence-seeking patterns (Christiano 2019); "
              "robust agent-agnostic processes (Critch 2021); gradual disempowerment (Kulveit and others 2025). The "
              "offspring comparison is elementary; what this adds is the conditions, joined to RuleCapture's lock, each "
              "bounded by a witness. Positioning list taken from board item AJ's plan.",
        'zh': '元吸引子之第二阶（theories/meta-attractor，〈对选择之控制的选择〉，2026年10月2日）：其能有变异、能保持、有实际影响、且及时返于该实践而胜其成本时，'
              '递归选择偏向对未来选择之更大控制；其连续梯度 Γ_T − C′(q) 于无所返（χ = 0）或反馈段为一步时为零，其杠杆作用于立规所予中返于立规者之多少（χ）'
              '与塑规所建之支持衰减之速（δ）。此处一步之内以计数言之：s 为独返者，p 为众人同得者；跨一段，m 与 n 为有所返之前与之同时之步数。Price (1970) 为此类选择记账；Olson (1965) 论众人同得之益何以不选付其代价者；'
              '生态位构建（Odling-Smee、Laland、Feldman 2003）；寻租（Tullock 1967；Krueger 1974）与规管俘获（Stigler 1971）；'
              '精英之持续（Acemoglu、Robinson 2008）；最优策略之求权（Turner 等 2021）；AI 间之自然选择（Hendrycks 2023）；'
              '求影响之模式（Christiano 2019）；稳健之与主体无关之过程（Critch 2021）；渐进之失权（Kulveit 等 2025）。后代之比较为初等；'
              '所增者为其条件，接于 RuleCapture 之锁定，各以见证为界。定位清单取自看板项 AJ 之计划。'},
    'canonical_source': MOD,
    'aliases': ['The capacity to shape the rule, selected by what comes back to it', '塑规之能，以独返于塑规者之所得被选',
                'selection for control over selection', 'Becoming.RuleShaping.favours_iff'],
    'dependencies': [
        {'id': 'capture-through-the-rule', 'relation': 'formal-reuse',
         'detail': {'en': 'CarrierCounts, its order, favours, disfavours, select, raises, lowers, upper, lower, '
                          'rises_strictly, rises_strictly_along; ReadsShare, Locked, favouring_locks, locked_not_below; '
                          'Pace.paced_succ, Pace.paced_fast_succ.',
                    'zh': 'CarrierCounts 及其序、favours、disfavours、select、raises、lowers、upper、lower、rises_strictly、'
                          'rises_strictly_along；ReadsShare、Locked、favouring_locks、locked_not_below；Pace.paced_succ、Pace.paced_fast_succ。'}}],
    'related': [
        {'id': 'closed-capture',
         'detail': {'en': 'The loop whose every level reads only the share; here the capacity that forms its rule is '
                          'selected.',
                    'zh': '每一层皆只读份额之回路；此处形成其规则之能被选。'}},
        {'id': 'target-capture',
         'detail': {'en': "A target's share among descendants; here the target is the capacity to shape the rule.",
                    'zh': '目标于后代中之份额；此处目标为塑规之能。'}},
        {'id': 'several-optimizers-drain-by-their-joint-capacity',
         'detail': {'en': 'Capacity joined without coupling; here help that lowers the cost of shaping moves the rule '
                          'toward the shapers.',
                    'zh': '能相合而无耦合；此处降低塑规成本之助使规则移向塑规者。'}}],
    'references': [{'path': MOD, 'role': 'proof', 'declarations': sorted(names), 'sha256': sha(MOD)},
                   {'path': RULE, 'role': 'proof', 'sha256': sha(RULE)},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': CH2, 'role': 'statement', 'sha256': sha(CH2)}],
    'proof_bindings': [{'source': MOD, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.RuleShaping',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{'en': f'25 October 2026: added (MA3), the meta-attractor\'s second order; study section {N}.',
                 'zh': f'2026年10月25日：新增（MA3），元吸引子之第二阶；研究第 {N} 节。'}],
}
if (RECORDS / 'readers-drawn-from-the-selected.json').exists():
    record['related'].append({'id': 'readers-drawn-from-the-selected', 'detail': {
        'en': 'MA2: ReadsShare from a pool of readers drawn from the selected; here ReadsShare is equivalent to what comes '
              'back to the shapers being monotone in their share. Related, not a proved adapter: no theorem joins the two yet.',
        'zh': 'MA2：自取自被选者之读者池得 ReadsShare；此处 ReadsShare 等价于返于塑规者者随其份额单调。相关而非已证之接合：尚无定理接二者。'}})
path = RECORDS / f'{RID}.json'
assert not path.exists()
path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', RID, len(names), 'declarations')
