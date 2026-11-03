"""UE32's probes of the design's choices (DESIGN.md §4, §6 and §7), run before the rules were frozen, on synthetic
archives of the dry runs' shape. Standard library only; streams seeded by name.
  - test: the frozen sign test against the Wilcoxon signed-rank test and against the margin alone, each with the same
    margin (ARCHIVES archives a generator, streams 'probe-' + generator);
  - form: N's held-out error in T2's written coordinates (E_t, E_{t-1}, g_{t-1}) against the balance's other form of
    the same three numbers (E_t, H_t, g_{t-1}), H_t = E_{t-1} - E_t + g_{t-1} (embed_rules' 'ND'), split by whether
    both forms chose theta = 0, where they span the same linear map (two archives a generator, streams 'form-' +
    generator). It led to reading N in whichever form has the less leave-one-out error (DESIGN.md §4);
  - s3: what the run's reported pairing gives (run_embed.by_s3): the median r over the testable stocks whose MQ5 S3
    excess is at or above MQ5's bound and over those below it, archive by archive (ARCHIVES archives a generator,
    streams 's3-' + generator; DESIGN.md §6 and §7).
Usage: python3 -I -B probe_design.py test [ARCHIVES] [GENERATOR ...] | form [GENERATOR ...] | s3 [ARCHIVES] [GENERATOR ...]"""
from __future__ import annotations

import hashlib
import json
import math
import os
import random
import statistics
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.join(os.path.dirname(HERE), 'margin-measured'))
import dry_runs_embed as D  # noqa: E402
import embed_rules as R  # noqa: E402
import run_embed as RE  # noqa: E402

GENS = ('age', 'age-early', 'two-lags', 't2', 't2-noisy', 'mq4')
FORM_GENS = ('t2', 'age', 'mq4')
S3_GENS = ('mixed',)


def signed_rank(rs):
    """The two-sided exact Wilcoxon signed-rank p over the non-zero r (doubled midranks), and W+ - W-."""
    x = [r for r in rs if r != 0]
    n = len(x)
    order = sorted(range(n), key=lambda i: abs(x[i]))
    rank = [0] * n
    i = 0
    while i < n:
        j = i
        while j + 1 < n and abs(x[order[j + 1]]) == abs(x[order[i]]):
            j += 1
        for k in range(i, j + 1):
            rank[order[k]] = i + j + 2
        i = j + 1
    dist = {0: 1}
    for rk in rank:
        nd = dict(dist)
        for s, c in dist.items():
            nd[s + rk] = nd.get(s + rk, 0) + c
        dist = nd
    wplus = sum(rk for rk, v in zip(rank, x) if v > 0)
    lo = sum(c for s, c in dist.items() if s <= wplus) / 2 ** n
    hi = sum(c for s, c in dist.items() if s >= wplus) / 2 ** n
    return min(1.0, 2 * min(lo, hi)), 2 * wplus - sum(rank)


def verdict(med, field_side, p):
    if med <= R.MARGIN and field_side and p < R.ALPHA:
        return 0
    if med >= -R.MARGIN and not field_side and p < R.ALPHA:
        return 2
    return 1


def test(archives, gens):
    lens = D.lengths()
    print('archives', archives, '; counts are (T2 fails, not separated, T2 better)')
    for g in gens:
        rng = random.Random('probe-' + g)
        out = {'sign test': [0, 0, 0], 'signed-rank test': [0, 0, 0], 'margin alone': [0, 0, 0]}
        meds = []
        for _ in range(archives):
            stocks = [s for s in (D.stock(g, rng, k) for k in lens) if s is not None]
            rs = [p['r'] for p in map(R.per_stock, stocks) if p['testable']]
            med = statistics.median(rs)
            meds.append(med)
            fb, nb = sum(r < 0 for r in rs), sum(r > 0 for r in rs)
            pr, diff = signed_rank(rs)
            out['sign test'][verdict(med, fb > nb, R.binom_two_sided(fb, fb + nb))] += 1
            out['signed-rank test'][verdict(med, diff < 0, pr)] += 1
            out['margin alone'][verdict(med, med < 0, 0.0)] += 1
        print(g, out, 'median r %.3f' % statistics.median(meds))
        sys.stdout.flush()
    return 0


