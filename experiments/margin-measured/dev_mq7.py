"""MQ7's design checks: the synthetic runs that chose the frozen design (PREDICTIONS-2026-10-21-MQ7.md, "Why the
comparison is within a stock and a bin of the deficit" and "Why the verdicts are on the TB reading"). No field value.

  python3 -I dev_mq7.py      writes results/mq7/design-checks.json; a quarter of an hour on one core
  python3 -I dev_mq7.py ssb  adds the SSB reading's variants (ssb-readings below) to it

  first-draft   C1 pooled over stocks in MQ3's strata of the level (the first draft) against C1 within a stock and a bin
                of the deficit, under the regime's step ('level', 600 stocks made, seed 5), with the level law fitted on
                the training years and on all years; and on the other generators (seed 5)
  bins          the deficit's bins of width 0.2 and 0.1 (seed 11; 3000 stocks made under 'level')
  regression    within-stock least squares of falling on the class with covariates instead of bins: the deficit z, the
                regime's own forecast of the episode p (the fitted level law with the actual catches, log of the level
                at t0 + K over the level at t0), p and p^2, p and z (seed 11)
  seeds         C1 and C2 within a stock and a bin of the deficit, and C1 with the catch held over the year before the
                origin as well (which makes the split almost free of kappa and timing), over seeds 21-24, under the two
                nulls and the hypothesis, in both readings
  kappa         the SSB reading with every series read at f = 0 and the draw's share fitted by the state with the lag
                (M3, MQ5's), with recent giving (M2) or by the level law (M1), seeds 21-24
  ssb-readings  the same three fits, each with the timing read and at f = 0, for C1 and C2, with mis-timed series
                (asked after the presence-only layout showed no unread primary test stock with total biomass)
The bootstrap uses 300 resamples here (the frozen rules 2000).
"""
from __future__ import annotations

import json
import math
import os
import random
import sys
from collections import defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import mq3  # noqa: E402
import mq5  # noqa: E402
import mq7  # noqa: E402

mq7.BOOT = 300

MAKERS = {'level': lambda rng: mq5.synthetic('level', rng), 'level-law': mq7.level_law_stock,
          'adjusting-law': lambda rng: mq7.adjusting_stock(rng, 'law'),
          'adjusting-reset': lambda rng: mq7.adjusting_stock(rng, 'reset'),
          'mq5-state': lambda rng: mq5.synthetic('hypothesis', rng),
          'relaxing': lambda rng: mq5.synthetic('relaxing', rng), 'trend': mq7.trend_stock,
          'age': lambda rng: mq5.synthetic('age', rng)}


def made(name, n, seed, reading, timings=mq7.TIMINGS, model='M3', all_years=False):
    rng = random.Random(seed)
    stocks = []
    for i in range(n):
        tb, ssb, c = MAKERS[name](rng)
        st, why = mq7.read_stock(tb if reading == 'TB' else ssb, c, reading, timings, model)
        if st is None:
            continue
        if all_years:
            ys = [y for y in st['sp_years'] if y not in st['bad']]
            st['fit'] = mq3.fit_quadratic([mq5.esc(st, y) / st['scale'] for y in ys],
                                          [mq5.gam(st, y) / st['scale'] for y in ys])
            if st['fit'] is None:
                continue
        st.update(stockid=f'{name}-{seed}-{i}')
        stocks.append(st)
    return stocks


def below(stocks):
    out = []
    for st in stocks:
        for e in mq7.episodes(st):
            if mq7.is_below_low(e):
                e['_st'] = st
                out.append(e)
    return out


def brief(c):
    return {'difference': c['difference'], 'lower_95': c['lower_95'], 'episodes': c['episodes'],
            'verdict': c['verdict']}


def zbin(width):
    def f(e):
        return (e['stock'], 'below 0' if e['z'] < 0 else min(int(e['z'] / width), int(round(1 / width)) - 1))
    return f


