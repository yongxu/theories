"""UE31's run, step 3 (DESIGN.md §9): group_verdicts on the primary and control groups at both grains, the output kept
whatever it is. Standard library only; the workbook is untrusted data, so run with python3 -I -B.

Fixed before the run, with no census value read:
  - the workbook's sha-256 must equal the digest Dryad publishes (LAYOUT.md);
  - the census grain: group_verdicts(cultures) at the frozen constants;
  - the coarser grain (reported only, DESIGN.md §5): every other census from t = 0, the set loss compounded over two steps
    (1 - (1 - mu)^2, as in the dry runs), group_verdicts(cultures, coarse=True) at the frozen constants; beside it, also
    reported, the threshold the dry runs used at that grain (15 rows a culture);
  - no per-culture number of a primary culture is written, read or not, so that a later design may still be made before
    any of their values is seen; the controls' per-culture numbers are kept.
Usage: python3 -I -B run.py XLSX OUT_JSON"""
from __future__ import annotations

import hashlib
import json
import os
import sys

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, HERE)
import reader  # noqa: E402
import state_rules as R  # noqa: E402

DIGEST = '5ce9ae436bf2ae9a7a320a0edeb2dd180633dc063bebc57f16ae2319b057c9a1'
DRY_RUNS_COARSE_ROWS = 15


def coarse(c):
    mu = c['mu']
    return {'id': c['id'], 'group': c['group'], 'mu': None if mu is None else 1 - (1 - mu) ** 2,
            'L': c['L'][::2], 'P': c['P'][::2], 'A': c['A'][::2]}


def main(path, out):
    with open(path, 'rb') as f:
        digest = hashlib.sha256(f.read()).hexdigest()
    assert digest == DIGEST, digest
    cultures, report = reader.cultures(path)
    res = {'workbook_sha256': digest, 'reader': report, 'groups': {}}
    for group in ('primary', 'control'):
        cs = [c for c in cultures if c['group'] == group]
        rows = sorted({len(R.reading(c)['rows']) for c in cs})
        g = {'cultures': len(cs), 'rows_a_culture': rows}
        for grain, kw in (('census', {}), ('coarse', {'coarse': True}),
                          ('coarse, dry runs threshold', {'coarse': True, 'min_rows': DRY_RUNS_COARSE_ROWS})):
            use = [coarse(c) for c in cs] if kw.get('coarse') else cs
            verdicts, per = R.group_verdicts(use, **kw)
            g[grain] = {'verdicts': verdicts}
            if group == 'control':
                g[grain]['per_culture'] = per
            else:
                g[grain]['per_culture_read'] = len(per)
        res['groups'][group] = g
    with open(out, 'w') as f:
        json.dump(res, f, indent=1, sort_keys=True, default=str)
    for group, g in res['groups'].items():
        print(group, 'cultures', g['cultures'], 'rows a culture', g['rows_a_culture'])
        for grain in ('census', 'coarse', 'coarse, dry runs threshold'):
            v = g[grain]['verdicts']
            keys = [k for k in ('cultures', 'too_short', 'testable', 'W', 'H1', 'V2', 'sign', 'V4', 'reading')
                    if k in v]
            print('  %-27s' % grain, {k: v[k] for k in keys})
    print('reader', report)
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1], sys.argv[2]))
