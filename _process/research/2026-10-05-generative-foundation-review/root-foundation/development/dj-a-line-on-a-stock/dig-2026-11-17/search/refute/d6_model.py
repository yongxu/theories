#!/usr/bin/env python3
"""D6 refuter: the smallest balanced model I could build. AI-written (Claude Fable 5.2),
17 November 2026. Integers only, no floats, no randomness.

THE MODEL (working names only)
  Two kinds of unit, G (gives) and T (does not).  Counts nG, nT.
  First condition(s) A: every unit takes from it.  Aarr = 'shared' (one A for both lines) or
      'own' (A_G, A_T).  One named source gives s to each first condition per step; nothing else
      gives to a first condition.
  Second condition(s) B: required for offspring.  Barr = 'own' (arrangement (i): B_G, B_T) or
      'shared' (arrangement (ii): one B).  Nothing gives to a second condition but G units.
  One step:
    1. the source gives s to each first condition;
    2. each unit of kind X asks hX of its first condition (hG = hT + ch).  A unit that gets it is
       met; one that does not takes nothing, gives nothing and leaves nothing.  Where the first
       condition is shared and short: orderA = 'G' (G served first), 'T', or 'prop'
       (metX = floor(nX * avail / demand), the remainder stays in A);
    3. each met G unit gives b (b <= hG, part of what it took) to its second condition;
       timing = 'before' (there for this step's offspring) or 'after' (lands at the end);
    4. each met unit of kind X asks for kX offspring.  mode 'rival r': each offspring takes r from
       the unit's second condition; mode 'thr m': offspring are left iff that condition stands at
       m or more, and nothing is taken from it.  Where B is shared and short: orderB as orderA;
    5. the next way is the offspring (a unit with one offspring is a unit that stays).
  Every level is a whole number changed only by these takes and gives; the script asserts
  next + taken = level + given for every condition at every step (Flow.Balances, Flow.lean:278).

VERDICTS, each exact
  'end t'  the line's count is 0 at step t (a line with no unit has none after).
  'inf'    proved to go on for ever: the state after some step equals an earlier state in its
           counts, and in each level either equals it or is higher while that level was not binding
           at any step between (every unit asking of it was served).  Then the stretch repeats.
  '?'      neither within the horizon; counted and listed, never read as 'inf'.
"""
import sys, json
from itertools import product

HORIZON = 400
LOOKBACK = 24