def first_draft():
    out = {}
    for name, n in (('level', 600), ('adjusting-law', 300), ('adjusting-reset', 300), ('mq5-state', 300),
                    ('relaxing', 600)):
        for reading in ('TB', 'SSB'):
            for all_years in ((False, True) if name == 'level' else (False,)):
                B = below(made(name, n, 5, reading, all_years=all_years))
                key = f'{name} | {reading}' + (' | level law on all years' if all_years else '')
                out[key] = {'episodes': len(B),
                            'pooled_level_strata': brief(mq7.compare(B, mq7.short, mq7.below_stratum)),
                            'stock_and_deficit': brief(mq7.compare(B, mq7.short, zbin(0.2))),
                            'stock_deficit_trend': brief(mq7.compare(
                                B, mq7.short, lambda e: (*zbin(0.2)(e), e['level_fell_last_year']))),
                            'deficit_only': brief(mq7.compare(B, mq7.short, lambda e: zbin(0.2)(e)[1]))}
                print('first-draft', key, json.dumps(out[key]), flush=True)
    return out


def bins():
    out = {}
    for name, n in (('level', 3000), ('adjusting-law', 300), ('trend', 300), ('age', 300)):
        for reading in ('SSB', 'TB'):
            B = below(made(name, n, 11, reading))
            out[f'{name} | {reading}'] = {f'width {w}': brief(mq7.compare(B, mq7.short, zbin(w))) for w in (0.2, 0.1)}
            print('bins', name, reading, json.dumps(out[f'{name} | {reading}']), flush=True)
    return out


def forecast_change(e):
    """The regime's own forecast of the episode: the fitted level law with the actual catches, log x_{t0+K} / x_t0."""
    st, t0 = e['_st'], e['t0']
    x = st['b'][t0]
    for j in range(mq7.K):
        left = x - st['kappa'] * st['c'][t0 + j]
        if left <= 0:
            x = 0.0
            break
        x = left + mq3.giving(st['fit'], left / st['scale']) * st['scale']
        if x <= 0:
            x = 0.0
            break
    return math.log(max(x, mq3.FLOOR * st['scale']) / st['b'][t0])


def within_stock(eps, covariates):
    """Least squares of falling on the class and the covariates, each demeaned within stock (stocks with both classes)."""
    by = defaultdict(list)
    for e in eps:
        by[e['stock']].append(e)
    rows = []
    for L in by.values():
        if len({mq7.short(e) for e in L}) < 2:
            continue
        cols = [[float(mq7.short(e)) for e in L]] + [[c(e) for e in L] for c in covariates]
        y = [float(e['falls']) for e in L]
        m = [sum(c) / len(c) for c in cols]
        my = sum(y) / len(y)
        rows += [([cols[j][i] - m[j] for j in range(len(cols))], y[i] - my) for i in range(len(L))]
    if not rows:
        return None
    p = len(rows[0][0])
    sol = mq3.solve([[sum(r[0][a] * r[0][b] for r in rows) for b in range(p)] for a in range(p)],
                    [sum(r[0][a] * r[1] for r in rows) for a in range(p)])
    return None if sol is None else sol[0]


def within_stock_bootstrap(eps, covariates, B=300, seed=3):
    d = within_stock(eps, covariates)
    by = defaultdict(list)
    for e in eps:
        by[e['stock']].append(e)
    keys = sorted(by)
    rng = random.Random(seed)
    ds = []
    for _ in range(B):
        sample = [dict(e, stock=(s, j)) for j, s in enumerate(rng.choice(keys) for _ in keys) for e in by[s]]
        x = within_stock(sample, covariates)
        if x is not None:
            ds.append(x)
    ds.sort()
    return {'coefficient': d, 'lower_95': ds[int(0.05 * len(ds))] if ds else None}


def regression():
    out = {}
    cov = {'z': [lambda e: e['z']], 'p': [lambda e: e['p']], 'p, p^2': [lambda e: e['p'], lambda e: e['p'] ** 2],
           'p, z': [lambda e: e['p'], lambda e: e['z']]}
    for name, n in (('level', 3000), ('adjusting-law', 300), ('adjusting-reset', 300), ('trend', 300), ('age', 300)):
        for reading in ('SSB', 'TB'):
            B = below(made(name, n, 11, reading))
            for e in B:
                e['p'] = forecast_change(e)
            out[f'{name} | {reading}'] = {k: within_stock_bootstrap(B, v) for k, v in cov.items()}
            print('regression', name, reading, json.dumps(out[f'{name} | {reading}']), flush=True)
    return out


def held_before(e):
    st, t0 = e['_st'], e['t0']
    m = sum(st['c'][t0 + j] for j in range(mq7.K)) / mq7.K
    return m / mq7.HELD <= st['c'][t0 - 1] <= mq7.HELD * m


