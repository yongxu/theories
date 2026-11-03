"""UE32's dry runs: the rules (embed_rules.py) on synthetic archives of MQ5's primary group's shape, before any series
is read (DESIGN.md). Each archive holds 69 stocks with the lengths of MQ5's 69 primary stocks (from MQ5's committed
fits), each built, split and given its draw's share by MQ5's own code (../margin-measured/mq5.py: build, prepare,
the SSB reading). Standard library only; seed 2026110304.

Generators (MQ5's synthetic stocks unless marked; the level law Schaefer's, K = 1e5 t):
  - t2: T2's law, MQ5's hypothesis: the giving relaxes toward the level's law at 0.9 and reads the lag, LAM (E_{t-1} -
    E_t), the catch following the level (EPS 0.7);
  - t2-noisy: the same, the spawning biomass read with lognormal noise 0.02;
  - mq4: MQ4's state, no lag, the same draw (MQ5's draw-only);
  - two-lags: T2's law with a second lag, LAM (E_{t-2} - E_{t-1});
  - level: the giving read off the level (the regime's step), catches reset every 3-6 years (MQ3's);
  - drifting: a giving that wanders on its own (MQ4's);
  - age: MQ5's age-structured stock, ages 1-12, maturity at 4, Beverton-Holt recruitment with AR(1) deviations;
  - age-early, age-late (added): the same with maturity at 2 and at 7, the late one's recruitment deviations sigma
    0.6, so that what spawns now returns as spawners several years on;
  - mixed (added): each stock age (maturity at 4) with probability 1/3 and t2 otherwise, the share at which MQ5's
    in-sample readings of its own stocks place them between those two worlds (DESIGN.md §1).
Usage: python3 -I -B dry_runs_embed.py OUT_JSON [ARCHIVES] [GENERATOR ...]
   or: python3 -I -B dry_runs_embed.py --merge OUT_JSON PART_JSON ... (each generator's stream is seeded by its name,
       so generators run in separate parts give what one run gives)"""
from __future__ import annotations

import hashlib
import json
import math
import os
import random
import statistics
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
MQ = os.path.join(os.path.dirname(HERE), 'margin-measured')
sys.path.insert(0, HERE)
sys.path.insert(0, MQ)
import embed_rules as R  # noqa: E402
import mq5  # noqa: E402

SEED = 2026110304
ARCHIVES = 200
FIRST_YEAR = 1950


def lengths():
    """The lengths of MQ5's primary stocks, from its committed fits."""
    with open(os.path.join(MQ, 'results', 'mq5', 'VERDICTS-mq5.json')) as f:
        fits = json.load(f)['fits']['primary']
    return [s['years'][1] - s['years'][0] + 1 for s in fits]


def age_model(rng, n_years, a_mat, sigma):
    """mq5.age_structured with maturity at a_mat (selectivity one year earlier) and recruitment deviations sigma."""
    A, M = 12, 0.2
    w = [(1 - math.exp(-0.3 * (a + 1))) ** 3 for a in range(A)]
    mat = [1 / (1 + math.exp(-1.5 * (a + 1 - a_mat))) for a in range(A)]
    sel = [1 / (1 + math.exp(-1.5 * (a + 1 - max(a_mat - 1, 1)))) for a in range(A)]
    n = [math.exp(-M * a) for a in range(A)]
    n[-1] /= (1 - math.exp(-M))
    tb0 = sum(x * wa for x, wa in zip(n, w))
    s0 = sum(x * wa * m for x, wa, m in zip(n, w, mat))
    h = rng.uniform(0.5, 0.9)
    rho, dev = rng.uniform(0.3, 0.8), 0.0
    f = rng.uniform(0.05, 0.4)
    tb, ssb, c = {}, {}, {}
    for i in range(n_years):
        y = FIRST_YEAR + i
        tb[y] = 1e5 * sum(x * wa for x, wa in zip(n, w)) / tb0
        s = sum(x * wa * m for x, wa, m in zip(n, w, mat))
        ssb[y] = 1e5 * s / tb0
        z = [sa * f + M for sa in sel]
        c[y] = 1e5 * sum(x * wa * sa * f / za * (1 - math.exp(-za)) for x, wa, sa, za in zip(n, w, sel, z)) / tb0
        dev = rho * dev + math.sqrt(1 - rho * rho) * rng.gauss(0, sigma)
        rec = 4 * h * s / (s0 * (1 - h) + s * (5 * h - 1)) * math.exp(dev - sigma * sigma / 2)
        surv = [x * math.exp(-za) for x, za in zip(n, z)]
        n = [rec] + surv[:A - 2] + [surv[A - 2] + surv[A - 1]]
        f = min(max(f * math.exp(rng.gauss(0, 0.15)), 0.02), 1.0)
    return tb, ssb, c


