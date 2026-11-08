"""The generated mirrors of studies GitHub cannot render (mirror.py, RW)."""
from __future__ import annotations

import os
import unittest
from unittest.mock import patch

from tools.research import lean_catalogue, mirror, moves, registry

D = 'study/root'
EN = f'{D}/STUDY.md'
ZH = f'{D}/STUDY.zh.md'
FOLDER = f'{D}/mirror/STUDY'
CONFIG = {'mirrors': {'folders': {EN: FOLDER, ZH: FOLDER}}}

EN_TEXT = '''<a id="top"></a>
# A study

> Some passages are only in the [Chinese edition](STUDY.zh.md).

<a id="1-old"></a>

<a id="2-zh-only"></a>
<a id="3-kept"></a>
## 3. Kept (P3)

See [the next section](#4-method-and-a-code-fence), [a chapter](../../chapters/ONE.md#law) and [a line](STUDY.md?plain=1#L20).

### Method

Text with a stray <b and no close
<a id="later-id"></a>
## 4. Method, and a code fence

```text
## 9. Not a heading: inside a fence
```

### Method

[back](#method-1), [first](#method)

## English summary

Summary text, see [§3](#3-kept).
'''

ZH_TEXT = '''# 研究

## 1. 旧

正文。

## 2. 只在中文

见[英文版](STUDY.md#3-kept)。

## 3. 保留

正文。
'''


def built():
    return mirror.Mirror(CONFIG, texts={EN: EN_TEXT, ZH: ZH_TEXT})


class SplitTests(unittest.TestCase):
    def test_pages_and_names(self):
        m = built()
        self.assertEqual([p.path.rsplit('/', 1)[1] for p in m.pages[EN]], ['preamble.md', '003.md', '004.md', 'english-summary.md'])
        self.assertEqual([p.path.rsplit('/', 1)[1] for p in m.pages[ZH]], ['preamble.zh.md', '001.zh.md', '002.zh.md', '003.zh.md'])
        # the anchors directly above a heading go with it; those separated by a blank line stay where they are
        three = m.pages[EN][1]
        self.assertTrue(EN_TEXT[three.start:three.end].startswith('<a id="2-zh-only"></a>\n<a id="3-kept"></a>\n## 3.'))
        self.assertEqual(m.route(EN, '1-old')[0], m.pages[EN][0].path)

    def test_a_heading_in_a_fence_does_not_split(self):
        m = built()
        self.assertNotIn(9, [p.number for p in m.pages[EN]])
        self.assertIn('## 9. Not a heading', EN_TEXT[m.pages[EN][2].start:m.pages[EN][2].end])

    def test_round_trip(self):
        m = built()
        for source, text in ((EN, EN_TEXT), (ZH, ZH_TEXT)):
            self.assertEqual(''.join(text[p.start:p.end] for p in m.pages[source]), text)

    def test_repeated_headings_renumbered_within_the_page(self):
        m = built()
        self.assertEqual(m.route(EN, 'method'), (m.pages[EN][1].path, 'method'))
        self.assertEqual(m.route(EN, 'method-1'), (m.pages[EN][2].path, 'method'))

    def test_an_id_after_a_stray_angle_bracket_stays_on_its_page(self):
        m = built()
        self.assertEqual(m.route(EN, 'later-id')[0], m.pages[EN][2].path)

    def test_the_whole_anchor_set_lands_where_the_pages_hold_it(self):
        m = built()
        out, errors = m.render()
        self.assertEqual(errors, [])
        for source, text in ((EN, EN_TEXT), (ZH, ZH_TEXT)):
            images = {}
            for a in moves.anchors(text):
                page, local = m.route(source, a)
                images.setdefault(page, set()).add(local)
            for p in m.pages[source]:
                self.assertEqual(moves.anchors(out[p.path]), images.get(p.path, set()), p.path)

    def test_section_pages_take_the_first_edition_with_the_heading(self):
        pages = built().section_pages(EN)
        self.assertEqual({n: p.rsplit('/', 1)[1] for n, p in pages.items()}, {3: '003.md', 4: '004.md', 1: '001.zh.md', 2: '002.zh.md'})


