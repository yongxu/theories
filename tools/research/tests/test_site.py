"""The reader's site (tools/publishing/build_site.py) against what it promises, on a throwaway repository: only the
allow-list is published and the push screen's private paths are refused; a link to a page of the site becomes a link to
its HTML, a link to any other tracked file goes to GitHub at the build commit, a link to an untracked path is shown as
text; every link between pages of the site resolves, anchor included, or the build fails; a result's anchor carries its
record's status; raw HTML keeps no handler or script URL; and the repository's own site configuration names only pages
that exist and may be published. Also what a reader meets: a card's time says what it is of, every result anchor has its
mark, chapters have contents and neighbours, a generated page shows one navigation, wide tables widen and stack, the search,
the 404 page and the favicon are written, the home's order, and that nothing written prints a local path."""
import importlib.util
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
import unittest
from types import SimpleNamespace
from unittest.mock import patch

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
# The search script on a stand-in for the page (node, argv: the script and search.json), so that a hit can be clicked.
SEARCH_STAGE = r"""
const fs = require('fs');
let focused = null;
const node = tag => ({tagName: tag.toUpperCase(), attrs: {}, on: {}, kids: [], hidden: false, value: '', text: '',
  get textContent() { return this.text; }, set textContent(v) { this.text = v; if (v === '') { this.kids = []; } },
  setAttribute(k, v) { this.attrs[k] = v; }, getAttribute(k) { return this.attrs[k]; },
  appendChild(c) { c.up = this; this.kids.push(c); return c; },
  addEventListener(t, f) { (this.on[t] = this.on[t] || []).push(f); },
  contains(o) { for (; o; o = o.up) { if (o === this) { return true; } } return false; },
  closest(s) { for (let o = this; o; o = o.up) { if (o.tagName === s.toUpperCase()) { return o; } } return null; },
  focus() { focused = this; }});
const body = node('body'), button = node('button'), page = node('html');
Object.assign(page, {currentScript: {getAttribute: () => ''}, querySelector: () => button, documentElement: {lang: 'en'}, createElement: node, body});
const fire = (el, type, extra) => {
  const ev = Object.assign({target: el, key: ''}, extra);
  for (let o = el; o; o = o.up) { (o.on[type] || []).forEach(f => f(ev)); }
  (page.on[type] || []).forEach(f => f(ev));
};
const data = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
globalThis.document = page;
globalThis.window = {fetch: () => Promise.resolve({ok: true, json: () => Promise.resolve(data)})};
globalThis.fetch = window.fetch;
new Function(fs.readFileSync(process.argv[1], 'utf8'))();
(async () => {
  fire(button, 'click');
  await new Promise(r => setTimeout(r));
  const panel = body.kids[0], input = panel.kids[0], list = panel.kids[2];
  input.value = 'what';
  fire(input, 'input');
  const link = () => list.kids[0].kids[0];
  fire(link(), 'click', {metaKey: true});
  const openAfterANewTab = !panel.hidden;
  fire(link().kids[0], 'click');  // the small words inside the link
  const afterHit = {hidden: panel.hidden, expanded: button.attrs['aria-expanded'], focusOnButton: focused === button};
  fire(button, 'click');
  fire(body, 'keydown', {key: 'Escape'});
  console.log(JSON.stringify({openAfterANewTab, afterHit, afterEscape: {hidden: panel.hidden, focusOnButton: focused === button}}));
})();
"""
# The same stand-in, typing the query argv[3] and printing each hit's text and the small words under it, in order.
SEARCH_QUERY = SEARCH_STAGE.split('(async () => {')[0] + r"""(async () => {
  fire(button, 'click');
  await new Promise(r => setTimeout(r));
  const panel = body.kids[0], input = panel.kids[0], list = panel.kids[2];
  input.value = process.argv[3];
  fire(input, 'input');
  console.log(JSON.stringify(list.kids.map(li => [li.kids[0].text, li.kids[0].kids.length ? li.kids[0].kids[0].text : ''])));
})();
"""


def strip(html_text):
    """A paragraph's text as the search reads it."""
    return ' '.join(site.strip_tags(html_text).split())


