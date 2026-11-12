# AI-written, 12 November 2026. Builds the sheet (one page) from data.py, settled.json, edits.py, stories.py and items.json.
#   python3 -B build.py            -> map.html (page fragment for publishing), preview.html (standalone), built.json
import json, os, sys, html, collections, math

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from data import BANDS, ROWS, CONDITIONS
from stories import PATHS, CASES
import edits as E

ROOT = '/Users/ren/theories/'
esc = html.escape

# ------------------------------------------------------------------ names
BANDS = [dict(b) for b in BANDS]; ROWS = [dict(r) for r in ROWS]; CONDITIONS = [dict(c) for c in CONDITIONS]
for b in BANDS:
    en, zh = E.BAND_NAMES.get(b['id'], (None, None)); b['en'] = en or b['en']; b['zh'] = zh or b['zh']
for r in ROWS:
    en, zh = E.ROW_NAMES.get(r['id'], (None, None)); r['en'] = en or r['en']; r['zh'] = zh or r['zh']
for c in CONDITIONS:
    en, zh = E.COND_NAMES.get(c['id'], (None, None)); c['en'] = en or c['en']; c['zh'] = zh or c['zh']
    c['known_as'] = E.KNOWN.get(c['id'], []); c['known_zh'] = E.KNOWN_ZH.get(c['id'], c['known_as'])

import re
def words_en(s):
    for a, b in E.EN_WORDS: s = re.sub(r'(?<![A-Za-z])' + re.escape(a) + r'(?![A-Za-z])', b, s)
    return s
def words_zh(s):
    for a, b in E.ZH_WORDS: s = s.replace(a, b)
    return s
def words2(en, zh):
    for a, b in E.EN_WORDS2: en = en.replace(a, b)
    for a, b in E.ZH_WORDS2: zh = zh.replace(a, b)
    return en, zh
LAST = json.load(open(os.path.join(HERE, 'last-read.json')))['result']
TAGFIX = {t['key']: (t['tag_en'], t['tag_zh']) for t in LAST['tags']['tags']}
SENTFIX, MOREFIX = {}, {}
for t in LAST['tags']['sentences']:
    k = t['key'].split(' ')[0]
    (MOREFIX if 'more[' in t['key'] else SENTFIX)[k] = (t['en'], t['zh'])

# ------------------------------------------------------------------ geometry
GX, CW, BW, BH, RH, BANDH, TOP, NCOL = 176, 152, 140, 58, 92, 26, 4, 6
W = GX + NCOL * CW + 6

def wrap(s, n):
    out, cur = [], ''
    for w in s.split(' '):
        if cur and len(cur) + 1 + len(w) > n:
            out.append(cur); cur = w
        else:
            cur = (cur + ' ' + w).strip()
    if cur: out.append(cur)
    return out

rows = {r['id']: dict(r) for r in ROWS}
ri = [r['id'] for r in ROWS]
y = TOP
band_boxes = []
for b in BANDS:
    y0 = y; y += BANDH
    for r in ROWS:
        if r['band'] != b['id']: continue
        rows[r['id']]['cy'] = y + RH / 2; rows[r['id']]['y0'] = y; y += RH
    band_boxes.append((b, y0, y)); y += 14
H = y

settled = json.load(open(os.path.join(HERE, 'settled.json')))
conds = {}
for c in CONDITIONS:
    c = dict(c)
    c['x'] = GX + (c['col'] - 1) * CW + CW / 2; c['y'] = rows[c['row']]['cy']
    f = settled['cond_fix'].get(c['id'])
    if f: c['says_en'] = f['says_en']; c['says_zh'] = f['says_zh']
    c['says_en'], c['says_zh'] = words2(words_en(c['says_en']), words_zh(c['says_zh']))
    if c['id'] in E.OWN_NAME: c['says_en'] += ' ' + E.OWN_NAME[c['id']][0]; c['says_zh'] += E.OWN_NAME[c['id']][1]
    c['anchors'] = [a.replace('Becoming.', '') for a in settled['anchors'].get(c['id'], [])][:8]
    conds[c['id']] = c
order = [c['id'] for c in CONDITIONS]

# ------------------------------------------------------------------ passages
dyn = {d['id']: d for d in json.load(open(ROOT + 'theories/becoming/results/atlas/entries/dynamics.json'))}
def dname(i):
    d = dyn.get(i)
    if not d: return i
    n = d.get('name')
    return n.get('en') if isinstance(n, dict) else n
