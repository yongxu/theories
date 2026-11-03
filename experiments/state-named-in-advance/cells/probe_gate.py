"""UE31b's review probe (DESIGN.md §6, §10, §12), from its two readers' probes and kept: what fires the gate at 30
replicates a cell under lpa? Four variants of lpa's culture, each at seeds 1 to 9: as designed (the loss set at week 12,
pupation and recruitment drawn); the loss set from week 0, so that no onset falls in the window read; and each of these
with pupation and recruitment fixed at their rounded means, so that T2's three numbers fix the next giving's mean up to
rounding and a further lag can add only through the misfit of T2's polynomial law (that also changes the dynamics).
Standard library only; no archive value is read. Usage: python3 -I -B probe_gate.py"""
from __future__ import annotations

import math
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

SEEDS = range(1, 10)


def course(onset, drawn):
    """lpa's culture (the egg rate Poisson throughout) with or without the onset, the chain drawn or fixed."""
    def run(rng, mu, q, **_):
        l1, p, a = D.START[0], D.START[1], D.START[2]
        L, P, A = [l1], [p], [a]
        for k in range(X.BEFORE + X.UNDER):
            eggs = D.poisson(rng, q['b'] * a * math.exp(-q['c_el'] * l1 - q['c_ea'] * a))
            if drawn:
                np_, rec = D.binomial(rng, l1, 1 - q['mu_l']), D.binomial(rng, p, math.exp(-q['c_pa'] * a))
            else:
                np_, rec = round(l1 * (1 - q['mu_l'])), round(p * math.exp(-q['c_pa'] * a))
            if onset and k + 1 < X.BEFORE:
                old = D.binomial(rng, a, 1 - q['mu_a'])
            else:
                old = round((1 - mu) * a)
            l1, p, a = eggs, np_, rec + old
            L.append(l1)
            P.append(p)
            A.append(a)
        return {'L': L[X.BEFORE:], 'P': P[X.BEFORE:], 'A': A[X.BEFORE:]}
    return run


def main():
    designed = X.lpa_course
    for label, onset, drawn in (('as designed', True, True), ('no onset', False, True),
                                ('onset, the chain fixed', True, False), ('no onset, the chain fixed', False, False)):
        X.lpa_course = course(onset, drawn)
        dets, fires, top = [], 0, []
        for seed in SEEDS:
            res, _ = C.group_verdicts(X.archive(random.Random(seed), 'lpa', X.LARGE_REPS))
            dets.append(res['H1_detected'])
            fires += res['H1_detected_tail'] < R_ALPHA
            top.append(res['H1_by_loss']['0.96'][0])
        print('%-26s H1 detected in %s of 10 cells (median %g); the gate fires in %d of %d; H1 at 0.96: %.2f to %.2f'
              % (label, dets, statistics.median(dets), fires, len(SEEDS), min(top), max(top)))
        sys.stdout.flush()
    X.lpa_course = designed
    return 0


R_ALPHA = C.R.ALPHA

if __name__ == '__main__':
    sys.exit(main())
