import json
import math
import re
import sys
import unittest
from pathlib import Path
from unittest import mock

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT))
from tools.research import spine, zh_fronts  # noqa: E402

ORDER = ['root', 'map', 'knowing', 'life', 'collective', 'classical', 'significance', 'method']


def node(id_, type_, region, **kw):
    return {'id': id_, 'type': type_, 'region': region, **kw}


def graph():
    """Two results per region, a module each, uses in both directions between root and map, and one of each other kind."""
    nodes = [node('concept:a', 'concept', 'root')]
    for k in ORDER:
        nodes += [node(f'record:{k}1', 'result', k), node(f'record:{k}2', 'result', k),
                  node(f'module:{k}', 'module', k, on_grammar=k == 'root')]
    edges = [{'from': 'record:root1', 'to': 'record:map1', 'type': 'formal-reuse'}] * 12 + \
            [{'from': 'record:map1', 'to': 'record:root1', 'type': 'formal-reuse'}] * 3 + \
            [{'from': 'record:map2', 'to': 'record:map1', 'type': 'formal-reuse'},
             {'from': 'record:knowing1', 'to': 'record:significance1', 'type': 'interpretive'},
             {'from': 'record:significance1', 'to': 'record:collective1', 'type': 'application'},
             {'from': 'record:life1', 'to': 'record:root2', 'type': 'related'},
             {'from': 'module:map', 'to': 'module:root', 'type': 'imports'}]
    return {'nodes': nodes, 'edges': edges}


class Counting(unittest.TestCase):
    def test_counts_by_region_and_kind(self):
        results, pairs, modules, concepts = spine.counts(graph(), ORDER)
        self.assertEqual(results['root'], 2)
        self.assertEqual(pairs[('root', 'map')]['formal-reuse'], 12)
        self.assertEqual(pairs[('map', 'root')]['formal-reuse'], 3)
        self.assertEqual(pairs[('map', 'map')]['formal-reuse'], 1)
        self.assertEqual(pairs[('life', 'root')]['related'], 1)
        self.assertEqual(set(pairs[('root', 'map')]), set(spine.KINDS))
        self.assertEqual(modules['root'], [1, 1])
        self.assertEqual(modules['map'], [1, 0])
        self.assertEqual(concepts, 1)

    def test_wrap_keeps_every_word_and_width(self):
        text = 'a verified inference using the cited result, the count of uses'
        lines = spine.wrap(text, 20, 'en')
        self.assertEqual(' '.join(lines), text)
        self.assertTrue(all(len(l) <= 20 for l in lines))
        zh = spine.wrap('一个从它所选择者读出的度量', 8, 'zh')
        self.assertEqual(''.join(zh), '一个从它所选择者读出的度量')
        self.assertTrue(all(len(l) <= 4 for l in zh))

    def test_items_wrap_between_items_only(self):
        body = '11 项推导而得 · 1 项在一个所述的假设之下 · 6 项为计数，位于文法以下 · 99 项处于一个指明的距离'
        lines = spine.wrap_items(body, 92, 'zh')
        self.assertEqual(' · '.join(lines), body)
        self.assertEqual(lines[-1], '99 项处于一个指明的距离')
        self.assertEqual(spine.wrap_items('ab · cd', 20, 'en'), ['ab · cd'])


