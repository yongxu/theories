"""MQ6 post hoc (not verdicts): why the breaks came early, and what A1's failure is.

  python3 -I posthoc_mq6.py DIR      writes results/mq6/posthoc-mq6.json

Written after the frozen verdicts (results/mq6/VERDICTS-mq6-a.json, VERDICTS-mq6.json) were read. Nothing here changes
a verdict. DIR as for mq6.py.

  H1 giving against the map before the break: the median one-day log residual of each run's map by day, over the
     populations above ten times the floor (does the giving fall below the map before the onset, day by day?).
  H2 the fold the breaks imply: for the dilution run, the beta (the low-density rate's fall with the draw) that, with
     the other parameters of the frozen map, puts the predicted free-fall onset on the observed median day; its fold.
     For the sucrose run, the scale on the low-density rate below 1% doing the same. A fit to the test data.
  H3 A1 read three ways: by the floor (MQ2's reading), by direction (the frozen reading), and by direction with the
     day-6 density also required above twice the floor (direction is noise for readings at the floor).
  H4 T1 with the map's level matched to the constant group (the carrying capacity scaled by the control's median over
     the map's level): does the offset C1 measured account for the map's one-day errors?
"""
from __future__ import annotations

import json
import math
import os
import statistics
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import mq2  # noqa: E402
import mq6  # noqa: E402


def residuals_by_day(pops, start, cond, G, df_of):
    by = {}
    for p in pops:
        for d in range(start, len(p)):
            if p[d - 1] > 10 * mq6.FLOOR and p[d] > 10 * mq6.FLOOR:
                r = math.log(p[d]) - math.log(max(G(p[d - 1] / df_of(d), cond(d)), mq6.FLOOR))
                by.setdefault(d, []).append(r)
    return {d: {'n': len(v), 'median_log_residual': statistics.median(v)} for d, v in sorted(by.items())}


def onset_median(pops, start, cond, G, df_of):
    days = []
    for p in pops:
        path = mq6.predicted_path(p, start, cond, G, df_of)
        days.append(mq6.fall_day(path, start))
    fin = [d for d in days if d is not None]
    return (statistics.median(fin) if len(fin) > len(days) / 2 else None), len(fin)


def h2_dilution(pops, target):
    rows = []
    best = None
    for i in range(27, 301, 3):
        beta = i / 100
        th = list(mq6.DF_THETA)
        th[4] = beta
        G = mq6.df_map(th)
        med, n = onset_median(pops, mq6.DF_START, mq6.df_of_day, G, mq6.df_of_day)
        fold = mq6.df_fold(G)
        rows.append({'beta': beta, 'median_onset': med, 'fold_df': fold})
        if med is not None and best is None and med <= target:
            best = {'beta': beta, 'median_onset': med, 'fold_df': fold}
    return {'target_median_onset': target, 'first_beta_reaching_it': best, 'scan': rows}


def h2_sucrose(pops, theta, target):
    rows = []
    best = None
    for i in range(0, 61):
        drop = i / 20          # extra fall of the low-density rate per unit ln(s) below 1%
        def G(x, s, drop=drop):
            p = mq6.suc_params(theta, s)
            if s < 1.0:
                p[0] -= drop * math.log(1.0 / s)
            return mq2.two_phase(p)(x)
        med, n = onset_median(pops, mq6.SUC_START, mq6.sucrose_of_day, G, lambda d: mq6.DF_SUC)
        fold = mq6.suc_fold(G)
        rows.append({'extra_drop': drop, 'median_onset': med, 'fold_sucrose': fold})
        if med is not None and best is None and med <= target:
            best = {'extra_drop': drop, 'median_onset': med, 'fold_sucrose': fold}
    return {'target_median_onset': target, 'first_reaching_it': best, 'scan': rows}


