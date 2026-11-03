"""UE31b's review probe (DESIGN.md §10, §12), written by its reader and kept: is the gate's firing at 30 replicates a
cell the transient from the onset? lpa archives at 30 replicates a cell, read as designed (the loss set at week 12) and
with the loss set from week 0 (no onset in the window read). Standard library only; no archive value is read.
Usage: python3 -I -B probe_transient.py"""
from __future__ import annotations

import math
import os
import random
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.dirname(HERE))
import cell_rules as C  # noqa: E402
import dry_runs as D  # noqa: E402
import dry_runs_cells as X  # noqa: E402


def no_onset(rng, mu, q, **_):
    """lpa's culture with the set loss from week 0; the 13 censuses from week 12, as the design reads them."""
    l1, p, a = D.START[0], D.START[1], D.START[2]
    L, P, A = [l1], [p], [a]
    for _ in range(X.BEFORE + X.UNDER):
        eggs = D.poisson(rng, q['b'] * a * math.exp(-q['c_el'] * l1 - q['c_ea'] * a))
        np_ = D.binomial(rng, l1, 1 - q['mu_l'])
        rec = D.binomial(rng, p, math.exp(-q['c_pa'] * a))
        l1, p, a = eggs, np_, rec + round((1 - mu) * a)
        L.append(l1)
        P.append(p)
        A.append(a)
    return {'L': L[X.BEFORE:], 'P': P[X.BEFORE:], 'A': A[X.BEFORE:]}


def main():
    designed = X.lpa_course
    for label, fn in (('onset at week 12 (as designed)', designed), ('no onset (the loss from week 0)', no_onset)):
        X.lpa_course = fn
        for seed in (1, 2, 3):
            t0 = time.process_time()
            res, _ = C.group_verdicts(X.archive(random.Random(seed), 'lpa', X.LARGE_REPS))
            print('%-32s seed %d  H1 detected in %s of 10 cells (tail %.4f)  H1 by loss %s  sign: %s  (%.1f s)' % (
                label, seed, res['H1_detected'], res['H1_detected_tail'],
                {k: round(v[0], 3) for k, v in res['H1_by_loss'].items()}, res['sign'], time.process_time() - t0))
            sys.stdout.flush()
    X.lpa_course = designed
    return 0


if __name__ == '__main__':
    sys.exit(main())
