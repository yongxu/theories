"""ZE step 3 input: the 經 of every 條, clause by clause, with the names of the table each clause uses (string
matches, with their English names; senses and what they do not carry are in names-en.tsv) and a compact form of the Lean statements the clause states.

The 經 come from the FC1 extraction (fidelity/data/tiao.jsonl, the 中华本 at 333c34065, which the chapter still is);
the clause-to-declaration assignment is FC1's final alignment (fidelity/data/align_final.json) where it exists, and
the 條's 證 otherwise. The Lean forms come from fidelity/data/lean_table.jsonl (bound by fidelity/MANIFEST.json).

    python3 -I prep_render.py N        # writes data/render-input/batch_K.jsonl, N batches in chapter order
"""
import csv, json, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ZH = HERE.parent / 'zhonghua'
FD = ZH / 'fidelity' / 'data'
sys.path.insert(0, str(ZH / 'work'))
from simplify import simp  # noqa: E402


def load(p):
    return [json.loads(l) for l in open(p, encoding='utf-8')]


def table():
    rows = list(csv.DictReader(open(HERE / 'names-en.tsv', encoding='utf-8'), delimiter='\t'))
    out = [{'zh': simp(r['名']), 'name_en': r['name_en'], 'sense_en': r['sense_en'],
            'not_carried_en': r['not_carried_en']} for r in rows]
    out.sort(key=lambda x: -len(x['zh']))
    return out


def find(text, rows):
    found, used = [], [False] * len(text)
    for r in rows:
        i = text.find(r['zh'])
        while i >= 0:
            if not any(used[i:i + len(r['zh'])]):
                found.append((i, r))
                for k in range(i, i + len(r['zh'])):
                    used[k] = True
                break
            i = text.find(r['zh'], i + 1)
    return [r for _, r in sorted(found, key=lambda x: x[0])]


def cut(s, n):
    return s if len(s) <= n else s[:n] + ' …'


def lean_compact(L):
    b = '; '.join('%s : %s' % (x['name'], cut(x['type'], 90)) for x in L['binders'])
    s = '%s (%s) [%s] ⊢ %s' % (L['decl'], L['kind'], b, cut(L['conclusion'], 260))
    body = (L.get('self') or {}).get('body')
    if body and L['kind'] in ('def', 'abbrev', 'structure', 'inductive'):
        s += ' := ' + cut(body, 220)
    return s


def main():
    n = int(sys.argv[1])
    T = load(FD / 'tiao.jsonl')
    final = json.loads((FD / 'align_final.json').read_text())
    L = {d['decl']: d for d in load(FD / 'lean_table.jsonl')}
    rows = table()
    recs = []
    for t in T:
        fa = final.get(t['id'])
        clauses, decls = [], []
        for j, c in enumerate(t['jing_clauses'], 1):
            ds = fa.get(str(j), []) if fa else []
            for d in ds:
                if d not in decls:
                    decls.append(d)
            clauses.append({'j': j, 'zh': c, 'names': [[r['zh'], r['name_en']] for r in find(c, rows)],
                            'states': ds})
        if not fa:
            decls = list(t['decls'])
        recs.append({'tiao': t['id'], 'title': t['title'], 'pian': t['pian'], 'clauses': clauses,
                     'aligned': bool(fa), 'lean': [lean_compact(L[d]) for d in decls if d in L],
                     'lean_missing': [d for d in decls if d not in L]})
    out = HERE / 'data' / 'render-input'
    out.mkdir(parents=True, exist_ok=True)
    for old in out.glob('*.jsonl'):
        old.unlink()
    size = -(-len(recs) // n)
    for k in range(n):
        part = recs[k * size:(k + 1) * size]
        with open(out / ('batch_%d.jsonl' % (k + 1)), 'w', encoding='utf-8') as f:
            for r in part:
                f.write(json.dumps(r, ensure_ascii=False) + '\n')
        print('batch %d: %d 條 (%s … %s), %d clauses' % (k + 1, len(part), part[0]['tiao'], part[-1]['tiao'],
                                                       sum(len(r['clauses']) for r in part)))


if __name__ == '__main__':
    main()
