#!/usr/bin/env python3
"""Build the second prototype's page from the question store: questions.json (cast, questions, answers, places as sets
of answers, the chart's two axes) and a rows file (one row per Lean law). Everything drawn is computed from those two;
only the six roles of the small web are placed by hand. AI-written prototype, 11 November 2026.
Usage: build.py ROWS.json OUT.html"""
import html, json, math, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
SITE = 'https://yongxu.github.io/theories/theories/becoming/results/atlas/families/'
RANK = ['exact', 'sufficient', 'necessary', 'witness', 'reading', 'open']
store = json.loads((HERE / 'questions.json').read_text())
rows = json.loads(Path(sys.argv[1]).read_text())
v1 = {p['id']: p for p in json.loads((HERE.parent / 'places' / 'places-v1.json').read_text())}
dyn = {d['id']: d for d in json.loads((ROOT / 'theories/becoming/results/atlas/entries/dynamics.json').read_text())}
QS = store['questions']
Q = {q['id']: q for q in QS}
esc = html.escape


def rank(s):
    return RANK.index(s) if s in RANK else len(RANK)


def answer(q, a):
    return next((x for x in Q[q]['answers'] if x['id'] == a), None) if q in Q else None


def wrap(t, n):
    out, line = [], ''
    for w in t.split():
        if line and len(line) + 1 + len(w) > n:
            out.append(line); line = w
        else:
            line = (line + ' ' + w).strip()
    return out + [line]


def kind_of(r):
    return 'reading' if r['strength'] in ('reading', 'open') else 'witness' if r['strength'] == 'witness' else r['by'] if r['shape'] == 'moves' else r['shape']


# ---- the rows, checked against the store ----------------------------------------------------------------------------
laws, unplaced = [], []
for r in rows:
    r = dict(r)
    r['family'] = dyn[r['dynamic']]['family'].lower() if r.get('dynamic') in dyn else ''
    r['name'] = dyn[r['dynamic']]['name']['en'] if r.get('dynamic') in dyn else ''
    r['given'] = {q: a for q, a in (r.get('given') or {}).items() if answer(q, a) and q != r.get('on')}
    ok = r.get('shape') in ('keeps', 'moves', 'line') and r.get('on') in Q and answer(r['on'], r.get('to')) \
        and (r.get('from') == 'any' or answer(r['on'], r.get('from')))
    (laws if ok else unplaced).append(r)
for i, r in enumerate(laws):
    r['id'] = f'L{i}'

places = []
for p in store['places']:
    old = v1.get(p['id'], {})
    places.append({'id': p['id'], 'label': p.get('label') or old.get('label'), 'gloss': p.get('gloss') or old.get('gloss', ''),
                   'example': p.get('example') or old.get('example', ''), 'answers': p['answers'],
                   'how_far': p.get('how_far') or old.get('how_far'), 'note': p.get('note', '')})

# ---- what the store shows without being told ------------------------------------------------------------------------
arrive = {(q['id'], a['id']): [] for q in QS for a in q['answers']}
for r in laws:
    if r['shape'] == 'moves':
        arrive[(r['on'], r['to'])].append(r)
        if r.get('fork') and answer(r['on'], r['fork'].get('to')) and r['fork']['to'] != r['from']:
            arrive[(r['on'], r['fork']['to'])].append(r)
used = {(q, a) for r in laws for q, a in r['given'].items()} | {(r['on'], r['to']) for r in laws if r['shape'] == 'keeps'}
taken = {k: sum(1 for r in laws if r['given'].get(k[0]) == k[1]) for k in arrive}
never_arrived = sorted([k for k, v in arrive.items() if taken[k] and not [r for r in v if r['strength'] in RANK[:3] and r['by'] == 'itself']], key=lambda k: -taken[k])

# ---- shared mark drawing ---------------------------------------------------------------------------------------------
def count(n, x, y):
    return f'<text class="n" x="{x:.0f}" y="{y:.0f}">{n}</text>' if n > 1 else ''


