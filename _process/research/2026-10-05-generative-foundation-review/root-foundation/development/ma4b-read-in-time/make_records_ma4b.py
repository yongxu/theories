#!/usr/bin/env python3
"""MA4b records: write loss-read-in-time-by-the-others (every declaration of Becoming.ReadInTime), update MA4's record (its
next step, the two scope items on the readers' timing, a related record, history) and MA2's (a related record, history),
and add this one to the results of the goal generative-alignment (make_records_ma4.py).
usage (from the checkout root, after texts_ma4b.py): python3 -B make_records_ma4b.py RECEIPT N"""
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
MOD = f'{PKG}/Becoming/ReadInTime.lean'
DRAWN = f'{PKG}/Becoming/DrawnShaping.lean'
SHAPING = f'{PKG}/Becoming/RuleShaping.lean'
CLOSED = f'{PKG}/Becoming/ClosedCapture.lean'
RULE = f'{PKG}/Becoming/RuleCapture.lean'
RESOLUTION = f'{PKG}/Becoming/Resolution.lean'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
KIT = RF + 'development/ma4b-read-in-time/'
RECORDS = ROOT / 'theories/becoming/results/records'
GOAL = ROOT / '_process/goals/generative-alignment.json'
RID = 'loss-read-in-time-by-the-others'
MA4 = 'shaping-read-by-readers-drawn-from-the-selected'
MA3 = 'shaping-the-rule-selected-by-what-comes-back'
MA2 = 'readers-drawn-from-the-selected'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
assert core['source_sha256']['Becoming.ReadInTime'] == sha(MOD)
mod = next(m for m in core['modules'] if m['module'] == 'Becoming.ReadInTime')
assert not any(mod['axiom_dependencies'].values())
names = {d['name'] for d in mod['declarations']}


def D(*short):
    out = ['Becoming.ReadInTime.' + s for s in short]
    missing = [n for n in out if n not in names]
    assert not missing, missing
    return out


