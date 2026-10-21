#!/usr/bin/env python3
"""LU1: extend the record closed-capture with the law of a part read alone (from the checkout root, after land_text.py):
python3 -B update_record.py CORE_RECEIPT STUDY_SECTION
Every declaration cited is resolved against the receipt's audited declarations, which must bind the module's bytes."""
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
PATH = ROOT / 'theories/becoming/results/records/closed-capture.json'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
assert re.search(rf'^## {N}\. Capture read as the part that makes sense alone \(LU1\)$', (ROOT / STUDY).read_text(), re.M)


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def src(mod):
    return f'{PKG}/Becoming/{mod}.lean'


m = next(x for x in core['modules'] if x['module'] == 'Becoming.ClosedCapture')
assert core['source_sha256']['Becoming.ClosedCapture'] == sha(src('ClosedCapture'))
assert not any(m['axiom_dependencies'].values())
full = {d['name'] for d in m['declarations']}
n_decl, n_thm = len(m['declarations']), sum(1 for d in m['declarations'] if d.get('kind') == 'theorem')
idr = next(x for x in core['modules'] if x['module'] == 'Becoming.IdentificationRuns')
idr_names = {d['name'] for d in idr['declarations']}
for n in ['Law.now_identifiesAlike_iff_goAlike', 'Law.sameFuture_of_goAlike', 'Law.part_identifiesAlike_iff_step']:
    assert f'Becoming.{n}' in idr_names, n

d = json.loads(PATH.read_text())
NEWD = [f'Becoming.ClosedCapture.{n}' for n in
        ['loopPart', 'goAlike_of_unread', 'identifiesAlike_iff_unread', 'courses_alike_iff_unread']]
assert all(n in full for n in NEWD)
law = {
    'en': 'The loop reads only the share exactly where what it reads makes sense alone: share, rule and step count (loopPart) '
          'go alike under the two-level step where Unread holds; they make sense by themselves along every schedule, and '
          'courses alike in share and rule stay alike along every schedule, exactly where Unread holds. This is '
          'IdentificationRuns\' law of a part read alone.',
    'zh': '回路只读份额，恰在它所读者单独成立之时：Unread 成立时，份额、规则与步数（loopPart）在两速一步下同行；恰在 Unread 成立时，'
          '它们在每种读步安排下自身成立，份额与规则相同的进程在每种安排下保持相同。这是 IdentificationRuns 的单独读一部分之律。',
    'declarations': NEWD}
assert len(law['en']) <= 420 and len(law['zh']) <= 190, (len(law['en']), len(law['zh']))
assert not any('loopPart' in str(x.get('declarations')) for x in d['laws'])
d['laws'].insert(1, law)
d['reviewed_at_utc'] = NOW
d['validation_scope'] = {
    'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {n_decl} declarations of '
          f'Becoming.ClosedCapture, {n_thm} of them theorems, have empty axiom reports; the checker verifies core purity. '
          'Built and reviewed in one session, with no separate reviewer; author review in study sections 242 and '
          f'{N}; not independently reviewed by a person.',
    'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.ClosedCapture 的 {n_decl} 项声明（{n_thm} 项定理）公理报告为空；'
          f'检查器并核对核心纯净。在一个会话中构建并审查，没有另设审查者；作者审查见研究第 242 与 {N} 节；未经人的独立审查。'}
d['correspondence']['en'] += (
    ' In supervisory control the loop\'s condition is observability under a reading of the joined whole, the reader '
    'inside the plant (Wakaiki, Tabuada and Hespanha 2019, Theorem 4.1); for a reward read through a channel the loop '
    'forms, a consistent corruption is indistinguishable from none and a reading the loop does not form is the way out '
    '(Everitt, Krakovna, Orseau and Legg 2017, Theorems 11 and 19); for a rule learned from what it admits, closed-loop '
    'identifiability (Borkar and Varaiya 1979). On the spine Unread is exactly the law of a part read alone '
    '(identifiesAlike_iff_unread), the lumping law that also settles what a learner identifies.')