class Geometry(unittest.TestCase):
    def layout(self):
        """The fixture with a pair across the ring (knowing and significance) and a pair at 90 degrees, both ways."""
        g = graph()
        more = [('knowing1', 'significance1', 12), ('significance1', 'knowing1', 11), ('root1', 'knowing1', 10),
                ('knowing1', 'root1', 13), ('map1', 'root1', 9)]
        for a, b, n in more:
            g['edges'] += [{'from': f'record:{a}', 'to': f'record:{b}', 'type': 'formal-reuse'}] * n
        results, pairs, modules, concepts = spine.counts(g, ORDER)
        return spine.layout(spine.spec(), results, pairs, 'en', 120)

    def test_no_curve_comes_near_the_grammar(self):
        L = self.layout()
        for c in L['curves']:
            for i in range(21):
                x, y = c['point'](i / 20)
                self.assertGreater(math.hypot(x - L['cx'], y - L['cy']), spine.GR + 6, (c['from'], c['to'], i))

    def test_a_pair_across_the_ring_goes_round_one_side(self):
        L = self.layout()
        mids = {(c['from'], c['to']): c['point'](0.5) for c in L['curves'] if c['kind'] == 'formal-reuse'}
        (x1, y1), (x2, y2) = mids[('knowing', 'significance')], mids[('significance', 'knowing')]
        self.assertGreater((y1 - L['cy']) * (y2 - L['cy']), 0, 'both directions on the same side of the centre')
        self.assertGreater(math.dist((x1, y1), (x2, y2)), 8, 'in different lanes')

    def test_two_directions_of_a_pair_take_different_lanes(self):
        L = self.layout()
        mids = {(c['from'], c['to']): c['point'](0.5) for c in L['curves'] if c['kind'] == 'formal-reuse'}
        self.assertGreater(math.dist(mids[('root', 'knowing')], mids[('knowing', 'root')]), 8)


class Checking(unittest.TestCase):
    def test_live_spec_holds_at_its_homes(self):
        self.assertEqual(spine.check(spine.spec()), [])

    def test_a_phrase_gone_from_its_home_is_an_error(self):
        s = spine.spec()
        real = spine._read

        def without(path):
            text = real(path)
            if path == s['theses_homes']['en']:
                text = text.replace('three frozen seabird tests did not reject it at their thresholds', 'three frozen seabird tests')
            return text

        with mock.patch.object(spine, '_read', side_effect=without):
            errors = spine.check(s)
        self.assertTrue(any('did not reject it' in e for e in errors), errors)

    def test_the_simpler_pictures_classes_are_checked(self):
        s, real = spine.spec(), spine.boundary_counts
        with mock.patch.object(spine, 'boundary_counts', lambda: {**real(), 'connected': real()['connected'] + 1, 'new class': 2}):
            errors = '\n'.join(spine.check(s))
        self.assertIn('2 central declarations "new class", a class the simpler picture does not draw', errors)
        self.assertIn(f"no longer holds: '{real()['connected'] + 1} connected'", errors)
        self.assertIn('do not add to its central declarations', errors)
        s['first_view']['bands'][0]['example']['en'][1] = 'a sentence its record does not hold'
        self.assertTrue(any('a sentence its record does not hold' in e for e in spine.check(s)))

    def test_an_example_stands_in_its_class_and_quotes_one_record(self):
        s = spine.spec()
        self.assertEqual([e for e in spine.check(s) if 'example of' in e], [])
        derived = s['first_view']['bands'][0]['example']
        derived['declaration'] = 'RelativePosition.rise_needs_fall'  # a counting declaration under "derived"
        derived['en'] = ['theories/becoming/results/records/one-root-to-its-edge.json', 'A case of «所闭之界» at feeding from']
        errors = '\n'.join(spine.check(s))
        self.assertIn('the example of "derived", RelativePosition.rise_needs_fall, stands as \'counting\'', errors)
        self.assertIn('the example of "derived" quotes two records', errors)
        s = spine.spec()
        ex = s['first_view']['bands'][2]['example']
        ex['en'][1], ex['zh'][1] = 'A nonempty family has a greatest part', '非空的族有一个最大的部分'  # the record's other law
        errors = spine.check(s)
        for lang in ('en', 'zh'):
            self.assertIn(f'the example of "counting" is not in a law of its record naming RelativePosition.rise_needs_fall ({lang})', '\n'.join(errors))
        self.assertFalse(any('no longer holds' in e for e in errors))
        s = spine.spec()
        s['first_view']['bands'][0]['gloss_also']['en'][1] = 'a clause the glossary does not hold'
        self.assertTrue(any('a clause the glossary does not hold' in e for e in spine.check(s)))

    def test_the_simpler_picture_says_a_class_of_one_is_its_only_member(self):
        svg = spine.standings_svg(spine.spec(), 'en')
        self.assertIn('It is GroupEnding.Flow.all_end:', svg)
        self.assertIn('For example, Flow.beyond_gives_nothing:', svg)
        self.assertIn('the case rests on those reviews,', svg)
        self.assertIn('each AI-written', svg)
        self.assertIn("(the closure: a formation's feeding closure)", svg.replace('&#x27;', "'").replace('&apos;', "'"))
        self.assertIn("RelativePosition.rise_needs_fall, in its record's law:", svg)
        self.assertIn('domains, list 126 central rows, nine declarations twice, so 117 distinct', spine.standings_svg(spine.spec(), 'en').split('</desc>')[0])

    def test_an_unknown_outcome_is_an_error(self):
        s = spine.spec()
        s['theses'][0] = {**s['theses'][0], 'outcome': 'passed'}
        self.assertTrue(any('unknown outcome' in e for e in spine.check(s)))