class LinkTests(unittest.TestCase):
    def page(self, name):
        out, errors = built().render()
        self.assertEqual(errors, [])
        return out[f'{FOLDER}/{name}']

    def test_links_point_from_the_page(self):
        three = self.page('003.md')
        self.assertIn('[the next section](004.md#4-method-and-a-code-fence)', three)
        self.assertIn('[a chapter](../../../../chapters/ONE.md#law)', three)
        self.assertIn('[a line](004.md?plain=1#L8)', three)  # the source's line 20, the fence's opening line, is 004's 4th line of text

    def test_a_line_link_names_the_page_and_its_line(self):
        m = built()
        page, line = m.line(EN, 20)
        p = next(p for p in m.pages[EN] if p.path == page)
        self.assertEqual(line, mirror.HEADER_LINES + 20 - p.first + 1)

    def test_into_the_same_page_and_into_the_other_edition(self):
        self.assertIn('[back](#method), [first](003.md#method)', self.page('004.md'))  # the second Method is this page's first
        self.assertIn('[Chinese edition](README.md)', self.page('preamble.md'))
        self.assertIn('[英文版](003.md#3-kept)', self.page('002.zh.md'))
        self.assertIn('[§3](003.md#3-kept)', self.page('english-summary.md'))

    def test_a_missing_anchor_is_an_error(self):
        m = mirror.Mirror(CONFIG, texts={EN: EN_TEXT + '\n[gone](#nowhere)\n', ZH: ZH_TEXT})
        _, errors = m.render()
        self.assertTrue(any('#nowhere' in e and 'does not have' in e for e in errors), errors)

    def test_a_page_over_the_limit_is_an_error(self):
        with patch.object(mirror, 'PAGE_LIMIT', 100):
            _, errors = built().render()
        self.assertTrue(any('over 100 bytes' in e for e in errors))

    def test_nothing_but_link_targets_changes(self):
        m = built()
        out, _ = m.render()
        for source in (EN, ZH):
            for p in m.pages[source]:
                body = out[p.path].split('\n', mirror.HEADER_LINES)[mirror.HEADER_LINES]
                original = m.texts[source][p.start:p.end]
                strip = lambda s: ''.join(s[a:b] for a, b in zip([0] + [e for _, e, _ in moves.links(s)], [x for x, _, _ in moves.links(s)] + [len(s)]))
                self.assertEqual(strip(body), strip(original), p.path)


class IndexTests(unittest.TestCase):
    def test_rows_and_what_only_one_edition_has(self):
        out, _ = built().render()
        index = out[f'{FOLDER}/README.md']
        self.assertIn('section 4 has its text only in STUDY.md; sections 1–2 have their text only in STUDY.zh.md', index)
        rows = [l for l in index.split('\n') if l.startswith('| ') and not l.startswith('| §')]
        self.assertEqual([r.split(' | ')[0] for r in rows], ['| —', '| 1', '| 2', '| 3', '| 4', '| —'])
        self.assertIn('| 3 | Kept (P3) | [', index)
        self.assertIn('| English summary | [', index)


