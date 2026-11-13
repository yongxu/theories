"""The spine picture (board item RW (c)): the eight chapters around the grammar, drawn from the theory graph.

One generated SVG in English (`theories/becoming/results/spine.svg`) and one in Chinese (`spine.zh.svg`), and the
section of THEORY-GRAPH.md that captions them, with the table of edge kinds between chapters. What is drawn, all
counted from the graph the same render builds:

- the grammar at the centre (its concepts) and the eight chapter regions on a ring in the chapters' order, each
  circle's area proportional to the results the region holds;
- each chapter's number inside its circle, its name, results and uses within it beside it;
- a spoke from each region to the grammar, its width the share of the region's core modules that state their laws on
  it, the count ("k of m modules on the grammar") in the chapter's words beside it, off the ring;
- under the standings of the central declarations, a strip of the five shared laws from 08 §7: the central rows on
  each and, hatched, those reaching the grammar, balance marked represented and not derived;
- `formal-reuse` between results of two regions as solid curves, for each ordered pair with at least DRAW_MIN uses,
  kept off a disc round the grammar, the count beside the curve where it is at least LABEL_MIN, darker where an
  earlier chapter's results use a later one's;
- `interpretive` edges between regions dashed (pairs with at least INTERPRETIVE_MIN), `application` edges dotted
  (every pair); `related` (analogy) is not drawn;
- what ranking results take as hypotheses, each where its theorem takes it, coming into chapter 7 in their homes'
  words: the continuation condition held de se, self-concern and C (`Comparison`), drawn as hypotheses, not as
  premises of the ethics (AG review, 9 November 2026: C is no longer introduced as a second foundation of the ethics);
- T1-T8 pinned at their homes, coloured by test outcome, with words chosen from their rows in 08 §9 (in Chinese,
  from the overview's table), standing first.

What is not drawn is counted in the caption, and every pair is in the table. A simpler picture
(`standings.svg`, `standings.zh.svg`) draws the central declarations one square each by their standing against the edge
of one root, the 99 at a named distance by reason, with one example per standing in its record's words. The curated input is
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
FIRST = {'en': 'theories/becoming/results/standings.svg', 'zh': 'theories/becoming/results/standings.zh.svg'}  # the simpler picture
PAGE_ZH = 'theories/becoming/results/THEORY-GRAPH.zh.md'  # the Chinese of THEORY-GRAPH.md's spine sections
# The atlas's terrain (tools/research/atlas.py, from the entries alone), placed before the chapters' picture: round 6 of the
# re-score asked that the fronts show the dynamics first and the chapters second (AG-F, 11 November 2026)
ATLAS_PAGE = 'theories/becoming/results/atlas/ATLAS.md'
TERRAIN = {'page': 'theories/becoming/results/atlas/TERRAIN.md', 'svg': 'theories/becoming/results/atlas/terrain.svg'}
ZH_REGIONS = {'process': '过程', 'retire': '待退役', 'unassigned': '尚未归属'}
WORKFLOW = '_process/RESULT-WORKFLOW.md'
DRAW_MIN = 10
INTERPRETIVE_MIN = 3
KINDS = ('formal-reuse', 'interpretive', 'application', 'related')
W, H = 900, 900
RING = 250            # the chapters' ring
CX, CY = W / 2, 470   # its centre; svg() sets the height below the header
GR = 58               # the grammar's circle
KEEP = GR + 26        # the base distance of a pair's curves from the centre is at least KEEP + 24; a pair's lanes sit
                      # up to 32 nearer (formal-reuse 8, interpretive 24, application 32), still clear of the grammar's
                      # circle (the tests hold GR + 6); 16 between a pair's two directions leaves a count room on its curve
LANE_STEP = 16        # between the lanes of pairs that pass near the grammar
LABEL_MIN = 15        # counts written on the picture
LEAD = 5              # how much nearer its own curve than any other a count must stand
LEAD_FLOOR = 4.75     # where no place gives LEAD clear of every other stroke by 1 px: the least lead a count takes,
                      # with every other stroke cleared exactly (the tests hold LEAD - 0.5 and the stroke itself)
BAR_MIN = 16          # the narrowest bar in the shared laws' strip
SPOKE_MAX = 6         # a spoke's extra width when every module of its chapter states its laws on the grammar
STANDING_FILL = ('#1c1917', '#57534e', '#a8a29e', '#e7e5e4')  # derived, under a hypothesis, counting, at a distance
LEGEND_X = 470
INK, MUTED, FAINT, PAPER = '#1c1917', '#57534e', '#a8a29e', '#fcfcfb'
FORWARD, BACKWARD = '#8a817c', '#1c1917'
FONT = {'en': 'Helvetica, Arial, sans-serif',
        'zh': "'PingFang SC', 'Hiragino Sans GB', 'Noto Sans CJK SC', 'Microsoft YaHei', sans-serif"}

WORDS = {
    'en': {
        'title': 'The eight chapters and their recorded uses of one another',
        'subtitle': 'Drawn from the theory graph: each circle sized by its chapter’s results; each solid curve counting one chapter’s uses of another’s results recorded as formal-reuse, dashed and dotted curves between chapters other dependences.',
        'grammar': 'The grammar', 'concepts': '{n} concepts',
        'results': '{n} results', 'within': '{n} within',
        'read': 'How to read it',
        'size': 'Circle: a chapter, its area by its results; its number inside it; beside it, its name, its results and the formal-reuse uses within it.',
        'formal': 'A use recorded as formal-reuse, a kind kept for “a verified inference using the cited result”: the arrow points to the chapter whose results are used; the number beside a curve counts its uses, written where it is {m} or more. The AI-written records assign the kind; the registry checks that an interface has its fields and cites a file among the record’s hashed references (on {k} of all {n} such edges; each cites a Lean file); nothing checks that the Lean there uses the cited result.',
        'numbering': 'The chapters are numbered for reading, not as an order of proof: {b} of the {t} uses between chapters run backward, an earlier chapter’s results using a later one’s (the darker curves; only formal-reuse curves of pairs with {m} or more are drawn).',
        'backward': 'The same, darker where an earlier chapter’s results use a later one’s.',
        'interpretive': 'interpretive, kept for “an argument dependency” (dashed; pairs with {m} or more).',
        'application': 'application, a reused result with its correspondence and added premises (dotted).',
        'spoke': 'Spoke: its width is the share of the chapter’s core modules that state their theorems on the grammar, given beside the chapter as “k of m modules on the grammar”. It counts modules, not results derived.',
        'spoke_label': '{k} of {m} modules on the grammar',
        'laws_head': 'The five shared laws (08 §7): central rows on each; hatched, those whose compiled type or value reaches the grammar',
        'law_all': '{c} rows, all {c} reach', 'law_some': '{c} rows, {k} reach', 'law_rep': 'represented both ways, not derived',
        'laws_note': 'Rows, not declarations: {rested} of the {rows} central rows (nine declarations stand in two) rest on at least one law, some on several. Reaching the grammar is not being derived: only the {d} derived above are read as cases of grammar theorems, and {h} as a root form at one step, under a stated hypothesis. A bar of few rows is widened to be seen; the words give the counts.',
        'related': 'Not drawn: related, for analogy ({n} edges), and the formal-reuse curves of pairs under {m} uses; counts under {k} are not written. THEORY-GRAPH.md’s edge kinds between chapters, its tables and pair list, have them all.',
        'theses': 'The theses',
        'theses_note': 'T1–T8 at their homes; what each claims, how far it has been seen and its tests: the theses table in THEORY-GRAPH.md, “The chapters at a glance”.',
        'premises': 'What ranking results take as hypotheses',
        'footer': 'Generated by tools/research/spine.py from theory-graph.json and spine.json; THEORY-GRAPH.md, “What the picture shows and does not show”, says so.',
    },
    'zh': {
        'title': '八章及各章彼此之间有记录的使用',
        'subtitle': '由理论图画出：每个圆按其章的结果数定大小；每条实线计一章的结果使用另一章结果、记为 formal-reuse 的次数，章与章之间的虚线与点线是别种依赖。',
        'grammar': '文法', 'concepts': '{n} 个概念',
        'results': '{n} 项结果', 'within': '章内使用 {n}',
        'read': '怎样读这幅图',
        'size': '圆：一章，面积按其结果数；圆内是章号；圆旁是章名、结果数与章内 formal-reuse 使用数。',
        'formal': '记为 formal-reuse 的使用（这一类留给使用所引结果的已核验推理）：箭头指向被使用其结果的那一章；曲线旁的数字为其使用次数，{m} 次及以上才标出。这一类由 AI 写成的记录指定；登记检查核对接口具备其字段、且其所引是记录中带散列的参考文献之一（全部 {n} 条这样的边中有 {k} 条，所引的都是 Lean 文件）；没有任何检查核对那里的 Lean 是否确实使用所引的结果。',
        'numbering': '章的编号是为阅读，不是证明的次序：章与章之间的 {t} 次使用中，{b} 次是逆向的，即章序在前的一章的结果使用章序在后的一章的结果（较深的曲线；formal-reuse 的实线只画出有 {m} 次或以上的配对）。',
        'backward': '同上；章序在前的一章的结果使用章序在后的一章的结果时，线色较深。',
        'interpretive': '诠释（interpretive），用于论证上的依赖（虚线；{m} 次及以上的配对）。',
        'application': '应用（application），一个被复用的结果，连同其对应与所添的前提（点线）。',
        'spoke': '辐条：粗细表示该章核心模块中在文法上陈述其律者所占的比例，其数写在章旁，作“m 个模块中 k 个在文法上”。它计的是模块，不是推导而得的结果。',
        'spoke_label': '{m} 个模块中 {k} 个在文法上',
        'laws_head': '五条共律（08 §7）：依于每一条的核心行；斜线部分是其编译后的类型或值达到文法的行',
        'law_all': '{c} 行，全部达到', 'law_some': '{c} 行，{k} 行达到', 'law_rep': '双向表示，不推导',
        'laws_note': '计的是行，不是声明：{rows} 个核心行（九项声明各占两行）中，{rested} 行至少依于一条律，有的依于多条。达到文法不等于推导而得：被读作文法之律之情形的，只有上面推导而得的 {d} 项，另有 {h} 项在一个所述的假设之下被读作一个根形式的一步。行数很少的条加宽以便看见；数目以文字为准。',
        'related': '不画出：相关（related，用于类比，{n} 条边），以及少于 {m} 次 formal-reuse 使用之配对的实线；少于 {k} 次的不标数字。理论图“各章一览”的中文版（THEORY-GRAPH.zh.md）中各章之间边的种类（各表与配对列表）列出全部。',
        'theses': '论题',
        'theses_note': 'T1 到 T8 在其所属之处；各自主张什么、看到了多远、检验如何：见理论图“各章一览”的中文版（THEORY-GRAPH.zh.md）中的论题表。',
        'premises': '排序结果所取的假设',
        'footer': '图中文字为 AI 所译，义以英文版为准。由 tools/research/spine.py 依 theory-graph.json 与 spine.json 画出；它显示什么、不显示什么，见 THEORY-GRAPH.zh.md 的“这幅图显示什么、不显示什么”。',
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
    laws = shared_laws_rows()
    if [r[0] for r in laws if r[2]] != ['Balance']:
        errors.append('08 §7: the laws table no longer has Balance as its one row represented and not derived')
    for name, *_ in laws:
        if name not in s.get('laws_zh', {}).get('names', {}):
            errors.append(f'spine.json: laws_zh has no name for {name}')
    errors += [f'08 §7 no longer says how many of the rows on {name} reach the grammar'
               for name, _, _, count in laws if reaching_the_grammar(name, count) is None]
    if rows_reaching() is None:
        errors.append('08 §7 no longer says how many of the 126 rows reach the grammar, and how many on no anchor')
    last_three = [d for d, *_ in derived_rows()[-3:]]
    after = method_section_7().split('the eight connected rows', 1)[-1].split(');', 1)[-1]  # past the eight's own list
    if not all(f'`{d}`' in after for d in last_three):
        errors.append(f'08 §7 no longer names {last_three} after the eight connected rows; THEORY-GRAPH says all but the last three')
    if len(derived_rows()) != 11:
        errors.append(f'the edge record has {len(derived_rows())} derived declarations; THEORY-GRAPH says eleven')
    if standing and str(central_total()) != standing['counts'][0][0]:
        errors.append(f'the shared-laws data places {central_total()} central declarations; the standing line counts otherwise')
    holds(METHOD, "every model's theorem in a row is proved from it, except balance's, which the grammar represents and does not derive")
    if central_rows() is None:
        errors.append('08 §7 no longer says how many of the central rows rest on at least one shared law')
    fv = s.get('first_view')
    if fv:  # the simpler picture: every class drawn, each class's words and count 08 §7's, each example its record's
        n = boundary_counts()
        drawn = [b['key'] for b in fv['bands']] + [d['key'] for d in fv['distance']]
        errors += [f'the shared-laws data has {v} central declarations "{k}", a class the simpler picture does not draw'
                   for k, v in n.items() if v and k not in drawn]
        if sum(n.values()) != central_total():
            errors.append('the shared-laws data\'s classes do not add to its central declarations')
        for b in fv['bands']:
            holds(METHOD, b['en']['gloss'])
            for lang in ('en', 'zh'):
                if b.get('gloss_also'):
                    holds(*b['gloss_also'][lang])
        for d in fv['distance']:
            holds(METHOD, f'{n.get(d["key"], 0)} {d["en"]["label"]}')
            if d['en'].get('gloss'):
                holds(METHOD, d['en']['gloss'])
        rows = json.loads(_read(registry.SHARED_LAWS) or '{}').get('boundary', {}).get('rows', {})
        for item in fv['bands'] + fv['distance']:
            if item.get('example'):
                ex = item['example']
                for lang in ('en', 'zh'):
                    holds(*ex[lang])
                if ex.get('note'):  # a note on an example is the glossary's words
                    for lang in ('en', 'zh'):
                        holds(*ex['note'][lang])
                if ex['en'][0] != ex['zh'][0]:
                    errors.append(f'spine.json: the example of "{item["key"]}" quotes two records, {ex["en"][0]} and {ex["zh"][0]}')
                if ex.get('in_law'):
                    laws = json.loads(_read(ex['en'][0]) or '{}').get('laws', [])
                    for lang in ('en', 'zh'):
                        if not any('Becoming.' + ex['declaration'] in law.get('declarations', []) and norm(ex[lang][1]) in norm(law.get(lang, ''))
                                   for law in laws):
                            errors.append(f'spine.json: the example of "{item["key"]}" is not in a law of its record naming {ex["declaration"]} ({lang})')
                label = rows.get('Becoming.' + ex['declaration'], {}).get('label')
                if label != item['key']:
                    errors.append(f'spine.json: the example of "{item["key"]}", {ex["declaration"]}, stands as {label!r} in the shared-laws data')
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


def along(point, prefer, offsets=(0, 6, 12, 18, 24), steps=50):
    """Candidate centres on and either side of a curve, nearest `prefer` along it first: at `steps` points along it, from
    a tenth of the way to nine tenths with `steps` 50, from a twentieth to nineteen twentieths with more."""
    lo = 5 if steps <= 50 else steps // 20
    ts = sorted((i / steps for i in range(lo, steps - lo + 1)), key=lambda t: abs(t - prefer))
    out = []
    for t in ts:
        (x0, y0), (x1, y1) = point(max(0.0, t - 0.01)), point(min(1.0, t + 0.01))
        dx, dy = x1 - x0, y1 - y0
        length = math.hypot(dx, dy) or 1
        nx, ny = -dy / length, dx / length
        x, y = point(t)
        out += [(x + nx * o * s, y + ny * o * s) for o in offsets for s in (1, -1)]
    return out


def layout(s, results, pairs, lang, top, modules=None):
    """Where everything on the ring goes: centres, radii, the chapters' label blocks (with the spoke's count where
    `modules` gives it), the curves with their lanes."""
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
        spoke = [(words['spoke_label'].format(k=modules[k][1], m=modules[k][0]), 13, 'normal', MUTED)] if modules else []
        return [(line, 16, 'bold', INK) for line in names] + [(counted, 13, 'normal', MUTED)] + spoke

    def block_height(lines):
        return sum(19 if size >= 16 else 17 for _, size, *_ in lines)

    first = order[0]
    cy = top + 18 + block_height(block_lines(first)) + 8 + r[first] + RING
    cx = CX
    centre = {k: (cx + RING * math.cos(angle[k]), cy + RING * math.sin(angle[k])) for k in order}
    # label blocks: above a chapter in the upper part of the ring, below every other; centred on it, except away from
    # the ring's top and bottom, where a block leans outward, off the curves that leave the chapter inward
    blocks = {}
    for k in order:
        lines = block_lines(k)
        x, y = centre[k]
        height = block_height(lines)
        widest = max(width_of(line, size, weight == 'bold') for line, size, weight, _ in lines)
        above = math.sin(angle[k]) < -0.3
        y0 = y - r[k] - 9 - height if above else y + r[k] + 7
        lean = -1 if math.cos(angle[k]) < -0.5 else 1 if math.cos(angle[k]) > 0.5 else 0
        tx = x + lean * 0.5 * r[k] * -1 if lean else x  # the text's anchor: the circle's inner side, the block running outward
        x0 = tx - widest if lean < 0 else tx if lean > 0 else x - widest / 2
        blocks[k] = {'lines': lines, 'box': (x0, y0, x0 + widest, y0 + height), 'x': tx,
                     'anchor': 'end' if lean < 0 else 'start' if lean > 0 else 'middle'}
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
        base[g] = max(KEEP + 24, h - (16 if h > 0.85 * RING else 32))
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
            offset = {'formal-reuse': 8 * outward, 'interpretive': 24 * outward, 'application': 32 * outward}[e['kind']]
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
    iface, formal = interface_counts(graph)
    out = [f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {H}" width="{W}" height="{H}" role="img" '
           f'aria-labelledby="spine-title spine-desc" font-family="{FONT[lang]}">',
           f'<title id="spine-title">{escape(words["title"])}</title>',
           f'<desc id="spine-desc">{escape(description(results, pairs, s, lang, modules))}</desc>',
           '<defs>',
           f'<marker id="fwd" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="11" markerHeight="11" markerUnits="userSpaceOnUse" orient="auto"><path d="M0,0 L10,5 L0,10 z" fill="{FORWARD}"/></marker>',
           f'<marker id="back" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="11" markerHeight="11" markerUnits="userSpaceOnUse" orient="auto"><path d="M0,0 L10,5 L0,10 z" fill="{BACKWARD}"/></marker>',
           f'<marker id="thin" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="9" markerHeight="9" markerUnits="userSpaceOnUse" orient="auto"><path d="M0,1 L9,5 L0,9" fill="none" stroke="{MUTED}" stroke-width="1.5"/></marker>',
           f'<marker id="diamond" viewBox="0 0 10 10" refX="5" refY="5" markerWidth="9" markerHeight="9" markerUnits="userSpaceOnUse" orient="auto"><path d="M5,0 L10,5 L5,10 L0,5 z" fill="{MUTED}"/></marker>',
           f'<pattern id="reach" width="4" height="4" patternUnits="userSpaceOnUse" patternTransform="rotate(45)"><rect width="4" height="4" fill="#ffffff"/><rect width="2" height="4" fill="{MUTED}"/></pattern>',
           '</defs>',
           f'<rect x="0.5" y="0.5" width="{W - 1}" height="{H - 1}" rx="10" fill="{PAPER}" stroke="#d6d3d1"/>',
           text(24, 40, words['title'], 24, 'bold')]
    y = 66
    rank = {k: i for i, k in enumerate(order)}
    between = {k: v['formal-reuse'] for k, v in pairs.items() if k[0] != k[1] and k[0] in rank and k[1] in rank}
    backward = sum(n for (a, b), n in between.items() if rank[a] < rank[b])
    numbering = words['numbering'].format(b=f'{backward:,}', t=f'{sum(between.values()):,}', m=DRAW_MIN)
    for line in wrap(words['subtitle'], 100 if lang == 'en' else 92, lang) + wrap(numbering, 100 if lang == 'en' else 92, lang):
        out.append(text(24, y, line, 15, fill=MUTED))
        y += 19
    top = y - 19 + 6
    standing = s.get('standing', {}).get(lang)
    if standing:
        y += 8
        sep = '：' if lang == 'zh' else ': '
        head, body = standing.split(sep, 1) if sep in standing else (standing, '')
        lines = wrap(head + sep.strip(), 100 if lang == 'en' else 92, lang) + wrap_items(body, 100 if lang == 'en' else 92, lang)
        heads = len(wrap(head + sep.strip(), 100 if lang == 'en' else 92, lang))
        out.append(f'<rect x="20" y="{y - 17}" width="{W - 40}" height="{36 + 20 * len(lines)}" rx="6" fill="#f5f5f4" stroke="#e7e5e4"/>')
        counts_of, item = [], 0
        for i, line in enumerate(lines):
            if i < heads:
                out.append(text(32, y + 20 * i, line, 15, 'bold', fill=INK))
                continue
            x = 32.0
            for body_item in line.split(' · '):  # each standing with the swatch of its segment in the bar
                out.append(f'<rect x="{f(x)}" y="{y + 20 * i - 10}" width="10" height="10" fill="{STANDING_FILL[item]}" stroke="{MUTED}" stroke-width="0.5"/>')
                out.append(text(x + 14, y + 20 * i, body_item, 15, fill=INK))
                x += 14 + width_of(body_item, 15) + 18
                counts_of.append(int(re.search(r'\d+', body_item).group()))
                item += 1
        bar_y, x, whole = y + 20 * len(lines) - 6, 32.0, sum(counts_of) or 1
        for fill, n in zip(STANDING_FILL, counts_of):  # the bar: each standing's share of the central declarations, drawn
            w = (W - 64) * n / whole                    # at its true width, the segments told apart by a hairline as the swatches are
            out.append(f'<rect x="{f(x)}" y="{bar_y}" width="{f(w)}" height="12" fill="{fill}" stroke="{MUTED}" stroke-width="0.5">'
                       f'<title>{n}</title></rect>')
            x += w
        top = y - 17 + 36 + 20 * len(lines)
        top = laws_strip(out, s, lang, top + 10, counts_of[0])
    L = layout(s, results, pairs, lang, top, modules)
    centre, r, angle, cx, cy = L['centre'], L['r'], L['angle'], L['cx'], L['cy']
    for c in L['curves']:  # the circles are painted over the curves: one passing behind a chapter would read as two edges
        for k in order:
            if k not in (c['from'], c['to']):
                near = min(math.hypot(px - centre[k][0], py - centre[k][1]) for px, py in (c['point'](i / 100) for i in range(101)))
                if near < r[k] + 3:
                    raise ValueError(f'spine picture ({lang}): the {c["kind"]} curve from {c["from"]} to {c["to"]} passes behind chapter {k}')
        for k, block in L['blocks'].items():  # nor through a chapter's words
            x0, y0, x1, y1 = block['box']
            if any(x0 - 2 <= px <= x1 + 2 and y0 - 2 <= py <= y1 + 2 for px, py in (c['point'](i / 200) for i in range(201))):
                raise ValueError(f'spine picture ({lang}): the {c["kind"]} curve from {c["from"]} to {c["to"]} crosses the words of chapter {k}')
    circles = [(cx, cy, GR)] + [(centre[k][0], centre[k][1], r[k]) for k in order]
    boxes = [b['box'] for b in L['blocks'].values()]
    # spokes to the grammar, their width by the share of the chapter's modules stated on it
    spoke_soft = []  # points along each spoke, which a count should not sit on
    for k in order:
        x, y0 = centre[k]
        a = angle[k]
        gx, gy = cx + (GR + 2) * math.cos(a), cy + (GR + 2) * math.sin(a)
        sx, sy = x - (r[k] + 2) * math.cos(a), y0 - (r[k] + 2) * math.sin(a)
        share = modules[k][1] / modules[k][0] if modules[k][0] else 0
        out.append(f'<line x1="{f(sx)}" y1="{f(sy)}" x2="{f(gx)}" y2="{f(gy)}" stroke="{FAINT}" stroke-opacity="0.45" '
                   f'stroke-width="{f(1 + SPOKE_MAX * share)}" stroke-linecap="round"/>')
        spoke_soft += [(sx + (gx - sx) * i / 40, sy + (gy - sy) * i / 40, (1 + SPOKE_MAX * share) / 2 + 1) for i in range(41)]
    out.append(f'<circle cx="{f(cx)}" cy="{f(cy)}" r="{GR}" fill="#f5f5f4" stroke="{INK}" stroke-width="1.5"/>')
    out.append(text(cx, cy - 2, words['grammar'], 15 if lang == 'en' else 17, 'bold', 'middle'))
    out.append(text(cx, cy + 16, words['concepts'].format(n=concepts), 13, anchor='middle', fill=MUTED))
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
            out.append(text(b['x'], yy - 4, line, size, weight, b['anchor'], fill, True))
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
    # the counts of 15 and more beside their curves, nearest their own, clear of the circles, the labels and their
    # pair's curves (the spokes' counts stand in the chapters' label blocks, off the ring)
    labels = []
    obstacles = circles + badges
    under = {id(c): [(*c['point'](i / 60), 1.5 + (0.4 + 0.4 * math.sqrt(c['n']) if c['kind'] == 'formal-reuse' else 1))
                     for i in range(61)] for c in L['curves']}
    halo = {id(c): [(x, y, r + 1.5) for x, y, r in pts] for c, pts in ((c, under[id(c)]) for c in L['curves'])}  # a count's halo too
    fine = {id(c): [c['point'](i / 100) for i in range(101)] for c in L['curves']}

    def nearest_is(c, lead=LEAD):  # a count stands visibly nearer its own curve than any other
        def accept(x, y):
            own = min(math.hypot(px - x, py - y) for px, py in fine[id(c)])
            return all(min(math.hypot(px - x, py - y) for px, py in fine[id(o)]) > own + lead for o in L['curves'] if o is not c)
        return accept

    for c in sorted(L['curves'], key=lambda c: -c['n']):
        if c['kind'] != 'formal-reuse' or c['n'] < LABEL_MIN:
            continue
        back = L['rank'][c['from']] < L['rank'][c['to']]
        body = str(c['n'])
        w, h = width_of(body, 14, back) + 6, 16
        mates = [o for o in L['curves'] if o is not c and {o['from'], o['to']} == {c['from'], c['to']}]
        soft = [pt for other in L['curves'] if other is not c and other not in mates for pt in halo[id(other)]] + spoke_soft
        hard = obstacles + [(x, y, r + 1) for o in mates for x, y, r in under[id(o)]]
        # either side of the curve: nearest_is keeps a count by its own curve rather than its pair's other one
        # the count's box already pads its digits by about 3 px, so every other curve's and spoke's stroke, and 1 px beyond
        # it, bound the box (not the halos)
        strict = hard + [(x, y, r - 0.5) for o in L['curves'] if o is not c and o not in mates for x, y, r in under[id(o)]] + spoke_soft
        box = place_box(along(c['point'], 0.5, offsets=(0, 3, 6, 9, 12, 15, 18, 21, 24)), w, h, strict, boxes + [l[0] for l in labels],
                        pad=0.0, soft=soft, accept=nearest_is(c))
        lead = LEAD
        if not all(clear_of_circle(box, o) for o in strict) or not nearest_is(c)((box[0] + box[2]) / 2, (box[1] + box[3]) / 2):
            # no place both clear of every other stroke by 1 px and LEAD nearer its own curve: of the places, every hundredth
            # of the way along the curve and every pixel either side, LEAD_FLOOR nearer its own curve and clear of the circles, labels
            # and its pair's curves, the one farthest from every other curve's and spoke's stroke (a bundle of two curves
            # LEAD apart, as where 07's curve to 01 meets 06's, leaves room only there)
            lead = LEAD_FLOOR
            taken = boxes + [l[0] for l in labels]
            def room(x, y):
                b = (x - w / 2, y - h / 2, x + w / 2, y + h / 2)
                return min(math.hypot(px - min(max(px, b[0]), b[2]), py - min(max(py, b[1]), b[3])) - r for px, py, r in strict[len(hard):])
            fits = [(x, y) for x, y in along(c['point'], 0.5, offsets=tuple(range(25)), steps=100)
                    if all(clear_of_circle((x - w / 2, y - h / 2, x + w / 2, y + h / 2), o) for o in hard)
                    and not any(overlaps((x - w / 2, y - h / 2, x + w / 2, y + h / 2), b) for b in taken)
                    and nearest_is(c, lead)(x, y)]
            # place_box takes the first candidate that clears, so ordering by room picks the roomiest
            box = place_box(sorted(fits, key=lambda p: -room(*p)) or along(c['point'], 0.5), w, h, hard, taken, pad=0.0,
                            soft=() if fits else soft, accept=nearest_is(c, lead))
        cx_, cy_ = (box[0] + box[2]) / 2, (box[1] + box[3]) / 2
        # the stroke itself, not the 1 px beyond it: what the tests hold, so no count is drawn across another curve
        crossed = [o for o in L['curves'] if o is not c and o not in mates and not all(
            clear_of_circle(box, (px, py, 0.4 + 0.4 * math.sqrt(o['n']) if o['kind'] == 'formal-reuse' else 1)) for px, py in fine[id(o)])]
        if (not nearest_is(c, lead)(cx_, cy_) or not all(clear_of_circle(box, o) for o in hard)
                or any(overlaps(box, b) for b in boxes + [l[0] for l in labels]) or crossed
                or not all(clear_of_circle(box, (x, y, r - 1)) for x, y, r in spoke_soft)):
            raise ValueError(f'spine picture ({lang}): no place for the count {c["n"]} of {c["from"]} to {c["to"]} '
                             f'nearer its own curve than any other and clear of the circles, the labels, its pair\'s curves '
                             f'and every other stroke' + (f' (it would cross {crossed[0]["from"]} to {crossed[0]["to"]})' if crossed else ''))
        labels.append((box, text((box[0] + box[2]) / 2, box[3] - 3.5, body, 14, 'bold' if back else 'normal', 'middle',
                                 BACKWARD if back else FORWARD, True)))
        if info is not None:
            info.setdefault('counts', []).append((c, box))
    out += [l[1] for l in labels]
    if info is not None:
        info.update({'curves': L['curves'], 'circles': circles + badges, 'boxes': boxes, 'spokes': spoke_soft})
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
    out.append(f'<circle cx="{x0 + 13}" cy="{y - 5}" r="12" fill="#ffffff" stroke="{INK}" stroke-width="1.5"/>')
    out.append(text(x0 + 13, y - 0.5, '01', 13, 'bold', 'middle', MUTED))
    width = 50 if lang == 'en' else 42
    y = legend_line(out, x0, y, words['size'], lang, size=14, width=width, step=18)
    samples = [
        (f'<line x1="{x0}" y1="{{y}}" x2="{x0 + 26}" y2="{{y}}" stroke="{FORWARD}" stroke-width="3.2" marker-end="url(#fwd)"/>', words['formal'].format(m=LABEL_MIN, k=f'{iface:,}' if lang == 'en' else iface, n=f'{formal:,}' if lang == 'en' else formal)),
        (f'<line x1="{x0}" y1="{{y}}" x2="{x0 + 26}" y2="{{y}}" stroke="{BACKWARD}" stroke-width="3.2" marker-end="url(#back)"/>', words['backward']),
        (f'<line x1="{x0}" y1="{{y}}" x2="{x0 + 26}" y2="{{y}}" stroke="{MUTED}" stroke-width="1.7" stroke-dasharray="6 4" marker-end="url(#thin)"/>', words['interpretive'].format(m=INTERPRETIVE_MIN)),
        (f'<line x1="{x0}" y1="{{y}}" x2="{x0 + 26}" y2="{{y}}" stroke="{MUTED}" stroke-width="1.7" stroke-dasharray="1.5 4" stroke-linecap="round" marker-end="url(#diamond)"/>', words['application']),
        (f'<line x1="{x0}" y1="{{y}}" x2="{x0 + 26}" y2="{{y}}" stroke="{FAINT}" stroke-opacity="0.45" stroke-width="{f(1 + SPOKE_MAX * 0.4)}" stroke-linecap="round"/>', words['spoke']),
        ('', words['related'].format(n=f'{related:,}' if lang == 'en' else related, m=DRAW_MIN, k=LABEL_MIN)),
    ]
    for mark, body in samples:
        if mark:
            out.append(mark.format(y=f(y - 5)))
        y = legend_line(out, x0, y, body, lang, size=14, width=width, step=18)
    height = int(max(y, left_bottom)) + 50
    for i, line in enumerate(wrap(words['footer'], 112 if lang == 'en' else 102, lang)):
        out.append(text(24, height - 30 + 16 * i, line, 13, fill=MUTED))
    out.append('</svg>')
    out[0] = out[0].replace(f'viewBox="0 0 {W} {H}" width="{W}" height="{H}"', f'viewBox="0 0 {W} {height}" width="{W}" height="{height}"')
    out = [o.replace(f'height="{H - 1}" rx="10"', f'height="{height - 1}" rx="10"') if o.startswith('<rect x="0.5"') else o for o in out]
    return '\n'.join(out) + '\n'


def central_rows():
    """(central rows, those resting on at least one shared law) from 08 §7's sentence the caption quotes."""
    found = re.search(r'Of the (\d+) central rows \(nine declarations stand in two\), (\d+) rest on at least one', method_section_7())
    return (int(found.group(1)), int(found.group(2))) if found else None


