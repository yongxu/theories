"""MQ5 development (not a test): forecast classes and readings on MQ3's and MQ4's stocks, and the draw's share on
synthetic stocks.

  python3 -I dev_mq5.py XLSX     writes results/mq5/development-models.json

Run before MQ5's freeze, on the stocks MQ3 and MQ4 had already read, to choose which state with a lag and which law of
the draw the freeze tests. Each class forecasts the level at t0 + k from the state at t0, on MQ3's split and MQ5's
origins, in both readings (TB: total biomass, the draw's share 1; SSB: spawning biomass, the share fitted):

  FR, RM, LG     the frozen rest, the regime's step, MQ4's state (mq5.project), with the actual catches
  LG3            the lag in the level's law: phi gamma + (1 - phi) g3(E_t, E_{t-1}), g3 quadratic in both, fitted on
                 the training years, with the actual catches
  LGD(lam)       the lag as frozen: phi gamma + (1 - phi) g(E_t) + lam (E_{t-1} - E_t), with the actual catches
  CLLG(eps)      MQ4's state in the closed loop, the catch following the level with elasticity eps (0: held)
  CL             LGD in the closed loop at the frozen eps
  NC(psi)        the net exchange (giving less the draw on the level) closing by psi a year: the level moves by
                 psi^j (gamma_{t0-1} - kappa C_{t0-1}) in year j

It also reports, per stock in sample, the giving on (E_t, SP_{t-1}, E_{t-1}) without the squares (how the lag acts),
and, on synthetic stocks (mq5.synthetic), the draw's share fitted on the training years by each model, against the
true share.
"""
from __future__ import annotations

import json
import math
import os
import random
import statistics
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import mq3  # noqa: E402
import mq5  # noqa: E402


def fit_g3(st):
    sc, k = st['scale'], st['kappa']
    t3 = [y for y in st['train'] if (y - 1) in st['b'] and (y - 1) not in st['bad']]
    co = mq5.ols_coef([mq5.gam(st, y) / sc for y in t3], mq5.state_cols(st, t3, k, ['E', 'EE', 'E1', 'E1E1']))
    return co if co is not None else (st['fit'][0], st['fit'][1], 0.0, 0.0)


def lg3(st, t0, k, co, phi=mq5.PHI):
    b, c, K, sc = st['b'], st['c'], st['kappa'], st['scale']
    x = b[t0]
    s_prev, e_prev = mq5.gam(st, t0 - 1), mq5.esc(st, t0 - 1)
    for j in range(k):
        e = x - K * c[t0 + j]
        if e <= 0:
            return 0.0
        u, u1 = e / sc, e_prev / sc
        s = phi * s_prev + (1 - phi) * (co[0] * u + co[1] * u * u + co[2] * u1 + co[3] * u1 * u1) * sc
        s_prev, e_prev = s, e
        x = e + s
        if x <= 0:
            return 0.0
    return x


def nc(st, t0, k, psi):
    x = st['b'][t0]
    n = mq5.gam(st, t0 - 1) - st['kappa'] * st['c'][t0 - 1]
    for _ in range(k):
        n *= psi
        x += n
        if x <= 0:
            return 0.0
    return x


def classes(stocks, k):
    names = ['FR', 'RM', 'LG', 'LG3', 'LGD', 'LGD0.15', 'CL'] + [f'CLLG{e}' for e in (0.0, 0.35, 0.7, 1.0, 1.5, 2.0)] \
        + ['NC0.3', 'NC0.5']
    right = {m: 0 for m in names + ['MO']}
    errs = {m: [] for m in names + ['RW']}
    n = 0
    for st in stocks:
        b = st['b']
        fl = mq3.FLOOR * st['scale']
        co = fit_g3(st)
        for t0 in mq5.origins(st, k):
            p = {'FR': mq5.forecast(st, t0, k, 'FR'), 'RM': mq5.forecast(st, t0, k, 'RM'),
                 'LG': mq5.forecast(st, t0, k, 'LG'), 'LG3': lg3(st, t0, k, co),
                 'LGD': mq5.forecast(st, t0, k, 'LGD'), 'LGD0.15': mq5.forecast(st, t0, k, 'LGD', lam=0.15),
                 'CL': mq5.forecast(st, t0, k, 'CL'), 'NC0.3': nc(st, t0, k, 0.3), 'NC0.5': nc(st, t0, k, 0.5)}
            for e in (0.0, 0.35, 0.7, 1.0, 1.5, 2.0):
                p[f'CLLG{e}'] = mq5.project(st, t0, k, 'LG', 'law', eps=e)
            obs = b[t0 + k] > b[t0]
            for m in names:
                right[m] += (p[m] > b[t0]) == obs
            right['MO'] += (b[t0] > b[t0 - k]) == obs
            p['RW'] = b[t0]
            for m in errs:
                errs[m].append(abs(math.log(max(p[m], fl) / b[t0 + k])))
            n += 1
    return {'origins': n, 'accuracy': {m: v / n if n else None for m, v in right.items()},
            'median_abs_log_error': {m: statistics.median(v) if v else None for m, v in errs.items()}}


