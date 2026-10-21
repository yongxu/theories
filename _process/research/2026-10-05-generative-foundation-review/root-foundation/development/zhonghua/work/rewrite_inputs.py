"""Inputs of the rewrite pass: python3 -I work/rewrite_inputs.py PLAN.json

Reads work/book-0.json and the checked restructuring plan, applies its operations (book.py apply) to give
work/book-1.json, writes work/book-1-outline.txt (every 條 id with the number and title it will have) and, for each
part, work/rewrite/<KEY>.json: the part, the plan's text work for its 條 and 篇首, the 條 it adds, and the 对照
lines that name no entry of the map. Text work for the preface (HEAD) is written to work/rewrite/HEAD.json."""
import json, os, re, sys

H = os.path.dirname(os.path.abspath(__file__)); KIT = os.path.dirname(H)
sys.path.insert(0, KIT)
import book as B

plan = json.load(open(sys.argv[1], encoding='utf-8'))
b0 = json.load(open(H + '/book-0.json', encoding='utf-8'))
ops = plan['ops']
for op in ops:  # an added 條 starts empty; its text comes from the rewrite
    if op['op'] == 'add':
        op.setdefault('body', '')
b1 = B.apply(b0, ops)
json.dump(b1, open(H + '/book-1.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
num = B.numbering(b1)
lines = []
where = {}
for p in b1['parts']:
    lines.append('## %s %s' % (p['key'], p['heading']))
    for t in p['tiao']:
        lines.append('%s\t%s\t%s' % (t['id'], num[t['id']], t['title']))
        where[t['id']] = p['key']
for old, new in b1['redirect'].items():
    lines.append('%s\t→ %s (deleted; its content is in %s)' % (old, num[old], new))
open(H + '/book-1-outline.txt', 'w', encoding='utf-8').write('\n'.join(lines) + '\n')
os.makedirs(H + '/rewrite', exist_ok=True)
by_part = {p['key']: {'part': p, 'edits': [], 'added': [], 'duizhao_issues': []} for p in b1['parts']}
head = []
for e in plan['edits']:
    t = e['target']
    if t == 'HEAD':
        head.append(e)
    elif t in by_part:
        by_part[t]['edits'].append(e)
    elif t in where:
        by_part[where[t]]['edits'].append(e)
    elif t in b1['redirect']:  # text work for a deleted 條 goes to the 條 that keeps its content
        k = t
        while k in b1['redirect']:
            k = b1['redirect'][k]
        by_part[where[k]]['edits'].append(dict(e, target=k, from_deleted=t))
    else:
        head.append(dict(e, unplaced=True))
for p in b1['parts']:
    for t in p['tiao']:
        if t.get('added'):
            by_part[p['key']]['added'].append({'id': t['id'], 'title': t['title']})
    for line in p['duizhao'].split('\n'):
        if line.startswith('- ') and not re.search(r'[（(][a-z0-9:]+(?:-[a-z0-9]+)+[）)]', line):
            by_part[p['key']]['duizhao_issues'].append(line)
for k, v in by_part.items():
    json.dump(v, open(H + '/rewrite/%s.json' % k, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
json.dump(head, open(H + '/rewrite/HEAD.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
print(sum(len(p['tiao']) for p in b1['parts']), '條;', sum(len(v['edits']) for v in by_part.values()), 'edits placed,',
      len(head), 'for the preface or unplaced;', sum(len(v['added']) for v in by_part.values()), 'added')
