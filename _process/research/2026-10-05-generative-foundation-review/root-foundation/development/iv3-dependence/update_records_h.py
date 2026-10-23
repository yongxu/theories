#!/usr/bin/env python3
"""IV3h: correct and extend the record self-concern-through-dependence after the independent review: statement,
laws 5, 8 and 17, the boundaries on what is drawn and on giving without end, the correspondence, a hypothesis, a
new law (possibility and giving without end), the FeedersInTurn possible flow, the validation scope (reviewed);
references re-hashed, one history note.
usage (from the checkout root, after apply_text_h.py): python3 -B update_records_h.py CORE_RECEIPT STUDY_SECTION"""
import datetime
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RECORDS = ROOT / 'theories/becoming/results/records'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
MODULE = 'Becoming.Weightings'
SOURCE = f'{PKG}/Becoming/Weightings.lean'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
R = json.loads((ROOT / RECEIPT).read_text())
assert R['status'] == 'passed'
assert f'## {N}. The independent review of the IV3 line, and its fixes (IV3h)' in (ROOT / STUDY).read_text()
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
DATE = '23 October 2026'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


found = [m for m in R['modules'] if m['module'] == MODULE]
assert len(found) == 1 and not any(found[0]['axiom_dependencies'].values())
HAVE = {d['name'] for d in found[0]['declarations']}
assert R['source_sha256'][MODULE] == sha(SOURCE)


def need(names):
    for n in names:
        assert n in HAVE, n
    return names


def t(en, zh):
    return {'en': en, 'zh': zh}


def replace_text(item, old_en, new_en, new_zh):
    assert item['en'] == old_en, item['en'][:80]
    item['en'], item['zh'] = new_en, new_zh


B, FL = 'Becoming.', 'Becoming.Flow.'
POSSIBLE = need([B + 'needsPart_of_none']
                + [FL + n for n in ['givenFrom_outside', 'otherCapacity_split', 'capacityWithout_split', 'able_of_covers',
                                    'possible_iff_covers', 'least_giving_of_possible', 'needsSome_without_end']]
                + [B + 'FeedersInTurn.' + n for n in ['turn', 'possible']])
SCOPE = t(
    f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): every declaration of '
    'Becoming.Weightings has an empty axiom report, and the checker verifies core purity. The literature check is the '
    'significance review\'s dependence check. Author review in study sections 373, 378 and 382 to 386; reviewed against '
    f'the Lean by a reader that did not write it, a separate AI agent, whose findings are fixed in study section {N}.',
    f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Weightings 的每项声明公理报告为空；检查器并核对核心纯净。文献核查是'
    f'显著性审查中的“依存”核查。作者审查见研究第 373、378、382 至 386 节；另由一个非作者的读者（另一个 AI 代理）对照 Lean 审查，'
    f'其发现在研究第 {N} 节修正。')

path = RECORDS / 'self-concern-through-dependence.json'
d = json.loads(path.read_text(encoding='utf-8'))
assert len(d['laws']) == 18
d['statement'] = t(
    'Held de se, self-concern is the same from every standpoint exactly where the centers lie within one another\'s '
    'closures; on the base, a consumer needs a feeder\'s giving exactly where the others could not together give what '
    'a step demands, and drawing past a hierarchy fed only from above needs giving into its top.',
    '从己地持有，自我关切恰在诸中心彼此位于对方闭包之内处对每个立场都相同；在基底上，消耗者恰在其余者合起来给不出某步需求之处需要某供给者的'
    '给予，而汲取超出只从上方供给的层级，需要向其顶层的给予。')
assert len(d['statement']['en']) <= 300 and len(d['statement']['zh']) <= 150, (len(d['statement']['en']), len(d['statement']['zh']))
law5 = d['laws'][5]
assert law5['en'].endswith('needs a given feeder\'s giving exactly where that feeder is the only one. Witness: two flows of one condition, each fed by one copy.')
law5['en'] = law5['en'].replace('and needs a given feeder\'s giving exactly where that feeder is the only one.',
                                'and, where each member can feed the family alone, needs a given feeder\'s giving exactly '
                                'where that feeder is the only member.')
law5['zh'] = law5['zh'] + '（此“唯一者”之律以每个成员都能单独供给该族为前提。）'
law8 = d['laws'][8]
assert 'that member is the only one active.' in law8['en']
law8['en'] = law8['en'].replace('that member is the only one active.',
                                'no member other than it is active (vacuously so where none is).')
law8['zh'] = law8['zh'].replace('某成员是唯一活跃者时', '没有其他成员活跃时') if '某成员是唯一活跃者时' in law8['zh'] else \
    law8['zh'] + '（即该步上没有其他成员活跃；无成员活跃时为空真。）'
law17 = d['laws'][17]
assert 'and where it can give each, some has it give exactly that' in law17['en']
law17['en'] = law17['en'].replace('and where it can give each, some has it give exactly that',
                                  'and wherever a flow is possible some has it give exactly that')
