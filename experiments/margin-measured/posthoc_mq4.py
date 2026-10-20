"""MQ4 post hoc (not verdicts): where the state of level and recent giving gains and where it does not.

  python3 -I posthoc_mq4.py XLSX     writes results/mq4/posthoc-mq4.json

Written after the frozen test's verdicts (results/mq4/VERDICTS-mq4.json) were read. Nothing here changes a verdict.
On the same test stocks, split and origins:

  H1 discordance: where LG and the frozen rest call the direction over k years differently, which is right, and how
     far each forecast's change is from the observed change.
  H2 what G3 needs: the excess reduction of adding SP_{t-2} alone, and of adding E_{t-1}, E_{t-1}^2 alone, to
     (E_t, E_t^2, SP_{t-1}) (q / (n - p) chance level as in G1-G3).
  H3 the draw responds: per stock, the slope of next year's log change in catch, log C_{t+1} - log C_t, on the last
     log change in biomass, log TB_t - log TB_{t-1}; the share of positive slopes and a sign test.
  H4 the catch after a predicted break: in T's class n <= 5, the mean catch of the next five years over C_{t0}, for
     origins that broke and that did not.
  H5 PHI on the test stocks: the PHI with the least pooled median |log error| at five years over the primary test
     stocks, and LG's scores there (a fit to the test data, so not a test).
"""
from __future__ import annotations

import json
import math
import os
import statistics
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import mq3  # noqa: E402
import mq4  # noqa: E402


def h1(stocks, k):
    n = disc = fr_right = lg_right = 0
    gap = {'LG': [], 'FR': []}
    for st in stocks:
        tb = st['tb']
        for t0 in mq4.origins(st, k):
            pl, pf = mq4.project(st, t0, k, 'LG'), mq4.project(st, t0, k, 'FR')
            obs = tb[t0 + k] > tb[t0]
            n += 1
            if (pl > tb[t0]) != (pf > tb[t0]):
                disc += 1
                fr_right += (pf > tb[t0]) == obs
                lg_right += (pl > tb[t0]) == obs
                f = mq3.FLOOR * st['scale']
                gap['LG'].append(abs(math.log(max(pl, f) / tb[t0 + k])))
                gap['FR'].append(abs(math.log(max(pf, f) / tb[t0 + k])))
    return {'origins': n, 'discordant': disc, 'FR_right': fr_right, 'LG_right': lg_right,
            'discordant_median_abs_log_error': {m: statistics.median(v) if v else None for m, v in gap.items()}}


def h2(stocks):
    sp2, el = [], []
    for st in stocks:
        tb, sc = st['tb'], st['scale']
        ys = [y for y in st['sp_years'] if all((y - j) in tb and (y - j) not in st['bad'] for j in (0, 1, 2))]
        if len(ys) < 20:
            continue
        e = [mq4.E(st, y) / sc for y in ys]
        e2 = [x * x for x in e]
        e1 = [mq4.E(st, y - 1) / sc for y in ys]
        e12 = [x * x for x in e1]
        s = [mq3.sp(st, y) / sc for y in ys]
        s1 = [mq3.sp(st, y - 1) / sc for y in ys]
        s2 = [mq3.sp(st, y - 2) / sc for y in ys]
        a = mq4.excess(s, [e, e2, s1], [s2])
        b = mq4.excess(s, [e, e2, s1], [e1, e12])
        if a is not None and b is not None:
            sp2.append(a)
            el.append(b)
    return {'stocks': len(sp2), 'median_excess_SP_t-2': statistics.median(sp2) if sp2 else None,
            'median_excess_E_t-1': statistics.median(el) if el else None}


def h3(stocks):
    slopes = []
    for st in stocks:
        tb, c = st['tb'], st['c']
        xs, ys = [], []
        for t in st['run']:
            if all(v in tb for v in (t - 1, t, t + 1)) and min(c[t], c[t + 1]) > 0:
                xs.append(math.log(tb[t] / tb[t - 1]))
                ys.append(math.log(c[t + 1] / c[t]))
        if len(xs) < 15:
            continue
        mx, my = sum(xs) / len(xs), sum(ys) / len(ys)
        den = sum((x - mx) ** 2 for x in xs)
        if den > 0:
            slopes.append(sum((x - mx) * (y - my) for x, y in zip(xs, ys)) / den)
    n = len(slopes)
    pos = sum(s > 0 for s in slopes)
    return {'stocks': n, 'positive_slopes': pos, 'median_slope': statistics.median(slopes) if slopes else None,
            'p_two_sided': mq3.binom_two_sided(pos, n) if n else None}


def h4(stocks):
    ratios = {True: [], False: []}
    for st in stocks:
        tb, c = st['tb'], st['c']
        for t0 in st['test']:
            if (t0 - 1) not in tb or (t0 - 1) in st['bad'] or t0 in st['bad']:
                continue
            obs = mq4.break_within(st, t0)
            if obs == 'censored':
                continue
            d = c[t0] - mq3.sp(st, t0 - 1)
            if d <= 0 or (1 - mq4.HALF) * tb[t0] / d > 5:
                continue
            nxt = [c[t0 + j] for j in range(1, 6) if (t0 + j) in c]
            if len(nxt) == 5 and c[t0] > 0:
                ratios[obs is not None].append(sum(nxt) / 5 / c[t0])
    return {k_: {'origins': len(v), 'median_catch_ratio_next5': statistics.median(v) if v else None}
            for k_, v in (('broke', ratios[True]), ('did_not_break', ratios[False]))}


def h5(stocks):
    scan = []
    for phi in mq4.PHI_GRID:
        r = mq4.forecast_scores(stocks, 5, phi)
        scan.append({'phi': phi, 'accuracy_LG': r['accuracy']['LG'], 'median_abs_log_error_LG': r['median_abs_log_error']['LG']})
    best = min(scan, key=lambda x: x['median_abs_log_error_LG'])
    return {'best_phi': best['phi'], 'best': best, 'scan': scan}


def main(xlsx):
    sel = mq4.selection(xlsx)
    groups, _ = mq4.load_from(xlsx, set(sel['chosen'].values()), sel['A'])
    out = {'scope': 'post hoc, after the frozen verdicts; not verdicts'}
    for g in ('primary', 'control', 'other'):
        stocks = groups.get(g, [])
        out[g] = {'H1_k5': h1(stocks, 5), 'H1_k10': h1(stocks, 10), 'H2': h2(stocks), 'H3': h3(stocks), 'H4': h4(stocks)}
    out['primary']['H5'] = h5(groups['primary'])
    with open(os.path.join(mq4.OUT, 'posthoc-mq4.json'), 'w') as f:
        json.dump(out, f, indent=1)
    for g in ('primary', 'control', 'other'):
        print(g, json.dumps({k: v for k, v in out[g].items() if k != 'H5'}))
    print('H5', json.dumps({k: v for k, v in out['primary']['H5'].items() if k != 'scan'}))


if __name__ == '__main__':
    main(sys.argv[1])
