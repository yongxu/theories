"""The reader's site (tools/publishing/build_site.py) against what it promises, on a throwaway repository: only the
allow-list is published and the push screen's private paths are refused; a link to a page of the site becomes a link to
its HTML, a link to any other tracked file goes to GitHub at the build commit, a link to an untracked path is shown as
text; every link between pages of the site resolves, anchor included, or the build fails; a result's anchor carries its
record's status; raw HTML keeps no handler or script URL; and the repository's own site configuration names only pages
that exist and may be published."""
import importlib.util
import json
import os
from pathlib import Path
import re
import shutil
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[3]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
_spec = importlib.util.spec_from_file_location('build_site', ROOT / 'tools' / 'publishing' / 'build_site.py')
site = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(site)

COMMIT = 'c0ffee' + '0' * 34
README = ('# The Theory of Becoming\n\n<!-- generated -->\n\n[Home](README.md) · [One page](a/ONE.md)\n\n'
          '> This version is still being revised.\n\n*A minute to read.*\n\n**An account** of how things go on. '
          'Start with [the one page](a/ONE.md#what-it-is), and [the opening](#truth-exists).\n\n## Truth exists\n\nThe opening.\n')
ONE = ('# One page\n\n## What it is\n\nSee [the chapter](chapters/02-MAP.md#r-closed-capture), [chapters](chapters/), '
       '[a record](results/records/closed-capture.md), [a scratch note](../tmp/notes.md), [a line](results/records/closed-capture.md?plain=1#L3) and [a folder](../experiments/).\n\n'
       '| Claim | Standing |\n|---|---|\n| `a \\| b` holds | proved \\| checked |\n\n'
       '- one\n  - nested\n- two\n\nA note.[^n]\n\n[^n]: The note.\n\n<!-- a comment that must not appear -->\n'
       'Raw <a href="javascript:alert(1)" onclick="x()">tag</a> and <script>no()</script>.\n')
CHAPTER = ('# The map\n\n## 9. Capture\n\n<a id="r-closed-capture"></a>\n**Theorem** (any type). The lock outlives a loss.\n'
           '\n## 9. Capture\n\nA repeated heading.\n')
CHAPTERS = '# Chapters\n\n[The map](02-MAP.md) and [one page](../ONE.md#what-it-is).\n'
SITE = {'repository': 'o/r', 'title': 'T', 'description': 'd',
        'pages': ['a/ONE.md', 'a/chapters/README.md', 'a/chapters/02-MAP.md', 'a/OPENING.md'],
        'aliases': {'README.md#truth-exists': 'a/OPENING.md#truth-exists'},
        'nav': [['index.html', 'Home'], ['a/ONE.md', 'One page']],
        'ways_in': [{'path': 'a/ONE.md', 'label': 'One page', 'text': 'What it claims.'}]}


