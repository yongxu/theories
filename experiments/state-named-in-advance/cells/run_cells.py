"""UE31b's run (cells/DESIGN.md §9), frozen with the design and not yet run: the cell rules on the archive's adult-loss
cultures, the output kept whatever it is. Standard library only; the workbook is untrusted data, so run with
python3 -I -B.

Fixed before the run, with none of these cultures' values read:
  - the workbook's sha-256 must equal the digest Dryad publishes (../LAYOUT.md), the file UE31's run read;
  - the cultures are UE31's reader's primary group (../reader.py, unchanged): Data Set 2's 40 cultures with a loss
    set, from week 12's entry after the treatment (t = 0) to week 36 (t = 12), the adults as returned;
  - the cells are those cultures by strain and set loss: 10 cells of 4, asserted before any rule is computed;
  - cell_rules.group_verdicts at UE31's frozen constants; every cell's numbers are written, since no later design
    is planned on these cultures (DESIGN.md §9).
Usage: python3 -I -B run_cells.py XLSX OUT_JSON"""
from __future__ import annotations

import hashlib
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, os.path.dirname(HERE))
import cell_rules as C  # noqa: E402
import reader  # noqa: E402

DIGEST = '5ce9ae436bf2ae9a7a320a0edeb2dd180633dc063bebc57f16ae2319b057c9a1'


def read_cells(path):
    """The primary cultures by UE31's reader, and the cells' shape, asserted: 10 cells of 4 cultures of 13 censuses."""
    cultures, report = reader.cultures(path)
    primary = [c for c in cultures if c['group'] == 'primary']
    cells = C.cells(primary)
    shape = {'%s-%g' % k: [len(cs), sorted({len(c['A']) for c in cs})] for k, cs in cells.items()}
    assert len(cells) == 10 and all(v == [4, [13]] for v in shape.values()), shape
    return primary, report, shape


def main(path, out):
    with open(path, 'rb') as f:
        digest = hashlib.sha256(f.read()).hexdigest()
    assert digest == DIGEST, digest
    primary, report, shape = read_cells(path)
    verdicts, per = C.group_verdicts(primary)
    res = {'workbook_sha256': digest, 'reader': report, 'cells': shape, 'verdicts': verdicts, 'per_cell': per}
    with open(out, 'w') as f:
        json.dump(res, f, indent=1, sort_keys=True, default=str)
        f.write('\n')
    keys = ['cells', 'too_short_cells', 'testable', 'W', 'V2', 'H1', 'V5', 'sign', 'V4', 'reading']
    print({k: verdicts[k] for k in keys if k in verdicts})
    for k in ('W_excess', 'V2_excess', 'H1_excess', 'W_detected', 'V2_detected', 'H1_detected', 'V5_signs',
              'sign_counts', 'V4_errors', 'reported_V3', 'reported_resid_over_floor',
              'reported_rows_recruits_above_pupae', 'left_out', 'zero_columns_dropped'):
        if k in verdicts:
            print(' ', k, verdicts[k])
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1], sys.argv[2]))
