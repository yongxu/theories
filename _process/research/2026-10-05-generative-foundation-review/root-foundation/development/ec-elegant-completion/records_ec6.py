#!/usr/bin/env python3
"""EC6's records: the new record rest-by-balance (the law in Becoming.Amounts and its five cases), and a history note
with a related link in each of the seven records whose cited law is now proved as one of its cases. Re-pointing the
other records that cite the four changed sources is left to tools/research/repoint.py (bookkeeping, logged once).
python3 -B records_ec6.py CORE_RECEIPT_ID STUDY_SECTION   (from the checkout root)"""
import datetime, hashlib, json, re, sys
from pathlib import Path
ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
assert re.search(rf'^## {N}\. Rest by balance: the course and regime series as its cases \(EC6\)$',
                 (ROOT / STUDY).read_text(), re.M)
elab = {m['module']: {d['name'] for d in m['declarations']} for m in core['modules']}
src = lambda m: f'{PKG}/Becoming/{m}.lean'
sha = lambda p: hashlib.sha256((ROOT / p).read_bytes()).hexdigest()

LAW = ['Becoming.Amounts.total_steps_lose', 'Becoming.Amounts.total_steps_le', 'Becoming.Amounts.total_steps_add',
       'Becoming.Amounts.falls_by_stretch', 'Becoming.Amounts.unmarked_or_marked', 'Becoming.Amounts.unmarked_within',
       'Becoming.Amounts.le_by_exchange']
CASES = {'Optimum': ['Becoming.Optimum.ends_within', 'Becoming.Optimum.drawnAt', 'Becoming.Optimum.falls_over',
                     'Becoming.Optimum.Next.drawable_le_of_gains', 'Becoming.Optimum.Next.drawable_step'],
         'LastChange': ['Becoming.LastChange.still_within', 'Becoming.LastChange.room_balance',
                        'Becoming.LastChange.still_of_fixed_at'],
         'RegimeMargin': ['Becoming.RegimeMargin.Adjusted.orbit_bound', 'Becoming.RegimeMargin.Adjusted.step_balances',
                          'Becoming.RegimeMargin.Adjusted.orbit_inside',
                          'Becoming.RegimeMargin.Coupled.Indexed.rests_by']}
for n in LAW:
    assert n in elab['Becoming.Amounts'], n
for m, ns in CASES.items():
    for n in ns:
        assert n in elab[f'Becoming.{m}'], n
assert 'Becoming.balance_over_stretch_on' in elab['Becoming.Prelude']
now = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()


def binding(m):
    return {'source': src(m), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{m}',
            'success_pointer': '/status', 'success_value': 'passed'}