class SiteTests(unittest.TestCase):
    def setUp(self):
        self.tmp = Path(tempfile.mkdtemp())
        self.addCleanup(shutil.rmtree, self.tmp)
        files = {'README.md': README, 'a/ONE.md': ONE, 'a/chapters/02-MAP.md': CHAPTER, 'a/chapters/README.md': CHAPTERS,
                 'a/OPENING.md': '## Truth exists\n\nThe opening.\n', 'a/results/records/closed-capture.md': '# r\n',
                 'experiments/x/README.md': '# x\n', 'sources/12-claude-ai-chats/c.md': 'private\n'}
        for p, text in files.items():
            (self.tmp / p).parent.mkdir(parents=True, exist_ok=True)
            (self.tmp / p).write_text(text)
        (self.tmp / 'tools/research').mkdir(parents=True)
        shutil.copy(ROOT / 'tools/research/push_screen.sh', self.tmp / 'tools/research/push_screen.sh')
        rec = self.tmp / 'theories/becoming/results/records'
        rec.mkdir(parents=True)
        (rec / 'closed-capture.json').write_text(json.dumps({'id': 'closed-capture', 'status': 'recorded-checked'}))
        self.files = set(files) | {'tools/research/push_screen.sh'}
        self.out = self.tmp / '_site'

    def build(self, **changes):
        cfg = dict(SITE, **changes)
        (self.tmp / 'config.json').write_text(json.dumps({'site': cfg}))
        return site.build(self.out, COMMIT, root=self.tmp, config_path=self.tmp / 'config.json', files=self.files)

    def page(self, p):
        return (self.out / p).read_text()

    def test_links_go_to_the_site_github_or_text(self):
        report = self.build()
        one = self.page('a/ONE.html')
        self.assertIn('href="chapters/02-MAP.html#r-closed-capture"', one)
        self.assertIn('href="chapters/index.html"', one)
        self.assertIn(f'href="https://github.com/o/r/blob/{COMMIT}/a/results/records/closed-capture.md"', one)
        self.assertIn(f'href="https://github.com/o/r/tree/{COMMIT}/experiments"', one)
        self.assertIn(f'href="https://github.com/o/r/blob/{COMMIT}/a/results/records/closed-capture.md?plain=1#L3"', one)
        self.assertIn('<span class="nolink" title="Not in the public repository">a scratch note</span>', one)
        self.assertEqual(report['untracked'], [('a/ONE.md', '../tmp/notes.md')])  # private (tmp/) and untracked alike
        self.assertIn('href="../ONE.html#what-it-is"', self.page('a/chapters/index.html'))

    def test_the_home_is_the_first_screen_with_the_ways_in(self):
        self.build()
        home = self.page('index.html')
        self.assertIn('<strong>An account</strong> of how things go on.', home)
        self.assertIn('href="a/ONE.html#what-it-is"', home)
        self.assertIn('href="a/OPENING.html#truth-exists"', home)  # the alias: README's opening is the opening's page
        self.assertNotIn('The opening.</p>', home)  # the screen stops at the opening's heading
        self.assertIn('<span class="label">One page</span>', home)

    def test_markdown_as_github_shows_it(self):
        self.build()
        one = self.page('a/ONE.html')
        self.assertIn('<td><code>a | b</code> holds</td><td>proved | checked</td>', one)
        self.assertIn('<ul><li>one<ul><li>nested</li></ul></li><li>two</li></ul>', one)
        self.assertIn('<a id="fnref-n" href="#fn-n">1</a>', one)
        self.assertIn('<li id="fn-n">The note.', one)
        self.assertNotIn('a comment that must not appear', one)
        self.assertNotIn('javascript:', one)
        self.assertNotIn('onclick', one)
        self.assertIn('&lt;script&gt;', one)
        chapter = self.page('a/chapters/02-MAP.html')
        self.assertIn('id="9-capture"', chapter)
        self.assertIn('id="9-capture-1"', chapter)  # a repeated heading numbered as GitHub numbers it

    def test_a_result_anchor_carries_its_record_status(self):
        self.build()
        chapter = self.page('a/chapters/02-MAP.html')
        self.assertRegex(chapter, r'<a id="r-closed-capture"></a>\s*<div class="marks"><a class="mark mark-recorded-checked" '
                                  r'href="https://github.com/o/r/blob/c0ffee0+/theories/becoming/results/records/closed-capture.md"')
        self.assertIn('>Lean receipt</a>', chapter)

    def test_a_broken_link_between_site_pages_fails_the_build(self):
        (self.tmp / 'a/ONE.md').write_text(ONE.replace('#r-closed-capture', '#r-no-such-result'))
        with self.assertRaisesRegex(site.SiteError, r'a/ONE.md → a/chapters/02-MAP.md#r-no-such-result'):
            self.build()

    def test_private_paths_and_sources_are_refused(self):
        for bad in ('sources/12-claude-ai-chats/c.md', 'tmp/x.md', '.claude/x.md', 'sources/15-x/y.md'):
            with self.subTest(bad=bad):
                self.files.add(bad)
                with self.assertRaisesRegex(site.SiteError, 'keeps private, or a source copy'):
                    self.build(pages=SITE['pages'] + [bad])

    def test_an_untracked_page_is_refused(self):
        with self.assertRaisesRegex(site.SiteError, 'does not track'):
            self.build(pages=SITE['pages'] + ['a/NEW.md'])

    def test_nothing_that_could_run_reaches_the_page(self):
        bad = ('[a](javascript:alert(1)) [b]( JaVaScRiPt:alert(2)) [c](&#106;avascript:alert(3)) [d](data:text/html,x) '
               '<a href=\'javascript:alert(4)\'>e</a> <a href=javascript:alert(5)>f</a> <a href="&#106;avascript:alert(6)">g</a> '
               '<img/src="x"/onerror="alert(7)"> <a href="#what-it-is" style="x" onmouseover="alert(8)">h</a>\n')
        (self.tmp / 'a/ONE.md').write_text(ONE + '\n' + bad)
        report = self.build()
        one = self.page('a/ONE.html')
        for word in ('javascript', 'JaVaScRiPt', 'data:text', 'onerror', 'onmouseover', 'style=', 'alert(', '&#106;'):
            self.assertNotIn(word, one.split('<main>')[1].split('</main>')[0].replace('&lt;', '<').split('<script>no')[0], word)
        self.assertIn('<a href="#what-it-is">h</a>', one)
        self.assertEqual(report['links']['refused'], 8)  # seven here and the fixture's own

    def test_a_link_to_a_private_path_is_text(self):
        self.files.add('.claude/launch.json')
        (self.tmp / 'a/ONE.md').write_text(ONE + '\nSee [config](../.claude/launch.json).\n')
        self.build()
        self.assertIn('<span class="nolink" title="Not in the public repository">config</span>', self.page('a/ONE.html'))

    def test_a_link_into_private_sources_is_text(self):
        (self.tmp / 'a/ONE.md').write_text(ONE + '\nSee [a chat](../sources/12-claude-ai-chats/c.md).\n')
        self.build()
        self.assertIn('<span class="nolink" title="Not in the public repository">a chat</span>', self.page('a/ONE.html'))

    def test_the_map_is_written_by_its_site_mode(self):
        from tools.research import connection_map
        calls = []

        def stub(out_dir, link_base, site_paths=None, home='index.html', nav=None):
            calls.append((link_base, dict(site_paths), home, list(nav or [])))
            out_dir = Path(out_dir)
            out_dir.mkdir(parents=True, exist_ok=True)
            (out_dir / 'map.html').write_text('<!doctype html><title>map</title><a href="a/ONE.html">one</a>')
            return out_dir / 'map.html'
        had = hasattr(connection_map, 'site_map')
        old = getattr(connection_map, 'site_map', None)
        connection_map.site_map = stub
        try:
            self.build(map=True, nav=SITE['nav'] + [['connections.html', 'Map']])
        finally:
            if had:
                connection_map.site_map = old
            else:
                del connection_map.site_map
        self.assertTrue((self.out / 'connections.html').is_file())
        self.assertFalse((self.out / '_map').exists())
        self.assertEqual(calls[0][0], f'https://github.com/o/r/blob/{COMMIT}/')
        self.assertEqual(calls[0][1]['a/ONE.md'], 'a/ONE.html')
        self.assertEqual(calls[0][2], 'index.html')
        self.assertIn(('One page', 'a/ONE.html'), calls[0][3])  # the map carries the site's line, hrefs from the root
        self.assertIn('href="../../connections.html"', self.page('a/chapters/index.html'))

    def test_the_home_keeps_the_status_line(self):
        self.build()
        self.assertIn('<blockquote><p>This version is still being revised.</p></blockquote>', self.page('index.html'))

    def test_headings_and_footnotes_as_github_has_them(self):
        (self.tmp / 'a/ONE.md').write_text('# One page\n\n## What it is\n\n## In C#\n\nSecond.[^b] First.[^a] Again.[^b]\n\n'
                                           '```\n<!-- kept in code -->\n[^a]: not a note\n```\n\n[^a]: Note a.\n[^b]: Note b.\n')
        self.build()
        one = self.page('a/ONE.html')
        self.assertIn('id="in-c"', one)
        self.assertIn('>In C#<', one)
        self.assertIn('<a id="fnref-b" href="#fn-b">1</a>', one)  # numbered by first reference
        self.assertIn('<a id="fnref-a" href="#fn-a">2</a>', one)
        self.assertIn('<a id="fnref-b-2" href="#fn-b">1</a>', one)
        self.assertIn('&lt;!-- kept in code --&gt;', one)
        self.assertIn('[^a]: not a note', one)
        self.assertLess(one.index('id="fn-b"'), one.index('id="fn-a"'))

    def test_the_map_is_built_only_with_its_site_mode(self):
        from tools.research import connection_map
        if hasattr(connection_map, 'site_map'):
            self.skipTest('this checkout has the site mode; the build writes the map')
        with self.assertRaisesRegex(site.SiteError, 'no site mode'):
            self.build(map=True, nav=SITE['nav'] + [['connections.html', 'Map']])
        self.build(nav=SITE['nav'] + [['connections.html', 'Map']])
        self.assertNotIn('connections.html', self.page('a/ONE.html'))

    def test_editions_pictures_and_titles(self):
        (self.tmp / 'a/ONE.zh.md').write_text('# 一页\n\n中文的一页。\n')
        (self.tmp / 'a/OPENING.md').write_text('## Truth exists\n\n![The picture](pic.svg)\n')
        (self.tmp / 'a/pic.svg').write_text('<svg xmlns="http://www.w3.org/2000/svg"></svg>')
        self.files |= {'a/ONE.zh.md', 'a/pic.svg'}
        self.build(pages=SITE['pages'] + ['a/ONE.zh.md'], assets=['a/pic.svg'],
                   nav=[['index.html', 'Home'], ['a/ONE.zh.md', '中文']], nav_zh=[['index.html', '首页'], ['a/ONE.md', 'English']])
        one, zh, opening = self.page('a/ONE.html'), self.page('a/ONE.zh.html'), self.page('a/OPENING.html')
        self.assertIn('<a href="ONE.zh.html"', one)  # the language link goes to this page's own edition
        self.assertIn('lang="zh-Hans"', zh)
        self.assertIn('首页', zh)
        self.assertIn('<a href="ONE.html"', zh)
        self.assertIn('<a class="picture" href="pic.svg"', opening)
        self.assertIn('<title>Truth exists · T</title>', opening)  # a page with no h1 takes its first heading

    def test_a_record_on_the_site_gets_its_mark_there(self):
        (self.tmp / 'theories/becoming/results/records/closed-capture.md').write_text('# Closed capture\n')
        self.files.add('theories/becoming/results/records/closed-capture.md')
        self.build(pages=SITE['pages'] + ['theories/becoming/results/records/closed-capture.md'])
        self.assertIn('class="mark mark-recorded-checked" href="../../theories/becoming/results/records/closed-capture.html"',
                      self.page('a/chapters/02-MAP.html'))

    def test_a_page_linking_itself_and_its_own_lines(self):
        (self.tmp / 'a/ONE.md').write_text(ONE + '\n[This page](ONE.md), [its lines](ONE.md#L3-L5), [plain](ONE.md?plain=1#L2).\n')
        self.build()
        one = self.page('a/ONE.html')
        self.assertIn('<a href="ONE.html">This page</a>', one)
        self.assertIn(f'href="https://github.com/o/r/blob/{COMMIT}/a/ONE.md#L3-L5"', one)
        self.assertIn(f'href="https://github.com/o/r/blob/{COMMIT}/a/ONE.md?plain=1#L2"', one)

    def test_cards_grouped_in_their_order(self):
        self.build(ways_in=[{'path': 'a/ONE.md', 'label': 'One', 'text': 'x', 'group': 'Read'},
                            {'path': 'a/OPENING.md', 'label': 'Open', 'text': 'y', 'group': 'Check'},
                            {'path': 'a/chapters/README.md', 'label': 'Ch', 'text': 'z', 'group': 'Read'}])
        home = self.page('index.html')
        self.assertLess(home.index('<h3 class="group">Read</h3>'), home.index('<h3 class="group">Check</h3>'))
        self.assertEqual(home.count('<h3 class="group">'), 2)
        self.assertLess(home.index('>Ch<'), home.index('<h3 class="group">Check</h3>'))  # a group keeps its cards together

    def test_the_chinese_readme_goes_back_to_the_home(self):
        (self.tmp / 'README.zh.md').write_text('# 中文\n\n中文的首页。\n')
        self.files.add('README.zh.md')
        self.build(pages=SITE['pages'] + ['README.zh.md'], nav=[['index.html', 'Home'], ['README.zh.md', '中文']],
                   nav_zh=[['index.html', '首页'], ['a/ONE.md', 'English']])
        self.assertIn('<a href="index.html">English</a>', self.page('README.zh.html'))

    def test_a_card_to_a_section_times_the_section(self):
        (self.tmp / 'a/ONE.md').write_text(ONE.replace('## What it is', '## What it is\n\nShort.\n\n## Long part\n\n' + 'word ' * 600 + '\n\n## After', 1))
        self.build(ways_in=[{'path': 'a/ONE.md#what-it-is', 'label': 'Part', 'text': 'x'}])
        self.assertIn('<span class="time">a minute</span>', self.page('index.html'))

    def test_with_the_map_off_its_links_stay_off_the_site(self):
        (self.tmp / 'a/ONE.md').write_text(ONE + '\nSee [the map](../map.html).\n')
        self.files.add('map.html')
        self.build(aliases=dict(SITE['aliases'], **{'map.html': 'connections.html'}))
        self.assertNotIn('connections.html', self.page('a/ONE.html'))
        self.assertIn(f'https://github.com/o/r/blob/{COMMIT}/map.html', self.page('a/ONE.html'))

    def test_a_cards_section_is_read_as_the_builder_reads_headings(self):
        page = ('# P\n\n## Results\n\nfirst\n\n## Results\n\n```\n# not a heading\n```\n\n' + 'word ' * 300 +
                '\n\n## After\n\n<a id="r-x"></a>\nshort\n\n## Last\n\n' + 'word ' * 600 + '\n')
        self.assertIn('word', site.section_text(page, 'results-1'))  # the second Results, numbered as GitHub numbers it
        self.assertNotIn('first', site.section_text(page, 'results-1'))
        self.assertNotIn('After', site.section_text(page, 'results-1'))  # a fenced '#' line does not end the part
        self.assertEqual(site.section_text(page, 'r-x').count('word'), 0)  # an <a id> line's part runs to the next heading
        with self.assertRaises(site.SiteError):
            site.section_text(page, 'no-such-part')

    def test_with_the_map_off_no_line_names_it(self):
        (self.tmp / 'a/ONE.zh.md').write_text('# 一页\n\n中文的一页。\n')
        (self.tmp / 'a/ONE.md').write_text(ONE + '\n[The map](../map.html) and [again](../connections.html).\n')
        self.files |= {'a/ONE.zh.md', 'map.html'}
        self.build(pages=SITE['pages'] + ['a/ONE.zh.md'], nav_zh=[['index.html', '首页'], ['connections.html', '地图']],
                   aliases=dict(SITE['aliases'], **{'map.html': 'connections.html#top'}),
                   ways_in=[{'path': 'a/ONE.md', 'label': 'One', 'text': 'x', 'zh': 'connections.html#x'}])
        for page in ('index.html', 'a/ONE.html', 'a/ONE.zh.html'):
            self.assertNotIn('connections.html', self.page(page), page)

    def test_a_link_to_an_aliased_files_lines_goes_to_github(self):
        (self.tmp / 'a/ONE.md').write_text(ONE + '\n[The readme\'s line](../README.md?plain=1#L5).\n')
        self.build(aliases=dict(SITE['aliases'], **{'README.md': 'index.html'}))
        self.assertIn(f'href="https://github.com/o/r/blob/{COMMIT}/README.md?plain=1#L5"', self.page('a/ONE.html'))

    def test_a_link_to_the_home_at_an_anchor_it_lacks_fails_the_build(self):
        (self.tmp / 'a/ONE.md').write_text(ONE + '\n[The readme](../README.md#no-such-part).\n')
        with self.assertRaises(site.SiteError):
            self.build(aliases=dict(SITE['aliases'], **{'README.md': 'index.html'}))

    def test_an_asset_is_readable_whatever_its_mode(self):
        (self.tmp / 'a/pic.svg').write_text('<svg xmlns="http://www.w3.org/2000/svg"></svg>')
        (self.tmp / 'a/pic.svg').chmod(0o600)
        self.files.add('a/pic.svg')
        old = os.umask(0o077)  # a fresh file would be private without the build's chmod
        self.addCleanup(os.umask, old)
        self.build(assets=['a/pic.svg'])
        self.assertEqual((self.out / 'a/pic.svg').stat().st_mode & 0o777, 0o644)
        self.assertEqual((self.out / 'assets/site.css').stat().st_mode & 0o777, 0o644)

    def test_a_heading_after_a_list_item_is_a_heading(self):
        (self.tmp / 'a/ONE.md').write_text(ONE + '\n1. an item\n## After the list\n\nText.\n')
        self.build()
        self.assertIn('<h2 id="after-the-list">', self.page('a/ONE.html'))

    def test_an_inline_code_line_continues_a_list_item(self):
        (self.tmp / 'a/ONE.md').write_text(ONE + '\n1. an item\n```x``` and more\n\nText after.\n')
        self.build()
        self.assertIn('<p>Text after.</p>', self.page('a/ONE.html'))  # not read as a fence running on down the page

    def test_a_card_times_its_part(self):
        with self.assertRaises(AssertionError):
            self.build(ways_in=[{'path': 'a/ONE.md', 'label': 'One page', 'text': 'x', 'time_until': '## No such part'}])

    def test_a_key_in_a_page_fails_the_build(self):
        (self.tmp / 'a/ONE.md').write_text(ONE + '\nsk-ant-' + 'a' * 30 + '\n')
        with self.assertRaisesRegex(site.SiteError, 'what the push screen reads as a key'):
            self.build()


