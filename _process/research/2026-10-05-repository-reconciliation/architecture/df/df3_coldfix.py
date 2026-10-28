#!/usr/bin/env python3
"""DF3: take the cold read of the applied migration (reports/df3-cold-read.json, two readers, 33 findings).

Taken: every overclaim, imprecision, dropped condition and home-section disagreement, the error in a mapping
row, and the style points that fix a reading's label, Ren's words given as a reason, a market word, unwitnessed
counterexamples shown twice and mapping rows that misreport. Not taken: b29 (the lint's length warning on a
correspondence whose excess is Ren's quoted English, kept verbatim) and a15 (the quotation keeps its date, which
names its source; the history note and mapping row are corrected instead).
Run from the worktree root: python3 -B <kit>/df3_coldfix.py
"""
import json, re, sys
from pathlib import Path

KIT = Path('_process/research/2026-10-05-repository-reconciliation/architecture/df')
RECORDS = Path('theories/becoming/results/records')
LEAN = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
failures, touched = [], {}


def rec(i):
    if i not in touched:
        touched[i] = (json.loads((RECORDS / f'{i}.json').read_text()), [])
    return touched[i][0]


def get(obj, path):
    for part in re.findall(r'[^.\[\]]+|\[-?\d+\]', path):
        obj = obj[int(part[1:-1])] if part.startswith('[') else obj[part]
    return obj


def setp(obj, path, value):
    parts = re.findall(r'[^.\[\]]+|\[-?\d+\]', path)
    for part in parts[:-1]:
        obj = obj[int(part[1:-1])] if part.startswith('[') else obj[part]
    last = parts[-1]
    obj[int(last[1:-1]) if last.startswith('[') else last] = value


def sub(i, path, old, new, field=None):
    r = rec(i)
    cur = get(r, path)
    if cur.count(old) != 1:
        failures.append(f'{i}:{path}: old occurs {cur.count(old)} times: {old[:60]}')
        return
    setp(r, path, cur.replace(old, new))
    touched[i][1].append(field or path.split('.')[0].split('[')[0])


def file_sub(path, old, new):
    p = Path(path)
    s = p.read_text()
    if s.count(old) != 1:
        failures.append(f'{path}: old occurs {s.count(old)} times: {old[:60]}')
        return
    p.write_text(s.replace(old, new))


MAP = lambda i: KIT / 'df3-mapping' / f'{i}.md'

# a0-a1: the bound, not "adds no fall".
sub('continuous-time-as-tower', 'correspondence.en', 'where what stands is not refuted to run down, dividing time more finely adds no fall of total standing.',
    'where what stands is not refuted to run down, however finely time is divided, the falls of total standing over a coarsest stretch stay within its starting total.')
sub('continuous-time-as-tower', 'correspondence.zh', '所立者不被否定地下降时，总水平的下降不因时间分得更细而增加。',
    '所立者不被否定地下降时，无论时间分得多细，最粗一段上总水平的下降次数都不超过其段首的总水平。')
# a4: the construction, with Ren's proposal as provenance.
sub('continuous-time-as-tower', 'correspondence.en', 'Ren decided that continuous time is built in the core as a tower of ever-finer discrete readings, a law of continuous time being a law at every level, real-valued time a later periphery correspondence.',
    "Continuous time is built in the core as a tower of ever-finer discrete readings, a law of continuous time being a law at every level, real-valued time a later periphery correspondence; the representation was Ren's proposal (provenance in the references).")
sub('continuous-time-as-tower', 'correspondence.zh', 'Ren 决定：连续时间在核心中构造为越来越细的离散读法之塔，连续时间的规律即塔的每一层上的规律，实数时间以后作为外围的对应。',
    '连续时间在核心中构造为越来越细的离散读法之塔，连续时间的规律即塔的每一层上的规律，实数时间以后作为外围的对应；这一表示出自 Ren 的提议（来历见引用）。')
# a2: the counterexample was narrowed, not moved (the review note DF3's apply script wrote).
sub('continuous-time-as-tower', 'history[-1].en', 'the counterexample (moved to a does-not-show item), laws', 'the counterexample (narrowed), laws', 'history')
sub('continuous-time-as-tower', 'history[-1].zh', '反例（移入“未表明”）、规律', '反例（收窄）、规律', 'history')
# a3: the counterexample's witness in references.
r = rec('continuous-time-as-tower')
ref = [x for x in r['references'] if x['path'].endswith('/Becoming/Sampling.lean')]
assert len(ref) == 1 and 'Becoming.Strobe.converse_fails' not in ref[0]['declarations']
ref[0]['declarations'].append('Becoming.Strobe.converse_fails')
touched['continuous-time-as-tower'][1].append('references')
# a5-a6: at every step.
sub('renewing-consuming-formation', 'laws[3].en',
    "where the joint pressure exceeds the current rate at every step or another part's pressure exceeds the initial rate at every step, though this part be within renewal and ceaseless alone; it ends so too where two parts, each within renewal and ceaseless alone, together exceed the initial rate.",
    "where, at every step, the joint pressure exceeds the current rate or another part's pressure exceeds the initial rate, though this part be within renewal and ceaseless alone; it ends so too where two parts, each within renewal and ceaseless alone, together exceed the initial rate at every step.")