def mark(cls, rs, body, label):
    best = min(rs, key=lambda r: rank(r['strength']))['strength']
    return (f'<g class="mark {cls} s-{best} k-{kind_of(rs[0])}" data-laws="{" ".join(r["id"] for r in rs)}" tabindex="0" role="button" '
            f'aria-label="{label}, {len(rs)} law{"s" if len(rs) > 1 else ""}">{body}</g>')


def head(rs):
    k = kind_of(rs[0])
    return 'aro' if k == 'outside' else 'ars' if k == 'reading' else 'ar'


# ---- the chart: two chains of questions as its axes ------------------------------------------------------------------
CH_ = store['chart']
DOWN, ACROSS = CH_['down']['bands'], CH_['across']['bands']
DQ = {q for b in DOWN for q in b['answers']}
AQ = {q for b in ACROSS for q in b['answers']}
GX, GY, CW2, CH2 = 192, 112, 242, 138
CWID, CHGT = GX + len(ACROSS) * CW2 + 14, GY + len(DOWN) * CH2 + 16


def band_of(bands, q, a):
    """The first band that gives question q the answer a."""
    return next((i for i, b in enumerate(bands) if b['answers'].get(q) == a), None)


def span(bands, given, axis_q, silent):
    """Indices of the bands a law's given leaves open. A law silent on the whole axis sits in the band `silent`."""
    keys = [q for q in given if q in axis_q]
    if not keys:
        return silent
    return [i for i, b in enumerate(bands) if all(q not in b['answers'] or b['answers'][q] == given[q] for q in keys)
            and any(q in b['answers'] for q in keys)]


chart, cmarks, off_chart = [], [], []
chart.append(f'<text class="ax mid" x="{GX + len(ACROSS) * CW2 / 2}" y="14">{esc(CH_["across"]["label"]["en"])} <tspan class="hz">{esc(CH_["across"]["label"]["zh"])}</tspan></text>')
chart.append(f'<text class="ax" x="8" y="{GY - 12}">{esc(CH_["down"]["label"]["en"])} <tspan class="hz">{esc(CH_["down"]["label"]["zh"])}</tspan></text>')
col_name, row_name, cell_name = {}, {}, {}
for p in places:
    pd = {q: a for q, a in p['answers'].items() if q in DQ}
    pa = {q: a for q, a in p['answers'].items() if q in AQ}
    rws = [i for i, b in enumerate(DOWN) if pd and all(b['answers'].get(q) == a for q, a in pd.items())]
    cls_ = [j for j, b in enumerate(ACROSS) if pa and all(b['answers'].get(q) == a for q, a in pa.items())]
    if (pd and not rws) or (pa and not cls_) or not (pd or pa):
        continue
    if rws and cls_:
        cell_name[(rws[0], cls_[0])] = p
    elif rws:
        row_name.update({i: p for i in rws})
    else:
        col_name.update({j: p for j in cls_})
for j, b in enumerate(ACROSS):
    x = GX + j * CW2 + CW2 / 2
    y = 40
    if j in col_name:
        chart.append(f'<text class="pl" x="{x}" y="{y}" text-anchor="middle">{esc(col_name[j]["label"]["en"])}</text>')
    for i, l in enumerate(wrap(b['say']['en'], 32)):
        chart.append(f'<text class="hd" x="{x}" y="{y + 18 + i * 15}">{esc(l)}</text>')
    chart.append(f'<text class="hz" x="{x}" y="{y + 18 + len(wrap(b["say"]["en"], 32)) * 15 + 1}">{esc(b["say"]["zh"])}</text>')
