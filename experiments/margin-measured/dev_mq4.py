"""MQ4 development (not a test): forecast classes for a state carrying recent giving, on MQ3's stocks.

  python3 -I dev_mq4.py XLSX     writes results/mq4/development-models.json

Run before MQ4's freeze, on the stocks MQ3 had already read (most recent assessments with TB and catch in tonnes),
to choose which two-variable state the freeze tests. Each class forecasts TB at t0 + k from the state at t0 with the
actual catches, on MQ3's split and origins:

  FR    giving held at SP_{t0-1} (the frozen rest)
  RM    giving read off what is left, g(E) (the regime margin)
  FR2   giving held at the mean of SP_{t0-1} and SP_{t0-2}
  RATE  giving per unit left held: SP_t = (SP_{t0-1} / E_{t0-1}) E_t
  M6    the level law's change with the anomaly held: SP_t = g(E_t) + (SP_{t0-1} - g(E_{t0-1}))
  LG    giving relaxing toward the level law: SP_t = phi SP_{t-1} + (1 - phi) g(E_t)
  P4    MQ3's post-hoc reading: SP_t = g(E_t) + phi^j (SP_{t0-1} - g(E_{t0-1}))
  MR    giving relaxing toward its training mean, no level: SP_t = phi SP_{t-1} + (1 - phi) mean
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


def project(st, t0, k, model, phi=None):
    tb, c = st['tb'], st['c']
    b = tb[t0]
    s_prev = mq3.sp(st, t0 - 1)
    e_prev = mq4.E(st, t0 - 1)
    d = s_prev - mq4.g_t(st, e_prev)
    tr = [mq3.sp(st, y) for y in st['train'] if y not in st['bad']]
    m = sum(tr) / len(tr)
    for j in range(k):
        e = b - c[t0 + j]
        if e <= 0:
            return 0.0
        if model == 'FR':
            s = s_prev
        elif model == 'RM':
            s = mq4.g_t(st, e)
        elif model == 'FR2':
            s = (mq3.sp(st, t0 - 1) + mq3.sp(st, t0 - 2)) / 2
        elif model == 'RATE':
            s = mq3.sp(st, t0 - 1) / e_prev * e if e_prev > 0 else mq3.sp(st, t0 - 1)
        elif model == 'M6':
            s = mq4.g_t(st, e) + d
        elif model == 'LG':
            s = phi * s_prev + (1 - phi) * mq4.g_t(st, e)
        elif model == 'P4':
            s = mq4.g_t(st, e) + phi ** (j + 1) * d
        elif model == 'MR':
            s = phi * s_prev + (1 - phi) * m
        s_prev = s
        b = e + s
        if b <= 0:
            return 0.0
    return b


def score(stocks, k, model, phi=None):
    right = n = 0
    errs = []
    for st in stocks:
        tb = st['tb']
        for t0 in mq4.origins(st, k):
            if (t0 - 2) not in tb or (t0 - 2) in st['bad']:
                continue
            p = project(st, t0, k, model, phi)
            right += (p > tb[t0]) == (tb[t0 + k] > tb[t0])
            n += 1
            errs.append(abs(math.log(max(p, mq3.FLOOR * st['scale']) / tb[t0 + k])))
    return {'origins': n, 'accuracy': right / n if n else None,
            'median_abs_log_error': statistics.median(errs) if errs else None}


def main(xlsx):
    groups, _ = mq4.load_mq3(xlsx)
    classes = [('FR', None), ('RM', None), ('FR2', None), ('RATE', None), ('M6', None),
               ('LG', 0.5), ('LG', 0.7), ('LG', 0.8), ('LG', 0.9), ('LG', 0.96),
               ('P4', 0.42), ('P4', 0.8), ('MR', 0.8), ('MR', 0.9)]
    out = {'scope': 'development before the MQ4 freeze, on MQ3 stocks already read; not a test'}
    for g in ('primary', 'control', 'other'):
        out[g] = {}
        for k in (1, 3, 5, 8):
            out[g][f'k{k}'] = {(m if p is None else f'{m}{p}'): score(groups[g], k, m, p) for m, p in classes}
    os.makedirs(mq4.OUT, exist_ok=True)
    with open(os.path.join(mq4.OUT, 'development-models.json'), 'w') as f:
        json.dump(out, f, indent=1)
    for g in ('primary', 'control', 'other'):
        for k in (1, 5, 8):
            print(g, k, ' '.join(f"{m}:{v['accuracy']:.3f}/{v['median_abs_log_error']:.3f}"
                                 for m, v in out[g][f'k{k}'].items()))


if __name__ == '__main__':
    main(sys.argv[1])