items = json.load(open(os.path.join(HERE, 'items.json')))
dyn_at = collections.defaultdict(list)
for r in items:
    if r['kind'] in ('stays', 'inside') and r.get('at') in conds:
        n = dname(r['dynamic'])
        if n not in dyn_at[r['at']]: dyn_at[r['at']].append(n)

ORDER = ['law', 'line', 'needs', 'built', 'reading', 'same']
def single(src):          # written by the reader who placed it, read by no second reader
    return src.endswith(':missing') or src.startswith('auto:')
passages = []
for q in settled['passages'] + [{'from': x['from'], 'to': x['to'], 'paths': x['paths'], 'ways': [{k: x[k] for k in ('kind', 'en', 'zh', 'laws', 'src')}]} for x in E.EXTRA]:
    key = q['from'] + '>' + q['to']
    ways = [dict(w) for w in q['ways']]
    if key in E.KIND: ways[0]['kind'] = E.KIND[key][0]
    if key in E.EN: ways[0]['en'] = E.EN[key]
    if key in E.ZH: ways[0]['zh'] = E.ZH[key]
    if key in SENTFIX: ways[0]['en'], ways[0]['zh'] = SENTFIX[key]
    if key in MOREFIX and len(ways) > 1: ways[1]['en'], ways[1]['zh'] = MOREFIX[key]
    for w in ways:
        w['en'], w['zh'] = words2(words_en(w['en']), words_zh(w['zh'])); w['single'] = single(w.get('src', ''))
    ways.sort(key=lambda w: ORDER.index(w['kind']))
    w = ways[0]
    tag = words2(*TAGFIX.get(key, E.TAGS.get(key, ('', ''))))
    passages.append({'from': q['from'], 'to': q['to'], 'key': key, 'kind': w['kind'], 'en': w['en'], 'zh': w['zh'], 'laws': w['laws'], 'single': w['single'],
                     'tag_en': tag[0], 'tag_zh': tag[1], 'paths': q.get('paths', []),
                     'more': [{k: x[k] for k in ('kind', 'en', 'zh', 'laws', 'single')} for x in ways[1:]]})
for i, q in enumerate(passages): q['id'] = 'p%d' % i
pkey = {(q['from'], q['to']): q for q in passages}
stays = [{'from': x['from'], 'en': words2(words_en(x['en']), '')[0], 'zh': words2('', words_zh(x['zh']))[1], 'laws': x['laws'], 'kind': x.get('kind', 'law')} for x in settled['stays']]
missing_tags = [q['key'] for q in passages if not q['tag_en']]
if missing_tags: print('no tag:', missing_tags)

# ------------------------------------------------------------------ routing
def between(a, b):
    lo, hi = sorted((a['col'], b['col']))
    return any(c['row'] == a['row'] and lo < c['col'] < hi for c in conds.values())
def far(q):
    return abs(ri.index(conds[q['from']]['row']) - ri.index(conds[q['to']]['row'])) > 3

slots = collections.defaultdict(list)
for q in passages:
    a, b = conds[q['from']], conds[q['to']]
    if a['row'] == b['row']:
        if between(a, b):
            side = 'top' if b['col'] > a['col'] else 'bottom'
            slots[(a['id'], side)].append((b['x'], q['id'], 'a')); slots[(b['id'], side)].append((a['x'], q['id'], 'b'))
        continue
    down = b['y'] > a['y']
    slots[(a['id'], 'bottom' if down else 'top')].append((b['x'], q['id'], 'a'))
    slots[(b['id'], 'top' if down else 'bottom')].append((a['x'], q['id'], 'b'))
off = {}
for (cid, side), L in slots.items():
    L.sort(); n = len(L); step = min(14, (BW - 26) / max(1, n - 1)) if n > 1 else 0
    for i, (_, pid, end) in enumerate(L): off[(pid, end)] = (i - (n - 1) / 2) * step

def head(tip, d, size=6.5):
    dx, dy = d; L = math.hypot(dx, dy) or 1; dx, dy = dx / L, dy / L
    px, py = -dy, dx
    bx, by = tip[0] - dx * size * 1.35, tip[1] - dy * size * 1.35
    return 'M%.1f %.1f L%.1f %.1f L%.1f %.1f Z' % (tip[0], tip[1], bx + px * size * .55, by + py * size * .55, bx - px * size * .55, by - py * size * .55)
def bar(mid, d, size=6):
    dx, dy = d; L = math.hypot(dx, dy) or 1; px, py = -dy / L, dx / L
    return 'M%.1f %.1f L%.1f %.1f' % (mid[0] + px * size, mid[1] + py * size, mid[0] - px * size, mid[1] - py * size)