for i, b in enumerate(DOWN):
    y = GY + i * CH2
    yy = y + 30
    if i in row_name:
        for k, l in enumerate(wrap(row_name[i]['label']['en'], 22)):
            chart.append(f'<text class="pl" x="8" y="{yy + k * 16}">{esc(l)}</text>')
        yy += 16 * len(wrap(row_name[i]['label']['en'], 22)) + 4
    ls = wrap(b['say']['en'], 24)
    for k, l in enumerate(ls):
        chart.append(f'<text class="hd l" x="8" y="{yy + k * 15}">{esc(l)}</text>')
    chart.append(f'<text class="hz l" x="8" y="{yy + len(ls) * 15 + 1}">{esc(b["say"]["zh"])}</text>')
    for j, c in enumerate(ACROSS):
        both = {**b['answers'], **c['answers']}
        chart.append(f'<g class="cell2" data-set="{esc(json.dumps(both))}" tabindex="0" role="button" aria-label="{esc(b["say"]["en"])}; {esc(c["say"]["en"])}">'
                     f'<rect x="{GX + j * CW2}" y="{y}" width="{CW2}" height="{CH2}"/></g>')
        if (i, j) in cell_name:
            chart.append(f'<text class="pl mid" x="{GX + j * CW2 + CW2 / 2}" y="{y + CH2 / 2 + 5}">{esc(cell_name[(i, j)]["label"]["en"])}</text>')

groups = {}
for r in laws:
    q = r['on']
    if q in DQ:
        i = 'any' if r['from'] == 'any' else band_of(DOWN, q, r['from'])
        j = band_of(DOWN, q, r['to'])
        if q == 'source' and r['to'] == 'results':
            j = 1
        sp = span(ACROSS, r['given'], AQ, [0])
        ax, bands, other = 'v', DOWN, ACROSS
    elif q in AQ:
        i, j = band_of(ACROSS, q, r['from']), band_of(ACROSS, q, r['to'])
        if q == 'time' and r['shape'] != 'keeps':
            i, j = (2, 3) if r['to'] == 'too-late' else (3, 2)
        sp = span(DOWN, r['given'], DQ, list(range(len(DOWN))))
        ax, bands, other = 'h', ACROSS, DOWN
    else:
        continue
    if i is None or j is None or not sp:
        off_chart.append(r['id']); continue
    if r['shape'] == 'line' and i > j:
        i, j = j, i
    key = f"{ax} {'any' if i == 'any' else bands[i]['id']}>{bands[j]['id']} {r['shape']} {kind_of(r)} [{other[sp[0]]['id']}..{other[sp[-1]]['id']}]"
    groups.setdefault((ax, i, j, r['shape'], kind_of(r), sp[0], sp[-1], key), []).append(r)
KEY = CH_.get('key', [])
num = {m: n + 1 for n, k in enumerate(KEY) for m in k['match']}
key_laws = {n + 1: [] for n in range(len(KEY))}
if '--groups' in sys.argv:
    for g, rs in sorted(groups.items(), key=lambda g: g[0][-1]):
        print(('%2s' % num.get(g[-1], '')), g[-1], f'×{len(rs)} ::', min(rs, key=lambda r: rank(r['strength']))['plain_en'][:100])


def badge(n, x, y):
    return f'<circle class="bd" cx="{x:.0f}" cy="{y:.0f}" r="9.5"/><text class="bn" x="{x:.0f}" y="{y + 3.8:.0f}">{n}</text>' if n else ''


merged = {}
for g, rs in sorted(groups.items(), key=lambda g: (num.get(g[0][-1], 99), 0 if g[0][1] == 'any' else 1, g[0][-1])):
    ax, i, j, shape, kind, s0, s1, key = g
    n = num.get(key)
    m = (n, ax, j, s0, shape) if n else g
    if m in merged:
        merged[m][1].extend(rs)
    else:
        merged[m] = [g, list(rs)]
