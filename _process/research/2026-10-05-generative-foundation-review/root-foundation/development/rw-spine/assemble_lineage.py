import json, sys
sys.path.insert(0, '.')
from unittest import mock
from tools.research import lineage
S = sys.argv[1]
res = json.load(open(f'{S}/lineage-final-raw.json'))
order = ['early', 'pre-becoming', 'becoming-october', 'november', 'thread', 'papers']
pts = [(k, p) for k in order for p in res[k]['points']]


def key(kp):
    d, prec = lineage.parse_date(kp[1]['date'])
    return (d, {'year': 0, 'month': 1, 'day': 2}[prec])


pts.sort(key=key)
points = [{'id': p['id'], 'date': p['date'], 'title': {'en': p['title_en'], 'zh': p['title_zh']},
           'what': {'en': p['what_en'], 'zh': p['what_zh']},
           'evidence': [{'path': e['path'], 'locator': e['locator'], 'quote': e['quote'], 'private': e['private']} for e in p['evidence']],
           'label': p['label'], 'label_why': p.get('label_why', ''), 'thread': bool(p.get('thread'))} for k, p in pts]
seen, renames = set(), []
for k in order:
    for r in res[k]['renames']:
        kk = (r['from'].strip().lower(), r['to'].strip().lower())
        if kk in seen:
            continue
        seen.add(kk)
        renames.append({'date': r['date'], 'from': r['from'], 'to': r['to'], 'where': {'en': r['where_en'], 'zh': r['where_zh']},
                        'evidence_path': r['evidence_path'], 'quote': r['quote'], 'label': r['label']})
renames.sort(key=lambda r: lineage.parse_date(r['date'].split('/')[0])[0])
papers = [{'id': p['id'], 'title': p['title'], 'date': p['date'], 'paths': p['paths'],
           'claimed': {'en': p['claimed_en'], 'zh': p['claimed_zh']}, 'stands': {'en': p['stands_en'], 'zh': p['stands_zh']},
           'stands_basis': p['stands_basis'], 'label': p['label']} for p in res['papers'].get('papers') or []]
papers.sort(key=lambda p: lineage.parse_date(p['date'].split('/')[0])[0])
static = json.load(open('_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rw-spine/lineage_static.json'))
thread_ids = [p['id'] for p in points if p['thread']]
intro = json.load(open(f'{S}/thread-intro.json')) if __import__('os').path.exists(f'{S}/thread-intro.json') else {'en': 'TODO', 'zh': 'TODO'}
spec = {**static, 'points': points, 'renames': renames, 'papers': papers,
        'thread': {'title': {'en': 'One thread: the selection mechanism', 'zh': '一条线索：选择机制'}, 'intro': intro, 'points': thread_ids}}
json.dump(spec, open(f'{S}/lineage-assembled.json', 'w'), ensure_ascii=False, indent=1)
open(f'{S}/output-README.md', 'w').write(res['papers'].get('output_readme') or '')
print(len(points), 'points;', len(renames), 'renames;', len(papers), 'papers; thread', len(thread_ids))
errs = lineage.check(spec)
print(len(errs))
print('\n'.join(errs))
