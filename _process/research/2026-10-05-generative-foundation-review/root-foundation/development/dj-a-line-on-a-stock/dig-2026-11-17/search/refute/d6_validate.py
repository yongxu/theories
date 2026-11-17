#!/usr/bin/env python3
"""Checks on d6_results.jsonl. AI-written, 17 Nov 2026. Integers only.
1. Every 'inf' verdict sampled (every 53rd) is rerun for 3000 steps with the repeat proof switched
   off: the line must still have units at the end.
2. (ii) rival, no priority, unequal starts: who outlasts whom (the more numerous line or the giver).
"""
import json
from collections import Counter
import d6_model as m
from d6_analyse import load, cls, cost
from d6_analyse2 import params, trace

R = load('d6_results.jsonl')
inf = [r for r in R if 'inf' in (r['endG'], r['endT'])]
m.LOOKBACK = 0
bad = 0; n = 0
for r in inf[::53]:
    eG, eT, _ = m.run(params(r), r['nG'], r['nT'], horizon=3000)
    n += 1
    if (r['endG'] == 'inf') != (eG == '?') or (r['endT'] == 'inf') != (eT == '?'):
        bad += 1; print('MISMATCH', r, eG, eT)
    if r['endG'] != 'inf' and eG != r['endG']: bad += 1; print('END MISMATCH G', r, eG)
    if r['endT'] != 'inf' and eT != r['endT']: bad += 1; print('END MISMATCH T', r, eT)
print(f"'inf' verdicts rerun for 3000 steps without the proof: {n} sampled of {len(inf)}, mismatches {bad}")
m.LOOKBACK = 24

rival = [r for r in R if r['mode'][0] == 'rival' and r['Barr'] == 'shared' and r['oA'] in ('prop', '-') and r['oB'] == 'prop']
def out(r):
    g, t = r['endG'], r['endT']
    if g == 'inf' and t == 'inf': return 'both for ever'
    if g == 'inf': return 'G outlasts'
    if t == 'inf': return 'T outlasts'
    return 'G outlasts' if g > t else ('T outlasts' if t > g else 'same step')
c = Counter(((r['nG'], r['nT']), cost(r) != 'none', out(r)) for r in rival)
print('(ii) rival, no priority: (start, G has a cost, outcome)')
for k, v in sorted(c.items()): print('  ', k, v)
few = [r for r in rival if (r['nG'], r['nT']) == (1, 3) and out(r) == 'G outlasts']
print('G outlasts T from (1,3):', len(few), Counter((r['Aarr'], r['endG'] == 'inf') for r in few))
for r in few[:2]: trace(r, 10)
many = [r for r in rival if (r['nG'], r['nT']) == (3, 1) and r['endG'] == 'inf' and r['endT'] != 'inf' and r['kG'] < r['kT']]
print('G for ever, T ends, from (3,1), with a cost in offspring:', len(many))
for r in many[:2]: trace(r, 10)