sub('renewing-consuming-formation', 'laws[3].zh', '两个各在更新之内、单独不息的部分合起来超过初始更新率时', '两个各在更新之内、单独不息的部分每步合起来都超过初始更新率时')
# a7-a8: a witness, read as one.
sub('growth-constrained-fragmentation', 'statement.en', 'and a retaining edge stops fragmentation.', 'and a retaining edge can stop fragmentation.')
sub('growth-constrained-fragmentation', 'statement.zh', '而一条保留边防止碎裂', '而一条保留边可以防止碎裂')
# a9-a10: the leaves' local support, in the statement and its home.
sub('exclusive-footprint-support', 'statement.en',
    "Where each part's footprint lies within its whole's and the two parts' footprints share nothing, the root's footprint supports what the leaves of a realized plan draw on: nothing repeats, and everything lies within it.",
    "Where each part's footprint lies within its whole's and the two parts' footprints share nothing, a plan realized with each leaf's draw supported by its own configuration's footprint has all its leaves draw on supported by the root's footprint: nothing repeats, and everything lies within it.")
sub('exclusive-footprint-support', 'statement.zh', '凡每个部分的足迹在其整体的足迹之内、两个部分的足迹无共同处，根的足迹支持一个被实现计划的诸叶所汲取者：无重复，且皆在其内。',
    '凡每个部分的足迹在其整体的足迹之内、两个部分的足迹无共同处，一个以每片叶所汲取者被其自身构形的足迹支持而实现的计划，其诸叶所汲取者皆被根的足迹支持：无重复，且皆在其内。')
file_sub('theories/becoming/chapters/01-ROOT.md', "every realized nested plan's requests are free of repetition and covered by the root's footprint",
         "every nested plan realized with each leaf's requests supported by its own configuration's footprint has requests free of repetition and covered by the root's footprint")
# a11: the home says more than the Lean.
file_sub('theories/becoming/chapters/01-ROOT.md', '**Theorem** (any process; the quantum case a witness). For every law of change with moves and every reduction,',
         '**Theorem** (any deterministic law; the quantum case a witness). For every law of change giving one next configuration for each configuration and move, and every reduction,')
# a12: a next step not already done.
r = rec('joint-decomposition-lifting')
r['next_delta'] = {'en': 'Lift decompositions whose parts share or duplicate support, or whose designated parts must be substituted, with the conditions stated as hypotheses.',
                   'zh': '提升部分共享或重复使用支持、或须替换指定部分的分解，其条件写为假设。'}
touched['joint-decomposition-lifting'][1].append('next_delta')
# a13-a14: the receipt named, not "the newest".
for i, mod in (('trace-law-equivalence', 'GenerativeCore'), ('joint-code-plan-lifting', 'Becoming.Likeness')):
    sub(i, 'validation_scope.en', f'and those of {mod} to the newest core receipt;', f'and those of {mod} to core receipt 20261027T195912.152773Z;')
    sub(i, 'validation_scope.zh', f'{mod} 绑定最新的核心回执', f'{mod} 绑定核心回执 20261027T195912.152773Z')
# a15 not taken: the quotation keeps its date; the history note and mapping say so.
sub('only-the-order-of-change-shows', 'history[-1].en', 'and the work-item labels, date and section number the correspondence;',
    "and the work-item labels and section number the correspondence, where the quotation keeps its date, which names its source;", 'history')
sub('only-the-order-of-change-shows', 'history[-1].zh', '对应去掉工作项标签、日期与节号；', '对应去掉工作项标签与节号，引文保留日期以示出处；', 'history')
file_sub(MAP('only-the-order-of-change-shows'),
         "| correspondence (“Following Ren's “move towards 100%”, … to be re-founded as the starting point was”: Ren's words verbatim; P78, P69 and the date left as process markers; P78 is in history entry 0, the date in the provenance source `2026-10-12-move-towards-100.md`, and all three in the snapshot) |",
         "| correspondence (“Following Ren's “move towards 100%” of 12 October 2026, … to be re-founded as the starting point was”: Ren's words verbatim with their date, which names the source `2026-10-12-move-towards-100.md`; P78 and P69 left as process markers, P78 in history entry 0, both in the snapshot) |")
