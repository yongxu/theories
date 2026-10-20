#!/usr/bin/env python3
"""Write WE1's record whole-drawing-beyond-renewal-ends (a theorem), note it in whole-persists-through-generation, and
give the coverage file's collective row the record and its law:
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION PREVIOUS_RECEIPT   (from the checkout root, after apply_text.py)

Every declaration cited is resolved against the receipt's audited declarations (a short name must match exactly one
declaration of the named module), the receipt must bind each cited module's current bytes, and the record must cite
every declaration WE1 added to Becoming.Wholes (adapted from SG1's make_record.py)."""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
STUDY = f'{RF}/BECOMING-RENEWAL-READING.md'
REVIEW = f'{RF}/BECOMING-SIGNIFICANCE-REVIEW.md'
CHAPTER = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
OPENING = 'theories/becoming/OPENING.md'
COVERAGE = 'theories/becoming/results/completion/COVERAGE.json'
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
HEAD = f"## {N}. A whole that draws its parts' arising beyond its renewal ends (WE1)"
assert re.search('^' + re.escape(HEAD) + '$', (ROOT / STUDY).read_text(), re.M)


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def src(mod):
    return f'{PKG}/Becoming/{mod}.lean'


def decls(mod):
    m = next(m for m in core['modules'] if m['module'] == f'Becoming.{mod}')
    assert core['source_sha256'][f'Becoming.{mod}'] == sha(src(mod)), ('receipt does not bind', mod)
    assert not any(m['axiom_dependencies'].values())
    return [d['name'] for d in m['declarations']]


def resolve(mod, names):
    full = decls(mod)
    out = []
    for n in names:
        hits = [f for f in full if f == 'Becoming.' + n] or [f for f in full if f.endswith('.' + n)]
        assert len(hits) == 1, (mod, n, hits)
        out.append(hits[0])
    return out


BOUNDS = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
          'omission-not-refutation']


def dep(rid, relation, en, zh, out_en, out_zh, in_en, in_zh, cond_en, cond_zh, evidence):
    return {'id': rid, 'relation': relation, 'detail': {'en': en, 'zh': zh},
            'interface': {'output': {'en': out_en, 'zh': out_zh}, 'input': {'en': in_en, 'zh': in_zh},
                          'conditions': {'en': cond_en, 'zh': cond_zh}, 'evidence': evidence}}


RID = 'whole-drawing-beyond-renewal-ends'
WHOLE = 'whole-persists-through-generation'
GROUPS = 'groups-whose-conditions-are-coupled'
OWN = 'own-count-misses-joint-excess'
WM = 'Wholes'

EXCEEDING = ['WholeExceeding.alive', 'WholeExceeding.web', 'WholeExceeding.flow', 'WholeExceeding.balances',
             'WholeExceeding.acting', 'WholeExceeding.dependent', 'WholeExceeding.gated', 'WholeExceeding.arising',
             'WholeExceeding.whole', 'WholeExceeding.member_ne', 'WholeExceeding.lineage_ne',
             'WholeExceeding.not_mem_pair', 'WholeExceeding.listed', 'WholeExceeding.ends', 'WholeExceeding.excess',
             'WholeExceeding.drawn']
NEEDED = ['WholeWithin.web', 'WholeWithin.flow', 'WholeWithin.balances', 'WholeWithin.acting', 'WholeWithin.dependent',
          'WholeWithin.gated', 'WholeWithin.arising', 'WholeWithin.kept',
          'WholeUnending.web', 'WholeUnending.flow', 'WholeUnending.balances', 'WholeUnending.persists',
          'WholeUngated.web', 'WholeUngated.flow', 'WholeUngated.balances', 'WholeUngated.persists']
