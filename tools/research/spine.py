"""The spine picture (board item RW (c)): the eight chapters around the grammar, drawn from the theory graph.

One generated SVG in English (`theories/becoming/results/spine.svg`) and one in Chinese (`spine.zh.svg`), and the
section of THEORY-GRAPH.md that captions them, with the table of edge kinds between chapters. What is drawn, all
counted from the graph the same render builds:

- the grammar at the centre (its concepts) and the eight chapter regions on a ring in the chapters' order, each
  circle's area proportional to the results the region holds;
- each chapter's number inside its circle, its name, results and uses within it beside it;
- a spoke from each region to the grammar, reading "k of m modules": how many of the region's core modules state
  their laws on it;
- `formal-reuse` between results of two regions as solid curves, for each ordered pair with at least DRAW_MIN uses,
  kept off a disc round the grammar, the count beside the curve where it is at least LABEL_MIN, darker where an
  earlier chapter's results use a later one's;
- `interpretive` edges between regions dashed (pairs with at least INTERPRETIVE_MIN), `application` edges dotted
  (every pair); `related` (analogy) is not drawn;
- the continuation condition and C coming into chapter 7 as premises, each a hypothesis where used and neither
  asserted, in their homes' words;
- T1-T8 pinned at their homes, coloured by test outcome, with words chosen from their rows in 08 §9 (in Chinese,
  from the overview's table), standing first.

What is not drawn is counted in the caption, and every pair is in the table. The curated input is
`theories/becoming/results/data/spine.json`; each phrase it quotes is checked at its home on every render, so a
change at a home that drops a phrase stops the render until the picture's words follow it. Text is SVG text with
generic fonts, no script and no external resource, so GitHub renders the picture as an image.
"""
from __future__ import annotations

import json
import math
import os
import re
from pathlib import Path
from xml.sax.saxutils import escape

from tools.research import moves, registry, theory_graph

ROOT = registry.ROOT
DATA = 'theories/becoming/results/data/spine.json'
SVG = {'en': 'theories/becoming/results/spine.svg', 'zh': 'theories/becoming/results/spine.zh.svg'}
PAGE_ZH = 'theories/becoming/results/THEORY-GRAPH.zh.md'  # the Chinese of THEORY-GRAPH.md's spine sections
ZH_REGIONS = {'process': '过程', 'retire': '待退役', 'unassigned': '尚未归属'}
WORKFLOW = '_process/RESULT-WORKFLOW.md'
DRAW_MIN = 10
INTERPRETIVE_MIN = 3
KINDS = ('formal-reuse', 'interpretive', 'application', 'related')
W, H = 900, 900
RING = 250            # the chapters' ring
CX, CY = W / 2, 470   # its centre; svg() sets the height below the header
GR = 58               # the grammar's circle
KEEP = GR + 26        # the base distance of a pair's curves from the centre is at least KEEP + 16; lanes of other
                      # kinds sit up to 25 nearer, still clear of the grammar's circle (the tests hold GR + 6)
LANE_STEP = 24        # between the lanes of pairs that pass near the grammar
LABEL_MIN = 15        # counts written on the picture
LEGEND_X = 470
INK, MUTED, FAINT, PAPER = '#1c1917', '#57534e', '#a8a29e', '#fcfcfb'
FORWARD, BACKWARD = '#8a817c', '#1c1917'
FONT = {'en': 'Helvetica, Arial, sans-serif',
        'zh': "'PingFang SC', 'Hiragino Sans GB', 'Noto Sans CJK SC', 'Microsoft YaHei', sans-serif"}

WORDS = {
    'en': {
        'title': 'The eight chapters around one grammar',
        'subtitle': 'Drawn from the theory graph: each circle sized by its chapter’s results, each curve counting how often one chapter’s results use another’s.',
        'grammar': 'The grammar', 'concepts': '{n} concepts',
        'results': '{n} results', 'within': '{n} within',
        'read': 'How to read it',
        'size': 'Circle: a chapter, its area by its results; its number inside it; beside it, its name, its results and the formal-reuse uses within it.',
        'formal': 'A use recorded as formal-reuse, a kind kept for “a verified inference using the cited result”: the arrow points to the chapter whose results are used; the number beside a curve counts its uses, written where it is {m} or more.',
        'backward': 'The same, darker where an earlier chapter’s results use a later one’s.',
        'interpretive': 'interpretive, kept for “an argument dependency” (dashed; pairs with {m} or more).',
        'application': 'application, a reused result with its correspondence and added premises (dotted).',
        'spoke': 'Spoke, “k of m modules”: k of the chapter’s m core modules state their laws on the grammar. It counts modules, not results derived; its width is the share.',
        'spoke_label': '{k} of {m} modules',
        'related': 'Not drawn: related, for analogy ({n} edges), and formal-reuse pairs under {m} uses; counts under {k} are not written. THEORY-GRAPH.md’s table of edge kinds between chapters has them all.',
        'theses': 'The theses',
        'theses_note': 'T1–T8 at their homes; what each claims, its standing and its tests: the theses table in THEORY-GRAPH.md, “The spine”.',
        'premises': 'Two premises, each a hypothesis where used',
        'footer': 'Generated by tools/research/spine.py from theory-graph.json and spine.json; THEORY-GRAPH.md, “The spine”, says what it shows and does not.',
    },
    'zh': {
        'title': '围绕一个文法的八章',
        'subtitle': '由理论图画出：每个圆按其章的结果数定大小，每条曲线计一章的结果使用另一章结果的次数。',
        'grammar': '文法', 'concepts': '{n} 个概念',
        'results': '{n} 项结果', 'within': '章内使用 {n}',
        'read': '怎样读这幅图',
        'size': '圆：一章，面积按其结果数；圆内是章号；圆旁是章名、结果数与章内 formal-reuse 使用数。',
        'formal': '记为 formal-reuse 的使用（这一类只用于使用所引结果的已核验推理）：箭头指向被使用其结果的那一章；曲线旁的数字为其使用次数，{m} 次及以上才标出。',
        'backward': '同上；前面一章的结果使用后面一章的结果时，线色较深。',
        'interpretive': '诠释（interpretive），用于论证上的依赖（虚线；{m} 次及以上的配对）。',
        'application': '应用（application），一个被复用的结果，连同其对应与所添的前提（点线）。',
        'spoke': '辐条，“m 个模块中 k 个”：该章 m 个核心模块中，有 k 个在文法上陈述其律。它计的是模块，不是推导而得的结果；粗细表示比例。',
        'spoke_label': '{m} 个模块中 {k} 个',
        'related': '不画出：相关（related，用于类比，{n} 条边），以及少于 {m} 次 formal-reuse 使用的配对；少于 {k} 次的不标数字。理论图脊柱部分的中文版（THEORY-GRAPH.zh.md）中各章之间边的种类表列出全部。',
        'theses': '论题',
        'theses_note': 'T1 到 T8 在其所属之处；各自主张什么、地位如何、检验如何：见理论图脊柱部分的中文版（THEORY-GRAPH.zh.md）中的论题表。',
        'premises': '两个前提，各在所用之处为假设',
        'footer': '由 tools/research/spine.py 依 theory-graph.json 与 spine.json 生成；它显示什么、不显示什么，见 THEORY-GRAPH.zh.md 的“脊柱”。',
    },
}


def _read(path):
    p = ROOT / path
    return p.read_text(encoding='utf-8') if p.is_file() else None


def norm(text):
    """Markdown emphasis and code marks dropped, whitespace collapsed: the form a quotation is matched in."""
    return re.sub(r'\s+', ' ', re.sub(r'[*`]', '', text or ''))


def spec():
    return json.loads(_read(DATA) or '{}')


