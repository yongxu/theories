#!/usr/bin/env python3
"""Write the re-coding sheet as SHEET.xlsx beside SHEET.tsv, for coders whose spreadsheet program garbles UTF-8
text files (the cold read of 25 October 2026, F10). Standard library only; the output is byte for byte the same on
every run (fixed zip times), so FREEZE.md can give its sha256.

The workbook has one sheet with the TSV's columns and rows unchanged, the header frozen, long text wrapped, and
dropdowns on `class` (the codebook's eight codes) and `confidence` (高, 中, 低). agreement.py reads a returned .xlsx
as it reads a .tsv. Run from anywhere: python3 -B make_sheet_xlsx.py"""
import csv
import zipfile
from pathlib import Path
from xml.sax.saxutils import escape

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[5]
TSV = ROOT / 'theories/becoming/review/recoding/SHEET.tsv'
OUT = TSV.with_suffix('.xlsx')
CODES = ['甲', '乙', '丙一', '丁', '戊', '己', '庚', '未读出']
CONFIDENCE = ['高', '中', '低']
WIDTH = {'n': 6, 'id': 16, 'text': 22, 'section': 14, 'unit_type': 10, 'before': 36, 'unit': 48, 'after': 36,
         'class': 10, 'confidence': 12, 'note': 40}
WRAP = {'before', 'unit', 'after', 'note', 'section'}


def col(i):
    s = ''
    i += 1
    while i:
        i, r = divmod(i - 1, 26)
        s = chr(65 + r) + s
    return s


def cell(ref, value, style):
    v = escape(value)
    space = ' xml:space="preserve"' if value != value.strip() else ''
    return f'<c r="{ref}" t="inlineStr" s="{style}"><is><t{space}>{v}</t></is></c>'


def main():
    with open(TSV, encoding='utf-8', newline='') as f:
        rows = list(csv.reader(f, delimiter='\t'))
    header, body = rows[0], rows[1:]
    last = col(len(header) - 1)
    n = len(rows)
    xml_rows = []
    for r, values in enumerate(rows, start=1):
        cells = []
        for c, value in enumerate(values):
            style = 1 if r == 1 else (2 if header[c] in WRAP else 0)
            cells.append(cell(f'{col(c)}{r}', value, style))
        xml_rows.append(f'<row r="{r}">{"".join(cells)}</row>')
    cols = ''.join(f'<col min="{i + 1}" max="{i + 1}" width="{WIDTH.get(h, 12)}" customWidth="1"/>'
                   for i, h in enumerate(header))
    ci, fi = col(header.index('class')), col(header.index('confidence'))
    validations = (
        '<dataValidations count="2">'
        f'<dataValidation type="list" allowBlank="1" showErrorMessage="1" errorTitle="码" '
        f'error="只用编码手册之八码" sqref="{ci}2:{ci}{n}"><formula1>"{",".join(CODES)}"</formula1></dataValidation>'
        f'<dataValidation type="list" allowBlank="1" showErrorMessage="1" sqref="{fi}2:{fi}{n}">'
        f'<formula1>"{",".join(CONFIDENCE)}"</formula1></dataValidation>'
        '</dataValidations>')
    sheet = ('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n'
             '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">'
             f'<dimension ref="A1:{last}{n}"/>'
             '<sheetViews><sheetView workbookViewId="0"><pane ySplit="1" topLeftCell="A2" activePane="bottomLeft" '
             'state="frozen"/></sheetView></sheetViews>'
             f'<cols>{cols}</cols><sheetData>{"".join(xml_rows)}</sheetData>{validations}'
             '<pageMargins left="0.5" right="0.5" top="0.5" bottom="0.5" header="0.3" footer="0.3"/></worksheet>')
    styles = ('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n'
              '<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">'
              '<fonts count="2"><font><sz val="11"/><name val="Calibri"/></font>'
              '<font><b/><sz val="11"/><name val="Calibri"/></font></fonts>'
              '<fills count="2"><fill><patternFill patternType="none"/></fill><fill><patternFill patternType="gray125"/></fill></fills>'
              '<borders count="1"><border><left/><right/><top/><bottom/><diagonal/></border></borders>'
              '<cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>'
              '<cellXfs count="3"><xf numFmtId="49" fontId="0" fillId="0" borderId="0" xfId="0" applyNumberFormat="1">'
              '<alignment vertical="top"/></xf>'
              '<xf numFmtId="49" fontId="1" fillId="0" borderId="0" xfId="0" applyFont="1" applyNumberFormat="1"/>'
              '<xf numFmtId="49" fontId="0" fillId="0" borderId="0" xfId="0" applyAlignment="1" applyNumberFormat="1">'
              '<alignment wrapText="1" vertical="top"/></xf></cellXfs>'
              '<cellStyles count="1"><cellStyle name="Normal" xfId="0" builtinId="0"/></cellStyles></styleSheet>')
    parts = {
        '[Content_Types].xml': (
            '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n'
            '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
            '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
            '<Default Extension="xml" ContentType="application/xml"/>'
            '<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>'
            '<Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>'
            '<Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>'
            '</Types>'),
        '_rels/.rels': (
            '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n'
            '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
            '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>'
            '</Relationships>'),
        'xl/workbook.xml': (
            '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n'
            '<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" '
            'xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">'
            '<sheets><sheet name="SHEET" sheetId="1" r:id="rId1"/></sheets></workbook>'),
        'xl/_rels/workbook.xml.rels': (
            '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n'
            '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
            '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>'
            '<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>'
            '</Relationships>'),
        'xl/worksheets/sheet1.xml': sheet,
        'xl/styles.xml': styles,
    }
    with zipfile.ZipFile(OUT, 'w', zipfile.ZIP_DEFLATED) as z:
        for name, text in parts.items():
            info = zipfile.ZipInfo(name, date_time=(2026, 10, 24, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            z.writestr(info, text.encode('utf-8'))
    print(f'{OUT.name}: {len(body)} rows, {len(header)} columns')


if __name__ == '__main__':
    main()