class Drawing(unittest.TestCase):
    def test_picture_is_self_contained_and_says_what_it_counts(self):
        s = spine.spec()
        for lang in ('en', 'zh'):
            out = spine.svg(graph(), s, lang)
            self.assertTrue(out.startswith('<svg xmlns="http://www.w3.org/2000/svg"'))
            self.assertNotIn('<script', out)
            self.assertNotIn('<foreignObject', out)
            self.assertIsNone(re.search(r'(?:href|src)="(?!#)', out), 'no external resource')
            self.assertIn('<title id="spine-title">', out)
            for t in s['theses']:
                self.assertIn(f'>{t["id"]}</text>', out)
        g = graph()
        g['edges'] += [{'from': 'record:root1', 'to': 'record:map1', 'type': 'formal-reuse'}] * 4 + \
            [{'from': 'record:knowing1', 'to': 'record:root1', 'type': 'formal-reuse'}] * 11
        out = spine.svg(g, s, 'en')
        drawing = out.split('</defs>', 1)[1].split('How to read it')[0]
        # root to map (16) is drawn and its count written; knowing to root (11) is drawn and not written; map to root
        # (3) is under the threshold and not drawn
        self.assertIn('>16</text>', drawing)
        self.assertNotIn('>11</text>', drawing)
        self.assertNotIn('>3</text>', drawing)
        self.assertIn('1 of 1 modules', drawing)

    def test_a_count_in_a_bundle_takes_a_lead_above_the_floor_these_tests_hold(self):
        # where no place is LEAD nearer its own curve and 1 px clear of every other stroke, the render takes LEAD_FLOOR,
        # still above the LEAD - 0.5 the live picture's test holds, and clears every other stroke itself (07's count to 01
        # beside 06's curve to 01, 9 November 2026)
        self.assertGreater(spine.LEAD_FLOOR, spine.LEAD - 0.5)
        self.assertLessEqual(spine.LEAD_FLOOR, spine.LEAD)

    def test_each_count_in_the_live_picture_sits_by_its_own_curve(self):
        g = json.loads((ROOT / 'theories/becoming/results/data/theory-graph.json').read_text(encoding='utf-8'))
        s = spine.spec()
        for lang in ('en', 'zh'):
            info = {}
            spine.svg(g, s, lang, info)
            self.assertTrue(info['counts'])
            for c, box in info['counts']:
                x, y = (box[0] + box[2]) / 2, (box[1] + box[3]) / 2

                def gap(curve):
                    return min(math.hypot(px - x, py - y) for px, py in (curve['point'](i / 200) for i in range(201)))
                nearest = min(info['curves'], key=gap)
                self.assertIs(nearest, c, (lang, c['from'], c['to'], c['n'], nearest['from'], nearest['to'], nearest['kind']))
                other = min(gap(o) for o in info['curves'] if o is not c)
                self.assertGreater(other, gap(c) + spine.LEAD - 0.5, (lang, c['n']))
                for circle in info['circles']:
                    self.assertTrue(spine.clear_of_circle(box, circle), (lang, c['n'], circle))
                # the box, which pads the digits by about 2.5 px, clears the stroke of every other curve but its pair's, and
                # every spoke
                mates = [o for o in info['curves'] if o is not c and {o['from'], o['to']} == {c['from'], c['to']}]
                for o in info['curves']:
                    if o is c or o in mates:
                        continue
                    half = 0.4 + 0.4 * math.sqrt(o['n']) if o['kind'] == 'formal-reuse' else 1
                    for i in range(201):
                        self.assertTrue(spine.clear_of_circle(box, (*o['point'](i / 200), half)), (lang, c['n'], o['from'], o['to']))
                for x, y, r in info['spokes']:
                    self.assertTrue(spine.clear_of_circle(box, (x, y, r - 1)), (lang, c['n'], 'spoke'))
                for block in info['boxes']:
                    self.assertFalse(spine.overlaps(box, block), (lang, c['n'], block))
            placed = [box for _, box in info['counts']]
            for i, a in enumerate(placed):
                self.assertFalse(any(spine.overlaps(a, b) for b in placed[i + 1:]), (lang, a))

    def test_a_count_with_no_place_stops_the_render(self):
        g = (ROOT / 'theories/becoming/results/data/theory-graph.json').read_text(encoding='utf-8')
        with mock.patch.object(spine, 'LEAD', 500), mock.patch.object(spine, 'LEAD_FLOOR', 500):
            pages, errors = spine.render(g)
        self.assertEqual(pages, {})
        self.assertTrue(any('no place for the count' in e for e in errors), errors)

    def test_a_count_on_a_circle_stops_the_render_though_nearest_its_curve(self):
        g = (ROOT / 'theories/becoming/results/data/theory-graph.json').read_text(encoding='utf-8')
        real = spine.place_box

        def grown(*a, **k):  # the same centre, so the lead still holds, and a box too large to clear anything
            box = real(*a, **k)
            return (box[0] - 200, box[1] - 200, box[2] + 200, box[3] + 200) if k.get('accept') else box
        with mock.patch.object(spine, 'place_box', grown):
            pages, errors = spine.render(g)
        self.assertEqual(pages, {})
        self.assertTrue(any('no place for the count' in e for e in errors), errors)

    def test_a_curve_behind_a_chapter_stops_the_render(self):
        g = (ROOT / 'theories/becoming/results/data/theory-graph.json').read_text(encoding='utf-8')
        with mock.patch.object(spine, 'LANE_STEP', 60):
            pages, errors = spine.render(g)
        self.assertEqual(pages, {})
        self.assertTrue(any('passes behind chapter' in e for e in errors), errors)

    def test_the_shared_laws_strip_and_the_spokes_beside_their_chapters(self):
        g = json.loads((ROOT / 'theories/becoming/results/data/theory-graph.json').read_text(encoding='utf-8'))
        s = spine.spec()
        out = spine.svg(g, s, 'en')
        for name, _, represented, c in spine.shared_laws_rows():
            self.assertIn(f'>{name}</text>', out)
            k = spine.reaching_the_grammar(name, c)
            self.assertIn(f'>{c} rows, all {c} reach</text>' if k == c else f'>{c} rows, {k} reach</text>', out)
        self.assertEqual(out.count('>represented both ways, not derived</text>'), 1)  # balance alone
        self.assertIn('fill="url(#reach)"', out)
        self.assertIn('run backward, an earlier chapter’s results using a later one’s', out)
        self.assertEqual(out.count(' modules on the grammar</text>'), 8)  # one line in each chapter's words, none on the ring
        zh = spine.svg(g, s, 'zh')
        self.assertIn('>平衡</text>', zh)
        self.assertEqual(zh.count(' 个在文法上</text>'), 8)

    def test_a_curve_through_a_chapters_words_stops_the_render(self):
        g = (ROOT / 'theories/becoming/results/data/theory-graph.json').read_text(encoding='utf-8')
        real = spine.layout

        def over(*a, **k):  # the map's words spread over the whole ring
            L = real(*a, **k)
            L['blocks']['map'] = {**L['blocks']['map'], 'box': (0, 0, spine.W, 2000)}
            return L
        with mock.patch.object(spine, 'layout', over):
            pages, errors = spine.render(g)
        self.assertEqual(pages, {})
        self.assertTrue(any('crosses the words of chapter map' in e for e in errors), errors)

    def test_the_simpler_picture_draws_every_central_declaration_once(self):
        s, n = spine.spec(), spine.boundary_counts()
        for lang in ('en', 'zh'):
            out = spine.standings_svg(s, lang)
            self.assertTrue(out.startswith('<svg xmlns="http://www.w3.org/2000/svg"'))
            self.assertIsNone(re.search(r'(?:href|src)="(?!#)', out), 'no external resource')
            self.assertNotIn('<script', out)
            self.assertEqual(out.count('width="12" height="12"'), sum(n.values()))
            for item in s['first_view']['bands'] + s['first_view']['distance']:
                head = f'{n[item["key"]]} {item[lang]["label"]}' if lang == 'en' else f'{n[item["key"]]} 项{item[lang]["label"]}'
                self.assertIn(f'>{head}</text>', out)
            for item in s['first_view']['bands'] + s['first_view']['distance']:
                if item.get('example'):
                    self.assertIn(item['example']['declaration'], out)
        self.assertIn('>The 117 central declarations and the grammar’s laws</text>', spine.standings_svg(s, 'en'))
        lead = '\n'.join(spine.lead(graph(), 'theories/becoming/results/THEORY-GRAPH.md'))
        self.assertIn('](standings.svg)', lead)
        self.assertIn('](standings.zh.svg)', spine.zh_page(graph()))

    def test_drawn_otherwise_names_the_kind(self):
        v = lambda f, i, a: {'formal-reuse': f, 'interpretive': i, 'application': a, 'related': 0}
        self.assertEqual(spine.drawn_otherwise({('a', 'b'): v(3, 0, 3), ('c', 'd'): v(1, 0, 1), ('e', 'f'): v(20, 9, 9)})[:2], (2, 'a dotted application curve'))
        self.assertEqual(spine.drawn_otherwise({('a', 'b'): v(3, 5, 0)})[:2], (1, 'a dashed interpretive curve'))
        self.assertEqual(spine.drawn_otherwise({('a', 'b'): v(3, 5, 0), ('c', 'd'): v(3, 0, 1)})[:2], (2, 'a dashed or dotted curve of another kind'))
        self.assertEqual(spine.drawn_otherwise({('a', 'b'): v(12, 0, 0)})[0], 0)

    def test_every_word_in_the_pictures_is_at_least_13_px(self):
        g = (ROOT / 'theories/becoming/results/data/theory-graph.json').read_text(encoding='utf-8')
        pages, errors = spine.render(g)
        self.assertEqual(errors, [])
        for path in (spine.SVG['en'], spine.SVG['zh'], spine.FIRST['en'], spine.FIRST['zh']):
            sizes = [float(x) for x in re.findall(r'font-size="([0-9.]+)"', pages[path])]
            self.assertTrue(sizes and min(sizes) >= 13, (path, min(sizes)))

    def test_fronts_carry_the_short_key_under_the_picture(self):
        s = spine.spec()
        for path, lang in (('theories/becoming/ONE-PAGE.md', 'en'), ('theories/becoming/THE-THEORY-OF-BECOMING.md', 'en'),
                           ('theories/becoming/ONE-PAGE.zh.md', 'zh'), ('theories/becoming/THE-THEORY-OF-BECOMING.zh.md', 'zh')):
            text = (ROOT / path).read_text(encoding='utf-8')
            key = spine.picture_key(s, lang, path)
            self.assertIn(key, text, path)
            self.assertGreater(text.index(key), text.index('](results/spine'), path)  # the picture first, its key under it
            self.assertNotIn(spine.how_to_read(s, lang), text, path)  # the full paragraph is THEORY-GRAPH's
        # AG review, 9 November 2026: the key says first what is drawn (the grammar, the ring, the spokes, the theses by outcome),
        # then what a solid curve counts and who assigns its kind, then the standings; that the chapters are numbered for reading,
        # not as an order of proof, and that a spoke counts modules stay in the picture's own lines, and the cycle in
        # THEORY-GRAPH's paragraph (test_a_cycle_among_recorded_uses_is_found)
        for lang, kept in (('en', ('The grammar is at the centre and the eight chapters on a ring around it', 'core modules',
                                   'that the AI-written records class as formal-reuse (nothing checks a use against the Lean)',
                                   "darker where an earlier chapter's results use a later one's",
                                   'T1 to T8 stand at their homes, coloured by how their tests came out (T8, argued, has none)', '11 are [derived]',
                                   '1 is a root form', '6 are counting laws, below the grammar', '99 stand at a [named distance]', 'each with its reason',
                                   '#the-spine-what-it-shows-and-does-not-show')),
                           ('zh', ('文法在中央，八章围绕它排成一圈', '核心模块', '由 AI 写成的记录归为 formal-reuse 的次数（没有任何检查核对一次使用是否见于 Lean）',
                                   '章序在前的一章的结果使用章序在后的一章的结果时较深', 'T1 到 T8 位于其所属之处，按检验结局着色（T8 已论证，无检验）',
                                   '位于文法以下', '各有其理由', '11 项[推导而得]', '1 项为一个根形式', '6 项为计数之律', '99 项处于一个[指明的距离]',
                                   '#the-spine-what-it-shows-and-does-not-show'))):
            key = spine.picture_key(s, lang)
            for phrase in kept:
                self.assertIn(phrase, key, lang)
        for lang, numbering, spoke in (('en', 'not as an order of proof', 'It counts modules, not results derived'),
                                       ('zh', '不是证明的次序', '它计的是模块，不是推导而得的结果')):
            self.assertIn(numbering, spine.WORDS[lang]['numbering'], lang)
            self.assertIn(spoke, spine.WORDS[lang]['spoke'], lang)
        self.assertIn('About a tenth of the 117', spine.how_to_read(s, 'en'))
        self.assertIn('counting laws, below the grammar (6)', spine.how_to_read(s, 'en'))

    def test_the_chinese_page(self):
        page = spine.zh_page(graph())
        self.assertIn(zh_fronts.nav_line(spine.PAGE_ZH), page)
        self.assertIn('<a id="the-spine-what-it-shows-and-does-not-show"></a>', page)
        self.assertIn('| 根 | 生成、守与退化 | 12 | 0 | 0 | 0 |', page)
        self.assertIn('](spine.zh.svg)', page)
        self.assertRegex(page, r'\*约 [0-9–]+ 分钟读完。\*')

    def test_the_boxes_are_said_with_no_second_premise(self):
        # AG review, sixth pass (Ren, messages 10 and 11): C is no premise "for order" beside the condition. Seventh pass:
        # the boxes are what ranking results take as hypotheses (the condition held de se, self-concern, C), C a requirement
        # on an order; widening on a finite listing is what every additive weighting counting each listed item above zero
        # ranks higher, and ranking by it adds no premise beside a life's own concern; the ranking between level paths is of
        # courses whose admissions end, and that a life forms self-concern is not shown
        s = spine.spec()
        self.assertEqual([p['id'] for p in s['premises']], ['condition', 'self-concern', 'C'])
        self.assertEqual(spine.WORDS['en']['premises'], 'What ranking results take as hypotheses')
        lead = '\n'.join(spine.lead(graph(), 'theories/becoming/results/THEORY-GRAPH.md'))
        for new in ('The three boxes are what ranking results take as hypotheses',
                    'drawn as hypotheses and not as premises of the ethics',
                    'the requirement that an order rank each course above every course it widens',
                    'whose admissions fit in a finite list, so that their admissions end',
                    'that a life forms self-concern is not shown',
                    'every additive weighting counting each listed item above zero ranks higher, and ranking by it adds no premise '
                    "beside a life's own concern"):
            self.assertIn(new, lead)
        page = spine.zh_page(graph())
        for new in ('画作假设，不画作伦理的前提', '对次序的一项要求', '生命是否会形成自我关切，尚未表明',
                    '凡给每个所列之物一个大于零的权重、再把权重相加的计法，一致排得更高的，恰好就是扩大',
                    '按扩大排序，在生命自身的关切之外不另加前提'):
            self.assertIn(new, page)
        for old in ('C for order', 'for scope', 'between listed courses', 'no second premise', 'courses that end',
                    'every positive weighting', 'some formations hold', 'an order ranking a course above'):
            self.assertNotIn(old, lead)
        for old in ('定次序', '定范围', '列出的进程', '不是第二个前提', '某些形成所持', '每一个正的赋权都共同认可'):
            self.assertNotIn(old, page)

    def test_section_tables_every_pair_and_counts_what_is_not_drawn(self):
        g = graph()
        lines = spine.section(g, 'theories/becoming/results/THEORY-GRAPH.md')
        body = '\n'.join(lines)
        lead = '\n'.join(spine.lead(g, 'theories/becoming/results/THEORY-GRAPH.md'))
        self.assertIn('](spine.svg)', lead)
        self.assertIn('| derived | 11 |', lead)
        self.assertIn('| T6. ', lead)
        self.assertIn('| The root | The map | 12 | 0 | 0 | 0 |', body)
        self.assertIn('| The map | The root | 3 | 0 | 0 | 0 |', body)
        self.assertIn('| Life and evolution | The root | 0 | 0 | 0 | 1 |', body)
        self.assertIn('1 pair with fewer than 10 formal-reuse uses (3 uses)', body)
        start = next(i for i, l in enumerate(lines) if l.startswith('| Edges from results of'))
        rows = [l for l in lines[start + 2:] if l.startswith('| ')]
        total = sum(int(c) for l in rows for c in l.strip('|').split('|')[2:])
        kinds = sum(1 for e in g['edges'] if e['type'] in spine.KINDS)
        self.assertEqual(total, kinds)
        # each kind's matrix among the eight chapters agrees, cell by cell, with the list's pair for that row and column
        order = spine.spec()['order']
        names = [spine.theory_graph.REGION_TITLES[k].split(':')[0] for k in order]
        listed = {(c[0].strip(), c[1].strip()): c[2:] for c in (l.strip('|').split('|') for l in rows)}
        for i, kind in enumerate(spine.KINDS):
            m = lines.index(f'**{kind}**' + (' (analogy, not a dependence)' if kind == 'related' else ''))
            for a, line in zip(names, lines[m + 4:m + 4 + 8]):
                for b, cell in zip(names, (x.strip() for x in line.strip('|').split('|')[1:])):
                    want = int(listed[(a, b)][i]) if (a, b) in listed else 0
                    self.assertEqual(0 if cell == '·' else int(cell), want, (kind, a, b))