def check(s):
    """Every phrase spine.json quotes, at its home; an error names the phrase and the home that no longer holds it."""
    errors = []
    homes = {}

    def home(path):
        if path not in homes:
            homes[path] = _read(path)
        return homes[path]

    def holds(path, phrase, where=None):
        text = home(path)
        if text is None:
            errors.append(f'spine.json: home missing: {path}')
            return
        # a phrase elided with " … " holds where each of its parts stands in the home, in order
        body, at = norm(where if where is not None else text), 0
        for part in norm(phrase).split(' … '):
            found = body.find(part.strip(), at)
            if found < 0:
                errors.append(f'spine.json: {path} no longer holds: {phrase!r}')
                break
            at = found + len(part.strip())

    for key in s.get('order', []):
        if key not in theory_graph.REGION_TITLES:
            errors.append(f'spine.json: not a region of the theory graph: {key}')
        ch = s['chapters'].get(key, {})
        if not (ROOT / 'theories/becoming/chapters' / ch.get('file', '-')).is_file():
            errors.append(f'spine.json: no chapter file for {key}: {ch.get("file")}')
        zh = home(s['chapter_label_homes']['zh']) or ''
        n = s['order'].index(key) + 1
        heading = next((l for l in zh.split('\n') if l.startswith(f'## {n}. ')), '')
        if ch.get('zh', '\0') not in heading:
            errors.append(f'spine.json: the Chinese overview\'s heading {n} no longer holds {ch.get("zh")!r}')
    for lang, start in (('en', '| {}. '), ('zh', '| {} |')):
        path = s['theses_homes'][lang]
        text = home(path) or ''
        for t in s.get('theses', []):
            row = next((l for l in text.split('\n') if l.startswith(start.format(t['id']))), None)
            if row is None:
                errors.append(f'spine.json: {path} has no row for {t["id"]}')
                continue
            for phrase in [t[lang]['title']] + t[lang]['words']:
                holds(path, phrase, row)
            if t['outcome'] not in s.get('outcomes', {}):
                errors.append(f'spine.json: {t["id"]}: unknown outcome {t["outcome"]}')
            if lang == 'en' and t['home'] not in s['order']:
                errors.append(f'spine.json: {t["id"]}: home not a region: {t["home"]}')
            if lang == 'en':
                link = f'({s["chapters"][t["home"]]["file"]}#{t.get("anchor", "")}'
                if link not in row:
                    errors.append(f'spine.json: 08 §9 no longer gives {t["id"]}\'s home as {s["chapters"][t["home"]]["file"]}')
    for p in s.get('premises', []):
        for lang in ('en', 'zh'):
            for path, phrase in p[lang]['quotes']:
                holds(path, phrase)
    for c in s.get('caption', []):
        holds(c['home'], c['text'])
        if c.get('anchor') and c['anchor'] not in moves.anchors(home(c['home']) or ''):
            errors.append(f'spine.json: {c["home"]} has no anchor {c["anchor"]}')
    standing = s.get('standing')
    if standing:
        for number, path, phrase in standing['counts']:
            holds(path, phrase)
            for lang in ('en', 'zh'):
                if number not in re.findall(r'\d+', standing[lang]):
                    errors.append(f'spine.json: the standing line ({lang}) lacks {number}')
    for phrase in ('a verified inference using the cited result', 'an argument dependency', '`related` for analogy'):
        holds(WORKFLOW, phrase)
    return errors


def counts(graph, order):
    """Results, uses by kind between and within regions, and modules on the grammar, by region."""
    region = {n['id']: n.get('region') or 'unassigned' for n in graph['nodes']}
    results = {k: 0 for k in order}
    for n in graph['nodes']:
        if n['type'] == 'result' and n.get('region') in results:
            results[n['region']] += 1
    pairs = {}
    for e in graph['edges']:
        if e['type'] in KINDS and e['from'].startswith('record:') and e['to'].startswith('record:'):
            key = (region[e['from']], region[e['to']])
            pairs.setdefault(key, dict.fromkeys(KINDS, 0))[e['type']] += 1
    modules = {k: [0, 0] for k in order}
    for n in graph['nodes']:
        if n['type'] == 'module' and n.get('region') in modules:
            modules[n['region']][0] += 1
            modules[n['region']][1] += bool(n.get('on_grammar'))
    concepts = sum(1 for n in graph['nodes'] if n['type'] == 'concept')
    return results, pairs, modules, concepts


def radius(n):
    return max(22.0, 6.0 * math.sqrt(n))


NO_LINE_START = set('，。；：、）」”！？》')
NO_LINE_END = set('（「“《')


def wrap(text, width, lang):
    """Lines of at most `width` characters: by words in English, by characters in Chinese (a CJK character counts two)."""
    if lang == 'zh':
        # Latin words stay whole, and a line does not begin with closing punctuation
        lines, line, size = [], '', 0
        for token in re.findall(r'[A-Za-z0-9_./\-]+|.', text):
            w = sum(2 if ord(ch) > 0x2e80 else 1 for ch in token)
            if size + w > width and line and token not in NO_LINE_START:
                lines.append(line)
                line, size = '', 0
            line += token
            size += w
        lines += [line] if line else []
        # nor ends with an opening bracket: it moves to the next line
        for i in range(len(lines) - 1):
            while lines[i] and lines[i][-1] in NO_LINE_END:
                lines[i], lines[i + 1] = lines[i][:-1], lines[i][-1] + lines[i + 1]
        return [l.strip() for l in lines if l.strip()]
    lines, line = [], ''
    for word in text.split():
        if line and len(line) + 1 + len(word) > width:
            lines.append(line)
            line = word
        else:
            line = f'{line} {word}' if line else word
    return lines + ([line] if line else [])


def wrap_items(text, width, lang, sep=' · '):
    """Lines of whole items: `text` split at `sep` and packed greedily, an item wider than a line wrapped alone."""
    def size(s):
        return sum(2 if lang == 'zh' and ord(ch) > 0x2e80 else 1 for ch in s)
    lines, line = [], ''
    for item in text.split(sep):
        if size(item) > width:
            lines += [line] if line else []
            lines += wrap(item, width, lang)
            line = ''
        elif line and size(line + sep + item) > width:
            lines.append(line)
            line = item
        else:
            line = f'{line}{sep}{item}' if line else item
    return lines + ([line] if line else [])


def f(x):
    return f'{x:.1f}'.rstrip('0').rstrip('.')


def text(x, y, body, size=12, weight='normal', anchor='start', fill=INK, halo=False):
    extra = f' stroke="{PAPER}" stroke-width="3" paint-order="stroke"' if halo else ''
    bold = ' font-weight="bold"' if weight == 'bold' else ''
    return (f'<text x="{f(x)}" y="{f(y)}" font-size="{size}"{bold} text-anchor="{anchor}" fill="{fill}"{extra}>'
            f'{escape(body)}</text>')


def width_of(body, size, bold=False):
    """An estimate of a line's drawn width: a CJK character a full em, Latin letters by rough class."""
    w = 0.0
    for ch in body:
        if ord(ch) > 0x2e80:
            w += 1.0
        elif ch in "iljI.,;:!|'’ ·":
            w += 0.3
        elif ch in 'mwMW':
            w += 0.85
        elif ch.isupper() or ch.isdigit():
            w += 0.62
        else:
            w += 0.54
    return w * size * (1.06 if bold else 1.0)


def overlaps(a, b, pad=0.0):
    return not (a[2] + pad <= b[0] or b[2] + pad <= a[0] or a[3] + pad <= b[1] or b[3] + pad <= a[1])


def clear_of_circle(box, circle, pad=0.0):
    """Whether a box stays outside a circle (cx, cy, r) by `pad`."""
    cx, cy, r = circle
    nx, ny = min(max(cx, box[0]), box[2]), min(max(cy, box[1]), box[3])
    return math.hypot(cx - nx, cy - ny) > r + pad


def arc_span(start, end, through):
    """The arc from angle `start` to `end` that passes `through`, as (from, length), counter-clockwise from `from`."""
    tau = 2 * math.pi
    ccw = (end - start) % tau
    if (through - start) % tau <= ccw:
        return start % tau, ccw
    return end % tau, (start - end) % tau


def spans_meet(a, b, margin=-0.05):
    tau = 2 * math.pi
    (s1, l1), (s2, l2) = a, b
    return ((s2 - s1) % tau) < l1 + margin or ((s1 - s2) % tau) < l2 + margin


