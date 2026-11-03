"""UE31's reader, the run's step 2 (DESIGN.md §9): the Beetle Team archive's workbook turned into the cultures of
state_rules.py, as LAYOUT.md fixes them. Standard library only; the workbook is untrusted data, so run with python3 -I.

The groups (LAYOUT.md):
  primary  Data Set 2, treatments 2 to 6 (adult loss 0.04, 0.27, 0.50, 0.73, 0.96 per census step), from week 12's entry
           after the treatment (t = 0) to the last census; the adults as returned after each census
  control  Data Set 1 treatment 1, Data Set 2 treatment 1, Data Set 3 treatment 1, Data Set 7 treatment 1 (constant
           habitat) and Data Set 8 habitat sequence 1 (constant habitat), every census; Data Set 10's constant cultures
           repeat Data Set 7's replicate numbers and are taken once, from Data Set 7, after a check that they agree
A week entered twice (the perturbation or treatment week) is read at its second entry, the one after the manipulation.
"""
from __future__ import annotations

import re
import sys
import zipfile
import xml.etree.ElementTree as ET

NS = {'m': 'http://schemas.openxmlformats.org/spreadsheetml/2006/main',
      'r': 'http://schemas.openxmlformats.org/officeDocument/2006/relationships'}
LOSS = {2: 0.04, 3: 0.27, 4: 0.50, 5: 0.73, 6: 0.96}   # Data Set 2's treatment codes (the archive's README)
ONSET = 12                                            # Data Set 2: the week the loss is first set
# per data set: the identifying columns, the week column and the three stage columns
COLUMNS = {1: ('AB', 'C', 'DEF'), 2: ('ABC', 'D', 'EFG'), 3: ('AB', 'E', 'FGH'), 7: ('AB', 'C', 'EFG'),
           8: ('ABC', 'D', 'FGH'), 10: ('AB', 'C', 'EFG')}


def number(text):
    x = float(text)
    return int(x) if x == int(x) else x


def workbook(path):
    """{data set number: [ {column letter: value} for each record ]}, header rows dropped."""
    z = zipfile.ZipFile(path)
    shared = []
    if 'xl/sharedStrings.xml' in z.namelist():
        for si in ET.fromstring(z.read('xl/sharedStrings.xml')).findall('m:si', NS):
            shared.append(''.join(t.text or '' for t in si.iter('{%s}t' % NS['m'])))
    wb = ET.fromstring(z.read('xl/workbook.xml'))
    rels = {r.get('Id'): r.get('Target') for r in ET.fromstring(z.read('xl/_rels/workbook.xml.rels'))}
    out = {}
    for s in wb.find('m:sheets', NS):
        name = s.get('name')
        if not name.startswith('Data Set '):
            continue
        x = ET.fromstring(z.read('xl/' + rels[s.get('{%s}id' % NS['r'])].split('xl/')[-1]))
        records = []
        for row in x.find('m:sheetData', NS).findall('m:row', NS)[1:]:
            rec = {}
            for c in row.findall('m:c', NS):
                v = c.find('m:v', NS)
                col = re.match(r'[A-Z]+', c.get('r')).group(0)
                if c.get('t') == 's' and v is not None:
                    rec[col] = shared[int(v.text)]
                elif v is not None:
                    rec[col] = number(v.text)
            records.append(rec)
        out[int(name.split()[-1])] = records
    return out


def series(records, ds):
    """{identifying codes: (weeks, L, P, A)}, in sheet order, a week entered twice read at its second entry."""
    ids, wk, stages = COLUMNS[ds]
    by = {}
    for rec in records:
        key = tuple(rec[c] for c in ids)
        by.setdefault(key, []).append((rec[wk], [rec[c] for c in stages]))
    out = {}
    for key, rows in by.items():
        kept = {}
        for week, counts in rows:
            kept[week] = counts                      # a repeated week keeps its later (post-manipulation) entry
        weeks = sorted(kept)
        assert all(b - a == 2 for a, b in zip(weeks, weeks[1:])), (ds, key, 'weeks not every two')
        repeats = [w for w in weeks if sum(1 for x, _ in rows if x == w) > 1]
        assert len(repeats) <= 1 and all(sum(1 for x, _ in rows if x == w) == 2 for w in repeats), (ds, key, repeats)
        out[key] = (weeks, [kept[w][0] for w in weeks], [kept[w][1] for w in weeks], [kept[w][2] for w in weeks])
    return out


def culture(cid, group, mu, s, start=None):
    weeks, L, P, A = s
    i = weeks.index(start) if start is not None else 0
    return {'id': cid, 'group': group, 'mu': mu, 'L': L[i:], 'P': P[i:], 'A': A[i:], 'weeks': weeks[i:]}


def cultures(path):
    """The cultures of the primary and control groups, and the reader's report."""
    wb = workbook(path)
    out, report = [], {}
    ds2 = series(wb[2], 2)
    for (strain, treatment, rep), s in sorted(ds2.items()):
        if treatment in LOSS:
            out.append(culture('DS2-strain%d-loss%g-rep%d' % (strain, LOSS[treatment], rep), 'primary',
                               LOSS[treatment], s, start=ONSET))
        elif treatment == 1:
            out.append(culture('DS2-strain%d-control-rep%d' % (strain, rep), 'control', None, s))
    for ds, keep in ((1, lambda k: k[0] == 1), (3, lambda k: k[0] == 1), (7, lambda k: k[0] == 1),
                     (8, lambda k: k[0] == 1)):
        for key, s in sorted(series(wb[ds], ds).items()):
            if keep(key):
                out.append(culture('DS%d-%s' % (ds, '-'.join(str(k) for k in key)), 'control', None, s))
    ds7, ds10 = series(wb[7], 7), series(wb[10], 10)
    same = {key: ds10.get(key) == s for key, s in ds7.items() if key[0] == 1}
    report['DS10 constant cultures equal to DS7'] = {'-'.join(str(k) for k in key): v for key, v in same.items()}
    report['cultures'] = {g: sum(1 for c in out if c['group'] == g) for g in ('primary', 'control')}
    return out, report


if __name__ == '__main__':
    cs, rep = cultures(sys.argv[1])
    print(rep)
    for c in cs:
        print(c['id'], c['group'], c['mu'], len(c['A']), 'censuses, weeks', c['weeks'][0], '-', c['weeks'][-1])
