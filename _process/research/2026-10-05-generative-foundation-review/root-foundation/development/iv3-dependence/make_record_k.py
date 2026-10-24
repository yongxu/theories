#!/usr/bin/env python3
"""IV3k: the new record need-and-feeding-read-with-time, its references hashed to the receipt, its laws checked against
the receipt's declarations and the style caps.
usage (from the checkout root, after apply_text_k.py): python3 -B make_record_k.py CORE_RECEIPT STUDY_SECTION"""
import datetime
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
SOURCE = f'{PKG}/Becoming/Weightings.lean'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
R = json.loads((ROOT / RECEIPT).read_text())
assert R['status'] == 'passed'
found = [m for m in R['modules'] if m['module'] == 'Becoming.Weightings']
assert len(found) == 1 and not any(found[0]['axiom_dependencies'].values())
HAVE = {d['name'] for d in found[0]['declarations']}
assert R['source_sha256']['Becoming.Weightings'] == hashlib.sha256((ROOT / SOURCE).read_bytes()).hexdigest()
assert f'## {N}. Need and feeding read with time, and chapter 7 led by the structure (IV3k)' in (ROOT / RF / 'BECOMING-RENEWAL-READING.md').read_text()
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def need(names):
    for n in names:
        assert n in HAVE, n
    return names


def t(en, zh, cap=None):
    if cap:
        assert len(en) <= cap[0] and len(zh) <= cap[1], (len(en), len(zh), en[:60])
    return {'en': en, 'zh': zh}


FL = 'Becoming.Flow.'
END = need([FL + n for n in ['active_of_givesWithin', 'active_of_givesInto', 'needs_iff_none_of_inactive',
                             'needs_into_iff_none_of_inactive']])
TIME = need([FL + n for n in ['FedUpTo', 'WithinFeedingUpTo', 'gives_of_withinFeedingUpTo',
                              'active_of_withinFeedingUpTo', 'withinFeeding_of_upTo']])
WITNESS = need(['Becoming.Overlapping.' + n for n in ['level', 'active', 'web', 'take', 'give', 'flow', 'give_pos',
                                                      'acting', 'fed', 'draws', 'fed_first', 'fed_middle', 'last_quiet',
                                                      'closure_overreaches']])
