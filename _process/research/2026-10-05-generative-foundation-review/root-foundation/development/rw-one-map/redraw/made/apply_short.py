# AI-written, 12 November 2026. Merges the shortened texts of the four later tests into the kit's laid.json, each as
# its second reader left it. The long checked versions stay in fill-tests.json.
#   python3 -B apply_short.py <result json of the shortening workflow>
import json, os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
r = json.load(open(sys.argv[1], encoding='utf-8')); r = r.get('result', r)
p = os.path.join(HERE, 'data', 'laid.json')
laid = json.load(open(p, encoding='utf-8'))
by = {t['id']: t for t in laid['tests']}
FIELDS = [f + '_' + l for f in ('what', 'said', 'seen', 'broke', 'after', 'rival') for l in ('en', 'zh')]
wc = lambda s: len(s.split())
for x in r['tests']:
    c = (x or {}).get('checked')
    if not c: print('NOT CHECKED, left long:', (x or {}).get('id')); continue
    t = by[x['id']]
    assert len(c['pins']) == len(t['pins']), (x['id'], len(c['pins']), len(t['pins']))
    before = sum(wc(t[f]) for f in FIELDS if f.endswith('_en')) + sum(wc(pin['en']) + wc(pin['seen_en']) for pin in t['pins'])
    for f in FIELDS: t[f] = c[f].strip()
    for pin, new in zip(t['pins'], c['pins']):
        for k in ('en', 'zh', 'short_en', 'short_zh', 'seen_en', 'seen_zh'): pin[k] = new[k].strip()
    after = sum(wc(t[f]) for f in FIELDS if f.endswith('_en')) + sum(wc(pin['en']) + wc(pin['seen_en']) for pin in t['pins'])
    print('%s: %d -> %d English words; %s' % (x['id'], before, after, {f[:-3]: wc(t[f]) for f in FIELDS if f.endswith('_en')}))
    print('   checker:', c.get('notes', '')[:600].replace('\n', ' '))
json.dump(laid, open(p, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
