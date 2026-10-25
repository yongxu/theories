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
RECURRENCE = f'{PKG}/Becoming/Recurrence.lean'
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
     D('shapedLossPool', 'course')),
    ("Kept, exactly: where every step adds at least one to the loss and lo' ≤ hi, at a reading step at which the loss "
     "has reached N and the rule in force favours the shapers, the course is locked for good from the next step exactly "
     "where x.carrier · c + x.other · c ≤ x.carrier · hi + x.other · lo' at the share there.",
     '恰留：每步损失至少增一且 lo\' ≤ hi 时，于损失已及 N、所行之规则偏向塑规者之读步，进程自下一步起永锁，恰当该处份额满足 '
     'x.carrier · c + x.other · c ≤ x.carrier · hi + x.other · lo\'。',
     D('kept_iff')),
    ("Turned, exactly, one step late: where every step adds at least one to the loss and lo' ≤ hi, at a reading step "
     "at which the loss has reached N and the late reading favours the others at the share there (ties included), the "
     "next step reading too, the course is locked the other way for good from two steps after the reading exactly where "
     "the late reading favours the others at the share of the next step.",
     '恰转，迟一步：每步损失至少增一且 lo\' ≤ hi 时，于损失已及 N、该处份额之迟读偏向他者（含相等）之读步，下一步亦读，'
     '进程自读后第二步起永反向锁定，恰当下一步之份额处迟读偏向他者。',
     D('loss_next', 'turned_iff')),
    ("Before the bound, MA4's course: with the loss starting at zero and growing by one a step, up to step N the joined "
     "course is DrawnShaping's course from the same start and the loss at step t is t; so is the share at step N + 1.",
     '界前为 MA4 之进程：损失自零起每步增一，至第 N 步，所接之进程即同一起点之 DrawnShaping 之进程，第 t 步之损失为 t；'
     '第 N + 1 步之份额亦同。',
     D('lossCourse', 'shapedLossPool_before', 'turn_before', 'early', 'next_share')),
    ("The window in MA4's course: from a start the rule read there favours, lo ≤ hi and lo' ≤ hi, the late reading "
     "never falls along that course; read from a reading step N, the course is locked for good from N + 1 exactly where "
     "the late reading favours the shapers at the share of step N, and, step N + 1 reading too, the other way from N + 2 "
     "exactly where it favours the others (ties included) at the share of step N + 1.",
     'MA4 进程中之窗口：自彼处所读之规则偏向之起点、lo ≤ hi 且 lo\' ≤ hi，沿此进程迟读永不降；自读步 N 读，进程自 N + 1 起永锁，'
     '恰当第 N 步之份额处迟读偏向塑规者；第 N + 1 步亦读，自 N + 2 起永反向锁定，恰当第 N + 1 步之份额处迟读偏向他者（含相等）。',
     D('late_never_falls', 'kept_early_iff', 'turned_early_iff')),
    ("In-time steps first, at most one between: from such a start, where the late reading favours the others at the "
     "share of a step of MA4's course, it does at every earlier step; with lo ≤ hi alone, at most one step has the late "
     "reading favouring the others strictly at its share and the shapers strictly at the next: a run of rules that never "
     "falls has at most one such step, one that never rises none.",
     '及时之步在前，其间至多一步：自此类起点，MA4 进程某步之份额处迟读偏向他者，则其前每步皆然；唯 lo ≤ hi 时，其份额处迟读严格偏向他者、'
     '而下一步严格偏向塑规者之步至多一步：永不降之规则序列至多有一此步，永不升者则无。',
     D('in_time_earlier', 'at_most_one_between_up', 'none_between_down', 'at_most_one_between')),
    ("The next round: where the late reading favours the shapers at the share of step N + 1 of MA4's course, as at the "
     "one step between, lo' ≤ hi, steps N + 1 and N + 2 reading, the course read from N is locked in the shapers' favour "
     "from N + 3 exactly where the late reading favours them at its share of step N + 2; neither the start favoured nor "
     "lo ≤ hi is needed.",
     '下一轮：MA4 进程第 N + 1 步之份额处迟读偏向塑规者（如其间之一步），lo\' ≤ hi，第 N + 1、N + 2 步皆读：自 N 读之进程自 N + 3 起'
     '永锁于塑规者之利，恰当其第 N + 2 步之份额处迟读偏向之；不需起点偏向，亦不需 lo ≤ hi。',
     D('kept_next_round_iff')),
    ("Once favoured, kept: from such a start, where the late reading favours the shapers at the share of a step s of "
     "MA4's course, the others reading the loss from any reading step s + d leave the course locked in the shapers' "
     "favour at every step from s + d + 1.",
     '一旦偏向，即留：自此类起点，MA4 进程某步 s 之份额处迟读偏向塑规者，则他者自任一读步 s + d 读损失，进程自 s + d + 1 起每步皆锁于塑规者之利。',
     D('kept_once_favoured')),
    ("The least reading of this form: where the late reading with nothing read as coming back (lo' = 0) favours the "
     "shapers, every late reading of this form does; with c ≤ hi that is exactly where x.other · c ≤ x.carrier · "
     "(hi − c); with lo ≤ hi, from a step of MA4's course at which it holds, every reading of this form with lo' ≤ hi "
     "from a reading step keeps the lock from the step after, with no premise on the start.",
     '此形之最小读：无所读为返者之迟读（lo\' = 0）偏向塑规者处，此形之每一迟读皆然，不论 lo\'；c ≤ hi 时恰当 x.other · c ≤ '
     'x.carrier · (hi − c)；lo ≤ hi 时，自 MA4 进程中此式成立之步起，此形且 lo\' ≤ hi 之读自读步之下一步起皆留锁定，起点之偏向随之。',
     D('least', 'least_iff', 'kept_past_least')),
    ("A deadline: from a start with a shaper present whose rule g read there favours the shapers strictly, lo ≤ hi and "
     "lo' ≤ hi, so that c < hi, the others reading the loss from any reading step N with g.other · c · x.other ≤ N "
     "leave the course locked in the shapers' favour at every step from N + 1, under every schedule of reading steps.",
     '期限：自有塑规者、彼处所读之规则 g 严格偏向塑规者之起点，lo ≤ hi 且 lo\' ≤ hi（故 c < hi）：他者自满足 g.other · c · x.other ≤ N '
     '之任一读步 N 读损失，进程自 N + 1 起每步皆锁于塑规者之利，对任一读步之安排皆然。',
     D('covers_of_strict', 'deadline')),
    ("The route to the deadline: MA4's course is never below the course with the start's rule held fixed (Law.orbit), "
     "whose counts are multiplied by that rule's powers (RuleShaping.orbit_held); held fixed, a rule favouring strictly "
     "carries the share past the least late reading's threshold by step g.other · c · x.other, a carrier present and "
     "c < hi, by Bernoulli's inequality.",
     '至期限之路：MA4 之进程永不低于起点之规则固定不变之进程（Law.orbit），后者之计数乘以该规则之幂（RuleShaping.orbit_held）；'
     '固定而严格偏向之规则，有携带者且 c < hi 时，至第 g.other · c · x.other 步已携份额越过最小迟读之门槛，由伯努利不等式。',
     D('powers_eq_pow', 'held_counts', 'powers_base_le', 'held_le', 'held_past')),
    ("Witness: a = 1, p = 0, c = 3, hi = 5, lo = 2, lo' = 0, one shaper to one other, read every step. Read from step "
     "2, the course is locked the other way for good from step 4. Step 3 is the one step between: read from there, though "
     "the late reading still favours the others at the share of step 3 and the rule in force at step 4 favours them, the "
     "course is not turned and from step 6 is locked in the shapers' favour.",
     '见证：a = 1、p = 0、c = 3、hi = 5、lo = 2、lo\' = 0，自一塑规者对一他者起，每步皆读规则。自第 2 步读，进程自第 4 步起永反向锁定。'
     '第 3 步为其间之一步：自彼读，第 3 步之份额处迟读仍偏向他者，第 4 步所行之规则亦偏向之，然进程不永转，自第 6 步起永锁于塑规者之利。',
     D('Window.readFrom', 'Window.in_time', 'Window.between', 'Window.too_late')),
    ("Read from step 4 or later with any lo' ≤ 5, the witness's course stays locked in the shapers' favour; its "
     "deadline is 24, the rule read at the start being 9 to 8. From two shapers to two others the least late reading "
     "still favours the others at the share of step 3 and every such reading from step 4 on keeps the lock, yet the "
     "deadline is 96.",
     '自第 4 步或其后以任一 lo\' ≤ 5 读，见证之进程永锁于塑规者之利；其期限为 24，起点所读之规则为九比八。自二塑规者对二他者起，第 3 步之份额处'
     '最小迟读仍偏向他者，自第 4 步起此类之读皆留锁定，而期限为 96。',
     D('Window.late_kept', 'Window.by_deadline', 'Window.twoToTwo', 'Window.scaled')),
    ("The step between can be turned: with a = 1, p = 0, c = 1, hi = 3, lo = 2 and lo' = 0, from one shaper to three "
     "others, read at every step, the start's rule favours the shapers, step 0 is the step between, and read from there "
     "the course is locked the other way for good from step 4.",
     '其间之一步可转：a = 1、p = 0、c = 1、hi = 3、lo = 2、lo\' = 0，自一塑规者对三他者起，每步皆读，起点之规则偏向塑规者，第 0 步为其间之一步，'
     '自彼读则进程自第 4 步起永反向锁定。',
     D('Between.turned')),
    ("A tie: at MA4's critical mass (c = 1, hi = 3, lo = lo' = 0, from one shaper to two others, read at every step) "
     "every rule read ties, and the course read from step 0 is locked both in the shapers' favour from step 1 and the "
     "other way from step 2: favours and disfavours are weak.",
     '相等：于 MA4 之临界量（c = 1、hi = 3、lo = lo\' = 0，自一塑规者对二他者起，每步皆读），所读之规则皆相等，自第 0 步读之进程既自第 1 步起'
     '锁于塑规者之利，又自第 2 步起反向锁定：偏向与不偏向皆为弱者。',
     D('Tie.both')),
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
        'en': "Where a rule's readers come from those it selects and the others among them read a loss late, a reading "
              "while their late reading a step on still favours them turns the course; once it would favour the shapers "
              "the lock stays; at most one step lies between, and a deadline bounds the window.",
        'zh': '规则之读者取自其所选者、其中他者迟读损失时：读时下一步之迟读仍偏向他者，则转其进程；迟读一旦偏向塑规者，则锁定留存；其间至多一步；'
              '一期限界此窗口。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': ds} for en, zh, ds in groups],
    'hypotheses': [
        {'en': "No axiom and no premise beyond each law's own: discrete steps, natural counts and others present "
               "(RuleCapture's counts); a positive; two kinds, shapers and others, offspring carrying their parent's "
               "kind (transmission, a premise as in Becoming.Capture); the rule read as the pool of two readings, the "
               "readers counted as the population counts them (ClosedCapture.Drawn.pool); no noise.",
         'zh': '不加公理，除各律所带者外不加前提：离散之步、自然数计数、他者恒在（RuleCapture 之计数）；a 为正；二类，塑规者与他者，后代携其亲之类'
               '（传递，如 Becoming.Capture 之前提）；所读之规则为二读之池，读者依群体计数（ClosedCapture.Drawn.pool）；无噪声。'},
        {'en': "The others reading the loss once it reaches N, the loss growing by at least one a step (by one a step "
               "from zero in MA4's course); all three readings with the same a, p and c, differing only in what is read "
               "as coming back to the shapers; hi, lo, lo', p, c and N constants; a fixed schedule of reading steps, the "
               "window's laws reading at N and N + 1.",
         'zh': '他者于损失及 N 后读之，损失每步至少增一（于 MA4 之进程中自零起每步增一）；三读皆同 a、p、c，唯所读为返于塑规者者有别；'
               'hi、lo、lo\'、p、c、N 为常数；读步之安排固定，窗口之律于 N 与 N + 1 皆读。'}],
    'does_not_show': [
        {'en': 'That actual rules are read by readers drawn from those they select, that the others among them read the '
               'loss at all, or that their late reading has this form, the same a, p and c with a natural number read as '
               'coming back.',
         'zh': '实有之规则由取自其所选者之读者读之，其中他者确读损失，或其迟读具此形（同 a、p、c，所读为返者为自然数）。',
         'kind': 'correspondence'},
        {'en': 'That a trained judge reads as such a pool: the one frozen test of the timing law on one (LA2, '
               'experiments/self-rewarding-lock) found one note in nine turned it, so the law did not apply there.',
         'zh': '受训之评判者如此池而读：时序律于一评判者之唯一冻结检验（LA2，experiments/self-rewarding-lock）见九中一注即转之，故此律于彼不适用。',
         'kind': 'correspondence'},
        {'en': 'A late reading of another form: with its own weight it has another window, and with a weight against '
               'the shapers chosen after the share is seen, far enough below theirs, the others could turn the course '
               'from any share.',
         'zh': '他形之迟读：自有权重者其窗口亦异；见份额后方定、对塑规者足够低之权重，则他者可自任一份额转其进程。',
         'kind': 'scope'},
        {'en': 'The step from which the window is closed: the deadline is a bound, quadratic in the start\'s counts '
               '(24 in the witness and 96 from two to two, both closed from step 4); none is stated for a weakly '
               'favouring start or one with no shaper.',
         'zh': '窗口自何步而闭：期限为一界，于起点之计数为二次（见证中为 24，二对二时为 96，皆自第 4 步已闭）；起点之规则仅弱偏向塑规者或无塑规者时，'
               '不立期限。',
         'kind': 'scope'},
        {'en': 'Courses with noise, readers who learn, readings changing with the share, a loss read before it reaches N, '
               'and a general law for the round from the one step between, which goes either way in the witnesses.',
         'zh': '有噪声之进程、会学之读者、随份额而变之读法、损失未及 N 时之读，及自其间一步起之一轮之一般律（见证中两向皆有）。',
         'kind': 'scope'},
        {'en': 'That the joint selection\'s two conditions are independent: here a lock is left in time where control '
               'is selected, not the converse.',
         'zh': '共同选择之二条件相互独立：此处控制被选之处锁定可及时而离，其逆未示。',
         'kind': 'non-implication'},
        {'en': 'That a reading in time supports 生生, or that a course turned is better than one kept: no evaluation '
               'enters, and ranking courses needs C.',
         'zh': '及时之读支持生生，或所转之进程优于所留者：不入评价，排序进程须 C。', 'kind': 'non-implication'}],
    'counterexamples': [
        {'path': MOD, 'detail': {
            'en': 'One step too late in the witness: read from step 3, the late reading still favours the others at the '
                  'share of step 3 and the rule in force at step 4 favours them, yet the course is not turned for good and '
                  'is locked in the shapers\' favour from step 6 (Window.too_late); the same reading from step 2 turns it '
                  '(Window.in_time).',
            'zh': '见证中迟一步：自第 3 步读，第 3 步之份额处迟读仍偏向他者，第 4 步所行之规则亦偏向之，然进程不永转，且自第 6 步起锁于塑规者之利'
                  '（Window.too_late）；自第 2 步同读则转之（Window.in_time）。'}},
        {'path': MOD, 'detail': {
            'en': 'The step between is not always too late: from one shaper to three others, read from the step between, '
                  'the course is turned for good from step 4 (Between.turned).',
            'zh': '其间之一步非恒迟：自一塑规者对三他者起，自其间之一步读，进程自第 4 步起永转（Between.turned）。'}},
        {'path': MOD, 'detail': {
            'en': 'Read late, every reading of this form with lo\' ≤ 5 keeps the lock: from step 4 of the witness the '
                  'least late reading favours the shapers (Window.late_kept).',
            'zh': '迟读，此形且 lo\' ≤ 5 之读皆留锁定：见证自第 4 步起，最小迟读偏向塑规者（Window.late_kept）。'}},
        {'path': MOD, 'detail': {
            'en': 'At a tie a reading both keeps the lock and turns the course in the sense of these laws (Tie.both).',
            'zh': '相等之处，依此诸律之义，一读既留锁定又转其进程（Tie.both）。'}},
        {'path': MOD, 'detail': {
            'en': 'The deadline is not a law of the share: from two to two the window is that from one to one, the '
                  'deadline 96 instead of 24 (Window.scaled).',
            'zh': '期限非份额之律：二对二时窗口同于一对一，期限为 96 而非 24（Window.scaled）。'}}],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical',
                            'names-provisional', 'omission-not-refutation'],
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.ReadInTime, '
              f'{len(names)} declarations, every one with an empty axiom report, all cited here. Built in one session; '
              f'one independent read-only review by a separate AI agent, its findings taken as the kit note says '
              f'(its probes kept in the kit), study section {N}; not reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：Becoming.ReadInTime，{len(names)} 项声明，公理报告皆空，本记录全引。'
              f'于一会话中构建；另一 AI 代理作一次独立只读审查，其所见依工作包说明采纳（其探针存于工作包），见研究第 {N} 节；未经人审。'},
    'next_delta': {
        'en': 'A late reading of another form, with its own weight, and the window it gives; the loss read before it '
              'reaches N; a law for the round from the step between; the step from which the window is closed, not only '
              'a bound; noise; readers who learn; an independent review by a person.',
        'zh': '他形之迟读（自有权重）及其所予之窗口；损失未及 N 时之读；自其间一步起之一轮之律；窗口自何步而闭，不止一界；噪声；会学之读者；人之独立审查。'},
    'correspondence': {
        'en': "Collingridge's dilemma (1980) has two horns: while change is easy its need cannot be known, and once it is "
              "known change is hard. Here the second is a theorem (from the first step at which the late reading would "
              "favour the shapers a reading keeps the lock, and past the least reading's threshold every reading of this "
              "form does) and the first a premise, the loss read only from N. Biggs, Carpenter and Brock (2009) give the "
              "continuous analogue of the window: the window for averting a regime shift ends abruptly. The lock is the "
              "lock-in of increasing returns and path dependence (David 1985; Arthur 1989; Cowan 1991), and the "
              "threshold the tipping point of Schelling (1978) and Granovetter (1978). The lag is the representation's, a "
              "rule read at a step being in force from the next; compare replicator selection with a delay (Alboszta and "
              "Miękisz 2004). The model is MA4's stag hunt with the others' reading changed once the loss reaches N "
              "(MA2's Thinned). What is new on the spine is the join: a window exact at every step but at most one, given "
              "readings at N and N + 1, its lag of one step, and a deadline; each law is elementary.",
        'zh': 'Collingridge 之两难（1980）有二端：改易尚易时其需不可知，其需既知则改易已难。此处后端为定理（迟读将偏向塑规者之首步起，一读即留锁定；'
              '越过最小读之门槛后，此形之读皆然），前端为前提，即损失自 N 起方被读。Biggs、Carpenter 与 Brock（2009）予此窗口之连续类比：'
              '避免体制转换之窗口骤然而闭。锁定即递增回报之锁入与路径依赖（David 1985；Arthur 1989；Cowan 1991），门槛即 Schelling（1978）与 '
              'Granovetter（1978）之临界点。滞后属表示：一步所读之规则自下一步施行；可比有时滞之复制者选择（Alboszta、Miękisz 2004）。模型即 MA4 之'
              '猎鹿博弈，他者之读于损失及 N 后改变（MA2 之 Thinned）。主干上所新者为其接合：N 与 N + 1 皆读时，除至多一步外每步皆精确之窗口、'
              '一步之滞后、一期限；每律皆初等。'},
    'canonical_source': MOD,
    'aliases': ['The loss read in time by the others, joined to the critical mass', '他者及时读损失，接于临界量',
                'the window for reading the loss', 'Becoming.ReadInTime.deadline'],
    'dependencies': [
        {'id': 'capture-through-the-rule', 'relation': 'formal-reuse',
         'detail': {'en': 'CarrierCounts, its order, favours, disfavours, select, select_mono, raises, lowers, upper, '
                          'lower; Locked, locked_not_below, reverse; paced_fast_succ; Pace.paced_succ and Pace.turn.',
                    'zh': 'CarrierCounts 及其序、favours、disfavours、select、select_mono、raises、lowers、upper、lower；Locked、'
                          'locked_not_below、reverse；paced_fast_succ；Pace.paced_succ 与 Pace.turn。'}},
        {'id': MA2, 'relation': 'formal-reuse',
         'detail': {'en': 'ClosedCapture.Thinned (lossPool, course, rule_read, read_late_kept, read_in_time_turns, '
                          'lossStep_accrues), Beyond.lossStep, join, Accrues and loss_grows; Drawn.pool, pool_reads and '
                          'pool_against.',
                    'zh': 'ClosedCapture.Thinned（lossPool、course、rule_read、read_late_kept、read_in_time_turns、lossStep_accrues）、'
                          'Beyond.lossStep、join、Accrues 与 loss_grows；Drawn.pool、pool_reads 与 pool_against。'}},
        {'id': MA4, 'relation': 'formal-reuse',
         'detail': {'en': 'DrawnShaping.drawn, drawnRead, drawnCourse, drawn_favours_iff, critical_iff, shaped_le_iff, '
                          'drawn_reads_iff, drawn_locks and drawn_from_below; the witnesses CriticalMass.one_pos, even, '
                          'oneToTwo and oneToThree.',
                    'zh': 'DrawnShaping.drawn、drawnRead、drawnCourse、drawn_favours_iff、critical_iff、shaped_le_iff、drawn_reads_iff、'
                          'drawn_locks 与 drawn_from_below；见证 CriticalMass.one_pos、even、oneToTwo 与 oneToThree。'}},
        {'id': MA3, 'relation': 'formal-reuse',
         'detail': {'en': 'RuleShaping.shaped, and RuleShaping.orbit_held for Law.orbit under a rule held fixed.',
                    'zh': 'RuleShaping.shaped，及固定规则下 Law.orbit 之 RuleShaping.orbit_held。'}},
        {'id': 'rest-at-every-resolution', 'relation': 'formal-reuse',
         'detail': {'en': 'powers and bernoulli_powers (Bernoulli\'s inequality for powers).',
                    'zh': 'powers 与 bernoulli_powers（幂之伯努利不等式）。'}}],
    'related': [
        {'id': 'closed-capture',
         'detail': {'en': 'The loop whose every level reads only the share; here a reading beyond the share, the loss read '
                          'by the others, leaves its lock only before their late reading would favour the shapers.',
                    'zh': '每一层皆只读份额之回路；此处份额之外之读，即他者所读之损失，唯于其迟读偏向塑规者之前方离其锁定。'}}],
    'references': [{'path': MOD, 'role': 'proof', 'declarations': sorted(names), 'sha256': sha(MOD)},
                   {'path': DRAWN, 'role': 'proof', 'sha256': sha(DRAWN)},
                   {'path': SHAPING, 'role': 'proof', 'sha256': sha(SHAPING)},
                   {'path': CLOSED, 'role': 'proof', 'sha256': sha(CLOSED)},
                   {'path': RULE, 'role': 'proof', 'sha256': sha(RULE)},
                   {'path': RESOLUTION, 'role': 'proof', 'sha256': sha(RESOLUTION)},
                   {'path': RECURRENCE, 'role': 'proof', 'sha256': sha(RECURRENCE)},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': KIT + 'NOTE.md', 'role': 'integration', 'sha256': sha(KIT + 'NOTE.md')},
                   {'path': KIT + 'REVIEW-MA4b.md', 'role': 'review', 'sha256': sha(KIT + 'REVIEW-MA4b.md')},
                   {'path': KIT + 'review-probe-ReadInTimeProbe.lean.txt', 'role': 'review',
                    'sha256': sha(KIT + 'review-probe-ReadInTimeProbe.lean.txt')},
                   {'path': CH2, 'role': 'statement', 'sha256': sha(CH2)},
                   {'path': OVERVIEW, 'role': 'statement', 'sha256': sha(OVERVIEW)},
                   {'path': META, 'role': 'statement', 'sha256': sha(META)}],
    'proof_bindings': [{'source': MOD, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.ReadInTime',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{'en': f'26 October 2026: added (MA4b), the others\' reading of the loss joined to the critical mass, after '
                       f'one independent review and its fix round; study section {N}.',
                 'zh': f'2026年10月26日：新增（MA4b），他者读损失接于临界量，经一次独立审查及其修订；研究第 {N} 节。'}],
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
                                      + RID + ' (MA4b).')