PW = RF + 'development/pw-step-forward/NOTE.md'
SW = RF + 'development/sw-significance-without-a-value-layer/NOTE.md'
record = {
    'schema_version': 2,
    'id': 'need-and-feeding-read-with-time',
    'title': t('Need and feeding, read with time', '带着时间来读的所需与供养', (100, 40)),
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F07',
    'reviewed_at_utc': NOW,
    'statement': t(
        'Over flows where only active formations give, a formation active at no step of a stretch is needed only where '
        'nothing lets the consumer draw past the stock; read with time, a feeding closure up to a step holds only what '
        'gives by then, though read across every step it can run past what it carries.',
        '在只有活跃构成给予的流上，区间内无一步活跃的构成只在无流使消耗者汲取超出存量处被需要；带着时间来读，至某步的供养闭包只含到那时为止给予者，'
        '跨一切步来读则可越过所承担者。', (300, 150)),
    'laws': [
        {**t('Need ends at the end: over any class of flows read off a web in which only active formations give, a '
             'formation active at no step of the stretch is needed exactly where no flow of the class lets the consumer '
             'draw past the stock; across two tiers likewise for giving into the hierarchy.',
             '所需止于终结：在只有活跃构成给予的任一类读自依存网的流上，区间内无一步活跃的构成，恰在该类中无流使消耗者汲取超出存量处被需要；'
             '跨两层者，对向层级的给予亦然。', (420, 190)), 'declarations': END},
        {**t('Read with time, each link no later than the one it feeds, a formation\'s feeding closure up to a step holds, '
             'besides it, only what takes part and gives at some step up to that one, so only what is active by then where '
             'only active formations give; it lies within the feeding closure read across every step.',
             '带着时间来读，每一环不晚于它所供养的那一环，构成至某步的供养闭包，除它自己外，只含在至该步为止某步参与并给予者；只有活跃构成给予时，'
             '只含到那时为止活跃者；它在跨一切步来读的供养闭包之内。', (420, 190)), 'declarations': TIME},
        {**t('Witness Overlapping: of three formations overlapping in turn, the last lies within the first\'s feeding '
             'closure but not within it read with time up to the first\'s last step, which holds the middle one, and the '
             'first, drawing past its condition\'s stock, does not need the last\'s giving.',
             '见证 Overlapping：三个依次交叠的构成，最后者在第一者的供养闭包之内，却不在带着时间读至第一者最后一步的闭包之内（后者含中间者）；'
             '第一者汲取超出其条件的存量，却不需要最后者的给予。', (420, 190)), 'declarations': WITNESS},
    ],
    'hypotheses': [t(
        'No axiom. The class of possible flows supplied, each with only active formations giving; the stretch a '
        'continuation is read across supplied; for the closure, the flow and the web given; discrete steps and '
        'natural-number amounts.',
        '不加公理。可能之流的类为所设，其中每个流只有活跃构成给予；延续所读的区间为所设；对闭包，流与依存网给定；离散之步，自然数之量。',
        (420, 190))],
    'does_not_show': [
        {**t('That nothing reaches successors: what comes after every present center\'s end is reached by a line under a '
             'class that goes on past it, or by the step of invariance.',
             '无物达到后来者：凡在一切现存中心终结之后者，由过其终结而续的一类下之线达到，或由不变之步达到。', (240, 110)),
         'kind': 'non-implication'},
        {**t('How far actual lives overlap, or which actual formations feed which: the laws read a given web and flow.',
             '实有之生命交叠多远，实有之构成谁供养谁：诸律读给定的依存网与流。', (240, 110)), 'kind': 'correspondence'},
        {**t('An exact law of need for a continuation without end: giving without end is shown, not which member gives.',
             '对无终延续的精确之“所需”律：已示无终之给予，未示何成员给予。', (240, 110)), 'kind': 'scope'},
    ],
    'counterexamples': [{'path': SOURCE, 'detail': t(
        'Overlapping: the first formation active at steps 0 and 1, the middle at 1 and 2, the last at 2 and 3; the middle '
        'feeds the first at step 1, the last the middle at step 2. The last lies within the first\'s feeding closure, not '
        'within it read with time up to step 1, and is not needed by the first though among its possible feeders '
        '(Overlapping.closure_overreaches).',
        'Overlapping：第一个构成在第 0、1 步活跃，中间者在第 1、2 步，最后者在第 2、3 步；中间者在第 1 步供养第一者，最后者在第 2 步供养中间者。'
        '最后者在第一者的供养闭包之内，不在带着时间读至第 1 步的闭包之内；虽在其可能的供给者之中，却不为第一者所需（Overlapping.closure_overreaches）。')}],
    'standard_boundaries': ['no-ethical-premise', 'formal-not-empirical', 'names-provisional', 'discrete-steps',
                            'omission-not-refutation'],
    'validation_scope': t(
        f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): every declaration of '
        'Becoming.Weightings has an empty axiom report, and the checker verifies core purity. Author review in study '
        f'section {N}.',
        f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Weightings 的每项声明公理报告为空；检查器并核对核心纯净。作者审查见研究第 {N} 节。',
        (600, 260)),
    'next_delta': t(
        'Feeding carried across steps, read with time; an exact law of need for a continuation without end; which class '
        'a center\'s own line runs under, so that its reach past its end is fixed.',
        '跨步承载的供养，带着时间来读；无终延续的精确“所需”律；中心自身之线在何类下，以定其过终之所及。', (400, 180)),
    'correspondence': t(
        'PW note §2-§3: need reaches contemporaries and predecessors, never successors, and the feeding closure reaches '
        'the future only read without time; made exact here. Parfit: what matters passes to successors in degrees; here '
        'need does not pass at all, and the reach past one\'s end is a question of classes (GS2).',
        'PW 笔记 §2-§3：所需达到同时代者与前人，从不达到后来者；供养闭包只在不带时间来读时达到未来；此处使之精确。帕菲特：重要者以程度传给后来者；'
        '此处所需全不传递，过己之终的所及是类的问题（GS2）。', (1200, 500)),
    'canonical_source': SOURCE,
    'aliases': ['Need and feeding, read with time', '带着时间来读的所需与供养', 'Becoming.Flow.needs_iff_none_of_inactive',
                'Becoming.Flow.WithinFeedingUpTo', 'Becoming.Overlapping.closure_overreaches'],
    'dependencies': [
        {'id': 'self-concern-through-dependence', 'relation': 'formal-reuse', 'detail': t(
            'Reuses NeedsPart, the flows read off a web (Flow.FedOnlyOn), Flow.DrawsPast, Flow.GivesWithin, the two-tier '
            'flows (Flow.FedThroughStores, Flow.GivesInto) and pos_or_of_add_pos; read with Flow.needsSome_without_end.',
            '复用 NeedsPart、读自依存网的流（Flow.FedOnlyOn）、Flow.DrawsPast、Flow.GivesWithin、两层之流（Flow.FedThroughStores、'
            'Flow.GivesInto）与 pos_or_of_add_pos；与 Flow.needsSome_without_end 合读。')},
        {'id': 'feeding-closure', 'relation': 'formal-reuse', 'detail': t(
            'Reuses feeding at a common step (Flow.FedBy) and the feeding closure (Flow.WithinFeeding, '
            'Flow.WithinFeeding.of_fedBy, Flow.WithinFeeding.trans).',
            '复用同步供养（Flow.FedBy）与供养闭包（Flow.WithinFeeding、Flow.WithinFeeding.of_fedBy、Flow.WithinFeeding.trans）。')},
    ],
    'related': [
        {'id': 'feeding-from-a-step', 'detail': t(
            'The closure from a step, shrinking as feeding stops; here the closure up to a step, holding only what gives '
            'by then.',
            '自某步起的闭包，随供养停止而缩小；此处为至某步的闭包，只含到那时为止给予者。')},
        {'id': 'reach-past-ones-own-end', 'detail': t(
            'Where the reach past one\'s own end comes from instead: a line under a class that goes on past it.',
            '过己之终的所及另有来处：过其终而续的一类下之线。')},
    ],
    'references': [
        {'path': SOURCE, 'role': 'proof', 'declarations': sorted(END + TIME + WITNESS), 'sha256': sha(SOURCE)},
        {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
        {'path': RF + 'BECOMING-RENEWAL-READING.md', 'role': 'integration', 'sha256': sha(RF + 'BECOMING-RENEWAL-READING.md')},
        {'path': RF + 'DELEGATED-CHOICES.md', 'role': 'integration', 'sha256': sha(RF + 'DELEGATED-CHOICES.md')},
        {'path': PW, 'role': 'provenance', 'sha256': sha(PW)},
        {'path': SW, 'role': 'provenance', 'sha256': sha(SW)},
    ],
    'proof_bindings': [{'source': SOURCE, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.Weightings',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [t(f'24 October 2026: added (IV3k), from PW\'s candidates (1) and (2); study section {N}.',
                  f'2026年10月24日：新增（IV3k），出自 PW 的候选（1）与（2）；研究第 {N} 节。')],
}
path = ROOT / 'theories/becoming/results/records/need-and-feeding-read-with-time.json'
assert not path.exists()
path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('created', record['id'])
