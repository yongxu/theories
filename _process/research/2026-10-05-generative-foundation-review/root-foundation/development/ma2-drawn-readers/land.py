#!/usr/bin/env python3
"""MA2's landing, 24 October 2026: bind readers-drawn-from-the-selected and closed-capture to the core receipt of
the merged tree, and carry the record from the retired canonical chapter to its home in 02 §9.

usage (from the checkout root, after the core checker has passed on the merged tree): python3 -B land.py RECEIPT_ID

readers-drawn-from-the-selected: references with the current sha256 of each cited file (02-MAP.md in place of the
retired chapter, the overview, OPENING, the meta-attractor page, the study, the delegated choices, the two
sources); the proof binding and validation scope at the receipt; the history renumbered (study section 398,
readings D67) with the landing added; D67 in place of D64 where the record names the readings.
closed-capture: MA2's next step, history line and related record, applied to main's record; its proof binding
and validation scope at the receipt; ClosedCapture.lean's and the receipt's references at their current sha256.
Other drifting references are left to repoint.sh."""
import datetime
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
L = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
RECORDS = ROOT / 'theories/becoming/results/records'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


receipt_id = sys.argv[1]
receipt = L + f'becoming-checks/{receipt_id}/verification.json'
v = json.loads((ROOT / receipt).read_text())
assert v['status'] == 'passed', v['status']
lean = L + 'Becoming/ClosedCapture.lean'
assert v['source_sha256']['Becoming.ClosedCapture'] == sha(lean), 'receipt does not bind the current source'
binding = [{'source': lean, 'receipt': receipt, 'sha256_pointer': '/source_sha256/Becoming.ClosedCapture',
            'success_pointer': '/status', 'success_value': 'passed'}]

# readers-drawn-from-the-selected
path = RECORDS / 'readers-drawn-from-the-selected.json'
d = json.loads(path.read_text())
decls = sorted({x for law in d['laws'] for x in law['declarations']})
refs = [{'path': lean, 'role': 'proof', 'declarations': decls, 'sha256': sha(lean)},
        {'path': L + 'Becoming/RuleCapture.lean', 'role': 'proof', 'sha256': sha(L + 'Becoming/RuleCapture.lean')},
        {'path': receipt, 'role': 'receipt', 'sha256': sha(receipt)}]
for p, role in [(RF + 'BECOMING-RENEWAL-READING.md', 'integration'),
                (RF + 'DELEGATED-CHOICES.md', 'integration'),
                ('theories/becoming/chapters/02-MAP.md', 'statement'),
                ('theories/becoming/THE-THEORY-OF-BECOMING.md', 'statement'),
                ('theories/becoming/OPENING.md', 'statement'),
                ('theories/meta-attractor/README.md', 'statement'),
                ('sources/15-codex-theory-conversations/2026-10-22-push-meta-attractor-further.md', 'provenance'),
                ('sources/15-codex-theory-conversations/2026-10-24-alignment-of-the-joint-selection.md', 'provenance')]:
    refs.append({'path': p, 'role': role, 'sha256': sha(p)})
d['references'] = refs
d['proof_bindings'] = binding
n = len(decls)
d['validation_scope'] = {
    'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {receipt_id}, on the tree merged with main '
          f'when it landed; first passed at 20261022T110422.961776Z): the {n} declarations cited here that '
          'Becoming.ClosedCapture gained have empty axiom reports; the checker verifies core purity. Built on 22 October in '
          'one session and reviewed there by one independent read-only reviewer, whose findings were applied; landed on '
          '24 October by another session (study section 398); not independently reviewed by a person.',
    'zh': f'Lean 4.29.1 合并检查器实查（回执 {receipt_id}，在落地时与主干合并之树上；首次通过于 20261022T110422.961776Z）：'
          f'本记录所引 Becoming.ClosedCapture 新增的 {n} 项声明公理报告为空；检查器并核对核心纯净。10 月 22 日在一个会话中构建，'
          '并由一位独立的只读审查者审查，其意见已采纳；10 月 24 日由另一会话落地（研究第 398 节）；未经人的独立审查。'}
