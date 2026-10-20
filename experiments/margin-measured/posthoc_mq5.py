"""MQ5 post hoc (not verdicts): analyses chosen after the frozen test had been run on the stocks no analysis had read.

  python3 -I posthoc_mq5.py XLSX       writes results/mq5/posthoc-mq5.json
  python3 -I posthoc_mq5.py why XLSX   writes results/mq5/why-d1-d2.json (why D1 and D2 failed; asked after the
                                       first post hoc analyses)

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

why (on the test stocks, MQ5's SSB reading of the development stocks and MQ4's TB reading of them, each split into the
New Zealand stocks and the rest, by the `stock` table's region):
  timing         per stock, the level's relative change from t-1 to t on year t's catch and year t-1's catch (each over
                 the level at t-1): the reading takes the draw of year t from the level at t, so year t's catch should
                 not lower it; where it does, the series reports the level after part of that year's catch
  forms          D1's form (same year, with the catch's last level), the same with last year's change in the level
                 instead (a response a year late), and D1, the draw's elasticity, and D2's parts at ten years: the held
                 draw, the actual catches, the draw's law, persistence, and the same three draws with the lag
  state          S1-S4's statistics on each part (mq5.rule_state, mq5.rule_forecast)
  synthetic      the two forms of D1 on mq5's generators (the blind catch, the hypothesis, held catches reset)
  mistimed       mq5's generators with the spawning biomass reported after a share f of the year's catch (0, 0.5, 1):
                 D1, S2, S3, S4 and the fitted share, to see what reporting the level after part of the draw does
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


def timing(stocks):
    """The level's relative change from t-1 to t on year t's catch and year t-1's catch, each over the level at t-1."""
    T = []
    for st in stocks:
        b, c = st['b'], st['c']
        rows = [t for t in st['run'] if (t - 1) in b]
        if len(rows) < 15:
            continue
        co = mq5.ols_coef([b[t] / b[t - 1] - 1 for t in rows],
                          [[c[t] / b[t - 1] for t in rows], [c[t - 1] / b[t - 1] for t in rows], [1.0] * len(rows)])
        if co is not None:
            T.append(co)
    return {'stocks': len(T), 'year_t_catch_lowers': sum(x[0] < 0 for x in T),
            'year_t_minus_1_catch_lowers': sum(x[1] < 0 for x in T),
            'median_coefficients': [statistics.median(x[0] for x in T), statistics.median(x[1] for x in T)] if T else None}


def response_forms(stocks):
    """Per stock, the change in log catch on the change in log level (same year, D1's form) or on last year's change (a
    response a year late), each with the catch's last level and a constant."""
    same, late = [], []
    for st in stocks:
        b, c = st['b'], st['c']
        rows = [t for t in st['run'] if all((t - j) in b for j in (0, 1, 2)) and min(c[t], c[t - 1]) > 0]
        if len(rows) < 15:
            continue
        y = [math.log(c[t] / c[t - 1]) for t in rows]
        c1 = [math.log(c[t - 1]) for t in rows]
        one = [1.0] * len(rows)
        a = mq5.ols_coef(y, [[math.log(b[t] / b[t - 1]) for t in rows], c1, one])
        z = mq5.ols_coef(y, [[math.log(b[t - 1] / b[t - 2]) for t in rows], c1, one])
        if a is not None and z is not None:
            same.append(a[0])
            late.append(z[0])

    def summ(v):
        pos = sum(x > 0 for x in v)
        return {'stocks': len(v), 'positive': pos, 'median': statistics.median(v) if v else None,
                'p_two_sided': mq3.binom_two_sided(pos, len(v)) if v else None}
    return {'same_year': summ(same), 'a_year_late': summ(late)}


def d2_parts(stocks):
    r = mq5.scores(stocks, 10, ['CLLG0', 'LG', 'CLLG', 'CL0', 'LGD', 'CL'])
    e = r['median_abs_log_error']
    gap = e['CLLG0'] - e['RW']
    zero = {m: 0 for m in ('CLLG0', 'LG', 'CLLG')}
    for st in stocks:
        fl = mq3.FLOOR * st['scale']
        for t0 in mq5.origins(st, 10):
            for m in zero:
                zero[m] += mq5.forecast(st, t0, 10, m) <= fl
    return {'origins': r['origins'], 'median_abs_log_error': {m: e[m] for m in
                                                              ('CLLG0', 'LG', 'CLLG', 'RW', 'CL0', 'LGD', 'CL')},
            'gap_closed_by_actual_catches': (e['CLLG0'] - e['LG']) / gap if gap > 0 else None,
            'gap_closed_by_draw_law_D2': (e['CLLG0'] - e['CLLG']) / gap if gap > 0 else None,
            'forecasts_at_floor': zero}


def state_parts(stocks):
    s = mq5.rule_state(stocks)
    f = mq5.rule_forecast(stocks)
    keep = ('stocks', 'S1_recent_giving_detected', 'S1_level_detected', 'S2_lag_detected', 'S2_binomial_p',
            'S2_lag_median_excess', 'S3_median_excess')
    return {**{k: s.get(k) for k in keep}, 'S4_k5_LGD_LG': [f['k5']['median_abs_log_error'][m] for m in ('LGD', 'LG')],
            'S4_k5_signs': f['k5']['signs']['LGD<LG'], 'k10_LGD_RW_LG': [f['k10']['median_abs_log_error'][m]
                                                                         for m in ('LGD', 'RW', 'LG')],
            'lag_coefficients': dev_mq5.lag_coefficients(stocks)}


