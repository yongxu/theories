"""UE31: the reader checked before it reads the archive (the run's step 2, DESIGN.md §9). Dry-run cultures are written
into a workbook in the archive's layout (LAYOUT.md: its sheets, header rows, codes, weeks and repeated weeks), and the
reader must return exactly the cultures LAYOUT.md fixes, built here directly from the same counts. Standard library
only; seed 20261103. Usage: python3 -I -B check_reader.py OUT_XLSX"""
from __future__ import annotations

import os
import random
import sys
import zipfile
from xml.sax.saxutils import escape

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import dry_runs as D  # noqa: E402
import reader  # noqa: E402

HEADERS = {
    1: ['Treatment', 'Replicate', 'Week', 'L-stage', 'P-stage', 'A-stage'],
    2: ['Strain', 'Treatment', 'Replicate', 'Week', 'L-stage', 'P-stage', 'A-stage'],
    3: ['Treatment', 'Replicate', 'mua', 'cpa', 'Week', 'L-stage', 'P-stage', 'A-stage'],
    7: ['Treatment', 'Replicate', 'Week', 'Habitat', 'L-stage', 'P-stage', 'A-stage'],
    8: ['HS', 'IC', 'Replicate', 'Week', 'Habitat', 'L-stage', 'P-stage', 'A-stage'],
    10: ['Treatment', 'Replicate', 'Week', 'Habitat', 'L-stage', 'P-stage', 'A-stage'],
}


def col(i):
    return 'ABCDEFGH'[i]


def sheet_xml(rows, strings):
    out = ['<?xml version="1.0" encoding="UTF-8"?><worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/'
           '2006/main"><sheetData>']
    for r, row in enumerate(rows, 1):
        cells = []
        for i, v in enumerate(row):
            ref = '%s%d' % (col(i), r)
            if isinstance(v, str):
                cells.append('<c r="%s" t="s"><v>%d</v></c>' % (ref, strings.index(v)))
            else:
                cells.append('<c r="%s"><v>%s</v></c>' % (ref, repr(v)))
        out.append('<row r="%d">%s</row>' % (r, ''.join(cells)))
    out.append('</sheetData></worksheet>')
    return ''.join(out)


def write(path, sheets):
    """A workbook with a 'Read Me' sheet without cells and 'Data Set n' sheets, as in the archive."""
    names = ['Read Me'] + ['Data Set %d' % n for n in range(1, 11)]
    strings = sorted({h for hs in HEADERS.values() for h in hs})
    with zipfile.ZipFile(path, 'w') as z:
        z.writestr('[Content_Types].xml', '<?xml version="1.0"?><Types xmlns="http://schemas.openxmlformats.org/'
                   'package/2006/content-types"/>')
        z.writestr('xl/workbook.xml', '<?xml version="1.0"?><workbook xmlns="http://schemas.openxmlformats.org/'
                   'spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/'
                   'relationships"><sheets>' + ''.join('<sheet name="%s" sheetId="%d" r:id="rId%d"/>'
                                                     % (escape(n), i, i) for i, n in enumerate(names, 1))
                   + '</sheets></workbook>')
        z.writestr('xl/_rels/workbook.xml.rels', '<?xml version="1.0"?><Relationships xmlns="http://schemas.'
                   'openxmlformats.org/package/2006/relationships">' + ''.join(
                       '<Relationship Id="rId%d" Target="worksheets/sheet%d.xml"/>' % (i, i)
                       for i in range(1, len(names) + 1)) + '</Relationships>')
        z.writestr('xl/sharedStrings.xml', '<?xml version="1.0"?><sst xmlns="http://schemas.openxmlformats.org/'
                   'spreadsheetml/2006/main">' + ''.join('<si><t>%s</t></si>' % escape(s) for s in strings)
                   + '</sst>')
        for i, n in enumerate(names, 1):
            ds = int(n.split()[-1]) if n.startswith('Data Set') else None
            rows = [HEADERS[ds]] + sheets[ds] if ds in sheets else []
            z.writestr('xl/worksheets/sheet%d.xml' % i, sheet_xml(rows, strings))


def counts(rng, mu, n):
    """n censuses of one dry-run culture (the dry runs' length raised for Data Set 8's longest cultures)."""
    saved, D.CENSUSES = D.CENSUSES, max(D.CENSUSES, n - 1)
    try:
        c = D.lpa_culture(rng, mu)
    finally:
        D.CENSUSES = saved
    assert len(c['A']) >= n
    return c['L'][:n], c['P'][:n], c['A'][:n]