def curve(a, ra, b, rb, d, centre=None, side=1):
    """A quadratic curve from circle a to circle b inside the ring: (path, its point at t, attachment points).

    Its middle stands on the perpendicular bisector of the chord, which passes through the ring's centre, at distance
    `d` from that centre: on the chord's side, or for a chord through the centre on the side `side` picks. Callers keep
    `d` well clear of the grammar's circle, so no curve between chapters crosses it."""
    cx0, cy0 = centre or (CX, CY)
    (ax, ay), (bx, by) = a, b
    mx, my = (ax + bx) / 2, (ay + by) / 2
    h = math.hypot(mx - cx0, my - cy0)
    if h > 1:
        ux, uy = (mx - cx0) / h, (my - cy0) / h
    else:
        dx, dy = bx - ax, by - ay
        length = math.hypot(dx, dy)
        ux, uy = -dy / length * side, dx / length * side
    px, py = cx0 + ux * d, cy0 + uy * d
    qx, qy = 2 * px - mx, 2 * py - my

    def towards(sx, sy, tx, ty, r):
        dist = math.hypot(tx - sx, ty - sy)
        return sx + (tx - sx) * r / dist, sy + (ty - sy) * r / dist

    p0 = towards(ax, ay, qx, qy, ra + 2)
    p2 = towards(bx, by, qx, qy, rb + 3)

    def point(t):
        u = 1 - t
        return (u * u * p0[0] + 2 * u * t * qx + t * t * p2[0], u * u * p0[1] + 2 * u * t * qy + t * t * p2[1])

    return f'M{f(p0[0])},{f(p0[1])} Q{f(qx)},{f(qy)} {f(p2[0])},{f(p2[1])}', point, (p0, p2)


def short_name(s, k, lang):
    """A chapter's short name: in English from its file's name (`02-MAP.md`: Map), in Chinese the overview's heading."""
    if lang == 'zh':
        return s['chapters'][k]['zh']
    stem = s['chapters'][k]['file'][3:].rsplit('.', 1)[0]
    return stem.replace('-', ' ').capitalize()


def place_box(candidates, w, h, circles, boxes, pad=2.0, soft=(), accept=None):
    """The first candidate centre, in the order given, whose w×h box is clear of every circle and box, that `accept`
    allows, and that crosses the fewest `soft` points (x, y, r: the curves under it); a box no candidate clears takes
    the fewest hits."""
    best = None
    for x, y in candidates:
        box = (x - w / 2, y - h / 2, x + w / 2, y + h / 2)
        hard = sum(not clear_of_circle(box, c, pad) for c in circles) + sum(overlaps(box, b, pad) for b in boxes)
        hard += 0 if accept is None or accept(x, y) else 10
        crossed = sum(not clear_of_circle(box, c) for c in soft)
        score = (hard, crossed)
        if best is None or score < best[0]:
            best = (score, box)
        if score == (0, 0):
            break
    return best[1]


def along(point, prefer, away=None, offsets=(0, 9, 17)):
    """Candidate centres on and beside a curve, nearest `prefer` first; with `away` (a point and a sign: +1 away from
    it, -1 towards it), only on that side of the curve, so a count stays on its own curve's side of its pair."""
    ts = sorted((i / 50 for i in range(8, 43)), key=lambda t: abs(t - prefer))
    out = []
    for t in ts:
        (x0, y0), (x1, y1) = point(max(0.0, t - 0.01)), point(min(1.0, t + 0.01))
        dx, dy = x1 - x0, y1 - y0
        length = math.hypot(dx, dy) or 1
        nx, ny = -dy / length, dx / length
        x, y = point(t)
        signs = (1, -1)
        if away is not None:
            (ox, oy), sgn = away
            signs = (sgn if nx * (x - ox) + ny * (y - oy) >= 0 else -sgn,)
        out += [(x + nx * o * s, y + ny * o * s) for o in offsets for s in signs]
    return out


def layout(s, results, pairs, lang, top):
    """Where everything on the ring goes: centres, radii, the chapters' label blocks, the curves with their lanes."""
    order = s['order']
    words = WORDS[lang]
    n = len(order)
    r = {k: radius(results[k]) for k in order}
    angle = {k: -math.pi / 2 + i * 2 * math.pi / n for i, k in enumerate(order)}
    rank = {k: i for i, k in enumerate(order)}

    def block_lines(k):
        name = short_name(s, k, lang)
        if lang == 'en' or len(name) <= 7:
            names = [name]
        elif '、' in name:  # at the enumeration comma nearest the middle
            cut = min((i for i, ch in enumerate(name) if ch == '、'), key=lambda i: abs(i - len(name) / 2)) + 1
            names = [name[:cut], name[cut:]]
        else:
            names = wrap(name, 14, lang)
        within = pairs.get((k, k), dict.fromkeys(KINDS, 0))['formal-reuse']
        counted = words['results'].format(n=results[k]) + (' · ' + words['within'].format(n=within) if within else '')
        return [(line, 16, 'bold', INK) for line in names] + [(counted, 13, 'normal', MUTED)]

    def block_height(lines):
        return sum(19 if size >= 16 else 17 for _, size, *_ in lines)

    first = order[0]
    cy = top + 18 + block_height(block_lines(first)) + 8 + r[first] + RING
    cx = CX
    centre = {k: (cx + RING * math.cos(angle[k]), cy + RING * math.sin(angle[k])) for k in order}
    # label blocks: above a chapter in the upper part of the ring, below every other, centred on it
    blocks = {}
    for k in order:
        lines = block_lines(k)
        x, y = centre[k]
        height = block_height(lines)
        widest = max(width_of(line, size, weight == 'bold') for line, size, weight, _ in lines)
        y0 = y - r[k] - 9 - height if math.sin(angle[k]) < -0.3 else y + r[k] + 7
        blocks[k] = {'lines': lines, 'box': (x - widest / 2, y0, x + widest / 2, y0 + height), 'x': x}
    # curves: the pairs drawn, their base distance from the centre, long pairs given lanes that do not meet
    drawn = []
    for (a, b), c in sorted(pairs.items(), key=lambda kv: (rank.get(kv[0][0], 99), rank.get(kv[0][1], 99))):
        if a == b or a not in rank or b not in rank:
            continue
        for kind, minimum in (('formal-reuse', DRAW_MIN), ('interpretive', INTERPRETIVE_MIN), ('application', 1)):
            if c[kind] >= minimum:
                drawn.append({'from': a, 'to': b, 'kind': kind, 'n': c[kind]})
    groups = {}
    for e in drawn:
        groups.setdefault(frozenset((e['from'], e['to'])), []).append(e)

    def chord_mid(a, b):
        (ax, ay), (bx, by) = centre[a], centre[b]
        return (ax + bx) / 2, (ay + by) / 2

    base = {}
    for g in groups:
        a, b = sorted(g, key=rank.get)
        mx, my = chord_mid(a, b)
        h = math.hypot(mx - cx, my - cy)
        base[g] = max(KEEP + 16, h - (16 if h > 0.85 * RING else 32))
    # a chord through the centre goes round on the side with less weight of other curves near it
    side = {}
    for g in groups:
        a, b = sorted(g, key=rank.get)
        mx, my = chord_mid(a, b)
        if math.hypot(mx - cx, my - cy) > 1:
            continue
        (ax, ay), (bx, by) = centre[a], centre[b]
        length = math.hypot(bx - ax, by - ay)
        best = None
        for sgn in (1, -1):
            px, py = cx - (by - ay) / length * sgn * base[g], cy + (bx - ax) / length * sgn * base[g]
            weight = 0.0
            for h, es in groups.items():
                if h == g:
                    continue
                p, q = sorted(h, key=rank.get)
                hx, hy = chord_mid(p, q)
                weight += sum(e['n'] for e in es) / (1 + math.hypot(px - hx, py - hy) / 60)
            if best is None or weight < best[0]:
                best = (weight, sgn)
        side[g] = best[1]
    # lanes: long pairs (those passing near the grammar) take the first level whose arcs they do not meet
    level, taken = {}, {}
    long_pairs = sorted((g for g in groups if base[g] < 0.66 * RING), key=lambda g: base[g])

    def span(g):
        a, b = sorted(g, key=rank.get)
        mx, my = chord_mid(a, b)
        if math.hypot(mx - cx, my - cy) > 1:
            through = math.atan2(my - cy, mx - cx)
        else:
            (ax, ay), (bx, by) = centre[a], centre[b]
            length = math.hypot(bx - ax, by - ay)
            through = math.atan2((bx - ax) / length * side[g], -(by - ay) / length * side[g])
        return arc_span(angle[a], angle[b], through)

    for g in sorted(long_pairs, key=lambda g: (base[g], span(g)[1])):
        lv = 0  # pairs at the same base distance share lanes; a lane holds arcs that do not meet
        while any(spans_meet(span(g), span(h)) for h in taken.get((round(base[g]), lv), [])):
            lv += 1
        taken.setdefault((round(base[g]), lv), []).append(g)
        level[g] = lv
    curves = []
    for g, es in groups.items():
        a0 = min(g, key=rank.get)
        d0 = base[g] + LANE_STEP * level.get(g, 0)
        for e in es:
            outward = 1 if e['from'] == a0 else -1
            offset = {'formal-reuse': 6 * outward, 'interpretive': 17 * outward, 'application': 25 * outward}[e['kind']]
            # the side of a chord through the centre is read from the pair's first chapter, so both directions agree
            path, point, ends = curve(centre[e['from']], r[e['from']], centre[e['to']], r[e['to']], d0 + offset,
                                      (cx, cy), side.get(g, 1) * outward)
            curves.append({**e, 'path': path, 'point': point, 'ends': ends, 'outward': outward})
    return {'centre': centre, 'r': r, 'angle': angle, 'cy': cy, 'cx': cx, 'blocks': blocks, 'curves': curves, 'rank': rank}