def why_group(stocks):
    d1 = mq5.draw_follows(stocks)
    return {'stocks': len(stocks), 'timing': timing(stocks), 'forms': response_forms(stocks),
            'D1': {k: d1[k] for k in ('stocks', 'positive_slopes', 'median_slope', 'p_two_sided')},
            'eps_measured': mq5.draw_elasticity(stocks)[0], 'D2_parts': d2_parts(stocks),
            'state': state_parts(stocks)}


def mistimed(rng):
    """The generators' spawning biomass is omega times the level before the year's draw; a series that reports it after
    a share f of that year's catch gives omega (b - f C)."""
    out = {}
    for kind in ('draw-only', 'relaxing', 'hypothesis'):
        for f in (0.0, 0.5, 1.0):
            stocks = []
            for _ in range(150):
                tb, ssb, c = mq5.synthetic(kind, rng)
                obs = {y: ssb[y] / tb[y] * (tb[y] - f * c[y]) for y in ssb}
                st, w = mq5.build(obs, c)
                if st is not None and not mq5.prepare(st, 'SSB'):
                    stocks.append(st)
            s = mq5.rule_state(stocks)
            d1 = mq5.draw_follows(stocks)
            fc = mq5.rule_forecast(stocks)
            out[f'{kind} | f = {f}'] = {'stocks': len(stocks), 'S2_lag_detected': s.get('S2_lag_detected'),
                                        'S3_median_excess': s.get('S3_median_excess'),
                                        'D1_positive': d1['positive_slopes'], 'D1_stocks': d1['stocks'],
                                        'D1_median_slope': d1['median_slope'], 'S4_k5_signs': fc['k5']['signs']['LGD<LG'],
                                        'kappa_quartiles': mq3.quartiles([x['kappa'] for x in stocks])}
    return out


def regions(xlsx):
    import ram_read
    it = ram_read.rows(xlsx, 'stock')
    h = next(it)
    ix = {k: i for i, k in enumerate(h)}
    return {r[ix['stockid']]: (r[ix['region']] if len(r) > ix['region'] else '') for r in it}


def why(xlsx):
    import random
    reg = regions(xlsx)
    cat = mq3.method_categories(xlsx)
    sel = mq5.selection(xlsx)
    chosen = set(sel['chosen'].values())
    test, _ = mq5.stocks_of(mq5.load_values(xlsx, chosen), sel['A'], cat, chosen, 'SSB')
    A, devset = mq5.dev_assessments(xlsx)
    ts = mq5.load_values(xlsx, devset)
    out = {'scope': 'post hoc, after the frozen MQ5 test and its first post hoc analyses; not verdicts'}
    for name, stocks in (('test_primary', test.get('primary', [])),
                         ('dev_SSB_primary', mq5.stocks_of(ts, A, cat, devset, 'SSB')[0].get('primary', [])),
                         ('dev_TB_primary', mq5.stocks_of(ts, A, cat, devset, 'TB')[0].get('primary', []))):
        nz = [s for s in stocks if reg.get(s['stockid']) == 'New Zealand']
        rest = [s for s in stocks if reg.get(s['stockid']) != 'New Zealand']
        out[name] = {'all': why_group(stocks), 'New Zealand': why_group(nz), 'not New Zealand': why_group(rest),
                     'New Zealand CASAL': sum(s['method'] == 'CASAL' for s in nz)}
    rng = random.Random(7)
    out['synthetic'] = {}
    for kind in ('blind', 'hypothesis', 'lag-reset'):
        made = []
        for _ in range(150):
            tb, ssb, c = mq5.synthetic(kind, rng)
            st, w = mq5.build(ssb, c)
            if st is not None and not mq5.prepare(st, 'SSB'):
                made.append(st)
        out['synthetic'][kind] = response_forms(made)
    out['mistimed'] = mistimed(random.Random(11))
    with open(os.path.join(mq5.OUT, 'why-d1-d2.json'), 'w') as f:
        json.dump(out, f, indent=1)
    for name in ('test_primary', 'dev_SSB_primary', 'dev_TB_primary'):
        for part in ('New Zealand', 'not New Zealand'):
            o = out[name][part]
            print(name, part, json.dumps({'stocks': o['stocks'], 'timing': o['timing'], 'forms': o['forms'],
                                          'D1': o['D1'], 'eps': o['eps_measured'], 'D2': o['D2_parts']}))
    print('synthetic', json.dumps(out['synthetic']))
    for name in ('test_primary', 'dev_SSB_primary'):
        for part in ('New Zealand', 'not New Zealand'):
            print(name, part, 'state', json.dumps(out[name][part]['state']))
    for k, v in out['mistimed'].items():
        print('mistimed', k, json.dumps(v))


if __name__ == '__main__':
    if sys.argv[1] == 'why':
        why(sys.argv[2])
    else:
        main(sys.argv[1])
