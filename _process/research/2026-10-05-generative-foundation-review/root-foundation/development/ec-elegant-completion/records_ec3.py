#!/usr/bin/env python3
"""EC3's records: declarations moved with their full names (to Becoming.InAmounts from Space, Premises, Openness and
LeastLoss; from InAmounts to LeastLoss), each cited under the module that now holds it with a proof binding to the core
receipt; the duplicate names World.rests_unrefuted_whole and World.rests_unrefuted_enclosed_whole replaced by the
theorems they restated, World.rests_unrefuted and World.rests_unrefuted_enclosed. A history note each.
python3 -B records_ec3.py CORE_RECEIPT STUDY_SECTION   (from the checkout root)"""
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
assert re.search(rf'^## {N}\. One rest theorem, below the worlds that use it \(EC3\)$', (ROOT / STUDY).read_text(), re.M)
elab = {m['module']: {d['name'] for d in m['declarations']} for m in core['modules']}
src = lambda m: f'{PKG}/Becoming/{m}.lean'
sha = lambda p: hashlib.sha256((ROOT / p).read_bytes()).hexdigest()
TO_IA = {'Space': ['World.Finite', 'World.RestsFrom', 'World.Balanced', 'World.Dissipative', 'World.Embodied',
                   'World.ArisingEmbodied', 'World.Embodied.arising', 'World.rests_unrefuted_iff',
                   'World.arising_unrefuted_covering', 'World.rests_unrefuted'],
         'Premises': ['World.Counted'], 'Openness': ['World.rests_unrefuted_enclosed'],
         'LeastLoss': ['Amounts.FallsStop', 'Amounts.NoEndlessFall', 'Amounts.EndlessFall', 'Amounts.FallsAtLeast',
                       'Amounts.fallsStop_congr', 'Amounts.noEndlessFall_of_fallsAtLeast', 'Amounts.whole_fallsAtLeast',
                       'Amounts.whole_noEndlessFall', 'Amounts.rising_apart', 'Amounts.from_start',
                       'Amounts.falls_within_reading', 'Amounts.extend_falls', 'Amounts.rests_unrefuted_of_finite_reading',
                       'Amounts.rests_of_finite_reading']}
MOVES = [(frm, 'InAmounts', ['Becoming.' + n for n in ns]) for frm, ns in TO_IA.items()]
MOVES.append(('InAmounts', 'LeastLoss', ['Becoming.Halving.worlds_need_not_rest', 'Becoming.Layered.worlds_need_not_rest']))
RENAMED = {'Becoming.World.rests_unrefuted_whole': 'Becoming.World.rests_unrefuted',
           'Becoming.World.rests_unrefuted_enclosed_whole': 'Becoming.World.rests_unrefuted_enclosed'}
for _, dst, ns in MOVES:
    for n in ns:
        assert n in elab[f'Becoming.{dst}'], (n, dst)
for n in RENAMED.values():
    assert n in elab['Becoming.InAmounts'], n


def ref_for(rec, mod):
    for r in rec['references']:
        if r['path'] == src(mod):
            return r
    r = {'path': src(mod), 'role': 'proof', 'sha256': sha(src(mod)), 'declarations': []}
    rec['references'].insert(0, r)
    if not any(b['source'] == src(mod) for b in rec['proof_bindings']):
        rec['proof_bindings'].append({'source': src(mod), 'receipt': RECEIPT,
                                      'sha256_pointer': f'/source_sha256/Becoming.{mod}',
                                      'success_pointer': '/status', 'success_value': 'passed'})
    if not any(x['path'] == RECEIPT for x in rec['references']):
        rec['references'].append({'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT), 'declarations': []})
    return r


def rename(names):
    out = []
    for n in names:
        n = RENAMED.get(n, n)
        if n not in out:
            out.append(n)
    return out


for f in sorted(RECORDS.glob('*.json')):
    rec = json.loads(f.read_text())
    moved, renamed = [], []
    for frm, dst, ns in MOVES:
        r = next((x for x in rec['references'] if x['path'] == src(frm)), None)
        if r is None or not r.get('declarations'):
            continue
        hit = [n for n in r['declarations'] if n in ns]
        if hit:
            r['declarations'] = [n for n in r['declarations'] if n not in hit]
            d = ref_for(rec, dst)
            d['declarations'] += [n for n in hit if n not in d['declarations']]
            moved.append((dst, hit))
    text = json.dumps(rec)
    if any(o in text for o in RENAMED):
        renamed = sorted(o for o in RENAMED if o in text)
        for r in rec['references']:
            if r.get('declarations'):
                r['declarations'] = rename(r['declarations'])
        for field in ('laws', 'does_not_show', 'counterexamples'):
            for item in rec.get(field) or []:
                if isinstance(item, dict) and item.get('declarations'):
                    item['declarations'] = rename(item['declarations'])
        rec['aliases'] = rename(rec.get('aliases', []))
        for o, nw in RENAMED.items():
            short_o, short_n = o.replace('Becoming.', ''), nw.replace('Becoming.', '')
            for field in ('laws', 'does_not_show', 'counterexamples'):
                for item in rec.get(field) or []:
                    if isinstance(item, dict):
                        for lang in ('en', 'zh'):
                            if isinstance(item.get(lang), str):
                                item[lang] = item[lang].replace(short_o, short_n)
        ia = ref_for(rec, 'InAmounts')
        ia['declarations'] = rename(ia['declarations'])
    if not (moved or renamed):
        continue
    parts = [f'{", ".join(n.replace("Becoming.", "") for n in hit)} to Becoming.{dst}' for dst, hit in moved]
    en = f'21 October 2026, EC3 (study section {N}): '
    zh = f'2026年10月21日，EC3（研究第 {N} 节）：'
    if parts:
        en += 'declarations moved with their full names: ' + '; '.join(parts) + '. '
        zh += '声明以完整名称移动：' + '；'.join(parts) + '。'
    if renamed:
        en += ('The duplicate names ' + ', '.join(o.replace('Becoming.', '') for o in renamed) +
               ', which stated World.rests_unrefuted and World.rests_unrefuted_enclosed a second time, are gone; the record '
               'cites those theorems, now proved in Becoming.InAmounts as the whole-number cases of the rest theorem over '
               'any amounts. ')
        zh += ('重复的名称 ' + '、'.join(o.replace('Becoming.', '') for o in renamed) +
               '（再次陈述 World.rests_unrefuted 与 World.rests_unrefuted_enclosed）已删去；本记录引用这两条定理，'
               '它们现于 Becoming.InAmounts 中作为任意量上停息定理的整数情形证明。')
    en += 'The cited Lean sources and their proof bindings follow them; the claim is unchanged.'
    zh += '所引 Lean 源及其证明绑定随之；论断不变。'
    rec['history'].append({'en': en, 'zh': zh})
    f.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
    print('record', rec['id'], moved and [(d, len(h)) for d, h in moved], renamed)