# a16: the mapping quotes the next step as it now is.
file_sub(MAP('finite-trace-transport'), '| next_delta (“Transport finite courses by trace_map wherever a map of configurations preserves steps”) |',
         '| next_delta (“State transport and exact reading through a map for runs without end”); reuse of trace_map is shown by the records that depend on it (becoming-context-coherence, trace-law-equivalence, derived-history-law-exactness) |')
file_sub(MAP('finite-trace-transport'), '| next_delta (“stating any further endpoint or correspondence condition as a hypothesis”), stated positively; the exactness criterion added as the certification it gives |',
         '| next_delta (“the correspondence of a state map to an actual system, each with its conditions stated as hypotheses”), stated positively |')
# a17-a19: counterexamples no declaration witnesses, each already carried by does-not-show items.
for i, carried in (('least-footprint-where-idleness-decided', 'does_not_show[0]–[3] and the standard boundaries no-evaluation and no-ethical-premise'),
                   ('joint-decomposition-lifting', 'does_not_show[0] (witness `LiftsFromEach`)'),
                   ('finite-joining-tree-lifting', 'does_not_show[0] and [1]')):
    r = rec(i)
    assert len(r['counterexamples']) == 1 and r.get('does_not_show'), i
    r['counterexamples'] = []
    touched[i][1].append('counterexamples')
    p = MAP(i)
    p.write_text(p.read_text().rstrip('\n') + f'\n\nThe cold read removed the counterexample, which no declaration witnesses and which {carried} already carry: X0 goes to those items.\n')
# b20-b22: a negated universal, not an exit step.
sub('market-finite-support-obstruction', 'statement.en', 'A start below level n of a family of levels the steps drain leaves the guard within n steps on every admissible history;',
    'A start below level n of a family of levels the steps drain has no admissible history within the guard at every step through n;')
sub('market-finite-support-obstruction', 'statement.zh', '在每段可容许历史上 n 步之内离开守卫', '没有可容许历史在直到第 n 步的每一步都留在守卫之内')
sub('market-finite-support-obstruction', 'laws[0].en', 'so a start below level n leaves the guard within n steps on every admissible history.',
    'so from below level n no admissible history stays within the guard through step n.')
sub('market-finite-support-obstruction', 'laws[0].zh', '所以低于第 n 级的起点在每段可容许历史上 n 步之内离开守卫', '所以从低于第 n 级的起点出发，没有可容许历史直到第 n 步都留在守卫之内')
sub('market-finite-support-obstruction', 'laws[3].en', 'not at level n, leaves the guard within n steps on every admissible history.',
    'not at level n, has no admissible history within the guard through step n.')
sub('market-finite-support-obstruction', 'laws[3].zh', '在每段可容许历史上 n 步之内离开守卫', '没有可容许历史直到第 n 步都留在守卫之内')
file_sub(MAP('market-finite-support-obstruction'), 'restated positively', 'restated positively, as the negated universal the Lean proves (no admissible history within the guard at every step through n)')
# b23-b24: "only" is proved, so it stays.
sub('metaethical-core-characterization', 'laws[10].en', 'lifting is transitive for a transitive better where the middle move has an outcome, irreflexive',
    'lifting is transitive for a transitive better where the middle move has an outcome, which is needed (through a move with none both lifts hold vacuously and the composite can fail), irreflexive')
sub('metaethical-core-characterization', 'laws[10].zh', '“更好”传递且中间动作有结果时提升传递；',
    '“更好”传递且中间动作有结果时提升传递，而这一结果是需要的（经过没有结果的动作，两次提升都空真成立而复合可以不成立）；')
r = rec('metaethical-core-characterization')
r['laws'][10]['declarations'].append('Becoming.LiftModel.lift_needs_live_middle')
RECEIPT = f'{LEAN}/becoming-checks/20261027T195912.152773Z/verification.json'
receipt_at = max(k for k, x in enumerate(r['references']) if x['role'] == 'receipt')
proofs_end = max(k for k, x in enumerate(r['references']) if x['role'] == 'proof') + 1
r['references'].insert(proofs_end, {'path': f'{LEAN}/Becoming/Lifting.lean', 'role': 'proof',
                                    'sha256': 'b76af036932ea87c820263922caab79b14852fcda6498d431ac7e6c5ad0bd18e',
                                    'declarations': ['Becoming.LiftModel.lift_needs_live_middle']})
if not any(x['path'] == RECEIPT for x in r['references']):
    r['references'].append({'path': RECEIPT, 'role': 'receipt', 'sha256': '18d5d8f742017f011cc1df59d6be80b1b3e0a46441e7127a0d784dfed1a5fd0b'})
r['proof_bindings'].append({'source': f'{LEAN}/Becoming/Lifting.lean', 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.Lifting',
                            'success_pointer': '/status', 'success_value': 'passed'})