def laws_strip(out, s, lang, top, derived):
    """The five shared laws under the standings: per law, the central rows resting on it and, hatched, those reaching the
    grammar, from 08 §7's table and sentence; balance marked represented, not derived. Returns the strip's bottom."""
    laws, words = shared_laws_rows(), WORDS[lang]
    if not laws:
        return top
    width = 100 if lang == 'en' else 92
    rows, rested = central_rows() or (0, 0)
    heads = wrap(words['laws_head'], width, lang)
    notes = wrap(words['laws_note'].format(rested=rested, rows=rows, d=derived, h=boundary_counts().get('under a stated hypothesis', 0)),
                 112 if lang == 'en' else 104, lang)
    y = top + 21
    height = 20 * len(heads) + 76 + 16 * len(notes) + 8
    out.append(f'<rect x="20" y="{top}" width="{W - 40}" height="{height}" rx="6" fill="#f5f5f4" stroke="#e7e5e4"/>')
    for i, line in enumerate(heads):
        out.append(text(32, y + 20 * i, line, 15, 'bold', fill=INK))
    y += 20 * len(heads) + 4
    colw = (W - 64) / len(laws)
    scale = (colw - 24) / max(c for *_, c in laws)
    for j, (name, _, represented, c) in enumerate(laws):
        x = 32 + j * colw
        k = reaching_the_grammar(name, c) or 0
        out.append(text(x, y, name if lang == 'en' else s['laws_zh']['names'][name], 14, 'bold', fill=INK))
        # a bar of few rows is drawn at least BAR_MIN wide, so its hatch shows; the hatch stays its share of the drawn
        # bar, never reaching the end unless every row reaches, and the words beside give the counts
        bar = max(c * scale, BAR_MIN)
        out.append(f'<rect x="{f(x)}" y="{y + 7}" width="{f(bar)}" height="11" fill="#ffffff" stroke="{MUTED}" stroke-width="0.5"><title>{c}</title></rect>')
        if k:
            out.append(f'<rect x="{f(x)}" y="{y + 7}" width="{f(bar * k / c)}" height="11" fill="url(#reach)" stroke="{MUTED}" stroke-width="0.5"><title>{k}</title></rect>')
        out.append(text(x, y + 34, (words['law_all'] if k == c else words['law_some']).format(c=c, k=k), 13, fill=INK))
        if represented:
            out.append(text(x, y + 51, words['law_rep'], 13, fill=MUTED))
    y += 51 + 20
    for i, line in enumerate(notes):
        out.append(text(32, y + 16 * i, line, 13, fill=MUTED))
    return top + height