def svg(graph, s, lang, info=None):
    """The picture in one language; `info`, a dict, receives where the counts went (for the tests)."""
    words = WORDS[lang]
    order = s['order']
    results, pairs, modules, concepts = counts(graph, order)
    related = sum(v['related'] for v in pairs.values())
    out = [f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {H}" width="{W}" height="{H}" role="img" '
           f'aria-labelledby="spine-title spine-desc" font-family="{FONT[lang]}">',
           f'<title id="spine-title">{escape(words["title"])}</title>',
           f'<desc id="spine-desc">{escape(description(results, pairs, s, lang))}</desc>',
           '<defs>',
           f'<marker id="fwd" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="11" markerHeight="11" markerUnits="userSpaceOnUse" orient="auto"><path d="M0,0 L10,5 L0,10 z" fill="{FORWARD}"/></marker>',
           f'<marker id="back" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="11" markerHeight="11" markerUnits="userSpaceOnUse" orient="auto"><path d="M0,0 L10,5 L0,10 z" fill="{BACKWARD}"/></marker>',
           f'<marker id="thin" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="9" markerHeight="9" markerUnits="userSpaceOnUse" orient="auto"><path d="M0,1 L9,5 L0,9" fill="none" stroke="{MUTED}" stroke-width="1.5"/></marker>',
           f'<marker id="diamond" viewBox="0 0 10 10" refX="5" refY="5" markerWidth="9" markerHeight="9" markerUnits="userSpaceOnUse" orient="auto"><path d="M5,0 L10,5 L5,10 L0,5 z" fill="{MUTED}"/></marker>',
           '</defs>',
           f'<rect x="0.5" y="0.5" width="{W - 1}" height="{H - 1}" rx="10" fill="{PAPER}" stroke="#d6d3d1"/>',
           text(24, 40, words['title'], 24, 'bold')]
    y = 66
    for line in wrap(words['subtitle'], 100 if lang == 'en' else 92, lang):
        out.append(text(24, y, line, 15, fill=MUTED))
        y += 19
    top = y - 19 + 6
    standing = s.get('standing', {}).get(lang)
    if standing:
        y += 8
        sep = '：' if lang == 'zh' else ': '
        head, body = standing.split(sep, 1) if sep in standing else (standing, '')
        lines = wrap(head + sep.strip(), 100 if lang == 'en' else 92, lang) + wrap_items(body, 100 if lang == 'en' else 92, lang)
        out.append(f'<rect x="20" y="{y - 17}" width="{W - 40}" height="{12 + 20 * len(lines)}" rx="6" fill="#f5f5f4" stroke="#e7e5e4"/>')
        for i, line in enumerate(lines):
            out.append(text(32, y + 20 * i, line, 15, 'bold' if i == 0 else 'normal', fill=INK))
        top = y - 17 + 12 + 20 * len(lines)
    L = layout(s, results, pairs, lang, top)
    centre, r, angle, cx, cy = L['centre'], L['r'], L['angle'], L['cx'], L['cy']
    circles = [(cx, cy, GR)] + [(centre[k][0], centre[k][1], r[k]) for k in order]
    boxes = [b['box'] for b in L['blocks'].values()]
    # spokes to the grammar, their width by the share of the chapter's modules stated on it
    for k in order:
        x, y0 = centre[k]
        a = angle[k]
        gx, gy = cx + (GR + 2) * math.cos(a), cy + (GR + 2) * math.sin(a)
        sx, sy = x - (r[k] + 2) * math.cos(a), y0 - (r[k] + 2) * math.sin(a)
        share = modules[k][1] / modules[k][0] if modules[k][0] else 0
        out.append(f'<line x1="{f(sx)}" y1="{f(sy)}" x2="{f(gx)}" y2="{f(gy)}" stroke="{FAINT}" stroke-opacity="0.75" '
                   f'stroke-width="{f(1 + 9 * share)}" stroke-linecap="round"/>')
    out.append(f'<circle cx="{f(cx)}" cy="{f(cy)}" r="{GR}" fill="#f5f5f4" stroke="{INK}" stroke-width="1.5"/>')
    out.append(text(cx, cy - 2, words['grammar'], 15 if lang == 'en' else 17, 'bold', 'middle'))
    out.append(text(cx, cy + 16, words['concepts'].format(n=concepts), 12, anchor='middle', fill=MUTED))
    # curves between chapters
    for c in L['curves']:
        if c['kind'] == 'formal-reuse':
            back = L['rank'][c['from']] < L['rank'][c['to']]
            colour = BACKWARD if back else FORWARD
            out.append(f'<path d="{c["path"]}" fill="none" stroke="{colour}" stroke-opacity="0.85" '
                       f'stroke-width="{f(0.8 + 0.8 * math.sqrt(c["n"]))}" marker-end="url(#{"back" if back else "fwd"})"/>')
        else:
            style = 'stroke-dasharray="6 4" marker-end="url(#thin)"' if c['kind'] == 'interpretive' else \
                'stroke-dasharray="1.5 4" stroke-linecap="round" marker-end="url(#diamond)"'
            out.append(f'<path d="{c["path"]}" fill="none" stroke="{MUTED}" stroke-width="1.7" {style}/>')
    # chapters: the number inside, the name and counts beside
    for k in order:
        x, y0 = centre[k]
        out.append(f'<circle cx="{f(x)}" cy="{f(y0)}" r="{f(r[k])}" fill="#ffffff" stroke="{INK}" stroke-width="1.5"/>')
        size = min(22, round(0.75 * r[k]))
        out.append(text(x, y0 + size * 0.36, s['chapters'][k]['file'][:2], size, 'bold', 'middle', MUTED))
        b = L['blocks'][k]
        yy = b['box'][1]
        for line, size, weight, fill in b['lines']:
            yy += 19 if size >= 16 else 17
            out.append(text(b['x'], yy - 4, line, size, weight, 'middle', fill, True))
    # the theses at their homes, as badges, where they clear the label, the spoke, the curves' ends and the premises
    attach = {k: [] for k in order}
    for c in L['curves']:
        attach[c['from']].append(c['ends'][0])
        attach[c['to']].append(c['ends'][1])
    for k in order:
        attach[k].append((centre[k][0] - (r[k] + 2) * math.cos(angle[k]), centre[k][1] - (r[k] + 2) * math.sin(angle[k])))
    premise_entry = [math.radians(150 + 16 * i) for i in range(len(s['premises']))]
    for i, a in enumerate(premise_entry):
        sx, sy = centre['significance']
        attach['significance'].append((sx + (r['significance'] + 4) * math.cos(a), sy + (r['significance'] + 4) * math.sin(a)))
    at = {}
    for t in s['theses']:
        at.setdefault(t['home'], []).append(t)
    badges = []
    for k, ts in at.items():
        x, y0 = centre[k]
        reach = r[k] + 13
        step = 33 / reach
        best = None
        for j in range(72):
            phi = j * 2 * math.pi / 72
            spots = [(x + reach * math.cos(phi + (i - (len(ts) - 1) / 2) * step),
                      y0 + reach * math.sin(phi + (i - (len(ts) - 1) / 2) * step)) for i in range(len(ts))]
            score = min(
                [math.hypot(px - qx, py - qy) - 21 for px, py in spots for qx, qy in attach[k]] +
                [math.hypot(px - ox, py - oy) - orr - 17 for px, py in spots for ox, oy, orr in circles if (ox, oy) != (x, y0)] +
                [0 if clear_of_circle(bx, (px, py, 17)) else -40 for px, py in spots for bx in boxes] +
                [min(px - 16, W - 16 - px) for px, _ in spots])
            if best is None or score > best[0]:
                best = (score, spots)
        for t, (px, py) in zip(ts, best[1]):
            badges.append((px, py, 15))
            colour = s['outcomes'][t['outcome']]['colour']
            label = '#ffffff' if t['outcome'] == 'partial' else INK
            out.append(f'<circle cx="{f(px)}" cy="{f(py)}" r="15" fill="{colour}" stroke="{INK}" stroke-width="1.2"/>')
            out.append(text(px, py + 5, t['id'], 13, 'bold', 'middle', label))
    # the words on the spokes, then the counts of 15 and more by their arrowheads, each clear of what is drawn
    labels = []
    obstacles = circles + badges
    under = {id(c): [(*c['point'](i / 25), 1.5 + (0.4 + 0.4 * math.sqrt(c['n']) if c['kind'] == 'formal-reuse' else 1))
                     for i in range(26)] for c in L['curves']}
    for k in order:
        a = angle[k]
        d0, d1 = GR + 4, RING - r[k] - 4
        body = words['spoke_label'].format(k=modules[k][1], m=modules[k][0])
        w, h = width_of(body, 12) + 6, 15
        spots = [(cx + (d0 + (d1 - d0) * t) * math.cos(a), cy + (d0 + (d1 - d0) * t) * math.sin(a))
                 for t in (0.5, 0.42, 0.58, 0.34, 0.66, 0.26, 0.74)]
        box = place_box(spots, w, h, obstacles, boxes + [l[0] for l in labels], soft=[pt for c in L['curves'] for pt in under[id(c)]])
        labels.append((box, text((box[0] + box[2]) / 2, box[3] - 3.5, body, 12, anchor='middle', fill=MUTED, halo=True)))
    fine = {id(c): [c['point'](i / 100) for i in range(101)] for c in L['curves']}

    def nearest_is(c):  # a count stands nearer its own curve than any other, so it cannot be read as another's
        def accept(x, y):
            own = min(math.hypot(px - x, py - y) for px, py in fine[id(c)])
            return all(min(math.hypot(px - x, py - y) for px, py in fine[id(o)]) > own + 1 for o in L['curves'] if o is not c)
        return accept

    for c in sorted(L['curves'], key=lambda c: -c['n']):
        if c['kind'] != 'formal-reuse' or c['n'] < LABEL_MIN:
            continue
        back = L['rank'][c['from']] < L['rank'][c['to']]
        body = str(c['n'])
        w, h = width_of(body, 14, back) + 6, 16
        mates = [o for o in L['curves'] if o is not c and {o['from'], o['to']} == {c['from'], c['to']}]
        soft = [pt for other in L['curves'] if other is not c and other not in mates for pt in under[id(other)]]
        hard = obstacles + [(x, y, r + 1) for o in mates for x, y, r in under[id(o)]]
        sibling = any(o['kind'] == 'formal-reuse' and o['from'] == c['to'] and o['to'] == c['from'] for o in L['curves'])
        away = ((L['cx'], L['cy']), 1 if c['outward'] > 0 else -1) if sibling else None
        box = place_box(along(c['point'], 0.5, away), w, h, hard, boxes + [l[0] for l in labels], soft=soft,
                        accept=nearest_is(c))
        labels.append((box, text((box[0] + box[2]) / 2, box[3] - 3.5, body, 14, 'bold' if back else 'normal', 'middle',
                                 BACKWARD if back else FORWARD, True)))
        if info is not None:
            info.setdefault('counts', []).append((c, box))
    out += [l[1] for l in labels]
    if info is not None:
        info.update({'curves': L['curves'], 'circles': circles + badges})
    low = max([b[3] for b in boxes] + [centre[k][1] + r[k] for k in order] + [py + 15 for _, py, _ in badges]) + 40
    # left column: the premises, their arrows up the left margin into chapter 7, then the theses' key
    sx, sy = centre['significance']
    y = low
    out.append(text(36, y, words['premises'], 15, 'bold', fill=MUTED))
    y += 12
    for i, p in enumerate(s['premises']):
        first = wrap(p[lang]['lines'][0], 46 if lang == 'en' else 40, lang)
        rest = [l for raw in p[lang]['lines'][1:] for l in wrap(raw, 52 if lang == 'en' else 46, lang)]
        bx, bw = 36, 390
        bh = 16 + 19 * (len(first) + len(rest))
        out.append(f'<rect x="{bx}" y="{y}" width="{bw}" height="{bh}" rx="6" fill="#ffffff" stroke="{INK}" stroke-dasharray="5 3"/>')
        for j, line in enumerate(first + rest):
            out.append(text(bx + 10, y + 22 + 19 * j, line, 15 if j < len(first) else 14,
                            'bold' if j < len(first) else 'normal', fill=INK if j < len(first) else MUTED))
        ex, ey = bx, y + 18
        target = premise_entry[i]
        tx, ty = sx + (r['significance'] + 4) * math.cos(target), sy + (r['significance'] + 4) * math.sin(target)
        lane = 14 + 9 * i
        out.append(f'<path d="M{f(ex)},{f(ey)} L{lane},{f(ey)} L{lane},{f(ty + 30)} Q{lane},{f(ty)} {f(tx)},{f(ty)}" fill="none" '
                   f'stroke="{INK}" stroke-width="1.5" stroke-dasharray="5 3" marker-end="url(#back)"/>')
        y += bh + 12
    y += 18
    out.append(text(20, y, words['theses'], 16, 'bold'))
    y += 26
    for key, o in s['outcomes'].items():
        out.append(f'<circle cx="{20 + 13}" cy="{y - 5}" r="10" fill="{o["colour"]}" stroke="{INK}" stroke-width="1.2"/>')
        y = legend_line(out, 20, y, o[lang], lang, size=14, width=46 if lang == 'en' else 40, step=18)
    y = legend_line(out, -16, y + 4, words['theses_note'], lang, size=14, width=52 if lang == 'en' else 46, step=18)
    left_bottom = y
    # right column: how to read it
    x0, y = LEGEND_X, low
    out.append(text(x0, y, words['read'], 16, 'bold'))
    y += 26
    out.append(f'<circle cx="{x0 + 13}" cy="{y - 5}" r="10" fill="#ffffff" stroke="{INK}" stroke-width="1.5"/>')
    out.append(text(x0 + 13, y - 1, '01', 10, 'bold', 'middle', MUTED))
    width = 50 if lang == 'en' else 42
    y = legend_line(out, x0, y, words['size'], lang, size=14, width=width, step=18)
    samples = [
        (f'<line x1="{x0}" y1="{{y}}" x2="{x0 + 26}" y2="{{y}}" stroke="{FORWARD}" stroke-width="3.2" marker-end="url(#fwd)"/>', words['formal'].format(m=LABEL_MIN)),
        (f'<line x1="{x0}" y1="{{y}}" x2="{x0 + 26}" y2="{{y}}" stroke="{BACKWARD}" stroke-width="3.2" marker-end="url(#back)"/>', words['backward']),
        (f'<line x1="{x0}" y1="{{y}}" x2="{x0 + 26}" y2="{{y}}" stroke="{MUTED}" stroke-width="1.7" stroke-dasharray="6 4" marker-end="url(#thin)"/>', words['interpretive'].format(m=INTERPRETIVE_MIN)),
        (f'<line x1="{x0}" y1="{{y}}" x2="{x0 + 26}" y2="{{y}}" stroke="{MUTED}" stroke-width="1.7" stroke-dasharray="1.5 4" stroke-linecap="round" marker-end="url(#diamond)"/>', words['application']),
        (f'<line x1="{x0}" y1="{{y}}" x2="{x0 + 26}" y2="{{y}}" stroke="{FAINT}" stroke-width="6" stroke-linecap="round"/>', words['spoke']),
        ('', words['related'].format(n=f'{related:,}' if lang == 'en' else related, m=DRAW_MIN, k=LABEL_MIN)),
    ]
    for mark, body in samples:
        if mark:
            out.append(mark.format(y=f(y - 5)))
        y = legend_line(out, x0, y, body, lang, size=14, width=width, step=18)
    height = int(max(y, left_bottom)) + 50
    for i, line in enumerate(wrap(words['footer'], 120 if lang == 'en' else 110, lang)):
        out.append(text(24, height - 30 + 15 * i, line, 12, fill=MUTED))
    out.append('</svg>')
    out[0] = out[0].replace(f'viewBox="0 0 {W} {H}" width="{W}" height="{H}"', f'viewBox="0 0 {W} {height}" width="{W}" height="{height}"')
    out = [o.replace(f'height="{H - 1}" rx="10"', f'height="{height - 1}" rx="10"') if o.startswith('<rect x="0.5"') else o for o in out]
    return '\n'.join(out) + '\n'


