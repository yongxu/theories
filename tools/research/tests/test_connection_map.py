import contextlib
import html
import io
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT))
from tools.research import connection_map as cm, registry, theory_graph  # noqa: E402

VOCABULARY = {'relations': [{'en': 'agreement', 'zh': '相合'}, {'en': 'divergence', 'zh': '相分'}],
              'carried': [{'en': c} for c in ('carried', 'not-carried', 'history-only', 'fresh-reading')],
              'agreement_of': [{'en': a} for a in ('law', 'thesis-or-method', 'reading')]}
GRAPH = {'nodes': [{'id': 'result:r1', 'type': 'result', 'record': 'r1', 'status': 'recorded-checked', 'kind': 'theorem', 'title': 'Law one'},
                   {'id': 'section:' + cm.BECOMING + 'chapters/02-MAP.md#r-r1', 'type': 'section'},
                   {'id': 'text:A', 'type': 'text'}, {'id': 'text:B', 'type': 'text'}, {'id': 'text:C', 'type': 'text'}, {'id': 'text:D', 'type': 'text'}],
         'edges': [{'type': 'states', 'from': 'section:' + cm.BECOMING + 'chapters/02-MAP.md#r-r1', 'to': 'result:r1'},
                   {'type': 'read-as', 'from': 'text:A', 'to': 'result:r1', 'outcome': 'proved'},
                   {'type': 'read-as', 'from': 'text:B', 'to': 'result:r1', 'outcome': 'not expressible'},
                   {'type': 'names', 'from': 'text:C', 'to': 'concept:x'}],
         'classified_total': 9}
SHARED = {'boundary': {'counts': {'derived': 2, 'counting': 1, 'connected': 3, 'unplaced': 0}, 'groups': {'on the edge': 2, 'below the grammar': 1, 'distances': 3, 'unplaced': 0}},
          'central_reach': {'counts': {'reaching the grammar': 4, 'the rest': 2}}}


def entry(id_, group, carried='carried', relation='agreement', record='r1', basis='read-in-repo', of='law', role='carries', same_as=None):
    targets = [{'record': record, 'role': role, 'says': {'en': 'It says.'}}] if record else []
    return {'id': id_, 'name': {'en': id_}, 'group': group, 'carried': carried, 'relation': relation, 'agreement_of': of if relation == 'agreement' else None,
            'same_as': same_as, 'sense': {'en': 'Sense.'}, 'quote': None,
            'reading': {'en': 'Read.'}, 'source': {'work': 'a.md', 'locator': 'head', 'basis': basis}, 'account_adds': None, 'source_adds': None,
            'absence': {'searched': ['x'], 'read': []} if carried in cm.ABSENT else None, 'targets': targets}


def group(id_, domain):
    return {'id': id_, 'title': {'en': id_}, 'domain': domain, 'kind': 'theory', 'summary': {'en': 'S.'}, 'read': ['a'], 'skimmed': [], 'searched': [],
            'not_mapped': [], 'coverage': None, 'by_carried': {}, 'by_relation': {}, 'by_agreement_of': {}}


def atlas(*entries):
    return {'vocabulary': VOCABULARY, 'dynamics': [], 'correspondences': list(entries),
            'correspondence_groups': [group('cxg-early', 'earlier-folders'), group('cxg-greek', 'greek-roman')]}


