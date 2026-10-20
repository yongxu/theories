"""Gather every proposed name with both verifiers' verdicts into one table (read-only on agents/)."""
import json, glob, os, sys
A = os.path.join(os.path.dirname(__file__), '..', 'agents')
rows = []
for f in sorted(glob.glob(A + '/map-C*.json')):
    m = json.load(open(f)); c = m['cluster'][:3] if isinstance(m['cluster'], str) else m['cluster']
    c = os.path.basename(f)[4:7]
    ver = {}
    for lens in ('philology', 'structure'):
        p = os.path.join(A, 'verify-%s-%s.json' % (lens, c))
        if os.path.exists(p):
            for n in json.load(open(p)).get('names', []):
                ver.setdefault(n['name'], {})[lens[0]] = n['verdict'][0]
    for n in m['names']:
        v = ver.get(n['name'], {})
        lean = n.get('lean') or []
        if isinstance(lean, str):
            try: lean = json.loads(lean.replace("'", '"'))
            except Exception: lean = [lean]
        rows.append([c, n['name'], n.get('form', '')[:2], 'Q' if str(n.get('pre_qin')) == 'True' else '-',
                     (n.get('confidence') or '')[:1], v.get('p', '?') + v.get('s', '?'),
                     n['concept'].split('：')[0][:38], ' '.join(x.replace('Becoming.', '') for x in lean)[:90]])
json.dump(rows, open(os.path.join(os.path.dirname(__file__), 'names_rows.json'), 'w'), ensure_ascii=False)
for r in rows:
    print('\t'.join(r))
