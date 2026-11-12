"""The map (map_sheet.py) against what it promises: an arrow joins boxes the sheet has; an arrow that names a law has
had a reader set its sentence against the Lean, and every law named is a declaration in the Lean; a name, a tag and a
law's sentence use no word that fits only a person; a step of a path is told and stands on something; a laid test is in
the tests table; an arrow is drawn in full along a row, between neighbouring rows or along a clear corridor, and is a
stub otherwise; the views are written from one build, the same bytes each time, in English and in Chinese; the site
publishes every view; and the repository's own data passes."""
import copy
import json
from pathlib import Path
import re
import sys
import unittest
from unittest import mock
from xml.etree import ElementTree

ROOT = Path(__file__).resolve().parents[3]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
from tools.research import map_sheet  # noqa: E402


def box(i, row, col, **more):
    return dict({'id': i, 'row': row, 'col': col, 'en': 'Box ' + i, 'zh': '方框' + i, 'says_en': 'It stands so.', 'says_zh': '它这样立着。',
                 'eg_en': 'Such as a well.', 'eg_zh': '比如一口井。', 'known_en': [], 'known_zh': [], 'anchors': [], 'dynamics': [], 'wanted': False}, **more)


def arrow(a, b, kind='law', **more):
    return dict({'from': a, 'to': b, 'kind': kind, 'tag_en': 'it runs down', 'tag_zh': '它往下走', 'en': 'Where it is taken, it runs down.', 'zh': '被取的时候，它往下走。',
                 'laws': [] if kind in ('reading', 'same') else ['Becoming.X.law'], 'readers': 0 if kind in ('reading', 'same') else 2, 'more': []}, **more)


def data(**change):
    d = {'sheet': {'lead_en': 'A map.', 'lead_zh': '一张图。', 'bands': [{'id': 'A', 'en': 'First', 'zh': '一'}, {'id': 'B', 'en': 'Second', 'zh': '二'}],
                   'rows': [{'id': 'r1', 'band': 'A', 'en': 'Row one', 'zh': '第一行'}, {'id': 'r2', 'band': 'A', 'en': 'Row two', 'zh': '第二行'},
                            {'id': 'r3', 'band': 'B', 'en': 'Row three', 'zh': '第三行'}, {'id': 'r4', 'band': 'B', 'en': 'Row four', 'zh': '第四行'}],
                   'web': [{'en': ['a', 'ties to', 'b'], 'zh': ['甲', '连着', '乙'], 'rows': ['r1']}],
                   'boxes': [box('a', 'r1', 1), box('b', 'r1', 2), box('c', 'r1', 3), box('d', 'r2', 2), box('e', 'r3', 1), box('f', 'r4', 2), box('g', 'r4', 3)]},
         'passages': {'passages': [arrow('a', 'b'), arrow('a', 'c', 'needs'), arrow('b', 'd', 'line'), arrow('a', 'f', 'built'), arrow('c', 'g', 'reading'), arrow('f', 'e', 'same')],
                      'stays': [{'at': 'b', 'en': 'It stays.', 'zh': '它留着。', 'laws': ['Becoming.X.stays']}]},
         'paths': {'paths': [{'id': 'down', 'bands': ['A'], 'en': 'Down', 'zh': '往下', 'lead_en': 'It goes down.', 'lead_zh': '往下走。',
                              'sections': [{'en': 'First', 'zh': '先', 'tone': 'close', 'steps': [{'say_en': 'It stands.', 'say_zh': '它立着。', 'on': ['box:a']},
                                                                                                    {'say_en': 'It runs down.', 'say_zh': '它往下走。', 'on': ['a>b', 'stay:b'], 'eg': 'b'}]},
                                           {'en': 'Then', 'zh': '再', 'tone': 'turn', 'steps': [{'say_en': 'A line.', 'say_zh': '一条界线。', 'on': ['d>b'], 'test': {'case': 'well', 'en': 'Laid on a well.', 'zh': '放到一口井上。'}}]}],
                              'shows_en': ['Proved (step 2).'], 'shows_zh': ['已证明的（第 2 步）。'], 'want_en': '', 'want_zh': ''}]},
         'laid': {'tests': [{'id': 'well', 'test': 'T1', 'setting': 'built', 'en': 'A well', 'zh': '一口井', 'line_en': 'It ran down, as said.', 'line_zh': '它往下走了，和推理说的一样。', 'what_en': 'A well.', 'what_zh': '一口井。', 'said_en': 'It runs down.', 'said_zh': '它往下走。',
                             'seen_en': 'It ran down.', 'seen_zh': '它往下走了。', 'broke_en': 'Nothing.', 'broke_zh': '没有。', 'after_en': 'Nothing.', 'after_zh': '没有。',
                             'rival_en': 'None.', 'rival_zh': '没有。',
                             'pins': [{'at': 'a', 'how': 'found', 'agree': 'yes', 'en': 'The well', 'zh': '那口井', 'short_en': 'ran down', 'short_zh': '往下走了', 'seen_en': 'ran down', 'seen_zh': '往下走了'},
                                      {'at': 'b', 'how': 'built', 'agree': 'no', 'found_at': 'c', 'en': 'The pump', 'zh': '那台泵', 'short_en': 'held', 'short_zh': '守住了', 'seen_en': 'held', 'seen_zh': '守住了'}],
                             'used': ['a>b'], 'gave': [{'pin': 2}, {'passage': 'a>b'}], 'view': {'at': 'e', 'en': 'Checked.', 'zh': '对过了。'}}]}}
    for path, value in change.items():
        at = d
        *keys, last = path.split('__')
        for k in keys:
            at = at[int(k)] if k.isdigit() else at[k]
        at[int(last) if last.isdigit() else last] = value
    return d