new = {
    'schema_version': 2,
    'id': 'rest-by-balance',
    'title': {'en': 'Rest by balance', 'zh': '由平衡而停息'},
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F01',
    'reviewed_at_utc': now,
    'statement': {
        'en': 'A count balanced across each step that loses at least one more than it gains at each falls by at least '
              'the number of steps; so marked steps cannot outrun what stood, and two balanced counts compare by their '
              'exchanges alone.',
        'zh': '每步平衡、且每步所失比所得至少多一的计数，至少下降所经的步数；所以被标记的步不能多于起初所立者，两个平衡的计数只由其交换相比较。'},
    'laws': [
        {'en': 'Where a count is balanced across each step of a stretch (after the step with what it loses equals before '
               'it with what it gains) and loses at least one more than it gains at each, it ends the stretch with the '
               "stretch's length within what it was at the start. The stretch balance is the reason.",
         'zh': '若一个计数在一段步的每步上平衡（步后加所失等于步前加所得），且每步所失比所得至少多一，则段末的计数加上段长不超过段首的计数。理由是段上的平衡。',
         'declarations': ['Becoming.Amounts.falls_by_stretch', 'Becoming.Amounts.total_steps_lose',
                          'Becoming.balance_over_stretch_on']},
        {'en': 'Where whether a step is marked is decided, and from a step on the count is balanced across each step and '
               'loses at least one more than it gains at each marked step, some step from there within what the count '
               'was is unmarked. The steps up to that bound are searched, so no omniscience is used.',
         'zh': '若每步是否被标记可判定，且自某步起计数每步平衡、在每个被标记的步所失比所得至少多一，则自该步起、在计数当时之值以内，有一步未被标记。所搜的步有界，不用全知原则。',
         'declarations': ['Becoming.Amounts.unmarked_within', 'Becoming.Amounts.unmarked_or_marked']},
        {'en': "Two counts balanced across each step of a stretch, the first starting within the second: where at each "
               "step the first's gain with the second's loss is within the second's gain with the first's loss, the "
               'first ends the stretch within the second.',
         'zh': '两个在一段步的每步上平衡的计数，第一个起于第二个之内：若每步第一个的所得加第二个的所失不超过第二个的所得加第一个的所失，则第一个在段末仍在第二个之内。',
         'declarations': ['Becoming.Amounts.le_by_exchange', 'Becoming.Amounts.total_steps_le',
                          'Becoming.Amounts.total_steps_add']},
        {'en': 'Its cases among courses: a course drawn above its renewal falls below every positive need within its '
               'starting excess over it, its step balancing with what it takes; and a course gaining the most at each '
               'step could draw, weighted, at least what any open course could.',
         'zh': '其在过程上的情形：汲取超过更新的过程在其起点超出需要之数以内落到任一正需要之下，其步与所取相平衡；每步获益最多的过程，加权后可汲取的不少于任一开放过程。',
         'declarations': ['Becoming.Optimum.ends_within', 'Becoming.Optimum.drawnAt',
                          'Becoming.Optimum.Next.drawable_le_of_gains', 'Becoming.Optimum.Next.drawable_step']},
        {'en': "Its cases among runs and regimes: a law's run with a bounded mark comes to rest within the bound; below a "
               "regime's point of no return the level falls by at least one a step until nothing is left; and a coupled "
               'web within a band under mutual support comes to rest.',
         'zh': '其在运行与体制上的情形：带有界标记的律之运行在界内静止；在体制的不归点之下，水平每步至少降一，直到一无所余；互相支持、在带内的耦合网静止。',
         'declarations': ['Becoming.LastChange.still_within', 'Becoming.LastChange.room_balance',
                          'Becoming.LastChange.still_of_fixed_at', 'Becoming.RegimeMargin.Adjusted.orbit_bound',
                          'Becoming.RegimeMargin.Adjusted.step_balances', 'Becoming.RegimeMargin.Adjusted.orbit_inside',
                          'Becoming.RegimeMargin.Coupled.Indexed.rests_by']},
    ],
    'hypotheses': [
        {'en': 'Balance at each step is a premise of the law, supplied by each case: a course takes what stands with what '
               'is given less what stands after; a regime\'s draw takes all there is up to the draw.',
         'zh': '每步的平衡是本律的前提，由各情形给出：过程所取是所立加所给减步后所立；体制的汲取取尽所有，至多到汲取量。'},
        {'en': "Where the loss is a count's own fall recorded as what it loses (a run's mark, what the draws leave of a "
               'web), balance adds no premise: the law then counts the falls of a count that never rises.',
         'zh': '若所失是计数自身的下降被记为所失（运行的标记、汲取留给网的），平衡不增加前提：本律此时计数一个从不上升的计数的下降。'},
    ],
    'does_not_show': [
        {'en': 'Stated in whole numbers; in denser amounts a fall at every step need not end.',
         'zh': '在整数中陈述；在更稠密的量中，每步下降不必终止。', 'kind': 'scope'},
        {'en': 'It bounds how long a count can lose; it does not say that the count reaches nothing.',
         'zh': '它限定计数能失去多久；不说计数会归于无。', 'kind': 'non-implication'},
        {'en': 'The comparison orders the counts at the end; it does not order what each drew at each step.',
         'zh': '比较给出段末计数的次序；不给出每步各自所取的次序。', 'kind': 'non-implication'},
    ],
    'counterexamples': [],
    'standard_boundaries': ['discrete-steps', 'decidability', 'no-ethical-premise', 'no-evaluation',
                            'formal-not-empirical', 'names-provisional'],
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the declarations of '
              'Becoming.Amounts, Becoming.LastChange, Becoming.Optimum and Becoming.RegimeMargin have empty axiom '
              'reports, and the five cases are proved through the law with their statements unchanged.',
        'zh': f'由合并的 Lean 4.29.1 检查器实查（回执 {core_id}）：Becoming.Amounts、Becoming.LastChange、Becoming.Optimum '
              '与 Becoming.RegimeMargin 的声明公理报告为空，五个情形经本律证明，陈述不变。'},
    'next_delta': {
        'en': "Read the outcomes open to a part as steps that balance through one step balance, so that the optimum's "
              'laws beyond its couplings stand on it as well.',
        'zh': '把部分可得的结果读作经同一步平衡而平衡的步，使最优在其耦合之外的定律也立于其上。'},
    'correspondence': {
        'en': "The whole-number, decided form of the least-loss law of rest, stated through balance: what least-loss-rest "
              'states over any amounts as non-recurrence is here a bound counted in steps.',
        'zh': '最小损失停息律的整数、可判定形式，经平衡陈述：least-loss-rest 在任意量上陈述为不复现者，此处是按步计数的界。'},
    'canonical_source': src('Amounts'),
    'aliases': ['Becoming.Amounts.falls_by_stretch', 'Becoming.Amounts.unmarked_within', 'Becoming.Amounts.le_by_exchange'],
    'dependencies': [
        {'id': 'census-balance', 'relation': 'formal-reuse',
         'detail': {'en': 'Reuses the stretch balance (balance_over_stretch_on) as the reason of every law here.',
                    'zh': '复用段上的平衡（balance_over_stretch_on），作为此处每条定律的理由。'},
         'interface': {'output': {'en': 'Over a stretch, the count at the end with everything lost is the count at the '
                                        'start with everything gained.',
                                  'zh': '一段步上，段末计数加全部所失等于段首计数加全部所得。'},
                       'input': {'en': 'With a loss at least one above the gain at each step, the count falls by the '
                                       "stretch's length.",
                                 'zh': '每步所失比所得至少多一时，计数下降段长。'},
                       'conditions': {'en': 'Balance across each step of the stretch; whole numbers.',
                                      'zh': '段上每步平衡；整数。'},
                       'evidence': src('Prelude')}},
        {'id': 'least-loss-rest', 'relation': 'formal-reuse',
         'detail': {'en': 'States the whole-number least loss of one as a bound counted in steps, through balance.',
                    'zh': '把整数中最小损失为一陈述为按步计数的界，经由平衡。'},
         'interface': {'output': {'en': 'In whole numbers the least loss is one.', 'zh': '整数中最小损失为一。'},
                       'input': {'en': 'Each losing step loses at least one more than it gains.',
                                 'zh': '每个失去之步所失比所得至少多一。'},
                       'conditions': {'en': 'Whole numbers; decided marks for the decided form.',
                                      'zh': '整数；可判定形式要求标记可判定。'},
                       'evidence': src('Amounts')}},
    ],
    'related': [
        {'id': i, 'detail': d} for i, d in [
            ('re-optimizing-above-a-renewal-ends-it',
             {'en': 'Its course ending above the renewal is a case of this law.', 'zh': '其过程在更新之上的终结是本律的情形。'}),
            ('a-weighting-faster-than-renewal-ends-the-base',
             {'en': 'Its comparison of weighted draws is a case of this law.', 'zh': '其加权汲取的比较是本律的情形。'}),
            ('others-drawing-first-end-the-base',
             {'en': 'Its comparison of weighted draws is a case of this law.', 'zh': '其加权汲取的比较是本律的情形。'}),
            ('where-a-run-of-a-regime-comes-to-rest',
             {'en': "Its rest of a law's run with a bounded mark is a case of this law.",
              'zh': '其带有界标记的律之运行的静止是本律的情形。'}),
            ('margin-of-a-regime',
             {'en': "Its fall below the regime's point of no return is a case of this law.",
              'zh': '其在体制不归点之下的下降是本律的情形。'}),
            ('regime-point-under-adjusting-giving',
             {'en': "Its fall below the point under adjusting giving is a case of this law.",
              'zh': '其在调整所给下不归点之下的下降是本律的情形。'}),
            ('rest-on-coupled-webs',
             {'en': 'Its rest of a coupled web within a band is a case of this law.',
              'zh': '其带内耦合网的静止是本律的情形。'}),
        ]],
    'references': [
        {'path': src('Amounts'), 'role': 'proof', 'sha256': sha(src('Amounts')), 'declarations': LAW},
        {'path': src('Prelude'), 'role': 'proof', 'sha256': sha(src('Prelude')),
         'declarations': ['Becoming.balance_over_stretch_on']},
        {'path': src('Optimum'), 'role': 'proof', 'sha256': sha(src('Optimum')), 'declarations': CASES['Optimum']},
        {'path': src('LastChange'), 'role': 'proof', 'sha256': sha(src('LastChange')), 'declarations': CASES['LastChange']},
        {'path': src('RegimeMargin'), 'role': 'proof', 'sha256': sha(src('RegimeMargin')),
         'declarations': CASES['RegimeMargin']},
        {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY), 'declarations': []},
        {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT), 'declarations': []},
    ],
    'proof_bindings': [binding(m) for m in ('Amounts', 'Prelude', 'Optimum', 'LastChange', 'RegimeMargin')],
    'history': [{'en': f'23 October 2026: added (EC6, study section {N}), on the EC row of the work board: one law of '
                       'rest by balance in Becoming.Amounts, from the stretch balance, with the ending of courses, the '
                       "comparison of weighted draws, the rest of a law's run, the fall below a regime's point and the "
                       f'rest of a coupled web proved as its cases; core receipt {core_id}.',
                 'zh': f'2026年10月23日：新增（EC6，研究第 {N} 节），见工作板 EC 行：Becoming.Amounts 中由段上平衡而得的一条停息律，'
                       '过程的终结、加权汲取的比较、律之运行的静止、体制不归点之下的下降与耦合网的静止经它作为情形证明；'
                       f'核心回执 {core_id}。'}],
}
out = RECORDS / 'rest-by-balance.json'
assert not out.exists() or json.loads(out.read_text())['id'] == 'rest-by-balance'
out.write_text(json.dumps(new, ensure_ascii=False, indent=2) + '\n')
print('record rest-by-balance')

