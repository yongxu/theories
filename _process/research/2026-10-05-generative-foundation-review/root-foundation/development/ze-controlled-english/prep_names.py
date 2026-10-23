"""ZE step 2 input: the 中华本's name table, one JSON line per name, with the canonical chapter's glossary terms
(§10 (a), (b)) that share an anchor with it, for the author of the English name table.

    python3 -I prep_names.py          # writes data/names-input.jsonl
"""
import csv, json, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ZH = HERE.parent / 'zhonghua'
sys.path.insert(0, str(ZH / 'fidelity'))
import segments as G  # noqa: E402  (glossary(), the FC1 key for English)


def norm(a):
    a = a.strip().strip('`')
    return a if a.startswith(('Becoming.', 'Generative.')) else 'Becoming.' + a


def main():
    rows = list(csv.DictReader(open(ZH / 'work/names-decisions.tsv', encoding='utf-8'), delimiter='\t'))
    gl = G.glossary()
    out = HERE / 'data'
    out.mkdir(exist_ok=True)
    with open(out / 'names-input.jsonl', 'w', encoding='utf-8') as f:
        for i, r in enumerate(rows, 1):
            anchors = [norm(a) for a in r['锚'].split('；') if a.strip() not in ('', '—')]
            cands = []
            for g in gl:
                if set(g['anchors']) & set(anchors) and g['term'] not in [c['term'] for c in cands]:
                    cands.append({'term': g['term'], 'meaning': g['meaning']})
            f.write(json.dumps({'row': i, 'zh': r['名'], 'pian': r['篇'], 'sense_zh': r['所名'], 'anchors_raw': r['锚'],
                                'anchors': anchors, 'note_zh': r['注'], 'glossary_same_anchor': cands[:6]},
                               ensure_ascii=False) + '\n')
    print(len(rows), 'rows ->', out / 'names-input.jsonl')


if __name__ == '__main__':
    main()