slot = {}
for g, rs in merged.values():
    ax, i, j, shape, kind, s0, s1, key = g
    rs.sort(key=lambda r: rank(r['strength']))
    n = num.get(key)
    if n:
        key_laws[n] += [r['id'] for r in rs]
    cls = shape + ('' if n else ' minor')
    if ax == 'v':
        xl, xr = GX + s0 * CW2, GX + (s1 + 1) * CW2
        if shape == 'keeps':
            k = slot.get(('vk', j, s0), 0); slot[('vk', j, s0)] = k + 1
            cx, cy = xl + 24 + k * 34, GY + j * CH2 + CH2 - 22
            body = f'<circle class="hit" cx="{cx}" cy="{cy}" r="14"/><path class="ln" d="M{cx - 7},{cy} a7,7 0 1 1 7,7" marker-end="url(#ar)"/>' + badge(n, cx + 13, cy - 10)
        elif shape == 'line':
            y = GY + max(i, j) * CH2
            d = f'M{xl + 16},{y - 3} H{xr - 16} M{xl + 16},{y + 3} H{xr - 16}'
            body = f'<rect class="hit" x="{xl + 16}" y="{y - 10}" width="{xr - xl - 32}" height="20"/><path class="ln" d="{d}"/>' + badge(n, xr - 30, y)
        else:
            k = slot.get(('vm', j, s0), 0); slot[('vm', j, s0)] = k + 1
            x = GX + (s0 + 1) * CW2 - 30 - k * 30
            if i == 'any':
                y1, y2 = GY + j * CH2 - 34, GY + j * CH2 + 18
            elif j > i:
                y1, y2 = GY + j * CH2 - 30, GY + j * CH2 + 22
            else:
                y1, y2 = GY + (j + 1) * CH2 + 30, GY + (j + 1) * CH2 - 22
            d = f'M{x},{y1} V{y2}'
            body = f'<path class="hit" d="{d}"/><path class="ln" d="{d}" marker-end="url(#{head(rs)})"/>' + badge(n, x, y1 - 11 if y2 > y1 else y1 + 11)
            if i == 'any' and n:
                body += f'<text class="any" x="{x - 14}" y="{y1 - 6}" text-anchor="end">any start</text>'
    else:
        yt, yb = GY + s0 * CH2, GY + (s1 + 1) * CH2
        if shape == 'keeps':
            k = slot.get(('hk', j), 0); slot[('hk', j)] = k + 1
            cx, cy = GX + j * CW2 + CW2 / 2 - 20 + k * 34, yt + 26
            body = f'<circle class="hit" cx="{cx}" cy="{cy}" r="14"/><path class="ln" d="M{cx - 7},{cy} a7,7 0 1 1 7,7" marker-end="url(#ar)"/>' + badge(n, cx + 13, cy - 10)
        elif shape == 'line':
            x = GX + max(i, j) * CW2
            d = f'M{x - 3},{yt + 14} V{yb - 14} M{x + 3},{yt + 14} V{yb - 14}'
            body = f'<rect class="hit" x="{x - 10}" y="{yt + 14}" width="20" height="{yb - yt - 28}"/><path class="ln" d="{d}"/>' + badge(n, x, yt + 30)
        else:
            k = slot.get(('hm', i, j), 0); slot[('hm', i, j)] = k + 1
            y = yt + 70 + k * 26
            right = j > i
            x1, x2 = (GX + j * CW2 - 34, GX + j * CW2 + 30) if right else (GX + (j + 1) * CW2 + 34, GX + (j + 1) * CW2 - 30)
            d = f'M{x1},{y} H{x2}'
            body = f'<path class="hit" d="{d}"/><path class="ln" d="{d}" marker-end="url(#{head(rs)})"/>' + badge(n, x1 - 12 if right else x1 + 12, y)
    cmarks.append(mark(cls, rs, body, {'keeps': 'stays', 'line': 'a border', 'moves': 'a change'}[shape]))
chart_svg = '\n'.join(chart + cmarks)
chart_key = [{'n': n + 1, 'say': k['say'], 'laws': key_laws[n + 1],
              'best': min((r['strength'] for r in laws if r['id'] in key_laws[n + 1]), key=rank, default=None)} for n, k in enumerate(KEY)]