class ScreenPatternTests(unittest.TestCase):
    def test_the_site_reads_the_push_screens_lists(self):
        private = site.private_pattern()
        for p in ('sources/12-claude-ai-chats/a.md', 'sources/13-claude-memories/a', 'sources/18-friend-conversations/a',
                  'drafts/2026-10-02-friend-conversation/a', 'tmp/a', 'work/a', 'experiments/guardian-anarchy/a',
                  '.claude/launch.json', 'x/.lake/y'):
            self.assertTrue(private.search(p), p)
        self.assertFalse(private.search('theories/becoming/ONE-PAGE.md'))
        secrets = site.secret_pattern()
        self.assertTrue(secrets.search('token = "' + 'A' * 20 + '"'))
        self.assertFalse(secrets.search('the continuation condition'))


class RepositoryConfigTests(unittest.TestCase):
    def test_the_site_lists_pages_that_exist_and_may_be_published(self):
        cfg = site.site_config()
        private = site.private_pattern()
        files = site.tracked_files()
        pages = site.expand_pages(cfg['pages'], files)
        for entry in cfg['pages']:
            self.assertTrue(site.expand_pages([entry], files), 'site.pages names nothing tracked: ' + entry)
        for p in pages + cfg.get('assets', []):
            self.assertTrue(p in files, 'site.pages names an untracked file: ' + p)
            self.assertFalse(site.refused(p, private), p)
        for target, _ in cfg['nav'] + cfg.get('nav_zh', []):
            self.assertTrue(target in site.SPECIAL or target in pages, target)
        for w in cfg['ways_in']:
            self.assertTrue(w['path'] in site.SPECIAL or (ROOT / w['path'].split('#')[0]).is_file(), w['path'])
            self.assertTrue(w.get('group'), 'a card with no group adds a list without a heading: ' + w['path'])
        for source, target in cfg.get('aliases', {}).items():
            self.assertTrue(target.split('#')[0] in site.SPECIAL or target.split('#')[0] in pages, (source, target))

    def test_patterns_stay_in_one_folder(self):
        files = {'a/x.md', 'a/b/y.md', 'a/README.md'}
        self.assertEqual(site.expand_pages(['a/*.md'], files), ['a/README.md', 'a/x.md'])

if __name__ == '__main__':
    unittest.main()
