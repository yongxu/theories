"""Read the RAM Legacy database's files with the standard library only (MQ3).

  python3 -I ram_read.py docx FILE.docx            text of a Word document
  python3 -I ram_read.py sheets FILE.xlsx          sheet names, with each sheet's row and column counts
  python3 -I ram_read.py header FILE.xlsx SHEET    the first row only (column names)
  python3 -I ram_read.py dump FILE.xlsx SHEET      every row, tab-separated (documentation workbooks only)

An xlsx file is a zip of XML parts; a docx file likewise. `header` reads the first row of a sheet and
stops, so a data sheet's values are not read; MQ3's freeze uses it on the data workbook before any value.
"""
from __future__ import annotations

import re
import sys
import zipfile
import xml.etree.ElementTree as ET

NS = {'m': 'http://schemas.openxmlformats.org/spreadsheetml/2006/main',
      'r': 'http://schemas.openxmlformats.org/officeDocument/2006/relationships',
      'w': 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'}
REL = '{http://schemas.openxmlformats.org/officeDocument/2006/relationships}id'


def docx_text(path):
    with zipfile.ZipFile(path) as z:
        root = ET.fromstring(z.read('word/document.xml'))
    out = []
    for p in root.iter('{%s}p' % NS['w']):
        out.append(''.join(t.text or '' for t in p.iter('{%s}t' % NS['w'])))
    return '\n'.join(out)


def _shared(z):
    try:
        data = z.read('xl/sharedStrings.xml')
    except KeyError:
        return []
    strings = []
    for _, el in ET.iterparse(__import__('io').BytesIO(data)):
        if el.tag == '{%s}si' % NS['m']:
            strings.append(''.join(t.text or '' for t in el.iter('{%s}t' % NS['m'])))
            el.clear()
    return strings


def _sheet_paths(z):
    wb = ET.fromstring(z.read('xl/workbook.xml'))
    rels = ET.fromstring(z.read('xl/_rels/workbook.xml.rels'))
    target = {r.get('Id'): r.get('Target') for r in rels}
    out = {}
    for s in wb.find('m:sheets', NS):
        t = target[s.get(REL)]
        t = t.lstrip('/')
        out[s.get('name')] = t if t.startswith('xl/') else 'xl/' + t
    return out


def _col(ref):
    letters = re.match(r'[A-Z]+', ref).group(0)
    n = 0
    for ch in letters:
        n = n * 26 + ord(ch) - 64
    return n - 1


def rows(path, sheet, limit=None):
    """Yield rows of a sheet as lists of strings (shared strings resolved, numbers as written)."""
    with zipfile.ZipFile(path) as z:
        strings = _shared(z)
        part = _sheet_paths(z)[sheet]
        with z.open(part) as f:
            count = 0
            for _, el in ET.iterparse(f):
                if el.tag != '{%s}row' % NS['m']:
                    continue
                cells = {}
                for c in el.findall('m:c', NS):
                    v = c.find('m:v', NS)
                    if c.get('t') == 's' and v is not None:
                        val = strings[int(v.text)]
                    elif c.get('t') == 'inlineStr':
                        val = ''.join(t.text or '' for t in c.iter('{%s}t' % NS['m']))
                    else:
                        val = v.text if v is not None else ''
                    cells[_col(c.get('r'))] = val
                el.clear()
                width = max(cells) + 1 if cells else 0
                yield [cells.get(i, '') for i in range(width)]
                count += 1
                if limit is not None and count >= limit:
                    return


def sheets(path):
    with zipfile.ZipFile(path) as z:
        paths = _sheet_paths(z)
        out = []
        for name, part in paths.items():
            with z.open(part) as f:
                head = f.read(4096).decode('utf-8', 'replace')
            dim = re.search(r'<dimension ref="([^"]+)"', head)
            out.append((name, dim.group(1) if dim else '?'))
    return out


def main(argv):
    cmd, path = argv[1], argv[2]
    if cmd == 'docx':
        print(docx_text(path))
    elif cmd == 'sheets':
        for name, dim in sheets(path):
            print(f'{name}\t{dim}')
    elif cmd == 'header':
        for r in rows(path, argv[3], limit=1):
            print('\t'.join(r))
    elif cmd == 'dump':
        for r in rows(path, argv[3]):
            print('\t'.join(r))
    else:
        raise SystemExit(__doc__)


if __name__ == '__main__':
    main(sys.argv)