both = {(q['from'], q['to']) for q in passages}
for q in passages:
    a, b = conds[q['from']], conds[q['to']]; pid = q['id']
    q['far'] = far(q); q['cross'] = a['row'] != b['row']
    if not q['cross'] and not between(a, b):
        sgn = 1 if b['x'] > a['x'] else -1
        two = (q['to'], q['from']) in both
        dy = (-9 * sgn) if two else 0
        p0 = (a['x'] + sgn * BW / 2, a['y'] + dy); p3 = (b['x'] - sgn * BW / 2, b['y'] + dy)
        q['d'] = 'M%.1f %.1f L%.1f %.1f' % (p0 + p3)
        q['h1'] = head(p3, (sgn, 0)); q['mid'] = ((p0[0] + p3[0]) / 2, p0[1]); q['bar'] = bar(q['mid'], (1, 0), 7)
        q['tagpos'] = (q['mid'][0], a['y'] - BH / 2 - 6) if sgn > 0 else (q['mid'][0], a['y'] + BH / 2 + 14)
    elif not q['cross']:
        up = b['x'] > a['x']
        yy = a['y'] + (-BH / 2 if up else BH / 2)
        p0 = (a['x'] + off.get((pid, 'a'), 0), yy); p3 = (b['x'] + off.get((pid, 'b'), 0), yy)
        cy = yy + (-24 if up else 24)
        q['d'] = 'M%.1f %.1f C%.1f %.1f %.1f %.1f %.1f %.1f' % (p0[0], p0[1], p0[0], cy, p3[0], cy, p3[0], p3[1])
        q['h1'] = head(p3, (0, 1 if up else -1)); q['mid'] = ((p0[0] + p3[0]) / 2, yy + (-18 if up else 18)); q['bar'] = bar(q['mid'], (1, 0), 6)
        q['tagpos'] = (q['mid'][0], q['mid'][1] + (-6 if up else 14))
    else:
        down = b['y'] > a['y']; s = 1 if down else -1
        p0 = (a['x'] + off.get((pid, 'a'), 0), a['y'] + s * BH / 2); p3 = (b['x'] + off.get((pid, 'b'), 0), b['y'] - s * BH / 2)
        k = max(18, min(90, abs(p3[1] - p0[1]) * .45))
        c1 = (p0[0], p0[1] + s * k); c2 = (p3[0], p3[1] - s * k)
        q['d'] = 'M%.1f %.1f C%.1f %.1f %.1f %.1f %.1f %.1f' % (p0 + c1 + c2 + p3)
        q['h1'] = head(p3, (0, s))
        tt = min(.5, 15.0 / max(1.0, abs(p3[1] - p0[1])) + .06)
        bez = lambda u, i: (1 - u) ** 3 * p0[i] + 3 * (1 - u) ** 2 * u * c1[i] + 3 * (1 - u) * u * u * c2[i] + u ** 3 * p3[i]
        q['mid'] = (bez(tt, 0), bez(tt, 1)); q['bar'] = bar(q['mid'], (0, 1), 6)
        q['tagpos'] = (q['mid'][0] + 10, q['mid'][1] + 4)
        # stubs for a passage too long to draw at rest
        q['stub'] = ('M%.1f %.1f L%.1f %.1f' % (p0[0], p0[1], p0[0], p0[1] + s * 13), head((p0[0], p0[1] + s * 13), (0, s), 5),
                     'M%.1f %.1f L%.1f %.1f' % (p3[0], p3[1] - s * 13, p3[0], p3[1]), head(p3, (0, s), 5))

