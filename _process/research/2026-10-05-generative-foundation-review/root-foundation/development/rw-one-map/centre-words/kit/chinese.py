#!/usr/bin/env python3
# AI-written, 13 November 2026 (board item WM2). Sets the Chinese of every field whose English was re-said, from the
# checked list (tmp/r7/sheet/wm2/zh-checked.json; items in zh-items-A.json and zh-items-B.json), then applies
# zh-fixes.json if present ({"<id>": "final Chinese"}: the coordinator's own corrections). Each replaces a whole field.
#   chinese.py <root>
import json, os, re, sys
ROOT = sys.argv[1]
M = os.path.join(ROOT, 'theories/becoming/results/map')
DIR = '/Users/ren/theories/tmp/r7/sheet/wm2'
KIT = '/Users/ren/tmp/rw/wm2'
items = {i['id']: i for k in 'AB' for i in json.load(open('%s/zh-items-%s.json' % (DIR, k), encoding='utf-8'))}
new = {i['id']: i['new_zh'] for i in json.load(open(DIR + '/zh-checked.json', encoding='utf-8'))}
fx = KIT + '/zh-fixes.json'
if os.path.exists(fx): new.update({int(k): v for k, v in json.load(open(fx, encoding='utf-8')).items()})
missing = sorted(set(items) - set(new)); extra = sorted(set(new) - set(items))
assert not missing and not extra, (missing, extra)
S = json.load(open(M + '/sheet.json', encoding='utf-8')); P = json.load(open(M + '/paths.json', encoding='utf-8')); A = json.load(open(M + '/passages.json', encoding='utf-8'))
box = {b['id']: b for b in S['boxes']}; arr = {p['from'] + '>' + p['to']: p for p in A['passages']}; stay = {s['at']: s for s in A['stays']}
paths = {p['id']: p for p in P['paths']}; lock = paths['lock']; steps = [s for sec in lock['sections'] for s in sec['steps']]
log = []


def put(obj, key, i):
    it = items[i]
    assert obj[key] == it['old_zh'], (i, it['where'], key)
    if obj[key] != new[i]:
        log.append({'id': i, 'where': it['where'], 'field': it['zh_field'], 'old': obj[key], 'new': new[i]}); obj[key] = new[i]


for i, it in sorted(items.items()):
    w, f = it['where'], it['zh_field']
    if w == 'sheet': put(S, 'lead_zh', i); continue
    m = re.match(r'row (\S+)', w)
    if m: put(next(x for x in S['rows'] if x['id'] == m.group(1)), 'zh', i); continue
    m = re.match(r'band (\S+)', w)
    if m: put(next(x for x in S['bands'] if x['id'] == m.group(1)), 'zh', i); continue
    m = re.match(r'box (\S+)', w)
    if m: put(box[m.group(1)], f, i); continue
    if w == 'path lock': put(lock, f, i); continue
    m = re.match(r'path lock cast (\d+)', w)
    if m: put(lock['cast'][int(m.group(1))], f, i); continue
    m = re.match(r'path lock step (\d+)', w)
    if m: put(steps[int(m.group(1)) - 1], 'say_zh', i); continue
    m = re.match(r'path (\S+) shows (\d+)', w)
    if m: put(paths[m.group(1)]['shows_zh'], int(m.group(2)), i); continue
    m = re.match(r'arrow (\S+) more (\d+)', w)
    if m: put(arr[m.group(1)]['more'][int(m.group(2))], 'zh', i); continue
    m = re.match(r'arrow (\S+)', w)
    if m: put(arr[m.group(1)], f, i); continue
    m = re.match(r'stay (\S+)', w)
    if m: put(stay[m.group(1)], 'zh', i); continue
    raise SystemExit('no place for ' + w)
for name, d in (('sheet', S), ('paths', P), ('passages', A)):
    open('%s/%s.json' % (M, name), 'w', encoding='utf-8').write(json.dumps(d, ensure_ascii=False, indent=1))
json.dump(log, open(KIT + '/old-new-zh.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
print('Chinese fields changed:', len(log), 'of', len(items))
long_names = [(l['where'], l['new']) for l in log if l['where'].startswith('box') and l['field'] == 'zh' and len(l['new']) > 12]
long_tags = [(l['where'], l['new']) for l in log if l['field'] == 'tag_zh' and len(l['new']) > 22]
print('box names over 12 characters:', long_names); print('tags over 22 characters:', long_tags)
left = [l['where'] for l in log if re.search('过程之外给定|就过程本身|自己撑住自己|自己评自己', l['new'])]
print('old phrases left:', left)