def boundary_counts():
    """The central declarations by class against the edge of one root, from the shared-laws data."""
    return json.loads(_read(registry.SHARED_LAWS) or '{}').get('boundary', {}).get('counts', {})


def examples_drawn(s):
    """The simpler picture's classes with an example: (those of several declarations, those of one, where the example is
    the class's only member)."""
    fv, n = s.get('first_view', {}), boundary_counts()
    shown = [item for item in fv.get('bands', []) + fv.get('distance', []) if item.get('example')]
    return sum(1 for i in shown if n.get(i['key'], 0) != 1), sum(1 for i in shown if n.get(i['key'], 0) == 1)


def standings_svg(s, lang):
    """The simpler picture: one square per central declaration, grouped by its standing against the edge of one root and,
    at a named distance, by its reason; one example per standing in its record's words."""
    fv, words, n = s['first_view'], s['first_view'][lang], boundary_counts()
    total = sum(n.values())
    rows = (central_rows() or (total, 0))[0]
    cov = len(json.loads(_read(COVERAGE) or '{}').get('rows', []))
    sub = words['subtitle'].format(n=total, rows=rows, cov=cov, derived=n.get('derived', 0), hyp=n.get('under a stated hypothesis', 0))
    per, pitch, size = 16, 15, 12
    tx = 24 + per * pitch + 22
    width = 78 if lang == 'en' else 74
    fills = dict(zip(('derived', 'under a stated hypothesis', 'counting'), STANDING_FILL))
    title = words['title'].format(n=total)
    out = [f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {H}" width="{W}" height="{H}" role="img" '
           f'aria-labelledby="standings-title standings-desc" font-family="{FONT[lang]}">',
           f'<title id="standings-title">{escape(title)}</title>',
           f'<desc id="standings-desc">{escape(sub)}</desc>',
           f'<rect x="0.5" y="0.5" width="{W - 1}" height="{H - 1}" rx="10" fill="{PAPER}" stroke="#d6d3d1"/>',
           text(24, 40, title, 22, 'bold')]
    y = 64
    for line in wrap(sub, 104 if lang == 'en' else 96, lang):
        out.append(text(24, y, line, 14, fill=MUTED))
        y += 18
    y += 18

    def squares(y0, count, fill):
        for i in range(count):
            out.append(f'<rect x="{24 + (i % per) * pitch}" y="{f(y0 + (i // per) * pitch)}" width="{size}" height="{size}" '
                       f'rx="1.5" fill="{fill}" stroke="{MUTED}" stroke-width="0.6"/>')
        return math.ceil(count / per) * pitch

    def block(y0, head, gloss, example, count):
        lines = [(l, 15, 'bold', INK) for l in wrap(head, width, lang)]
        lines += [(l, 14, 'normal', MUTED) for l in wrap(gloss, width + 4, lang)] if gloss else []
        if example:
            note = example.get('note')
            decl, words_of = example['declaration'], norm(example[lang][1]) + (
                (f" (the closure: {norm(note[lang][1])})" if lang == 'en' else f'（闭包指{norm(note[lang][1])}）') if note else '')
            lead = (f'{words["example_only" if count == 1 else "example"]} {decl}{words["in_law"] if example.get("in_law") else ""}'
                    f'{"：" if lang == "zh" else ": "}{words_of}')
            lines += [(l, 14, 'normal', INK) for l in wrap(lead, width + 4, lang)]
        yy = y0 + 11
        for body, sz, weight, fill in lines:
            out.append(text(tx, yy, body, sz, weight, fill=fill))
            yy += 18
        return yy - 11 - y0

    def label(count, b):
        return f'{count} {b["label"]}' if lang == 'en' else f'{count} 项{b["label"]}'

    for band in fv['bands']:
        c, b = n.get(band['key'], 0), band[lang]
        used = squares(y, c, fills[band['key']])
        gloss = norm(b.get('gloss', '')) + ((('；' if lang == 'zh' else '; ') + norm(band['gloss_also'][lang][1]) + words.get('review_label', ''))
                                            if band.get('gloss_also') else '')
        y += max(used, block(y, label(c, b), gloss, band.get('example'), c)) + 16
    rest = sum(n.get(d['key'], 0) for d in fv['distance'])
    out.append(f'<line x1="24" y1="{y - 6}" x2="{W - 24}" y2="{y - 6}" stroke="#e7e5e4"/>')
    y += 14
    out.append(text(24, y, words['distance'].format(n=rest), 16, 'bold'))
    y += 16
    for d in fv['distance']:
        c, b = n.get(d['key'], 0), d[lang]
        used = squares(y, c, STANDING_FILL[3])
        y += max(used, block(y, label(c, b), norm(b.get('gloss', '')), d.get('example'), c)) + 12
    y += 8
    based = edge_bases()[0]
    for paragraph in words['footer']:
        for line in wrap(paragraph.format(b=based, r=total - based), 112 if lang == 'en' else 102, lang):
            out.append(text(24, y, line, 13, fill=MUTED))
            y += 17
        y += 4
    height = int(y + 14)
    out.append('</svg>')
    out[0] = out[0].replace(f'viewBox="0 0 {W} {H}" width="{W}" height="{H}"', f'viewBox="0 0 {W} {height}" width="{W}" height="{height}"')
    out[3] = out[3].replace(f'height="{H - 1}"', f'height="{height - 1}"')
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