class PayloadTests(unittest.TestCase):
    def data(self, *entries):
        return cm.payload(atlas(*entries), GRAPH, SHARED)

    def test_a_record_target_is_threaded_to_the_chapter_that_states_it(self):
        d = self.data(entry('cx-a', 'cxg-early'))
        self.assertEqual(d['entries'][0]['warps'], ['ch-02'])
        self.assertEqual([(w['id'], w['n']) for w in d['warp']], [('ch-02', 1)])
        self.assertEqual(d['entries'][0]['targets'][0]['status'], 'recorded-checked')

    def test_what_stayed_behind_is_counted_and_reaches_nothing(self):
        d = self.data(entry('cx-a', 'cxg-early'), entry('cx-b', 'cxg-early', 'not-carried', None, None), entry('cx-c', 'cxg-early', 'history-only', 'agreement'))
        self.assertEqual(d['totals']['loose'], 2)
        self.assertEqual(d['groups'][0]['loose'], 2)
        self.assertEqual([(w['id'], w['n']) for w in d['warp']], [('ch-02', 1)])
        self.assertNotIn('agreement-of-loose', d['totals']['relation'])
        self.assertEqual(d['totals']['relation'], {'agreement': 1})

    def test_meeting_needs_two_groups_and_marks_a_difference(self):
        d = self.data(entry('cx-a', 'cxg-early'), entry('cx-b', 'cxg-early'))
        self.assertEqual((d['points'], d['single']), ([], 1))
        d = self.data(entry('cx-a', 'cxg-early'), entry('cx-b', 'cxg-greek', 'fresh-reading', 'divergence', basis='ai-knowledge'))
        self.assertEqual([(p['key'], p['groups'], p['differ']) for p in d['points']], [('r1', 2, True)])
        self.assertEqual(d['totals']['from_knowledge'], 1)

    def test_only_a_carrying_target_draws_a_thread_or_a_meeting(self):
        d = self.data(entry('cx-a', 'cxg-early', role='neighbour', of='reading'), entry('cx-b', 'cxg-greek', role='limit', of='reading'))
        self.assertEqual(d['warp'], [])
        self.assertEqual(d['points'], [])
        self.assertEqual(d['totals']['unwarped'], 2)
        self.assertEqual(d['entries'][0]['targets'][0]['role'], 'neighbour')

    def test_agreement_is_counted_by_what_it_is_with(self):
        d = self.data(entry('cx-a', 'cxg-early'), entry('cx-b', 'cxg-early', of='reading'), entry('cx-c', 'cxg-greek', 'fresh-reading', of='thesis-or-method'))
        self.assertEqual(d['totals']['agreement_of'], {'law': 1, 'reading': 1, 'thesis-or-method': 1})

    def test_a_claim_in_two_rows_counts_once(self):
        d = self.data(entry('cx-a', 'cxg-early', same_as=['cx-b']), entry('cx-b', 'cxg-greek', same_as=['cx-a']), entry('cx-c', 'cxg-greek'))
        self.assertEqual((d['totals']['entries'], d['totals']['distinct']), (3, 2))

    def test_the_checks_reach_the_page(self):
        a = atlas()
        a['crosswalk_checks'] = {'second_critic': {'sampled': 10, 'estimate_percent': {'holds': 80.0, 'label': 12.5, 'fails': 7.5}}}
        self.assertEqual(cm.payload(a, GRAPH, SHARED)['checks']['second_critic']['sampled'], 10)
        self.assertIsNone(self.data()['checks'])

    def test_the_standings_are_read_from_the_data_and_a_zero_is_left_out(self):
        d = self.data()
        self.assertEqual(d['declarations'], 6)
        self.assertEqual([(g['title'], g['n']) for g in d['standings']],
                         [('On the edge', 2), ('Below the grammar', 1), ('At a named distance, each with its reason', 3)])
        self.assertEqual([r['key'] for r in d['reach']], ['reaching the grammar', 'the rest'])

    def test_the_corpus_counts_come_from_the_edges(self):
        self.assertEqual(self.data()['corpus'], {'classified': 9, 'stating': 4, 'law': 1, 'no_law': 1, 'cited': 1, 'only': 1})


class LiveDataTests(unittest.TestCase):
    def test_every_standing_and_reach_in_the_data_is_worded(self):
        shared = json.loads((ROOT / cm.registry.SHARED_LAWS).read_text(encoding='utf-8'))
        worded = {k for _, _, rows in cm.STANDINGS for k, _, _ in rows}
        self.assertEqual(set(shared['boundary']['counts']) - worded, set())
        self.assertEqual(set(shared['boundary']['groups']) - {key for _, key, _ in cm.STANDINGS}, set())
        self.assertEqual(set(shared['central_reach']['counts']) - {k for k, _, _ in cm.REACH}, set())