def legend_line(out, x0, y, body, lang, size=11.5, width=None, step=15, first_bold=0):
    """Wrapped legend text right of its sample; returns the next line's baseline."""
    width = width or (46 if lang == 'en' else 40)
    lines = wrap(body, width, lang)
    for i, line in enumerate(lines):
        if i == 0 and first_bold:
            out.append(f'<text x="{f(x0 + 36)}" y="{f(y)}" font-size="{size}" fill="{INK}"><tspan font-weight="bold">'
                       f'{escape(line[:first_bold])}</tspan>{escape(line[first_bold:])}</text>')
        else:
            out.append(text(x0 + 36, y, line, size, fill=INK))
        y += step
    return y + 4


def description(results, pairs, s, lang):
    order = s['order']
    drawn = sum(1 for (a, b), c in pairs.items() if a != b and a in order and b in order and c['formal-reuse'] >= DRAW_MIN)
    total = sum(c['formal-reuse'] for (a, b), c in pairs.items() if a != b and a in order and b in order)
    if lang == 'zh':
        sizes = '；'.join(s['chapters'][k]['zh'] + ' ' + str(results[k]) for k in order)
        return (f'八章围绕文法排成一圈，按其结果数定大小（{sizes}）。'
                f'章与章之间共有 {total} 次记为 formal-reuse 的使用，画出 {drawn} 个至少 {DRAW_MIN} 次的配对。延续条件与 C 作为前提进入第七章，各在所用之处为假设，二者都不断言。'
                f'T1 到 T8 在其所属之处，按检验结局着色。')
    sizes = ', '.join(theory_graph.REGION_TITLES[k].split(':')[0] + ' ' + str(results[k]) for k in order)
    return (f'Eight chapters on a ring around the grammar, sized by their results ({sizes}); '
            f'{total} formal-reuse uses between chapters, {drawn} pairs with at least {DRAW_MIN} drawn; the continuation '
            f'condition and C come into chapter 7 as premises, each a hypothesis where used, neither asserted; T1 to T8 at '
            f'their homes, coloured by test outcome.')