GENS = {'t2': 'hypothesis', 't2-noisy': 'hypothesis-noisy', 'mq4': 'draw-only', 'two-lags': 'two-lags',
        'level': 'level', 'drifting': 'drifting', 'age': 'age', 'age-early': (2, 0.4), 'age-late': (7, 0.6),
        'mixed': None}
MIXED_AGE = 1 / 3


def stock(gen, rng, n_years):
    """One synthetic stock read as MQ5 reads one (SSB), redrawn until MQ5's code admits it (at most 50 tries)."""
    kind = GENS[gen]
    if gen == 'mixed':
        kind = 'age' if rng.random() < MIXED_AGE else 'hypothesis'
    for _ in range(50):
        if isinstance(kind, tuple):
            _, ssb, c = age_model(rng, n_years, *kind)
        else:
            _, ssb, c = mq5.synthetic(kind, rng, n_years)
        st, why = mq5.build(ssb, c)
        if st is None or mq5.prepare(st, 'SSB'):
            continue
        return st
    return None


def archive(gen, rng, lens):
    stocks = [s for s in (stock(gen, rng, n) for n in lens) if s is not None]
    res, _ = R.group_verdicts(stocks)
    return res


def share(values):
    out = {}
    for v in values:
        out[v] = out.get(v, 0) + 1
    n = len(values)
    return {k: v / n for k, v in sorted(out.items())}


def summary(results):
    n = len(results)
    read = [r for r in results if 'median_r' in r]

    def med(f):
        vals = [f(r) for r in read]
        vals = [v for v in vals if v is not None]
        return statistics.median(vals) if vals else None
    rep = lambda k: (lambda r: r['reported'][k])  # noqa: E731
    return {'archives': n, 'shares': share([r['fitted'] for r in results]),
            'readings': share([r['reading'] for r in results]),
            'simplex_shares': share([r['reported']['simplex']['verdict'] for r in read]),
            'draw_form_shares': share([r['reported']['draw_form']['verdict'] for r in read]),
            'chosen_form_shares': share([r['reported']['chosen_form']['verdict'] for r in read]),
            'medians': {'median_r': med(lambda r: r['median_r']), 'f_better': med(lambda r: r['f_better']),
                        'n_better': med(lambda r: r['n_better']), 'testable': med(lambda r: r['testable']),
                        'median_r_d_at_least_2': med(lambda r: r['median_r_d_at_least_2']),
                        'simplex_median_r': med(lambda r: r['reported']['simplex']['median_r']),
                        'draw_median_r': med(lambda r: r['reported']['draw_form']['median_r']),
                        'chosen_median_r': med(lambda r: r['reported']['chosen_form']['median_r']),
                        'N_form_draw_share': med(lambda r: r['reported']['chosen_form']['N_form_draw'] / r['testable']),
                        'N_skill_vs_persistence': med(rep('N_skill_vs_persistence')),
                        'F_skill_vs_persistence': med(rep('F_skill_vs_persistence')),
                        'N_skill_vs_mean': med(rep('N_skill_vs_mean')),
                        'N_worse_than_persistence': med(lambda r: r['reported']['share_worse_than_persistence']['N']),
                        'F_worse_than_persistence': med(lambda r: r['reported']['share_worse_than_persistence']['F']),
                        'L_over_N': med(lambda r: r['reported']['median_ln_mse_over_N']['L']),
                        'U_over_N': med(lambda r: r['reported']['median_ln_mse_over_N']['U'])},
            'range_median_r': [min(r['median_r'] for r in read), max(r['median_r'] for r in read)] if read else None,
            'share_margin_met': {'fails side': sum(r['median_r'] <= R.MARGIN for r in read) / n,
                                 'better side': sum(r['median_r'] >= -R.MARGIN for r in read) / n} if read else None,
            'dims_chosen': {d: sum(r['dims'][d] for r in read) for d in range(1, R.D_MAX + 1)} if read else {},
            'simplex_dims_chosen': {d: sum(r['reported']['simplex']['dims'][d] for r in read)
                                    for d in range(1, R.D_MAX + 1)} if read else {},
            'median_r_by_d': {d: statistics.median(r['by_d'][d]['median_r'] for r in read if d in r['by_d'])
                              for d in range(1, R.D_MAX + 1) if any(d in r['by_d'] for r in read)} if read else {}}


