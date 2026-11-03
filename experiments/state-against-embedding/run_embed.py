"""UE32's run (DESIGN.md), frozen with the design and not yet run: the rules on MQ5's stocks, the output kept whatever
it is. Standard library only; the workbook is downloaded data, so run with python3 -I -B.

Fixed before the run:
  - the workbook is RAM Legacy v4.66's assessment data, the one MQ3 to MQ5 read (Zenodo record 14043031, the archive's
    md5 ed6d7cd3f7da1fdcbc60015c3d65014b checked when it is downloaded); its sha-256 is written with the output;
  - the stocks are MQ5's, read by MQ5's own code (../margin-measured/mq5.py: selection, load_values, stocks_of, the SSB
    reading), and before any rule is computed each group's stocks must equal MQ5's committed fits (stock, assessment,
    years, last training year, the draw's share and the level's scale exactly, and the level law's two coefficients,
    which depend on the series' values, within a relative 1e-9), or the run stops;
  - Python 3.11, this machine's python3 (3.11.2), which MQ5's run presumably used (its version was not recorded); 3.12
    changed how a float sum rounds, which could move a near-tie in the draw's share and stop the run at the check, so
    any other version stops the run; the version is written with the output;
  - before any rule is computed, the median in-sample S3 excess of the primary and other groups, as MQ5's code computes
    it, must reproduce MQ5's committed values within a relative 1e-9, a check on the series' values themselves;
  - embed_rules.group_verdicts on each group; the primary group's verdict is the test's, the control and other groups'
    are reported;
  - reported beside it: each stock's in-sample S3 excess as MQ5 computes it (mq5.insample, mq5.excess_of from M3 to
    M4), and the median r over the testable stocks at or above MQ5's bound and below it.
Usage: python3 -I -B run_embed.py XLSX OUT_JSON"""
from __future__ import annotations

import hashlib
import json
import math
import os
import statistics
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
MQ = os.path.join(os.path.dirname(HERE), 'margin-measured')
sys.path.insert(0, HERE)
sys.path.insert(0, MQ)
import embed_rules as R  # noqa: E402
import mq3  # noqa: E402
import mq5  # noqa: E402

GROUPS = ('primary', 'control', 'other')


def key(s):
    return [s['stockid'], s['assessid'], s['years'][0], s['years'][1], s['train_to'], round(s['kappa'], 6),
            float('%.6g' % s['scale_t'])]


def committed():
    with open(os.path.join(MQ, 'results', 'mq5', 'VERDICTS-mq5.json')) as f:
        fits = json.load(f)['fits']
    return ({g: sorted(key(s) for s in fits.get(g, [])) for g in GROUPS},
            {g: {(s['stockid'], s['assessid']): (s['a'], s['b']) for s in fits.get(g, [])} for g in GROUPS})


class NotMQ5sStocks(Exception):
    pass


def s3_check(groups):
    """MQ5's committed S3 medians reproduced from the stocks' values, before any rule is computed."""
    with open(os.path.join(MQ, 'results', 'mq5', 'VERDICTS-mq5.json')) as f:
        v = json.load(f)
    for g in ('primary', 'other'):
        xs = [x for x in (s3_excess(s) for s in groups.get(g, [])) if x is not None]
        want = v[g]['state']['S3_median_excess']
        if not xs or not math.isclose(statistics.median(xs), want, rel_tol=1e-9):
            raise NotMQ5sStocks((g, 'S3 median', statistics.median(xs) if xs else None, want))


def stocks(xlsx):
    """MQ5's stocks, as mq5.test reads them, asserted equal to its committed fits."""
    sel = mq5.selection(xlsx)
    chosen = set(sel['chosen'].values())
    ts = mq5.load_values(xlsx, chosen)
    cat = mq3.method_categories(xlsx)
    groups, _ = mq5.stocks_of(ts, sel['A'], cat, chosen, 'SSB')
    got = {g: sorted(key({'stockid': s['stockid'], 'assessid': s['assessid'], 'years': [s['run'][0], s['run'][-1]],
                          'train_to': s['train'][-1] if s['train'] else None, 'kappa': s['kappa'],
                          'scale_t': s['scale']})
                     for s in groups.get(g, [])) for g in GROUPS}
    want, laws = committed()
    for g in GROUPS:
        if got[g] != want[g]:
            raise NotMQ5sStocks((g, len(got[g]), len(want[g])))
        for s in groups.get(g, []):
            a, b = laws[g][(s['stockid'], s['assessid'])]
            if not (math.isclose(s['fit'][0], a, rel_tol=1e-9) and math.isclose(s['fit'][1], b, rel_tol=1e-9)):
                raise NotMQ5sStocks((g, s['stockid'], 'level law', s['fit'][:2], (a, b)))
    return groups


def s3_excess(st):
    r = mq5.insample(st)
    return None if r is None else mq5.excess_of(r, 'M3', 'M4')


def by_s3(per):
    """The median r over the testable stocks whose MQ5 S3 excess is at or above MQ5's bound, and below it."""
    out = {}
    for side, keep in (('at_or_above', lambda x: x >= mq5.NEEDED), ('below', lambda x: x < mq5.NEEDED)):
        rs = [p['r'] for p in per if p['testable'] and p['mq5_s3_excess'] is not None and keep(p['mq5_s3_excess'])]
        out[side] = {'stocks': len(rs), 'median_r': statistics.median(rs) if rs else None}
    return out


def main(xlsx, out):
    if sys.version_info[:2] != (3, 11):
        raise NotMQ5sStocks(('Python', sys.version))
    with open(xlsx, 'rb') as f:
        digest = hashlib.sha256(f.read()).hexdigest()
    groups = stocks(xlsx)
    s3_check(groups)
    shas = {}
    for name in ('embed_rules.py', 'run_embed.py', os.path.join('..', 'margin-measured', 'mq5.py')):
        with open(os.path.join(HERE, name), 'rb') as f:
            shas[os.path.basename(name)] = hashlib.sha256(f.read()).hexdigest()
    res = {'workbook_sha256': digest, 'python': sys.version, 'code_sha256': shas, 'groups': {}}
    for g in GROUPS:
        verdicts, per = R.group_verdicts(groups.get(g, []))
        per = [dict(p, stockid=s['stockid'], mq5_s3_excess=s3_excess(s)) for p, s in zip(per, groups.get(g, []))]
        verdicts['reported_r_by_mq5_s3'] = by_s3(per)
        res['groups'][g] = {'verdicts': verdicts, 'per_stock': per}
        print(g, {k: verdicts.get(k) for k in ('stocks', 'testable', 'fitted', 'reading', 'median_r', 'f_better',
                                               'n_better', 'p', 'dims')})
    with open(out, 'w') as f:
        json.dump(res, f, indent=1, sort_keys=True, default=str)
        f.write('\n')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1], sys.argv[2]))