def how_to_read(s, lang):
    """The two sentences above the picture wherever it is shown: what its marks are, and the standings in plain words,
    the numbers from 08 §7's phrases in spine.json (the one-page fronts copy them, and a test holds them to this)."""
    n = {phrase_n: int(phrase_n) for phrase_n, *_ in s['standing']['counts']}
    total, d, h, c, rest = n['117'], n['11'], n['1'], n['6'], n['99']
    share = (d + h) / total
    if lang == 'zh':
        about = '约十分之一' if 0.085 <= share <= 0.115 else f'{d + h} 项'
        return (f'每个圆是一章，按其结果数定大小；从一章到另一章的实线，计其结果使用另一章结果、记为 formal-reuse（这一类只用于'
                f'已核验的推理）的次数，虚线与点线是别种依赖；辐条标出该章有多少核心模块在中央的文法上陈述其律（计的是模块，'
                f'不是推导而得的结果）。{total} 项核心声明中，{about}被读作文法之律的情形（{d} 项推导而得，{h} 项在一个所述的'
                f'假设之下）；其余或为计数之律，位于文法以下（{c} 项），或处于一个指明的距离，各有其理由（{rest} 项）。')
    about = 'About a tenth' if 0.085 <= share <= 0.115 else f'{d + h}'
    return (f'Each circle is a chapter, sized by its results; a solid curve from one chapter to another counts the uses of '
            f'the other\'s results recorded as formal-reuse, the kind kept for verified inferences, and dashed and dotted '
            f'curves are other dependences; a spoke says how many of the chapter\'s core modules state their laws on the '
            f'grammar at the centre (modules, not results derived). {about} of the {total} central declarations are read as '
            f'cases of the grammar\'s laws ({d} derived, {h} under a stated hypothesis); the rest are counting laws, below the '
            f'grammar ({c}), or stand at a named distance, each with its reason ({rest}).')


def plural(n, noun):
    return f'{n} {noun}' + ('' if n == 1 else 's')


def lead(graph, page_path):
    """THEORY-GRAPH.md's opening on the picture, before the region table: the image, a plain reading of it with its
    counts from the graph, the standings of the central declarations in 08 §7's words, and the theses in 08 §9's."""
    s = spec()
    if not s:
        return []
    order = s['order']
    results, pairs, modules, concepts = counts(graph, order)
    here = Path(page_path).parent

    def rel(path, anchor=''):
        return os.path.relpath(path, here) + (f'#{anchor}' if anchor else '')

    between = {k: v['formal-reuse'] for k, v in pairs.items() if k[0] != k[1] and k[0] in order and k[1] in order}
    total = sum(between.values())
    into = {k: sum(n for (a, b), n in between.items() if b == k) for k in order}
    top = sorted(order, key=lambda k: -into[k])[:2]
    rank = {k: i for i, k in enumerate(order)}
    backward = sum(n for (a, b), n in between.items() if rank[a] < rank[b])
    name = {k: theory_graph.REGION_TITLES[k].split(':')[0] for k in theory_graph.REGION_TITLES}
    st = s.get('standing', {})
    counts_by = {n: phrase for n, path, phrase in st.get('counts', [])}
    m08 = 'theories/becoming/chapters/08-METHOD.md'
    lines = ['## The spine', '',
             f'**How to read it.** {how_to_read(s, "en")}', '',
             f'![The eight chapters around the grammar: circles sized by their results, curves counting the uses between '
             f'chapters\' results, the continuation condition and C coming into chapter 7 as premises, and T1 to T8 at their '
             f'homes coloured by test outcome]({rel(SVG["en"])})', '',
             f'*Generated by `tools/research/spine.py` from this graph and [spine.json]({rel(DATA)}); '
             f'[the Chinese of these sections]({rel(PAGE_ZH)}), with [its picture]({rel(SVG["zh"])}).*', '',
             f'**Reading it closely.** Each circle is one of the eight chapters, its size the number of results it holds; the '
             f'grammar, the root\'s vocabulary, is at the centre, and a spoke\'s width shows what share of the chapter\'s core '
             f'modules state their laws on it. A curve from one chapter to another counts the uses of the second\'s results '
             f'by the first\'s recorded as `formal-reuse`, a kind RESULT-WORKFLOW keeps for a verified inference: {total:,} '
             f'between chapters, {sum(into[k] for k in top):,} of them into {name[top[0]].lower()} and {name[top[1]].lower()}, '
             f'and {backward:,} running backward, an earlier chapter\'s results using a later one\'s. The two boxes are the '
             f'ethics\' premises, each a hypothesis where used, neither asserted. The badges T1 to T8 are the theses at the '
             f'chapters that state them, coloured by how their frozen tests came out; the table below gives each in its row\'s '
             f'words. A curve is a dependence, not an agreement in meaning.', '']
    if st:
        lines += [f'**The standings of the central declarations** ([08 §7]({rel(m08, "r-one-root-to-its-edge")})), which the '
                  f'picture\'s top line gives:', '',
                  '| Standing against the edge of one root | Declarations | In 08 §7\'s words |', '|---|---:|---|']
        for label, n in (('derived', '11'), ('under a stated hypothesis', '1'), ('counting, below the grammar', '6'),
                         ('at a named distance', '99')):
            lines.append(f'| {label} | {n} | "{counts_by.get(n, "")}" |')
        lines += [f'| all central declarations | 117 | "{counts_by.get("117", "")}" |', '']
    lines += [f'**The theses in the picture** ([08 §9]({rel(m08, "theses")})): words chosen from each row, its standing first; '
              f'the row has the rest.', '',
              '| Thesis | Home | Colour in the picture | Its row\'s words |', '|---|---|---|---|']
    for t in s['theses']:
        home = s['chapters'][t['home']]['file']
        lines.append(f'| {t["id"]}. {t["en"]["title"]} | [{home[:2]}]({rel("theories/becoming/chapters/" + home, t.get("anchor", ""))}) | '
                     f'{s["outcomes"][t["outcome"]]["en"]} | {"; ".join(t["en"]["words"])} |')
    return lines