groups = [
    ("The rule read once the others read the loss: the shapers among the readers read the rule after shaping with hi "
     "coming back to the shapers, whatever the loss, the others with lo while the loss is below N and with lo' from "
     "then on, all with the same a, p and c (ClosedCapture.Thinned.lossPool over three of RuleShaping's rules after "
     "shaping).",
     '他者读损失后所读之规则：读者中塑规者以 hi 为返于塑规者者读塑规后之规则，不论损失；他者于损失未及 N 时以 lo 读之，此后以 lo\' 读之；'
     '皆同 a、p、c（ClosedCapture.Thinned.lossPool 施于 RuleShaping 三塑规后之规则）。',
     D('lossRead', 'course')),
    ("Kept, exactly: with lo' ≤ hi, at a reading step at which the loss has reached N and the rule in force favours the "
     "shapers, the course is locked for good from the next step exactly where x.carrier · c + x.other · c ≤ "
     "x.carrier · hi + x.other · lo' at the share there.",
     '恰留：lo\' ≤ hi 时，于损失已及 N、所行之规则偏向塑规者之读步，进程自下一步起永锁，恰当该处份额满足 '
     'x.carrier · c + x.other · c ≤ x.carrier · hi + x.other · lo\'。',
     D('kept_iff')),
    ("Turned, exactly, one step late: with lo' ≤ hi, at a reading step at which the loss has reached N and the late "
     "reading favours the others at the share there (ties included), the next step reading too, the course is locked "
     "the other way for good from two steps after the reading exactly where the late reading favours the others at "
     "the share of the next step. Each step adds at least one to the loss.",
     '恰转，迟一步：lo\' ≤ hi 时，于损失已及 N、该处份额之迟读偏向他者（含相等）之读步，下一步亦读，进程自读后第二步起永反向锁定，'
     '恰当下一步之份额处迟读偏向他者。每步损失至少增一。',
     D('loss_next', 'turned_iff')),
    ("Before the bound, MA4's course: with the loss starting at zero and growing by one a step, up to step N the joined "
     "course is DrawnShaping's course from the same start and the loss at step t is t; so is the share at step N + 1.",
     '界前为 MA4 之进程：损失自零起每步增一，至第 N 步，所接之进程即同一起点之 DrawnShaping 之进程，第 t 步之损失为 t；'
     '第 N + 1 步之份额亦同。',
     D('lossCourse', 'lossRead_before', 'turn_before', 'early', 'next_share')),
    ("The window in MA4's course: from a start the rule read there favours, lo ≤ hi and lo' ≤ hi, the late reading "
     "never falls along that course; read from N, the course is locked for good from N + 1 exactly where the late "
     "reading favours the shapers at the share of step N, and, step N + 1 reading too, locked the other way for good "
     "from N + 2 exactly where it favours the others (ties included) at the share of step N + 1.",
     'MA4 进程中之窗口：自彼处所读之规则偏向之起点、lo ≤ hi 且 lo\' ≤ hi，沿此进程迟读永不降；自 N 读，进程自 N + 1 起永锁，'
     '恰当第 N 步之份额处迟读偏向塑规者；第 N + 1 步亦读，自 N + 2 起永反向锁定，恰当第 N + 1 步之份额处迟读偏向他者（含相等）。',
     D('late_rises', 'kept_early_iff', 'turned_early_iff')),
    ("In time, late, or the one step between: from such a start, where the late reading favours the others at the "
     "share of a step of MA4's course, it does at every earlier step; and at most one step has the late reading "
     "favouring the others strictly at its share and the shapers strictly at the next.",
     '及时、迟，或其间之一步：自此类起点，MA4 进程某步之份额处迟读偏向他者，则其前每步皆然；其份额处迟读严格偏向他者、'
     '而下一步严格偏向塑规者之步，至多一步。',
     D('in_time_earlier', 'one_between')),
    ("Once favoured, kept: from such a start, where the late reading favours the shapers at the share of a step s of "
     "MA4's course, the others reading the loss from any reading step s + d leave the course locked in the shapers' "
     "favour for good from s + d + 1.",
     '一旦偏向，即留：自此类起点，MA4 进程某步 s 之份额处迟读偏向塑规者，则他者自任一读步 s + d 读损失，进程自 s + d + 1 起永锁于塑规者之利。',
     D('closed_kept')),
    ("The least reading of this form: where the late reading with nothing read as coming back (lo' = 0) favours the "
     "shapers, every late reading of this form does; with c ≤ hi that is exactly where x.other · c ≤ x.carrier · "
     "(hi − c); from a step of MA4's course at which it holds, no reading of this form by the others turns the course.",
     '此形之最小读：无所读为返者之迟读（lo\' = 0）偏向塑规者处，此形之每一迟读皆然；c ≤ hi 时恰当 x.other · c ≤ x.carrier · (hi − c)；'
     '自 MA4 进程中此式成立之步起，他者此形之读皆不转其进程。',
     D('least', 'least_iff', 'closed_for_every')),
    ("A deadline: from a start with a shaper present whose rule g read there favours the shapers strictly, lo ≤ hi, "
     "lo' ≤ hi and c < hi, the others reading the loss from any reading step N with g.other · c · x.other ≤ N leave "
     "the course locked in the shapers' favour for good from N + 1, under every schedule of reading steps.",
     '期限：自有塑规者、彼处所读之规则 g 严格偏向塑规者之起点，lo ≤ hi、lo\' ≤ hi 且 c < hi：他者自满足 g.other · c · x.other ≤ N '
     '之任一读步 N 读损失，进程自 N + 1 起永锁于塑规者之利，对任一读步之安排皆然。',
     D('deadline')),
    ("The route to the deadline: MA4's course is never below the course with the start's rule held fixed, whose counts "
     "are multiplied by that rule's powers; held fixed, a rule favouring strictly carries the share past the least "
     "late reading's threshold by step g.other · c · x.other, a carrier present and c < hi, by Bernoulli's inequality.",
     '至期限之路：MA4 之进程永不低于起点之规则固定不变之进程，后者之计数乘以该规则之幂；固定而严格偏向之规则，有携带者且 c < hi 时，'
     '至第 g.other · c · x.other 步已携份额越过最小迟读之门槛，由伯努利不等式。',
     D('held', 'held_counts', 'powers_base_le', 'held_le', 'held_past')),
    ("Witnesses, with a = 1, p = 0, c = 3, hi = 5, lo = 2 and lo' = 0, from one shaper to one other, read at every "
     "step: read from step 2, the course is locked the other way for good from step 4; read from step 3, though "
     "the late reading still favours the others at the share of step 3 and the rule in force at step 4 favours them, "
     "the course is not turned for good and from step 6 is locked in the shapers' favour for good.",
     '见证：a = 1、p = 0、c = 3、hi = 5、lo = 2、lo\' = 0，自一塑规者对一他者起，每步皆读规则：自第 2 步读，进程自第 4 步起永反向锁定；'
     '自第 3 步读，第 3 步之份额处迟读仍偏向他者，第 4 步所行之规则亦偏向之，然进程不永转，自第 6 步起永锁于塑规者之利。',
     D('Window.one_pos', 'Window.even', 'Window.readFrom', 'Window.in_time', 'Window.too_late')),
    ("Read from step 4 or later with any lo' ≤ 5, the witness's course stays locked in the shapers' favour for good; "
     "its deadline is 24, the rule read at the start being 9 to 8.",
     '自第 4 步或其后以任一 lo\' ≤ 5 读，见证之进程永锁于塑规者之利；其期限为 24，起点所读之规则为九比八。',
     D('Window.late_kept', 'Window.by_deadline')),
]
cited = [n for _, _, ds in groups for n in ds]
assert len(cited) == len(set(cited))
assert set(cited) == names, sorted(names ^ set(cited))