# ---- the strips: one row for each question that is not an axis of the chart ------------------------------------------
STRIP = [q for q in QS if q['id'] not in DQ | AQ]
LEFT, CW, CH, GAP, RH, TOP = 344, 178, 50, 26, 110, 8
SW, SH = LEFT + 4 * (CW + GAP) + 10, TOP + RH * len(STRIP) + 6


def cell(q, a):
    qi = [x['id'] for x in STRIP].index(q)
    ai = [x['id'] for x in Q[q]['answers']].index(a)
    return LEFT + ai * (CW + GAP), TOP + qi * RH + 40


strip, smarks = [], []
for qi, q in enumerate(STRIP):
    y0 = TOP + qi * RH
    if qi:
        strip.append(f'<line class="rule" x1="0" y1="{y0 - 4}" x2="{SW}" y2="{y0 - 4}"/>')
    en = wrap(q['ask']['en'], 34)
    zh = [q['ask']['zh'][i:i + 19] for i in range(0, len(q['ask']['zh']), 19)]
    for i, l in enumerate(en):
        strip.append(f'<text class="q" x="6" y="{y0 + 44 + i * 16}">{esc(l)}</text>')
    for i, l in enumerate(zh):
        strip.append(f'<text class="qz" x="6" y="{y0 + 44 + len(en) * 16 + 2 + i * 15}">{esc(l)}</text>')
    for a in q['answers']:
        x, y = cell(q['id'], a['id'])
        ls = wrap(a['say']['en'], 25)[:2]
        ty = y + (20 if len(ls) == 1 else 15)
        strip.append(f'<g class="cell" data-q="{q["id"]}" data-a="{a["id"]}" tabindex="0" role="button" aria-label="{esc(a["say"]["en"])}">'
                     f'<rect x="{x}" y="{y}" width="{CW}" height="{CH}" rx="7"/>'
                     + ''.join(f'<text class="al" x="{x + CW / 2}" y="{ty + i * 14}">{esc(l)}</text>' for i, l in enumerate(ls))
                     + f'<text class="az" x="{x + CW / 2}" y="{y + CH - 6}">{esc(a["say"]["zh"])}</text></g>')
    sg, lift = {}, {}
    for r in [r for r in laws if r['on'] == q['id']]:
        sg.setdefault((r['shape'], r['from'], r['to'], kind_of(r)), []).append(r)
    for (shape, frm, to, kind), rs in sorted(sg.items(), key=lambda g: tuple(str(x) for x in g[0])):
        n = len(rs)
        if shape == 'keeps':
            x, y = cell(q['id'], to)
            k = lift.get(('k', to), 0); lift[('k', to)] = k + 1
            cx, cy = x + CW - 14 - k * 28, y + CH + 12
            body = f'<circle class="hit" cx="{cx}" cy="{cy}" r="12"/><path class="ln" d="M{cx - 6},{cy} a6,6 0 1 1 6,6" marker-end="url(#ar)"/>' + count(n, cx + 13, cy + 4)
            smarks.append(mark('keeps', rs, body, 'stays'))
        elif shape == 'line':
            (x1, y1), (x2, _) = cell(q['id'], frm), cell(q['id'], to)
            lo, hi = min(x1, x2), max(x1, x2)
            if hi - lo == CW + GAP:
                bx = lo + CW + GAP / 2
                d = f'M{bx - 3},{y1 - 5} V{y1 + CH + 5} M{bx + 3},{y1 - 5} V{y1 + CH + 5}'
                body = f'<rect class="hit" x="{bx - 11}" y="{y1 - 6}" width="22" height="{CH + 12}"/><path class="ln" d="{d}"/>' + count(n, bx, y1 + CH + 18)
            else:
                k = lift.get(('l', lo, hi), 0); lift[('l', lo, hi)] = k + 1
                by_ = y1 + CH + 9 + k * 8
                d = f'M{lo + CW / 2},{by_ - 4} V{by_} H{hi + CW / 2} V{by_ - 4}'
                body = f'<path class="hit" d="{d}"/><path class="ln" d="{d}"/>' + count(n, (lo + hi + CW) / 2, by_ + 12)
            smarks.append(mark('line', rs, body, 'a border'))
        else:
            x2, y2 = cell(q['id'], to)
            if frm == 'any':
                sx, ex = LEFT - 20, x2 + 26
            else:
                x1, _ = cell(q['id'], frm)
                sx, ex = (x1 + CW - 30, x2 + 30) if x2 > x1 else (x1 + 30, x2 + CW - 30)
            k = lift.get(('m', min(sx, ex), max(sx, ex)), 0); lift[('m', min(sx, ex), max(sx, ex))] = k + 1
            hgt = 14 + 11 * k + min(12, abs(ex - sx) / 34)
            d = f'M{sx:.0f},{y2 - 2} C{sx:.0f},{y2 - hgt * 1.5:.0f} {ex:.0f},{y2 - hgt * 1.5:.0f} {ex:.0f},{y2 - 3}'
            body = f'<path class="hit" d="{d}"/><path class="ln" d="{d}" marker-end="url(#{head(rs)})"/>' + count(n, (sx + ex) / 2, y2 - hgt * 1.12 - 2)
            if frm == 'any' and k == 0:
                body += f'<text class="any" x="{LEFT - 24}" y="{y2 + 12}">any start</text>'
            smarks.append(mark('moves', rs, body, 'a change'))