def form(gens):
    lens = D.lengths()
    print('N in the balance\'s other form: ln(MSE of (E_t, H_t, g_{t-1}) / MSE of (E_t, E_{t-1}, g_{t-1})), held out')
    for g in gens:
        rng = random.Random('form-' + g)
        rs = []
        for _ in range(2):
            for n in lens:
                st = D.stock(g, rng, n)
                if st is None:
                    continue
                train, test_ = R.rows(st)
                if len(train) < R.MIN_TRAIN or len(test_) < R.MIN_TEST:
                    continue
                a, b = R.read_state('N', 3, st, train, test_), R.read_state('ND', 3, st, train, test_)
                rs.append((math.log(statistics.fmean(b['sq']) / statistics.fmean(a['sq'])),
                           a['theta'] == 0.0 and b['theta'] == 0.0))
        bent = [r for r, linear in rs if not linear]
        print(g, len(rs), 'stocks; both linear (theta 0) in %d, where the forms agree to %.1g' %
              (len(rs) - len(bent), max([abs(r) for r, linear in rs if linear] or [0.0])),
              '; where either bends (%d): median %.3f, the draw form better in %d, worse in %d (|ratio| < 1e-6 a tie),'
              ' quartiles %s' % (len(bent), statistics.median(bent), sum(r < -1e-6 for r in bent),
                                 sum(r > 1e-6 for r in bent), ['%.2f' % q for q in statistics.quantiles(bent, n=4)]))
        sys.stdout.flush()
    return 0


def s3(archives, gens):
    lens = D.lengths()
    print('archives', archives, '; per archive: (stocks, median r) at or above MQ5\'s bound, then below it')
    for g in gens:
        rng = random.Random('s3-' + g)
        rows = []
        for _ in range(archives):
            stocks = [s for s in (D.stock(g, rng, k) for k in lens) if s is not None]
            per = [dict(R.per_stock(s), mq5_s3_excess=RE.s3_excess(s)) for s in stocks]
            b = RE.by_s3(per)
            rows.append(((b['at_or_above']['stocks'], b['at_or_above']['median_r']),
                         (b['below']['stocks'], b['below']['median_r'])))
        both = [(a[1], c[1]) for a, c in rows if a[1] is not None and c[1] is not None]
        print(g, ['(%d, %.3f) (%d, %.3f)' % (a[0], a[1] or 0, c[0], c[1] or 0) for a, c in rows])
        print(g, 'median over archives: at or above %.3f, below %.3f; the stocks above have the lower median r in %d of %d'
              % (statistics.median(x for x, _ in both), statistics.median(y for _, y in both),
                 sum(x < y for x, y in both), len(both)))
        sys.stdout.flush()
    return 0


if __name__ == '__main__':
    a = sys.argv[1:]
    shas = dict(D.code_sha256())
    for name in ('probe_design.py', 'run_embed.py'):
        with open(os.path.join(HERE, name), 'rb') as f:
            shas[name] = hashlib.sha256(f.read()).hexdigest()
    print('probe_design.py', ' '.join(a), '; code sha-256', json.dumps(shas, sort_keys=True))
    if a and a[0] == 'form':
        sys.exit(form(a[1:] or FORM_GENS))
    if a and a[0] == 's3':
        sys.exit(s3(int(a[1]) if len(a) > 1 else 10, a[2:] or S3_GENS))
    if a and a[0] == 'test':
        sys.exit(test(int(a[1]) if len(a) > 1 else 12, a[2:] or GENS))
    sys.exit(__doc__)
