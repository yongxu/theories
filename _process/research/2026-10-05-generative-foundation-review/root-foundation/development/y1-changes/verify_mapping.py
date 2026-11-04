#!/usr/bin/env python3
"""Check the mapping of the 周易 and the 易传 onto the spine (Y1, Y2, Y3, Y4, Y5). usage, from anywhere:
  python3 -B verify_mapping.py [--receipt PATH] [--chapter PATH]   # check, exit 1 on any failure
  python3 -B verify_mapping.py --table                             # print the chapter's passage table

Checks, each against the repository's own files:
  1. every preserved page in sources/zhouyi-yizhuan/ has the bytes and the wikitext its
     PROVENANCE.json binds by SHA-256;
  2. every fragment of passages.json occurs verbatim in the wikitext of its page, read with
     Wikisource's markup removed (character-variant markup -{…}-, links, templates, tags);
  3. every declaration a passage names is in the audited declaration list of a core receipt
     (default: the newest under becoming-checks/); names of Becoming.Hexagrams,
     Becoming.HexagramPlaces, Becoming.HexagramLaws, Becoming.HexagramSites and Becoming.HexagramSequences not
     yet in that receipt are checked against the modules' source and reported as such;
  4. the received order of Hexagrams.lean is the order of the preserved pages: page n is the
     n-th hexagram (第n卦), follows page n-1 by its link, and its trigram line (X下Y上) gives
     the six lines of the n-th entry of `order`;
  5. the names the chapter gives to configurations are right: `rising k` and `falling k` are
     the lines of 坤 復 臨 泰 大壯 夬 乾 and 乾 姤 遯 否 觀 剝 坤, `sui` is 隨, and the law of
     waxing and waning carries 隨 → 中孚 → 蠱 → 小過 → 隨 and 乾 → 姤 → … → 坤 → 復 → … → 乾;
  6. the chapter's passage table, between its two markers, is the table printed by --table. The table lives only in
     the chapter of this map, which RA moved to history/ on 23 October 2026 and which 06-CLASSICAL-TEXTS's section
     五 links to; it is read there, frozen, so a failure here says the data has moved from the table the chapter
     shows (a missing chapter is a failure too);
  7. each configuration HexagramPlaces.lean, HexagramSites.lean or HexagramSequences.lean names by its number
     (`def jiJi : Hexagram := number 63`) carries in its doc comment the name of that page of the
     received order;
  8. four censuses of the text match the lists of HexagramPlaces.lean: every 小象 line that states
     a place explicitly (位不當, 不當位, 未當位, 未得位; 位正當, 位當, 當位, 得位) is in
     `placeStatements` with what it says, every one that says 中正 or 正中 is in
     `centreStatements`, every one that says 乘剛 is in `fallStatements` at the seam below its
     line, and every 彖 that says 剛中而應 is in `middleOppositionStatements`, but for the
     exceptions named in EXCEPTIONS, each stated by its own theorem; the relation of each entry is
     also recomputed here from the pages' trigram lines, as a cross-check of the lists;
  9. the censuses of HexagramSites.lean (王弼's readings, Y4), each recomputed from the pages:
     under the second relation (初上無位: no place at the bottom and the top) every 小象 statement of
     place holds with no exception, and no 小象 or 彖 statement of place is of the bottom or the top
     but 需上六's, while 乾上九's 「貴而无位」 stands in the 文言 and the 繫辭上 (`topStatements`);
     every 彖 clause of place (當位, 位當, 得位, 正位, 位正當; 位不當, 不當位, 未當位, 未得位, 失位)
     is in `tuanPlaceStatements` (of one line) or `tuanWholeStatements` (of the whole); every 彖
     that says 上下應 is in `answeredStatements`, with a sole line at the listed place; every line
     text (爻辭) that says 中 is in `lineTextMiddle` (中行 in `middleCourseLines`) and every one
     that says 位 in `lineTextPlace`; every 大象 that says 中, the configuration's own name left
     out, sets the lower trigram's image within the upper one's (DAXIANG_WITHIN), and every 大象
     that says 位 is of the 君子 (DAXIANG_PLACE); every 小象 line that says 中 is at a middle place
     but the four of XIAOXIANG_MIDDLE_OTHER, each with its word;
 10. the arrangements of HexagramSequences.lean (Y5): `zaguaNumbers` is the order in which the 雜卦 names the
     configurations, read from the atlas's preserved text (ZAGUA, bound by RO's verify_ro.py) by the names of the
     received order's pages; each trigram the module names (`Trigram.qian`, …) has the lines of TRIGRAM, and
     `Trigram.stations` is the order in which 說卦 ch. 5 names them (帝出乎震 … 成言乎艮).
It checks text and names, not the proofs: the core checker proves the declarations."""
import argparse
import hashlib
import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[5]
SRC = ROOT / 'sources/zhouyi-yizhuan'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CHAPTER = ROOT / 'theories/becoming/history/YI-ZHUAN-AND-BECOMING.md'   # frozen there since 23 October 2026 (RA)
ZAGUA = ROOT / 'sources/chinese-classical-texts/yidao-v1.3/evidence/texts/YD-OW-ZG.txt'
BEGIN, END = '<!-- passage-map:begin -->', '<!-- passage-map:end -->'
KIND_ZH = {'agreement': '相合', 'scope': '定域', 'divergence': '相分'}
TRIGRAM = {'乾': (1, 1, 1), '兌': (1, 1, 0), '離': (1, 0, 1), '震': (1, 0, 0),
           '巽': (0, 1, 1), '坎': (0, 1, 0), '艮': (0, 0, 1), '坤': (0, 0, 0)}
