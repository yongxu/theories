#!/usr/bin/env python3
"""Reads d6_results.jsonl (written by d6_model.py) and counts outcomes. AI-written, 17 Nov 2026.
Integers only."""
import json, sys
from collections import Counter

def load(path):
    with open(path) as f:
        return [json.loads(l) for l in f]

def cls(r):
    g, t = r['endG'], r['endT']
    def k(x): return 'inf' if x == 'inf' else ('?' if x == '?' else 'end')
    a, b = k(g), k(t)
    if a == 'end' and b == 'end':
        return 'both end, G first' if g < t else ('both end, T first' if t < g else 'both end, same step')
    return f'G {a}, T {b}'

def cost(r):
    return ('k' if r['kG'] < r['kT'] else '') + ('h' if r['ch'] else '') or 'none'

def show(title, rows, keys=()):
    print(f'\n== {title}: {len(rows)} runs')
    c = Counter(cls(r) for r in rows)
    for k, v in sorted(c.items()): print(f'   {k:26s} {v}')
    for key in keys:
        print(f'   -- by {key}')
        cc = Counter(((r[key] if isinstance(key, str) else key(r)), cls(r)) for r in rows)
        for k, v in sorted(cc.items(), key=lambda kv: (str(kv[0][0]), kv[0][1])): print(f'      {str(k[0]):10s} {k[1]:26s} {v}')

def ex(rows, n=3):
    for r in rows[:n]:
        print('      e.g.', {k: r[k] for k in ('Aarr','Barr','s','A0','hT','ch','b','kG','kT','mode','B0','oA','oB','timing','nG','nT','endG','endT','aloneG','aloneT')})