laws = [
    ('Parts each of whose activity ends, with the active ones listed at each step, none arising from some step on, are '
     'all inactive from a later step, and a whole of such parts ends; Covered.needs_arising and Whole.needs_arising are '
     'the case of a whole that persists.',
     '各自终结、每步活跃者可列出的部分，从某步起无一生起时，从更晚的某步起全都不活跃，这样的部分的整体终结；'
     'Covered.needs_arising 与 Whole.needs_arising 是整体持续的情形。',
     ['Web.Listed.end_without_arising', 'Web.Whole.ends_without_arising']),
    ('With a flow, under balance, only active formations giving and activity needing support: a whole of such parts '
     'arising only where they then depend on some condition of a family at a need of at least m, the family\'s renewal '
     'gated on it, has no part arising after n steps of excess of the family\'s uptake over its replenishment from a '
     'stock below n + m, and ends; the family of one condition is the joint-excess form.',
     '在带流的同一世界上，在平衡、只有活跃者给予、活动需要支持之下：部分只在以至少 m 的需要依存于某条件族时生起、族的更新以族为门控的这样的整体，'
     '在族的取用超过补充 n 步、起始存量低于 n + m 之后再无部分生起并终结；单个条件之族即联合超出的形式。',
     ['Web.Whole.family_excess_ends', 'Web.Whole.joint_excess_ends']),
    ('Witness WholeExceeding: a lineage of members that each end, each arising where the condition it then depends on '
     'stands at its need and giving it one, the lineage taking two; every premise holds, the lineage is active at steps '
     'zero to two, and, through the law, no member arises from step two on and the lineage ends.',
     '见证 WholeExceeding：成员各自终结、各在其所依存的条件处于其需要时生起并给予它一，谱系取二；每个前提成立，谱系在第零至二步活跃，'
     '经由该律，从第二步起无成员生起，谱系终结。',
     EXCEEDING),
    ('The excess, ending parts and the arising\'s dependence are each needed: drawing within what the members give, the '
     'lineage is active at every step (WholeWithin); with a part that never ends (WholeUnending), or members arising '
     'without depending on the drawn condition (WholeUngated), the whole persists through the same excess.',
     '超出、部分终结与生起的依存各自必要：在成员所给之内汲取，谱系每步活跃（WholeWithin）；有一个永不终结的部分（WholeUnending），'
     '或成员不依存于被汲取的条件而生起（WholeUngated），整体经历同样的超出而持续。',
     NEEDED),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
full = decls(WM)
cited = sorted(d for _, _, names in laws for d in resolve(WM, names))
# The declarations WE1 added: the module's declarations less those audited by the receipt before WE1's.
prev_id = sys.argv[3]
prev = json.loads((ROOT / f'{PKG}/becoming-checks/{prev_id}/verification.json').read_text())
before = {d['name'] for m in prev['modules'] if m['module'] == f'Becoming.{WM}' for d in m['declarations']}
assert len(before) == 51, len(before)
assert before <= set(full), before - set(full)
new = sorted(set(full) - before)
assert sorted(cited) == sorted(new), (set(new) - set(cited), set(cited) - set(new))
USED = {'Continuation': ['Becoming.Flow.family_excess_ends', 'Becoming.Flow.gate_single'],
        'Wholes': ['Becoming.Web.Whole', 'Becoming.Web.Listed', 'Becoming.Web.Ends', 'Becoming.Web.active_back',
                   'Becoming.Web.Ends.all', 'Becoming.Web.Covered.needs_arising', 'Becoming.Generations.whole',
                   'Becoming.Generations.listed', 'Becoming.Generations.ends', 'Becoming.Generations.generations',
                   'Becoming.Generations.parts', 'Becoming.Generations.alive']}
refs_used = []
for mod, names in USED.items():
    have = set(decls(mod))
    assert set(names) <= have, (mod, set(names) - have)
    refs_used.append((mod, sorted(names)))
wholes_decls = sorted(set(cited) | set(dict(refs_used)['Wholes']))
SA = f'BECOMING-RENEWAL-READING.md#{N}-a-whole-that-draws-its-parts-arising-beyond-its-renewal-ends-we1'
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'A whole that draws its parts\' arising beyond its renewal ends',
              'zh': '汲取其部分之生起超过更新的整体终结'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Listed parts that each end, none arising from some step on, end with their whole; so a whole whose parts '
              'arise only where they depend on a family whose renewal is gated on it ends after the joint draw exceeds '
              'the renewal for longer than the margin.',
        'zh': '各自终结、可列出、从某步起无一生起的部分，与其整体一同终结；所以部分只在依存于更新以其为门控的条件族时生起的整体，'
              '在联合汲取超过更新长于余量之后终结。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(WM, names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': 'No axiom. The whole (Web.Whole, coincidence of activity) and its parts are a representational premise; '
               'the parts are listed at each step (finitely many active at once) and each part\'s activity ends.',
         'zh': '不加公理。整体（Web.Whole，活动的重合）与其部分是表示前提；部分每步可列出（同时活跃者有限），每个部分的活动终结。'},
        {'en': 'For the join: balance, only active formations giving (Acting), activity needing support (Dependent); the '
               'family\'s renewal gated on it (whatever gives to a member depends on some member at a need of at least '
               'm); a part arising across a step depends, at its first active step, on some member at such a need; n '
               'steps of excess of the family\'s uptake over its replenishment from a stock below n + m.',
         'zh': '对于结合：平衡、只有活跃者给予（Acting）、活动需要支持（Dependent）；族的更新以族为门控（凡给予某成员者都以至少 m 的需要依存于某个成员）；'
               '跨某步生起的部分在其首个活跃步以这样的需要依存于某个成员；族的取用超过补充 n 步，起始存量低于 n + m。'},
        {'en': 'Discrete steps and natural-number amounts, as in Becoming.Continuation; the uptake counts every taker, so '
               'no taker, the whole included, is singled out.',
         'zh': '离散的步与自然数的量，与 Becoming.Continuation 同；取用计入每个取用者，所以没有哪个取用者（整体在内）被单独挑出。'}],
    'does_not_show': [
        {'en': 'That the gate on renewal and the finite listing are needed for this law: Countless shows the listing needed '
               'for Whole.needs_arising, with no flow; no witness here drops either with every other premise kept.',
         'zh': '更新的门控与有限列出对本律必要：Countless 表明列出对 Whole.needs_arising 必要，但没有流；此处没有见证在保持其余前提时去掉其中之一。',
         'kind': 'scope'},
        {'en': 'That the whole ends at T + n: it ends once the parts active then have ended, at a step the listing fixes.',
         'zh': '整体在 T + n 终结：它在那时活跃的部分都终结之后终结，在列出所定的某一步。', 'kind': 'scope'},
        {'en': 'That the collective is the consumer, or that its ending is a loss: the draw is joint, and no evaluation '
               'enters; a loss is a loss under a significance (chapter 6).',
         'zh': '集体是消耗者，或其终结是损失：汲取是联合的，没有评价进入；损失是在某种意义之下的损失（第 6 章）。', 'kind': 'non-implication'},
        {'en': 'That actual collectives meet the premises, above all that new members arise only where what is drawn stands '
               'at their need: that is the reading carried by OPENING\'s sentence.',
         'zh': '实际的集体满足这些前提，尤其是新成员只在被汲取者处于其需要时生起：这是 OPENING 那句话所承载的读法。', 'kind': 'scope'}],
    'counterexamples': [{'path': src(WM), 'detail': {
        'en': 'WholeWithin, WholeUnending and WholeUngated: with the excess, ending parts or the arising\'s dependence '
              'dropped and every other premise kept, the whole is active at every step.',
        'zh': 'WholeWithin、WholeUnending 与 WholeUngated：去掉超出、部分终结或生起的依存而保持其余前提时，整体每步活跃。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {len(cited)} declarations '
              f'WE1 added to Becoming.Wholes have empty axiom reports, as does every declaration of the module; the checker '
              f'verifies core purity. Built and reviewed in one session, with no separate reviewer; author review in study '
              f'section {N}; not independently reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：WE1 加入 Becoming.Wholes 的 {len(cited)} 项声明公理报告为空，该模块每项声明亦然；'
              f'检查器并核对核心纯净。在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'Witnesses for the gate on renewal and the finite listing; a whole whose parts\' arising draws on the family '
              'only in part (some arising through what is drawn, some through another renewal); an independent review.',
        'zh': '更新门控与有限列出的见证；部分的生起只部分地取自该族的整体（一些经被汲取者生起，一些经另一更新）；独立审查。'},
    'correspondence': {
        'en': 'OPENING note collective: "a collective made of lives that each end goes on only as new lives keep arising; '
              'one that consumes them consumes what it goes on through" (Ren\'s body sentence), read with a collective as '
              'the whole of its lives, the lives\' renewal as the drawn family and consuming as the joint draw exceeding '
              'it (the AI\'s readings); TH1\'s revised proposal 8, its second clause. Reading: joint consumption has no '
              'single consumer (joint-difference-making).',
        'zh': 'OPENING 注 collective：“由各自终结的生命构成的集体，只在新生命不断生起时延续；消耗它们的集体消耗了它所赖以延续者”（Ren 的正文），'
              '读法为：集体是其生命的整体，生命的更新是被汲取的族，消耗是联合汲取超过它（AI 的读法）；TH1 修订的提议 8 的第二句。'
              '读法：联合消耗没有单一的消耗者。'},
    'canonical_source': src(WM),
    'aliases': ['a whole that draws its parts\' arising beyond its renewal ends', 'a collective consuming what it goes '
                'on through', 'ending parts end together without arising', '汲取其部分之生起超过更新的整体终结',
                'Becoming.Web.Whole.family_excess_ends', 'Becoming.Web.Whole.joint_excess_ends',
                'Becoming.Web.Listed.end_without_arising', 'Becoming.Web.Whole.ends_without_arising'],
    'dependencies': [
        dep(WHOLE, 'formal-reuse',
            'Reuses Web.Whole, Web.Listed, Web.Ends, active_back and Ends.all; Covered.needs_arising is now proved from '
            'Listed.end_without_arising; the witnesses reuse Generations.',
            '复用 Web.Whole、Web.Listed、Web.Ends、active_back 与 Ends.all；Covered.needs_arising 现由 Listed.end_without_arising 证明；'
            '见证复用 Generations。',
            'A whole is active exactly while some part is; a part active after a step at which nothing arose was not '
            'inactive at it; finitely many endings end by one step.',
            '整体恰在某部分活跃时活跃；在无生起之后活跃的部分，在那一步并非不活跃；有限个终结在同一步之前终结。',
            'Ending parts end together without arising, and their whole.', '无生起时终结的部分一同终结，其整体亦然。',
            'Listed; each part ends.', '可列出；每个部分终结。', src(WM)),
        dep(GROUPS, 'formal-reuse',
            'The join applies Flow.family_excess_ends at the step after a part\'s arising; the one-condition form goes '
            'through Flow.gate_single.',
            '结合在部分生起后的一步应用 Flow.family_excess_ends；单条件形式经 Flow.gate_single。',
            'After n steps of the family\'s excess from a stock below n + m, every formation depending on a member at a '
            'need of at least m is inactive from T + n on.',
            '族超出 n 步、起始存量低于 n + m 之后，凡以至少 m 的需要依存于某成员的形成，从 T + n 起都不活跃。',
            'No part arises from T + n on.', '从 T + n 起没有部分生起。',
            'Balance, Acting, Dependent, the coupled gate.', '平衡、Acting、Dependent、耦合的门控。', src('Continuation'))],
    'related': [
        {'id': WHOLE, 'detail': {'en': 'A persisting whole needs its parts\' arising; this record says how a whole ends where '
                                       'that arising stops, and what stops it.',
                                 'zh': '持续的整体需要部分的生起；本记录说生起停止时整体如何终结，以及什么使它停止。'}},
        {'id': OWN, 'detail': {'en': 'Joint excess ends gated renewal; read for a whole, it ends what the whole goes on '
                                     'through.',
                               'zh': '联合超出终结门控的更新；对整体读，它终结整体赖以延续者。'}}],
    'references': [{'path': src(WM), 'role': 'proof', 'declarations': wholes_decls, 'sha256': sha(src(WM))},
                   {'path': src('Continuation'), 'role': 'proof', 'declarations': dict(refs_used)['Continuation'],
                    'sha256': sha(src('Continuation'))},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                   {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)},
                   {'path': OPENING, 'role': 'statement', 'sha256': sha(OPENING)}],
    'proof_bindings': [{'source': src(mod), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{mod}',
                        'success_pointer': '/status', 'success_value': 'passed'}
                       for mod in [WM, 'Continuation']],
    'history': [{
        'en': f'21 October 2026: added (WE1), a whole that draws its parts\' arising beyond its renewal ends: the law below '
              f'Whole.needs_arising (ending listed parts end together without arising, and their whole) and its join with '
              f'Flow.family_excess_ends; OPENING note collective restated; study section {N}.',
        'zh': f'2026年10月21日：新增（WE1），汲取其部分之生起超过更新的整体终结：Whole.needs_arising 之下的律（无生起时可列出的终结部分一同终结，'
              f'其整体亦然）及其与 Flow.family_excess_ends 的结合；OPENING 注 collective 重述；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, (len(rec['statement']['en']), len(rec['statement']['zh']))
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID, len(cited), 'new declarations cited')

# The persisting whole's record notes the ending.
p = RECORDS / f'{WHOLE}.json'
d = json.loads(p.read_text())
d.setdefault('related', []).append({'id': RID, 'detail': {
    'en': 'How a whole of ending listed parts ends where their arising stops, and a draw beyond renewal that stops it.',
    'zh': '可列出的终结部分之整体在其生起停止时如何终结，以及使之停止的超过更新的汲取。'}})
d['history'].append({
    'en': f'21 October 2026, WE1: Covered.needs_arising is now proved from Listed.end_without_arising, the law below it '
          f'(record {RID}, study section {N}); this record\'s statement, laws and declarations are unchanged.',
    'zh': f'2026年10月21日，WE1：Covered.needs_arising 现由其下的律 Listed.end_without_arising 证明（记录 {RID}，研究第 {N} 节）；'
          '本记录的陈述、定律与声明不变。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('noted', WHOLE)

cov = json.loads((ROOT / COVERAGE).read_text())
row = next(r for r in cov['rows'] if r['id'] == 'collective')
assert RID not in row['records']
row['records'].append(RID)
row['declarations'].append('Becoming.Web.Whole.family_excess_ends')
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
print('coverage row collective')