def section(graph, page_path):
    """THEORY-GRAPH.md's section after the region table: what the picture shows and does not, in its homes' words, and
    the table of edge kinds."""
    s = spec()
    if not s:
        return []
    order = s['order']
    results, pairs, modules, concepts = counts(graph, order)
    here = Path(page_path).parent

    def rel(path, anchor=''):
        return os.path.relpath(path, here) + (f'#{anchor}' if anchor else '')

    between = {k: v for k, v in pairs.items() if k[0] != k[1] and k[0] in order and k[1] in order}
    drawn = [k for k, v in between.items() if v['formal-reuse'] >= DRAW_MIN]
    rank = {k: i for i, k in enumerate(order)}
    back = [k for k in drawn if rank[k[0]] < rank[k[1]]]
    small = [v['formal-reuse'] for k, v in between.items() if 0 < v['formal-reuse'] < DRAW_MIN]
    other_kind = sum(1 for v in between.values() if 0 < v['formal-reuse'] < DRAW_MIN
                     and (v['interpretive'] >= INTERPRETIVE_MIN or v['application'] >= 1))
    interp_small = [v['interpretive'] for v in between.values() if 0 < v['interpretive'] < INTERPRETIVE_MIN]
    related = sum(v['related'] for v in pairs.values())
    outside = sum(sum(v.values()) for k, v in pairs.items() if k[0] not in order or k[1] not in order)
    biggest = max(back, key=lambda k: between[k]['formal-reuse']) if back else None
    name = {k: theory_graph.REGION_TITLES[k].split(':')[0] for k in theory_graph.REGION_TITLES}
    cap = s['caption']
    others = sorted({k for pair in pairs for k in pair if k not in order}, key=lambda k: list(theory_graph.REGION_ORDER).index(k)
                    if k in theory_graph.REGION_ORDER else 99)
    method = rel('theories/becoming/chapters/08-METHOD.md', 'theses')
    lines = ['', '### The spine: what it shows and does not show', '',
             f'**What it shows.** Each circle is a chapter\'s region, its area proportional to the results the region '
             f'holds; the centre is the grammar ({concepts} concepts). A curve from one chapter to another counts uses of '
             f'the second\'s results by the first\'s under `formal-reuse`, which [RESULT-WORKFLOW]({rel(WORKFLOW)}) keeps '
             f'for "a verified inference using the cited result". Darker curves are an earlier chapter\'s results using a '
             f'later one\'s: {len(back)} of the {len(drawn)} pairs drawn'
             + (f', the largest {name[biggest[0]].lower()} to {name[biggest[1]].lower()} with '
                f'{between[biggest]["formal-reuse"]}' if biggest else '') + '. '
             f'Dashed curves are `interpretive`, kept for "an argument dependency", and dotted ones `application`; `related`, '
             f'which RESULT-WORKFLOW keeps for analogy, is not drawn ({related:,} edges). Not drawn as formal-reuse curves: '
             f'{plural(len(small), "pair")} with fewer than {DRAW_MIN} formal-reuse uses ({sum(small)} uses)'
             + (f', {other_kind} of them drawn as a dashed or dotted curve of another kind' if other_kind else '') + '; '
             f'not drawn as dashed curves: {plural(len(interp_small), "interpretive pair")} with fewer than '
             f'{INTERPRETIVE_MIN} ({sum(interp_small)} edges); and the counts of curves under {LABEL_MIN} uses are not '
             f'written. The table below has every pair. Beside a circle, "within" counts formal-reuse between results of '
             f'the same chapter; interpretive edges within a chapter are in the table. A spoke\'s width and its "k of m '
             f'modules" count the region\'s core modules that state their laws on the grammar, as the region lists below '
             f'say. '
             + (f'Results in {", ".join(name.get(k, k) for k in others)} ({outside} edges touch them) are in the table only. '
                if outside else '')
             + f'The continuation condition and C come into chapter 7 as premises: "{cap[4]["text"]}" '
             f'([07]({rel(cap[4]["home"])})). T1 to T8 stand at their homes, coloured by test outcome; their words, chosen '
             f'from their rows in [08 §9]({method}), standing first, are in the theses table above.', '',
             f'**What it does not show.** An edge records a dependence, a citation or a registered reading, not an '
             f'agreement in meaning, as this page begins. Nor does a curve say how far a chapter\'s results reach the '
             f'grammar, which 08 §7 counts two ways. "{cap[0]["text"]}"; "{cap[1]["text"]}"; "{cap[2]["text"]}" '
             f'([08 §7]({rel(cap[0]["home"], cap[0]["anchor"])})). And "{cap[5]["text"]}"; "{cap[3]["text"]}" '
             f'([08 §7]({rel(cap[3]["home"], cap[3]["anchor"])})). Reaching the grammar is that dependence of a '
             f'declaration\'s compiled type or value; being derived is a standing, a declaration read as a case of grammar '
             f'laws through bridges checked in Lean as equivalences and support the review reads where a row has them. So 45 and 11 count '
             f'different things, and the curves draw neither. Nor does a spoke: it counts modules that state their laws '
             f'on the grammar, not results that reach it.', '',
             '### Edge kinds between chapters', '',
             'Edges from the results of the first region to the results of the second, by the kind each record gives its '
             'dependence (`formal-reuse`, `interpretive`, `application`) and its `related` list (analogy, not a '
             'dependence). A row whose two regions are the same counts edges within the region.', '',
             '| Edges from results of | to results of | formal-reuse | interpretive | application | related |',
             '|---|---|---:|---:|---:|---:|']
    full = list(theory_graph.REGION_ORDER)
    for (a, b), c in sorted(pairs.items(), key=lambda kv: (full.index(kv[0][0]) if kv[0][0] in full else 99,
                                                              full.index(kv[0][1]) if kv[0][1] in full else 99)):
        if any(c.values()):
            lines.append(f'| {name.get(a, a)} | {name.get(b, b)} | {c["formal-reuse"]} | {c["interpretive"]} | '
                         f'{c["application"]} | {c["related"]} |')
    return lines