def description(results, pairs, s, lang, modules=None):
    order = s['order']
    rank = {k: i for i, k in enumerate(order)}
    backward = sum(c['formal-reuse'] for (a, b), c in pairs.items() if a != b and a in rank and b in rank and rank[a] < rank[b])
    laws = shared_laws_rows() or []
    strip = [(name, c, reaching_the_grammar(name, c) or 0, represented) for name, _, represented, c in laws]
    drawn = sum(1 for (a, b), c in pairs.items() if a != b and a in order and b in order and c['formal-reuse'] >= DRAW_MIN)
    total = sum(c['formal-reuse'] for (a, b), c in pairs.items() if a != b and a in order and b in order)
    modules = modules or {}
    n = boundary_counts()
    if lang == 'zh':
        sizes = '；'.join(s['chapters'][k]['zh'] + ' ' + str(results[k]) for k in order)
        spokes = '；'.join(f'{s["chapters"][k]["zh"]} {modules[k][0]} 个中 {modules[k][1]} 个' for k in order if k in modules)
        return (f'八章围绕文法排成一圈，按其结果数定大小（{sizes}）。'
                f'章与章之间共有 {total} 次记为 formal-reuse 的使用，画出 {drawn} 个至少 {DRAW_MIN} 次的配对；{total} 次中有 {backward} 次是逆向的，'
                f'即章序在前的一章的结果使用章序在后的一章的结果，其所在配对有 {DRAW_MIN} 次或以上时画得较深（章的编号是为阅读，不是证明的次序）。'
                + (f'每章到文法的辐条，示该章在文法上陈述其律的核心模块（{spokes}）。' if spokes else '')
                + (f'{sum(n.values())} 项核心声明相对于根之边的位置：{n.get("derived", 0)} 项推导而得，{n.get("under a stated hypothesis", 0)} 项在一个所述的假设之下，'
                   f'{n.get("counting", 0)} 项为计数，{sum(n.values()) - n.get("derived", 0) - n.get("under a stated hypothesis", 0) - n.get("counting", 0)} 项处于一个指明的距离。' if n else '')
                + '其下，五条共律各有依于它的核心行与其中达到文法者（'
                + '；'.join(f'{s["laws_zh"]["names"][nm]} {c} 行，{k} 行达到' + ('，平衡为表示，不推导' if rep_ else '') for nm, c, k, rep_ in strip)
                + '）。三个方框进入第七章，是排序结果在其定理取用之处所取的假设：以从己方式成立的延续条件（谁的损失算数，单凭自身不排序）、'
                '自我关切（即这样一种次序：一个进程扩大另一个时，只要多出的东西里有属于自身延续的，这一次序就把前者排在后者之上；这里把自身的延续读作自身所能到达的一切；'
                '在延续条件跨越所有步来读、以从己方式成立之处，它在一个有限列表上把每一个扩大都排在上面；生命是否会形成这种次序，尚未表明）与 C（Comparison，对次序的一项要求：'
                '在每一个主张都算作活之时，把一个进程排在它所扩大的每一个进程之上）。T1 到 T8 在其所属之处，按检验结局着色。')
    sizes = ', '.join(theory_graph.REGION_TITLES[k].split(':')[0] + ' ' + str(results[k]) for k in order)
    spokes = ', '.join(f'{theory_graph.REGION_TITLES[k].split(":")[0]} {modules[k][1]} of {modules[k][0]}' for k in order if k in modules)
    return (f'Eight chapters on a ring around the grammar, sized by their results ({sizes}); '
            f'{total} formal-reuse uses between chapters, {drawn} pairs with at least {DRAW_MIN} drawn, {backward} of the uses running backward, '
            f"an earlier chapter's results using a later one's, drawn darker where a pair has {DRAW_MIN} or more (the chapters are numbered for reading, not as an order of proof); "
            + (f"spokes to the grammar give each chapter's core modules that state their laws on it ({spokes}); " if spokes else '')
            + (f'the places of the {sum(n.values())} central declarations against the edge of one root ({n.get("derived", 0)} derived, '
               f'{n.get("under a stated hypothesis", 0)} under a stated hypothesis, {n.get("counting", 0)} counting, '
               f'{sum(n.values()) - n.get("derived", 0) - n.get("under a stated hypothesis", 0) - n.get("counting", 0)} at a named distance); ' if n else '')
            + 'under the places, the five shared laws with the central rows on each and those reaching the grammar ('
            + '; '.join(f'{nm} {c} rows, {k} reach' + (', represented, not derived' if rep_ else '') for nm, c, k, rep_ in strip)
            + '); three boxes come into chapter 7, what ranking results take as hypotheses where their theorems take them: the continuation condition '
            'held de se (whose losses count, ranking nothing), self-concern (an order ranking above what it widens every widening that adds to one\'s own '
            'continuation, read as what lies within one\'s reach, which where the condition holds de se, read across all steps, ranks every widening above '
            'on a finite listing; that a life forms it is not shown) and C (Comparison, a requirement on an '
            'order: with every claim counted as living, that it rank each course above every course it widens); '
            'T1 to T8 at their homes, coloured by test outcome.')


def interface_counts(graph):
    """Formal-reuse edges between records: (those carrying an interface the registry checks, all of them)."""
    edges = [e for e in graph['edges'] if e['type'] == 'formal-reuse']
    return sum(1 for e in edges if e.get('interface')), len(edges)


