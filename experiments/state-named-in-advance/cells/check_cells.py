"""UE31b: the run's path checked before the run (cells/DESIGN.md §9). Synthetic cultures are written into a workbook
in Data Set 2's layout (../LAYOUT.md: strain, treatment and replicate codes, weeks 0 to 36, week 12 entered twice with
the entry before the treatment different), read back by UE31's reader and grouped into cells by run_cells.read_cells,
and the cell rules must give exactly what they give on the same cultures built directly. Two more workbooks check the
run's reading of week 12: with its two entries in the other order in every culture, the earlier entry must be read and
the verdicts must be the same; with them in the other order in half the cultures, no verdict may be read. Standard
library only; seed 2026110303. Usage: python3 -I -B check_cells.py OUT_XLSX"""
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


def main(out):
    rng = random.Random(2026110303)
    rows, swapped, mixed, direct = [], [], [], []
    for strain in (1, 2):
        for treatment in range(1, 7):
            for k in range(4):
                rep = treatment + 6 * k
                mu = reader.LOSS.get(treatment)
                L, P, A = K.counts(rng, mu, 19)
                pre = (L[6] + 1, P[6] + 2, A[6] + 3)
                for t in range(19):
                    row = [strain, treatment, rep, 2 * t, L[t], P[t], A[t]]
                    if t == 6:
                        before = [strain, treatment, rep, 12, *pre]
                        rows.append(before)
                        swapped += [row, before]
                        mixed += [row, before] if k % 2 else [before, row]   # the other way in half the cultures
                    else:
                        swapped.append(row)
                        mixed.append(row)
                    rows.append(row)
                if mu is not None:
                    direct.append({'id': 'DS2-strain%d-loss%g-rep%d' % (strain, mu, rep), 'group': 'primary',
                                   'mu': mu, 'strain': strain, 'L': L[6:], 'P': P[6:], 'A': A[6:]})
    K.write(out, {2: rows})
    res = run_cells.read(out)
    got, shape = res['verdicts'], res['cells']
    order = got.pop('week12_order')
    want, _ = C.group_verdicts(direct)
    same = json.dumps(got, sort_keys=True, default=str) == json.dumps(want, sort_keys=True, default=str)
    print('cells', shape)
    print('testable', got['testable'], 'cells read', got['cells'], 'protocol', got['protocol'], got['protocol_rows'])
    print('reading', got['reading'])
    print('week 12 in order', order)
    K.write(out, {2: swapped})
    back = run_cells.read(out)['verdicts']
    turned = back.pop('week12_order')
    same_back = json.dumps(back, sort_keys=True, default=str) == json.dumps(want, sort_keys=True, default=str)
    print('week 12 the other way', turned, 'the same verdicts' if same_back else 'DIFFERENT VERDICTS')
    K.write(out, {2: mixed})
    part = run_cells.read(out)['verdicts']
    caught = all(part[k] == run_cells.ORDER_FAILED for k in C.VERDICTS if k in part)
    print('week 12 mixed', part['week12_order'], 'every verdict not read' if caught else 'A VERDICT WAS READ')
    ok = same and order['read at t = 0'] == 'later' and same_back and turned['read at t = 0'] == 'earlier' and caught
    print('CELL CHECK', 'PASSED' if ok else 'FAILED')
    return 0 if ok else 1


if __name__ == '__main__':
    sys.exit(main(sys.argv[1]))
