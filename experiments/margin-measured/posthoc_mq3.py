"""MQ3 post hoc (not verdicts): why the regime margin lost to the frozen rest in the field.

  python3 -I posthoc_mq3.py XLSX     writes results/mq3/posthoc-mq3.json

Written after the frozen test's verdicts (results/mq3/VERDICTS-mq3.json) were read. Nothing here changes
a verdict. Four readings, each on the same stocks, origins and outcomes as F1 (one year) and F2 (five years):

  P1 within range: only origins whose escapement lies inside the training years' range of escapement
     (no extrapolation of the fitted law).
  P2 in sample: g fitted on every SP year of the stock, test years included (an upper bound for a giving
     law of the level alone, with no change of regime across the split).
  P3 refitted: g refitted at each origin on every SP year before it (the law follows a changing regime).
  P5 the other order: giving read off the level before the draw, SP_t = g(TB_t), TB_{t+1} = TB_t - C_t + g(TB_t)
     (the usual production-model order; RM1 states only draw-first), fitted on training; P5s the same in sample.
  P4 level plus anomaly: SP_t = g(E_t) + d_t with the anomaly d persisting as d_{t+1} = phi d_t, phi and g
     fitted on training; at the origin d is read from SP_{t0-1} - g(E_{t0-1}). The frozen rest is the case
     g = 0, phi = 1; the regime margin the case phi = 0.

Also: the share of concave fits, and the F3 'beyond giving' episodes (the training law never meets the catch).
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


def fit_on(st, years, give_first=False):
    tb, c, scale = st['tb'], st['c'], st['scale']
    ys_ = [y for y in years if y not in st['bad']]
    xs = [(tb[y] - (0 if give_first else c[y])) / scale for y in ys_]
    gs = [mq3.sp(st, y) / scale for y in ys_]
    return mq3.fit_quadratic(xs, gs) if len(ys_) >= 5 else None


def phi_on(st, fit, years):
    tb, c, scale = st['tb'], st['c'], st['scale']
    d = {y: mq3.sp(st, y) / scale - mq3.giving(fit, (tb[y] - c[y]) / scale) for y in years if y not in st['bad']}
    pairs = [(d[y], d[y + 1]) for y in d if (y + 1) in d]
    den = sum(a * a for a, _ in pairs)
    return max(-1.0, min(1.0, sum(a * b for a, b in pairs) / den)) if den > 0 else 0.0


def project_give_first(st, t0, k, fit):
    tb, c, scale = st['tb'], st['c'], st['scale']
    b = tb[t0]
    for j in range(k):
        b = b - c[t0 + j] + mq3.giving(fit, b / scale) * scale
        if b <= 0:
            return 0.0
    return b


def project(st, t0, k, fit, phi=0.0, anomaly=True):
    tb, c, scale = st['tb'], st['c'], st['scale']
    b = tb[t0]
    e1 = (tb[t0 - 1] - c[t0 - 1]) / scale
    d = (mq3.sp(st, t0 - 1) / scale - mq3.giving(fit, e1)) if anomaly else 0.0
    for j in range(k):
        e = b - c[t0 + j]
        if e <= 0:
            return 0.0
        d = phi * d
        b = e + (mq3.giving(fit, e / scale) + d) * scale
        if b <= 0:
            return 0.0
    return b


def evaluate(stocks, k, model, within=False):
    right = n = 0
    errs = []
    for st in stocks:
        tb, c, scale = st['tb'], st['c'], st['scale']
        es = [(tb[y] - c[y]) for y in st['train']]
        lo, hi = min(es), max(es)
        all_fit = fit_on(st, st['sp_years']) if model == 'P2' else None
        gf = fit_on(st, st['train'], give_first=True) if model == 'P5' else None
        gfs = fit_on(st, st['sp_years'], give_first=True) if model == 'P5s' else None
        phi = phi_on(st, st['fit'], st['train']) if model == 'P4' else 0.0
        for t0 in st['test']:
            if (t0 + k) not in tb or (t0 - k) not in tb or (t0 - 1) not in tb:
                continue
            if any((t0 + j) in st['bad'] for j in range(k)) or (t0 - 1) in st['bad']:
                continue
            if within and not (lo <= tb[t0] - c[t0] <= hi):
                continue
            if model in ('RM', 'FR'):
                p = mq3.forecast(st, t0, k, model)
            elif model == 'P2':
                p = project(st, t0, k, all_fit, anomaly=False)
            elif model == 'P3':
                f = fit_on(st, [y for y in st['sp_years'] if y < t0])
                if f is None:
                    continue
                p = project(st, t0, k, f, anomaly=False)
            elif model == 'P4':
                p = project(st, t0, k, st['fit'], phi=phi)
            elif model == 'P5':
                if gf is None:
                    continue
                p = project_give_first(st, t0, k, gf)
            elif model == 'P5s':
                if gfs is None:
                    continue
                p = project_give_first(st, t0, k, gfs)
            right += (p > tb[t0]) == (tb[t0 + k] > tb[t0])
            n += 1
            errs.append(abs(math.log(max(p, mq3.FLOOR * scale) / tb[t0 + k])))
    return {'origins': n, 'accuracy': right / n if n else None,
            'median_abs_log_error': statistics.median(errs) if errs else None}


def main(xlsx):
    groups, _ = mq3.load(xlsx)
    out = {'scope': 'post hoc, after the frozen verdicts; not verdicts'}
    for g in ('primary', 'control'):
        stocks = groups[g]
        res = {}
        for k in (1, 5):
            res[f'k{k}'] = {m: evaluate(stocks, k, m) for m in ('RM', 'FR', 'P2', 'P3', 'P4', 'P5', 'P5s')}
            res[f'k{k}_within_training_range'] = {m: evaluate(stocks, k, m, within=True) for m in ('RM', 'FR', 'P4')}
        fits = [st['fit'] for st in stocks]
        res['fits'] = {'stocks': len(fits), 'concave_dome': sum(a > 0 and b < 0 for a, b in fits),
                       'a_nonpositive': sum(a <= 0 for a, _ in fits), 'convex': sum(b >= 0 for _, b in fits)}
        res['phi'] = {'median': statistics.median(phi_on(st, st['fit'], st['train']) for st in stocks)}
        f3 = mq3.rule_f3(stocks)
        bg = [e for e in f3['below_episodes'] if e['beyond_giving']]
        nb = [e for e in f3['below_episodes'] if not e['beyond_giving']]
        res['f3_split'] = {'beyond_giving': len(bg), 'beyond_giving_fell': sum(e['fell'] for e in bg) / len(bg) if bg else None,
                           'below_point': len(nb), 'below_point_fell': sum(e['fell'] for e in nb) / len(nb) if nb else None}
        out[g] = res
    with open(os.path.join(mq3.OUT, 'posthoc-mq3.json'), 'w') as f:
        json.dump(out, f, indent=1)
    print(json.dumps(out, indent=1))


if __name__ == '__main__':
    main(sys.argv[1])