NUMERAL = '〇一二三四五六七八九'


def chinese_number(n):
    tens, ones = divmod(n, 10)
    return ((NUMERAL[tens] if tens > 1 else '') + ('十' if tens else '') + (NUMERAL[ones] if ones else '')) or '〇'


def page(rel):
    data = json.loads((SRC / rel).read_text())
    return data['query']['pages'][0] if 'query' in data else data


def wikitext(rel):
    return page(rel)['revisions'][0]['slots']['main']['content']


def clean(text):
    text = re.sub(r'-\{(?:[A-Za-z]\|)?|\}-', '', text)                 # character-variant markup
    text = re.sub(r'\{\{yw\|([^{}]*)\}\}', r'\1', text)                  # the main text (原文) of a page with notes
    text = re.sub(r'\[\[(?:[^\]|]*\|)?([^\]]*)\]\]', r'\1', text)        # links: the shown text
    text = re.sub(r'\{\{另\|([^|}]*)\|[^}]*\}\}', r'\1', text)           # variant readings: the first
    text = re.sub(r'\{\{[^{}]*\}\}', '', text)                           # other templates
    return re.sub(r'<[^>]+>', '', text)                                  # tags


# Law level (R35, G12): computed from the declarations a passage cites, never stored in passages.json.
ENCODING = 'Hexagram'  # the hexagram encoding: Becoming.Hexagram lemmas about Fin 64, tables, decide
LEVEL_ZH = {'general': '一般律', 'encoding': '编码', 'mixed': '兼有', None: '—'}


def law_level(p):
    """'encoding' where every cited declaration is in namespace Becoming.Hexagram, 'general' where none is, 'mixed'
    where both occur; None for a passage citing no declaration."""
    names = [d.removeprefix('Becoming.') for d in p.get('declarations', [])]
    if not names:
        return None
    enc = [n.split('.')[0] == ENCODING for n in names]
    return 'encoding' if all(enc) else 'mixed' if any(enc) else 'general'


def level_split(passages, kinds):
    """{kind: {level: count}} for the summary line."""
    out = {k: {} for k in kinds}
    for p in passages:
        lv = law_level(p)
        out[p['kind']][lv] = out[p['kind']].get(lv, 0) + 1
    return out


def level_line(passages, kinds):
    names = {'general': 'general laws', 'encoding': 'the encoding only', 'mixed': 'both', None: 'no declaration'}
    split = level_split(passages, kinds)
    return 'by law level: ' + '; '.join(
        f"{k} {sum(v.values())} (" + ', '.join(f'{v[lv]} through {names[lv]}' for lv in ('general', 'encoding', 'mixed', None) if v.get(lv)) + ')'
        for k, v in split.items())


def table(passages):
    rows = ['| 经文 | 出处 | 关系 | 律的层次 | 脊柱上的声明 | 读法（AI） |', '|---|---|---|---|---|---|']
    for p in passages:
        text = '……'.join(f'「{f}」' for f in p['fragments'])
        decls = '<br>'.join(f"`{d.removeprefix('Becoming.')}`" for d in p['declarations'])
        rows.append(f"| <a id=\"p-{p['id']}\"></a>{text} | {p['locator']} | {KIND_ZH[p['kind']]} | {LEVEL_ZH[law_level(p)]} | {decls} | {p['reading']} |")
    return '\n'.join(rows)