def formal_cycles(graph):
    """Over the recorded formal-reuse edges: (edges, results they touch, groups of results reaching one another)."""
    next_of, nodes, edges = {}, set(), 0
    for e in graph['edges']:
        if e['type'] == 'formal-reuse':
            edges += 1
            nodes |= {e['from'], e['to']}
            next_of.setdefault(e['from'], []).append(e['to'])
    index, low, on_stack, stack, groups, counter = {}, {}, set(), [], [], [0]
    for root in sorted(nodes):  # Tarjan's strongly connected components, without recursion
        if root in index:
            continue
        work = [(root, iter(next_of.get(root, ())))]
        index[root] = low[root] = counter[0]
        counter[0] += 1
        stack.append(root)
        on_stack.add(root)
        while work:
            v, it = work[-1]
            for w in it:
                if w not in index:
                    index[w] = low[w] = counter[0]
                    counter[0] += 1
                    stack.append(w)
                    on_stack.add(w)
                    work.append((w, iter(next_of.get(w, ()))))
                    break
                if w in on_stack:
                    low[v] = min(low[v], index[w])
            else:
                work.pop()
                if work:
                    low[work[-1][0]] = min(low[work[-1][0]], low[v])
                if low[v] == index[v]:
                    group = []
                    while True:
                        w = stack.pop()
                        on_stack.discard(w)
                        group.append(w)
                        if w == v:
                            break
                    if len(group) > 1 or v in next_of.get(v, ()):
                        groups.append(sorted(group))
    return edges, len(nodes), groups


METHOD = 'theories/becoming/chapters/08-METHOD.md'
COVERAGE = 'theories/becoming/results/completion/COVERAGE.json'
EDGE_RECORD = 'theories/becoming/results/records/one-root-to-its-edge'
GRAMMAR_LAWS = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarLaws.lean'
REVIEW_U4 = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u4-one-root-to-its-edge/REVIEW-U4-RECORD.md'
DESIGN_BOUNDARY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u4-one-root-to-its-edge/DESIGN-BOUNDARY.md'
CONNECTED_READING = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u4-one-root-to-its-edge/CONNECTED-ROWS-READING.md'
REVIEW_U4C = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u4-one-root-to-its-edge/REVIEW-U4C-RECORD.md'


def shared_laws_rows():
    """The shared laws from 08 §7's table, its words: (name, statement, represented and not derived?, declarations on it)."""
    rows, inside = [], False
    for line in (_read(METHOD) or '').split('\n'):
        if line.startswith('| Law | Statement |'):
            inside = True
        elif inside and not line.startswith('|---'):
            if not line.startswith('|'):
                break
            cells = [c.strip() for c in line.strip().strip('|').split(' | ')]
            rows.append((cells[0], cells[1], 'not derived' in cells[3], int(cells[4])))
    return rows


def method_section_7():
    """08 §7, from its anchor to the next chapter section: where the counts this page reads stand."""
    text = _read(METHOD) or ''
    start = text.find('<a id="shared-laws-and-connectivity"></a>')
    end = text.find('\n## ', text.find('\n## ', start) + 1)  # past its own heading, to the next
    return text[start:end] if start >= 0 else ''


def shared_laws_cells():
    """(law, its 'On the grammar' cell) from 08 §7's table, as written."""
    out, inside = [], False
    for line in (_read(METHOD) or '').split('\n'):
        if line.startswith('| Law | Statement |'):
            inside = True
        elif inside and not line.startswith('|---'):
            if not line.startswith('|'):
                break
            cells = [c.strip() for c in line.strip().strip('|').split(' | ')]
            out.append((cells[0], cells[3]))
    return out


def reaching_the_grammar(name, count):
    """How many of the central rows on a shared law reach the grammar, from 08 §7's sentence ("all 42 on closure", "16 of 54
    on balance"), or None where the sentence no longer says it for that count."""
    text, word = method_section_7(), name.lower()
    if f'all {count} on {word}' in text:
        return count
    found = re.search(rf'(\d+) of {count} on {word}', text)
    return int(found.group(1)) if found else None


def rows_reaching():
    """(rows reaching the grammar, those of them on no anchor) from 08 §7's sentence, or None."""
    text = method_section_7()
    whole, none = re.search(r'Of the 126 rows, (\d+) now reach the grammar', text), re.search(r'and (\d+) on no anchor', text)
    return (int(whole.group(1)), int(none.group(1))) if whole and none else None


def central_total():
    """The central declarations the shared-laws data places against the edge."""
    data = json.loads(_read(registry.SHARED_LAWS) or '{}')
    return sum(data.get('boundary', {}).get('groups', {}).values())


def edge_bases():
    """From the edge record's data: (declarations with a basis in words, those of them at a named distance)."""
    record = json.loads(_read(EDGE_RECORD + '.json') or '{}')
    with_basis = [s for s in record.get('boundary', {}).get('standings', []) if s.get('basis')]
    near = ('derived', 'under a stated hypothesis', 'counting')
    return len(with_basis), sum(1 for s in with_basis if s.get('standing') not in near)


def law_english(name):
    """A grammar law in English: the bold lead of its docstring in `Becoming.GrammarLaws`, else its first sentence, without
    the law's own name in brackets; the name itself where it has no docstring."""
    bare = name.removeprefix('Becoming.')
    found = re.search(r'/--((?:(?!-/).)*?)-/\s*(?:@\[[^\]]*\]\s*)?(?:theorem|lemma|def|abbrev) ' + re.escape(bare) + r'[\s{(:]',
                      _read(GRAMMAR_LAWS) or '', re.S)
    if not found:
        return bare
    doc = ' '.join(found.group(1).split())
    bold = re.match(r'\*\*(.+?)\*\*', doc)
    lead = bold.group(1) if bold else re.split(r'(?<=[.:])\s', doc, 1)[0]
    lead = re.sub(r'\s*\(' + re.escape(bare.strip('«»')) + r'\)', '', lead).rstrip('.:')
    return lead[:1].upper() + lead[1:]


def derived_rows():
    """The derived declarations from the edge record: (short name, its laws, the first sentence of its basis and any
    sentence on how its statement reads, records whose laws name it)."""
    record = json.loads(_read(EDGE_RECORD + '.json') or '{}')
    wanted = [s for s in record.get('boundary', {}).get('standings', []) if s.get('standing') == 'derived']
    stating = {s['declaration']: [] for s in wanted}
    folder = ROOT / Path(EDGE_RECORD).parent
    for path in sorted(folder.glob('*.json')):
        if path.stem in ('one-root-to-its-edge', 'shared-laws-on-the-grammar'):
            continue
        r = json.loads(path.read_text(encoding='utf-8'))
        if r.get('status') == 'superseded':
            continue
        laws = json.dumps(r.get('laws', []), ensure_ascii=False)
        for d in stating:
            if f'"{d}"' in laws:
                stating[d].append(r['id'])
    out = []
    for s in wanted:
        d = s['declaration']
        sentences = re.split(r'(?<=[.])\s+(?=[A-Z«`])', s['basis']['en'])
        first = sentences[0] + ''.join(' … ' + x for x in sentences[1:] if x.startswith('Its statement still reads'))
        out.append((d.removeprefix('Becoming.'), [x.removeprefix('Becoming.') for x in s.get('law', [])], first, stating[d]))
    return out


def shared_laws_section(s, rel, lang):
    """The five shared laws, in 08 §7's words and counts, read from its table at each render."""
    rows, caps = shared_laws_rows(), s['caption']
    total = sum(r[3] for r in rows)
    link = rel(METHOD, 'shared-laws-and-connectivity')
    rested = re.search(r'(\d+) rest on at least one', caps[6]['text']).group(1)
    reach, no_anchor = rows_reaching() or (0, 0)
    column = "every model's theorem in a row is proved from it, except balance's, which the grammar represents and does not derive"
    cells = {name: cell for name, cell in shared_laws_cells()}
    if lang == 'zh':
        names, words = s['laws_zh']['names'], s['laws_zh']['statements']
        out = ['### 五条共律', '<a id="the-five-shared-laws"></a>', '',
               f'共律陈述许多核心结果共有的一个机制，在持有它的最低一层只陈述一次（[08 §7]({link})）；这个名称不把任何一条律排在另一条之上。', '',
               '| 共律 | 它说什么（译文） | 在文法上（08 §7 英文原文） | 依于它的核心行 | 其中达到文法的 |', '|---|---|---|---:|---:|']
        out += [f'| {names[n]} | {words[n]} | {cells[n]} | {c} | {reaching_the_grammar(n, c)} |' for n, _, rep_only, c in rows]
        return out + ['', f'第三栏照录 08 §7 的原文：它指明该律在 `Becoming.GrammarLaws` 中的陈述以及锚如何读它；用 08 §7 的话说，“{column}”'
                          f'（表中一行里每个模型之律都由它证明，平衡除外，文法表示平衡而不推导它）。这些计数相加为 {total}，多于依于至少一条的 {rested} 行，'
                          f'因为一行可以依于多条：“{caps[6]["zh"]}”（[08 §7]({link})）。最后一栏是 08 §7 所计的、这些行中其编译后的类型或值达到文法的行数；'
                          f'126 行中有 {reach} 行达到文法，其中 {no_anchor} 行不依于任何锚，所以依于一条共律的有 {reach - no_anchor} 行；这一栏相加为 {sum(reaching_the_grammar(n, c) or 0 for n, _, _, c in rows)}，多于 {reach - no_anchor}，是因为一行可以依于多条律，{names["Finite runs"]}的各行也依于{names["Closure"]}。'
                          f'它说的是一行编译后的类型或值达到什么，不是说该行是这条律的一个情形：被读作文法之律之情形的，只有上面的十一项，'
                          f'另有一项 `GroupEnding.Flow.all_end` 在一个所述的假设之下被读作根形式 `RootForms.outside_leaves_no_offspring` 的一步。', '']
    out = ['### The five shared laws', '',
           f'A shared law states a mechanism many central results share, at the lowest layer that holds it ([08 §7]({link})); the name '
           f'ranks no law above another.', '',
           '| Law | What it says, in 08 §7\'s words | On the grammar, in 08 §7\'s words | Central rows resting on it | Of those, reaching the grammar |', '|---|---|---|---:|---:|']
    out += [f'| {n} | {w} | {cells[n]} | {c} | {reaching_the_grammar(n, c)} |' for n, w, rep_only, c in rows]
    return out + ['', f'The third column, in 08 §7\'s words, names the law\'s statement in `Becoming.GrammarLaws` and how the anchor reads it: "{column}". '
                      f'These counts add to {total}, more than the {rested} rows that rest on at least one, because a row can rest on several: "{caps[6]["text"]}" '
                      f'([08 §7]({link})). The last column is 08 §7\'s count of those rows whose compiled type or value reaches the grammar; of the 126 rows, '
                      f'{reach} reach it, {no_anchor} of them on no anchor, so {reach - no_anchor} on a shared law; the column adds to {sum(reaching_the_grammar(n, c) or 0 for n, _, _, c in rows)}, '
                      f'more than {reach - no_anchor}, because a row can rest on several laws, the finite-run rows on closure too. It says what a row\'s compiled type or value reaches, not that the row is a case of the law: only the eleven above are '
                      f'read as cases of grammar theorems, and one, `GroupEnding.Flow.all_end`, as the root form `RootForms.outside_leaves_no_offspring` at one step, under a stated hypothesis.', '']