class SiteTests(unittest.TestCase):
    def setUp(self):
        self.tmp = Path(tempfile.mkdtemp())
        self.addCleanup(shutil.rmtree, self.tmp)
        files = {'README.md': README, 'a/ONE.md': ONE, 'a/chapters/02-MAP.md': CHAPTER, 'a/chapters/README.md': CHAPTERS,
                 'a/OPENING.md': '## Truth exists\n\nThe opening.\n', 'a/results/records/closed-capture.md': '# r\n',
                 'experiments/x/README.md': '# x\n', 'sources/12-claude-ai-chats/c.md': '# A private chat\n\nprivate\n'}
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
        self.assertIn('<a class="lang" href="ONE.zh.html"', one)  # the language link goes to this page's own edition
        self.assertIn('lang="zh-Hans"', zh)
        self.assertIn('首页', zh)
        self.assertIn('<a class="lang" href="ONE.html"', zh)
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
        self.assertIn('<a class="lang" href="index.html" hreflang="en" lang="en">English</a>', self.page('README.zh.html'))

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

    # -- a card's time
    def test_a_card_says_what_its_time_is_of(self):
        (self.tmp / 'a/chapters/01-LONG.md').write_text('# Long\n\n' + 'word ' * 30000 + '\n')
        self.files.add('a/chapters/01-LONG.md')
        self.build(pages=SITE['pages'] + ['a/chapters/01-LONG.md'],
                   ways_in=[{'path': 'a/chapters/README.md', 'label': 'Ch', 'text': 'x', 'time': 'the index {time}; the chapters {all:a/chapters/0*.md}'}])
        self.assertIn('<span class="time">the index a minute; the chapters about 4–5 hours</span>', self.page('index.html'))

    def test_a_card_can_quote_the_time_its_page_states(self):
        (self.tmp / 'a/ONE.md').write_text('# One\n\n## What it is\n\n*The lead: 3–4 minutes to read; every row: 30–40 minutes.*\n')
        self.build(ways_in=[{'path': 'a/ONE.md', 'label': 'One', 'text': 'x', 'time': 'lead {said:lead: (.+?) to read}, all {said:every row: (.+?)\\.}'}])
        self.assertIn('<span class="time">lead 3–4 minutes, all 30–40 minutes</span>', self.page('index.html'))
        with self.assertRaisesRegex(site.SiteError, 'no longer states'):
            self.build(ways_in=[{'path': 'a/ONE.md', 'label': 'One', 'text': 'x', 'time': '{said:never said (.+)}'}])

    def test_a_card_can_time_a_page_without_its_notes(self):  # neither the notes nor the marks that call them are read
        (self.tmp / 'a/ONE.md').write_text('# One\n\n## What it is\n\n' + 'word[^n] ' * 200 + '\n\n[^n]: ' + 'note ' * 5000 + '\n')
        self.build(ways_in=[{'path': 'a/ONE.md', 'label': 'One', 'text': 'x', 'time': '{body}, without its notes'}])
        self.assertIn('<span class="time">2 minutes, without its notes</span>', self.page('index.html'))

    def test_a_card_without_a_page_of_text_shows_only_its_stated_time(self):
        self.build(nav=SITE['nav'], ways_in=[{'path': 'index.html', 'label': 'H', 'text': 'x', 'time': 'at a glance'}])
        self.assertIn('<span class="time">at a glance</span>', self.page('index.html'))

    # -- the marks
    def test_every_result_anchor_with_a_record_has_its_mark(self):
        rec = self.tmp / 'theories/becoming/results/records'
        for rid in ('in-a-cell', 'in-a-list', 'in-a-line'):
            (rec / f'{rid}.json').write_text(json.dumps({'id': rid, 'status': 'reviewed-scoped'}))
        (self.tmp / 'a/chapters/02-MAP.md').write_text(
            CHAPTER + '\n| Result | Standing |\n|---|---|\n| <a id="r-in-a-cell"></a>A name | proved |\n| <a id="r-no-record"></a>Other | open |\n\n'
            '- <a id="r-in-a-list"></a>**A listed one**: text.\n\n<a id="r-in-a-line"></a>A sentence that runs on.\n')
        self.build()
        chapter = self.page('a/chapters/02-MAP.html')
        anchors = [a for a in re.findall(r'id="r-([^"]+)"', chapter) if a != 'no-record']
        self.assertEqual(sorted(anchors), ['closed-capture', 'in-a-cell', 'in-a-line', 'in-a-list'])
        self.assertEqual(len(re.findall(r'<a class="mark mark-', chapter)), len(anchors))
        self.assertRegex(chapter, r'<td><a id="r-in-a-cell"></a><a class="mark mark-reviewed-scoped" ')
        self.assertRegex(chapter, r'<li><a id="r-in-a-list"></a><a class="mark mark-reviewed-scoped" ')
        self.assertIn('<td><a id="r-no-record"></a>Other</td>', chapter)  # no record, no mark

    def test_an_anchor_that_could_not_be_marked_fails_the_build(self):
        (self.tmp / 'a/chapters/02-MAP.md').write_text(CHAPTER.replace('<a id="r-closed-capture"></a>\n', 'Text <span id="r-closed-capture"></span> here.\n'))
        with self.assertRaisesRegex(site.SiteError, 'has no mark'):
            self.build()

    # -- chapters
    def test_chapters_have_contents_and_neighbours(self):
        (self.tmp / 'a/chapters/01-ROOT.md').write_text('# The root\n\nIntro.\n\n## First\n\n### Under it\n\n## `Second` part\n\nText.\n')
        (self.tmp / 'a/chapters/03-LAST.md').write_text('# 最后一章\n\n中文的一章，都是中文。\n\n## 一节\n\n正文。\n')
        self.files |= {'a/chapters/01-ROOT.md', 'a/chapters/03-LAST.md'}
        self.build(pages=SITE['pages'] + ['a/chapters/01-ROOT.md', 'a/chapters/03-LAST.md'],
                   chapters={'pages': 'a/chapters/0*.md', 'index': 'a/chapters/README.md'})
        first, middle, last = self.page('a/chapters/01-ROOT.html'), self.page('a/chapters/02-MAP.html'), self.page('a/chapters/03-LAST.html')
        self.assertIn('<a href="#first">First</a><ul><li><a href="#under-it">Under it</a></li></ul>', first)
        self.assertIn('<a href="#second-part">Second part</a>', first)
        self.assertLess(first.index('</h1>'), first.index('<nav class="contents"'))
        self.assertLess(first.index('<nav class="contents"'), first.index('Intro.'))
        self.assertNotIn('class="prev"', first)
        self.assertIn('class="next" href="02-MAP.html">Next: The map →</a>', first)
        self.assertEqual(middle.count('class="prev" href="01-ROOT.html">← Previous: The root</a>'), 2)  # at the top and at the foot
        self.assertIn('class="all" href="index.html">All chapters</a>', middle)
        self.assertNotIn('class="next"', last)
        self.assertIn('aria-label="目录"', last)  # a chapter in Chinese is told so in Chinese
        self.assertIn('上一章：The map', last)
        self.assertNotIn('<nav class="contents"', self.page('a/ONE.html'))  # the index and other pages are not chapters

    def test_a_neighbour_in_the_other_language_is_said_to_be(self):
        (self.tmp / 'a/chapters/03-LAST.md').write_text('# 最后一章\n\n中文的一章，都是中文。\n\n## 一节\n\n正文。\n')
        self.files.add('a/chapters/03-LAST.md')
        self.build(pages=SITE['pages'] + ['a/chapters/03-LAST.md'], chapters={'pages': 'a/chapters/0*.md', 'index': 'a/chapters/README.md'})
        self.assertIn('class="next" href="03-LAST.html">Next: 最后一章 (in Chinese) →</a>', self.page('a/chapters/02-MAP.html'))
        self.assertIn('class="prev" href="02-MAP.html">← 上一章：The map（英文）</a>', self.page('a/chapters/03-LAST.html'))

    def test_a_chapter_index_must_be_on_the_site(self):
        with self.assertRaisesRegex(site.SiteError, 'site.chapters'):
            self.build(chapters={'pages': 'a/chapters/0*.md', 'index': 'a/NOT-THERE.md'})

    # -- one navigation
    def test_a_generated_pages_navigation_line_is_dropped(self):
        (self.tmp / 'a/ONE.md').write_text('# One page\n\n<!-- generated -->\n\n[Home](../README.md) · [Chapters](chapters/README.md) · [The map](chapters/02-MAP.md)\n\n## What it is\n\n'
                                           'Text. [Chapters](chapters/README.md) · [The map](chapters/02-MAP.md)\n')
        (self.tmp / 'a/OPENING.md').write_text('# 中文\n\n[首页](ONE.md) · **第六章** · [The map](chapters/02-MAP.md)\n\n## Truth exists\n\nThe opening.\n')
        (self.tmp / 'a/chapters/README.md').write_text('# 中文首页\n\n[English](../ONE.md) · **首页** · [一页](../ONE.md#what-it-is)\n\n'
                                                       + CHAPTERS.split('\n', 1)[1])  # the Chinese landing's form: the home in bold
        self.build()
        main = self.page('a/ONE.html').split('<main>')[1].split('</main>')[0]
        self.assertNotIn('>Home<', main)
        landing = self.page('a/chapters/index.html').split('<main>')[1].split('</main>')[0]
        self.assertNotIn('首页</strong>', landing)
        self.assertIn('<a href="02-MAP.html">The map</a>', landing)  # the page's own text stays
        self.assertIn('Text. <a href="chapters/index.html">Chapters</a>', main)  # a line of links that is not the navigation stays
        self.assertNotIn('第六章', self.page('a/OPENING.html'))

    def test_the_homes_own_navigation_line_is_dropped_too(self):
        for home, kept in (('**首页**', False), ('**Home**', False), ('**另一页**', True)):  # the page that is the home has it in bold
            with self.subTest(home=home):
                line = f'[English](README.md) · {home} · [一页](a/ONE.md)'
                self.assertEqual(line in site.strip_nav_line(f'# 中文\n\n{line}\n\n正文。\n'), kept)

    # -- tables
    def test_a_wide_table_widens_and_a_text_table_stacks(self):
        wide = '| A | B | C | D | E |\n|---|---|---|---|---|\n' + '| 1 | 2 | 3 | 4 | 5 |\n'
        text = '| Name | **Standing** | What |\n|---|---|---|\n| n | s ' + 'word ' * 9 + '| ' + 'word ' * 30 + '|\n| | | |\n'
        (self.tmp / 'a/ONE.md').write_text(f'# One\n\n## What it is\n\n{wide}\n{text}\n')
        self.build()
        one = self.page('a/ONE.html')
        self.assertIn('<div class="table wide"><table>', one)  # numbers: scrolled, not stacked, and so unlabelled
        self.assertIn('<td>1</td>', one)
        self.assertIn('<div class="table stack"><table>', one)
        self.assertIn('<td data-label="Name">n</td><td data-label="Standing">s word', one)  # the label is the heading's plain text

    def test_a_numeric_table_with_one_long_name_scrolls(self):
        head = '| Thesis | ' + ' | '.join('c%d' % k for k in range(6)) + ' |\n|' + '---|' * 7 + '\n'
        rows = ''.join('| ' + 'a long thesis name ' * 8 + ' | ' + ' | '.join(['1'] * 6) + ' |\n' for _ in range(3))
        (self.tmp / 'a/ONE.md').write_text(f'# One\n\n## What it is\n\n{head}{rows}\n')
        self.build()
        self.assertNotIn('table stack', self.page('a/ONE.html'))  # one prose cell a row: scrolled, not stacked as fourteen labelled lines

    def test_the_stylesheet_widens_cues_and_stacks(self):
        css = (ROOT / 'tools/publishing/site.css').read_text()
        self.assertIn('main > div.table.wide', css)
        self.assertRegex(css, r'div\.table \{[^}]*no-repeat local')  # a shade at an edge says there is more
        narrow = css.split('@media (max-width: 600px)')[1].split('@media print')[0]
        self.assertIn('div.table.stack td[data-label]::before', narrow)
        self.assertIn('content: attr(data-label)', narrow)

    # -- the search, the 404 page and the favicon
    def test_the_search_reads_titles_headings_and_result_names_of_built_pages(self):
        (self.tmp / 'theories/becoming/results/records/closed-capture.json').write_text(json.dumps(
            {'id': 'closed-capture', 'status': 'recorded-checked', 'title': {'en': 'Closed capture', 'zh': '闭合的捕获'}}))
        (self.tmp / 'theories/becoming/results/records/closed-capture.md').write_text('# Closed capture\n\n## Laws\n')
        self.files.add('theories/becoming/results/records/closed-capture.md')
        self.build(pages=SITE['pages'] + ['theories/becoming/results/records/closed-capture.md'])
        index = json.loads(self.page('search.json'))
        one = next(p for p in index['pages'] if p['u'] == 'a/ONE.html')
        self.assertEqual(one['t'], 'One page')
        self.assertIn(['What it is', 'what-it-is'], one['h'])
        self.assertEqual(index['results'], [{'t': 'Closed capture', 'z': '闭合的捕获', 'u': 'theories/becoming/results/records/closed-capture.html',
                                             'a': 'closed-capture', 's': 'an existing Lean receipt is recorded'}])
        for entry in index['pages'] + index['results']:
            self.assertTrue((self.out / entry['u']).is_file(), entry['u'])
            self.assertFalse(entry['u'].startswith('sources/'), entry['u'])
        self.assertNotIn('A private chat', self.page('search.json'))  # sources/ is off the site and off the index

    def mussels(self):
        """Pages where 'mussels' is a heading, a page's lead and a former id."""
        (self.tmp / 'a/OPENING.md').write_text('## Truth exists\n\nThe opening.\n\n## Mussels\n\nText.\n')
        (self.tmp / 'a/ONE.md').write_text('# One page\n\n[中文](ONE.zh.md) · [Uses](USES.md) · [Graph](GRAPH.md)\n\n*Two minutes to read, '
                                           'the paragraph below one of them.*\n\nA bed of mussels dies the first month fewer than seventy tons '
                                           'are left in the lake.\n\n## What it is\n\nText.\n')
        renamed = 'theories/becoming/results/records/mussels-old.md'
        (self.tmp / renamed).write_text('# mussels-old (renamed)\n\nThe record `mussels-old` is now `closed-capture`, and its history is kept there.\n')
        self.files.add(renamed)
        self.build(pages=SITE['pages'] + [renamed])

    def test_the_search_reads_leads_and_marks_a_former_id(self):
        self.mussels()
        index = json.loads(self.page('search.json'))
        self.assertEqual(index['pages'][0]['u'], 'index.html')  # the home, first
        self.assertTrue(index['pages'][0]['l'].startswith('An account of how things go on.'))
        one = next(p for p in index['pages'] if p['u'] == 'a/ONE.html')
        self.assertEqual(one['l'], 'A bed of mussels dies the first month fewer than seventy tons are left in the lake.')  # not the line of links or the time
        old = next(p for p in index['pages'] if p['u'] == 'theories/becoming/results/records/mussels-old.html')
        self.assertEqual((old.get('f'), 'l' in old), (1, False))
        self.assertEqual(site.lead('<p>' + 'word ' * 200 + '</p>')[-1], '…')
        self.assertLessEqual(len(site.lead('<p>' + 'word ' * 200 + '</p>')), site.LEAD_MAX + 1)
        said = '<p>One graph of the theory, with the edges between its results kept apart by kind.</p>'
        for before in ('<a href="GRAPH.zh.html">中文（各章一览）</a> · 72–94 minutes to read in full; the chapters at a glance in 29–38 minutes.',
                       '<a href="LINEAGE.zh.html">中文</a> · 110–142 minutes to read in full; the brief, the picture and the threads in 30–39 minutes.',
                       'Board item T1N, 5 November 2026. AI-written (a Claude Code session). About 4 to 6 minutes to read.',
                       '<code>coupled-drawers-keep-a-need-only-where-the-coupling-reaches-it</code> · <strong>an existing Lean receipt is '
                       'recorded</strong> · theorem · F01 · <a href="x.json">record</a> · <a href="R.html">register</a>'):
            self.assertEqual(site.lead('<p>' + before + '</p>\n' + said), strip(said), before)  # a language link, a time to read, a status line
        for before in ('Board item LA1b, 27 October 2026. AI-written (a Claude Code session).',
                       'Board item SE1 (line E), 20 October 2026. AI-written (a Claude Code session started from the significance-aim '
                       'session). Study section 263 of BECOMING-RENEWAL-READING. Literature check: significance review, "side effects".',
                       'Board item UE32, 3 November 2026; run 4 November 2026. AI-written (a Claude Code session; no person\'s review of '
                       'it is recorded). About twenty to twenty-seven minutes to read, the result fourteen to nineteen of them.'):
            self.assertEqual(site.lead('<p>' + before + '</p>\n' + said), strip(said), before)  # a paragraph of provenance only
        for before, rest in (('Board item LA1, 22 October 2026. AI-written (a Claude Code session). ',
                              'Claude Haiku, through the Claude Code CLI, takes the member\'s place in a commons that renews.'),
                             ('UE32, 3 November 2026. AI-written (a Claude Code session, through a subagent it sent to read). ',
                              'It is the reading behind UE32: the field that reads a state from a series of counts.'),
                             ('AI-authored study, 6 October 2026. ', 'The protocol was written, frozen and committed before the code existed.'),
                             ('Board item IN1, 21 October 2026. AI-written (a Claude Code session). Predictions, verdict rules and code frozen '
                              'before any experimental model call: PREDICTIONS-2026-10-21.md. Prior art: significance review, installation check. ',
                              'Three fishers share a lake, and a bed of mussels that gives them nothing depends on the fish.'),
                             ('6 October 2026. ', 'Executable counterpart of the mathematical market study, its connection named.'),
                             ('Board item X1, 2 May 2026. Literature check: Smith et al. 2020, sections 2.1 and 3. ',
                              'The test reads the bed and the fish, each season, from the frozen tables.'),
                             ('AI-assisted mathematical experiment, 5 October 2026. ',
                              'This evaluates the existing finite-material shared-renewal process, with all event rates retained.'),
                             ('Board item X2, 3 May 2026. Literature check: the review "Seabirds and forage fish." ',
                              'The test reads the colonies and the catch, each season, from the frozen tables.'),
                             ('Board item X3, 4 May 2026. Literature check: Dai et al. ',
                              'The test reads the colonies and the catch, each season, from the frozen tables.'),
                             ('Board item T1N, 5 Nov. 2026. AI-written (a Claude Code session). ',
                              'The rules read the lakes below the need, each with its fate resolved, from the frozen layout.')):
            self.assertEqual(site.lead('<p>' + before + rest + '</p>\n' + said), rest, before)  # what follows the provenance is the lead
        for plain in ('Board games and AI-written essays are read here as one case among many, and nothing about them is provenance.',
                      'AI-written essays are read here as one case among many, and nothing about them is provenance at all.',
                      'About the lake: the bed dies the first month fewer than seventy tons are left, whatever the fishers read.',
                      'About what it takes to read a state from a series, the field has said little, and the test asks why.',
                      'Board items of the old kind are not provenance, whatever their date or their reader says.',
                      'Study sections of this kind are read here as text, and the search should show them whole.',
                      'Predictions frozen before the run failed in four lakes of five, and the fifth was not read at all.'):
            self.assertEqual(site.lead('<p>' + plain + '</p>'), plain)  # a sentence that only starts like provenance stays
        long = '<p>' + 'A paragraph long enough to be a lead says how long it takes, about ten minutes to read, and more. ' * 3 + '</p>'
        self.assertEqual(site.lead(long), strip(long))  # a paragraph of text that names a time is still text
        zh = '<p>正文的第一段：一个选择可以成功，而它所不度量的东西却失去了；这一段足够长，可以作为本页的引言来读。</p>'
        self.assertEqual(site.lead('<p>全文约 117–152 分钟；简述、图、标签与这些线索约 31–40 分钟，其余部分可以留到以后再读。</p>\n' + zh), strip(zh))
        guide = '<p>' + '只有十分钟的读者：先读论题与三种关系，再看第十一节照录的相分与反读；只有一小时的读者：读古文审查材料的一小时之路，依字句、异文与注疏，共六条。' + '</p>'
        self.assertEqual(site.lead(guide + zh), strip(guide))  # in Chinese a line is a third as long

    def test_a_paragraph_more_than_a_few_pages_open_with_is_no_pages_lead(self):
        opening = '<p>The crosswalk, with every folder and domain and their counts.</p>\n'
        own = 'What folder {} claimed in its own terms, and what became of it in the account.'
        page = lambda k: SimpleNamespace(title=f'Folder {k}', toc=[], html=opening + f'<p>{own.format(k)}</p>')
        for many, leads in ((site.LEAD_SHARED, lambda n: [strip(opening)] * n), (site.LEAD_SHARED + 1, lambda n: [own.format(k) for k in range(n)])):
            index = site.search_index({f'a/f{k}.md': page(k) for k in range(many)}, {})
            self.assertEqual([p['l'] for p in index['pages']], leads(many), many)

    @unittest.skipUnless(shutil.which('node'), 'node is not installed')
    def test_a_name_ranks_above_a_lead_and_a_former_id_below_both(self):
        self.mussels()
        run = subprocess.run(['node', '-e', SEARCH_QUERY, str(self.out / 'assets/search.js'), str(self.out / 'search.json'), 'mussels'],
                             capture_output=True, text=True, check=True)
        hits = json.loads(run.stdout)
        self.assertEqual([h[0] for h in hits], ['Mussels', 'One page', 'mussels-old (renamed)'])
        self.assertIn('mussels dies', hits[1][1])  # a hit in a lead shows where
        self.assertEqual(hits[2][1], 'A former id, renamed')

    @unittest.skipUnless(shutil.which('node'), 'node is not installed')
    def test_a_search_hit_closes_the_panel(self):
        self.build()
        run = subprocess.run(['node', '-e', SEARCH_STAGE, str(self.out / 'assets/search.js'), str(self.out / 'search.json')],
                             capture_output=True, text=True, check=True)
        seen = json.loads(run.stdout)
        self.assertEqual(seen['afterHit'], {'hidden': True, 'expanded': 'false', 'focusOnButton': False})  # the reader goes to the hit
        self.assertTrue(seen['openAfterANewTab'])  # a hit opened in a new tab leaves the list to try the next
        self.assertEqual(seen['afterEscape'], {'hidden': True, 'focusOnButton': True})  # Esc still gives the focus back

    def test_the_search_script_is_the_sites_own_and_writes_text_as_text(self):
        self.build()
        script = self.page('assets/search.js')
        self.assertNotRegex(script, r'https?://')
        self.assertNotIn('innerHTML', script)
        self.assertNotIn('eval(', script)
        self.assertIn('<script src="../../assets/search.js" data-root="../../" defer></script>', self.page('a/chapters/index.html'))
        self.assertIn('<script src="assets/search.js" data-root="" defer></script>', self.page('index.html'))
        self.assertIn('<button class="find" type="button" hidden>', self.page('a/ONE.html'))  # shown by the script, so never dead

    def test_the_404_page_links_work_from_any_depth(self):
        self.build()
        page = self.page('404.html')
        self.assertIn('<base href="/r/">', page)
        refs = [r for r in re.findall(r'\b(?:href|src)="([^"]+)"', page) if not re.match(r'https?:', r) and r != '/r/']
        self.assertTrue(refs)
        for ref in refs:
            self.assertFalse(ref.startswith(('/', '../')), ref)  # read from the site's root, by the base
            self.assertTrue((self.out / ref).is_file(), ref)
        self.assertNotIn('aria-current', page)
        self.assertNotIn("This page's source", page)

    def test_the_root_of_the_404_page(self):
        self.assertEqual(site.site_root({'repository': 'o/theories'}), '/theories/')
        self.assertEqual(site.site_root({'repository': 'o/o.github.io'}), '/')
        self.assertEqual(site.site_root({'repository': 'o/theories', 'site_root': '/elsewhere'}), '/elsewhere/')

    def test_a_favicon_is_written_and_linked(self):
        self.build()
        self.assertTrue(self.page('assets/favicon.svg').startswith('<svg'))
        self.assertIn('<link rel="icon" href="../assets/favicon.svg"', self.page('a/ONE.html'))

    # -- the home
    def test_the_cards_follow_start_with_and_the_picture_follows_the_cards(self):
        (self.tmp / 'a/pic.svg').write_text('<svg xmlns="http://www.w3.org/2000/svg"></svg>')
        self.files.add('a/pic.svg')
        (self.tmp / 'README.md').write_text('# T\n\n> Still being revised.\n\n**First.** What it is.\n\n**Start with** [the one page](a/ONE.md).\n\n'
                                            '**Receipts** prove less than they seem.\n\n![The picture](a/pic.svg)\n\n*The caption.*\n\n---\n\n## Truth exists\n\nThe opening.\n')
        self.build(assets=['a/pic.svg'])
        home = self.page('index.html')
        order = [home.index(w) for w in ('Still being revised', 'First.', 'Receipts', 'Start with', 'id="ways-in"', 'class="picture"', 'The caption.')]
        self.assertEqual(order, sorted(order))  # no qualifier falls below the cards; the words are all there
        self.assertNotIn('<hr>', home)

    def test_a_first_screen_without_start_with_keeps_its_order(self):
        blocks = ['<p>One.</p>', '<p><a class="picture" href="p.svg"><img></a></p>', '<p><em>Caption.</em></p>', '<p>Two.</p>', '<hr>']
        self.assertEqual(site.arrange_first_screen(blocks), (['<p>One.</p>', '<p>Two.</p>'], blocks[1:3]))

    # -- what is written
    def test_a_local_path_in_a_written_page_fails_the_build(self):
        (self.tmp / 'a/ONE.md').write_text(ONE + '\n```sh\nPYTHONPATH=/tmp/x /Users/someone/.cache/bin/python3 run.py\n```\n')
        with self.assertRaisesRegex(site.SiteError, r'a/ONE.html prints a local path'):
            self.build()

    def test_what_is_and_is_not_a_local_path(self):
        for path in ('/Users/someone/x', 'file:///Users/someone/x', '/home/someone/x', '/private/tmp/x', '/var/folders/ab/x', 'C:\\Users\\someone',
                     '~/tmp/x', '/Volumes/Disk/x', '-I/Users/someone/include', 'cc -L/tmp/libs', '/tmp/ren-recipient-value-deps',
                     'BECOMING_OUT=/tmp/other', 'BECOMING_OUT=/tmp/becoming-run-2', 'OTHER=/tmp/becoming-run'):
            self.assertTrue(site.LOCAL_PATH.search(path), path)
        for path in ('BECOMING_OUT=/tmp/becoming-run', 'BECOMING_OUT=/tmp/becoming-run python3', 'https://example.org/Users/x', 'https://example.org/home/x/',
                     'https://example.org/tmp/x', 'https://example.org/Volumes/x', 'https://example.org/~/x', '../tmp/notes.md', 'tmp/site/', 'a-I/Users/x'):
            self.assertFalse(site.LOCAL_PATH.search(path), path)

    def test_a_rewrite_changes_the_site_and_not_the_source(self):
        source = ONE + '\n```sh\nPYTHONPATH=/tmp/x /Users/someone/.cache/bin/python3 run.py\n```\n'
        (self.tmp / 'a/ONE.md').write_text(source)
        self.build(rewrites=[{'page': 'a/ONE.md', 'pattern': r'PYTHONPATH=/tmp/\S+ /Users/\S+/python3', 'to': 'PYTHONPATH=<deps> python3'}])
        self.assertIn('PYTHONPATH=&lt;deps&gt; python3 run.py', self.page('a/ONE.html'))
        self.assertEqual((self.tmp / 'a/ONE.md').read_text(), source)

    def test_a_rule_whose_words_have_gone_fails_the_build(self):
        with self.assertRaisesRegex(site.SiteError, 'no longer matches'):
            self.build(rewrites=[{'page': 'a/ONE.md', 'pattern': 'words that are not there', 'to': ''}])
        with self.assertRaisesRegex(site.SiteError, 'not on the site'):
            self.build(rewrites=[{'page': 'a/GONE.md', 'pattern': 'x', 'to': ''}])

    def test_a_rule_for_no_named_page_may_match_nowhere(self):
        (self.tmp / 'a/ONE.md').write_text(ONE + '\nThe map, on this page only, is there.\n')
        self.build(rewrites=[{'pattern': ', on this page only,'}, {'pattern': 'not on any page'}])
        self.assertIn('The map is there.', self.page('a/ONE.html'))

    def test_the_footer_says_when_the_build_changes_words(self):
        self.build()
        self.assertNotIn('changed at build', self.page('a/ONE.html'))
        self.build(rewrites=[{'pattern': 'not on any page'}])
        self.assertIn("converted from the repository's text, with local paths and words true only off the site changed at build; a link",
                      self.page('a/ONE.html'))

    def test_the_footer_says_when_github_may_not_have_the_commit(self):
        with patch.object(site, 'on_github', return_value=False):
            self.build()
        said = ("This commit is not on the repository's main branch as this clone last fetched it (origin/main), so a link to "
                'GitHub at this commit may not resolve until it is pushed.')
        for page in ('a/ONE.html', 'index.html', '404.html'):
            self.assertIn(said, self.page(page).replace('&#x27;', "'"), page)
        with patch.object(site, 'on_github', return_value=True):
            self.build()
        self.assertNotIn('may not resolve', self.page('a/ONE.html'))

    def test_a_chinese_page_has_its_footer_in_chinese(self):
        (self.tmp / 'a/ONE.zh.md').write_text('# 一页\n\n中文的一页。\n')
        self.files.add('a/ONE.zh.md')
        with patch.object(site, 'on_github', return_value=False):
            self.build(pages=SITE['pages'] + ['a/ONE.zh.md'])
        zh, one = self.page('a/ONE.zh.html'), self.page('a/ONE.html')
        footer = zh[zh.index('<footer>'):]
        self.assertIn(f'本站由<a href="https://github.com/o/r">本仓库</a>的提交 <a href="https://github.com/o/r/tree/{COMMIT}"><code>{COMMIT[:9]}</code></a> 构建', footer)
        self.assertIn('此提交不在本地克隆上次获取的仓库主分支（origin/main）上', footer)
        self.assertIn('本页的源文件</a>。', footer)
        self.assertNotIn('Built from', footer)
        self.assertIn('Built from', one[one.index('<footer>'):])  # an English page keeps the English
        with patch.object(site, 'on_github', return_value=None):
            self.build(pages=SITE['pages'] + ['a/ONE.zh.md'])
        self.assertIn('从本地克隆无法查明 GitHub 是否已有此提交', self.page('a/ONE.zh.html'))
        with patch.object(site, 'on_github', return_value=True):
            self.build(pages=SITE['pages'] + ['a/ONE.zh.md'], rewrites=[{'pattern': 'not on any page'}])
        zh = self.page('a/ONE.zh.html')
        self.assertNotIn('打不开', zh)
        self.assertIn('每一页都由仓库中的文本转换而来，只在站外才成立的本地路径与词句在构建时已改；', zh)  # the build's changes, in Chinese
        dirty = site.template('a/ONE.zh.md', '一页', '<p>x</p>', 'zh', SITE | {'repository': 'o/r'}, COMMIT, '2026-11-09', '', '', dirty=True)
        self.assertIn(f'<code>{COMMIT[:9]}</code></a> 及其上尚未提交的改动构建（2026-11-09）', dirty)
        self.assertNotIn('Built from', dirty)

    def test_the_map_says_when_github_may_not_have_the_commit(self):
        from tools.research import connection_map

        def stub(out_dir, link_base, site_paths=None, home='index.html', nav=None):
            out_dir = Path(out_dir)
            out_dir.mkdir(parents=True, exist_ok=True)
            (out_dir / 'map.html').write_text('<!doctype html><head><title>map</title></head><body><nav class="sitebar" aria-label="Site">'
                                              '<a class="home" href="index.html">Home</a></nav><div class="wrap">map</div></body>')
            return out_dir / 'map.html'
        had = hasattr(connection_map, 'site_map')
        old = getattr(connection_map, 'site_map', None)
        connection_map.site_map = stub
        try:
            with patch.object(site, 'on_github', return_value=False):
                self.build(map=True, nav=SITE['nav'] + [['connections.html', 'Map']])
            drawn = (self.out / 'connections.html').read_text()
            self.assertIn('</nav>\n<p class="pushed-note"', drawn)  # under the site bar
            self.assertIn(f'This page was built from commit <code>{COMMIT[:9]}</code>. This commit is not', drawn)  # it names the commit
            self.assertIn("This commit is not on the repository&#x27;s main branch", drawn)  # escaped
            self.assertIn('may not resolve until it is pushed.</p><div class="wrap">', drawn.replace('&#x27;', "'"))
            self.assertEqual((drawn.count('pushed-note'), drawn.count('rel="icon"')), (1, 1))
            with patch.object(site, 'on_github', return_value=None):
                self.build(map=True, nav=SITE['nav'] + [['connections.html', 'Map']])
            self.assertIn('could not be checked from this clone', (self.out / 'connections.html').read_text())
            with patch.object(site, 'on_github', return_value=True):
                self.build(map=True, nav=SITE['nav'] + [['connections.html', 'Map']])
            self.assertNotIn('pushed-note', (self.out / 'connections.html').read_text())
        finally:
            if had:
                connection_map.site_map = old
            else:
                del connection_map.site_map

    def test_whether_github_has_the_commit(self):
        git = ['git', '-c', 'user.name=x', '-c', 'user.email=x@x', '-c', 'commit.gpgsign=false']
        with tempfile.TemporaryDirectory() as folder, patch.dict(os.environ):
            os.environ.pop('GITHUB_ACTIONS', None)
            os.environ.pop('GITHUB_SHA', None)
            self.assertIsNone(site.on_github('0' * 40, Path(folder)))  # no repository: cannot tell
            subprocess.run(git + ['init', '-q'], cwd=folder, check=True)
            subprocess.run(git + ['commit', '-q', '--allow-empty', '-m', 'one'], cwd=folder, check=True)
            first = subprocess.run(['git', 'rev-parse', 'HEAD'], cwd=folder, capture_output=True, text=True, check=True).stdout.strip()
            self.assertIsNone(site.on_github(first, Path(folder)))  # no origin/main
            subprocess.run(['git', 'update-ref', 'refs/remotes/origin/main', first], cwd=folder, check=True)
            subprocess.run(git + ['commit', '-q', '--allow-empty', '-m', 'two'], cwd=folder, check=True)
            second = subprocess.run(['git', 'rev-parse', 'HEAD'], cwd=folder, capture_output=True, text=True, check=True).stdout.strip()
            self.assertIs(site.on_github(first, Path(folder)), True)
            self.assertIs(site.on_github(second, Path(folder)), False)  # a local commit, not yet pushed
            os.environ.update(GITHUB_ACTIONS='true', GITHUB_SHA=second)
            self.assertIs(site.on_github(second, Path(folder)), True)  # GitHub's own run of the commit: GitHub has it

    def test_a_page_in_chinese_is_named_described_and_labelled_in_chinese(self):
        (self.tmp / 'README.zh.md').write_text('# 中文\n\n中文的首页。\n')
        (self.tmp / 'a/ONE.zh.md').write_text('# 一页\n\n中文的一页，有注。[^n] 见[草稿](../tmp/x.md)。\n\n## 一节\n\n正文。\n\n[^n]: 注文。\n')
        self.files |= {'README.zh.md', 'a/ONE.zh.md'}
        self.build(pages=SITE['pages'] + ['README.zh.md', 'a/ONE.zh.md'], title_zh='题', description_zh='描述',
                   nav=[['index.html', 'Home'], ['README.zh.md', '中文']], nav_zh=[['README.zh.md', '首页'], ['a/ONE.md', 'English']])
        zh, en = self.page('a/ONE.zh.html'), self.page('a/ONE.html')
        for said in ('<a class="brand" href="../README.zh.html">题</a>', '<meta name="description" content="描述">', '<title>一页 · 题</title>',
                     '<nav aria-label="页面">', 'aria-label="本节的链接"', 'aria-label="返回"', 'title="不在公开的仓库中"',
                     '<button class="find" type="button" hidden>搜索</button>'):
            self.assertIn(said, zh)
        for said in ('<a class="brand" href="../index.html">T</a>', '<meta name="description" content="d">', '<nav aria-label="Pages">',
                     'aria-label="Link to this section"'):
            self.assertIn(said, en)

    def test_a_page_named_as_the_site_is_titled_with_the_name_once(self):
        (self.tmp / 'README.zh.md').write_text('# 题\n\n中文的首页。\n')
        (self.tmp / 'a/chapters/README.md').write_text('# T\n\n' + CHAPTERS.split('\n', 2)[2])
        self.files.add('README.zh.md')
        self.build(pages=SITE['pages'] + ['README.zh.md'], title_zh='题', nav=[['index.html', 'Home'], ['README.zh.md', '中文']])
        self.assertIn('<title>题</title>', self.page('README.zh.html'))
        self.assertIn('<title>T</title>', self.page('a/chapters/index.html'))
        self.assertIn('<title>One page · T</title>', self.page('a/ONE.html'))

    def test_the_language_link_stands_outside_the_line_that_scrolls(self):
        self.build(nav=[['index.html', 'Home'], ['a/ONE.md', 'One page'], ['a/OPENING.md', '中文']])
        header = self.page('a/ONE.html').split('<header class="top">')[1].split('</header>')[0]
        line = header.split('<nav aria-label="Pages">')[1].split('</nav>')[0]
        self.assertNotIn('中文', line)
        self.assertIn('</nav><a class="lang" href="OPENING.html" hreflang="zh-Hans" lang="zh-Hans">中文</a><button', header)
        css = (ROOT / 'tools/publishing/site.css').read_text()
        self.assertRegex(css, r'(?m)^header\.top a\.lang \{[^}]*flex: none')  # unindented: outside every @media, so at every width

    def test_a_record_page_says_its_status_in_words(self):
        record = 'theories/becoming/results/records/closed-capture.md'
        (self.tmp / record).write_text('# Closed\n\n`closed-capture` · **recorded-checked** · theorem · F01\n\nThe word `recorded-checked` in a sentence stays.\n')
        self.files.add(record)
        self.build(pages=SITE['pages'] + [record])
        page = self.page(record[:-3] + '.html')
        self.assertIn('<strong>an existing Lean receipt is recorded</strong> · theorem', page)
        self.assertNotIn('<strong>recorded-checked</strong>', page)
        self.assertIn('The word <code>recorded-checked</code> in a sentence stays.', page)


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

    def test_card_times_do_not_mislead(self):
        cfg = site.site_config()
        cards = {w['label']: w for w in cfg['ways_in']}
        self.assertIn('{all:theories/becoming/chapters/0*.md}', cards['The eight chapters']['time'])
        self.assertIn('the index {time}', cards['The eight chapters']['time'])
        for label in ('The tests', 'The register of results', 'The theory graph'):
            self.assertIn('time', cards[label], label)  # a page to look things up in, or read in part, says so
        self.assertNotRegex(cards['Check the proofs']['time'].replace('{time}', ''), r'\d')  # no run's duration: none was timed

    def test_the_opening_is_timed_alike_on_its_card_and_in_start_with(self):
        card = next(w for w in site.site_config()['ways_in'] if w['label'] == 'The opening')
        body = site.navigation.readme_opening().partition('\n### Notes\n')[0]  # what the first screen's {{time:opening}} times
        self.assertEqual(site.card_time(card, ROOT, site.tracked_files()), site.navigation.reading_time(body) + ', without its notes')

    def test_the_chinese_pages_and_navigation(self):
        cfg = site.site_config()
        for page in ('theories/becoming/results/THEORY-GRAPH.zh.md', 'theories/becoming/results/atlas/CROSSWALK.zh.md'):
            self.assertIn(page, cfg['pages'])
        self.assertIn(['theories/becoming/results/atlas/CROSSWALK.zh.md', '对照表'], cfg['nav_zh'])
        pages = site.expand_pages(cfg['pages'], site.tracked_files())
        page = 'theories/becoming/results/atlas/CROSSWALK.zh.md'
        text = site.site_text(page, (ROOT / page).read_text(), site.compile_rewrites(cfg, pages))
        self.assertIn('[连接图（英文）](map.html)', text)  # the map, marked as English

    def test_the_navigation_names_the_main_readings(self):
        labels = [label for _, label in site.site_config()['nav']]
        for label in ('Chapters', 'Overview', 'Results', '中文'):
            self.assertIn(label, labels)
        css = (ROOT / 'tools/publishing/site.css').read_text()
        narrow = css.split('@media (max-width: 600px)')[1].split('@media print')[0]
        self.assertRegex(narrow, r'header\.top nav \{[^}]*flex-wrap: wrap')
        masked = re.findall(r'(@media[^{]*\{\s*)?header\.top nav \{[^}]*mask-image', css)
        self.assertEqual(len(masked), 1)  # one rule fades the line, and only at the widths where it scrolls
        self.assertIn('min-width: 601px', masked[0])

    def test_the_stylesheet_has_no_dead_figure_rule_and_no_mark_over_text(self):
        css = (ROOT / 'tools/publishing/site.css').read_text()
        self.assertNotIn('figure.spine', css)
        self.assertNotRegex(css, r'div\.marks \{[^}]*-\.')

    def test_the_two_published_readmes_are_redacted_at_build(self):
        cfg = site.site_config()
        pages = site.expand_pages(cfg['pages'], site.tracked_files())
        rules = site.compile_rewrites(cfg, pages)
        for page in ('experiments/motor-learning-cost/README.md', 'experiments/recipient-value-learning/README.md'):
            raw, text = (ROOT / page).read_text(), site.site_text(page, (ROOT / page).read_text(), rules)
            self.assertTrue(site.LOCAL_PATH.search(raw), page + ' no longer prints a path: drop its rule')
            self.assertFalse(site.LOCAL_PATH.search(text), page)
            self.assertIn("<the run's dependency folder> <the run's Python>", text)  # marked as withheld, not shown as a bare python3

    def test_the_site_does_not_promise_itself(self):
        cfg = site.site_config()
        rules = site.compile_rewrites(cfg, site.expand_pages(cfg['pages'], site.tracked_files()))
        said = 'To explore the same data, open [the connection map](map.html) on the reader’s site, once it is published, or from a clone; GitHub shows it only as source.'
        self.assertEqual(site.rewritten('x.md', said, rules), 'To explore the same data, open [the connection map](map.html).')
        reworded = 'The map, once it is published, is there; GitHub shows it only as source.'
        self.assertEqual(site.rewritten('x.md', reworded, rules), reworded)  # left whole, for the test below to go red on
        said = ('the map draws it (interactive: once the reader\'s site is published, open it there, or from a clone of the repository, '
                'since GitHub shows only its source; [its picture](x.md) heads the crosswalk)')
        self.assertEqual(site.rewritten('x.md', said, rules), 'the map draws it (interactive; [its picture](x.md) heads the crosswalk)')

    def test_no_page_of_the_site_says_the_site_is_yet_to_come(self):
        cfg = site.site_config()
        pages = site.expand_pages(cfg['pages'], site.tracked_files())
        rules = site.compile_rewrites(cfg, pages)
        for page in pages:
            text = site.site_text(page, (ROOT / page).read_text(), rules)
            self.assertNotRegex(text, r"once (?:it|the reader[’']s site) is published", page)

    def test_patterns_stay_in_one_folder(self):
        files = {'a/x.md', 'a/b/y.md', 'a/README.md'}
        self.assertEqual(site.expand_pages(['a/*.md'], files), ['a/README.md', 'a/x.md'])

    def rules(self):
        cfg = site.site_config()
        return site.compile_rewrites(cfg, site.expand_pages(cfg['pages'], site.tracked_files()))

    def site_text(self, page):
        return site.site_text(page, (ROOT / page).read_text(), self.rules())

    def test_the_chinese_tests_page_is_on_the_site_and_in_the_chinese_line(self):
        cfg = site.site_config()
        self.assertIn('TESTS.zh.md', cfg['pages'])
        self.assertIn(['TESTS.zh.md', '检验'], cfg['nav_zh'])
        self.assertNotIn('TESTS.md', [target for target, _ in cfg['nav_zh']])  # the Chinese line sends no one to the English tests
        self.assertEqual(site.edition('TESTS.md', set(cfg['pages'])), 'TESTS.zh.md')

    def test_the_sites_chapter_index_is_the_chapters_without_the_folders_housekeeping(self):
        index = 'theories/becoming/chapters/README.md'
        source, text = (ROOT / index).read_text(), self.site_text(index)
        for gone in ('## Files in this directory', '## Chapters moved to history', 'in history (below)', 'Rerun `make research-render`'):
            self.assertIn(gone, source, 'the rule cuts what the page no longer has: ' + gone)
            self.assertNotIn(gone, text)
        self.assertIn('## The eight chapters', text)
        for k in range(1, 9):
            chapter = next(p.name for p in (ROOT / 'theories/becoming/chapters').glob(f'0{k}-*.md'))
            self.assertIn(f']({chapter})', text, chapter)  # every chapter is still linked from its row
        self.assertIn('[history](../history/)', text)
        rules = self.rules()
        after = site.site_text(index, source + '\n## A section after the last line\n\nKept.\n', rules)
        self.assertIn('## A section after the last line', after)  # the cut ends at the generator's closing line
        among = source.replace('\n## Chapters moved to history\n', '\n## A section among them\n\nx\n\n## Chapters moved to history\n')
        for changed in (among, source.replace('\nStatus: **chapter** is', '\nKey: **chapter** is'),
                        source.replace('\nRerun `make research-render` after a chapter', '\nRun `make research-render` after a chapter')):
            self.assertNotEqual(changed, source)
            with self.assertRaises(site.SiteError):  # the generator's words changed, or a section came among them: the build fails
                site.site_text(index, changed, rules)

    def test_the_sites_chapter_06_has_one_english_line(self):
        text = self.site_text('theories/becoming/chapters/06-CLASSICAL-TEXTS.md')
        line = next(l for l in text.split('\n') if 'In English:' in l)
        self.assertTrue(line.startswith('<p lang="en">'))
        self.assertIn('(../review/CLASSICAL-TEXTS.md)', line)
        self.assertIn('(../THE-THEORY-OF-BECOMING.md#6-the-classical-texts)', line)
        self.assertEqual(text.count('In English:'), 1)
        self.assertNotIn('In English:', (ROOT / 'theories/becoming/chapters/06-CLASSICAL-TEXTS.md').read_text())  # the site's line only

    def test_the_lineage_card_names_the_pages_three_threads(self):
        card = next(w for w in site.site_config()['ways_in'] if w['path'] == 'theories/LINEAGE.md')
        lineage = (ROOT / 'theories/LINEAGE.md').read_text()
        self.assertIn('the three threads followed below (the selection mechanism, the root and the ethics)', lineage)
        self.assertIn('three threads followed through (the selection mechanism, the root and the ethics)', card['text'])
        self.assertNotIn('one thread', card['text'])

    def test_where_everything_is_leaves_the_lineage_its_own_times(self):
        # MAP.md is hand-written and the lineage's times move with every render: MAP names no figure that would go stale
        line = next(l for l in (ROOT / 'MAP.md').read_text().split('\n') if l.startswith('[How the account grew]'))
        self.assertNotRegex(line, r'\d+–\d+ minutes')
        self.assertIn('states its own reading times', line)

    def test_the_chinese_name_and_description_are_set(self):
        cfg = site.site_config()
        self.assertEqual(cfg['title_zh'], '生灭变化之论')
        self.assertIn('# 生灭变化之论', (ROOT / 'README.zh.md').read_text())  # the Chinese home's own name
        self.assertGreater(site.cjk_share(cfg['description_zh']), 0.5)