record = {
    'schema_version': 2,
    'id': RID,
    'title': {'en': 'The loss read in time by the others, joined to the critical mass',
              'zh': '他者及时读损失，接于临界量'},
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F01',
    'reviewed_at_utc': NOW,
    'statement': {
        'en': "Where a rule's readers come from those it selects and the others among them read a loss late, only a "
              "reading in time leaves the lock: read while their late reading a step on still favours them, it turns "
              "the course; once it would favour the shapers it keeps the lock, and a deadline closes the window.",
        'zh': '规则之读者取自其所选者、其中他者迟读损失时，唯及时之读离锁定：读时下一步之迟读仍偏向他者，则转其进程；迟读一旦偏向塑规者，'
              '则留锁定；一期限闭此窗口。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': ds} for en, zh, ds in groups],
    'hypotheses': [{
        'en': "No axiom and no premise beyond each law's own: discrete steps, natural counts and others present "
              "(RuleCapture's counts); a positive; two kinds, shapers and others, offspring carrying their parent's kind "
              "(transmission, a premise as in Becoming.Capture); the rule read as the pool of two readings, the readers "
              "counted as the population counts them (ClosedCapture.Drawn.pool); the others reading the loss once it "
              "reaches N, the loss growing by at least one a step (by one a step from zero in MA4's course); all three "
              "readings with the same a, p and c, differing only in what is read as coming back to the shapers; hi, lo, "
              "lo', p, c and N constants; a fixed schedule of reading steps; no noise.",
        'zh': '不加公理，除各律所带者外不加前提：离散之步、自然数计数、他者恒在（RuleCapture 之计数）；a 为正；二类，塑规者与他者，后代携其亲之类'
              '（传递，如 Becoming.Capture 之前提）；所读之规则为二读之池，读者依群体计数（ClosedCapture.Drawn.pool）；他者于损失及 N 后读之，'
              '损失每步至少增一（于 MA4 之进程中自零起每步增一）；三读皆同 a、p、c，唯所读为返于塑规者者有别；hi、lo、lo\'、p、c、N 为常数；'
              '读步之安排固定；无噪声。'}],
    'does_not_show': [
        {'en': 'That actual rules are read by readers drawn from those they select, that the others among them read the '
               'loss at all, or that their late reading has this form, the same a, p and c with a natural number read as '
               'coming back: a late reading of another form, with its own weight, has another window.',
         'zh': '实有之规则由取自其所选者之读者读之，其中他者确读损失，或其迟读具此形（同 a、p、c，所读为返者为自然数）：他形之迟读（自有其权重）其窗口亦异。',
         'kind': 'correspondence'},
        {'en': 'That a trained judge reads as such a pool: the one frozen test of the timing law on one (LA2, '
               'experiments/self-rewarding-lock) found one note in nine turned it, so the law did not apply there.',
         'zh': '受训之评判者如此池而读：时序律于一评判者之唯一冻结检验（LA2，experiments/self-rewarding-lock）见九中一注即转之，故此律于彼不适用。',
         'kind': 'correspondence'},
        {'en': 'The step from which the window is closed: the deadline is a bound, the product g.other · c · x.other, '
               'where the share grows geometrically (24 in the witness, closed from step 4); and no deadline where the '
               'start\'s rule favours the shapers only weakly or no shaper is present.',
         'zh': '窗口自何步而闭：期限为一界，即乘积 g.other · c · x.other，而份额呈几何增长（见证中为 24，自第 4 步已闭）；起点之规则仅弱偏向塑规者，'
               '或无塑规者时，不立期限。',
         'kind': 'scope'},
        {'en': 'Courses with noise, readers who learn, readings changing with the share, a loss read before it reaches N, '
               'and a law for the step between (in the witness a reading from that step is relocked).',
         'zh': '有噪声之进程、会学之读者、随份额而变之读法、损失未及 N 时之读，及其间一步之律（见证中自该步之读复锁）。',
         'kind': 'scope'},
        {'en': 'That a reading in time supports 生生, or that a course turned is better than one kept: no evaluation '
               'enters, and ranking courses needs C.',
         'zh': '及时之读支持生生，或所转之进程优于所留者：不入评价，排序进程须 C。', 'kind': 'non-implication'}],
    'counterexamples': [
        {'path': MOD, 'detail': {
            'en': 'One step too late: read from step 3 in the witness, the late reading still favours the others at the '
                  'share of step 3 and the rule in force at step 4 favours them, yet the course is not turned for good and '
                  'is locked in the shapers\' favour from step 6 (Window.too_late); the same reading from step 2 turns it '
                  '(Window.in_time).',
            'zh': '迟一步：见证中自第 3 步读，第 3 步之份额处迟读仍偏向他者，第 4 步所行之规则亦偏向之，然进程不永转，且自第 6 步起锁于塑规者之利'
                  '（Window.too_late）；自第 2 步同读则转之（Window.in_time）。'}},
        {'path': MOD, 'detail': {
            'en': 'Read late, no reading of this form turns the course: from step 4 of the witness the least late reading '
                  'favours the shapers, so every lo\' ≤ 5 read from step 4 or later leaves the lock in place '
                  '(Window.late_kept).',
            'zh': '迟读，此形之读皆不转其进程：见证自第 4 步起，最小迟读偏向塑规者，故自第 4 步或其后以任一 lo\' ≤ 5 读，锁定留存（Window.late_kept）。'}}],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical',
                            'names-provisional', 'omission-not-refutation'],
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.ReadInTime, '
              f'{len(names)} declarations, every one with an empty axiom report, all cited here. Built in one session; '
              f'one independent read-only review by a separate AI agent, taken as the kit note says, study section {N}; '
              f'not reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：Becoming.ReadInTime，{len(names)} 项声明，公理报告皆空，本记录全引。'
              f'于一会话中构建；另一 AI 代理作一次独立只读审查，依工作包说明采纳，见研究第 {N} 节；未经人审。'},
    'next_delta': {
        'en': 'A late reading of another form, with its own weight, and the window it gives; the loss read before it '
              'reaches N; the step from which the window is closed, not only a bound; noise; readers who learn; an '
              'independent review by a person.',
        'zh': '他形之迟读（自有权重）及其所予之窗口；损失未及 N 时之读；窗口自何步而闭，不止一界；噪声；会学之读者；人之独立审查。'},
    'correspondence': {
        'en': "Collingridge's dilemma (1980): control is easy while the need for it is not yet read, and hard once it is; "
              "here the loss is read only from N, and the window closes a step before the first step at which the late "
              "reading would favour the shapers. The lock is the lock-in of increasing returns and path dependence "
              "(David 1985; Arthur 1989), and the threshold the tipping point of Schelling (1978) and Granovetter "
              "(1978). The lag is that of discrete replicator selection with a delay of one step (Alboszta and Miękisz "
              "2004): the rule read at a step is in force at the next. The model is MA4's stag hunt with the others' "
              "reading changed once the loss reaches N (MA2's Thinned). What is new on the spine is the join: the exact "
              "window, its lag of one step, at most one step between, and a deadline; each law is elementary.",
        'zh': 'Collingridge 之两难（1980）：控制之需未被读时控制易，已被读时则难；此处损失自 N 起方被读，窗口闭于迟读将偏向塑规者之首步之前一步。'
              '锁定即递增回报之锁入与路径依赖（David 1985；Arthur 1989），门槛即 Schelling（1978）与 Granovetter（1978）之临界点。'
              '滞后即一步时滞之离散复制者选择之滞后（Alboszta、Miękisz 2004）：一步所读之规则于下一步施行。模型即 MA4 之猎鹿博弈，他者之读于损失及 N 后改变'
              '（MA2 之 Thinned）。主干上所新者为其接合：精确之窗口、一步之滞后、其间至多一步、一期限；每律皆初等。'},
    'canonical_source': MOD,
    'aliases': ['The loss read in time by the others, joined to the critical mass', '他者及时读损失，接于临界量',
                'the window for reading the loss', 'Becoming.ReadInTime.deadline'],
    'dependencies': [
        {'id': 'capture-through-the-rule', 'relation': 'formal-reuse',
         'detail': {'en': 'CarrierCounts, its order, favours, disfavours, select, select_mono, raises, upper, lower; '
                          'Locked, locked_not_below, reverse; paced_fast_succ; Pace.paced_succ and Pace.turn.',
                    'zh': 'CarrierCounts 及其序、favours、disfavours、select、select_mono、raises、upper、lower；Locked、locked_not_below、'
                          'reverse；paced_fast_succ；Pace.paced_succ 与 Pace.turn。'}},
        {'id': MA2, 'relation': 'formal-reuse',
         'detail': {'en': 'ClosedCapture.Thinned (lossPool, course, rule_read, read_late_kept, read_in_time_turns, '
                          'lossStep_accrues), Beyond.lossStep, join and Accrues; Drawn.pool and pool_reads.',
                    'zh': 'ClosedCapture.Thinned（lossPool、course、rule_read、read_late_kept、read_in_time_turns、lossStep_accrues）、'
                          'Beyond.lossStep、join 与 Accrues；Drawn.pool 与 pool_reads。'}},
        {'id': MA4, 'relation': 'formal-reuse',
         'detail': {'en': 'DrawnShaping.drawn, drawnRead, drawnCourse, drawn_favours_iff, critical_iff, shaped_le_iff, '
                          'drawn_reads_iff and drawn_locks.',
                    'zh': 'DrawnShaping.drawn、drawnRead、drawnCourse、drawn_favours_iff、critical_iff、shaped_le_iff、drawn_reads_iff 与 '
                          'drawn_locks。'}},
        {'id': MA3, 'relation': 'formal-reuse',
         'detail': {'en': 'RuleShaping.shaped alone.', 'zh': '唯 RuleShaping.shaped。'}},
        {'id': 'rest-at-every-resolution', 'relation': 'formal-reuse',
         'detail': {'en': 'powers and bernoulli_powers (Bernoulli\'s inequality for powers).',
                    'zh': 'powers 与 bernoulli_powers（幂之伯努利不等式）。'}}],
    'related': [
        {'id': 'closed-capture',
         'detail': {'en': 'The loop whose every level reads only the share; here a reading beyond the share, the loss read '
                          'by the others, leaves its lock only in time.',
                    'zh': '每一层皆只读份额之回路；此处份额之外之读，即他者所读之损失，唯及时方离其锁定。'}}],
    'references': [{'path': MOD, 'role': 'proof', 'declarations': sorted(names), 'sha256': sha(MOD)},
                   {'path': DRAWN, 'role': 'proof', 'sha256': sha(DRAWN)},
                   {'path': SHAPING, 'role': 'proof', 'sha256': sha(SHAPING)},
                   {'path': CLOSED, 'role': 'proof', 'sha256': sha(CLOSED)},
                   {'path': RULE, 'role': 'proof', 'sha256': sha(RULE)},
                   {'path': RESOLUTION, 'role': 'proof', 'sha256': sha(RESOLUTION)},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': KIT + 'NOTE.md', 'role': 'integration', 'sha256': sha(KIT + 'NOTE.md')},
                   {'path': KIT + 'REVIEW-MA4b.md', 'role': 'review', 'sha256': sha(KIT + 'REVIEW-MA4b.md')},
                   {'path': CH2, 'role': 'statement', 'sha256': sha(CH2)},
                   {'path': OVERVIEW, 'role': 'statement', 'sha256': sha(OVERVIEW)},
                   {'path': META, 'role': 'statement', 'sha256': sha(META)}],
    'proof_bindings': [{'source': MOD, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.ReadInTime',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{'en': f'26 October 2026: added (MA4b), the others\' reading of the loss joined to the critical mass, after '
                       f'one independent review; study section {N}.',
                 'zh': f'2026年10月26日：新增（MA4b），他者读损失接于临界量，经一次独立审查；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists()
path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

# MA4's record: the readers' timing is no longer missing
path = RECORDS / f'{MA4}.json'
d = json.loads(path.read_text(encoding='utf-8'))
old_next = ("A loss read by the others among the readers once the shapers pass the critical mass, the readers' timing "
            "(ClosedCapture.Thinned) joined to the rise; ")
assert d['next_delta']['en'].count(old_next) == 1
d['next_delta']['en'] = d['next_delta']['en'].replace(old_next, '')
d['next_delta']['en'] = d['next_delta']['en'][0].upper() + d['next_delta']['en'][1:]
old_next_zh = '塑规者越过临界量后由读者中他者所读之损失，读者之时序（ClosedCapture.Thinned）接于其升；'
assert d['next_delta']['zh'].count(old_next_zh) == 1
d['next_delta']['zh'] = d['next_delta']['zh'].replace(old_next_zh, '')
item = [x for x in d['does_not_show'] if x['kind'] == 'non-implication' and 'ClosedCapture.Thinned' in x['en']]
assert len(item) == 1
old = 'leaving needs a reading beyond the share (ClosedCapture.Thinned), which is not joined.'
assert item[0]['en'].count(old) == 1
item[0]['en'] = item[0]['en'].replace(old, 'leaving needs a reading beyond the share (ClosedCapture.Thinned), joined in '
                                      + RID + ' (MA4b), where the others\' reading of the loss leaves the lock only in time.')
old_zh = '离开须读份额之外者（ClosedCapture.Thinned），未接。'
assert item[0]['zh'].count(old_zh) == 1
item[0]['zh'] = item[0]['zh'].replace(old_zh, '离开须读份额之外者（ClosedCapture.Thinned），接于 ' + RID + '（MA4b）：他者读损失唯及时方离锁定。')
item = [x for x in d['does_not_show'] if x['kind'] == 'scope' and 'ClosedCapture.Thinned, not joined' in x['en']]
assert len(item) == 1
item[0]['en'] = item[0]['en'].replace('(ClosedCapture.Thinned, not joined)', '(ClosedCapture.Thinned, joined in ' + RID
                                      + ', MA4b)')
assert item[0]['zh'].count('（ClosedCapture.Thinned，未接）') == 1
item[0]['zh'] = item[0]['zh'].replace('（ClosedCapture.Thinned，未接）', '（ClosedCapture.Thinned，接于 ' + RID + '，MA4b）')
assert not any(x['id'] == RID for x in d['related'])
d['related'].append({'id': RID, 'detail': {
    'en': 'MA4b: the others among the readers read a loss once it reaches a bound; their reading leaves this module\'s '
          'lock only in time, with a lag of one step, at most one step between, and a deadline.',
    'zh': 'MA4b：读者中之他者于损失及一界后读之；其读唯及时方离本模块之锁定，滞后一步，其间至多一步，且有期限。'}})
d['history'].append({
    'en': f'26 October 2026 (MA4b, study section {N}): the readers\' timing joined to the critical mass in {RID}; the next '
          'step, the two scope items on the readers\' timing, and a related record updated. The laws are unchanged.',
    'zh': f'2026年10月26日（MA4b，研究第 {N} 节）：读者之时序接于临界量，见 {RID}；下一步、关于读者时序之二范围条目及相关记录随之更新。诸律不变。'})
path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

# MA2's record: a related record
path = RECORDS / f'{MA2}.json'
d = json.loads(path.read_text(encoding='utf-8'))
assert not any(x['id'] == RID for x in d['related'])
d['related'].append({'id': RID, 'detail': {
    'en': 'MA4b: Thinned joined to MA4\'s critical mass; read past the bound, the counts when the loss is read decide, '
          'exactly and with no mirror premise, and a reading turns the course only in time.',
    'zh': 'MA4b：Thinned 接于 MA4 之临界量；界后而读，读损失时之计数定其向，恰如其分且不需镜像前提；读唯及时方转其进程。'}})
d['history'].append({
    'en': f'26 October 2026 (MA4b, study section {N}): related record {RID} added. The laws are unchanged.',
    'zh': f'2026年10月26日（MA4b，研究第 {N} 节）：增相关记录 {RID}。诸律不变。'})
path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

# the goal's results
g = json.loads(GOAL.read_text(encoding='utf-8'))
assert RID not in g['result_ids']
g['result_ids'].append(RID)
GOAL.write_text(json.dumps(g, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('records:', RID, len(names), 'declarations; MA4 and MA2 records updated; goal results', len(g['result_ids']))
