#!/usr/bin/env python3
"""Write J1S's record basic-priority-step-by-step (a theorem) and note it in ranking-under-readings,
stepwise-law-of-easing and relation-level-law-of-easing (whose J1 items it states):
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION PREVIOUS_RECEIPT   (from the checkout root, after apply_text.py)

The laws cite exactly the declarations Becoming.Ranking gained since the previous receipt; every cited declaration is
resolved against the receipt's audited declarations, and the receipt must bind the module's current bytes. Every edit
is checked before anything is written."""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
REVIEW = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md'
CHAPTER = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
COVERAGE = 'theories/becoming/results/completion/COVERAGE.json'
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N, previous = sys.argv[1], int(sys.argv[2]), sys.argv[3]
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
HEAD = f"## {N}. The priority of basic conditions, step by step (J1S)"
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
        hits = [f for f in full if f == f'Becoming.{mod}.' + n]
        assert len(hits) == 1, (mod, n, hits)
        out.append(hits[0])
    return out


BOUNDS = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
          'omission-not-refutation']

RID = 'basic-priority-step-by-step'
RR = 'ranking-under-readings'
SL = 'stepwise-law-of-easing'
RLL = 'relation-level-law-of-easing'
RK = 'Ranking'

laws = [
    ("The two-part family read in two tiers over any claims with a part read off each: the sustaining formation's "
     "included claims, whose activity is the condition meeting its need, are basic; the focal formation's are gains.",
     '在任何能读出所属部分的断言上把二元族读作两层：维持者被记入的断言为基本（其活动即条件达到所需），焦点形成的断言为增益。',
     ['basicTier', 'gainTier']),
    ("Under the stepwise reading's premises the course without the focal formation is lexically above the course with "
     "it: it keeps every basic event, the sustaining formation active and drawing nothing at every step of it, and holds "
     "one the other loses after the loss; the same relation by relation.",
     '在逐步读法的前提下，没有焦点形成的进程在词典序上高于有它的进程：它保持每个基本事件（维持者在其每步都活动且不汲取），并持有另一进程在损失后失去的一个；逐个关系读亦然。',
     ['basic_first_stepwise', 'basic_first_relational']),
    ('Every comparison meeting J1 (BasicPriority with these tiers) ranks absence above malignant growth under the '
     'stepwise and relation-level readings, where C alone leaves the two unranked.',
     '满足 J1（以这两层的 BasicPriority）的每个比较，在逐步与关系层读法下都把不在场排在恶性增殖之上，那里 C 单独不对两者排序。',
     ['basic_first_ranks']),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
old_names = {d['name'] for d in next(m for m in P['modules'] if m['module'] == f'Becoming.{RK}')['declarations']}
full = decls(RK)
assert old_names <= set(full), old_names - set(full)
new = sorted(d for d in full if d not in old_names)
cited = sorted(d for _, _, names in laws for d in resolve(RK, names))
assert cited == new, (set(new) - set(cited), set(cited) - set(new))
EARLIER = ['Becoming.Ranking.stepwise', 'Becoming.Ranking.relational', 'Becoming.Ranking.stepwise_unranked',
           'Becoming.Ranking.relational_unranked', 'Becoming.Ranking.absent_sustains', 'Becoming.Ranking.course']
assert set(EARLIER) <= set(full), set(EARLIER) - set(full)
LEX = ['Becoming.Lexical.Above', 'Becoming.Lexical.Above.anchor', 'Becoming.Lexical.BasicPriority']
assert set(LEX) <= set(decls('Lexical')), set(LEX) - set(decls('Lexical'))
n_new = len(new)
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'The priority of basic conditions, step by step', 'zh': '逐步的基本条件优先'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': "Read with the sustaining formation's events as the basic tier, the priority of basic conditions (J1) ranks "
              "the absence of a malignant formation above its occurrence under the stepwise and relation-level readings, "
              "where C alone leaves them unranked.",
        'zh': '以维持者的事件为基本层读时，基本条件优先（J1）在逐步与关系层读法下把恶性形成的不在场排在其在场之上，那里 C 单独不对两者排序。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(RK, names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': "No axiom. The two-part family's premises as in stepwise_unranked (a positive need of the sustaining "
               "formation, the focal need within it, a start at that need, overdraw from some step on); J1/J2 as the "
               "condition BasicPriority on a comparison; the basic tier read as the sustaining formation's claims.",
         'zh': '不加公理。二元族的前提同 stepwise_unranked（维持者所需为正、焦点所需不超过它、起点达到该所需、自某步起过度汲取）；J1/J2 作为比较上的条件 BasicPriority；'
               '基本层读作维持者的断言。'}],
    'does_not_show': [
        {'en': "That the sustaining formation's claims must be the basic tier: the assignment is a reading, its activity "
               "being the condition meeting its need; another assignment is not covered.",
         'zh': '维持者的断言必须是基本层：此分派是一种读法（其活动即条件达到所需）；其他分派未涵盖。', 'kind': 'non-implication'},
        {'en': 'Families beyond the two-part one; the form of L under the condition.',
         'zh': '二元族之外的族；条件之下 L 的形式。', 'kind': 'scope'},
        {'en': 'Which comparison to use, J1 or C alone: each is a premise the theorems take.',
         'zh': '应采用哪种比较，J1 还是单独的 C：各是定理所取的前提。', 'kind': 'non-implication'}],
    'counterexamples': [],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {n_new} declarations '
              f'Becoming.Ranking gained have empty axiom reports; the checker verifies core purity. Built and reviewed in '
              f'one session; author review in study section {N}; not independently reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Ranking 新增的 {n_new} 项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'The same beyond the two-part family, with the basic tier read as the claims of formations whose activity '
              'is a condition meeting its need; the form of L under the condition; an independent review.',
        'zh': '二元族之外的同一结论，基本层读作其活动即条件达到所需之形成的断言；条件之下 L 的形式；独立审查。'},
    'correspondence': {
        'en': "The comparisons are the theory's own. C read on all living events weighs a malignant formation's early "
              "event against the sustaining formation's later ones and ranks neither course; J1 counts the basic tier "
              "first, and the course without the malignant formation keeps strictly more of it, so no gain of the "
              "malignant formation trades for the loss.",
        'zh': '比较是本理论自己的。C 读所有活的事件时，把恶性形成的早期事件与维持者后来的事件相权，不对任一进程排序；J1 先计基本层，没有恶性形成的进程保持其中严格更多，'
              '故恶性形成的任何增益都不能换取那一损失。'},
    'canonical_source': src(RK),
    'aliases': ['the priority of basic conditions step by step', 'J1 ranks absence above malignant growth', '逐步的基本条件优先',
                'Becoming.Ranking.basic_first_ranks', 'Becoming.Ranking.basic_first_stepwise'],
    'dependencies': [
        {'id': RR, 'relation': 'formal-reuse',
         'detail': {'en': 'The two-part family, its courses and the stepwise reading are reused; the question its next step '
                          'asked is answered.',
                    'zh': '沿用二元族、其进程与逐步读法；回答了其下一步所问。'},
         'interface': {
             'output': {'en': 'course, stepwise, stepwise_unranked, absent_sustains.', 'zh': 'course、stepwise、stepwise_unranked、absent_sustains。'},
             'input': {'en': 'J1 ranks absence above malignant growth step by step.', 'zh': 'J1 逐步把不在场排在恶性增殖之上。'},
             'conditions': {'en': "The basic tier read as the sustaining formation's events.", 'zh': '基本层读作维持者的事件。'},
             'evidence': src(RK)}},
        {'id': RLL, 'relation': 'formal-reuse',
         'detail': {'en': 'The relation-level reading and its unranked two-part family are reused.',
                    'zh': '沿用关系层读法及其二元族不排序。'},
         'interface': {
             'output': {'en': 'relational, relational_unranked.', 'zh': 'relational、relational_unranked。'},
             'input': {'en': 'The same ranking relation by relation.', 'zh': '逐个关系读的同一排序。'},
             'conditions': {'en': 'The two-part family.', 'zh': '二元族。'},
             'evidence': src(RK)}}],
    'related': [{'id': 'protection-priority-excludes-uniform-aggregation', 'detail': {
        'en': 'That record states what basic-condition priority excludes among scores; here it ranks courses step by step.',
        'zh': '该记录陈述基本条件优先在评分中排除什么；此处它逐步给进程排序。'}}],
    'references': [{'path': src(RK), 'role': 'proof', 'declarations': sorted(new + EARLIER), 'sha256': sha(src(RK))},
                   {'path': src('Lexical'), 'role': 'proof', 'declarations': LEX, 'sha256': sha(src('Lexical'))},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                   {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
    'proof_bindings': [{'source': src(mod), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{mod}',
                        'success_pointer': '/status', 'success_value': 'passed'} for mod in [RK, 'Lexical']],
    'history': [{
        'en': f"21 October 2026: added (J1S), the priority of basic conditions step by step: read with the sustaining "
              f"formation's events as the basic tier, J1 ranks absence above malignant growth under the stepwise and "
              f"relation-level readings; study section {N}.",
        'zh': f'2026年10月21日：新增（J1S），逐步的基本条件优先：以维持者的事件为基本层读时，J1 在逐步与关系层读法下把不在场排在恶性增殖之上；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, (len(rec['statement']['en']), len(rec['statement']['zh']))
for h in rec['hypotheses']:
    assert len(h['en']) <= 420, len(h['en'])
for h in rec['does_not_show']:
    assert len(h['en']) <= 240, len(h['en'])
notes = [
    (RR, [], [('Whether the priority of basic conditions yields “better without malignant growth” stepwise.',
               'The form of L under the condition; an independent review.'),
              ('检验基本条件优先能否在逐步读法下给出“没有恶性增殖更好”。', '条件之下 L 的形式；独立审查。')]),
    (SL, [('; whether J1 yields "better without malignant growth" step by step.', '.'),
          ('；J1 能否在逐步读法下给出“没有恶性增殖更好”。', '。')],
         [('J1 step by step; ', ''), ('逐步的 J1；', '')]),
    (RLL, [('; J1 step by step.', '.'), ('；逐步的 J1。', '。')],
          [('J1 step by step; ', ''), ('逐步的 J1；', '')])]
loaded = {}
for rid, dns_pairs, nd_pairs in notes:
    d = json.loads((RECORDS / f'{rid}.json').read_text())
    for old, new in dns_pairs:
        lang = 'zh' if re.search('[一-鿿]', old) else 'en'
        hits = [x for x in d['does_not_show'] if old in x[lang]]
        assert len(hits) == 1, (rid, old)
        hits[0][lang] = hits[0][lang].replace(old, new)
    for old, new in nd_pairs:
        lang = 'zh' if re.search('[一-鿿]', old) else 'en'
        assert d['next_delta'][lang].count(old) == 1, (rid, lang, old)
        d['next_delta'][lang] = d['next_delta'][lang].replace(old, new)
    d['related'] = d.get('related', []) + [{'id': RID, 'detail': {
        'en': "Read with the sustaining formation's events as the basic tier, J1 ranks absence above malignant growth "
              "under the stepwise and relation-level readings.",
        'zh': '以维持者的事件为基本层读时，J1 在逐步与关系层读法下把不在场排在恶性增殖之上。'}}]
    d['history'].append({
        'en': f'21 October 2026, J1S: whether J1 yields "better without malignant growth" step by step is answered (record '
              f'{RID}, study section {N}); the next step says so. Its laws are unchanged.',
        'zh': f'2026年10月21日，J1S：J1 能否逐步给出“没有恶性增殖更好”已回答（记录 {RID}，研究第 {N} 节）；下一步如此说明。其规律不变。'})
    loaded[rid] = d
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID, n_new, 'declarations')
for rid, d in loaded.items():
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('noted', rid)