touched['metaethical-core-characterization'][1].append('references')
file_sub(MAP('metaethical-core-characterization'), '“only” is not kept, since no declaration shows that transitivity fails without an outcome of the middle move',
         '“only” is kept: Becoming.LiftModel.lift_needs_live_middle (Lifting.lean) shows that through a move with no outcome both lifts hold vacuously while the composite fails; the declaration is added to the law and references')
# b25: the reading's label.
sub('significance-retained-within-margin', 'does_not_show[5].en', 'this is a chosen reading, open to revision.', 'this is an AI reading, open to revision.')
sub('significance-retained-within-margin', 'does_not_show[5].zh', '这是所选的读法，可以修订。', '这是 AI 的读法，可以修订。')
# b26: the support consumption the theorem takes.
file_sub('theories/becoming/chapters/05-COLLECTIVES.md', 'for `β ≤ 5/12` each such state has a landing time `N`, and initial stock at least `K_N` carries',
         'for `β ≤ 5/12` each such state has a landing time `N`, and, with extra support consumption `κ ≥ 0` a step, initial stock at least the cover `K_N` carries')
# b27: which checker bound GenerativeCore.
sub('effective-capacity-and-eventual-reachability', 'validation_scope.en',
    'Machine-checked by the consolidated Lean 4.29.1 checker: the core modules Becoming.ActivationCapacity, Becoming.Labelled, Becoming.Bundles and GenerativeCore (receipts under becoming-checks/ and relational-becoming-checks/), every cited declaration with an empty axiom report.',
    'Machine-checked with Lean 4.29.1: the core modules Becoming.ActivationCapacity, Becoming.Labelled and Becoming.Bundles by the consolidated checker (becoming-checks/), and GenerativeCore by the RelationalBecoming check (relational-becoming-checks/), every cited declaration with an empty axiom report.')
sub('effective-capacity-and-eventual-reachability', 'validation_scope.zh',
    'Lean 4.29.1 合并检查器实查：核心 ActivationCapacity、Labelled、Bundles 与 GenerativeCore（becoming-checks/、relational-becoming-checks/）',
    'Lean 4.29.1 实查：核心 ActivationCapacity、Labelled、Bundles 由合并检查器（becoming-checks/），GenerativeCore 由 RelationalBecoming 检查（relational-becoming-checks/）')
# b28: name what is kept.
sub('pending-task-context-applicability', 'laws[5].en', "one more record and the account's total (work, reserve and units drawn) kept", 'one more record and the total of work, reserve and units drawn kept')
sub('pending-task-context-applicability', 'laws[5].zh', '多一条记录，账户总量（工作、储备与已用单位）保持', '多一条记录，工作、储备与已用单位的总量保持')
# b30-b32: mapping rows that said "unchanged".
file_sub(MAP('market-supported-finite-transition'), '| statement | statement (unchanged) |',
         '| statement | statement, narrowed to the Lean: “for each positive state some N exists at which initial support at least K_N carries it into the original protection” (the horizon depends on the state, `no_uniform_pulse_duration`) |')
file_sub(MAP('metaethical-core-characterization'), '| R0–R4 | correspondence | correspondence (unchanged) |',
         '| R0–R4 | correspondence | correspondence, with the AI label added to the reading of `living` (“`living` reads 生生 (an AI reading)”), otherwise unchanged |')
file_sub(MAP('pending-task-context-applicability'), '| statement | statement (unchanged) |',
         '| statement | statement (“an endpoint” read as “a pending endpoint”, as `review_completes_iff` takes it; “reviews not cleared” written “uncleared reviews”) |')

EN = {'statement': 'the statement', 'laws': 'laws', 'does_not_show': 'does-not-show items', 'validation_scope': 'the evidence paragraph',
      'correspondence': 'the correspondence', 'next_delta': 'the next step', 'counterexamples': 'the counterexample (removed, as no declaration witnesses it)',
      'references': 'the references'}
ZH = {'statement': '陈述', 'laws': '规律', 'does_not_show': '“未表明”各项', 'validation_scope': '证据段', 'correspondence': '对应', 'next_delta': '下一步',
      'counterexamples': '反例（删去，无声明为其见证）', 'references': '引用'}
for i, (r, fields) in touched.items():
    tops = [f for f in dict.fromkeys(fields) if f != 'history']
    h = r['history'][-1]
    assert h['en'].startswith('28 October 2026: migrated to schema 2 (DF3'), i
    if tops:
        h['en'] = h['en'].rstrip() + ' A cold read of the applied record was taken in ' + ', '.join(EN[k] for k in tops) + '.'
        h['zh'] = h['zh'].rstrip() + '对已应用记录的通读意见已采纳，涉及' + '、'.join(ZH[k] for k in tops) + '。'
    (RECORDS / f'{i}.json').write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n')
print(json.dumps({'records': sorted(touched), 'failures': failures}, ensure_ascii=False, indent=1))
sys.exit(1 if failures else 0)