def lean_declarations(path):
    """Full names of the declarations of one Lean file, by its namespaces."""
    return lean_declarations_text(path.read_text())


def lean_declarations_text(text):
    names, stack = set(), []
    for line in text.splitlines():
        m = re.match(r'namespace\s+(\S+)', line)
        if m:
            stack.append(m.group(1))
            continue
        m = re.match(r'end\s+(\S+)', line)
        if m and stack and stack[-1] == m.group(1):
            stack.pop()
            continue
        m = re.match(r'(?:protected\s+|private\s+|noncomputable\s+)*(theorem|def|structure|inductive|abbrev|instance|lemma)\s+([^\s:({\[]+)', line)
        if m:
            names.add('.'.join(stack + [m.group(2)]))
    return names


def order_literal(path):
    text = path.read_text()
    body = text[text.index('def order : List Hexagram := ['):]
    body = body[:body.index('\n  ]')] if '\n  ]' in body else body[:body.index(']\n')]
    return [tuple(1 if v == 'true' else 0 for v in m.group(1).split(', '))
            for m in re.finditer(r'⟨((?:true|false)(?:, (?:true|false)){5})⟩', body)]


def def_table(path, name):
    text = path.read_text()
    block = text[text.index(f'def {name} : Nat → Hexagram'):]
    block = block[:block.index('\n\n')]
    out = {}
    for m in re.finditer(r'\| (\d+|_) => ⟨((?:true|false)(?:, (?:true|false)){5})⟩', block):
        out[m.group(1)] = tuple(1 if v == 'true' else 0 for v in m.group(2).split(', '))
    return out


def variant(name):
    """One form of the two names Wikisource writes either way (恆/恒, 遯/遁)."""
    return name.replace('恆', '恒').replace('遯', '遁')


# Census entries the text states and the relation does not give, each with the theorem stating the
# configuration as it is: 需's top line is in phase (its 小象 says 雖不當位), and 艮's fifth line is
# middle and out of phase (its 小象 says 以中正也).
EXCEPTIONS = {
    'place': {(5, 6, False): 'Becoming.Hexagram.xu_top_inPhase'},
    'centre': {(52, 5): 'Becoming.Hexagram.gen_fifth_out_of_phase'},
    'fall': {},
    'middle': {},
}
NEG_PLACE = ('位不當', '不當位', '未當位', '未得位')
POS_PLACE = ('位正當', '位當', '當位', '得位')


def xiang_lines(text):
    """The 小象 of the six lines of a cleaned page, bottom to top (用九 and 用六 left out)."""
    block = re.search(r"'''象曰：'''\n((?:\*[*#].*\n?)+)", text)
    return [line[2:] for line in block.group(1).splitlines() if line.startswith('*#')][:6]


def tuan_text(text):
    """The 彖 of a cleaned page."""
    block = re.search(r"'''彖曰：'''\n((?:\*\*.*\n?)+)", text)
    return block.group(1) if block else ''


def lean_list(source, name, pattern):
    """The entries of a list literal `def NAME : … := [ … ]` of a Lean source, by a pattern."""
    body = source[source.index(f'def {name} : '):]
    start = body.index(':= [') + 4
    return [m.groups() for m in re.finditer(pattern, body[start:body.index(']', start)])]


