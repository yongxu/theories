# AI-written, 12 November 2026. Merges into the kit's data what the two filling workflows returned, each item as its
# second reader left it: the link that closes the ring, three more paths, the names others gave the boxes, four more
# tests.   python3 -B apply_fill.py <paths-names result json> <tests result json>
import json, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
def load(n): return json.load(open(os.path.join(HERE, 'data', n + '.json'), encoding='utf-8'))
def save(n, d): json.dump(d, open(os.path.join(HERE, 'data', n + '.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
def result(p):
    r = json.load(open(p, encoding='utf-8'))
    return r.get('result', r)
A, B = result(sys.argv[1]), result(sys.argv[2])
sheet, passages, paths, laid = load('sheet'), load('passages'), load('paths'), load('laid')
boxes = {b['id'] for b in sheet['boxes']}
keys = {p['from'] + '>' + p['to'] for p in passages['passages']}
log = []

# ---- the link that closes the ring, and the lock path's first section
ring = A['ring']
link = next(p for p in passages['passages'] if p['from'] == 'b1.held' and p['to'] == 'b2.uncounted')
lock = next(p for p in paths['paths'] if p['id'] == 'lock')
if ring['arrow']['draw']:
    a = ring['arrow']
    link.update(kind=a['kind'], tag_en=a['tag_en'], tag_zh=a['tag_zh'], en=a['en'], zh=a['zh'], laws=a['laws'], readers=1 if a['laws'] else 0)
    log.append('ring link: %s; %s' % (a['kind'], a['why'][:300]))
else:
    passages['passages'].remove(link); keys.discard('b1.held>b2.uncounted')
    log.append('ring link NOT drawn: ' + ring['arrow']['why'][:400])
flat = [st for S in lock['sections'] for st in S['steps']]
for s in ring['steps']:
    flat[s['step'] - 1]['say_en'], flat[s['step'] - 1]['say_zh'] = s['say_en'], s['say_zh']
    log.append('lock step %d retold: %s' % (s['step'], s['why'][:200]))
if ring['shows_change']:
    lock['shows_en'], lock['shows_zh'] = ring['shows_en'], ring['shows_zh']; log.append('lock shows lines replaced')

# ---- three more paths
have = {p['id'] for p in paths['paths']}
for x in A['paths']:
    p = (x or {}).get('checked')
    if not p: log.append('path for band %s: not checked, not added' % (x or {}).get('band')); continue
    pid = re.sub(r'[^a-z]', '', p['id'].lower()) or 'path'
    while pid in have or pid in ('whole', 'own', 'zh'): pid += 'x'
    have.add(pid)
    secs = []
    for S in p['sections']:
        steps = []
        for st in S['steps']:
            on = []
            for ref in st['on']:
                ok = (ref.startswith('box:') and ref[4:] in boxes) or (ref.startswith('stay:') and any(s['at'] == ref[5:] for s in passages['stays'])) or ref in keys or '>'.join(reversed(ref.split('>'))) in keys
                if ok: on.append(ref)
                else: log.append('path %s: dropped a reference that does not exist: %s' % (pid, ref))
            step = {'say_en': st['say_en'], 'say_zh': st['say_zh'], 'on': on}
            if st.get('eg') and st['eg'] in boxes: step['eg'] = st['eg']
            if on: steps.append(step)
            else: log.append('path %s: dropped a step that stood on nothing: %s' % (pid, st['say_en'][:80]))
        secs.append({'en': S['en'], 'zh': S['zh'], 'tone': S['tone'], 'steps': steps})
    bands = [b for b in p['bands'] if b in {x['id'] for x in sheet['bands']}] or [x['band']]
    paths['paths'].append({'id': pid, 'bands': bands, 'en': p['en'], 'zh': p['zh'], 'lead_en': p['lead_en'], 'lead_zh': p['lead_zh'], 'sections': secs,
                           'shows_en': p['shows_en'], 'shows_zh': p['shows_zh'], 'want_en': '', 'want_zh': ''})
    log.append('path %s added: %d steps; checker: %s' % (pid, sum(len(S['steps']) for S in secs), p.get('notes', '')[:300]))

# ---- the names others gave the boxes
names = (A.get('names') or {}).get('checked')
if names:
    by = {}
    for n in names['names']:
        if n['verdict'] == 'drop' or n['box'] not in boxes:
            log.append('name dropped at %s: %s (%s)' % (n['box'], n['en'][:60], n['why'][:160])); continue
        by.setdefault(n['box'], []).append(n)
    for b in sheet['boxes']:
        if b['id'] not in by: continue
        close = [n for n in by[b['id']] if n['how'] != 'not']; unlike = [n for n in by[b['id']] if n['how'] == 'not']
        b['known_en'] = [n['en'] for n in close]; b['known_zh'] = [n['zh'] for n in close]
        b['unlike_en'] = [n['en'] for n in unlike]; b['unlike_zh'] = [n['zh'] for n in unlike]
        b['known_src'] = [n['source'] for n in close + unlike]
    log.append('names: %d kept on %d boxes' % (sum(len(v) for v in by.values()), len(by)))

# ---- four more tests
tids = {t['id'] for t in laid['tests']} | have
for x in B['tests']:
    t = (x or {}).get('checked')
    if not t or not t.get('fits', True): log.append('test %s: not laid (%s)' % ((x or {}).get('test'), ((x or {}).get('written') or {}).get('why_not', 'not checked')[:200])); continue
    tid = re.sub(r'[^a-z0-9]', '', t['id'].lower()) or 'test'
    while tid in tids or tid in ('whole', 'own', 'zh'): tid += 'x'
    tids.add(tid)
    pins = []
    for p in t['pins']:
        if p['at'] not in boxes: log.append('test %s: dropped a pin at an unknown box %s' % (tid, p['at'])); continue
        pin = {k: p[k] for k in ('at', 'how', 'agree', 'en', 'zh', 'short_en', 'short_zh', 'seen_en', 'seen_zh')}
        if p.get('found_at') in boxes and p['found_at'] != p['at']: pin['found_at'] = p['found_at']
        pins.append(pin)
    used = [k for k in t.get('used', []) if k in keys]
    for k in t.get('used', []):
        if k not in keys: log.append('test %s: an arrow it names is not on the map: %s' % (tid, k))
    gave = []
    for g in t.get('gave', []):
        if g.get('pin') and 1 <= g['pin'] <= len(pins): gave.append({'pin': g['pin']})
        elif g.get('passage') in keys: gave.append({'passage': g['passage']})
    view = t.get('view') if (t.get('view') or {}).get('at') in boxes else None
    laid['tests'].append(dict({k: t[k] for k in ('en', 'zh', 'what_en', 'what_zh', 'said_en', 'said_zh', 'seen_en', 'seen_zh', 'broke_en', 'broke_zh', 'after_en', 'after_zh', 'rival_en', 'rival_zh')},
                              id=tid, test=x['test'], records=[x['test']], pins=pins, used=used, gave=gave, view=view))
    log.append('test %s (%s) laid: %d pins, %d arrows; checker: %s' % (tid, x['test'], len(pins), len(used), t.get('notes', '')[:300]))

save('sheet', sheet); save('passages', passages); save('paths', paths); save('laid', laid)
open(os.path.join(HERE, 'fill.log'), 'w', encoding='utf-8').write('\n'.join(log) + '\n')
print('\n'.join(l[:230] for l in log))