def circular_paragraph(graph, lang):
    """Whether the recorded formal-reuse edges have a cycle, computed at each render and stated of those edges only."""
    edges, nodes, groups = formal_cycles(graph)
    if lang == 'zh':
        found = '没有哪项结果经由它们达到自身' if not groups else f'有 {len(groups)} 组结果彼此可达'
        return ['<a id="do-the-recorded-uses-form-a-cycle"></a>', '', f'**已记录的使用有环吗？** 在已记录的 {edges} 条 `formal-reuse` 边上，共 {nodes} 项结果，{found}（每次生成时计算）。登记检查拒绝会闭合其已声明依赖之环的记录，'
                f'所以这是入册的条件，不是关于这些结果的一项发现：它说的是记录所声明的，不是 Lean 证明或论证没有循环。']
    found = 'no result reaches itself' if not groups else f'{len(groups)} group{"s" if len(groups) != 1 else ""} of results reach one another'
    return ['<a id="do-the-recorded-uses-form-a-cycle"></a>', '', f'**Do the recorded uses form a cycle?** Among the {edges:,} recorded `formal-reuse` edges, over {nodes} results, {found} (computed at each render). '
            f'The registry refuses a record that would close a cycle among its declared dependencies, so this is a condition of entry, not a finding about the results: '
            f'it says what the records declare, not that the Lean proofs or the arguments are non-circular.']


def picture_key(s, lang, page='theories/becoming/ONE-PAGE.md'):
    """The short key under the picture on the one page and the overview. In English: what is drawn (the grammar at the
    centre, the chapters on a ring, the spokes, the theses T1-T8 by outcome), what a solid curve counts and who assigns
    its kind, and the four standings, with a link to what the picture shows and does not show; the picture's own lines
    say that the chapters are numbered for reading and that a spoke counts modules, and THEORY-GRAPH keeps the full
    paragraph (how_to_read) and the cycle (circular_paragraph). The Chinese key says the same. The numbers are 08 §7's
    phrases in spine.json, and a test holds the fronts to this."""
    n = {phrase_n: int(phrase_n) for phrase_n, *_ in s['standing']['counts']}
    gl = os.path.relpath('GLOSSARY.zh.md' if lang == 'zh' else 'GLOSSARY.md', Path(page).parent)
    tg = os.path.relpath(PAGE_ZH if lang == 'zh' else 'theories/becoming/results/THEORY-GRAPH.md', Path(page).parent)
    total, d, h, c, rest = n['117'], n['11'], n['1'], n['6'], n['99']
    if lang == 'zh':
        return (f'文法在中央，八章围绕它排成一圈，每个圆按其结果数定大小；辐条的粗细是该章核心模块中在文法上陈述其律者所占的比例。'
                f'实线计一章的结果使用另一章结果、由 AI 写成的记录归为 formal-reuse 的次数（没有任何检查核对一次使用是否见于 Lean），'
                f'章序在前的一章的结果使用章序在后的一章的结果时较深。T1 到 T8 位于其所属之处，按检验结局着色（T8 已论证，无检验）。'
                f'{total} 项核心声明中，{d} 项[推导而得]({gl}#derived)，{h} 项为一个根形式的一步情形、在一个所述的假设之下，{c} 项为计数之定理、位于文法以下，'
                f'{rest} 项处于一个[指明的距离]({gl}#named-distance)、各有其理由（[这幅图显示什么、不显示什么]({tg}#the-spine-what-it-shows-and-does-not-show)）。')
    return (f'The grammar is at the centre and the eight chapters on a ring around it, each circle sized by its results; a spoke\'s width '
            f'is the share of the chapter\'s core modules that state their theorems on the grammar. A solid curve counts one chapter\'s uses of '
            f'another\'s results that the AI-written records class as formal-reuse (nothing checks a use against the Lean), darker where an '
            f'earlier chapter\'s results use a later one\'s. T1 to T8 stand at their homes, coloured by how their tests came out (T8, argued, '
            f'has none). Of the {total} central declarations, {d} are [derived]({gl}#derived), {h} is a '
            f'root form at one step under a stated hypothesis, {c} are counting theorems, below the grammar, and {rest} stand at a '
            f'[named distance]({gl}#named-distance), each with its reason '
            f'([what the picture shows and does not show]({tg}#the-spine-what-it-shows-and-does-not-show)).')


def how_to_read(s, lang, page='theories/becoming/ONE-PAGE.md'):
    """The full paragraph on reading the picture, above it on THEORY-GRAPH in both languages: what its marks are, and the
    standings in plain words, the numbers from 08 §7's phrases in spine.json. The one page and the overview carry the
    short key (picture_key) under the picture instead, and a test holds them to that. That the chapters are numbered for
    reading, not as an order of proof, and that a spoke counts modules are the picture's own lines; the cycle is
    circular_paragraph's, on the same page."""
    n = {phrase_n: int(phrase_n) for phrase_n, *_ in s['standing']['counts']}
    wf = os.path.relpath(WORKFLOW, Path(page).parent)
    gl = os.path.relpath('GLOSSARY.zh.md' if lang == 'zh' else 'GLOSSARY.md', Path(page).parent)
    total, d, h, c, rest = n['117'], n['11'], n['1'], n['6'], n['99']
    share = (d + h) / total
    if lang == 'zh':
        about = '约十分之一' if 0.085 <= share <= 0.115 else f'{d + h} 项'
        return (f'每个圆是一章，按其结果数定大小，围绕中央的文法排成一圈；辐条的粗细标出比例、章旁的计数标出数目：该章核心模块中在文法上陈述其律者。'
                f'从一章到另一章的实线，计其结果使用另一章结果、记为 formal-reuse 的次数，[RESULT-WORKFLOW]({wf}) 把这一类留给已核验的推理，这里由 AI 写成的记录指定，'
                f'没有任何检查核对一次使用是否见于 Lean；章与章之间的虚线与点线是别种依赖，较深的曲线是章序在前的一章的结果使用章序在后的一章的结果，章的编号是为阅读。'
                f'{total} 项核心声明中，{about}被读作文法之律或根形式的情形：{d} 项[推导而得]({gl}#derived)，为文法之律的情形，{h} 项为一个根形式（root form）的一步情形，'
                f'在一个所述的假设之下；其余或为计数之定理，位于文法以下（{c} 项），或处于一个[指明的距离]({gl}#named-distance)，各有其指明的理由（{rest} 项）。')
    about = 'About a tenth' if 0.085 <= share <= 0.115 else f'{d + h}'
    return (f'Each circle is a chapter, sized by its results, on a ring around the grammar at the centre; a spoke\'s width gives the share, '
            f'and the count beside its chapter the number, of the chapter\'s core modules that state their theorems on the grammar. A solid curve '
            f'from one chapter to another counts the uses of the other\'s results recorded as formal-reuse, the kind [RESULT-WORKFLOW]({wf}) '
            f'keeps for verified inferences, here assigned by the AI-written records with no check against the Lean; dashed and dotted curves '
            f'between chapters are other dependences, and a darker curve is an earlier chapter\'s results using a later one\'s, the chapters '
            f'being numbered for reading. {about} of the {total} central declarations are read as cases of grammar theorems or of a root form: '
            f'{d} [derived]({gl}#derived), cases of grammar theorems, and {h}, a root form at one step, under a stated hypothesis; the rest are '
            f'counting theorems, below the grammar ({c}), or stand at a [named distance]({gl}#named-distance), each with its reason named ({rest}).')