def errors(d, **kw):
    return ' | '.join(map_sheet.validate(d, **kw))


class ValidationTests(unittest.TestCase):
    def test_a_sheet_that_holds_together_passes(self):
        self.assertEqual(map_sheet.validate(data(), dyn_ids=set(), test_ids={'T1'}, lean={'law', 'stays'}), [])

    def test_an_arrow_joins_boxes_the_sheet_has(self):
        self.assertIn('passage a>z: unknown box', errors(data(passages__passages__0=arrow('a', 'z'))))
        self.assertIn('passage a>a: from a box to itself', errors(data(passages__passages__0=arrow('a', 'a'))))
        self.assertIn('passage a>c: listed twice', errors(data(passages__passages__0=arrow('a', 'c'))))

    def test_an_arrow_that_names_a_law_has_had_a_reader(self):
        self.assertIn('passage a>b: names a law and no reader has set its sentence against the Lean', errors(data(passages__passages__0=arrow('a', 'b', readers=0))))
        self.assertEqual(errors(data(passages__passages__0=arrow('a', 'b', readers=1))), '')

    def test_an_arrow_drawn_as_proved_names_a_law_and_a_reading_need_not(self):
        self.assertIn('passage a>b: drawn as law and names no law', errors(data(passages__passages__0=arrow('a', 'b', laws=[]))))
        self.assertEqual(errors(data(passages__passages__4=arrow('c', 'g', 'reading'))), '')
        self.assertIn('unknown kind route', errors(data(passages__passages__0=arrow('a', 'b', 'route'))))

    def test_a_law_named_is_a_declaration_in_the_lean(self):
        self.assertIn('passage a>b: Becoming.X.law is not a declaration in the Lean', errors(data(), lean={'stays'}))
        names = map_sheet.lean_names()
        self.assertIn('lock_outlives_loss', names)   # a theorem by its last name
        self.assertIn('Unread', names)               # a definition

    def test_a_word_that_fits_only_a_person_stops_the_render(self):
        self.assertIn('passage a>b: tag_en uses a word that fits only a person', errors(data(passages__passages__0=arrow('a', 'b', tag_en='someone takes it'))))
        self.assertIn('passage a>b: zh uses a word that fits only a person', errors(data(passages__passages__0=arrow('a', 'b', zh='谁都在取。'))))
        self.assertIn('box a: its name uses a word that fits only a person', errors(data(sheet__boxes__0=box('a', 'r1', 1, en='What people take'))))
        self.assertEqual(errors(data(passages__passages__0=arrow('a', 'b', zh='这是人为设定的。'))), '')  # 人为 is said of a set-up, not of a person
        self.assertEqual(errors(data(passages__passages__0=arrow('a', 'b', en='A ring whose links pass it on.'))), '')

    def test_two_boxes_do_not_share_a_cell_and_a_band_keeps_its_rows_together(self):
        self.assertIn('box b: shares a cell with a', errors(data(sheet__boxes__1=box('b', 'r1', 1))))
        d = data()
        d['sheet']['rows'][1]['band'] = 'B'; d['sheet']['rows'][2]['band'] = 'A'
        self.assertIn('the rows of band A are not together', errors(d))

    def test_a_step_is_told_and_stands_on_something_the_sheet_has(self):
        self.assertIn('path down step 1: stands on nothing', errors(data(paths__paths__0__sections__0__steps__0={'say_en': 'x', 'say_zh': 'x', 'on': []})))
        self.assertIn('path down step 1: not told', errors(data(paths__paths__0__sections__0__steps__0={'say_en': '', 'say_zh': 'x', 'on': ['box:a']})))
        self.assertIn('path down step 1: no passage b>c', errors(data(paths__paths__0__sections__0__steps__0={'say_en': 'x', 'say_zh': 'x', 'on': ['b>c']})))
        self.assertIn('path down step 1: nothing is said of staying at a', errors(data(paths__paths__0__sections__0__steps__0={'say_en': 'x', 'say_zh': 'x', 'on': ['stay:a']})))
        self.assertEqual(errors(data()), '')  # the third step names the line b>d the other way round

    def test_a_name_a_path_gives_stands_at_a_box_on_the_path_that_carries_a_name_others_gave(self):
        def named(at):
            d = data(sheet__boxes__0=box('a', 'r1', 1, known_en=['The well of the proverb'], known_zh=['俗话里的井']),
                     sheet__boxes__6=box('g', 'r4', 3, known_en=['The far well'], known_zh=['远处的井']))
            d['paths']['paths'][0]['known'] = [{'at': at, 'en': 'the well', 'zh': '井'}]
            return d
        self.assertNotIn('a name it gives', errors(named('a')))
        self.assertIn('path down: a name it gives stands at g, which is not on the path', errors(named('g')))
        self.assertIn('path down: a name it gives stands at b, which carries no name others gave', errors(named('b')))
        m = map_sheet.build(named('a'))
        self.assertEqual(map_sheet._known(m, m['paths'][0], 'zh'), ['井'])

    def test_an_id_and_a_text_cannot_break_the_page(self):
        self.assertIn("box 'a b': an id is letters, digits, dots, dashes and underscores", errors(data(sheet__boxes__0=box('a b', 'r1', 1))))
        self.assertIn('holds markup characters', errors(data(sheet__lead_en='A <b>map</b>.')))
        self.assertIn('holds markup characters', errors(data(laid__tests__0__what_en='See [this](that).')))

    def test_a_path_names_its_bands_and_a_test_has_pins(self):
        self.assertIn('path down: no bands', errors(data(paths__paths__0__bands=[])))
        self.assertIn('test well: no pins, or no test named', errors(data(laid__tests__0__pins=[])))

    def test_a_further_way_of_an_arrow_is_held_to_the_same_words(self):
        more = arrow('a', 'b', more=[dict(arrow('a', 'b'), en='Where someone takes it, it runs down.')])
        self.assertIn('passage a>b: a further way uses a word that fits only a person', errors(data(passages__passages__0=more)))

    def test_a_name_at_a_box_the_sheet_lacks_is_an_error_not_a_crash(self):
        d = data()
        d['paths']['paths'][0]['sections'][0]['steps'][0]['on'] = ['box:zz']
        d['paths']['paths'][0]['known'] = [{'at': 'zz', 'en': 'the well', 'zh': '井'}]
        self.assertIn('unknown box box:zz', errors(d))

    def test_a_path_s_cast_is_filled_in_both_languages(self):
        d = data()
        d['paths']['paths'][0]['cast'] = [{'en': 'the well', 'zh': '井', 'says_en': 'what is drawn from.', 'says_zh': ''}]
        self.assertIn('path down: an entry of its cast is not filled', errors(d))
        d['paths']['paths'][0]['cast'][0]['says_zh'] = '被取用的。'
        self.assertNotIn('cast', errors(d))
        m = map_sheet.build(d)
        self.assertEqual(map_sheet._cast(m['paths'][0], 'zh')[2], '- **井**：被取用的。')

    def test_a_laid_test_says_where_it_was_run(self):
        self.assertIn('test well: its setting is built or field', errors(data(laid__tests__0__setting='lab')))

    def test_a_laid_test_says_in_a_sentence_what_was_seen(self):
        self.assertIn('test well: no line_en', errors(data(laid__tests__0__line_en=' ')))

    def test_a_laid_test_is_in_the_tests_table_and_pins_boxes_the_sheet_has(self):
        self.assertIn('test well: T1 is not in the tests table', errors(data(), test_ids={'T2'}))
        self.assertIn('test well: T9 (round 2) is not in the tests table', errors(data(laid__tests__0__records=['T1', 'T9 (round 2)']), test_ids={'T1'}))
        self.assertIn('test well pin 1: unknown box z', errors(data(laid__tests__0__pins__0__at='z')))
        self.assertIn('test well: gave way at a pin it does not have', errors(data(laid__tests__0__gave=[{'pin': 3}])))
        self.assertIn('test well: no passage b>c', errors(data(laid__tests__0__used=['b>c'])))

    def test_a_box_at_a_dynamic_the_atlas_lacks_is_an_error(self):
        self.assertIn('box a: gone is not a dynamic of the atlas', errors(data(sheet__boxes__0=box('a', 'r1', 1, dynamics=['gone'])), dyn_ids={'here'}))