strip_svg = '\n'.join(strip + smarks)

# ---- the small web: six roles, one line per question -----------------------------------------------------------------
POS = {'rule': (320, 46), 'ahead': (530, 128), 'others': (530, 300), 'store': (320, 348), 'dependants': (100, 300), 'say': (100, 128)}
VERB = {'source': 'set', 'held': 'favours', 'ways': 'share a way?', 'pays': 'bending pays?', 'judges': 'judge', 'draws': 'use up', 'reach': 'reaches?',
        'counts': 'counts?', 'there': 'among them?', 'time': 'in time?', 'on': 'live on'}
CURVE = {'source': 40, 'held': 40, 'time': 26, 'on': 26}
web = []
for q in QS:
    a, _, b = q['about']
    (x1, y1), (x2, y2) = POS[a], POS[b]
    if q['id'] == 'pays':
        d = f'M{x1 - 10},{y1 - 24} c-6,-44 60,-44 46,-2'
        lx, ly = x1 + 22, y1 - 62
    else:
        n = math.hypot(x2 - x1, y2 - y1)
        ux, uy = (x2 - x1) / n, (y2 - y1) / n
        c = CURVE.get(q['id'], 0)
        mx, my = (x1 + x2) / 2 - uy * c, (y1 + y2) / 2 + ux * c
        s, e = (x1 + ux * 50 - uy * c * .35, y1 + uy * 28 + ux * c * .35), (x2 - ux * 54 - uy * c * .35, y2 - uy * 30 + ux * c * .35)
        d = f'M{s[0]:.0f},{s[1]:.0f} Q{mx:.0f},{my:.0f} {e[0]:.0f},{e[1]:.0f}'
        lx, ly = (s[0] + 2 * mx + e[0]) / 4, (s[1] + 2 * my + e[1]) / 4
    end = '' if q['id'] == 'ways' else ' marker-end="url(#ars)"'
    web.append(f'<g class="edge" data-q="{q["id"]}" tabindex="0" role="button" aria-label="{esc(q["ask"]["en"])}"><path class="hit" d="{d}"/><path class="ln" d="{d}"{end}/>'
               f'<text class="ev" x="{lx:.0f}" y="{ly - 4:.0f}">{esc(VERB[q["id"]])}</text><text class="ea" x="{lx:.0f}" y="{ly + 10:.0f}"></text></g>')
