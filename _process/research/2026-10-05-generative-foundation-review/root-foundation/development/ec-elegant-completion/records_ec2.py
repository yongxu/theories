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

# EC4: the record of what the step across standpoints reaches gains the valuations' reading of the scope.
f = RECORDS / 'what-the-step-across-standpoints-reaches.json'
rec = json.loads(f.read_text())
NEW = ['Becoming.Valuation.transmits_iff_closed', 'Becoming.Valuation.forced_iff_reach',
       'Becoming.Valuation.forced_whole_iff_connected']
for n in NEW:
    assert n in elab['Becoming.ValuationFrames'], n
rec['laws'].append({
    'en': 'On valuations, relational neutrality is closedness of each standpoint\'s significance under the formed '
          'relations\' steps; what the two neutralities force from a valued living claim is exactly what it reaches '
          'through formed relations among living claims, and every living claim is forced exactly where the formed '
          'relations connect the living claims: the scope is the closure, as on boundaries (forced_iff_within).',
    'zh': '在赋值上，关系中立即各立场的意义对所成关系之步封闭；两种中立由一个有意义的存活主张所迫出者，恰是经存活主张间所成关系所及者；'
          '恰在所成关系连通诸存活主张之处，每个存活主张都被迫出：范围即闭包，与边界上相同（forced_iff_within）。',
    'declarations': NEW})
vf = next((r for r in rec['references'] if r['path'] == src('ValuationFrames')), None)
if vf is None:
    vf = {'path': src('ValuationFrames'), 'role': 'proof', 'sha256': sha(src('ValuationFrames')), 'declarations': []}
    rec['references'].insert(0, vf)
vf['declarations'] += [n for n in NEW if n not in vf['declarations']]
if not any(b['source'] == src('ValuationFrames') for b in rec['proof_bindings']):
    rec['proof_bindings'].append({'source': src('ValuationFrames'), 'receipt': RECEIPT,
                                  'sha256_pointer': '/source_sha256/Becoming.ValuationFrames',
                                  'success_pointer': '/status', 'success_value': 'passed'})
if not any(x['path'] == RECEIPT for x in rec['references']):
    rec['references'].append({'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT), 'declarations': []})
rec['aliases'] += [n for n in NEW if n not in rec['aliases']]
rec['history'].append({
    'en': f'21 October 2026, EC4 (study section {N + 1}): a law added, the valuations\' reading of the scope '
          '(Valuation.transmits_iff_closed, Valuation.forced_iff_reach, Valuation.forced_whole_iff_connected in '
          'Becoming.ValuationFrames): what the two neutralities force is the closure of a valued living claim, the same '
          'law as forced_iff_within on boundaries. Readings D61. The record\'s earlier laws are unchanged.',
    'zh': f'2026年10月21日，EC4（研究第 {N + 1} 节）：新增一律，即赋值上的范围读法（Becoming.ValuationFrames 中的 '
          'Valuation.transmits_iff_closed、Valuation.forced_iff_reach、Valuation.forced_whole_iff_connected）：两种中立所迫出者'
          '是一个有意义的存活主张的闭包，与边界上的 forced_iff_within 为同一律。读法 D61。本记录先前各律不变。'})
f.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('record', rec['id'], 'EC4 law')