NOTES = {
    're-optimizing-above-a-renewal-ends-it': ('Optimum.ends_within', 'Optimum.ends_within'),
    'a-weighting-faster-than-renewal-ends-the-base': ('Optimum.Next.drawable_le_of_gains',
                                                      'Optimum.Next.drawable_le_of_gains'),
    'others-drawing-first-end-the-base': ('Optimum.Next.drawable_le_of_gains', 'Optimum.Next.drawable_le_of_gains'),
    'where-a-run-of-a-regime-comes-to-rest': ('LastChange.still_within', 'LastChange.still_within'),
    'margin-of-a-regime': ('RegimeMargin.Adjusted.orbit_bound', 'RegimeMargin.Adjusted.orbit_bound'),
    'regime-point-under-adjusting-giving': ('RegimeMargin.Adjusted.orbit_bound', 'RegimeMargin.Adjusted.orbit_bound'),
    'rest-on-coupled-webs': ('RegimeMargin.Coupled.Indexed.rests_by', 'RegimeMargin.Coupled.Indexed.rests_by'),
}
for rid, (en_n, zh_n) in NOTES.items():
    f = RECORDS / f'{rid}.json'
    rec = json.loads(f.read_text())
    if any('EC6' in h.get('en', '') for h in rec['history']):
        continue
    rec['history'].append({
        'en': f'23 October 2026, EC6 (study section {N}): {en_n} is now proved as a case of rest by balance (record '
              'rest-by-balance) instead of by its own induction; its statement and this record\'s laws are unchanged.',
        'zh': f'2026年10月23日，EC6（研究第 {N} 节）：{zh_n} 现作为由平衡而停息的情形证明（记录 rest-by-balance），'
              '不再以其自身的归纳证明；其陈述与本记录的定律不变。'})
    rel = rec.setdefault('related', [])
    if not any(x.get('id') == 'rest-by-balance' for x in rel):
        rel.append({'id': 'rest-by-balance',
                    'detail': {'en': f'{en_n} is a case of rest by balance.', 'zh': f'{zh_n} 是由平衡而停息的情形。'}})
    f.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
    print('note', rid)
