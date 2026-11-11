#!/usr/bin/env python3
"""Draw the places map from data: places (places-v1.json), decisions on every atlas item (decisions.json) and a hand-set
layout (layout.json). Writes one self-contained HTML page: a static SVG complete at rest, with a panel that opens on a
click. AI-written prototype, 11 November 2026. Usage: draw.py DECISIONS.json OUT.html"""
import html, json, math, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
SITE = 'https://yongxu.github.io/theories/theories/becoming/results/atlas/families/'
RANK = ['exact', 'sufficient', 'necessary', 'witness', 'reading', 'open']
W, H, NW, NH = 1240, 650, 184, 60

places = json.loads((HERE / 'places-v1.json').read_text())
layout = json.loads((HERE / 'layout.json').read_text())
decisions = json.loads(Path(sys.argv[1]).read_text())
dyn = {d['id']: d for d in json.loads((ROOT / 'theories/becoming/results/atlas/entries/dynamics.json').read_text())}
by = {p['id']: p for p in places}
pos = layout['pos']


def rank(s):
    return RANK.index(s) if s in RANK else len(RANK)


def info(d):
    e = dyn[d['dynamic']]
    return {'dynamic': d['dynamic'], 'name': e['name']['en'], 'family': e['family'].lower(), 'item': d['item'],
            'en': d.get('condition_en') or d.get('note') or '', 'zh': d.get('condition_zh') or '',
            'strength': d['strength'], 'law': d.get('law') or '', 'kind': d.get('kind') or ''}


# arrows grouped by unordered pair; each item keeps its own direction
pairs = {}
for d in decisions:
    if d['decision'] != 'arrow' or d.get('from') not in by or d.get('to') not in by or d['from'] == d['to']:
        continue
    key = tuple(sorted((d['from'], d['to'])))
    pairs.setdefault(key, []).append({**info(d), 'from': d['from'], 'to': d['to'], 'both': bool(d.get('both_ways'))})
notes = {p['id']: {'stays': [], 'inside': [], 'out': []} for p in places}
unplaced = []
for d in decisions:
    k = d['decision']
    where = d.get('place') or d.get('from')
    if k in ('stays', 'inside') and where in by:
        notes[where][k].append(info(d))
    elif k == 'leads-out' and where in by:
        notes[where]['out'].append(info(d))
    elif k == 'arrow' and d.get('from') == d.get('to') and d.get('from') in by:
        notes[d['from']]['inside'].append(info(d))
    elif k != 'arrow':
        unplaced.append(info(d))


def edge_point(c, toward):
    """Where the ray from a box's centre toward a point leaves the box."""
    (cx, cy), (tx, ty) = c, toward
    dx, dy = tx - cx, ty - cy
    if dx == 0 and dy == 0:
        return cx, cy
    s = min((NW / 2 + 5) / abs(dx) if dx else 1e9, (NH / 2 + 5) / abs(dy) if dy else 1e9)
    return cx + dx * s, cy + dy * s


def wrap(text, width=25):
    out, line = [], ''
    for w in text.split():
        if line and len(line) + 1 + len(w) > width:
            out.append(line); line = w
        else:
            line = (line + ' ' + w).strip()
    return out + [line]


