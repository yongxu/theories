"""UE31b's pilot on the first row, before the dry runs and before any value of these cultures is read: the cell rules
with rows from t = 3 and from t = 4 on 60 synthetic archives of five generators each (dry_runs_cells.py's), seed 7.
It chose t = 3 (cells/DESIGN.md §3, §6). Standard library only. Usage: python3 -I -B pilot_first.py"""
from __future__ import annotations

import os
import random
import statistics
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.dirname(HERE))
import cell_rules as C  # noqa: E402
import dry_runs_cells as X  # noqa: E402

N = 60

for first in (3, 4):
    C.FIRST = first
    for gen in ('lpa', 'lpa-two', 'lpa-long', 't2-stage-mq5', 't2-copy-mq5'):
        rng = random.Random(7)
        rs = [C.group_verdicts(X.archive(rng, gen))[0] for _ in range(N)]

        def share(key, value):
            return sum(1 for r in rs if r[key] == value) / N
        by = {}
        for r in rs:
            for mu, (m, _) in r['H1_by_loss'].items():
                by.setdefault(mu, []).append(m)
        print('first %d %-13s W fails %.2f | V2 holds %.2f | H1 holds %.2f, median %.3f, by loss %s' % (
            first, gen, share('W', 'the wording fails'), share('V2', 'the rival holds'), share('H1', 'T2 holds'),
            statistics.median(r['H1_excess'] for r in rs),
            {k: round(statistics.median(v), 3) for k, v in sorted(by.items())}))
        for key in ('sign', 'V4', 'V5'):
            print('   %s %s' % (key, {v: round(share(key, v), 2) for v in sorted({r[key] for r in rs})}))
        sys.stdout.flush()
