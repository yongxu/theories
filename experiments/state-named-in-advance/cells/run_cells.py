"""UE31b's run (cells/DESIGN.md §9), frozen with the design and not yet run: the cell rules on the archive's adult-loss
cultures, the output kept whatever it is. Standard library only; the workbook is untrusted data, so run with
python3 -I -B.

Fixed before the run, with none of these cultures' values read:
  - the workbook's sha-256 must equal the digest Dryad publishes (../LAYOUT.md), the file UE31's run read;
  - the cultures are UE31's reader's primary group (../reader.py, unchanged): Data Set 2's 40 cultures with a loss
    set, from week 12's entry after the treatment (t = 0) to week 36 (t = 12), the adults as returned;
  - the cells are those cultures by strain and set loss: 10 cells of 4, asserted before any rule is computed;
  - week 12 (DESIGN.md §7): the reader keeps a week's later entry. The set losses from 0.27 on exceed both estimates
    of the adults' natural loss the design uses (0.007629 and the recalled set's 0.1108), so there the treatment
    removes adults, and in each culture the entry with fewer adults is read as the one after it (the later where they
    hold the same). At 0.04 the treatment may add adults, so each culture there is read at the position, earlier or
    later in the sheet, that its strain's cultures from 0.27 on mostly show (the later on a tie);
  - cell_rules.group_verdicts at UE31's frozen constants, with its recording check; every cell's numbers are
    written, since no later design is planned on these cultures (DESIGN.md §9), unless the recording check stops the
    reading: then only the check, the labels and the counts of cells are written, and every cell's numbers and
    statistics are withheld, so that a design for the recording found can still be made blind.
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
REMOVES = 0.27   # the set losses from here on exceed both natural-loss estimates (0.007629; the recalled set's 0.1108)
KEPT = ('cells', 'too_short', 'too_short_cells', 'testable', 'protocol', 'protocol_rows') + C.VERDICTS


def read_cells(path):
    """The primary cultures by UE31's reader, and the cells' shape, asserted: 10 cells of 4 cultures of 13 censuses."""
    cultures, report = reader.cultures(path)
    primary = [c for c in cultures if c['group'] == 'primary']
    cells = C.cells(primary)
    shape = {'%s-%g' % k: [len(cs), sorted({len(c['A']) for c in cs})] for k, cs in cells.items()}
    assert len(cells) == 10 and all(v == [4, [13]] for v in shape.values()), shape
    return primary, report, shape


def week12(path):
    """Week 12's two entries in sheet order, culture by culture, keyed by the reader's culture id. From 0.27 on the
    one read at t = 0 is the one with fewer adults, the later where they hold the same; at 0.04 it is the one at the
    position its strain's cultures from 0.27 on mostly show, the later on a tie. And the report of which was read,
    how the losses from 0.27 on show the sheet's order, what the entry read at 0.04 holds, and how many cultures hold
    the same larvae and pupae in both entries."""
    ids, wk, stages = reader.COLUMNS[2]
    by = {}
    for rec in reader.workbook(path)[2]:
        strain, treatment, rep = (rec[c] for c in ids)
        if treatment in reader.LOSS:
            cid = 'DS2-strain%d-loss%g-rep%d' % (strain, reader.LOSS[treatment], rep)
            by.setdefault(cid, [strain, reader.LOSS[treatment], []])
            if rec[wk] == reader.ONSET:
                by[cid][2].append([rec[c] for c in stages])
    two = {cid: v for cid, v in by.items() if len(v[2]) == 2}
    later = {cid: v[2] <= u[2] for cid, (_, mu, (u, v)) in two.items() if mu >= REMOVES}
    position = {}
    for strain in sorted({v[0] for v in two.values()}):
        votes = [later[cid] for cid in later if two[cid][0] == strain]
        position[strain] = 2 * sum(votes) >= len(votes)
    for cid, (strain, mu, _) in two.items():
        if mu < REMOVES:
            later[cid] = position[strain]
    read = {cid: v[2][1] if later[cid] else v[2][0] for cid, v in two.items()}
    other = {cid: v[2][0] if later[cid] else v[2][1] for cid, v in two.items()}
    high = [v[2] for v in two.values() if v[1] >= REMOVES]
    low = {strain: [c for c, v in two.items() if v[0] == strain and v[1] < REMOVES] for strain in position}
    report = {'cultures': len(by), 'with two entries': len(two),
              'the earlier read': sum(1 for cid in two if not later[cid]),
              'the later read': sum(1 for cid in two if later[cid]),
              'from 0.27 on: the later holds fewer adults, the earlier holds fewer, the same':
                  [sum(1 for u, v in high if v[2] < u[2]), sum(1 for u, v in high if u[2] < v[2]),
                   sum(1 for u, v in high if u[2] == v[2])],
              'at 0.04 by strain: the position read, and in how many of its cultures the entry read holds fewer '
              'adults than the other': {strain: ['later' if position[strain] else 'earlier',
                                                 sum(1 for c in cs if read[c][2] < other[c][2]),
                                                 len(cs)] for strain, cs in low.items()},
              'same larvae and pupae in both': sum(1 for v in two.values() if v[2][0][:2] == v[2][1][:2])}
    return read, report


def read(path):
    """Everything the run reads, the digest apart: the cells, week 12's entry and the verdicts; every cell's numbers
    and statistics withheld if the recording check stops the reading."""
    primary, report, shape = read_cells(path)
    entries, order = week12(path)
    for c in primary:
        if c['id'] in entries:
            c['L'][0], c['P'][0], c['A'][0] = entries[c['id']]
    verdicts, per = C.group_verdicts(primary)
    verdicts['week12'] = order
    if verdicts['protocol'] != C.PROTOCOL_AGREES:
        verdicts = {k: v for k, v in verdicts.items() if k in KEPT + ('week12',)}
        per = 'withheld: ' + C.PROTOCOL_DISAGREES
    return {'reader': report, 'cells': shape, 'verdicts': verdicts, 'per_cell': per}


def main(path, out):
    with open(path, 'rb') as f:
        digest = hashlib.sha256(f.read()).hexdigest()
    assert digest == DIGEST, digest
    res = dict(read(path), workbook_sha256=digest)
    verdicts = res['verdicts']
    with open(out, 'w') as f:
        json.dump(res, f, indent=1, sort_keys=True, default=str)
        f.write('\n')
    keys = ['cells', 'too_short_cells', 'testable', 'protocol', 'W', 'V2', 'H1', 'V5', 'sign', 'V4', 'reading']
    print({k: verdicts[k] for k in keys if k in verdicts})
    for k in ('W_excess', 'V2_excess', 'H1_excess', 'W_detected', 'V2_detected', 'H1_detected', 'V5_signs',
              'sign_counts', 'V4_errors', 'reported_V3', 'reported_resid_over_floor',
              'reported_rows_recruits_above_pupae', 'protocol_rows', 'week12', 'left_out',
              'zero_columns_dropped'):
        if k in verdicts:
            print(' ', k, verdicts[k])
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1], sys.argv[2]))