law17['zh'] = law17['zh'].replace('它能给出每个缺额时，某个可能的流使它恰好给出这么多', '凡有可能的流，某个流使它恰好给出这么多') \
    if '它能给出每个缺额时，某个可能的流使它恰好给出这么多' in law17['zh'] else law17['zh']
d['laws'].append({**t(
    'Some flow read off a web with capacities lets the consumer draw past the stock exactly where the class can give '
    'each step\'s demand; elsewhere every need holds vacuously, and wherever a flow is possible the degree of need is '
    'attained. Drawing without end needs giving without end: after every step some member gives within the next '
    'stock-plus-one steps. Witness FeedersInTurn.possible.',
    '某个从依存网读出的有容量的流使消耗者汲取超出存量，恰在该类能给出每步需求之处；别处一切“所需”都是空真的，凡有可能的流，被需要的程度都'
    '可达成。无尽的汲取需要无尽的给予：每一步之后，在随后存量加一步之内有某成员给予。见证 FeedersInTurn.possible。'),
    'declarations': POSSIBLE})
dns = d['does_not_show']
corr = [i for i, x in enumerate(dns) if x['kind'] == 'correspondence']
assert len(corr) == 1 and 'could not together give what they draw' in dns[corr[0]]['en']
dns[corr[0]] = {**t(
    'That actual centers depend on one another, or that the alternatives to a condition they all need could not '
    'together give what each step demands: both are empirical.',
    '实际的诸中心彼此依存，或它们都需要的某个条件的诸替代者合起来给不出每步的需求：二者都是经验问题。'), 'kind': 'correspondence'}
end = [i for i, x in enumerate(dns) if x['en'].startswith('Need without end')]
assert len(end) == 1
dns[end[0]] = {**t(
    'That a need holding where no flow lets the consumer draw past the stock is substantive: there it holds vacuously, '
    'and that is exactly where the class cannot give some step\'s demand.',
    '在没有流使消耗者汲取超出存量之处成立的“所需”是实质的：那里它是空真的，而这恰是该类给不出某步需求之处。'), 'kind': 'scope'}
c = d['correspondence']
assert 'need against feeding, parting exactly at copies' in c['en']
c['en'] = c['en'].replace('need against feeding, parting exactly at copies',
                          'need against feeding, parting where the others could together give what a feeder gives')
d['hypotheses'].append(t(
    'Every exact law on the base: the consumer outside the class and active across a stretch longer than the family\'s '
    'stock.',
    '基底上的每条精确之律：消耗者在该类之外，并在长于该族存量的一段步内活跃。'))
d['counterexamples'].append({'path': SOURCE, 'detail': t(
    'FeedersInTurn.possible: the flow drawn across the two steps with the copy active at each giving lets the user draw '
    'past the stock, so the user\'s need of both copies (FeedersInTurn.needs_both) is not vacuous.',
    'FeedersInTurn.possible：以每步活跃的副本给予而画过两步的流使使用者汲取超出存量，所以使用者对两个副本的需要（FeedersInTurn.needs_both）'
    '不是空真的。')})
d['next_delta'] = t(
    'Capacities across a hierarchy whose upper tier divides its giving among several stores; the degree of need with '
    'capacities read off stores.',
    '上层把给予分给多个库存的层级中的容量；以从库存读出的容量计的被需要程度。')
d['validation_scope'] = SCOPE
d['reviewed_at_utc'] = NOW
for ref in d['references']:
    if ref['path'] == SOURCE and ref['role'] == 'proof':
        ref['declarations'] = sorted(set(ref['declarations']) | set(POSSIBLE))
        ref['sha256'] = sha(SOURCE)
    elif ref['role'] == 'receipt':
        ref['path'] = RECEIPT
        ref['sha256'] = sha(RECEIPT)
    else:
        ref['sha256'] = sha(ref['path'])
for binding in d['proof_bindings']:
    if binding['source'] == SOURCE:
        binding['receipt'] = RECEIPT
d['history'].append(t(
    f'{DATE}: corrected and extended (IV3h) after an independent review against the Lean: the statement now says '
    f'"what a step demands", not "what is drawn", and states need, not reach; the base copies law states its premise; '
    f'"no other member is active", not "the only one active"; the degree where a flow is possible; the possibility law '
    f'and giving without end added; the boundary on giving without end replaced; study section {N}.',
    f'2026年10月23日：经对照 Lean 的独立审查后修正并扩展（IV3h）：陈述改为“某步的需求”而非“所汲取者”，并陈述“所需”而非“达到”；基底副本之律'
    f'写明其前提；“没有其他成员活跃”而非“唯一活跃者”；程度限于有可能的流之处；增加可能性之律与无尽的给予；替换关于无尽给予的边界；'
    f'研究第 {N} 节。'))
path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('updated', d['id'])