d['history'] = [
    {'en': "22 October 2026: added (MA2) on branch ma2, on Ren's question about OPENING's note on the meta-attractor; an "
           "independent read-only review applied.",
     'zh': '2026年10月22日：于 ma2 分支新增（MA2），回应 Ren 关于 OPENING 元吸引子之注的提问；已采纳一次独立的只读审查。'},
    {'en': f'24 October 2026: landed on main, its owner idle since 22 October, by the session coordinating AJ on Ren\'s '
           f'yes; merged with main, the statement carried from the retired canonical chapter\'s §4.5 to 02 §9, the core '
           f'checker re-run on the merged tree (receipt {receipt_id}); study section 398; readings D67 (D64 when proved). '
           'The laws are unchanged.',
     'zh': f'2026年10月24日：其所有者自 10 月 22 日起闲置，由协调 AJ 的会话依 Ren 之同意落地主干；与主干合并，陈述由已退役的总章 '
           f'§4.5 移至 02 §9，在合并之树上重跑核心检查器（回执 {receipt_id}）；研究第 398 节；读法 D67（证明时为 D64）。诸律不变。'}]
for item in d['does_not_show']:
    for lang in ('en', 'zh'):
        item[lang] = item[lang].replace('D64', 'D67')
d['reviewed_at_utc'] = NOW
text = json.dumps(d, ensure_ascii=False)
for stale in ('THE-THEORY-OF-BECOMING.md#45', 'chapters/THE-THEORY-OF-BECOMING', 'study section 355', '研究第 355 节'):
    assert stale not in text, stale
path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('readers-drawn-from-the-selected: bound', n, 'declarations to', receipt_id)

# closed-capture
path = RECORDS / 'closed-capture.json'
c = json.loads(path.read_text())
c['next_delta'] = {
    'en': 'Readings of the share and of part of what lies beyond with weights other than a pool counted by kind, and how '
          'much of the loss such a reading must read to leave; real-valued shares; an independent review.',
    'zh': '以按类计数的汇合以外的权重读份额与份额之外一部分的读法，以及这样的读法须读多少损失才离开；实数份额；独立审查。'}
entry = {
    'en': '24 October 2026, MA2 (proved 22 October, landed 24 October): the next step revised, the reading formed by a '
          'selection among readers, a reading of the share and part of what lies beyond by a pool, and a loss read late '
          'now stated in readers-drawn-from-the-selected; the module gained that record\'s declarations, so the evidence '
          'counts this record\'s own; study section 398. The laws are unchanged.',
    'zh': '2026年10月24日，MA2（10 月 22 日证明，10 月 24 日落地）：下一步修订，由读者之间的选择形成的读法、由汇合读份额与份额之外'
          '一部分的读法、迟读的损失，现陈述于 readers-drawn-from-the-selected；模块增加了该记录的声明，所以证据只计本记录所引者；'
          '研究第 398 节。诸律不变。'}
if not any('MA2' in h['en'] for h in c['history']):
    c['history'].append(entry)
if not any(r['id'] == 'readers-drawn-from-the-selected' for r in c['related']):
    c['related'].append({'id': 'readers-drawn-from-the-selected', 'detail': {
        'en': 'The reading formed by a selection among readers: the rule as the pool of readers drawn from those it '
              'selects, and the loss read late by the readers the selection thins.',
        'zh': '由读者之间的选择形成的读法：规则为从其所选者中抽出的读者之汇合，以及被选择稀释的读者迟读的损失。'}})
c['proof_bindings'] = binding
for r in c['references']:
    if r['path'] == lean:
        r['sha256'] = sha(lean)
    elif r.get('role') == 'receipt':
        r['path'] = receipt
        r['sha256'] = sha(receipt)
c['validation_scope'] = {
    'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {receipt_id}): the 43 declarations of '
          'Becoming.ClosedCapture cited here, 28 of them theorems, have empty axiom reports; the checker verifies core '
          'purity. Built and reviewed in one session, with no separate reviewer; author review in study sections 242 and '
          '309; not independently reviewed by a person.',
    'zh': f'Lean 4.29.1 合并检查器实查（回执 {receipt_id}）：本记录所引 Becoming.ClosedCapture 的 43 项声明（28 项定理）公理报告为空；'
          '检查器并核对核心纯净。在一个会话中构建并审查，没有另设审查者；作者审查见研究第 242 与 309 节；未经人的独立审查。'}
c['reviewed_at_utc'] = NOW
path.write_text(json.dumps(c, ensure_ascii=False, indent=2) + '\n')
print('closed-capture: bound to', receipt_id)