def lag_coefficients(stocks):
    """Per stock, in sample, the giving on E_t, SP_{t-1}, E_{t-1} (scaled, no constant): medians and positive counts.
    By the balance E_{t-1} - E_t = kappa C_t - SP_{t-1}, a positive E_{t-1} with a negative E_t is giving moving toward
    the draw."""
    cos = []
    for st in stocks:
        ys = mq5.insample_years(st)
        if len(ys) < 20:
            continue
        co = mq5.ols_coef([mq5.gam(st, t) / st['scale'] for t in ys],
                          mq5.state_cols(st, ys, st['kappa'], ['E', 'G1', 'E1']))
        if co:
            cos.append(co)
    return {'stocks': len(cos), 'columns': ['E_t', 'SP_{t-1}', 'E_{t-1}'],
            'median': [statistics.median(c[i] for c in cos) for i in range(3)],
            'positive': [sum(c[i] > 0 for c in cos) for i in range(3)]}


def kappa_recovery(seed=5, n=60):
    """The draw's share fitted on the training years by each model, over the true share (the median ratio of the
    synthetic spawning biomass to the total)."""
    rng = random.Random(seed)
    out = {}
    for kind in ('hypothesis', 'relaxing', 'draw-only', 'age'):
        res = {m: [] for m in ('M1', 'M2', 'M3', 'M4')}
        for _ in range(n):
            tb, ssb, c = mq5.synthetic(kind, rng)
            st, why = mq5.build(ssb, c)
            if st is None or mq5.prepare(st, 'SSB'):
                continue
            om = statistics.median(ssb[y] / tb[y] for y in st['run'])
            sp = st['sp_years']
            train = sp[:int(math.floor(mq3.TRAIN * len(sp)))]
            ys = [y for y in train if (y - 2) in st['b']]
            ks = mq5.kappas(st, set(ys) | {y - 1 for y in ys} | {y - 2 for y in ys})
            for m in res:
                r = mq5.rss(st, ys, mq5.MODELS[m], ks)
                if r and om > 0:
                    res[m].append(r[1] / om)
        out[kind] = {m: {'median': statistics.median(v), 'quartiles': mq3.quartiles(v)} for m, v in res.items() if v}
    return out


def main(xlsx):
    A, devset = mq5.dev_assessments(xlsx)
    ts = mq5.load_values(xlsx, devset)
    cat = mq3.method_categories(xlsx)
    out = {'scope': "development before the MQ5 freeze, on MQ3's and MQ4's stocks already read; not a test"}
    for reading in ('SSB', 'TB'):
        groups, _ = mq5.stocks_of(ts, A, cat, devset, reading)
        out[reading] = {}
        for g in ('primary', 'control', 'other'):
            st = groups.get(g, [])
            out[reading][g] = {f'k{k}': classes(st, k) for k in (1, 5, 10)}
            out[reading][g]['lag_coefficients'] = lag_coefficients(st)
    out['kappa_recovery_synthetic'] = kappa_recovery()
    os.makedirs(mq5.OUT, exist_ok=True)
    with open(os.path.join(mq5.OUT, 'development-models.json'), 'w') as f:
        json.dump(out, f, indent=1)
    for reading in ('SSB', 'TB'):
        for k in (1, 5, 10):
            r = out[reading]['primary'][f'k{k}']
            print(reading, 'primary', k, r['origins'], ' '.join(
                f"{m}:{(r['accuracy'].get(m) or 0):.3f}/{r['median_abs_log_error'][m]:.3f}"
                for m in r['median_abs_log_error']))
        print(reading, 'lag coefficients', out[reading]['primary']['lag_coefficients'])
    print(json.dumps(out['kappa_recovery_synthetic']))


if __name__ == '__main__':
    main(sys.argv[1])
