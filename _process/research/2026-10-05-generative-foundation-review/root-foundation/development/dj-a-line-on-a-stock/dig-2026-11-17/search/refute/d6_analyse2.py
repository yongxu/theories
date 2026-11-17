#!/usr/bin/env python3
"""Second pass over d6_results.jsonl: the questions D6 turns on, with traces. AI-written,
17 Nov 2026. Integers only."""
import json, sys
from collections import Counter
import d6_model as m
from d6_analyse import load, cls, cost

PKEYS = ('Aarr','Barr','s','A0','hT','ch','b','kG','kT','mode','B0','oA','oB','timing')

def params(r):
    p = {k: r[k] for k in PKEYS}; p['mode'] = tuple(r['mode']); return p

def trace(r, n=12):
    eG, eT, rows = m.run(params(r), r['nG'], r['nT'], trace=True)
    print('      ', {k: r[k] for k in PKEYS}, 'start', (r['nG'], r['nT']), '-> G', eG, 'T', eT,
          '| G alone', r['aloneG'], 'T alone', r['aloneT'])
    print('       (step, nG, nT, A, B):', rows[:n])

def tab(title, rows, key=None):
    print(f'\n== {title}: {len(rows)} runs')
    if key is None:
        for k, v in sorted(Counter(cls(r) for r in rows).items()): print(f'   {k:26s} {v}')
    else:
        for k, v in sorted(Counter((key(r), cls(r)) for r in rows).items(), key=lambda kv: (str(kv[0][0]), kv[0][1])):
            print(f'   {str(k[0]):34s} {k[1]:24s} {v}')