d['correspondence']['zh'] += (
    '在监督控制中，回路的条件是对合并整体之读取下的可观测性，读者在受控对象之内（Wakaiki、Tabuada 与 Hespanha 2019，定理 4.1）；'
    '对经由回路所形成之通道读取的奖励，一致的污染与没有污染无法区分，回路不形成的读取是出路（Everitt、Krakovna、Orseau 与 Legg 2017，'
    '定理 11 与 19）；对从其所准入者学得的规则，是闭环可辨识性（Borkar 与 Varaiya 1979）。在脊柱上，Unread 恰是单独读一部分之律'
    '（identifiesAlike_iff_unread），即同样决定学习者辨识什么的归并之律。')
for a in ['the part that makes sense alone', 'Becoming.ClosedCapture.identifiesAlike_iff_unread']:
    if a not in d['aliases']:
        d['aliases'].append(a)
SPLIT = 'the-split-that-makes-sense'
assert (ROOT / f'theories/becoming/results/records/{SPLIT}.json').exists()
if not any(x['id'] == SPLIT for x in d['dependencies']):
    d['dependencies'].append({'id': SPLIT, 'relation': 'formal-reuse', 'detail': {
        'en': 'Reads Becoming.IdentificationRuns\' laws (Law.now_identifiesAlike_iff_goAlike, Law.sameFuture_of_goAlike, '
              'through Learning.goAlike_iff_lumped) on the two-level step, with what the loop reads as the part.',
        'zh': '把 Becoming.IdentificationRuns 的诸律（Law.now_identifiesAlike_iff_goAlike、Law.sameFuture_of_goAlike，经由 '
              'Learning.goAlike_iff_lumped）用于两速一步，以回路所读者为部分。'},
        'interface': {
            'output': {'en': 'A part read alone carries a law, and fixes its own future, exactly where the rest makes no '
                             'difference to its next value.',
                       'zh': '单独读一部分时，恰在其余者不影响其下一值之处，它承载一律并确定自身的未来。'},
            'input': {'en': 'What the loop reads (loopPart) and the two-level step.',
                      'zh': '回路所读者（loopPart）与两速一步。'},
            'conditions': {'en': 'Unread.', 'zh': 'Unread。'},
            'evidence': src('IdentificationRuns')}})
for r in d['references']:
    if r['path'] == src('ClosedCapture'):
        r['declarations'] = sorted(full)
        r['sha256'] = sha(r['path'])
    elif r['role'] == 'receipt':
        r['path'], r['sha256'] = RECEIPT, sha(RECEIPT)
    else:
        r['sha256'] = sha(r['path'])
for p in [src('IdentificationRuns'), REVIEW]:
    if not any(r['path'] == p for r in d['references']):
        d['references'].append({'path': p, 'role': 'proof' if p.endswith('.lean') else 'integration', 'sha256': sha(p)})
d['proof_bindings'] = [{'source': src('ClosedCapture'), 'receipt': RECEIPT,
                        'sha256_pointer': '/source_sha256/Becoming.ClosedCapture', 'success_pointer': '/status',
                        'success_value': 'passed'}]
d['history'].append({
    'en': f'21 October 2026, LU1: a law added, Unread read as the law of a part read alone (identifiesAlike_iff_unread, '
          f'courses_alike_iff_unread); unread_course derived from Law.sameFuture_of_goAlike, its statement unchanged; '
          f'study section {N}. The other laws are unchanged.',
    'zh': f'2026年10月21日，LU1：新增一律，把 Unread 读作单独读一部分之律（identifiesAlike_iff_unread、courses_alike_iff_unread）；'
          f'unread_course 由 Law.sameFuture_of_goAlike 推出，陈述不变；研究第 {N} 节。其余诸律不变。'})
PATH.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record closed-capture extended:', n_decl, 'declarations,', n_thm, 'theorems')
