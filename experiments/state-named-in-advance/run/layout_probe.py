"""UE31 layout probe: the workbook's structure only. Prints sheet names, header rows, and per culture the identifying
columns (codes and weeks), never a census count (L, P, A) or a parameter value. Usage: python3 -I layout_probe.py XLSX"""
import re
import sys
import zipfile
import xml.etree.ElementTree as ET

NS = {'m': 'http://schemas.openxmlformats.org/spreadsheetml/2006/main',
      'r': 'http://schemas.openxmlformats.org/officeDocument/2006/relationships'}
# per sheet (in workbook order, by the README's Data Set number): the identifying columns and the week column;
# every other column (the three stage counts, habitat size, mua, cpa) is counted only, never printed
IDS = {1: ('ABC', 'C'), 2: ('ABCD', 'D'), 3: ('ABE', 'E'), 4: ('ABC', 'C'), 5: ('ABC', 'C'), 6: ('AB', 'B'),
       7: ('ABC', 'C'), 8: ('ABCD', 'D'), 9: ('ABC', 'C'), 10: ('ABC', 'C')}


def col_of(ref):
    return re.match(r'[A-Z]+', ref).group(0)


def main(path):
    z = zipfile.ZipFile(path)
    shared = []
    if 'xl/sharedStrings.xml' in z.namelist():
        for si in ET.fromstring(z.read('xl/sharedStrings.xml')).findall('m:si', NS):
            shared.append(''.join(t.text or '' for t in si.iter('{%s}t' % NS['m'])))
    wb = ET.fromstring(z.read('xl/workbook.xml'))
    rels = ET.fromstring(z.read('xl/_rels/workbook.xml.rels'))
    target = {r.get('Id'): r.get('Target') for r in rels}
    sheets = [(s.get('name'), target[s.get('{%s}id' % NS['r'])]) for s in wb.find('m:sheets', NS)]
    print('sheets:', [s for s, _ in sheets])
    for k0, (name, tgt) in enumerate(sheets, 1):
        k = int(name.split()[-1]) if name.startswith('Data Set') else 0
        x = ET.fromstring(z.read('xl/' + tgt.lstrip('/').replace('xl/', '')))
        rows = x.find('m:sheetData', NS).findall('m:row', NS)
        if not rows:
            print(f'\n== {name!r}: no rows'); continue
        def cells(row):
            out = {}
            for c in row.findall('m:c', NS):
                v = c.find('m:v', NS)
                t = c.get('t')
                if t == 's' and v is not None:
                    out[col_of(c.get('r'))] = ('s', shared[int(v.text)])
                elif t == 'inlineStr':
                    out[col_of(c.get('r'))] = ('s', ''.join(e.text or '' for e in c.iter('{%s}t' % NS['m'])))
                elif v is not None:
                    out[col_of(c.get('r'))] = ('n', v.text)
            return out
        head = cells(rows[0])
        print(f'\n== sheet {k} {name!r}: {len(rows)} rows; header:',
              {c: (v if t == 's' else '<number>') for c, (t, v) in sorted(head.items())})
        if k not in IDS:
            continue
        idcols, wk = IDS[k]
        cultures, blanks, ncols = {}, 0, set()
        for row in rows[1:]:
            cs = cells(row)
            ncols.add(len(cs))
            key = tuple(cs.get(c, ('', ''))[1] for c in idcols if c != wk)
            week = cs.get(wk, ('', ''))[1]
            cultures.setdefault(key, []).append(week)
            blanks += sum(1 for c in 'ABCDEFGH'[:max(len(cs), 1)] if c not in cs)
        print(f'   cells per record: {sorted(ncols)}; blank cells among the first columns: {blanks}; cultures: {len(cultures)}')
        for key, weeks in sorted(cultures.items(), key=lambda kv: [float(x) if x.replace(".", "").isdigit() else 0 for x in kv[0]]):
            w = [float(x) for x in weeks]
            dup = sorted({x for x in w if w.count(x) > 1})
            steps = sorted({round(b - a, 3) for a, b in zip(w, w[1:])})
            print(f'   {key}: {len(w)} records, weeks {min(w):g}..{max(w):g}, steps {steps}, repeated {dup}')


if __name__ == '__main__':
    main(sys.argv[1])