def main(path):
    R = load(path)
    rival = [r for r in R if r['mode'][0] == 'rival']
    fair = lambda r: r['oA'] in ('prop', '-') and r['oB'] in ('prop', '-')
    eq = lambda r: r['nG'] == r['nT']

    # ---- (ii), no priority, equal starts
    ii = [r for r in rival if r['Barr'] == 'shared' and fair(r) and eq(r)]
    tab('(ii) rival, no priority anywhere, equal starts; by (kG,kT), cost, first condition', ii,
        lambda r: ((r['kG'], r['kT']), cost(r), r['Aarr']))
    zero = [r for r in ii if cost(r) == 'none']
    asym = [r for r in zero if r['endG'] != r['endT']]
    print('   no cost: runs where the two lines differ at all:', len(asym), 'of', len(zero))
    g_inf_t_end = [r for r in ii if r['endG'] == 'inf' and r['endT'] != 'inf']
    print('   G for ever and T ends:', len(g_inf_t_end))
    co = [r for r in ii if r['endG'] == 'inf' and r['endT'] == 'inf' and cost(r) != 'none']
    print('   both for ever with a cost to G:', len(co), sorted(Counter(((r['kG'], r['kT']), cost(r), r['Aarr']) for r in co).items()))
    for r in co[:2]: trace(r)
    co2 = [r for r in ii if r['endG'] == 'inf' and r['endT'] == 'inf' and r['kT'] == 2]
    print('   both for ever with kT = 2 (T multiplies):', len(co2), sorted(Counter(((r['kG'], r['kT']), cost(r), r['Aarr']) for r in co2).items()))
    for r in co2[:3]: trace(r, 16)
    late = [r for r in ii if r['endG'] != 'inf' and r['endT'] != 'inf' and r['endG'] > r['endT']]
    print('   both end and G ends later than T:', len(late))
    for r in late[:2]: trace(r)

    # ---- (ii) with priority: which priority makes giving favoured
    iip = [r for r in rival if r['Barr'] == 'shared' and eq(r) and r['kT'] == 2]
    tab('(ii) rival, equal starts, kT = 2, by (first condition, who is served first from A, from B)', iip,
        lambda r: (r['Aarr'], r['oA'], r['oB']))
    gb = [r for r in iip if r['oB'] == 'G' and r['oA'] in ('prop', '-', 'T') and r['endG'] == 'inf' and r['endT'] != 'inf' and cost(r) != 'none']
    print('   G for ever and T ends, G served first from B only (not from A), with a cost:', len(gb))
    for r in gb[:2]: trace(r)
    ga = [r for r in iip if r['oA'] == 'G' and r['oB'] in ('prop', 'T') and r['endG'] == 'inf' and r['endT'] != 'inf' and cost(r) != 'none']
    print('   G for ever and T ends, G served first from A only, with a cost:', len(ga))
    for r in ga[:2]: trace(r)
    odd = [r for r in iip if r['oB'] == 'T' and r['oA'] in ('prop', '-', 'T') and r['endG'] == 'inf' and r['endT'] != 'inf']
    print('   G for ever and T ends although T is served first from B and G has no priority on A:', len(odd),
          sorted(Counter((r['Aarr'], r['oA'], (r['kG'], r['kT']), cost(r), r['s'], r['hT']) for r in odd).items())[:12])
    for r in odd[:3]: trace(r, 14)

    # ---- (i): both multiply
    i_ = [r for r in rival if r['Barr'] == 'own' and eq(r)]
    tab('(i) rival, equal starts, by ((kG,kT), first condition, who is served first from A)', i_,
        lambda r: ((r['kG'], r['kT']), r['Aarr'], r['oA']))
    st = [r for r in i_ if r['aloneG'] == 'inf' and r['endG'] != 'inf' and r['kG'] == 2 and r['kT'] == 2]
    print('   kG = kT = 2: G alone for ever, with T present G ends:', len(st), sorted(Counter((r['oA'], cost(r)) for r in st).items()))
    for r in [x for x in st if x['oA'] == 'prop'][:2] + [x for x in st if x['oA'] == 'T'][:1]: trace(r, 14)
    # premises under which G goes on in (i): tabulate G alone
    al = Counter()
    for r in i_:
        hG = r['hT'] + r['ch']
        al[(r['aloneG'] == 'inf', 's>=hG' if r['s'] >= hG else 's<hG', 'b>=r' if r['b'] >= r['mode'][1] else 'b<r',
            'B0>0 or before' if (r['B0'] >= r['mode'][1] or r['timing'] == 'before') else 'B0<r and after')] += 1
    print('   G alone for ever?, by (s >= hG, b >= r, first offspring possible):')
    for k, v in sorted(al.items()): print('     ', k, v)
    # G inf in (i) with T present: does it need more
    gi = Counter()
    for r in i_:
        if r['aloneG'] == 'inf':
            gi[(r['Aarr'], r['oA'], r['endG'] == 'inf')] += 1
    print('   given G alone goes on: with T present, G goes on? by (first condition, order):')
    for k, v in sorted(gi.items()): print('     ', k, v)
    # how long T lasts in (i)
    tl = Counter()
    for r in i_:
        tl[(r['B0'], r['mode'][1], r['endT'])] += 1
    print('   (i) T ends at step, by (B0, r):', sorted(tl.items()))

    # ---- threshold (a)
    thr = [r for r in R if r['mode'][0] == 'thr' and r['Barr'] == 'own' and eq(r) and r['Aarr'] == 'own']
    tab('(i) threshold, own first conditions (lines decoupled), equal starts, by (B0, cost)', thr, lambda r: (r['B0'], cost(r)))
    a = [r for r in thr if r['endT'] == 'inf' and r['endG'] != 'inf']
    for r in a[:2]: trace(r)

    # ---- pooling rescues G
    def key(r): return tuple(r[k] if k != 'mode' else tuple(r[k]) for k in ('Aarr','s','A0','hT','ch','b','kG','kT','mode','B0','oA','timing','nG','nT'))
    I = {key(r): r for r in rival if r['Barr'] == 'own'}
    resc = [(I[key(r)], r) for r in rival if r['Barr'] == 'shared' and key(r) in I and I[key(r)]['endG'] != 'inf' and r['endG'] == 'inf']
    print('\n== pooling: G ends in (i) and goes on for ever in (ii):', len(resc),
          sorted(Counter((b['oB'], a['aloneG'] == 'inf', b['aloneG'] == 'inf', a['B0']) for a, b in resc).items()))
    for a, b in resc[:2]:
        trace(a); trace(b)

if __name__ == '__main__':
    main(sys.argv[1] if len(sys.argv) > 1 else 'd6_results.jsonl')
