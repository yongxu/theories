"""UE31b's run (cells/DESIGN.md §9), frozen with the design and not yet run: the cell rules on the archive's adult-loss
cultures, the output kept whatever it is. Standard library only; the workbook is untrusted data, so run with
python3 -I -B.

Fixed before the run, with none of these cultures' values read:
  - the workbook's sha-256 must equal the digest Dryad publishes (../LAYOUT.md), the file UE31's run read;
  - the cultures are UE31's reader's primary group (../reader.py, unchanged): Data Set 2's 40 cultures with a loss
    set, from week 12's entry after the treatment (t = 0) to week 36 (t = 12), the adults as returned;
  - the cells are those cultures by strain and set loss: 10 cells of 4, asserted before any rule is computed;
  - week 12's order (DESIGN.md §7): the reader keeps a week's later entry, taken to be the one after the manipulation.
    At the three largest losses, which take half or more of the adults, the entry after it holds fewer. If the later
    entry holds no more adults than the earlier in all 24 cultures at those losses and fewer in at least 20, it is
    read; else, if the earlier entry does so, the earlier is read at t = 0 in every culture; else no verdict is read;
  - cell_rules.group_verdicts at UE31's frozen constants, with its recording check; every cell's numbers are
    written, since no later design is planned on these cultures (DESIGN.md §9).
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
ORDER_LOSSES = (0.50, 0.73, 0.96)   # losses at which the entry after the manipulation must hold fewer adults
ORDER_FEWER = 20                    # of the 24 cultures at those losses
ORDER_FAILED = "not read: neither of week 12's entries is the one after the treatment in every culture"


def read_cells(path):
    """The primary cultures by UE31's reader, and the cells' shape, asserted: 10 cells of 4 cultures of 13 censuses."""
    cultures, report = reader.cultures(path)
    primary = [c for c in cultures if c['group'] == 'primary']
    cells = C.cells(primary)
    shape = {'%s-%g' % k: [len(cs), sorted({len(c['A']) for c in cs})] for k, cs in cells.items()}
    assert len(cells) == 10 and all(v == [4, [13]] for v in shape.values()), shape
    return primary, report, shape


def week12_order(path):
    """Week 12's two entries in sheet order, culture by culture, keyed by the reader's culture id; which of them is
    the one after the treatment, as the largest losses show it ('later', 'earlier' or None); and, reported only, how
    many cultures hold the same larvae and pupae in both entries."""
    ids, wk, stages = reader.COLUMNS[2]
    by = {}
    for rec in reader.workbook(path)[2]:
        strain, treatment, rep = (rec[c] for c in ids)
        if treatment in reader.LOSS:
            cid = 'DS2-strain%d-loss%g-rep%d' % (strain, reader.LOSS[treatment], rep)
            by.setdefault(cid, [treatment, []])
            if rec[wk] == reader.ONSET:
                by[cid][1].append([rec[c] for c in stages])
    two = {cid: v for cid, (_, v) in by.items() if len(v) == 2}
    high = [two[cid] for cid, (tr, _) in by.items() if cid in two and reader.LOSS[tr] in ORDER_LOSSES]
    report = {'cultures': len(by), 'with two entries': len(two), 'at the largest losses': len(high),
              'same larvae and pupae in both': sum(1 for a, b in two.values() if a[:2] == b[:2])}
    which = None
    for name, after, before in (('later', 1, 0), ('earlier', 0, 1)):
        no_more = sum(1 for v in high if v[after][2] <= v[before][2])
        fewer = sum(1 for v in high if v[after][2] < v[before][2])
        report['%s holds no more adults; fewer' % name] = [no_more, fewer]
        if which is None and len(two) == len(by) == 40 and len(high) == 24 and no_more == 24 and fewer >= ORDER_FEWER:
            which = name
    report['read at t = 0'] = which
    return which, two, report


def read(path):
    """Everything the run reads, the digest apart: the cells, week 12's order and the verdicts."""
    primary, report, shape = read_cells(path)
    which, entries, order = week12_order(path)
    if which == 'earlier':
        for c in primary:
            c['L'][0], c['P'][0], c['A'][0] = entries[c['id']][0]
    verdicts, per = C.group_verdicts(primary)
    verdicts['week12_order'] = order
    if which is None:
        for k in C.VERDICTS:
            if k in verdicts:
                verdicts[k] = ORDER_FAILED
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
              'reported_rows_recruits_above_pupae', 'protocol_rows', 'week12_order', 'left_out',
              'zero_columns_dropped'):
        if k in verdicts:
            print(' ', k, verdicts[k])
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1], sys.argv[2]))