# ------------------------------------------------------------------ paths and tests
TOLD = json.load(open(os.path.join(HERE, 'told-check.json')))['result']
TOLDFIX = {(x['path'], x['step']): (x['say_en'], x['say_zh']) for x in TOLD['steps']}
LEAD = {'en': TOLD['lead']['en'], 'zh': TOLD['lead']['zh']}
for P in PATHS:
    n = 0; P['cset'], P['pset'], P['tones'] = [], [], {}
    for S in P['sections']:
        for st in S['steps']:
            n += 1; st['n'] = n; st['tone'] = S['tone']
            if (P['id'], n) in TOLDFIX: st['say_en'], st['say_zh'] = TOLDFIX[(P['id'], n)]
            refs = []
            if 'c' in st: refs.append(('c', st['c']))
            if 'p' in st: refs.append(('p', tuple(st['p'])))
            if 'also' in st: refs.append(('p', tuple(st['also'])))
            st['refs'] = []
            for kind, ref in refs:
                if kind == 'c':
                    st['refs'].append({'c': ref}); P['cset'].append(ref)
                elif ref[0] == ref[1]:
                    q = next(x for x in stays if x['from'] == ref[0]); st['refs'].append({'stay': ref[0], 'en': q['en'], 'zh': q['zh']}); P['cset'].append(ref[0])
                else:
                    q = pkey.get(ref) or pkey.get((ref[1], ref[0]))
                    assert q, ref
                    st['refs'].append({'p': q['id']}); P['pset'].append(q['id']); P['cset'] += [q['from'], q['to']]
                    P['tones'].setdefault(q['id'], S['tone'])
            for r in st['refs']:
                cid = r.get('c') or r.get('stay')
                if cid: P['tones'].setdefault(cid, S['tone'])
    P['cset'] = sorted(set(P['cset'])); P['pset'] = sorted(set(P['pset']))
bykey = {q['key']: q for q in passages}
tested = collections.defaultdict(list)
for C in CASES:
    for i, pin in enumerate(C['pins']):
        pin['n'] = i + 1; assert pin['at'] in conds
        pin['k'] = sum(1 for x in C['pins'][:i] if x['at'] == pin['at'])
        if C['id'] not in tested[pin['at']]: tested[pin['at']].append(C['id'])
    C['used'] = [bykey[k]['id'] for k in C.get('used', [])]
    for g in C.get('gave', []):
        if 'p' in g: g['p'] = bykey[g['p']]['id']
WANTED = ['b2.counted', 'b3.rest', 'bs.costs']

# ------------------------------------------------------------------ svg
stay_at = collections.defaultdict(list)
for s in stays: stay_at[s['from']].append(s)

def node_svg(c):
    x, yy = c['x'] - BW / 2, c['y'] - BH / 2
    en = wrap(c['en'], 22); lh = 13.5
    total = len(en) * lh + 14
    ty = c['y'] - total / 2 + 10
    t = ''.join('<tspan x="%.1f" y="%.1f">%s</tspan>' % (c['x'], ty + i * lh, esc(l)) for i, l in enumerate(en))
    zy = ty + len(en) * lh + 1
    extra = ''
    if stay_at.get(c['id']):       # a staying law: a small closed ring on the box's lower right corner
        extra += '<circle class="ring" cx="%.1f" cy="%.1f" r="5.2"></circle>' % (c['x'] + BW / 2 - 9, c['y'] + BH / 2 - 9)
    if tested.get(c['id']):
        extra += '<circle class="tdot" cx="%.1f" cy="%.1f" r="3.2"></circle>' % (c['x'] - BW / 2 + 8, c['y'] + BH / 2 - 8)
    cls = 'node' + (' wanted' if c['id'] in WANTED else '')
    return ('<g class="%s" data-id="%s" tabindex="0" role="button" aria-label="%s">'
            '<rect class="box" x="%.1f" y="%.1f" width="%d" height="%d" rx="7"></rect>'
            '<text class="nm">%s</text><text class="zh" x="%.1f" y="%.1f">%s</text>%s</g>') % (cls, c['id'], esc(c['en']), x, yy, BW, BH, t, c['x'], zy, esc(c['zh']), extra)

svg = ['<svg id="sheet" class="sheet" viewBox="0 0 %d %d" role="img" aria-label="The map: fourteen rows of boxes with the arrows between them">' % (W, H)]
for b, y0, y1 in band_boxes:
    svg.append('<g class="band band-%s"><rect class="bandbg" x="0" y="%.1f" width="%d" height="%.1f" rx="10"></rect>'
               '<text class="bandt" x="12" y="%.1f"><tspan class="bande">%s </tspan><tspan class="bandz">%s</tspan></text></g>' % (b['id'], y0, W, y1 - y0, y0 + 17, esc(b['en'].upper()), esc(b['zh'])))
for r in ROWS:
    R = rows[r['id']]
    en = wrap(r['en'], 26)
    ty = R['cy'] - (len(en) * 13 + 13) / 2 + 10
    t = ''.join('<tspan x="12" y="%.1f">%s</tspan>' % (ty + i * 13, esc(l)) for i, l in enumerate(en))
    svg.append('<g class="rowl" data-row="%s"><line class="rowline" x1="%d" y1="%.1f" x2="%d" y2="%.1f"></line><text class="rown">%s</text><text class="rowz" x="12" y="%.1f">%s</text></g>'
               % (r['id'], GX - 8, R['y0'] + RH - 1, W - 8, R['y0'] + RH - 1, t, ty + len(en) * 13 + 1, esc(r['zh'])))