class CitedTests(unittest.TestCase):
    def test_the_forms_histories_use(self):
        record = {'history': [{'en': 'study section 358, DELEGATED-CHOICES D12'}, {'en': 'study sections 61 and 62'},
                              {'en': 'study sections 23–25 on LibreOffice format'}, {'en': "Study section 422's pending"},
                              {'en': 'study section 14 (_process/research/2026-10-05-x)'}, {'en': 'study sections 7, 8'},
                              {'en': 'no section here; a study of 3 sections'}]}
        self.assertEqual(mirror.Mirror.cited(record), [7, 8, 14, 23, 24, 25, 61, 62, 358, 422])

    def test_record_sources(self):
        m = built()
        rows, errors = m.record_sources({'id': 'r', 'references': [{'path': EN}], 'history': [{'en': 'study sections 2 and 3'}]})
        self.assertEqual(errors, [])
        self.assertEqual(rows[EN]['index'], f'{FOLDER}/README.md')
        self.assertEqual([(n, p.rsplit('/', 1)[1], z) for n, p, z in rows[EN]['sections']], [(2, '002.zh.md', True), (3, '003.md', False)])
        _, errors = m.record_sources({'id': 'r', 'references': [{'path': EN}], 'history': [{'en': 'study section 9'}]})
        self.assertEqual(errors, [f'r: its history names study section 9, which no edition of {EN} has'])
        self.assertEqual(m.record_sources({'id': 'r', 'references': [{'path': 'other.md'}], 'history': [{'en': 'study section 9'}]}), ({}, []))

    def test_the_record_page_cell(self):
        base = registry.ROOT / 'theories/becoming/results/records'
        r = {'_mirror': {EN: {'index': f'{FOLDER}/README.md', 'sections': [(2, f'{FOLDER}/002.zh.md', True), (3, f'{FOLDER}/003.md', False)]}}}
        cell = registry.source_cell(r, EN, base)
        up = os.path.relpath(registry.ROOT, base)
        self.assertEqual(cell, f'[STUDY.md]({up}/{FOLDER}/README.md) (generated mirror): study sections [2]({up}/{FOLDER}/002.zh.md) (Chinese), [3]({up}/{FOLDER}/003.md)')
        self.assertEqual(registry.source_cell({}, 'a/b.md', base), registry.link('a/b.md', base))


class LeanCatalogueTests(unittest.TestCase):
    def test_a_mirrored_study_is_linked_at_its_page(self):
        with patch.object(lean_catalogue, '_mirror_folders', lambda: {EN: FOLDER}), \
                patch.object(lean_catalogue, '_mirror_links', lambda stamps: {EN: {'x/A.lean': f'{FOLDER}/003.md'}}), \
                patch.object(lean_catalogue, '_stamp', lambda path: (str(path), 0, 0)):
            self.assertEqual(lean_catalogue._mirror_page(EN, 'x/A.lean'), f'{FOLDER}/003.md')
            self.assertEqual(lean_catalogue._mirror_page(EN, 'x/B.lean'), f'{FOLDER}/README.md')
            self.assertEqual(lean_catalogue._mirror_page('other/DOC.md', 'x/A.lean'), 'other/DOC.md')


class TreeTests(unittest.TestCase):
    """The configured mirrors as the tree has them: every invariant above on the real studies."""

    def test_the_tree(self):
        m = mirror.Mirror()
        if not m.folders:
            self.skipTest('no mirror configured')
        out, errors = m.render()
        self.assertEqual(errors, [])
        for source, pages in m.pages.items():
            text = m.texts[source]
            self.assertEqual(''.join(text[p.start:p.end] for p in pages), text, source)
            whole = set(mirror.suffixed([s for _, s in mirror.heading_offsets(text)])) | {x.group(2) for x in moves.ANCHOR_ATTR.finditer(moves.code_mask(text))}
            self.assertEqual(whole, moves.anchors(text), source)
            images = {}
            for a in moves.anchors(text):
                page, local = m.route(source, a)
                images.setdefault(page, set()).add(local)
            for p in pages:
                self.assertEqual(moves.anchors(out[p.path]), images.get(p.path, set()), p.path)
                self.assertLessEqual(len(out[p.path].encode('utf-8')), mirror.PAGE_LIMIT, p.path)
        records, load_errors = registry.load_records()
        self.assertEqual([e for e in load_errors if 'study section' in e or e.startswith('mirror')], [])


if __name__ == '__main__':
    unittest.main()