def drawn_otherwise(between):
    """The pairs under DRAW_MIN formal-reuse uses that a curve of another kind still draws, and how (en, zh)."""
    kinds = []
    for v in between.values():
        if 0 < v['formal-reuse'] < DRAW_MIN:
            dashed, dotted = v['interpretive'] >= INTERPRETIVE_MIN, v['application'] >= 1
            if dashed or dotted:
                kinds.append('both' if dashed and dotted else 'dashed' if dashed else 'dotted')
    if not kinds:
        return 0, '', ''
    if set(kinds) == {'dotted'}:
        return len(kinds), 'a dotted application curve', '点线（应用）'
    if set(kinds) == {'dashed'}:
        return len(kinds), 'a dashed interpretive curve', '虚线（诠释）'
    return len(kinds), 'a dashed or dotted curve of another kind', '别种的虚线或点线'


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
    m07, m08 = 'theories/becoming/chapters/07-SIGNIFICANCE.md', 'theories/becoming/chapters/08-METHOD.md'
    lines = [f'Two pictures, the dynamics first: [the terrain]({rel(TERRAIN["page"])}) shows the dynamics of [the atlas]({rel(ATLAS_PAGE)}) '
             f'and the exits recorded between their families, drawn by `tools/research/atlas.py` from the atlas\'s entries alone, an '
             f'arrow a count of exits, not a route; the picture under [the chapters at a glance](#the-spine) shows the chapters and their recorded '
             f'uses of one another.', '',
             f'![The terrain: the eight families of the atlas\'s dynamics and the recorded exits between them, drawn from the entries '
             f'alone; an arrow is a count of exits, not a route.]({rel(TERRAIN["svg"])})', '',
             '<a id="the-spine"></a>', '', '## The chapters at a glance', '',
             f'**How to read it.** {how_to_read(s, "en", page_path)} Of the {total:,} uses between chapters, '
             f'{sum(into[k] for k in top):,} go into {name[top[0]].lower()} and {name[top[1]].lower()}, and {backward:,} run backward. '
             f'Under the places, a strip gives the five shared laws: the central rows resting on each and, hatched, those whose compiled '
             f'type or value reaches the grammar ([their table](#the-five-shared-laws)). The three boxes are what ranking results take as hypotheses, each where its theorem takes it, '
             f'drawn as hypotheses and not as premises of the ethics: the continuation condition held de se, which says whose losses count and ranks nothing; '
             f'self-concern, a property of an order over courses; and C (`Comparison`), a requirement on an order. No law in the account evaluates: there is '
             f'no should beyond becoming and no good and evil set over it; right and wrong form within it, in people and AI, and its ethics emerges from '
             f'continuation, from a life going on through what sustains it ([07 §4]({rel(m07, "scope-and-order")}) says how, how far that has been seen, '
             f'and what is open); what is offered, for life, 生生, AI within it, is counting the losses that never come back to whoever causes them, with a '
             f'way of seeing what each course draws on, what it opens and closes, and who bears it ([T8]({rel(m07, "t8")})). The badges T1 to T8 are the '
             f'theses at the chapters that state them, coloured by how their frozen tests came out, each in its row\'s words in the table below.', '',
             f'![The eight chapters and their recorded uses of one another: circles sized by their results, solid curves counting formal-reuse uses '
             f'between chapters\' results and dashed and dotted ones other dependences, the five shared laws under the places, the continuation '
             f'condition, self-concern and C coming into chapter 7 as hypotheses, and T1 to T8 at their homes coloured by test outcome]({rel(SVG["en"])})', '',
             f'*Generated by `tools/research/spine.py` from this graph and [spine.json]({rel(DATA)}); '
             f'[the Chinese of these sections]({rel(PAGE_ZH)}), with [its picture]({rel(SVG["zh"])}).*', '']
    if st:
        lines += [f'**The places of the central declarations** ([08 §7]({rel(m08, "r-one-root-to-its-edge")})), which the '
                  f'picture\'s top line gives and the simpler picture below draws one square each:', '',
                  '| Place against the edge of one root | Declarations | In 08 §7\'s words |', '|---|---:|---|']
        for label, n in (('derived', '11'), ('under a stated hypothesis', '1'), ('counting, below the grammar', '6'),
                         ('at a named distance', '99')):
            lines.append(f'| {label} | {n} | "{counts_by.get(n, "")}" |')
        with_basis, at_distance = edge_bases()
        total_decl = central_total()
        lines += [f'| all central declarations | 117 | "{counts_by.get("117", "")}" |', '',
                  f'Each declaration and its place is in [the edge record]({rel(EDGE_RECORD + ".md")}): {with_basis} have a basis in words, in '
                  f'[its data]({rel(EDGE_RECORD + ".json")}) (`boundary.standings`), and the other {total_decl - with_basis} the label a rule gives. The page of each '
                  f'record whose laws name a declaration prints its place: for a derived row its laws, bridges and support, for the row under a '
                  f'stated hypothesis its form, hypotheses and countermodels, for a reading its basis, and otherwise the rule\'s reason. Each of the 99 has its named reason: its class, and for {at_distance} a '
                  f'basis in words. A declaration is the Lean statement a row of the coverage file names; the plain words of a result are at its record.', '',
                  f'![The {total_decl} central declarations, one square each, by their place against the edge of one root: derived, under a stated '
                  f'hypothesis, counting and, by reason, at a named distance, with an example for {examples_drawn(s)[0]} of the classes' + (' and the single declaration of the class of one' if examples_drawn(s)[1] else '') + f', in its record\'s words, the derived one with the glossary\'s note on its closure]({rel(FIRST["en"])})', '',
                  f'*Generated by `tools/research/spine.py` from [the shared-laws data]({rel(registry.SHARED_LAWS)}) and [spine.json]({rel(DATA)}); '
                  f'[in Chinese]({rel(FIRST["zh"])}).*', '',
                  f'**The eleven derived**, each read as a case of grammar theorems by an AI-written review ([of the record]({rel(REVIEW_U4)}), [of `Listed.coming_of_ceasing`\'s row]({rel(REVIEW_U4C)})); '
                  f'every recorded review so far is by AI ([08]({rel(m08, "review-status")})). Eight of them, all but the last three rows below, are, in 08 §7\'s words, "the eight connected rows that the '
                  f'reading of connected rows took as derived": a row that reaches the grammar, without balance in its statement, is connected by the rule '
                  f'([DESIGN-BOUNDARY]({rel(DESIGN_BOUNDARY)}) §2, rules 1 and 2), and [the reading of connected rows]({rel(CONNECTED_READING)}), also AI-written, '
                  f'marks the cases. Each «…» is a law stated in '
                  f'[`Becoming.GrammarLaws`]({rel(GRAMMAR_LAWS)}); the second column gives it in English by the first words of its Lean docstring.', '',
                  '| Declaration | A case of (the law\'s docstring, its first words) | First sentence of the record\'s basis (the last row also its place) | Named in the laws of |', '|---|---|---|---|']
        for decl, laws, first, stating in derived_rows():
            lines.append(f'| `{decl}` | {"; ".join(f"{law_english(x)} (`{x}`)" for x in laws)} | {first} | '
                         + ', '.join(f'[{x}]({rel(str(Path(EDGE_RECORD).parent) + "/" + x + ".md")})' for x in stating) + ' |')
        lines += ['', *shared_laws_section(s, rel, 'en'), *circular_paragraph(graph, 'en'), '']
    lines += [f'**The theses in the picture** ([08 §9]({rel(m08, "theses")})): words chosen from each row, saying first how far it has been seen; '
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
    other_kind, other_en, _ = drawn_otherwise(between)
    interp_small = [v['interpretive'] for v in between.values() if 0 < v['interpretive'] < INTERPRETIVE_MIN]
    related = sum(v['related'] for v in pairs.values())
    outside = sum(sum(v.values()) for k, v in pairs.items() if k[0] not in order or k[1] not in order)
    biggest = max(back, key=lambda k: between[k]['formal-reuse']) if back else None
    name = {k: theory_graph.REGION_TITLES[k].split(':')[0] for k in theory_graph.REGION_TITLES}
    cap = s['caption']
    others = sorted({k for pair in pairs for k in pair if k not in order}, key=lambda k: list(theory_graph.REGION_ORDER).index(k)
                    if k in theory_graph.REGION_ORDER else 99)
    method = rel('theories/becoming/chapters/08-METHOD.md', 'theses')
    iface, formal = interface_counts(graph)
    lines = ['', '<a id="the-spine-what-it-shows-and-does-not-show"></a>', '', '## What the picture shows and does not show', '',
             f'**What it shows.** Each circle is a chapter\'s region, its area proportional to the results the region '
             f'holds; the centre is the grammar ({concepts} concepts). A solid curve from one chapter to another counts uses of '
             f'the second\'s results by the first\'s under `formal-reuse`, which [RESULT-WORKFLOW]({rel(WORKFLOW)}) keeps '
             f'for "a verified inference using the cited result": the records, made with AI ("Made with AI, proofs included", [the one page]({rel("theories/becoming/ONE-PAGE.md")})), assign the kind, the registry checks that an interface has its fields '
             f'and cites a file among the record\'s hashed references (on {iface:,} of all {formal:,} such edges; each cites a Lean file), and nothing checks that the Lean there uses the cited result. Darker curves are an earlier chapter\'s results using a '
             f'later one\'s: {len(back)} of the {len(drawn)} pairs drawn'
             + (f', the largest {name[biggest[0]].lower()} to {name[biggest[1]].lower()} with '
                f'{between[biggest]["formal-reuse"]}' if biggest else '') + '. '
             f'Dashed curves between chapters are `interpretive`, kept for "an argument dependency", and dotted ones `application`; `related`, '
             f'which RESULT-WORKFLOW keeps for analogy, is not drawn ({related:,} edges). Not drawn as formal-reuse curves: '
             f'{plural(len(small), "pair")} with fewer than {DRAW_MIN} formal-reuse uses ({sum(small)} uses)'
             + (f', {other_kind} of them drawn as {other_en}' if other_kind else '') + '; '
             f'not drawn as dashed curves: {plural(len(interp_small), "interpretive pair")} with fewer than '
             f'{INTERPRETIVE_MIN} ({sum(interp_small)} edges); and the counts of curves under {LABEL_MIN} uses are not '
             f'written. The list under "Edge kinds between chapters" has every pair with an edge. Beside a circle, "within" counts formal-reuse between results of '
             f'the same chapter; interpretive edges within a chapter are on the diagonal of the interpretive table. A spoke\'s width, and the "k of m '
             f'modules on the grammar" beside its chapter, count the region\'s core modules that state their theorems on the grammar, as the region lists below '
             f'say. '
             + (f'Results in {", ".join(name.get(k, k) for k in others)} ({outside} edges touch them) are in that list only. '
                if outside else '')
             + f'The continuation condition, self-concern and C come into chapter 7 as hypotheses where a ranking result takes them: "{cap[4]["text"]}" '
             f'([07]({rel(cap[4]["home"])})). T1 to T8 stand at their homes, coloured by test outcome; their words, chosen '
             f'from their rows in [08 §9]({method}), saying first how far each has been seen, are in the theses table above.', '',
             f'**What it does not show.** An edge records a dependence, a citation or a registered reading, not an '
             f'agreement in meaning, as this page begins. Nor does a curve say how far a chapter\'s results reach the '
             f'grammar, which 08 §7 counts two ways. "{cap[0]["text"]}"; "{cap[1]["text"]}"; "{cap[2]["text"]}" '
             f'([08 §7]({rel(cap[0]["home"], cap[0]["anchor"])})). And "{cap[5]["text"]}"; "{cap[3]["text"]}" '
             f'([08 §7]({rel(cap[3]["home"], cap[3]["anchor"])})). Reaching the grammar is that dependence of a '
             f'declaration\'s compiled type or value; being derived is a place, a declaration read as a case of grammar '
             f'laws through bridges checked in Lean as equivalences and support the review reads where a row has them. So 45 and 11 count '
             f'different things, and the curves draw neither. Nor does a spoke: it counts modules that state their laws '
             f'on the grammar, not results that reach it.', '',
             '## Edge kinds between chapters', '',
             'Edges from the results of the first region to the results of the second, by the kind each record gives its '
             'dependence (`formal-reuse`, `interpretive`, `application`) and its `related` list (analogy, not a '
             'dependence). A row whose two regions are the same counts edges within the region.', '',
             'First, one table per kind among the eight chapters: a row is the chapter whose results use (for related, list) the '
             'column\'s, a column the chapter whose results are used (listed), the diagonal within a chapter, and a dot none.', '',
             *edge_matrices(pairs, s, 'en'),
             'Then every pair with an edge' + (f', {", ".join(name.get(k, k) for k in others)} included' if others else '') + ':', '',
             '| Edges from results of | to results of | formal-reuse | interpretive | application | related |',
             '|---|---|---:|---:|---:|---:|']
    full = list(theory_graph.REGION_ORDER)
    for (a, b), c in sorted(pairs.items(), key=lambda kv: (full.index(kv[0][0]) if kv[0][0] in full else 99,
                                                              full.index(kv[0][1]) if kv[0][1] in full else 99)):
        if any(c.values()):
            lines.append(f'| {name.get(a, a)} | {name.get(b, b)} | {c["formal-reuse"]} | {c["interpretive"]} | '
                         f'{c["application"]} | {c["related"]} |')
    return lines


def edge_matrices(pairs, s, lang):
    """One 8 by 8 table per edge kind, rows the citing chapter and columns the cited one, the diagonal within a chapter;
    a dot where there is none. The list under them gives every pair, the regions beyond the eight chapters included."""
    order = s['order']
    num = {k: s['chapters'][k]['file'][:2] for k in order}
    short = {k: (theory_graph.REGION_TITLES[k].split(':')[0].removeprefix('The ').capitalize() if lang == 'en' else s['chapters'][k]['zh']) for k in order}
    out = []
    for kind in KINDS:
        head = (f'**{kind}**' + (' (analogy, not a dependence)' if kind == 'related' and lang == 'en' else
                                 '（类比，不是依赖）' if kind == 'related' else ''))
        out += [head, '', ('| from \\ to | ' if lang == 'en' else '| 从 \\ 到 | ') + ' | '.join(num[k] for k in order) + ' |',
                '|---|' + '---:|' * len(order)]
        for a in order:
            cells = [str(pairs.get((a, b), {}).get(kind, 0) or '·') for b in order]
            out.append(f'| {num[a]} {short[a]} | ' + ' | '.join(cells) + ' |')
        out.append('')
    return out


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
    other_kind, _, other_zh = drawn_otherwise(between)
    interp_small = [v['interpretive'] for v in between.values() if 0 < v['interpretive'] < INTERPRETIVE_MIN]
    related = sum(v['related'] for v in pairs.values())
    outside = sum(sum(v.values()) for k, v in pairs.items() if k[0] not in order or k[1] not in order)
    others = sorted({k for pair in pairs for k in pair if k not in order})
    cap = s['caption']
    st = s['standing']
    m07, m08 = 'theories/becoming/chapters/07-SIGNIFICANCE.md', 'theories/becoming/chapters/08-METHOD.md'
    iface, formal_edges = interface_counts(graph)
    body = ['## 各章一览', '<a id="the-spine"></a>', '',
            f'**怎样读它。** {how_to_read(s, "zh", PAGE_ZH)}章与章之间共 {total} 次使用，其中 {into[top[0]] + into[top[1]]} 次进入'
            f'「{zname(top[0])}」与「{zname(top[1])}」两章，{backward} 次是逆向的。图顶端说核心声明位置的那一行之下，条带给出五条共律：依于每一条的核心行，'
            f'斜线部分是其编译后的类型或值达到文法的行（[其表](#the-five-shared-laws)）。三个方框是排序结果所取的假设，各在其定理取用之处写明，画作假设，不画作伦理的前提：以从己方式成立的延续条件，说的是谁的损失算数，单凭自身不排序；'
            f'自我关切，随自身延续而递增的次序；C（`Comparison`），对次序的一项要求。本论中没有一条律作评价：生灭变化之外没有应当，也没有凌驾其上的善与恶；'
            f'是非在其中形成，形成于人与 AI 之中；伦理从延续中生出：生命依靠维持它的东西而延续（怎样生出、看到了多远、还有什么未解，见 '
            f'[07 §4]({rel(m07, "scope-and-order")})）；为生命、为生生（生命之延续，AI 也在其中）所提出的，是把那些永远不会回到造成者身上的损失也算进来，'
            f'并以一种看法，看每一个进程取用什么、打开什么又关上什么、由谁承担（[T8]({rel(m07, "t8")})）。'
            f'徽标 T1 到 T8 是各论题，位于陈述它们的那一章，按其冻结检验的结局着色，下表以各自所在行的话给出它们。', '',
            f'![八章及各章彼此之间有记录的使用：圆按结果数定大小，实线计各章结果之间记为 formal-reuse 的使用，章与章之间的虚线与点线是别种依赖，核心声明的位置之下是五条共律，延续条件、自我关切与 C 作为假设进入第七章，T1 到 T8 '
            f'在其所属之处按检验结局着色]({rel(SVG["zh"])})', '',
            f'*由 `tools/research/spine.py` 依理论图与 [spine.json]({rel(DATA)}) 画出，图中文字为 AI 所译；[英文图]({rel(SVG["en"])})。*', '',
            f'**核心声明相对于根之边的位置**（[08 §7]({rel(m08, "r-one-root-to-its-edge")})），即图顶端那一行，下面较简的图每项画一个方块：', '',
            '| 相对于根之边的位置 | 声明数 | 08 §7 的话（译文） |', '|---|---:|---|']
    for label, n in (('推导而得', '11'), ('在一个所述的假设之下', '1'), ('计数，位于文法以下', '6'), ('处于一个指明的距离', '99')):
        body.append(f'| {label} | {n} | “{st["counts_zh"][n]}” |')
    body += [f'| 全部核心声明 | 117 | “{st["counts_zh"]["117"]}” |', '',
             f'每项声明及其位置，见[根之边的记录]({rel(EDGE_RECORD + ".md")})（英文）：{edge_bases()[0]} 项有文字的依据，在[其数据]({rel(EDGE_RECORD + ".json")})（`boundary.standings`）中，'
             f'其余 {central_total() - edge_bases()[0]} 项是规则所给的标签。凡其律中列有某项声明的记录，其页面印出该声明的位置：推导而得者印出其律、桥接与支持，在一个所述的假设之下的那一行印出其形式、假设与反模型，读法印出其依据，其余印出规则的理由。99 项中每一项都有其指明的理由：其类别，其中 {edge_bases()[1]} 项另有文字的依据。'
             f'一项[核心声明]({rel("GLOSSARY.zh.md")}#核心声明)是覆盖文件的某一行所指明的 Lean 陈述；一项结果的平实说法在其记录中。', '',
             f'![{central_total()} 项核心声明，每项一个方块，按其相对于根之边的位置排列：推导而得、在一个所述的假设之下、计数，以及按理由分列的处于一个指明的距离者，其中 {examples_drawn(s)[0]} 类各附一例' + ('，单独一项的那一类写出该项' if examples_drawn(s)[1] else '') + f'，皆用其记录的话，推导而得的一例附词汇表对其闭包的说明]({rel(FIRST["zh"])})', '',
             f'*由 `tools/research/spine.py` 依[共律数据]({rel(registry.SHARED_LAWS)})与 [spine.json]({rel(DATA)}) 画出，图中文字为 AI 所译；[英文图]({rel(FIRST["en"])})。*', '',
             f'**十一项推导而得者**，各由一次 AI 写成的审阅读作文法之律的一个情形（[对该记录的审阅]({rel(REVIEW_U4)})，[对 `Listed.coming_of_ceasing` 一行的审阅]({rel(REVIEW_U4C)})）；'
             f'迄今有记录的审阅都出自 AI（[08]({rel(m08, "review-status")})）。其中八项（除表中最后三行外），用 08 §7 的话说，是“the eight connected rows that the reading of connected rows took as derived”'
             f'（对连接行的读法取为推导而得的八个连接行）：一行达到文法、且其陈述中没有平衡，按规则即为连接行（[DESIGN-BOUNDARY]({rel(DESIGN_BOUNDARY)}) §2，规则 1 与 2），'
             f'[对连接行的读法]({rel(CONNECTED_READING)})（也是 AI 写成的）标出其中的情形。每个 «…» 都是 [`Becoming.GrammarLaws`]({rel(GRAMMAR_LAWS)}) 中陈述的一条律；第二栏在律名后引其 Lean 文档字符串的开头（英文原文），一如英文版。', '',
             '| 声明 | 所属情形（律名；其文档字符串的开头，英文原文） | 记录依据的第一句（末行另引说其位置的一句；英文原文） | 其律中列有它的结果 |', '|---|---|---|---|',
             *[f'| `{decl}` | {"；".join(f"`{x}`（{law_english(x)}）" for x in laws)} | {first} | '
               + '、'.join(f'[{x}]({rel(str(Path(EDGE_RECORD).parent) + "/" + x + ".md")})' for x in stating) + ' |'
               for decl, laws, first, stating in derived_rows()],
             '', *shared_laws_section(s, rel, 'zh'), *circular_paragraph(graph, 'zh'), '',
             f'**图中的论题**（[08 §9]({rel(m08, "theses")})）：选自[总览]({rel(s["theses_homes"]["zh"])})论题表中各自所在行的话，'
             f'先说各自看到了多远，其余见该行；08 §9 各行的完整表述见英文。', '',
             '| 论题 | 所在 | 图中颜色 | 其行的话 |', '|---|---|---|---|']
    for th in s['theses']:
        home = s['chapters'][th['home']]['file']
        body.append(f'| {th["id"]}. {th["zh"]["title"]} | [{home[:2]}]({rel("theories/becoming/chapters/" + home, th.get("anchor", ""))}) | '
                    f'{s["outcomes"][th["outcome"]]["zh"]} | {"；".join(th["zh"]["words"])} |')
    body += ['', '### 这幅图显示什么、不显示什么', '<a id="the-spine-what-it-shows-and-does-not-show"></a>', '',
             f'**它显示什么。** 每个圆是一章的区域，面积与该区域所含结果数成正比；中央是文法（{concepts} 个概念）。从甲章到乙章的'
             f'实线，计甲章的结果在 `formal-reuse` 之下使用乙章结果的次数，[RESULT-WORKFLOW]({rel(WORKFLOW)}) 把这一类留给'
             f'“使用所引结果的已核验推理”：这一类由借助 AI 做成的记录指定（[一页](../ONE-PAGE.zh.md)说本论“借助 AI 做成，证明也在内”）；登记检查核对接口具备其字段、且其所引是记录中带散列的参考文献之一（全部 {formal_edges} 条这样的边中有 {iface} 条，所引的都是 Lean 文件）；没有任何检查核对那里的 Lean 是否确实使用所引的结果。较深的曲线是章序在前的一章的结果使用章序在后的一章的结果：所画 {len(drawn)} 个配对中有 {len(back)} 个'
             + (f'，最大的是「{zname(biggest[0])}」到「{zname(biggest[1])}」，{formal[biggest]} 次' if biggest else '') + '。'
             f'章与章之间的虚线是 `interpretive`，留给“论证上的依赖”；点线是 `application`；`related` 是 RESULT-WORKFLOW 留给类比的，不画出'
             f'（{related} 条边）。不画作 formal-reuse 曲线的：少于 {DRAW_MIN} 次 formal-reuse 使用的 {len(small)} 个配对（共 '
             f'{sum(small)} 次）' + (f'，其中 {other_kind} 个画作{other_zh}' if other_kind else '') + f'；不画作虚线的：少于 '
             f'{INTERPRETIVE_MIN} 次的 {len(interp_small)} 个诠释配对（{sum(interp_small)} 条边）；少于 {LABEL_MIN} 次的曲线不标数字。“各章之间边的种类”末尾的配对列表列出'
             f'有边的每一个配对。圆旁的“章内使用”计同一章结果之间的 formal-reuse，章内的诠释边见 interpretive 表的对角线。章旁的“m 个模块中 k 个在文法上”与辐条的粗细，'
             f'计该区域核心模块中在文法上陈述其律的那些，如[英文版](THEORY-GRAPH.md)各区域的列表所示。'
             + (f'{"、".join("「" + zname(k) + "」" for k in others)}的结果（{outside} 条边涉及它们）只在那份列表中。' if outside else '')
             + f'延续条件、自我关切与 C 在排序结果取用它们之处作为假设进入第七章：“{cap[4]["zh"]}”（[07]({rel(cap[4]["home"])})）。T1 到 T8 位于其所属之处，按检验'
             f'结局着色；它们的话选自[总览]({rel(s["theses_homes"]["zh"])})论题表中各自所在的行，先说各自看到了多远，见上面的论题表。', '',
             f'**它不显示什么。** 一条边记录的是一种依赖、一次引用或一个已登记的读法，不是意义上的一致。曲线也不说一章的结果在多大'
             f'程度上达到文法，08 §7 以两种方式计这一点。“{cap[0]["zh"]}”；“{cap[1]["zh"]}”；“{cap[2]["zh"]}”'
             f'（[08 §7]({rel(cap[0]["home"], cap[0]["anchor"])})）。又，“{cap[5]["zh"]}”；“{cap[3]["zh"]}”'
             f'（[08 §7]({rel(cap[3]["home"], cap[3]["anchor"])})）。达到文法，是一项声明编译后的类型或值的那种依赖；推导而得是'
             f'根之边上的一种位置，即一项声明被读作文法之律的一个情形，经由在 Lean 中作为等价核验的桥接与审阅所读的支持（某行载有它们之处）。'
             f'所以 45 与 11 计的是不同的东西，而曲线两者都不画。辐条也不画：它计的是在文法上陈述其律的模块，不是达到文法的结果。', '',
             '### 各章之间边的种类', '<a id="edge-kinds-between-chapters"></a>', '',
             '从第一个区域的结果到第二个区域的结果的边，按各记录给其依赖的种类（`formal-reuse`、`interpretive`、`application`）'
             '与其 `related` 列表（类比，不是依赖）计。两个区域相同的一行，计该区域之内的边。区域以其所在章在总览中的标题称之；'
             '英文区域名见[英文版](THEORY-GRAPH.md#the-regions)。', '',
             '先是八章之间每一种边各一张表：行是使用（related：列出）者结果所在的章，列是被使用（被列出）者结果所在的章，对角线是一章之内，圆点表示没有。', '',
             *edge_matrices(pairs, s, 'zh'),
             '再是有边的每一对区域' + (f'，{"、".join("「" + zname(k) + "」" for k in others)}也在内' if others else '') + '：', '',
             '| 从此区域的结果 | 到此区域的结果 | formal-reuse | interpretive | application | related |',
             '|---|---|---:|---:|---:|---:|']
    full = list(theory_graph.REGION_ORDER)
    for (a, b), c in sorted(pairs.items(), key=lambda kv: (full.index(kv[0][0]) if kv[0][0] in full else 99,
                                                              full.index(kv[0][1]) if kv[0][1] in full else 99)):
        if any(c.values()):
            body.append(f'| {zname(a)} | {zname(b)} | {c["formal-reuse"]} | {c["interpretive"]} | {c["application"]} | {c["related"]} |')
    head = ['<!-- Generated by tools/research/research.py render (tools/research/spine.py) from the theory graph and '
            'theories/becoming/results/data/spine.json; edit those, not this page. -->', '',
            '# 理论图：各章一览', '', zh_fronts.nav_line(PAGE_ZH), '', '{time}', '',
            f'本页是[理论图](THEORY-GRAPH.md)中“各章一览”的中文版：这幅图、怎样读它、核心声明的位置、五条共律与论题、它显示什么与不显示什么，'
            f'以及各章之间边的种类表；各区域的结果、模块与文本的列表只在英文版中。本页由 AI 翻译；引自英文文本的话，除标明为英文原文者外，都是译文，未经核对，以英文原文为准。', '']
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
    try:
        pages = {SVG[lang]: svg(graph, s, lang) for lang in ('en', 'zh')}
        pages.update({FIRST[lang]: standings_svg(s, lang) for lang in ('en', 'zh')})
    except ValueError as error:  # a count that would read as another curve's: stop the render, naming it
        return {}, [str(error)]
    pages[PAGE_ZH] = zh_page(graph)
    return pages, []