def main(path):
    R = load(path)
    print('runs', len(R), ' undecided:', sum(1 for r in R if '?' in (r['endG'], r['endT'])))
    rival = [r for r in R if r['mode'][0] == 'rival']
    thr = [r for r in R if r['mode'][0] == 'thr']

    # ---------- arrangement (i): each line its own second condition
    i_r = [r for r in rival if r['Barr'] == 'own']
    show('(i) own second conditions, offspring TAKE from it (rival)', i_r, ('Aarr',))
    t_inf = [r for r in i_r if r['endT'] in ('inf', '?')]
    print('   (a) T goes on for ever or undecided:', len(t_inf)); ex(t_inf)
    g_inf = [r for r in i_r if r['endG'] == 'inf']
    g_end = [r for r in i_r if r['endG'] != 'inf']
    print('   G goes on for ever:', len(g_inf), ' G ends:', len(g_end))
    # why G ends: alone it would also end, or only with T present
    by_T = [r for r in g_end if r['aloneG'] == 'inf']
    print('   G ends although G alone (2 units, same parameters) goes on for ever:', len(by_T))
    print('      of these by Aarr/oA:', sorted(Counter((r['Aarr'], r['oA']) for r in by_T).items()))
    ex(by_T, 4)
    alone_end = [r for r in g_end if r['aloneG'] != 'inf']
    print('   G ends and G alone ends too:', len(alone_end), ' by (b>=r*kG?, b, r, kG):',
          sorted(Counter((r['b'] >= r['mode'][1] * r['kG'], r['b'], r['mode'][1], r['kG']) for r in alone_end).items()))
    print('   G alone for ever, by (b, r):', sorted(Counter((r['b'], r['mode'][1], r['aloneG'] == 'inf') for r in i_r).items()))
    g_before_t = [r for r in i_r if r['endG'] != 'inf' and r['endT'] != 'inf' and r['endG'] <= r['endT']]
    print('   G ends no later than T:', len(g_before_t), 'by Aarr/oA:', sorted(Counter((r['Aarr'], r['oA']) for r in g_before_t).items()))
    own_own = [r for r in i_r if r['Aarr'] == 'own']
    dep = [r for r in own_own if (r['endG'] == 'inf') != (r['aloneG'] == 'inf')]
    print('   own A and own B: runs where G\'s verdict differs from G alone:', len(dep), '(lines decoupled if 0)')

    i_t = [r for r in thr if r['Barr'] == 'own']
    show('(i) own second conditions, offspring only REQUIRE a standing (threshold m=1, nothing taken)', i_t, ('B0',))
    t_better = [r for r in i_t if r['endT'] == 'inf' and r['endG'] != 'inf']
    print('   (a) T for ever while G ends:', len(t_better), 'by Aarr/oA/cost:', sorted(Counter((r['Aarr'], r['oA'], cost(r)) for r in t_better).items())); ex(t_better)
    t_ok = [r for r in i_t if r['endT'] == 'inf']
    print('   (a) T for ever (at least as long as G):', len(t_ok), 'of', len(i_t), ' by B0:', sorted(Counter(r['B0'] for r in t_ok).items()))

    # ---------- arrangement (ii): one shared second condition
    ii_r = [r for r in rival if r['Barr'] == 'shared']
    show('(ii) one shared second condition, rival', ii_r, ('Aarr', 'oB', 'timing', cost))
    fav = [r for r in ii_r if (r['endG'] == 'inf' and r['endT'] != 'inf') or
           (r['endG'] != 'inf' and r['endT'] != 'inf' and r['endG'] > r['endT'])]
    print('   (b) G outlasts T (G for ever and T ends, or G ends later):', len(fav))
    print('      by (Aarr, oA, oB, timing):')
    for k, v in sorted(Counter((r['Aarr'], r['oA'], r['oB'], r['timing']) for r in fav).items()): print('        ', k, v)
    print('      by start (nG, nT):', sorted(Counter((r['nG'], r['nT']) for r in fav).items()))
    print('      by cost:', sorted(Counter(cost(r) for r in fav).items()))
    noprio = [r for r in fav if r['oA'] in ('prop', '-') and r['oB'] == 'prop']
    print('   (b) with no priority anywhere (oA prop or own A, oB prop):', len(noprio))
    print('      by (Aarr, timing, start, cost):')
    for k, v in sorted(Counter((r['Aarr'], r['timing'], (r['nG'], r['nT']), cost(r)) for r in noprio).items()): print('        ', k, v)
    eq = [r for r in noprio if r['nG'] == r['nT']]
    print('   (b) no priority and equal starts:', len(eq)); ex(eq, 6)
    eqc = [r for r in eq if cost(r) != 'none']
    print('   (b) no priority, equal starts, and a cost to G:', len(eqc)); ex(eqc, 6)
    both_inf = [r for r in ii_r if r['endG'] == 'inf' and r['endT'] == 'inf']
    print('   both go on for ever (nothing falls):', len(both_inf))
    print('      by (Aarr, oA, oB, cost):')
    for k, v in sorted(Counter((r['Aarr'], r['oA'], r['oB'], cost(r)) for r in both_inf).items()): print('        ', k, v)
    ex([r for r in both_inf if cost(r) != 'none'], 4)
    t_out = [r for r in ii_r if r['endT'] == 'inf' and r['endG'] != 'inf']
    print('   T for ever while G ends (must be 0: nobody gives to B once G is gone):', len(t_out)); ex(t_out)
    t_last = [r for r in ii_r if r['endG'] != 'inf' and r['endT'] != 'inf' and r['endT'] > r['endG']]
    print('   G ends first and T ends after it:', len(t_last), ' gaps:', sorted(Counter(r['endT'] - r['endG'] for r in t_last).items())[:12])
    alone_t = Counter(r['aloneT'] == 'inf' for r in ii_r)
    print('   T alone for ever?', dict(alone_t))

    ii_t = [r for r in thr if r['Barr'] == 'shared']
    show('(ii) one shared second condition, threshold', ii_t, ('B0', cost))

    # ---------- pooling: the same parameters in (i) and in (ii)
    def key(r): return tuple(r[k] if k != 'mode' else tuple(r[k]) for k in ('Aarr','s','A0','hT','ch','b','kG','kT','mode','B0','oA','timing','nG','nT'))
    I = {}
    for r in i_r: I[key(r)] = r
    moves = Counter()
    for r in ii_r:
        a = I.get(key(r))
        if a is None: continue
        moves[(r['oB'], 'G: ' + ('inf' if a['endG'] == 'inf' else 'end') + ' -> ' + ('inf' if r['endG'] == 'inf' else 'end'),
               'T: ' + ('inf' if a['endT'] == 'inf' else 'end') + ' -> ' + ('inf' if r['endT'] == 'inf' else 'end'))] += 1
    print('\n== pooling the two second conditions into one (same parameters, (i) -> (ii)), rival')
    for k, v in sorted(moves.items()): print('   ', k, v)

if __name__ == '__main__':
    main(sys.argv[1] if len(sys.argv) > 1 else 'd6_results.jsonl')