def main(out):
    rng = random.Random(20261103)
    sheets, expected = {}, []
    # Data Set 2: 2 strains x (control, five losses) x 4 replicates, weeks 0..36, week 12 twice (before, after)
    rows = []
    for strain in (1, 2):
        for treatment in range(1, 7):
            for k in range(4):
                rep = treatment + 6 * k
                mu = reader.LOSS.get(treatment)
                L, P, A = counts(rng, mu, 19)
                pre = (L[6] + 1, P[6] + 2, A[6] + 3)          # the week-12 entry before the treatment differs
                for t in range(19):
                    if t == 6:
                        rows.append([strain, treatment, rep, 12, *pre])
                    rows.append([strain, treatment, rep, 2 * t, L[t], P[t], A[t]])
                if mu is None:
                    expected.append(('DS2-strain%d-control-rep%d' % (strain, rep), 'control', None, L, P, A))
                else:
                    expected.append(('DS2-strain%d-loss%g-rep%d' % (strain, mu, rep), 'primary', mu, L[6:], P[6:],
                                     A[6:]))
    sheets[2] = rows
    # Data Set 1: control and a perturbation, weeks 0..38, week 10 twice
    rows = []
    for treatment, reps in ((1, (1, 2)), (2, (1,))):
        for rep in reps:
            L, P, A = counts(rng, None, 20)
            for t in range(20):
                if t == 5:
                    rows.append([treatment, rep, 10, L[t] + 4, P[t], A[t]])
                rows.append([treatment, rep, 2 * t, L[t], P[t], A[t]])
            if treatment == 1:
                expected.append(('DS1-1-%d' % rep, 'control', None, L, P, A))
    sheets[1] = rows
    # Data Set 3: a control and a c_pa treatment, weeks 0..80, with the parameter columns
    rows = []
    for treatment, rep in ((1, 4), (6, 2)):
        L, P, A = counts(rng, None, 41)
        for t in range(41):
            rows.append([treatment, rep, 0.0076, 0.0046, 2 * t, L[t], P[t], A[t]])
        if treatment == 1:
            expected.append(('DS3-1-4', 'control', None, L, P, A))
    sheets[3] = rows
    # Data Sets 7 and 10: the same constant cultures in both, and cycling ones; Data Set 8: sequences 1 and 2
    rows7, rows10 = [], []
    for treatment, rep in ((1, 13), (1, 18), (2, 5)):
        L, P, A = counts(rng, None, 36)
        for t in range(36):
            rows7.append([treatment, rep, 2 * t, 20 if treatment == 1 else (32 if t % 2 else 8), L[t], P[t], A[t]])
            if treatment == 1:
                rows10.append([treatment, rep, 2 * t, 20, L[t], P[t], A[t]])
        if treatment == 1:
            expected.append(('DS7-1-%d' % rep, 'control', None, L, P, A))
    sheets[7], sheets[10] = rows7, rows10
    rows = []
    for hs, ic, rep, n in ((1, 1, 1, 39), (1, 2, 6, 71), (2, 1, 3, 39)):
        L, P, A = counts(rng, None, n)
        for t in range(n):
            rows.append([hs, ic, rep, 2 * t, 20, L[t], P[t], A[t]])
        if hs == 1:
            expected.append(('DS8-%d-%d-%d' % (hs, ic, rep), 'control', None, L, P, A))
    sheets[8] = rows
    write(out, sheets)
    got, rep = reader.cultures(out)
    g = {c['id']: (c['group'], c['mu'], c['L'], c['P'], c['A']) for c in got}
    e = {cid: (grp, mu, L, P, A) for cid, grp, mu, L, P, A in expected}
    missing, extra = sorted(set(e) - set(g)), sorted(set(g) - set(e))
    wrong = sorted(k for k in set(e) & set(g) if e[k] != g[k])
    print('expected', len(e), 'read', len(g), 'missing', missing, 'extra', extra, 'wrong', wrong)
    print('report', rep)
    ok = not missing and not extra and not wrong and all(rep['DS10 constant cultures equal to DS7'].values())
    print('READER CHECK', 'PASSED' if ok else 'FAILED')
    return 0 if ok else 1


if __name__ == '__main__':
    sys.exit(main(sys.argv[1]))
