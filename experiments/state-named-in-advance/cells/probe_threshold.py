"""UE31b's probe for the recording check's threshold (DESIGN.md §7): rows of 360 in which the recruits read exceed the
pupae by more than half an animal, as cell_rules.in_cell counts them, in synthetic archives recorded as the protocol
says but with count errors (the second reader's departures: the survivors' set share rounded up, a share of the pupae
missed at each count, a share of the larvae maturing within a step uncounted as pupae) at four settings, and
recorded in the counted form at two parameter sets, the 2001 estimates and the recalled set. 200 archives each, seed 11. Standard library only; no archive value is read.
Usage: python3 -I -B probe_threshold.py"""
from __future__ import annotations

import os
import random
import statistics
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.dirname(HERE))
import cell_rules as C  # noqa: E402
import dry_runs as D  # noqa: E402
import dry_runs_cells as X  # noqa: E402

N = 200


def rows_above(cs):
    n = 0
    for c in cs:
        A, P, mu = c['A'], c['P'], c['mu']
        n += sum(1 for t in range(C.FIRST, len(A) - 1) if A[t + 1] - (1 - mu) * A[t] > P[t] + 0.5 + 1e-6)
    return n


def report(rng, label, gen, q=None, miscount=None):
    counts = []
    for _ in range(N):
        cs = []
        for st in X.STRAINS:
            for mu in D.MUS:
                for _ in range(X.REPS):
                    c = X.lpa_course(rng, mu, q or D.LPA, counted=(gen == 'counted'), miscount=miscount)
                    cs.append(dict(c, mu=mu))
        counts.append(rows_above(cs))
    q_ = sorted(counts)
    print('%-52s min %3d  median %5.1f  99th percentile %3d  max %3d  stopped (46 or more) %5.1f%%' % (
        label, q_[0], statistics.median(q_), q_[int(0.99 * N) - 1], q_[-1], 100 * sum(x >= 46 for x in q_) / N))
    sys.stdout.flush()


def main():
    rng = random.Random(11)
    for label, m in (('protocol, rounded up, 2% of pupae missed, larvae 0.002', {'up': True, 'missed': 0.02, 'larvae': 0.002}),
                     ('protocol, as lpa-miscount (5% missed)', X.MISCOUNT),
                     ('protocol, rounded up, 5% missed, larvae 0.005', {'up': True, 'missed': 0.05, 'larvae': 0.005}),
                     ('protocol, 10% of pupae missed', {'up': False, 'missed': 0.10, 'larvae': 0.0})):
        report(rng, label, 'protocol', miscount=m)
    for label, q in (('counted, at the 2001 estimates', D.LPA), ('counted, at the recalled set', D.RECALLED)):
        report(rng, label, 'counted', q=q)
    return 0


if __name__ == '__main__':
    sys.exit(main())