old_zh = '离开须读份额之外者（ClosedCapture.Thinned），未接。'
assert item[0]['zh'].count(old_zh) == 1
item[0]['zh'] = item[0]['zh'].replace(old_zh, '离开须读份额之外者（ClosedCapture.Thinned），接于 ' + RID + '（MA4b）。')
item = [x for x in d['does_not_show'] if x['kind'] == 'scope' and 'ClosedCapture.Thinned, not joined' in x['en']]
assert len(item) == 1
item[0]['en'] = item[0]['en'].replace('(ClosedCapture.Thinned, not joined)', '(ClosedCapture.Thinned, joined in ' + RID
                                      + ', MA4b)')
assert item[0]['zh'].count('（ClosedCapture.Thinned，未接）') == 1
item[0]['zh'] = item[0]['zh'].replace('（ClosedCapture.Thinned，未接）', '（ClosedCapture.Thinned，接于 ' + RID + '，MA4b）')
assert not any(x['id'] == RID for x in d['related'])
d['related'].append({'id': RID, 'detail': {
    'en': 'MA4b: the others among the readers read a loss once it reaches a bound; their reading leaves this module\'s '
          'lock only before their late reading would favour the shapers, for good while it still favours them a step '
          'on, with a lag of one step, at most one step between, and a deadline.',
    'zh': 'MA4b：读者中之他者于损失及一界后读之；其读唯于其迟读偏向塑规者之前方离本模块之锁定，下一步之迟读仍偏向他者时则永离，滞后一步，'
          '其间至多一步，且有期限。'}})
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
          'exactly and with no mirror premise, and a reading turns the course only before the late reading would '
          'favour the shapers.',
    'zh': 'MA4b：Thinned 接于 MA4 之临界量；界后而读，读损失时之计数定其向，恰如其分且不需镜像前提；读唯于迟读偏向塑规者之前方转其进程。'}})
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