def zh_page(graph):
    """THEORY-GRAPH.zh.md: the Chinese of THEORY-GRAPH.md's spine sections (the picture, how to read it, the standings,
    the theses, what it shows and does not, the table of edge kinds), so the Chinese fronts link no English anchor.
    The quotations are spine.json's AI translations of their homes; the region lists stay in the English page."""
    from tools.research import navigation, zh_fronts
    s = spec()
    order = s['order']
    results, pairs, modules, concepts = counts(graph, order)
    here = Path(PAGE_ZH).parent

    def rel(path, anchor=''):
        return os.path.relpath(path, here) + (f'#{anchor}' if anchor else '')

    def zname(k):
        return s['chapters'][k]['zh'] if k in s['chapters'] else ZH_REGIONS.get(k, k)

    between = {k: v for k, v in pairs.items() if k[0] != k[1] and k[0] in order and k[1] in order}
    formal = {k: v['formal-reuse'] for k, v in between.items()}
    total = sum(formal.values())
    into = {k: sum(n for (a, b), n in formal.items() if b == k) for k in order}
    top = sorted(order, key=lambda k: -into[k])[:2]
    rank = {k: i for i, k in enumerate(order)}
    backward = sum(n for (a, b), n in formal.items() if rank[a] < rank[b])
    drawn = [k for k, n in formal.items() if n >= DRAW_MIN]
    back = [k for k in drawn if rank[k[0]] < rank[k[1]]]
    biggest = max(back, key=lambda k: formal[k]) if back else None
    small = [n for n in formal.values() if 0 < n < DRAW_MIN]
    other_kind = sum(1 for v in between.values() if 0 < v['formal-reuse'] < DRAW_MIN
                     and (v['interpretive'] >= INTERPRETIVE_MIN or v['application'] >= 1))
    interp_small = [v['interpretive'] for v in between.values() if 0 < v['interpretive'] < INTERPRETIVE_MIN]
    related = sum(v['related'] for v in pairs.values())
    outside = sum(sum(v.values()) for k, v in pairs.items() if k[0] not in order or k[1] not in order)
    others = sorted({k for pair in pairs for k in pair if k not in order})
    cap = s['caption']
    st = s['standing']
    m08 = 'theories/becoming/chapters/08-METHOD.md'
    body = ['## 脊柱', '<a id="the-spine"></a>', '',
            f'**怎样读它。** {how_to_read(s, "zh")}', '',
            f'![围绕文法的八章：圆按结果数定大小，曲线计各章结果之间的使用，两个前提进入第七章，各在所用之处为假设，T1 到 T8 '
            f'在其所属之处按检验结局着色]({rel(SVG["zh"])})', '',
            f'*由 `tools/research/spine.py` 依理论图与 [spine.json]({rel(DATA)}) 生成；[英文图]({rel(SVG["en"])})。*', '',
            f'**细读。** 每个圆是八章之一，大小为其所含结果数；中央是文法，即根的词汇；辐条的粗细表示该章核心模块中有多大比例在'
            f'文法上陈述其律。从一章到另一章的曲线，计后一章的结果被前一章的结果使用、记为 `formal-reuse` 的次数，'
            f'RESULT-WORKFLOW 把这一类留给已核验的推理：章与章之间共 {total} 次，其中 {into[top[0]] + into[top[1]]} 次进入'
            f'「{zname(top[0])}」与「{zname(top[1])}」两章，{backward} 次是逆向的，即前面一章的结果使用后面一章的结果。两个方框是伦理的两个'
            f'前提，各在所用之处为假设，二者都不断言。徽标 T1 到 T8 是各论题，位于陈述它们的那一章，按其冻结检验的结局着色；'
            f'下表以各自所在行的话给出它们。曲线是一种依赖，不是意义上的一致。', '',
            f'**核心声明的地位**（[08 §7]({rel(m08, "r-one-root-to-its-edge")})），即图顶端那一行：', '',
            '| 相对于一根之边的地位 | 声明数 | 08 §7 的话（译文） |', '|---|---:|---|']
    for label, n in (('推导而得', '11'), ('在一个所述的假设之下', '1'), ('计数，位于文法以下', '6'), ('处于一个指明的距离', '99')):
        body.append(f'| {label} | {n} | “{st["counts_zh"][n]}” |')
    body += [f'| 全部核心声明 | 117 | “{st["counts_zh"]["117"]}” |', '',
             f'**图中的论题**（[08 §9]({rel(m08, "theses")})）：选自[总览]({rel(s["theses_homes"]["zh"])})论题表中各自所在行的话，'
             f'地位在前；08 §9 各行的完整表述见英文。', '',
             '| 论题 | 所在 | 图中颜色 | 其行的话 |', '|---|---|---|---|']
    for th in s['theses']:
        home = s['chapters'][th['home']]['file']
        body.append(f'| {th["id"]}. {th["zh"]["title"]} | [{home[:2]}]({rel("theories/becoming/chapters/" + home, th.get("anchor", ""))}) | '
                    f'{s["outcomes"][th["outcome"]]["zh"]} | {"；".join(th["zh"]["words"])} |')
    body += ['', '### 它显示什么、不显示什么', '<a id="the-spine-what-it-shows-and-does-not-show"></a>', '',
             f'**它显示什么。** 每个圆是一章的区域，面积与该区域所含结果数成正比；中央是文法（{concepts} 个概念）。从一章到另一章的'
             f'曲线，计前一章的结果在 `formal-reuse` 之下使用后一章结果的次数，[RESULT-WORKFLOW]({rel(WORKFLOW)}) 把这一类留给'
             f'“使用所引结果的已核验推理”。较深的曲线是前面一章的结果使用后面一章的结果：所画 {len(drawn)} 个配对中有 {len(back)} 个'
             + (f'，最大的是「{zname(biggest[0])}」到「{zname(biggest[1])}」，{formal[biggest]} 次' if biggest else '') + '。'
             f'虚线是 `interpretive`，留给“论证上的依赖”；点线是 `application`；`related` 是 RESULT-WORKFLOW 留给类比的，不画出'
             f'（{related} 条边）。不画作 formal-reuse 曲线的：少于 {DRAW_MIN} 次 formal-reuse 使用的 {len(small)} 个配对（共 '
             f'{sum(small)} 次）' + (f'，其中 {other_kind} 个画作别种的虚线或点线' if other_kind else '') + f'；不画作虚线的：少于 '
             f'{INTERPRETIVE_MIN} 次的 {len(interp_small)} 个诠释配对（{sum(interp_small)} 条边）；少于 {LABEL_MIN} 次的曲线不标数字。下表列出'
             f'每一个配对。圆旁的“章内使用”计同一章结果之间的 formal-reuse，章内的诠释边见表。辐条上的“m 个模块中 k 个”与其粗细，'
             f'计该区域核心模块中在文法上陈述其律的那些，如[英文版](THEORY-GRAPH.md)各区域的列表所示。'
             + (f'{"、".join("「" + zname(k) + "」" for k in others)}的结果（{outside} 条边涉及它们）只在表中。' if outside else '')
             + f'延续条件与 C 作为前提进入第七章：“{cap[4]["zh"]}”（[07]({rel(cap[4]["home"])})）。T1 到 T8 位于其所属之处，按检验'
             f'结局着色；它们的话选自[总览]({rel(s["theses_homes"]["zh"])})论题表中各自所在的行，地位在前，见上面的论题表。', '',
             f'**它不显示什么。** 一条边记录的是一种依赖、一次引用或一个已登记的读法，不是意义上的一致。曲线也不说一章的结果在多大'
             f'程度上达到文法，08 §7 以两种方式计这一点。“{cap[0]["zh"]}”；“{cap[1]["zh"]}”；“{cap[2]["zh"]}”'
             f'（[08 §7]({rel(cap[0]["home"], cap[0]["anchor"])})）。又，“{cap[5]["zh"]}”；“{cap[3]["zh"]}”'
             f'（[08 §7]({rel(cap[3]["home"], cap[3]["anchor"])})）。达到文法，是一项声明编译后的类型或值的那种依赖；推导而得是'
             f'一种地位，即一项声明被读作文法之律的一个情形，经由在 Lean 中作为等价核验的桥接与审阅所读的支持（在某行列有它们之处）。'
             f'所以 45 与 11 计的是不同的东西，而曲线两者都不画。辐条也不画：它计的是在文法上陈述其律的模块，不是达到文法的结果。', '',
             '### 各章之间边的种类', '<a id="edge-kinds-between-chapters"></a>', '',
             '从第一个区域的结果到第二个区域的结果的边，按各记录给其依赖的种类（`formal-reuse`、`interpretive`、`application`）'
             '与其 `related` 列表（类比，不是依赖）计。两个区域相同的一行，计该区域之内的边。区域以其所在章在总览中的标题称之；'
             '英文区域名见[英文版](THEORY-GRAPH.md#the-regions)。', '',
             '| 从此区域的结果 | 到此区域的结果 | formal-reuse | interpretive | application | related |',
             '|---|---|---:|---:|---:|---:|']
    full = list(theory_graph.REGION_ORDER)
    for (a, b), c in sorted(pairs.items(), key=lambda kv: (full.index(kv[0][0]) if kv[0][0] in full else 99,
                                                              full.index(kv[0][1]) if kv[0][1] in full else 99)):
        if any(c.values()):
            body.append(f'| {zname(a)} | {zname(b)} | {c["formal-reuse"]} | {c["interpretive"]} | {c["application"]} | {c["related"]} |')
    head = ['<!-- Generated by tools/research/research.py render (tools/research/spine.py) from the theory graph and '
            'theories/becoming/results/data/spine.json; edit those, not this page. -->', '',
            '# 理论图：脊柱', '', zh_fronts.nav_line(PAGE_ZH), '', '{time}', '',
            f'本页是[理论图](THEORY-GRAPH.md)中脊柱部分的中文版：这幅图、怎样读它、核心声明的地位与论题、它显示什么与不显示什么，'
            f'以及各章之间边的种类表；各区域的结果、模块与文本的列表只在英文版中。本页的“脊柱”指各章围绕文法的这幅图；术语表中的'
            f'“脊柱”指由其检查器所运行的 Lean 包 `Becoming`。本页由 AI 翻译；引自英文文本的话都是译文，未经核对，以英文原文为准。', '']
    text = '\n'.join(head + body).rstrip() + '\n'
    time = navigation.reading_time(text).replace(' minutes', ' 分钟').replace('a minute', '一分钟')
    return text.replace('{time}', f'*约 {time}读完。*', 1)


def render(graph_json):
    """(pages, errors): the two pictures and the Chinese page, or none and the errors where a quoted phrase has left
    its home."""
    s = spec()
    if not s:
        return {}, [f'{DATA} is missing']
    errors = check(s)
    if errors:
        return {}, errors
    graph = json.loads(graph_json)
    pages = {SVG[lang]: svg(graph, s, lang) for lang in ('en', 'zh')}
    pages[PAGE_ZH] = zh_page(graph)
    return pages, []