def census(failures, order, places_text):
    """Checks 7 and 8, on the cleaned pages; returns the size of each list and its exceptions."""
    pages = [clean(wikitext(f'hexagrams/{n:02d}.json')) for n in range(1, 65)]
    names = [clean(page(f'hexagrams/{n:02d}.json')['title']).split('/', 1)[1] for n in range(1, 65)]
    for m in re.finditer(r'/-- (\S+) \((\d+)\)\. -/\ndef (\w+) : Hexagram := number (\d+)', places_text):
        if m.group(2) != m.group(4) or variant(names[int(m.group(4)) - 1]) != variant(m.group(1)):
            failures.append(f'{m.group(3)} is number {m.group(4)}, not {m.group(1)} ({m.group(2)})')

    def in_phase(n, k):
        return order[n - 1][k - 1] == k % 2

    found = {'place': set(), 'centre': set(), 'fall': set(), 'middle': set()}
    for n, text in enumerate(pages, 1):
        for k, line in enumerate(xiang_lines(text), 1):
            if any(w in line for w in NEG_PLACE):
                found['place'].add((n, k, False))
            elif any(w in line for w in POS_PLACE):
                found['place'].add((n, k, True))
            if '中正也' in line or '正中也' in line:
                found['centre'].add((n, k))
            if '乘剛' in line:
                found['fall'].add((n, k - 1))
        if '剛中而應' in tuan_text(text):
            found['middle'].add(n)
    listed = {
        'place': {(int(n), int(k), b == 'true') for n, k, b in
                  lean_list(places_text, 'placeStatements', r'\((\d+), \.p(\d), (true|false)\)')},
        'centre': {(int(n), int(k)) for n, k in
                   lean_list(places_text, 'centreStatements', r'\((\d+), \.p(\d)\)')},
        'fall': {(int(n), int(lo)) for n, lo, _ in
                 lean_list(places_text, 'fallStatements', r'\((\d+), \.s(\d)(\d)\)')},
        'middle': {int(n) for (n,) in lean_list(places_text, 'middleOppositionStatements', r'(\d+)')},
    }
    holds = {
        'place': lambda q: in_phase(q[0], q[1]) == q[2],
        'centre': lambda q: q[1] in (2, 5) and in_phase(*q),
        'fall': lambda q: order[q[0] - 1][q[1] - 1] == 1 and order[q[0] - 1][q[1]] == 0,
        'middle': lambda n: order[n - 1][1] != order[n - 1][4],
    }
    declared = lean_declarations_text(places_text)
    for kind in found:
        exceptions = set(EXCEPTIONS[kind])
        if found[kind] != listed[kind] | exceptions or listed[kind] & exceptions:
            failures.append(f'census {kind}: in the text, not listed: {sorted(found[kind] - listed[kind] - exceptions)}; '
                            f'listed, not in the text: {sorted(listed[kind] - found[kind])}')
        for q in listed[kind]:
            if not holds[kind](q):
                failures.append(f'census {kind}: {q} does not hold on the pages')
        for q, theorem in EXCEPTIONS[kind].items():
            if holds[kind](q) or theorem not in declared:
                failures.append(f'census {kind}: exception {q} holds, or {theorem} is not in the module')
    return {kind: (len(listed[kind]), len(EXCEPTIONS[kind])) for kind in found}


# Y4: the censuses of HexagramSites.lean.
PLACE_CLAUSE = re.compile('位不當|不當位|未當位|未得位|失位|位正當|位當|當位|得位|正位')
NEGATIVE_CLAUSE = {'位不當', '不當位', '未當位', '未得位', '失位'}
IMAGE = {'天': '乾', '地': '坤', '雷': '震', '風': '巽', '木': '巽', '水': '坎', '雲': '坎', '雨': '坎',
         '泉': '坎', '火': '離', '明': '離', '電': '離', '山': '艮', '澤': '兌'}
WITHIN = re.compile(r'(\S)中(?:有|生)(\S)|(\S)(?:在|入)(\S)中')
# The 大象 that set the lower trigram's image within the upper one's, and those that say 位 (of the 君子).
DAXIANG_WITHIN = {7, 15, 17, 24, 26, 36, 46, 49}
DAXIANG_PLACE = {50: '君子以正位凝命', 52: '君子以思不出其位'}
# The 小象 lines that say 中 at a place that is not middle, each with the word that says it.
XIAOXIANG_MIDDLE_OTHER = {(11, 4): '中心', (24, 4): '中行', (51, 6): '中未得', (55, 4): '日中'}


def line_texts(text):
    """The line texts (爻辭) of a cleaned page, bottom to top (用九 and 用六 left out)."""
    block = re.search(r"'''易經：'''\n((?:\*[*#].*\n?)+)", text)
    return [line[2:] for line in block.group(1).splitlines() if line.startswith('*#')][:6]


def da_xiang(text):
    """The 大象 of a cleaned page: the first line of its 象."""
    block = re.search(r"'''象曰：'''\n((?:\*[*#].*\n?)+)", text)
    return next(line[2:] for line in block.group(1).splitlines() if line.startswith('**'))