class PageTests(unittest.TestCase):
    def setUp(self):
        hostile = entry('cx-a', 'cxg-early')
        hostile['reading'] = {'en': 'Ends </script><b> and a [link](nowhere.md).'}
        self.page = cm.page(cm.payload(atlas(hostile), GRAPH, SHARED))
        self.fragment = cm.fragment(cm.payload(atlas(hostile), GRAPH, SHARED, base=None))

    def test_text_cannot_close_the_script_or_trip_the_link_check(self):
        self.assertEqual(self.page.count('</script><b>'), 0)
        self.assertEqual(re.findall(r'\]\((<[^>]+>|[^\s)]+)\)', self.page), [])

    def test_the_data_comes_back_whole(self):
        blob = re.search(r'<script type="application/json" id="cx-data">(.*?)</script>', self.page, re.S).group(1)
        self.assertEqual(json.loads(blob)['entries'][0]['reading'], 'Ends </script><b> and a [link](nowhere.md).')

    def test_the_page_stands_alone(self):
        self.assertTrue(self.page.startswith('<!doctype html>'))
        self.assertIn(cm.GENERATED, self.page)
        self.assertEqual(re.findall(r'(?:src|href)="https?:', self.page), [])
        self.assertEqual(re.findall(r'@import|url\(http', self.page), [])

    def test_the_fragment_has_no_skeleton_and_no_repository_links(self):
        self.assertFalse(self.fragment.lstrip().lower().startswith('<!doctype'))
        self.assertNotIn('<html', self.fragment)
        self.assertIn('"base":null', self.fragment)

    @unittest.skipUnless(shutil.which('node'), 'node is not installed')
    def test_every_script_on_the_page_parses_whole(self):
        # each inline script is checked as one program, so a quote that closes a string early fails here, not on a reader's page
        scripts = [m.group(1) for m in re.finditer(r'<script(?![^>]*type="application/json")[^>]*>(.*?)</script>', self.page, re.S)]
        self.assertTrue(scripts)
        for script in scripts:
            with tempfile.NamedTemporaryFile('w', suffix='.js', delete=False) as f:
                f.write(script)
            try:
                run = subprocess.run(['node', '--check', f.name], capture_output=True, text=True)
            finally:
                os.unlink(f.name)
            self.assertEqual(run.returncode, 0, run.stderr[-800:])

    def test_it_names_both_readings_where_it_speaks_of_the_ethics(self):
        self.assertIn('the continuation condition for scope and C for order', self.page)
        self.assertIn('no warrant from outside is sought', self.page)
        self.assertNotIn('derives from the condition', self.page)


class OverviewTests(unittest.TestCase):
    """The map's overview as a static picture: well formed, drawn from the same data as the page, at its own width."""

    def setUp(self):
        entries = [entry('cx-a', 'cxg-early'), entry('cx-b', 'cxg-early', relation='divergence', of=None),
                   entry('cx-c', 'cxg-greek', relation='scope', of=None, carried='fresh-reading'),
                   entry('cx-d', 'cxg-greek', carried='not-carried', relation=None, record=None)]
        self.data = cm.payload(atlas(*entries), GRAPH, SHARED)
        self.data['relations'] = [{'en': r} for r in ('agreement', 'scope', 'divergence', 'contrary-reading')]
        self.svg = cm.overview_svg(self.data)

    def test_it_is_well_formed_and_drawn_at_900(self):
        import xml.etree.ElementTree as ET
        root = ET.fromstring(self.svg)
        self.assertEqual(root.get('width'), '900')
        self.assertTrue(root.get('viewBox').startswith('0 0 900 '))
        self.assertIn('<title id="cx-title">', self.svg)

    def test_it_says_what_every_thread_is_and_gives_the_counts(self):
        self.assertIn('Every dot is an AI reading, no person’s.', self.svg)
        for k, label in cm.STATS:
            self.assertIn(f'>{self.data["totals"]["carried"].get(k, 0):,}</tspan> {label}', self.svg)

    def test_a_thread_for_each_stated_or_proposed_claim_group_part_and_relation(self):
        threads = cm.overview_threads(self.data)
        self.assertEqual(sorted((t['group'], t['relation'], t['fresh'], t['n']) for t in threads),
                         [('cxg-early', 'agreement', False, 1), ('cxg-early', 'divergence', False, 1), ('cxg-greek', 'scope', True, 1)])
        dots = re.findall(r'<circle class="thread"[^>]*>', self.svg)
        self.assertEqual(len(dots), len(threads))  # a dot per thread, in its row and column
        self.assertEqual(sum('stroke=' in d for d in dots), sum(t['fresh'] for t in threads))  # proposed here: a ring
        self.assertIn(f'fill="{cm.OV_COLOUR["divergence"]}"', self.svg)  # stated: filled in its relation's colour

    def test_a_title_with_markup_is_escaped_and_a_relation_without_a_colour_is_named(self):
        import xml.etree.ElementTree as ET
        hostile = dict(self.data, groups=[dict(g, title='A <b>"bold" & odd</b> folder') for g in self.data['groups']])
        ET.fromstring(cm.overview_svg(hostile))
        with self.assertRaises(ValueError) as caught:
            cm.overview_svg(dict(self.data, relations=self.data['relations'] + [{'en': 'resonance'}]))
        self.assertIn('resonance', str(caught.exception))

    def test_the_columns_keep_apart_and_fit_the_width(self):
        many = dict(self.data, warp=[dict(w, id=f'w{i}', title=f'Part {i}') for i, w in enumerate(self.data['warp'] * 9)])
        svg = cm.overview_svg(many)
        xs = [float(x) for x in re.findall(r'<text transform="translate\(([\d.]+),', svg)]
        self.assertEqual(len(xs), len(many['warp']))
        self.assertTrue(all(b - a >= 14 for a, b in zip(xs, xs[1:])), xs)
        self.assertLess(max(xs), cm.OV_W - 60)  # the rising labels keep inside the picture

    @unittest.skipUnless(shutil.which('node'), 'node is not installed')
    def test_the_threads_are_the_ones_the_page_draws(self):
        def line(head):  # one line of the page's script, as it stands
            i = cm.SCRIPT.index(head)
            return cm.SCRIPT[i:cm.SCRIPT.index('\n', i)] + '\n'
        data = {'entries': self.data['entries'], 'relations': self.data['relations'], 'carried': VOCABULARY['carried']}
        script = ('const D=' + json.dumps(data) + ';\n' + line('const OF=') + line('const LOOSE=') + line('const S=') + line('function shown(')
                  + line('function threads(){') + 'console.log(JSON.stringify(threads()));')
        out = json.loads(subprocess.run(['node', '-e', script], capture_output=True, text=True, check=True).stdout)
        key = lambda t: (t['group'], t['warp'], t['relation'], t['fresh'], t['n'])
        self.assertEqual(sorted(map(key, out)), sorted(map(key, cm.overview_threads(self.data))))

    def test_each_curated_name_is_a_live_group_or_part(self):
        live = json.loads((ROOT / cm.atlas_tool.DATA).read_text(encoding='utf-8'))
        self.assertLessEqual(set(cm.OV_SHORT), {g['id'] for g in live['correspondence_groups']})
        self.assertLessEqual(set(cm.OV_WARP), {i for i, _, _ in cm.WARP})

    def test_render_writes_the_page_and_the_picture(self):
        out = cm.render(json.dumps(atlas(entry('cx-a', 'cxg-early'))), json.dumps(GRAPH))
        self.assertEqual(set(out), {cm.PAGE, cm.OVERVIEW, cm.OVERVIEW_ZH})

    def test_short_names(self):
        self.assertEqual(cm._short('The meta-attractor (元吸引子 / 总体化吸引子)'), 'The meta-attractor')
        self.assertEqual(cm._short('智善: intelligence must be good'), '智善: intelligence must be good')
        self.assertEqual(cm._short('Modern philosophy: process, recognition, capital'), 'Modern philosophy')
        self.assertTrue(len(cm._short('x ' * 60)) <= 50)
        self.assertLessEqual(sum(2 if '\u4e00' <= c <= '\u9fff' else 1 for c in cm._short('间' * 40)), 50)  # a wide character counts two

