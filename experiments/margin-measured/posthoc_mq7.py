"""MQ7 post hoc (not verdicts): analyses chosen after the frozen test had been run on the stocks no analysis had read.

  python3 -I posthoc_mq7.py SMART SAG    writes results/mq7/posthoc-mq7.json

  where       where the 21 primary stocks' origins went: test origins, a held catch, a positive draw on the level
              (kappa > 0), below the regime's point, on the low side, in a compared stratum; per stock
  compared    the stocks and strata C1 compared, with each stock's episodes, shares falling and its own difference
  bootstrap   C1's stock bootstrap: the share of resamples at or below zero and at exactly zero (the frozen lower bound
              is the 5th percentile, and it came out exactly 0)
  kappa_zero  the stocks whose fitted share of the catch on the spawning stock is 0, so that no episode has a draw on
              the level, and C1 with them read at kappa = 1 (the whole catch drawn from the spawning stock, as the TB
              reading takes it)
"""
from __future__ import annotations

import json
import os
import sys
from collections import Counter, defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import mq3  # noqa: E402
import mq5  # noqa: E402
import mq7  # noqa: E402


def where(st, k=mq7.K):
    """The fate of each test origin of a stock, by the first condition it fails."""
    b, c, kap = st['b'], st['c'], st['kappa']
    pk = mq7.peak(st)
    out = Counter()
    for t0 in st['test']:
        if (t0 + k) not in b or (t0 - 1) not in b or any((t0 + j) in st['bad'] for j in range(-1, k)):
            out['no t0 - 1 or t0 + 3 in the run'] += 1
            continue
        cs = [c[t0 + j] for j in range(k)]
        m = sum(cs) / k
        if m <= 0 or max(cs) > mq7.HELD * m or m > mq7.HELD * min(cs):
            out['catch not held'] += 1
            continue
        if kap * m <= 0:
            out['no draw on the level (kappa 0)'] += 1
            continue
        pt = mq3.regime_point(st['fit'], kap * m / st['scale'])
        if pt is not None and b[t0] >= pt * st['scale'] / mq7.SEP:
            out['not below the point'] += 1
            continue
        if not mq5.esc(st, t0) < pk:
            out['high side of the peak'] += 1
            continue
        out['below the point, low side'] += 1
    return dict(out)


def per_stock(eps):
    by = defaultdict(list)
    for e in eps:
        by[e['stock']].append(e)
    out = {}
    for s, L in sorted(by.items()):
        sh = [e for e in L if mq7.short(e)]
        me = [e for e in L if not mq7.short(e)]
        d, _ = mq7.pooled_difference(L, mq7.short, mq7.c1_stratum)
        out[s] = {'episodes': len(L), 'short': len(sh), 'meets': len(me),
                  'short_falls': sum(e['falls'] for e in sh) / len(sh) if sh else None,
                  'meets_falls': sum(e['falls'] for e in me) / len(me) if me else None,
                  'C1_within_stock': d}
    return out


def bootstrap_shares(eps):
    import random
    by = defaultdict(list)
    for e in eps:
        by[e['stock']].append(e)
    keys = sorted(by, key=str)
    rng = random.Random(mq7.SEED)
    ds = []
    for _ in range(mq7.BOOT):
        sample = []
        for j, s in enumerate(rng.choice(keys) for _ in keys):
            sample += [(j, e) for e in by[s]]
        x = mq7.pooled_difference([e for _, e in sample], mq7.short,
                                  mq7._relabel(mq7.c1_stratum, {id(e): j for j, e in sample}))[0]
        if x is not None:
            ds.append(x)
    n = len(ds)
    return {'resamples': n, 'share_at_or_below_zero': sum(x <= 0 for x in ds) / n,
            'share_exactly_zero': sum(x == 0 for x in ds) / n, 'share_below_zero': sum(x < 0 for x in ds) / n,
            'median': sorted(ds)[n // 2]}


def main(smart, sag):
    groups, _ = mq7.test_stocks(smart, sag)
    stocks = groups.get(('SSB', 'primary'), [])
    E = [e for st in stocks for e in mq7.episodes(st)]
    B = [e for e in E if mq7.is_below_low(e)]
    out = {'scope': 'post hoc, after the frozen MQ7 test; not verdicts',
           'where': {st['stockid']: {'name': st['name'], 'kappa': st['kappa'], 'timing': st['timing'],
                                     'test_origins': len(st['test']), **where(st)} for st in stocks},
           'compared': per_stock(B), 'bootstrap': bootstrap_shares(B)}
    zero = [st for st in stocks if st['kappa'] == 0]
    out['kappa_zero'] = {'stocks': [st['stockid'] for st in zero]}
    redo = []
    S = mq7.test_series(smart, sag, values=True)
    for st in stocks:
        if st['kappa'] != 0:
            redo.append(st)
            continue
        src, sid = st['stockid'].split(':', 1)
        r = S[(src, sid, 'SSB')]
        L = {y: v for y, v in r['L'].items() if v is not None}
        C = {y: v for y, v in r['C'].items() if v is not None}
        st1, why = mq7.read_stock(L, C, 'TB', mq7.READINGS['SSB']['timings'], mq7.READINGS['SSB']['model'])
        if st1 is None:
            out['kappa_zero'].setdefault('excluded_at_kappa_1', {})[st['stockid']] = why
            continue
        st1.update(stockid=st['stockid'], name=st['name'])
        redo.append(st1)
    out['kappa_zero']['C1_with_them_at_kappa_1'] = mq7.brief(mq7.rules(redo, report=False)['C1'])
    out['kappa_zero']['C2_with_them_at_kappa_1'] = mq7.brief(mq7.rules(redo, report=False)['C2'])
    os.makedirs(mq7.OUT, exist_ok=True)
    with open(os.path.join(mq7.OUT, 'posthoc-mq7.json'), 'w') as f:
        json.dump(out, f, indent=1, default=str)
    print(json.dumps(out, indent=1, default=str))


if __name__ == '__main__':
    if len(sys.argv) != 3:
        raise SystemExit(__doc__)
    main(*sys.argv[1:])
