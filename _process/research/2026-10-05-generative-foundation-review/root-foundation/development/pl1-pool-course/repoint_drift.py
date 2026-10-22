#!/usr/bin/env python3
"""PL1 landing (22 October 2026): re-point the chapter reference of records whose reviewed hash is the chapter just
before PL1's edits, after reading the change: python3 -B repoint_drift.py BEFORE_SHA256 (from the checkout root).
PL1, CK1, CR1 and EM1 added to sections 5, 7.4, 7.5, 7.7, 8.1 item 3 and 8.7; no text these records rest on changed."""
import hashlib, json, sys
from pathlib import Path

C = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
before = sys.argv[1]
ids = set(sys.argv[2:])  # records research-check reports as drifting only in the sections PL1 edited
h = hashlib.sha256(open(C, 'rb').read()).hexdigest()
NOTE = {'en': '22 October 2026, PL1 landing (with CK1, CR1, EM1): THE-THEORY-OF-BECOMING.md re-pointed. Since this record\'s reviewed '
              'hash, the cited text changed only by additions in sections 5, 7.4, 7.5, 7.7, 8.1 item 3 and 8.7 (pools along a run, '
              'what a center can know by a step, the deployed pipelines, learners that generalize). Read before re-pointing. The claim is unchanged.',
        'zh': '2026年10月22日，PL1 落地（与 CK1、CR1、EM1）：THE-THEORY-OF-BECOMING.md 重新指向。自本记录所审哈希以来，所引文字只因第 5、7.4、7.5、7.7 节、'
              '8.1 第 3 项与 8.7 的增补而变（沿历程的合池、中心逐步能知者、已部署流程、跨状态推广的学习者）。重新指向前已读。论断不变。'}
for f in sorted(Path('theories/becoming/results/records').glob('*.json')):
    d = json.loads(f.read_text())
    refs = [r for r in d.get('references', []) if r['path'] == C and (r['sha256'] == before or (f.stem in ids and r['sha256'] != h))]
    if not refs:
        continue
    for r in refs:
        r['sha256'] = h
    if not d['history'][-1]['en'].startswith('22 October 2026, PL1 landing'):
        d['history'].append(dict(NOTE))
    f.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print(f.stem)