def sites_census(failures, order, sites_text):
    """Check 9 (and 7 for HexagramSites.lean); returns counts for the summary."""
    pages = [clean(wikitext(f'hexagrams/{n:02d}.json')) for n in range(1, 65)]
    names = [clean(page(f'hexagrams/{n:02d}.json')['title']).split('/', 1)[1] for n in range(1, 65)]
    for m in re.finditer(r'/-- (\S+) \((\d+)\)\. -/\ndef (\w+) : Hexagram := number (\d+)', sites_text):
        if m.group(2) != m.group(4) or variant(names[int(m.group(4)) - 1]) != variant(m.group(1)):
            failures.append(f'{m.group(3)} is number {m.group(4)}, not {m.group(1)} ({m.group(2)})')

    def line(n, k):
        return order[n - 1][k - 1]

    def in_phase(n, k):
        return line(n, k) == k % 2

    def holds(n, k):
        return 2 <= k <= 5 and in_phase(n, k)

    def sole(n, k):
        return all(line(n, i) != line(n, k) for i in range(1, 7) if i != k)

    def trigrams(n):
        tri = re.search(r'(\S)下(\S)上', pages[n - 1])
        return tri.group(1), tri.group(2)

    out = {}
    # the 小象's statements of place under the second relation; none at the ends but 需上六's
    place = set()
    for n, text in enumerate(pages, 1):
        for k, words in enumerate(xiang_lines(text), 1):
            if any(w in words for w in NEG_PLACE):
                place.add((n, k, False))
            elif any(w in words for w in POS_PLACE):
                place.add((n, k, True))
    top = {(int(n), int(k), b == 'true') for n, k, b in
           lean_list(sites_text, 'topStatements', r'\((\d+), \.p(\d), (true|false)\)')}
    if {q for q in place if q[1] in (1, 6)} != {(5, 6, False)} or top != {(1, 6, False), (5, 6, False)}:
        failures.append(f'statements of place at the ends: {sorted(q for q in place if q[1] in (1, 6))}, '
                        f'topStatements {sorted(top)}')
    for n, k, b in place | top:
        if holds(n, k) != b:
            failures.append(f'second relation: ({n}, {k}, {b}) does not hold on the pages')
    if '貴而无位' not in pages[0] or '貴而无位' not in clean(wikitext('yizhuan/xici-shang.json')):
        failures.append('乾上九 「貴而无位」 not found in the 文言 of 乾 and the 繫辭上')
    out['小象 place, second relation'] = f'{len(place)} + 乾上九, no exception'
    # the 彖's clauses of place
    found, listed = {}, {}
    for n, text in enumerate(pages, 1):
        for m in PLACE_CLAUSE.finditer(tuan_text(text)):
            key = (n, m.group(0) not in NEGATIVE_CLAUSE)
            found[key] = found.get(key, 0) + 1
    lines_ = [(int(n), int(k), b == 'true') for n, k, b in
              lean_list(sites_text, 'tuanPlaceStatements', r'\((\d+), \.p(\d), (true|false)\)')]
    wholes = [(int(n), b == 'true') for n, b in lean_list(sites_text, 'tuanWholeStatements', r'\((\d+), (true|false)\)')]
    for n, _, b in lines_:
        listed[(n, b)] = listed.get((n, b), 0) + 1
    for n, b in wholes:
        listed[(n, b)] = listed.get((n, b), 0) + 1
    if found != listed:
        failures.append(f'census 彖 place: in the text {sorted(found.items())}, listed {sorted(listed.items())}')
    for n, k, b in lines_:
        if not 2 <= k <= 5 or in_phase(n, k) != b:
            failures.append(f'census 彖 place: ({n}, {k}, {b}) does not hold on the pages')
    first = 0
    for n, b in wholes:
        between = [in_phase(n, k) for k in range(2, 6)]
        if not all(x == b for x in between):
            failures.append(f'census 彖 whole: ({n}, {b}) does not hold under the second relation')
        first += all(in_phase(n, k) == b for k in range(1, 7))
    out['彖 place'] = f'{len(lines_)} of one line + {len(wholes)} of the whole ({first} under the six places)'
    # 上下應
    answered = [(int(n), int(k)) for n, k in lean_list(sites_text, 'answeredStatements', r'\((\d+), \.p(\d)\)')]
    if {n for n, _ in answered} != {n for n, text in enumerate(pages, 1) if '上下應' in tuan_text(text)}:
        failures.append('census 上下應: the list differs from the 彖')
    for n, k in answered:
        if not sole(n, k):
            failures.append(f'census 上下應: ({n}, {k}) is not a sole line')
    out['彖 上下應'] = str(len(answered))
    # the line texts
    middle = {(n, k) for n, text in enumerate(pages, 1) for k, words in enumerate(line_texts(text), 1) if '中' in words}
    course = {(n, k) for n, text in enumerate(pages, 1) for k, words in enumerate(line_texts(text), 1) if '中行' in words}
    placed = {(n, k) for n, text in enumerate(pages, 1) for k, words in enumerate(line_texts(text), 1) if '位' in words}
    for name, got in (('lineTextMiddle', middle), ('middleCourseLines', course), ('lineTextPlace', placed)):
        want = {(int(n), int(k)) for n, k in lean_list(sites_text, name, r'\((\d+), \.p(\d)\)')}
        if got != want:
            failures.append(f'census {name}: in the text {sorted(got)}, listed {sorted(want)}')
    if any(not 2 <= k <= 5 for _, k in middle) or any(not holds(n, k) for n, k in placed):
        failures.append('census 爻辭: a 中 at an end, or a 位 not held')
    out['爻辭 中'] = f'{len(middle)} ({sum(k in (2, 5) for _, k in middle)} middle, all between the ends)'
    out['爻辭 位'] = str(len(placed))
    # the 大象
    within, at_place = set(), set()
    for n, text in enumerate(pages, 1):
        words = da_xiang(text).replace(names[n - 1], '')
        if '中' in words:
            within.add(n)
            m = WITHIN.search(words)
            outer, inner = (m.group(1), m.group(2)) if m and m.group(1) else (m.group(4), m.group(3)) if m else (None, None)
            lower, upper = trigrams(n)
            if IMAGE.get(outer) != upper or IMAGE.get(inner) != lower:
                failures.append(f'census 大象 中: {names[n - 1]} does not set the lower trigram within the upper')
        if '位' in words:
            at_place.add(n)
            if DAXIANG_PLACE.get(n, '\0') not in words:
                failures.append(f'census 大象 位: {names[n - 1]} is not listed with its words')
    if within != DAXIANG_WITHIN or at_place != set(DAXIANG_PLACE):
        failures.append(f'census 大象: 中 at {sorted(within)}, 位 at {sorted(at_place)}')
    out['大象 中'] = f'{len(within)}, each the lower trigram within the upper'
    out['大象 位'] = f'{len(at_place)}, of the 君子'
    # every 小象 line that says 中
    said = {(n, k): words for n, text in enumerate(pages, 1) for k, words in enumerate(xiang_lines(text), 1)
            if '中' in words}
    other = {q for q in said if q[1] not in (2, 5)}
    if other != set(XIAOXIANG_MIDDLE_OTHER) or any(XIAOXIANG_MIDDLE_OTHER[q] not in said[q] for q in other):
        failures.append(f'census 小象 中: not at a middle place {sorted(other)}')
    out['小象 中'] = f'{len(said)} ({len(said) - len(other)} middle)'
    return out