class BuildTests(unittest.TestCase):
    def setUp(self):
        self.m = map_sheet.build(data())
        self.p = {p['key']: p for p in self.m['geo']['P']}

    def test_an_arrow_is_drawn_in_full_only_where_no_box_lies_under_its_line(self):
        cls = {k: p['cls'] for k, p in self.p.items()}
        self.assertEqual(cls['a>b'], 'adj')     # neighbours in a row
        self.assertEqual(cls['a>c'], 'arc')     # along a row, over a box
        self.assertEqual(cls['b>d'], 'near')    # between neighbouring rows
        self.assertEqual(cls['a>f'], 'far')     # three rows apart, nothing clear: a stub at each end
        self.assertEqual(cls['c>g'], 'far')     # the same column, and no neighbouring column is clear
        self.assertEqual(cls['f>e'], 'near')
        self.assertEqual({k for k, p in self.p.items() if p['far']}, {'a>f', 'c>g'})
        for p in self.p.values():
            self.assertEqual('stub' in p, p['far'], p['key'])
            self.assertRegex(p['d'], r'^M[-\d.]+ [-\d.]+ ')

    def test_a_clear_corridor_carries_an_arrow_two_rows_apart(self):
        d = data()
        d['sheet']['boxes'] = [box('a', 'r1', 1), box('b', 'r3', 2)]
        d['passages'] = {'passages': [arrow('a', 'b')], 'stays': []}
        d['paths'] = {'paths': []}; d['laid'] = {'tests': []}
        p = map_sheet.build(d)['geo']['P'][0]
        self.assertEqual((p['cls'], p['far']), ('ell-to', False))
        d['sheet']['boxes'] += [box('c', 'r2', 2), box('d', 'r2', 1)]   # now a box lies in each corridor
        self.assertEqual(map_sheet.build(d)['geo']['P'][0]['cls'], 'far')

    def test_a_path_is_numbered_through_its_sections_and_knows_what_it_lights(self):
        path = self.m['paths'][0]
        self.assertEqual([st['n'] for S in path['sections'] for st in S['steps']], [1, 2, 3])
        self.assertEqual(path['cset'], ['a', 'b', 'd'])
        self.assertEqual(path['pset'], sorted([self.p['a>b']['id'], self.p['b>d']['id']]))
        self.assertEqual(path['tones'][self.p['b>d']['id']], 'turn')
        self.assertEqual([n for n, _tone, _at, _soft in path['badges']], [1, 2, 3])

    def test_a_path_s_picture_shows_its_bands_and_names_the_box_a_lit_arrow_leaves_for(self):
        d = data()
        d['paths']['paths'][0]['sections'][0]['steps'].append({'say_en': 'It leaves.', 'say_zh': '它离开。', 'on': ['c>g']})
        m = map_sheet.build(d)
        self.assertTrue(next(p for p in m['geo']['P'] if p['key'] == 'c>g')['far'])
        svg = map_sheet.path_picture(m, m['paths'][0], 'en')
        self.assertRegex(svg, r'class="edge k-reading far[^"]* cut"')       # the arrow is a stub, not a line off the edge
        self.assertIn('→ Box g', svg)                                        # and says where it leads
        self.assertNotIn(' cut"', map_sheet.chart(m['geo'], focus=m['paths'][0]))   # on the whole map it is drawn in full
        top = lambda s: float(re.search(r'viewBox="0 (\S+) ', s).group(1))
        self.assertEqual(top(svg), 0)
        self.assertGreater(top(map_sheet.chart(m['geo'], crop=['B'])), 0)    # a lower band's picture starts at that band

    def test_a_step_whose_arrow_leaves_the_picture_is_numbered_at_its_stub_and_one_drawn_in_full_is_an_error(self):
        d = data()
        d['paths']['paths'][0]['sections'][0]['steps'].append({'say_en': 'It leaves.', 'say_zh': '它离开。', 'on': ['c>g']})
        m = map_sheet.build(d)
        self.assertEqual(map_sheet.built_errors(m), [])
        far = next(p for p in m['geo']['P'] if p['key'] == 'c>g')
        at = next(a for n, _tone, a, _soft in m['paths'][0]['badges'] if n == 3)
        self.assertEqual(at, (far['tips'][0][0] - 12, far['tips'][0][1]))
        d['paths']['paths'][0]['sections'][0]['steps'][-1]['on'] = ['box:g']
        self.assertIn("path down step 3: g lies outside the path's bands", ' | '.join(map_sheet.built_errors(map_sheet.build(d))))

    def test_a_step_that_is_not_proved_of_the_course_itself_has_a_hollow_number(self):
        d = data()
        d['paths']['paths'][0]['sections'][0]['steps'].append({'say_en': 'It is given.', 'say_zh': '这是给定的。', 'on': ['a>c']})   # a>c is drawn as needs
        m = map_sheet.build(d)
        self.assertEqual([soft for _n, _tone, _at, soft in m['paths'][0]['badges']], [False, False, True, False])
        self.assertEqual(map_sheet.path_picture(m, m['paths'][0], 'en').count('class="badge soft '), 1)

    def test_a_laid_test_shows_the_bands_it_touches(self):
        t = self.m['tests'][0]
        self.assertEqual(t['bands'], ['A', 'B'])     # its view stands in the second band
        self.assertEqual([pin['n'] for pin in t['pins']], [1, 2])
        self.assertEqual(t['gave'], [{'pin': 2}, {'p': self.p['a>b']['id']}])

    def test_the_counts_say_how_each_arrow_was_read(self):
        c = self.m['counts']
        self.assertEqual((c['boxes'], c['rows'], c['arrows'], c['two'], c['one'], c['nolean']), (7, 4, 6, 4, 0, 2))
        self.assertEqual(c['along'], {'right/law': 1, 'right/needs': 1})


class RepositoryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        (cls.d, cls.dyn, cls.tests), errs = map_sheet.load()
        assert not errs, errs
        cls.m = map_sheet.build(cls.d); cls.m['dyn_names'] = cls.dyn; cls.m['totals'] = map_sheet.totals()
        cls.pages, cls.errors = map_sheet.render()

    def test_the_repository_s_map_passes_and_every_law_it_names_is_in_the_lean(self):
        self.assertEqual(self.errors, [])
        self.assertEqual(map_sheet.validate(self.d, dyn_ids=set(self.dyn), test_ids=self.tests, lean=map_sheet.lean_names()), [])

    def test_the_views_are_the_page_its_two_pages_of_detail_the_pictures_and_the_map_to_operate_in_both_languages(self):
        want = {map_sheet.INTERACTIVE}
        for lang in ('en', 'zh'):
            want |= {map_sheet.PAGE[lang], map_sheet.PLACES[lang], map_sheet.PATHS_PAGE[lang], map_sheet.PICTURE[lang]}
            want |= {map_sheet.path_picture_file(p['id'], lang) for p in self.m['paths']}
        self.assertEqual(set(self.pages), want)
        again, errs = map_sheet.render()
        self.assertEqual((errs, again), ([], self.pages))  # the same bytes each time
        self.assertEqual([str(p) for p in map_sheet.inputs() if not p.is_file()], [])

    def test_the_page_opens_with_what_the_map_is_of_and_tells_its_first_path(self):
        page = self.pages[map_sheet.PAGE['en']]
        self.assertIn(map_sheet.GENERATED, page)
        self.assertIn(self.d['sheet']['lead_en'], page.split('## ')[0])
        first = self.m['paths'][0]
        for S in first['sections']:
            for st in S['steps']:
                self.assertIn('%d. %s' % (st['n'], st['say_en']), page)
        read = re.sub(r'<details>.*?</details>', '', page, flags=re.S)      # what a reader meets without opening a fold
        self.assertLess(len(read.split()), 4400)      # about eighteen minutes; the table at its foot and the tests' lines are a third of it
        self.assertIn('## The other paths', page)  # the home's card times the page up to here
        zh = self.pages[map_sheet.PAGE['zh']]
        self.assertIn(self.d['sheet']['lead_zh'], zh)
        self.assertIn('[English](THE-MAP.md)', zh)

    def test_every_box_and_every_arrow_has_its_place_on_the_page_of_places_in_both_languages(self):
        for lang in ('en', 'zh'):
            places = self.pages[map_sheet.PLACES[lang]]
            self.assertEqual(sorted(re.findall(r'^<a id="(box-[^"]+)"></a>$', places, re.M)), sorted('box-' + b['id'].replace('.', '-') for b in self.d['sheet']['boxes']))
            for p in self.d['passages']['passages']:
                self.assertIn(p['zh'] if lang == 'zh' else p['en'], places, p['from'] + '>' + p['to'])
            paths = self.pages[map_sheet.PATHS_PAGE[lang]]
            self.assertEqual(sorted(re.findall(r'^<a id="(?:path|test)-([^"]+)"></a>$', paths, re.M)), sorted([p['id'] for p in self.m['paths']] + [t['id'] for t in self.m['tests']]))

    def test_the_pages_link_one_another_at_anchors_that_exist(self):
        from tools.research import reading_catalogue, research
        self.assertEqual(research.check_links(self.pages, set(self.pages) | {map_sheet.LEDGER, map_sheet.LAWS_PAGE, map_sheet.DYNAMICS_PAGE, map_sheet.CASES_PAGE}), [])
        pages = {p.rsplit('/', 1)[1]: body for p, body in self.pages.items() if p.endswith('.md')}
        anchors = {name: reading_catalogue.anchors_from_text(body) for name, body in pages.items()}
        missing = [f'{name}: {target}#{anchor}' for name, body in pages.items()
                   for target, anchor in re.findall(r'\]\(((?:THE-MAP|PLACES|PATHS)(?:\.zh)?\.md)?#([^)\s]+)\)', body)
                   if anchor not in anchors[target or name]]
        self.assertEqual(missing, [])

    def test_each_picture_is_one_drawing_that_stands_alone(self):
        for name, body in self.pages.items():
            if name.endswith('.svg'):
                svg = ElementTree.fromstring(body)
                ns = '{http://www.w3.org/2000/svg}'
                texts = {''.join(t.itertext()) for t in svg.iter(ns + 'text')}
                self.assertTrue(any(b['zh'] in texts for b in self.d['sheet']['boxes']), name)
                self.assertNotRegex(body, r'href="http|<script|id="sheet"')
        lock = self.pages[map_sheet.path_picture_file(self.m['paths'][0]['id'], 'en')]
        self.assertEqual(len(re.findall(r'<g class="badge ', lock)), self.m['paths'][0]['n'])  # every step of the first path is numbered on its picture

    def test_the_map_to_operate_is_one_document_the_site_takes(self):
        from tools.publishing import build_site
        document = self.pages[map_sheet.INTERACTIVE]
        self.assertLess(len(document.encode('utf-8')), map_sheet.MAX_INTERACTIVE)
        self.assertLess(map_sheet.MAX_INTERACTIVE, build_site.MAX_PAGE)
        self.assertTrue(document.startswith('<!doctype html>\n<html lang="en">\n<head>\n<meta charset="utf-8">'))
        self.assertNotRegex(document, r'/\*[A-Z]+\*/')  # every place of the template is filled
        outside = [u for u in re.findall(r'\b(?:src|href)="([^"]+)"', document) if not u.startswith(('#', map_sheet.SITE))]
        self.assertEqual(outside, [])  # no font, script or style from elsewhere: its links go to the reader's site
        self.assertNotRegex(document, r'@import|url\(\s*["\']?https?:|<link\b|<script\b[^>]*\bsrc=')
        self.assertIsNone(build_site.LOCAL_PATH.search(document))
        written = [x.lower() for x in self.pages if not x.endswith('.md')] + [x[:-3].lower() + '.html' for x in self.pages if x.endswith('.md')]
        written += [x[:-3].lower() + '.html' for x in (map_sheet.LEDGER, map_sheet.LAWS_PAGE, map_sheet.DYNAMICS_PAGE, map_sheet.CASES_PAGE)]
        self.assertEqual(len(set(written)), len(written))  # a name that differs from another only by case would be one file on a disk blind to case
        data = json.loads(re.search(r'const D = (\{.*\});\n', document).group(1))
        self.assertEqual(data['counts'], self.m['counts'])
        self.assertEqual(len(data['passages']), len(self.d['passages']['passages']))
        self.assertEqual([p['id'] for p in data['paths']], [p['id'] for p in self.d['paths']['paths']])

    def test_a_map_to_operate_too_large_for_the_site_stops_the_render(self):
        with mock.patch.object(map_sheet, 'MAX_INTERACTIVE', 1000):
            pages, errs = map_sheet.render()
        self.assertEqual(pages, {})
        self.assertRegex(' '.join(errs), 'interactive.html: \\d+ bytes, over 1000')

    def test_the_site_publishes_every_view_and_its_navigation_names_the_map(self):
        site = json.loads((ROOT / '_process/research-config.json').read_text(encoding='utf-8'))['site']
        for name in self.pages:
            self.assertIn(name, site['pages'] if name.endswith('.md') else site['assets'], name)
        self.assertIn([map_sheet.PAGE['en'], 'Map'], site['nav'])
        self.assertIn([map_sheet.PAGE['zh'], '地图'], site['nav_zh'])
        card = next(w for w in site['ways_in'] if w['path'] == map_sheet.PAGE['en'])
        self.assertIn(card['time_until'], self.pages[map_sheet.PAGE['en']])  # the card says what its time is of
        self.assertEqual(card['zh'], map_sheet.PAGE['zh'])

    def test_what_the_page_says_of_itself_is_counted_from_the_data(self):
        c = self.m['counts']
        P = self.d['passages']['passages']
        self.assertEqual(c['arrows'], len(P))
        self.assertEqual(c['two'] + c['one'] + c['nolean'], len(P))
        self.assertEqual(c['one'], sum(1 for p in P if p['laws'] and p['readers'] == 1))
        page = self.pages[map_sheet.PAGE['en']]
        self.assertIn('| The %d arrows: the full sentence of each |' % c['arrows'], page)
        self.assertIn('%d by a second AI reader, who corrected most; %d by their one reader' % (c['two'], c['one']), page)
        self.assertIn('| The %d boxes, with their sentences and examples |' % c['boxes'], page)
        self.assertIn('Drawn so far: %d boxes on %d rows, %d paths told step by step, %d tests laid on them.' % (c['boxes'], c['rows'], c['paths'], c['tests']), page)
        self.assertEqual(c['records'], len({rec for t in self.d['laid']['tests'] for rec in t.get('records', [t['test']])}))
        self.assertIn('%d are tied to a definition or a law in the Lean' % c['anchored'], page)
        tot = map_sheet.totals()
        self.assertEqual(tot['all_tests'], len(self.tests))
        self.assertEqual(tot['dynamics'], len(self.dyn))
        self.assertIn('%d of its %d tests' % (tot['all_tests'] - c['records'], tot['all_tests']), page)   # counted by rows of the tests table: one laid test can carry two
        self.assertIn('The %d tests laid on the map (%d rows of' % (c['tests'], c['records']), page)
        self.assertIn('most of the %d ways out of a condition and the %d passages between conditions' % (tot['exits'], tot['transitions']), page)

    def test_what_the_whole_map_says_of_its_arrows_along_a_row_is_what_the_counts_give(self):
        # the page: most that run right are laws of the course itself; most that run back need something given, or are built
        along = self.m['counts']['along']
        right = {k[6:]: v for k, v in along.items() if k.startswith('right/')}
        left = {k[5:]: v for k, v in along.items() if k.startswith('left/')}
        self.assertGreater(right.get('law', 0), sum(right.values()) / 2)
        self.assertGreater(left.get('needs', 0) + left.get('built', 0), sum(left.values()) / 2)

    def test_every_step_of_every_path_lies_in_the_picture_of_its_path(self):
        self.assertEqual(map_sheet.built_errors(self.m), [])


if __name__ == '__main__':
    unittest.main()
