#!/usr/bin/env python3
"""Bind the record readers-drawn-from-the-selected to its receipt and sources: python3 -B bind.py RECEIPT_ID

Sets the references (proof, receipt, statements, integration) with the current sha256 of each file, the proof
binding of ClosedCapture.lean to the receipt, and the validation scope. Run from the checkout root after the
checker has passed and every cited document is final."""
import hashlib, json, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[6]
REC = ROOT / 'theories/becoming/results/records/readers-drawn-from-the-selected.json'
L = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


receipt_id = sys.argv[1]
receipt = L + f'becoming-checks/{receipt_id}/verification.json'
v = json.loads((ROOT / receipt).read_text())
assert v['status'] == 'passed', v['status']
lean = L + 'Becoming/ClosedCapture.lean'
assert v['source_sha256']['Becoming.ClosedCapture'] == sha(lean), 'receipt does not bind the current source'
d = json.loads(REC.read_text())
decls = sorted({x for law in d['laws'] for x in law['declarations']})
refs = [{'path': lean, 'role': 'proof', 'declarations': decls, 'sha256': sha(lean)},
        {'path': L + 'Becoming/RuleCapture.lean', 'role': 'proof', 'sha256': sha(L + 'Becoming/RuleCapture.lean')},
        {'path': receipt, 'role': 'receipt', 'sha256': sha(receipt)}]
for path, role in [(RF + 'BECOMING-RENEWAL-READING.md', 'integration'),
                   (RF + 'DELEGATED-CHOICES.md', 'integration'),
                   ('theories/becoming/chapters/THE-THEORY-OF-BECOMING.md', 'statement'),
                   ('theories/becoming/OPENING.md', 'statement'),
                   ('theories/meta-attractor/README.md', 'statement'),
                   ('sources/15-codex-theory-conversations/2026-10-22-push-meta-attractor-further.md', 'provenance')]:
    refs.append({'path': path, 'role': role, 'sha256': sha(path)})
d['references'] = refs
d['proof_bindings'] = [{'source': lean, 'receipt': receipt, 'sha256_pointer': '/source_sha256/Becoming.ClosedCapture',
                        'success_pointer': '/status', 'success_value': 'passed'}]
n = len(decls)
d['validation_scope'] = {
    'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {receipt_id}): the {n} declarations cited here '
          'that Becoming.ClosedCapture gained have empty axiom reports; the checker verifies core purity. Built in one '
          'session and reviewed there by one independent read-only reviewer, whose findings were applied (study '
          'section 349); not independently reviewed by a person.',
    'zh': f'Lean 4.29.1 合并检查器实查（回执 {receipt_id}）：本记录所引 Becoming.ClosedCapture 新增的 {n} 项声明公理报告为空；'
          '检查器并核对核心纯净。在一个会话中构建，并由一位独立的只读审查者审查，其意见已采纳（研究第 349 节）；未经人的独立审查。'}
REC.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('bound', n, 'declarations to', receipt_id)
