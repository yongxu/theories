"""UE31b: the run's path checked before the run (cells/DESIGN.md §9). Synthetic cultures are written into a workbook
in Data Set 2's layout (../LAYOUT.md: strain, treatment and replicate codes, weeks 0 to 36, week 12 entered twice with
the entry before the treatment holding more adults), read back by UE31's reader and run_cells.read, and the cell rules
must give exactly what they give on the same cultures built directly. Four more workbooks check the reading of week
12, and each must give the same verdicts: its two entries the other way round in every culture; mixed, strain 2's the
other way round and one culture in four at each loss from 0.27 on against its strain's order; and, with adults added at
the 0.04 loss's treatment so that its entry after the treatment holds more adults, in order and the other way round. A
last workbook, its adults from week 14 on recorded as counted before the treatment, must read no verdict and write no
cell's numbers. Standard library only; seed 2026110303. Usage: python3 -I -B check_cells.py OUT_XLSX"""
from __future__ import annotations

import json
import os
import random
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.dirname(HERE))
import cell_rules as C  # noqa: E402
import check_reader as K  # noqa: E402
import reader  # noqa: E402
import run_cells  # noqa: E402

NATURAL = 0.007629   # the adults' natural loss a step (Dennis et al. 2001)


def main(out):
    rng = random.Random(2026110303)
    rows, swapped, mixed, added, added_swapped, counted, direct = [], [], [], [], [], [], []
    for strain in (1, 2):
        for treatment in range(1, 7):
            for k in range(4):
                rep = treatment + 6 * k
                mu = reader.LOSS.get(treatment)
                L, P, A = K.counts(rng, mu, 19)
                pre = (L[6] + 1, P[6] + 2, A[6] + 3)
                assert A[6] >= 3
                fewer = (L[6] + 1, P[6] + 2, A[6] - 3)   # before a treatment that adds adults
                low = mu is not None and mu < run_cells.REMOVES
                # mixed: strain 2 the other way round; from 0.27 on, the fourth replicate against its strain's order
                other_way = (strain == 2) != (k == 3 and not low)
                # counted: from week 14 on, the adults as counted, the natural survivors in place of the set share
                Ac = [a + (round((mu - NATURAL) * A[t - 1]) if mu and t > 6 else 0) for t, a in enumerate(A)]
                for t in range(19):
                    row = [strain, treatment, rep, 2 * t, L[t], P[t], A[t]]
                    if t == 6:
                        before = [strain, treatment, rep, 12, *pre]
                        before_added = [strain, treatment, rep, 12, *(fewer if low else pre)]
                        rows.append(before)
                        swapped += [row, before]
                        mixed += [row, before] if other_way else [before, row]
                        added += [before_added, row]
                        added_swapped += [row, before_added]
                        counted.append(before)
                    else:
                        swapped.append(row)
                        mixed.append(row)
                        added.append(row)
                        added_swapped.append(row)
                    rows.append(row)
                    counted.append(row[:6] + [Ac[t]])
                if mu is not None:
                    direct.append({'id': 'DS2-strain%d-loss%g-rep%d' % (strain, mu, rep), 'group': 'primary',
                                   'mu': mu, 'strain': strain, 'L': L[6:], 'P': P[6:], 'A': A[6:]})
    want, _ = C.group_verdicts(direct)
    want = json.dumps(want, sort_keys=True, default=str)
    ok = True
    for name, sheet, earlier in (('in order', rows, 0), ('the other way', swapped, 40), ('mixed', mixed, 20),
                                 ('adults added at 0.04, in order', added, 0),
                                 ('adults added at 0.04, the other way', added_swapped, 40)):
        K.write(out, {2: sheet})
        res = run_cells.read(out)
        got = res['verdicts']
        w12 = got.pop('week12')
        same = json.dumps(got, sort_keys=True, default=str) == want
        ok = ok and same and w12['the earlier read'] == earlier
        if name == 'in order':
            print('cells', res['cells'])
            print('testable', got['testable'], 'cells read', got['cells'], 'protocol', got['protocol'], got['protocol_rows'])
            print('reading', got['reading'])
        print('week 12', name, w12, 'the same verdicts' if same else 'DIFFERENT VERDICTS')
    K.write(out, {2: counted})
    res = run_cells.read(out)
    got = res['verdicts']
    stopped = (all(got[k] == 'not read: ' + C.PROTOCOL_DISAGREES for k in C.VERDICTS if k in got)
               and isinstance(res['per_cell'], str) and not any(k.endswith('_excess') for k in got))
    print('counted', got['protocol'], got['protocol_rows'], 'every verdict not read, numbers withheld' if stopped
          else 'A VERDICT OR A NUMBER WAS WRITTEN')
    ok = ok and stopped
    print('CELL CHECK', 'PASSED' if ok else 'FAILED')
    return 0 if ok else 1


if __name__ == '__main__':
    sys.exit(main(sys.argv[1]))