svg, edges = [], []
for (a, b), items in sorted(pairs.items()):
    best = min(items, key=lambda i: rank(i['strength']))['strength']
    fwd = any(i['from'] == a or i['both'] for i in items)
    back = any(i['from'] == b or i['both'] for i in items)
    (ax, ay), (bx, by_) = pos[a], pos[b]
    mx, my = (ax + bx) / 2, (ay + by_) / 2
    n = math.hypot(bx - ax, by_ - ay) or 1
    curv = layout.get('curv', {}).get(f'{a}|{b}', 0)
    cx, cy = mx - (by_ - ay) / n * curv, my + (bx - ax) / n * curv
    s, e = edge_point((ax, ay), (cx, cy)), edge_point((bx, by_), (cx, cy))
    tx, ty = (s[0] + 2 * cx + e[0]) / 4, (s[1] + 2 * cy + e[1]) / 4
    eid = f'{a}__{b}'
    cls = best if best in RANK else 'reading'
    mk = 'm-soft' if cls in ('reading', 'open') else 'm-open' if cls == 'necessary' else 'm-ink'
    attrs = (f' marker-end="url(#{mk})"' if fwd else '') + (f' marker-start="url(#{mk}-s)"' if back else '')
    svg.append(f'<g class="edge s-{cls}" data-edge="{eid}" tabindex="0" role="button" aria-label="{html.escape(by[a]["label"]["en"])} to {html.escape(by[b]["label"]["en"])}, {len(items)} laws">'
               f'<path class="hit" d="M{s[0]:.1f},{s[1]:.1f} Q{cx:.1f},{cy:.1f} {e[0]:.1f},{e[1]:.1f}"/>'
               f'<path class="line" d="M{s[0]:.1f},{s[1]:.1f} Q{cx:.1f},{cy:.1f} {e[0]:.1f},{e[1]:.1f}"{attrs}/>'
               + (f'<circle class="chip" cx="{tx:.1f}" cy="{ty:.1f}" r="9"/><text class="chipn" x="{tx:.1f}" y="{ty + 3.6:.1f}">{len(items)}</text>' if len(items) > 1 else '')
               + '</g>')
    tag = layout.get('tags', {}).get(f'{a}|{b}')
    if tag:
        ox, oy = layout.get('tagoff', {}).get(f'{a}|{b}', [0, -12])
        svg.append(f'<text class="tag" x="{tx + ox:.1f}" y="{ty + oy:.1f}">{html.escape(tag)}</text>')
    edges.append({'id': eid, 'a': a, 'b': b, 'best': cls, 'items': items})

for a, b, word in layout.get('links', []):
    s_, e_ = edge_point(pos[a], pos[b]), edge_point(pos[b], pos[a])
    svg.append(f'<path class="rel" d="M{s_[0]:.1f},{s_[1]:.1f} L{e_[0]:.1f},{e_[1]:.1f}"/>'
               f'<text class="tag" x="{(s_[0] + e_[0]) / 2 + (30 if s_[0] == e_[0] else 0):.1f}" y="{(s_[1] + e_[1]) / 2 + (4 if s_[0] == e_[0] else -7):.1f}">{html.escape(word)}</text>')

for p in places:
    x, y = pos[p['id']]
    soft = p.get('how_far') in ('a reading', 'open')
    lines = wrap(p['label']['en'])
    top = y - (len(lines) * 16 + 15) / 2 + 12
    text = ''.join(f'<text class="nl" x="{x}" y="{top + i * 16:.1f}">{html.escape(l)}</text>' for i, l in enumerate(lines))
    text += f'<text class="nz" x="{x}" y="{top + len(lines) * 16 + 1:.1f}">{html.escape(p["label"]["zh"])}</text>'
    svg.append(f'<g class="node{" soft" if soft else ""}" data-place="{p["id"]}" tabindex="0" role="button" aria-label="{html.escape(p["label"]["en"])}">'
               f'<rect x="{x - NW / 2}" y="{y - NH / 2}" width="{NW}" height="{NH}" rx="9"/>{text}</g>')

n_items = len(decisions)
n_arrows = sum(len(e['items']) for e in edges)
counts = {'items': n_items, 'arrows': n_arrows, 'pairs': len(edges),
          'stays': sum(len(v['stays']) for v in notes.values()), 'inside': sum(len(v['inside']) for v in notes.values()),
          'out': sum(len(v['out']) for v in notes.values()), 'unplaced': len(unplaced),
          'unconditioned': sum(1 for e in edges for i in e['items'] if i['strength'] in ('witness', 'reading', 'open'))}
data = {'places': places, 'edges': edges, 'notes': notes, 'unplaced': unplaced, 'counts': counts, 'site': SITE}

page = (HERE / 'template.html').read_text()
page = (page.replace('/*SVG*/', '\n'.join(svg)).replace('/*W*/', str(W)).replace('/*H*/', str(H))
        .replace('/*DATA*/', json.dumps(data, ensure_ascii=False).replace('</', '<\\/')))
for k, v in counts.items():
    page = page.replace('{{' + k + '}}', str(v))
Path(sys.argv[2]).write_text(page)
print(counts)