def seeds():
    out = {}
    for seed in (21, 22, 23, 24):
        for reading in ('SSB', 'TB'):
            for name, n in (('level', 2000), ('level-law', 400), ('adjusting-law', 300), ('adjusting-reset', 300)):
                B = below(made(name, n, seed, reading))
                key = f'{name} | {reading} | seed {seed}'
                out[key] = {'C1': brief(mq7.compare(B, mq7.short, mq7.c1_stratum)),
                            'C2': brief(mq7.compare(B, mq7.short, mq7.c2_stratum, testable_on=mq7.discordant)),
                            'C1_held_before': brief(mq7.compare([e for e in B if held_before(e)], mq7.short,
                                                                mq7.c1_stratum))}
                print('seeds', key, json.dumps(out[key]), flush=True)
    return out


def kappa():
    out = {}
    for model in ('M3', 'M2', 'M1'):
        for seed in (21, 22, 23, 24):
            for name, n in (('level', 2000), ('level-law', 400), ('adjusting-law', 300), ('adjusting-reset', 300)):
                B = below(made(name, n, seed, 'SSB', timings=(0.0,), model=model))
                key = f'{name} | SSB at f = 0, kappa by {model} | seed {seed}'
                out[key] = brief(mq7.compare(B, mq7.short, mq7.c1_stratum))
                print('kappa', key, json.dumps(out[key]), flush=True)
    return out


def ssb_readings():
    """The SSB reading's variants against the two nulls and the hypothesis, seeds 21-24, and the hypothesis reported
    after half or all of the year's catch (seeds 21-22): the draw's share fitted by the state with the lag (M3), with
    recent giving (M2) or by the level law (M1), each with the timing read (f profiled) or every series at f = 0.
    Asked after the presence-only layout showed that no unread primary test stock carries total biomass."""
    out = {}
    for model in ('M2', 'M1', 'M3'):
        for timings, tl in ((mq7.TIMINGS, 'timing read'), ((0.0,), 'f = 0')):
            for seed in (21, 22, 23, 24):
                for name, n in (('level', 2000), ('level-law', 400), ('adjusting-law', 300), ('adjusting-reset', 300)):
                    B = below(made(name, n, seed, 'SSB', timings=timings, model=model))
                    key = f'{name} | kappa by {model}, {tl} | seed {seed}'
                    out[key] = {'C1': brief(mq7.compare(B, mq7.short, mq7.c1_stratum)),
                                'C2': brief(mq7.compare(B, mq7.short, mq7.c2_stratum, testable_on=mq7.discordant))}
                    print('ssb', key, json.dumps(out[key]), flush=True)
            for f in mq7.MISTIMED:
                for seed in (21, 22):
                    rng = random.Random(seed)
                    stocks = []
                    for i in range(300):
                        tb, ssb, c = MAKERS['adjusting-law'](rng)
                        obs = {y: v for y, v in ((y, ssb[y] - f * ssb[y] / tb[y] * c[y]) for y in ssb) if v > 0}
                        st, why = mq7.read_stock(obs, c, 'SSB', timings, model)
                        if st is not None:
                            st.update(stockid=f'mistimed-{seed}-{i}')
                            stocks.append(st)
                    B = below(stocks)
                    key = f'adjusting-law, mistimed f = {f} | kappa by {model}, {tl} | seed {seed}'
                    out[key] = {'C1': brief(mq7.compare(B, mq7.short, mq7.c1_stratum)),
                                'C2': brief(mq7.compare(B, mq7.short, mq7.c2_stratum, testable_on=mq7.discordant))}
                    print('ssb', key, json.dumps(out[key]), flush=True)
    return out


def main():
    if sys.argv[1:] == ['ssb']:
        path = os.path.join(mq7.OUT, 'design-checks.json')
        with open(path) as f:
            out = json.load(f)
        out['ssb_readings'] = ssb_readings()
        with open(path, 'w') as f:
            json.dump(out, f, indent=1, default=str)
        return
    out = {'scope': 'design checks on synthetic stocks; no field value',
           'first_draft': first_draft(), 'bins': bins(), 'regression': regression(), 'seeds': seeds(),
           'kappa': kappa(), 'ssb_readings': ssb_readings()}
    os.makedirs(mq7.OUT, exist_ok=True)
    with open(os.path.join(mq7.OUT, 'design-checks.json'), 'w') as f:
        json.dump(out, f, indent=1, default=str)


if __name__ == '__main__':
    main()
