"""MQ5 post hoc (not verdicts): analyses chosen after the frozen test had been run on the stocks no analysis had read.

  python3 -I posthoc_mq5.py XLSX     writes results/mq5/posthoc-mq5.json

  draw           why D1 failed while MQ4's form of it holds: per stock, the change in log catch on the change in log
                 level without the catch's own last level, with it (D1), and the coefficient on that last level (the
                 catch reverting to its own mean); and next year's change on this year's change (MQ4's form)
  eps            the draw's elasticity measured on the test stocks as the frozen EPS was measured on the development
                 stocks, D2's share at other elasticities, and D2's share and D1 on the stocks whose fitted share
                 of the catch on the spawning stock exceeds 0.1 (where it is near 0 the catch hardly enters the
                 forecast: the SSB reading's limit in the dry runs)
  lam            the lag's weight that fits the test stocks best at five years, as the frozen LAM was chosen
  damping        the lag against a net change that decays with no level and no lag (dev_mq5's NC), at 5 and 10 years
  coefficients   per stock, in sample, the giving on E_t, SP_{t-1} and E_{t-1} without squares
Each on the primary group, with the other group reported.
"""
from __future__ import annotations

import json
import math
import os
import statistics
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import dev_mq5  # noqa: E402
import mq3  # noqa: E402
import mq5  # noqa: E402


def draw(stocks):
    full, plain, own, lagged = [], [], [], []
    for st in stocks:
        b, c = st['b'], st['c']
        xs, zs, ys, xl, yl = [], [], [], [], []
        for t in st['run']:
            if (t - 1) in b and min(c[t], c[t - 1]) > 0:
                xs.append(math.log(b[t] / b[t - 1]))
                zs.append(math.log(c[t - 1]))
                ys.append(math.log(c[t] / c[t - 1]))
            if all(v in b for v in (t - 1, t, t + 1)) and min(c[t], c[t + 1]) > 0:
                xl.append(math.log(b[t] / b[t - 1]))
                yl.append(math.log(c[t + 1] / c[t]))
        if len(xs) < 15:
            continue
        co = mq5.ols_coef(ys, [xs, zs, [1.0] * len(xs)])
        cp = mq5.ols_coef(ys, [xs, [1.0] * len(xs)])
        cl = mq5.ols_coef(yl, [xl, [1.0] * len(xl)])
        if co is None or cp is None or cl is None:
            continue
        full.append(co[0])
        own.append(co[1])
        plain.append(cp[0])
        lagged.append(cl[0])

    def summ(v):
        pos = sum(x > 0 for x in v)
        return {'stocks': len(v), 'positive': pos, 'median': statistics.median(v), 'quartiles': mq3.quartiles(v),
                'p_two_sided': mq3.binom_two_sided(pos, len(v))}
    return {'D1_slope_controlled': summ(full), 'own_last_level_coefficient': summ(own),
            'slope_uncontrolled_same_year': summ(plain), 'next_year_on_this_year_MQ4_form': summ(lagged)}


def eps_part(stocks):
    e, n = mq5.draw_elasticity(stocks)
    out = {'eps_measured': e, 'pairs': n, 'D2_share_by_eps': {}}
    for eps in (0.35, 0.7, 1.0, 1.5, 2.0):
        r = mq5.scores(stocks, 10, ['CLLG', 'CLLG0'], eps=eps)
        out['D2_share_by_eps'][str(eps)] = mq5.gap_share(r['median_abs_log_error'], 'CLLG0', 'CLLG')
    big = [st for st in stocks if st['kappa'] > 0.1]
    r = mq5.scores(big, 10, ['CLLG', 'CLLG0'])
    d1 = mq5.draw_follows(big)
    out['kappa_above_0.1'] = {'stocks': len(big), 'origins_k10': r['origins'],
                              'D2_share': mq5.gap_share(r['median_abs_log_error'], 'CLLG0', 'CLLG'),
                              'median_abs_log_error_k10': r['median_abs_log_error'],
                              'D1_positive': d1['positive_slopes'], 'D1_stocks': d1['stocks'],
                              'D1_p_two_sided': d1['p_two_sided']}
    return out


def lam_part(stocks):
    scan = []
    for lam in mq5.LAM_GRID:
        r = mq5.scores(stocks, 5, ['LGD'], lam=lam)
        scan.append({'lam': lam, 'median_abs_log_error_LGD': r['median_abs_log_error']['LGD'],
                     'RW': r['median_abs_log_error']['RW']})
    best = min(scan, key=lambda x: x['median_abs_log_error_LGD'])
    return {'best': best['lam'], 'scan': scan}


def damping(stocks):
    out = {}
    for k in (5, 10):
        e = {'LGD': [], 'NC0.3': [], 'NC0.5': [], 'RW': []}
        per = []
        for st in stocks:
            fl = mq3.FLOOR * st['scale']
            le = {m: [] for m in e}
            for t0 in mq5.origins(st, k):
                obs = st['b'][t0 + k]
                p = {'LGD': mq5.forecast(st, t0, k, 'LGD'), 'NC0.3': dev_mq5.nc(st, t0, k, 0.3),
                     'NC0.5': dev_mq5.nc(st, t0, k, 0.5), 'RW': st['b'][t0]}
                for m in e:
                    x = abs(math.log(max(p[m], fl) / obs))
                    e[m].append(x)
                    le[m].append(x)
            if le['RW']:
                per.append({m: sum(v) / len(v) for m, v in le.items()})
        out[f'k{k}'] = {'median_abs_log_error': {m: statistics.median(v) for m, v in e.items()},
                        'LGD<NC0.3': mq5.sign(per, 'LGD', 'NC0.3'), 'LGD<NC0.5': mq5.sign(per, 'LGD', 'NC0.5')}
    return out


def main(xlsx):
    sel = mq5.selection(xlsx)
    chosen = set(sel['chosen'].values())
    ts = mq5.load_values(xlsx, chosen)
    cat = mq3.method_categories(xlsx)
    groups, _ = mq5.stocks_of(ts, sel['A'], cat, chosen, 'SSB')
    out = {'scope': 'post hoc, after the frozen MQ5 test; not verdicts'}
    for g_ in ('primary', 'other'):
        st = groups.get(g_, [])
        out[g_] = {'draw': draw(st), 'eps': eps_part(st), 'lam': lam_part(st), 'damping': damping(st),
                   'coefficients': dev_mq5.lag_coefficients(st)}
    os.makedirs(mq5.OUT, exist_ok=True)
    with open(os.path.join(mq5.OUT, 'posthoc-mq5.json'), 'w') as f:
        json.dump(out, f, indent=1)
    for g_ in ('primary', 'other'):
        o = out[g_]
        print(g_, json.dumps({'draw': o['draw'], 'eps': o['eps'], 'lam_best': o['lam']['best'],
                              'damping': o['damping'], 'coefficients': o['coefficients']}, indent=1))


if __name__ == '__main__':
    main(sys.argv[1])