def wax_wane(s):
    a, b, c, d, e, f = s
    return (1 - f, a, b, c, d, e)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--receipt', type=Path)
    ap.add_argument('--chapter', type=Path, default=CHAPTER)
    ap.add_argument('--table', action='store_true')
    args = ap.parse_args()
    passages = json.loads((HERE / 'passages.json').read_text())['passages']
    if args.table:
        print(table(passages))
        return 0
    failures = []

    # 1. preserved bytes
    prov = json.loads((SRC / 'PROVENANCE.json').read_text())
    for f in prov['files']:
        raw = (SRC / f['file']).read_bytes()
        if hashlib.sha256(raw).hexdigest() != f['sha256']:
            failures.append(f"bytes changed: {f['file']}")
        pg = page(f['file'])
        rev = pg['revisions'][0]
        if rev['revid'] != f['revid'] or pg['title'] != f['title']:
            failures.append(f"revision differs: {f['file']}")
        if hashlib.sha256(rev['slots']['main']['content'].encode()).hexdigest() != f['wikitext_sha256']:
            failures.append(f"wikitext changed: {f['file']}")
    bound = {f['file'] for f in prov['files']}

    # 2. fragments verbatim
    ids = set()
    for p in passages:
        if p['id'] in ids:
            failures.append(f"passage id repeated: {p['id']}")
        ids.add(p['id'])
        if p['source'] not in bound:
            failures.append(f"{p['id']}: source not bound by the provenance: {p['source']}")
            continue
        text = clean(wikitext(p['source']))
        for frag in p['fragments']:
            if frag not in text:
                failures.append(f"{p['id']}: not verbatim in {p['source']}: {frag}")
        if p['kind'] not in KIND_ZH or not p['declarations']:
            failures.append(f"{p['id']}: kind or declarations missing")

    # 3. declarations
    checks = PKG / 'becoming-checks'
    receipt = args.receipt or max(checks.glob('*/verification.json'))
    audited = {d['name'] for m in json.loads(receipt.read_text())['modules'] for d in m['declarations']}
    module = PKG / 'Becoming/Hexagrams.lean'
    if not module.exists():
        module = HERE / 'Becoming/Hexagrams.lean'
    places = PKG / 'Becoming/HexagramPlaces.lean'
    if not places.exists():
        places = HERE / 'y2/Becoming/HexagramPlaces.lean'
    laws = PKG / 'Becoming/HexagramLaws.lean'
    if not laws.exists():
        laws = HERE / 'y3/Becoming/HexagramLaws.lean'
    sites = PKG / 'Becoming/HexagramSites.lean'
    if not sites.exists():
        sites = HERE / 'y4/Becoming/HexagramSites.lean'
    sequences = PKG / 'Becoming/HexagramSequences.lean'
    if not sequences.exists():
        sequences = HERE / 'y5/Becoming/HexagramSequences.lean'
    from_source = (lean_declarations(module) | lean_declarations(places) | lean_declarations(laws)
                   | lean_declarations(sites) | lean_declarations(sequences))
    by_source = set()
    for p in passages:
        for d in p['declarations']:
            if d in audited:
                continue
            if d.startswith('Becoming.Hexagram') and d in from_source:
                by_source.add(d)
            else:
                failures.append(f"{p['id']}: no such audited declaration: {d}")

    # 4. the received order
    order = order_literal(module)
    if len(order) != 64:
        failures.append(f'order literal has {len(order)} entries')
    names = []
    previous = None
    for n in range(1, 65):
        pg = page(f'hexagrams/{n:02d}.json')
        title = clean(pg['title'])
        name = title.split('/', 1)[1]
        names.append(name)
        text = clean(wikitext(f'hexagrams/{n:02d}.json'))
        if f'第{chinese_number(n)}卦' not in text:
            failures.append(f'page {n} ({title}) is not marked 第{chinese_number(n)}卦')
        tri = re.search(r'(\S)下(\S)上', text)
        lines = TRIGRAM[tri.group(1)] + TRIGRAM[tri.group(2)]
        if n <= len(order) and order[n - 1] != lines:
            failures.append(f'order entry {n} is not {name} ({tri.group(0)})')
        if previous is not None:
            link = re.search(r'\|\s*next\s*=\s*\[\[\.\./([^|\]]+)', clean_links_kept(previous))
            if not link or variant(re.sub(r'-\{|\}-', '', link.group(1)).strip()) != variant(name):
                failures.append(f'page {n - 1} does not link to {name}')
        previous = wikitext(f'hexagrams/{n:02d}.json')
    named = {lines: names[i] for i, lines in enumerate(order)}

    # 5. named configurations and orbits
    rising, falling = def_table(module, 'rising'), def_table(module, 'falling')
    want_r, want_f = '坤 復 臨 泰 大壯 夬 乾'.split(), '乾 姤 遯 否 觀 剝 坤'.split()
    for k in range(7):
        key = str(k) if k < 6 else '_'
        if named.get(rising[key]) != want_r[k]:
            failures.append(f'rising {k} is not {want_r[k]}')
        if named.get(falling[key]) != want_f[k]:
            failures.append(f'falling {k} is not {want_f[k]}')
    sui = re.search(r'def sui : Hexagram := ⟨([^⟩]*)⟩', module.read_text()).group(1)
    sui = tuple(1 if v == 'true' else 0 for v in sui.split(', '))
    cycle, s = [], sui
    for _ in range(4):
        cycle.append(named[s])
        s = wax_wane(s)
    if cycle != ['隨', '中孚', '蠱', '小過'] or s != sui:
        failures.append(f'the orbit of 隨 is {cycle}')
    s, orbit = (1,) * 6, []
    for _ in range(12):
        orbit.append(named[s])
        s = wax_wane(s)
    if orbit != want_f + want_r[1:6] or s != (1,) * 6:
        failures.append(f'the orbit of 乾 is {orbit}')

    # 7 and 8. the named configurations and the censuses
    counts = census(failures, order, places.read_text())
    sites_counts = sites_census(failures, order, sites.read_text())

    # 7 and 10. the named configurations and the arrangements of HexagramSequences.lean
    arrangements = sequences_check(failures, sequences.read_text())

    # 6. the chapter table
    if args.chapter.exists():
        text = args.chapter.read_text()
        if BEGIN not in text or END not in text:
            failures.append('chapter has no passage-map markers')
        else:
            got = text[text.index(BEGIN) + len(BEGIN):text.index(END)].strip()
            if got != table(passages):
                failures.append('chapter table differs from passages.json (print it with --table)')
    else:
        failures.append(f'no chapter at {args.chapter}')

    kinds = {k: sum(p['kind'] == k for p in passages) for k in KIND_ZH}
    decls = {d for p in passages for d in p['declarations']}
    print(f"{len(passages)} passages ({kinds['agreement']} agreement, {kinds['scope']} scope, "
          f"{kinds['divergence']} divergence), {sum(len(p['fragments']) for p in passages)} fragments, "
          f"{len(decls)} declarations; receipt {receipt.parent.name}"
          + (f'; {len(by_source)} Hexagrams names checked against the module source, not yet in the receipt' if by_source else ''))
    print(level_line(passages, KIND_ZH))
    print('censuses (listed + exceptions): ' + ', '.join(f'{k} {v[0]} + {v[1]}' for k, v in counts.items()))
    print('censuses of HexagramSites: ' + '; '.join(f'{k} {v}' for k, v in sites_counts.items()))
    print('arrangements of HexagramSequences: ' + '; '.join(f'{k} {v}' for k, v in arrangements.items()))
    print('order: 64 pages, trigrams and links agree' if not any('order' in f or 'page' in f for f in failures) else '')
    for f in failures:
        print('FAIL', f)
    return 1 if failures else 0