svg.append('<g class="edges">')
for q in passages:
    cls = 'edge k-%s%s%s' % (q['kind'], ' far' if q['far'] else '', ' cross' if q['cross'] else '')
    hd = ''
    if q['kind'] == 'line': hd = '<path class="bar" d="%s"></path>' % q['bar']
    elif q['kind'] != 'same': hd = '<path class="hd" d="%s"></path>' % q['h1']
    inner = '<path class="ln2" d="%s"></path>' % q['d'] if q['kind'] == 'same' else ''
    stub = ''
    if q['far']:
        s0, h0, s1, h1 = q['stub']
        stub = '<g class="stub"><path class="ln" d="%s"></path><path class="hd" d="%s"></path><path class="ln" d="%s"></path><path class="hd" d="%s"></path></g>' % (s0, h0, s1, h1)
    svg.append('<g class="%s" data-id="%s" data-from="%s" data-to="%s">%s<g class="full"><path class="hit" d="%s"></path><path class="ln" d="%s"></path>%s%s</g></g>'
               % (cls, q['id'], q['from'], q['to'], stub, q['d'], q['d'], inner, hd))
svg.append('</g><g class="nodes">')
for cid in order: svg.append(node_svg(conds[cid]))
svg.append('</g><g id="marks"></g></svg>')
SVG = '\n'.join(svg)

# ------------------------------------------------------------------ data for the page
counts = {'conds': len(order), 'rows': len(ROWS), 'passages': len(passages),
          'two': sum(1 for q in passages if not q['single'] and q['laws']), 'one': sum(1 for q in passages if q['single'] and q['laws']),
          'nolean': sum(1 for q in passages if not q['laws']), 'stays': len(stays),
          'anchored': sum(1 for c in conds.values() if c['anchors']), 'kinds': dict(collections.Counter(q['kind'] for q in passages))}
dirs = collections.Counter()
for q in passages:
    if q['kind'] in ('line', 'same'): continue
    a_, b_ = conds[q['from']], conds[q['to']]
    if a_['row'] != b_['row'] or a_['row'] in ('e1', 'e2'): continue
    dirs[('right' if b_['col'] > a_['col'] else 'left', q['kind'])] += 1
counts['dirs_within_rows'] = {'%s/%s' % k: v for k, v in sorted(dirs.items())}
print(counts)

D = {
    'rows': [{'id': r['id'], 'en': r['en'], 'zh': r['zh'], 'band': r['band']} for r in ROWS],
    'bands': BANDS,
    'conds': {cid: {k: conds[cid][k] for k in ('id', 'row', 'col', 'en', 'zh', 'says_en', 'says_zh', 'eg_en', 'eg_zh', 'known_as', 'known_zh', 'x', 'y', 'anchors')} for cid in order},
    'order': order,
    'passages': [{k: q.get(k) for k in ('id', 'from', 'to', 'kind', 'en', 'zh', 'laws', 'single', 'tag_en', 'tag_zh', 'more', 'mid', 'tagpos', 'far')} for q in passages],
    'stays': stays, 'dynAt': dyn_at, 'paths': PATHS, 'cases': CASES, 'wanted': WANTED, 'bandEnd': {b_['id']: y1_ for b_, y0_, y1_ in band_boxes},
    'geo': {'BW': BW, 'BH': BH, 'W': W, 'H': H}, 'counts': counts, 'lead': LEAD,
}
page = open(os.path.join(HERE, 'template.html')).read()
page = page.replace('/*SVG*/', SVG).replace('/*DATA*/', json.dumps(D, ensure_ascii=False).replace('</', '<\\/'))
open(os.path.join(HERE, 'map.html'), 'w').write(page)
standalone = '<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover"><style>:root{color-scheme:light}body{margin:0;font:14px system-ui}img{max-width:100%}[hidden]{display:none!important}</style></head><body>' + page + '</body></html>'
open(os.path.join(HERE, 'preview.html'), 'w').write(standalone)
json.dump({'passages': passages, 'stays': stays, 'counts': counts, 'conds': conds, 'rows': ROWS, 'bands': BANDS}, open(os.path.join(HERE, 'built.json'), 'w'), ensure_ascii=False, indent=1)
print('wrote map.html', len(page), 'bytes')