def h3(data, Gs_odd):
    out = {}
    for i in mq6.EVEN:
        s = mq6.SUCROSE[i - 1]
        st = mq6.state_at(lambda z: Gs_odd(z, s), mq6.DF_SUC)
        u = st['need']
        starts = [p[0] for p in data[i]]
        readings = {'floor': [p[5] > mq6.FLOOR for p in data[i]],
                    'direction': [mq6.survives(p, st['stable']) for p in data[i]],
                    'direction_above_2f': [(p[5] > 2 * mq6.FLOOR) and mq6.survives(p, st['stable']) for p in data[i]]}
        row = {'sucrose': s, 'need': u,
               'starts_at_or_below_floor': sum(1 for x in starts if x <= mq6.FLOOR),
               'day6_at_or_below_2f': sum(1 for p in data[i] if p[5] <= 2 * mq6.FLOOR)}
        for name, alive in readings.items():
            hi = [a for x, a in zip(starts, alive) if u and x > mq6.SEP * u and x > mq6.FLOOR]
            lo = [a for x, a in zip(starts, alive) if u and x < u / mq6.SEP and (x > mq6.FLOOR or u / mq6.SEP >= mq6.FLOOR)]
            r = {'high_n': len(hi), 'low_n': len(lo),
                 'high_alive': (sum(hi) / len(hi)) if hi else None,
                 'low_extinct': (sum(1 for a in lo if not a) / len(lo)) if lo else None}
            if 0 < sum(alive) < len(alive):
                ustar, acc = mq2.best_threshold(starts, alive)
                r.update(empirical_need=ustar, empirical_accuracy=acc,
                         ratio=(u / ustar) if u else None)
            row[name] = r
        out[s] = row
    return out


def main(directory):
    out = {'scope': 'post hoc, after the frozen verdicts; not verdicts'}
    sets = mq6.deterioration_sets(directory)
    fa = json.load(open(os.path.join(mq6.OUT, 'fit-all.json')))
    fo = json.load(open(os.path.join(mq6.OUT, 'fit-odd.json')))
    v = json.load(open(os.path.join(mq6.OUT, 'VERDICTS-mq6.json')))
    Gs = mq6.suc_map(fa['theta'])
    Gdf = mq6.df_map()
    df_pops, suc_pops, ctl = sets['subset_DF'][0], sets['subset_SUC'][0], sets['subset_DF_control'][0]
    out['H1'] = {'dilution_run': residuals_by_day(df_pops, mq6.DF_START, mq6.df_of_day, Gdf, mq6.df_of_day),
                 'constant_group': residuals_by_day(ctl, mq6.DF_START, lambda d: 500.0, Gdf, lambda d: 500.0),
                 'sucrose_run': residuals_by_day(suc_pops, mq6.SUC_START, mq6.sucrose_of_day, Gs, lambda d: mq6.DF_SUC)}
    out['H2'] = {'dilution_run': h2_dilution(df_pops, v['main']['subset_DF']['T2']['median_observed']),
                 'sucrose_run': h2_sucrose(suc_pops, fa['theta'], v['main']['subset_SUC']['T2']['median_observed'])}
    data = mq6.read_sucbif(directory, range(1, 10))
    for i in data:
        data[i], _ = mq6.scale_rows(data[i], 1.7)
    out['H3'] = h3(data, mq6.suc_map(fo['theta']))
    # H4: the carrying capacity scaled to the constant group's level
    c1 = v['C1']
    th = list(mq6.DF_THETA)
    for _ in range(40):          # match the level at DF 500 by adjusting ln k (bisection on the scale)
        G = mq6.df_map(th)
        lvl = mq6.state_at(lambda z: G(z, 500.0), 500.0)['stable']
        th[3] += math.log(c1['median_reading'] / lvl)
    G_adj = mq6.df_map(th)
    out['H4'] = {'theta_adjusted': th,
                 'level_at_500': mq6.state_at(lambda z: G_adj(z, 500.0), 500.0)['stable'],
                 'T1': mq6.rule_t1(df_pops, mq6.DF_START, mq6.df_of_day, G_adj, mq6.df_of_day)}
    with open(os.path.join(mq6.OUT, 'posthoc-mq6.json'), 'w') as f:
        json.dump(out, f, indent=1, default=str)
    brief = {'H1_dilution': {d: round(r['median_log_residual'], 3) for d, r in out['H1']['dilution_run'].items()},
             'H1_constant': {d: round(r['median_log_residual'], 3) for d, r in out['H1']['constant_group'].items()},
             'H1_sucrose': {d: round(r['median_log_residual'], 3) for d, r in out['H1']['sucrose_run'].items()},
             'H2_dilution': out['H2']['dilution_run']['first_beta_reaching_it'],
             'H2_sucrose': out['H2']['sucrose_run']['first_reaching_it'],
             'H3': {s: {k: (r[k] if not isinstance(r[k], dict) else {kk: (round(vv, 3) if isinstance(vv, float) else vv)
                                                                        for kk, vv in r[k].items()}) for k in r}
                    for s, r in out['H3'].items()},
             'H4_T1': {w: {k: {m: round(x, 3) for m, x in out['H4']['T1'][w][k]['median_abs_log_error'].items()}
                           for k in ('k1', 'k3', 'k5')} for w in ('every_origin', 'late_origins')}}
    print(json.dumps(brief, indent=1, default=str))


if __name__ == '__main__':
    main(sys.argv[1])