class Tables(unittest.TestCase):
    """The tables THEORY-GRAPH.md reads from 08 §7 and the edge record, against small inputs."""

    METHOD = ('<a id="shared-laws-and-connectivity"></a>\n## 7. Shared laws\n\n'
              '| Law | Statement | Anchor | On the grammar | Rows |\n|---|---|---|---|---:|\n'
              '| Closure | c | `W` | `«a»` | 4 |\n| Balance | b | `B` | represented both ways, not derived | 6 |\n\nNext.\n'
              'Of the 126 rows, 5 now reach the grammar: all 4 on closure and 2 of 6 on balance, and 1 on no anchor.\n\n## 8. Known\n'
              'Elsewhere, all 6 on balance.')

    def test_the_laws_table_and_how_many_reach_the_grammar(self):
        with mock.patch.object(spine, '_read', lambda path: self.METHOD if path == spine.METHOD else None):
            self.assertEqual(spine.shared_laws_rows(), [('Closure', 'c', False, 4), ('Balance', 'b', True, 6)])
            self.assertEqual(spine.reaching_the_grammar('Closure', 4), 4)
            self.assertEqual(spine.reaching_the_grammar('Balance', 6), 2)
            self.assertIsNone(spine.reaching_the_grammar('Balance', 7))  # the sentence no longer counts those rows
            self.assertEqual(spine.rows_reaching(), (5, 1))
            self.assertEqual(spine.shared_laws_cells(), [('Closure', '`«a»`'), ('Balance', 'represented both ways, not derived')])

    def test_check_stops_when_the_counts_the_page_reads_move(self):
        real, s = spine._read, spine.spec()
        record = {'boundary': {'standings': [
            {'declaration': f'Becoming.X.{k}', 'standing': 'derived', 'law': [], 'basis': {'en': 'A case.'}} for k in 'ab']}}

        def moved(path):
            if path == spine.METHOD:
                return real(path).replace('Of the 126 rows, ', 'Of the rows, ')
            if path == spine.EDGE_RECORD + '.json':
                return json.dumps(record)
            if str(path) == str(spine.registry.SHARED_LAWS):
                return json.dumps({'boundary': {'groups': {'on the edge': 2, 'distances': 97}}})
            return real(path)
        with mock.patch.object(spine, '_read', moved):
            errors = '\n'.join(spine.check(s))
        self.assertIn('no longer says how many of the 126 rows reach the grammar', errors)
        self.assertIn('the edge record has 2 derived declarations', errors)
        self.assertIn('the shared-laws data places 99 central declarations', errors)
        self.assertIn('after the eight connected rows', errors)

    def test_a_cycle_among_recorded_uses_is_found(self):
        g = {'edges': [{'from': 'a', 'to': 'b', 'type': 'formal-reuse'}, {'from': 'b', 'to': 'c', 'type': 'formal-reuse'},
                       {'from': 'c', 'to': 'a', 'type': 'formal-reuse'}, {'from': 'c', 'to': 'd', 'type': 'formal-reuse'},
                       {'from': 'd', 'to': 'a', 'type': 'related'}]}
        self.assertEqual(spine.formal_cycles(g), (4, 4, [['a', 'b', 'c']]))
        g['edges'] = g['edges'][1:]
        self.assertEqual(spine.formal_cycles(g), (3, 4, []))
        paragraph = '\n'.join(spine.circular_paragraph(g, 'en'))
        self.assertTrue(paragraph.startswith('<a id="do-the-recorded-uses-form-a-cycle"></a>'))
        self.assertIn('no result reaches itself', paragraph)
        self.assertIn('condition of entry, not a finding', paragraph)
        lead = '\n'.join(spine.lead(graph(), 'theories/becoming/results/THEORY-GRAPH.md'))  # the same page as how to read it
        self.assertIn('<a id="do-the-recorded-uses-form-a-cycle"></a>', lead)
        self.assertIn('condition of entry, not a finding', lead)
        self.assertIn('id="do-the-recorded-uses-form-a-cycle"', '\n'.join(spine.circular_paragraph(g, 'zh')))

    def test_a_law_in_english_from_its_docstring(self):
        lean = ('/-- Nothing within a closure bears the relation to what lies beyond it. Read through more. -/\n'
                'theorem «所闭之界» {R : X} : True := trivial\n\n'
                '/-- **Taking on, over `n` steps (承之迭).** Let each round hold. -/\ntheorem «承之迭» : True := trivial\n')
        with mock.patch.object(spine, '_read', lambda path: lean if path == spine.GRAMMAR_LAWS else None):
            self.assertEqual(spine.law_english('Becoming.«所闭之界»'), 'Nothing within a closure bears the relation to what lies beyond it')
            self.assertEqual(spine.law_english('«承之迭»'), 'Taking on, over `n` steps')
            self.assertEqual(spine.law_english('«无»'), '«无»')  # no docstring: the name itself
        lead = '\n'.join(spine.lead(graph(), 'theories/becoming/results/THEORY-GRAPH.md'))
        self.assertIn('Nothing within a closure bears the relation to what lies beyond it (`«所闭之界»`)', lead)

    def test_a_basis_is_cut_after_its_first_sentence_and_keeps_its_standing(self):
        record = {'boundary': {'standings': [
            {'declaration': 'Becoming.X.y', 'standing': 'derived', 'law': ['Becoming.L'],
             'basis': {'en': 'A case of «L» at x, through Steps.along. Its other step is support. Its statement still reads as counting.'}},
            {'declaration': 'Becoming.X.z', 'standing': 'derived', 'law': [], 'basis': {'en': 'A case, e.g. the run, of «L». Then more.'}},
            {'declaration': 'Becoming.X.w', 'standing': 'named distance', 'basis': {'en': 'Far.'}},
            {'declaration': 'Becoming.X.v', 'standing': 'counting'}]}}
        with mock.patch.object(spine, '_read', lambda path: json.dumps(record) if path.endswith('.json') else None), \
                mock.patch.object(spine, 'ROOT', Path('/nonexistent')):
            rows = spine.derived_rows()
            self.assertEqual(spine.edge_bases(), (3, 1))
        self.assertEqual(rows[0][2], 'A case of «L» at x, through Steps.along. … Its statement still reads as counting.')
        self.assertEqual(rows[1][2], 'A case, e.g. the run, of «L».')  # an abbreviation's point is not a sentence's end


if __name__ == '__main__':
    unittest.main()