def code_sha256():
    """The sha-256 of the code the dry runs read, so that an output names the code that wrote it."""
    names = ('embed_rules.py', 'dry_runs_embed.py', os.path.join('..', 'margin-measured', 'mq5.py'))
    out = {}
    for n in names:
        with open(os.path.join(HERE, n), 'rb') as f:
            out[os.path.basename(n)] = hashlib.sha256(f.read()).hexdigest()
    return out


def main(out, archives=ARCHIVES, gens=None):
    lens = lengths()
    report = {'seed': SEED, 'archives': archives, 'stocks_per_archive': len(lens), 'lengths': sorted(lens),
              'code_sha256': code_sha256(),
              'rules': {'D_MAX': R.D_MAX, 'THETAS': R.THETAS, 'MARGIN': R.MARGIN, 'ALPHA': R.ALPHA,
                        'MIN_TRAIN': R.MIN_TRAIN, 'MIN_TEST': R.MIN_TEST, 'MIN_STOCKS': R.MIN_STOCKS},
              'results': {}}
    for gen in gens or list(GENS):
        rng = random.Random(f'{SEED}-{gen}')
        t0 = time.process_time()
        res = [archive(gen, rng, lens) for _ in range(archives)]
        report['results'][gen] = dict(summary(res), cpu_seconds=round(time.process_time() - t0, 1))
        got = report['results'][gen]
        print(gen, json.dumps(got['shares']), json.dumps(got['readings']), 'median r %.3f' %
              (got['medians']['median_r'] or 0), 'simplex', json.dumps(got['simplex_shares']), 'draw form',
              json.dumps(got['draw_form_shares']), 'chosen form', json.dumps(got['chosen_form_shares']), 'dims',
              got['dims_chosen'], '%.0fs' % got['cpu_seconds'])
        sys.stdout.flush()
    with open(out, 'w') as f:
        json.dump(report, f, indent=1, sort_keys=True)
        f.write('\n')
    return 0


def merge(out, parts):
    reports = []
    for p in parts:
        with open(p) as f:
            reports.append(json.load(f))
    report = dict(reports[0], results={})
    for r in reports:
        assert {k: v for k, v in r.items() if k != 'results'} == {k: v for k, v in reports[0].items() if k != 'results'}
        report['results'].update(r['results'])
    report['results'] = {g: report['results'][g] for g in GENS if g in report['results']}
    with open(out, 'w') as f:
        json.dump(report, f, indent=1, sort_keys=True)
        f.write('\n')
    return 0


if __name__ == '__main__':
    a = sys.argv[1:]
    if a[0] == '--merge':
        sys.exit(merge(a[1], a[2:]))
    sys.exit(main(a[0], int(a[1]) if len(a) > 1 else ARCHIVES, a[2:] or None))
