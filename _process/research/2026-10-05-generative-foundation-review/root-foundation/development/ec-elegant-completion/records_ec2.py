#!/usr/bin/env python3
"""EC2's records: balance_over_stretch_on (from Becoming.Change) and balance_over_stretch, le_over_stretch,
ge_over_stretch (from Becoming.Population) moved unchanged, with their full names, to Becoming.Prelude. Each record
citing them under the old module cites them under the prelude, with a proof binding to the core receipt, and gets a
history note. Run before repoint.py --receipt.
python3 -B records_ec2.py CORE_RECEIPT STUDY_SECTION   (from the checkout root, after land_text_ec2.py)"""
import hashlib, json, re, sys
from pathlib import Path
ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
assert re.search(rf'^## {N}\. One stretch balance in the prelude \(EC2\)$', (ROOT / STUDY).read_text(), re.M)
elab = {m['module']: {d['name'] for d in m['declarations']} for m in core['modules']}
MOVED = {'Becoming.balance_over_stretch_on': 'Change', 'Becoming.balance_over_stretch': 'Population',
         'Becoming.le_over_stretch': 'Population', 'Becoming.ge_over_stretch': 'Population'}
for n in MOVED:
    assert n in elab['Becoming.Prelude'], n
src = lambda m: f'{PKG}/Becoming/{m}.lean'
sha = lambda p: hashlib.sha256((ROOT / p).read_bytes()).hexdigest()
for f in sorted(RECORDS.glob('*.json')):
    rec = json.loads(f.read_text())
    moved = []
    for r in rec['references']:
        if not r.get('declarations'):
            continue
        hit = [n for n in r['declarations'] if n in MOVED and r['path'] == src(MOVED[n])]
        if hit:
            r['declarations'] = [n for n in r['declarations'] if n not in hit]
            moved += hit
    if not moved:
        continue
    pre = next((r for r in rec['references'] if r['path'] == src('Prelude')), None)
    if pre is None:
        pre = {'path': src('Prelude'), 'role': 'proof', 'sha256': sha(src('Prelude')), 'declarations': []}
        rec['references'].insert(0, pre)
    pre['declarations'] += [n for n in moved if n not in pre['declarations']]
    if not any(b['source'] == src('Prelude') for b in rec['proof_bindings']):
        rec['proof_bindings'].append({'source': src('Prelude'), 'receipt': RECEIPT,
                                      'sha256_pointer': '/source_sha256/Becoming.Prelude',
                                      'success_pointer': '/status', 'success_value': 'passed'})
    if not any(x['path'] == RECEIPT for x in rec['references']):
        rec['references'].append({'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT), 'declarations': []})
    names = ', '.join(n.replace('Becoming.', '') for n in moved)
    rec['history'].append({
        'en': f'21 October 2026, EC2 (study section {N}): declarations moved with their full names: {names} to '
              'Becoming.Prelude, the one stretch balance from which the stretch balances of flows, amounts and courses '
              'are now derived. The cited Lean source and its proof binding follow them; the claim is unchanged.',
        'zh': f'2026年10月21日，EC2（研究第 {N} 节）：声明以完整名称移动：{names} 移至 Becoming.Prelude，即唯一的跨段平衡，'
              '流、量与过程的跨段平衡现由其导出。所引 Lean 源及其证明绑定随之；论断不变。'})
    f.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
    print('record', rec['id'], names)