class SiteTests(unittest.TestCase):
    """The map for a site: a whole document from the data a render wrote, its links going to the base the builder gives."""

    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.root = Path(temporary.name)
        hostile = entry('cx-a', 'cxg-early')
        hostile['reading'] = {'en': 'Ends <!--<script> and </script> here.'}
        for path, data in ((cm.atlas_tool.DATA, atlas(hostile)), (theory_graph.GRAPH, GRAPH), (registry.SHARED_LAWS, SHARED)):
            (self.root / path).parent.mkdir(parents=True, exist_ok=True)
            (self.root / path).write_text(json.dumps(data, ensure_ascii=False))
        patcher = mock.patch.object(cm, 'ROOT', self.root)
        patcher.start()
        self.addCleanup(patcher.stop)
        self.out = self.root / 'site'
        self.base = 'https://github.com/o/r/blob/0123abc/'

    def data(self, page):
        return json.loads(re.search(r'<script type="application/json" id="cx-data">(.*?)</script>', page, re.S).group(1))

    def test_it_writes_a_whole_document_with_its_title_in_its_head(self):
        path = cm.site_map(self.out, self.base, {'theories/becoming/ONE-PAGE.md': 'becoming/ONE-PAGE.html'})
        self.assertEqual(path, self.out / 'map.html')
        page = path.read_text()
        head, body = page.split('</head>', 1)
        self.assertTrue(page.startswith('<!doctype html>'))
        self.assertIn(f'<title>{cm.TITLE}</title>', head)
        self.assertNotIn('<title>', body)
        data = self.data(page)
        self.assertEqual((data['base'], data['site']), (self.base, {'theories/becoming/ONE-PAGE.md': 'becoming/ONE-PAGE.html'}))
        self.assertEqual(data['entries'][0]['reading'], 'Ends <!--<script> and </script> here.')
        self.assertEqual(page.count('<script'), 2)  # the data cannot open or close one

    def test_the_repository_page_has_its_title_in_its_head_and_no_site(self):
        page = cm.page(cm.payload(atlas(), GRAPH, SHARED))
        self.assertIn(f'<title>{cm.TITLE}</title>', page.split('</head>', 1)[0])
        self.assertNotIn('site', self.data(page))

    def test_a_base_without_a_slash_or_a_path_with_an_anchor_is_refused(self):
        with self.assertRaises(ValueError):
            cm.site_map(self.out, 'https://github.com/o/r/blob/0123abc')
        with self.assertRaises(ValueError):
            cm.site_map(self.out, self.base, {'theories/becoming/ONE-PAGE.md#x': 'a.html'})
        with self.assertRaises(ValueError):
            cm.site_map(self.out, self.base, {'theories/becoming/ONE-PAGE.md': None})
        self.assertFalse((self.out / 'map.html').exists())

    def test_the_command_line_writes_it_and_refuses_half_a_request(self):
        with contextlib.redirect_stdout(io.StringIO()) as printed:
            self.assertEqual(cm.main(['--site', str(self.out), '--link-base', self.base]), 0)
        self.assertEqual(printed.getvalue().strip(), str(self.out / 'map.html'))
        for argv in (['--site', str(self.out)], ['--fragment', str(self.root / 'f.html'), '--link-base', self.base],
                     ['--site', str(self.out), '--link-base', 'no-slash']):
            with self.subTest(argv=argv), contextlib.redirect_stderr(io.StringIO()), self.assertRaises(SystemExit):
                cm.main(argv)

    def test_the_site_page_has_its_line_home_and_a_summary_without_script(self):
        page = cm.site_map(self.out, self.base, {cm.CROSSWALK_PATH: 'crosswalk.html'}, nav=[('Chapters', 'chapters.html')]).read_text()
        body = page.split('<body>', 1)[1]
        self.assertTrue(body.lstrip().startswith('<nav class="sitebar" aria-label="Site"><a class="home" href="index.html">The Theory of Becoming</a>'
                                                 '<a href="chapters.html">Chapters</a></nav>'))
        noscript = re.search(r'<noscript>(.*?)</noscript>', page, re.S).group(1)
        lede, sub = cm._ledes(self.data(page))
        self.assertIn(f'<p class="lede" id="lede">{html.escape(lede)}</p>', page)  # written in, the same with or without script
        self.assertIn(f'<p class="note small" id="sublede">{html.escape(sub)}</p>', page)
        self.assertIn('<li><b>1</b>carried</li>', page)
        self.assertTrue(lede.startswith('1 claims from 1 earlier folders and 1 domains of thought'))
        self.assertEqual(page.count('<h1>'), 1)
        self.assertIn('<a href="crosswalk.html">the crosswalk</a>', noscript)  # the site's page for the crosswalk
        self.assertNotIn('<script', noscript)
        with self.assertRaises(ValueError):
            cm.site_map(self.out, self.base, nav=[('Chapters',)])

    def test_the_repository_page_has_the_summary_and_no_site_line(self):
        page = cm.page(cm.payload(atlas(entry('cx-a', 'cxg-early')), GRAPH, SHARED))
        self.assertNotIn('class="sitebar"', page)
        self.assertIn('<a href="../../../../' + cm.CROSSWALK_PATH + '">the crosswalk</a>', page)
        self.assertNotIn("getElementById('lede').textContent", page)  # the header is written in, not by the script
        fragment = cm.fragment(cm.payload(atlas(entry('cx-a', 'cxg-early')), GRAPH, SHARED, base=None))
        self.assertIn('the crosswalk (CROSSWALK.md)', fragment)  # no repository links where links are text

    @unittest.skipUnless(shutil.which('node'), 'node is not installed')
    def test_a_link_goes_to_the_site_where_it_has_the_page_and_keeps_its_anchor(self):
        to = re.search(r'function to\(path\)\{.*?\}\n', cm.SCRIPT).group(0)
        script = ("const D={base:'B/',site:{'a.md':'a.html'}};" + to
                  + "console.log(JSON.stringify(['a.md#x','a.md','b.md#y','constructor'].map(to)));")
        out = subprocess.run(['node', '-e', script], capture_output=True, text=True, check=True).stdout
        self.assertEqual(json.loads(out), ['a.html#x', 'a.html', 'B/b.md#y', 'B/constructor'])


if __name__ == '__main__':
    unittest.main()