def zagua_order(text, names):
    """The received-order numbers of the configurations the 雜卦 names, in its order: the preserved text's first
    edition (一篇) marks each name by the space its link left, and a name is the longest ending of the text before
    such a space that is a page name of the received order."""
    body = text[text.index('## 一篇'):text.index('## 校詁版')]
    body = body[body.index('\n'):].replace('[编辑 ]', '')
    index = {variant(n): i + 1 for i, n in enumerate(names)}
    found = []
    for seg in body.split(' ')[:-1]:
        seg = seg.strip()
        hit = next((index[variant(seg[-k:])] for k in (2, 1) if len(seg) >= k and variant(seg[-k:]) in index), None)
        found.append(hit)
    return found


def sequences_check(failures, text):
    """Checks 7 and 10 for HexagramSequences.lean; returns counts for the summary."""
    names = [clean(page(f'hexagrams/{n:02d}.json')['title']).split('/', 1)[1] for n in range(1, 65)]
    named = 0
    for m in re.finditer(r'/-- (\S+) \((\d+)\)\. -/\ndef (\w+) : Hexagram := number (\d+)', text):
        named += 1
        if m.group(2) != m.group(4) or variant(names[int(m.group(4)) - 1]) != variant(m.group(1)):
            failures.append(f'{m.group(3)} is number {m.group(4)}, not {m.group(1)} ({m.group(2)})')
    body = text[text.index('def zaguaNumbers : List Nat :='):]
    listed = [int(x) for x in re.findall(r'\d+', body[body.index('['):body.index(']')])]
    if not ZAGUA.exists():
        failures.append(f'no preserved 雜卦 at {ZAGUA.relative_to(ROOT)}')
    elif zagua_order(ZAGUA.read_text(), names) != listed:
        failures.append('zaguaNumbers is not the order in which the preserved 雜卦 names the configurations')
    trigrams = {}
    for m in re.finditer(r'/-- (\S)[.:][^-]*-/\ndef (\w+) : Bool × Bool × Bool := \((true|false), (true|false), '
                         r'(true|false)\)', text):
        lines = tuple(1 if v == 'true' else 0 for v in m.group(3, 4, 5))
        trigrams[m.group(2)] = m.group(1)
        if TRIGRAM.get(m.group(1)) != lines:
            failures.append(f'Trigram.{m.group(2)} does not have the lines of {m.group(1)}')
    if len(trigrams) != 8:
        failures.append(f'{len(trigrams)} trigrams named, not eight')
    stations = re.search(r'def stations : List \(Bool × Bool × Bool\) := \[([^\]]*)\]', text).group(1)
    shown = ''.join(trigrams.get(s.strip(), '?') for s in stations.split(','))
    said = re.search(r'帝出乎(\S)，齊乎(\S)，相見乎(\S)，致役乎(\S)，說言乎(\S)，戰乎(\S)，勞乎(\S)，成言乎(\S)。',
                     clean(wikitext('yizhuan/shuogua.json')))
    if not said or shown != ''.join(said.groups()):
        failures.append(f'Trigram.stations ({shown}) is not the order of 說卦 ch. 5')
    return {'named configurations': named, '雜卦 entries': len(listed), 'stations': shown}


def clean_links_kept(text):
    return re.sub(r'-\{(?:[A-Za-z]\|)?|\}-', '', text)


if __name__ == '__main__':
    sys.exit(main())