@unittest.skipUnless((ROOT / '_process/research').is_dir(), 'the studies are not in this checkout (the Pages job reads only the site)')
class MirroredStudyLinkTests(unittest.TestCase):
    """A page of the site links no study GitHub cannot render where a mirror renders it (research.py repoint-mirrored), and the
    link check refuses such a link however long it has stood."""

    def test_a_front_holding_a_link_to_a_mirrored_study_is_refused(self):
        from tools.research import research
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            (root / 'docs').mkdir()
            (root / 'BIG.md').write_text('# big\n\n' + 'x' * 2000)
            (root / 'docs/old.md').write_text('[kept](../BIG.md#a)\n')
            for args in (['init', '-q'], ['add', '-A'], ['-c', 'user.name=x', '-c', 'user.email=x@x', '-c', 'commit.gpgsign=false', 'commit', '-qm', 'base']):
                subprocess.run(['git', *args], cwd=root, check=True)
            found = lambda fronts: research.oversized_links(root, since='HEAD', limit=1000, fronts=fronts)
            self.assertEqual(found({'docs/old.md'})['new'], [])  # not mirrored: a held link is set apart
            with patch.object(research.mirror, 'folders', return_value={'BIG.md': 'mirror/BIG'}):
                refused, elsewhere = found({'docs/old.md'}), found(set())
        self.assertEqual([(f['file'], f['target'], f['mirrored']) for f in refused['new']], [('docs/old.md', '../BIG.md#a', True)])
        self.assertEqual((elsewhere['new'], elsewhere['held_since']), ([], 1))  # a file not on the site keeps its held link

    def test_no_page_of_the_site_links_a_mirrored_study(self):
        from tools.research import research
        found = research.repoint_mirrored()
        self.assertEqual((found['links'], found['errors']), (0, []), found['list'][:5])

if __name__ == '__main__':
    unittest.main()