def alloc(order, wantG, wantT, costG, costT, avail):
    """Units served from one level `avail`; returns (gotG, gotT)."""
    demand = wantG * costG + wantT * costT
    if demand <= avail:
        return wantG, wantT
    if order == 'G':
        g = min(wantG, avail // costG) if costG else wantG
        t = min(wantT, (avail - g * costG) // costT) if costT else wantT
        return g, t
    if order == 'T':
        t = min(wantT, avail // costT) if costT else wantT
        g = min(wantG, (avail - t * costT) // costG) if costG else wantG
        return g, t
    # prop
    return (wantG * avail) // demand, (wantT * avail) // demand

def run(p, nG, nT, horizon=HORIZON, trace=False):
    Aarr, Barr = p['Aarr'], p['Barr']
    s, hT, hG, b = p['s'], p['hT'], p['hT'] + p['ch'], p['b']
    kG, kT = p['kG'], p['kT']
    mode, q = p['mode']            # ('rival', r) or ('thr', m)
    oA, oB, timing = p['oA'], p['oB'], p['timing']
    A = [p['A0']] if Aarr == 'shared' else [p['A0'], p['A0']]
    B = [p['B0']] if Barr == 'shared' else [p['B0'], p['B0']]
    endG = 0 if nG == 0 else None
    endT = 0 if nT == 0 else None
    hist = []          # (counts, levels, slack flags per level) before each step
    rows = []
    for t in range(horizon):
        if trace: rows.append((t, nG, nT, tuple(A), tuple(B)))
        if nG == 0 and endG is None: endG = t
        if nT == 0 and endT is None: endT = t
        if nG == 0 and nT == 0:
            break
        levels0 = tuple(A) + tuple(B)
        # 1-2 feeding
        if Aarr == 'shared':
            av = A[0] + s
            mG, mT = alloc(oA, nG, nT, hG, hT, av)
            takenA = [mG * hG + mT * hT]; givenA = [s]
            slackA = [mG == nG and mT == nT]
        else:
            mG = min(nG, (A[0] + s) // hG); mT = min(nT, (A[1] + s) // hT)
            takenA = [mG * hG, mT * hT]; givenA = [s, s]
            slackA = [mG == nG, mT == nT]
        # 3 giving
        gift = mG * b
        # 4 offspring
        wG, wT = mG * kG, mT * kT
        if Barr == 'shared':
            avB = B[0] + (gift if timing == 'before' else 0)
            if mode == 'rival':
                oGn, oTn = alloc(oB, wG, wT, q, q, avB)
                takenB = [(oGn + oTn) * q]
            else:
                ok = avB >= q
                oGn, oTn = (wG, wT) if ok else (0, 0)
                takenB = [0]
            givenB = [gift]
            slackB = [oGn == wG and oTn == wT]
        else:
            avG = B[0] + (gift if timing == 'before' else 0)
            avT = B[1]
            if mode == 'rival':
                oGn = min(wG, avG // q); oTn = min(wT, avT // q)
                takenB = [oGn * q, oTn * q]
            else:
                oGn = wG if avG >= q else 0
                oTn = wT if avT >= q else 0
                takenB = [0, 0]
            givenB = [gift, 0]
            slackB = [oGn == wG, oTn == wT]
        # balance, asserted
        newA = [A[i] + givenA[i] - takenA[i] for i in range(len(A))]
        newB = [B[i] + givenB[i] - takenB[i] for i in range(len(B))]
        assert all(x >= 0 for x in newA + newB)
        for i in range(len(A)): assert newA[i] + takenA[i] == A[i] + givenA[i]
        for i in range(len(B)): assert newB[i] + takenB[i] == B[i] + givenB[i]
        hist.append(((nG, nT), levels0, tuple(slackA + slackB)))
        A, B, nG, nT = newA, newB, oGn, oTn
        # proof of going on for ever
        if nG or nT:
            now_levels = tuple(A) + tuple(B)
            nlev = len(now_levels)
            slack_run = [True] * nlev
            for back in range(1, min(LOOKBACK, len(hist)) + 1):
                counts, lv, sl = hist[-back]
                slack_run = [slack_run[i] and sl[i] for i in range(nlev)]
                if counts == (nG, nT) and all(
                        now_levels[i] == lv[i] or (now_levels[i] > lv[i] and slack_run[i])
                        for i in range(nlev)):
                    if nG and endG is None: endG = 'inf'
                    if nT and endT is None: endT = 'inf'
                    if trace: rows.append((t + 1, nG, nT, tuple(A), tuple(B), 'repeats', back))
                    return endG, endT, rows
    else:
        if endG is None: endG = '?' if nG else horizon
        if endT is None: endT = '?' if nT else horizon
    return endG, endT, rows

def grid():
    for Aarr, Barr in product(('shared', 'own'), ('own', 'shared')):
        oAs = ('G', 'T', 'prop') if Aarr == 'shared' else ('-',)
        oBs = ('G', 'T', 'prop') if Barr == 'shared' else ('-',)
        for s, A0, hT, ch, b, (kG, kT), mode, B0, oA, oB, timing in product(
                (1, 2, 3, 4), (0, 6), (1, 2), (0, 1), (1, 2),
                ((1, 1), (1, 2), (2, 2)),
                (('rival', 1), ('rival', 2), ('thr', 1)),
                (0, 2, 8), oAs, oBs, ('before', 'after')):
            if b > hT + ch:
                continue
            yield dict(Aarr=Aarr, Barr=Barr, s=s, A0=A0, hT=hT, ch=ch, b=b, kG=kG, kT=kT,
                       mode=mode, B0=B0, oA=oA, oB=oB, timing=timing)

STARTS = ((1, 1), (2, 2), (1, 3), (3, 1))

def main(out):
    n = 0
    with open(out, 'w') as f:
        for p in grid():
            alone_G = run(p, 2, 0)[0]
            alone_T = run(p, 0, 2)[1]
            for nG, nT in STARTS:
                eG, eT, _ = run(p, nG, nT)
                rec = dict(p); rec['mode'] = list(p['mode'])
                rec.update(nG=nG, nT=nT, endG=eG, endT=eT, aloneG=alone_G, aloneT=alone_T)
                f.write(json.dumps(rec) + '\n'); n += 1
    print('runs', n)

if __name__ == '__main__':
    main(sys.argv[1] if len(sys.argv) > 1 else 'd6_results.jsonl')
