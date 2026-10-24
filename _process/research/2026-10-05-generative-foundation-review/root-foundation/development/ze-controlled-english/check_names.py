"""ZE: check the English name table names-en.tsv against the 中华本's name table.

Every row of work/names-decisions.tsv has exactly one row here, in the same order, with the same Chinese name, 篇 and
anchors; every anchor resolves in the newest core receipt (a declaration or module of it) or in a periphery receipt,
as verify_zh.py resolves them; the English names are distinct (case, spacing and a plural -s or -es ignored); every row
has an English name, a sense and a not-carried field; no English field holds Chinese characters except quoted
Chinese names in the not-carried field.

    python3 -I check_names.py [--receipt PATH]     # exit 1 on any failure
"""
import argparse, csv, json, re, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ZH = HERE.parent / 'zhonghua'
ROOT = HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
COLS = ['row', '名', '篇', 'name_en', 'sense_en', 'not_carried_en', '锚', 'glossary_term']
CJK = re.compile(r'[㐀-鿿]')


def key(name):
    k = re.sub(r'\s+', ' ', name.strip().lower())
    return re.sub(r'(es|s)$', '', k)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--receipt', type=Path)
    args = ap.parse_args()
    fail = []
    zh = list(csv.DictReader(open(ZH / 'work/names-decisions.tsv', encoding='utf-8'), delimiter='\t'))
    en = list(csv.DictReader(open(HERE / 'names-en.tsv', encoding='utf-8'), delimiter='\t'))
    if en and list(en[0].keys()) != COLS:
        fail.append('columns %s, expected %s' % (list(en[0].keys()), COLS))
    if len(en) != len(zh):
        fail.append('%d rows, the name table has %d' % (len(en), len(zh)))
    receipt = args.receipt or max((PKG / 'becoming-checks').glob('*/verification.json'))
    rec = json.loads(receipt.read_text())
    decls = {d['name'] for m in rec['modules'] for d in m['declarations']}
    modules = {m['module'] for m in rec['modules']} | {d.rsplit('.', 1)[0] for d in decls}
    periphery = set()
    for f in PKG.parent.glob('*/*verification.json'):
        try:
            for m in json.loads(f.read_text()).get('modules', []):
                if m.get('layer') == 'periphery':
                    periphery |= {d['name'] for d in m.get('declarations', [])}
        except (ValueError, AttributeError):
            pass

    def decl_ok(n):
        n = n.strip().strip('`')
        full = n if n.startswith('Becoming.') or n in decls else 'Becoming.' + n
        return full in decls or full in modules or full in periphery

    seen, n_anchor, n_gloss = {}, 0, 0
    for i, (z, e) in enumerate(zip(zh, en), 1):
        tag = 'row %d (%s)' % (i, z['名'])
        if e.get('row') != str(i) or e.get('名') != z['名'] or e.get('篇') != z['篇']:
            fail.append('%s: row, 名 or 篇 differ (%s, %s, %s)' % (tag, e.get('row'), e.get('名'), e.get('篇')))
        if (e.get('锚') or '').strip() != z['锚'].strip():
            fail.append('%s: anchors differ from the name table' % tag)
        for a in [a.strip() for a in z['锚'].split('；') if a.strip() not in ('', '—')]:
            n_anchor += 1
            if not decl_ok(a):
                fail.append('%s: anchor %s not in receipt %s' % (tag, a, receipt.parent.name))
        for f_ in ('name_en', 'sense_en', 'not_carried_en'):
            if not (e.get(f_) or '').strip():
                fail.append('%s: empty %s' % (tag, f_))
        for f_ in ('name_en', 'sense_en'):
            if CJK.search(e.get(f_) or ''):
                fail.append('%s: Chinese characters in %s' % (tag, f_))
        k = key(e.get('name_en') or '')
        if k in seen:
            fail.append('%s: English name "%s" coincides with row %d' % (tag, e.get('name_en'), seen[k]))
        seen[k] = i
        n_gloss += bool((e.get('glossary_term') or '').strip())
    for x in fail:
        print('FAIL', x)
    print('%d rows, %d distinct English names, %d anchors resolved against %s, %d names taken from the glossary; %s'
          % (len(en), len(seen), n_anchor, receipt.parent.name, n_gloss, 'FAILED %d' % len(fail) if fail else 'ok'))
    sys.exit(1 if fail else 0)


if __name__ == '__main__':
    main()