for r in store['cast']:
    x, y = POS[r['id']]
    web.append(f'<g class="role"><rect x="{x - 72}" y="{y - 22}" width="144" height="44" rx="22"/><text class="rl" x="{x}" y="{y - 1}">{esc(r["en"])}</text><text class="rz" x="{x}" y="{y + 14}">{esc(r["zh"])}</text></g>')
web_svg = '\n'.join(web)

# ---- the chain the region turns on, link by link, looked up in the rows ----------------------------------------------
chain = []
for link in store['loop']:
    (q1, a1), (q2, a2), kind = link['from'], link['to'], link['kind']
    hits = [r for r in laws if r['on'] == q2 and r['to'] == a2 and r['shape'] == kind and r['given'].get(q1) == a1]
    best = min(hits, key=lambda r: rank(r['strength'])) if hits else None
    chain.append({'from': [q1, a1], 'to': [q2, a2], 'kind': kind, 'laws': [r['id'] for r in hits], 'best': best['strength'] if best else None,
                  'taken': sum(1 for r in laws if r['given'].get(q2) == a2),
                  'modules': sorted({r['module'].split('.')[1] for r in hits if r['module'].count('.')})})

counts = {'questions': len(QS), 'answers': sum(len(q['answers']) for q in QS), 'places': len(places),
          'laws': len(laws), 'items': sum(len(r.get('items') or []) for r in laws), 'unplaced': len(unplaced),
          'moves': sum(r['shape'] == 'moves' for r in laws), 'lines': sum(r['shape'] == 'line' for r in laws), 'keeps': sum(r['shape'] == 'keeps' for r in laws),
          'outside': sum(r['shape'] == 'moves' and r['by'] == 'outside' for r in laws), 'witness': sum(r['strength'] == 'witness' for r in laws),
          'itself': sum(r['shape'] == 'moves' and r['by'] == 'itself' and r['strength'] in RANK[:3] for r in laws),
          'modules': len({r['module'] for r in laws}), 'never': len(never_arrived), 'offchart': len(off_chart)}
KEEP = ('id', 'dynamic', 'name', 'family', 'lean', 'items', 'on', 'shape', 'from', 'to', 'fork', 'given', 'by', 'measure_en', 'within', 'plain_en', 'plain_zh', 'strength', 'module')
slim = [{k: r.get(k) for k in KEEP} for r in laws]
waiting = [{'lean': r.get('lean', ''), 'dynamic': r.get('dynamic'), 'name': r.get('name'), 'family': r.get('family'), 'plain_en': r.get('plain_en', ''), 'needs': (r.get('needs') or r.get('unplaced_why') or '')[:260]} for r in unplaced]
data = {'questions': [{k: v for k, v in q.items() if k != 'answers'} | {'answers': [{'id': a['id'], 'say': a['say'], 'tag': a.get('tag', '')} for a in q['answers']]} for q in QS],
        'cast': store['cast'], 'places': places, 'laws': slim, 'unplaced': waiting, 'chain': chain, 'key': chart_key,
        'never': [[q, a, taken[(q, a)]] for q, a in never_arrived], 'off_chart': off_chart, 'counts': counts, 'site': SITE}
page = (HERE / 'template.html').read_text()
page = (page.replace('/*CHART*/', chart_svg).replace('/*STRIP*/', strip_svg).replace('/*WEB*/', web_svg)
        .replace('/*CW*/', str(CWID)).replace('/*CH*/', str(CHGT)).replace('/*SW*/', str(SW)).replace('/*SH*/', str(SH))
        .replace('/*DATA*/', json.dumps(data, ensure_ascii=False).replace('</', '<\\/')))
for k, v in counts.items():
    page = page.replace('{{' + k + '}}', str(v))
Path(sys.argv[2]).write_text(page)
print(counts)
print('no law arrives at:', [f'{q}:{a} (given in {taken[(q, a)]})' for q, a in never_arrived])
print('off the chart:', len(off_chart), '| unplaced:', len(unplaced))
for c in chain:
    print('chain', c['from'], '->', c['to'], c['best'], c['modules'], len(c['laws']))
