"""The generated mirrors of studies GitHub cannot render (mirror.py, RW)."""
from __future__ import annotations

import os
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

from tools.research import lean_catalogue, mirror, moves, navigation, registry, research

D = 'study/root'
EN = f'{D}/STUDY.md'
ZH = f'{D}/STUDY.zh.md'
FOLDER = f'{D}/mirror/STUDY'
OTHER = f'{D}/OTHER.md'
CONFIG = {'mirrors': {'folders': {EN: FOLDER, ZH: FOLDER}}}

EN_TEXT = '''<a id="top"></a>
# A study

> Some passages are only in the [Chinese edition](STUDY.zh.md).

<a id="1-旧"></a>

<a id="2-只在中文"></a>
<a id="3-kept"></a>
## 3. Kept (P3)

See [the next section](#4-method-and-a-code-fence), [a chapter](../../chapters/ONE.md#law) and [a line](STUDY.md?plain=1#L20).

### Method

Text with a stray <b and no close
<a id="later-id"></a>
## 4. Method, and a code fence

```text
## 9. Not a heading: inside a fence
[in code](not/a/link.md)
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


def built(en=EN_TEXT, zh=ZH_TEXT, **more):
    return mirror.Mirror(CONFIG, texts={EN: en, ZH: zh, **more})


def page_of(m, source, name):
    return next(p for p in m.pages[source] if p.path.rsplit('/', 1)[1] == name)


class SplitTests(unittest.TestCase):
    def test_pages_and_names(self):
        m = built()
        self.assertEqual([p.path.rsplit('/', 1)[1] for p in m.pages[EN]], ['preamble.md', '001.md', '002.md', '003.md', '004.md', 'english-summary.md'])
        self.assertEqual([p.path.rsplit('/', 1)[1] for p in m.pages[ZH]], ['preamble.zh.md', '001.zh.md', '002.zh.md', '003.zh.md'])

    def test_what_a_file_keeps_of_a_section_headed_elsewhere_starts_a_page(self):
        m = built()
        two = page_of(m, EN, '002.md')
        self.assertEqual((two.number, two.title, two.remnant), (2, '', True))
        self.assertEqual(m.route(EN, '1-旧')[0], page_of(m, EN, '001.md').path)
        # an anchor directly above a heading goes with it, unless it starts a section of its own
        three = page_of(m, EN, '003.md')
        self.assertTrue(EN_TEXT[three.start:three.end].startswith('<a id="3-kept"></a>\n## 3.'))
        self.assertTrue(EN_TEXT[two.start:two.end].startswith('<a id="2-只在中文"></a>\n'))

    def test_a_number_prefix_is_not_a_section(self):
        # `61-…` is §6.1's anchor: only an anchor equal to the other edition's heading starts a section
        m = built(en='# S\n\n<a id="61-sub"></a>\n\n## 7. Seven\n', zh='# 研\n\n## 61. 六一\n')
        self.assertEqual([p.number for p in m.pages[EN]], [None, 7])

    def test_a_heading_in_a_fence_does_not_split(self):
        m = built()
        self.assertNotIn(9, [p.number for p in m.pages[EN]])
        four = page_of(m, EN, '004.md')
        self.assertIn('## 9. Not a heading', EN_TEXT[four.start:four.end])

    def test_round_trip(self):
        m = built()
        for source, text in ((EN, EN_TEXT), (ZH, ZH_TEXT)):
            self.assertEqual(''.join(text[p.start:p.end] for p in m.pages[source]), text)

    def test_repeated_headings_renumbered_within_the_page(self):
        m = built()
        self.assertEqual(m.route(EN, 'method'), (page_of(m, EN, '003.md').path, 'method'))
        self.assertEqual(m.route(EN, 'method-1'), (page_of(m, EN, '004.md').path, 'method'))

    def test_an_id_after_a_stray_angle_bracket_stays_on_its_page(self):
        m = built()  # the '<b' is on §3's page, and the id's regex match begins there
        self.assertEqual(m.route(EN, 'later-id')[0], page_of(m, EN, '004.md').path)

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

    def test_lines_are_the_ones_github_numbers(self):
        m = built(en='# S\n\ntext\x0cwith a form feed\n\n## 1. One\n', zh='# 研\n')
        self.assertEqual(page_of(m, EN, '001.md').first, 5)


class LinkTests(unittest.TestCase):
    def page(self, name, m=None):
        out, errors = (m or built()).render()
        self.assertEqual(errors, [])
        return out[f'{FOLDER}/{name}']

    def test_links_point_from_the_page(self):
        three = self.page('003.md')
        self.assertIn('[the next section](004.md#4-method-and-a-code-fence)', three)
        self.assertIn('[a chapter](../../../../chapters/ONE.md#law)', three)

    def test_a_line_link_names_the_page_and_its_line(self):
        self.assertIn('[a line](004.md?plain=1#L8)', self.page('003.md'))  # the source's line 20 is 004's 4th, after a 4-line header
        self.assertEqual(built().line(EN, 20), (f'{FOLDER}/004.md', 8))

    def test_into_the_same_page_and_into_the_other_edition(self):
        self.assertIn('[back](#method), [first](003.md#method)', self.page('004.md'))  # the second Method is this page's first
        self.assertIn('[Chinese edition](README.md)', self.page('preamble.md'))
        self.assertIn('[英文版](003.md#3-kept)', self.page('002.zh.md'))
        self.assertIn('[§3](003.md#3-kept)', self.page('english-summary.md'))

    def test_text_in_code_stays(self):
        self.assertIn('[in code](not/a/link.md)', self.page('004.md'))

    def test_forms_of_target(self):
        source = '# S\n\n## 1. One\n\n' + '\n'.join([
            '[up](/)', '[spaced](a%20b.md)', '[hash](x%23y.md)', '[angle](<a b.md>)', '[root](/top/T.md)',
            '<a href="a%20b.md">h</a>', '[enc](STUDY.md#%31-one)', '[case](STUDY.md#1-ONE)', '[line](STUDY.md#L3)', '[file](STUDY.md?plain=1)']) + '\n'
        one = self.page('001.md', built(en=source, zh='# 研\n'))
        up = '../../../..'
        for expected in (f'[up]({up})', f'[spaced](../../a%20b.md)', '[hash](../../x%23y.md)', '[angle](<../../a b.md>)', f'[root]({up}/top/T.md)',
                         '<a href="../../a%20b.md">', '[enc](#1-one)', '[case](#1-one)', '[line](#L5)', '[file](README.md)'):
            self.assertIn(expected, one)

    def test_a_missing_anchor_is_an_error(self):
        _, errors = built(en=EN_TEXT + '\n[gone](#nowhere)\n').render()
        self.assertTrue(any('#nowhere' in e and 'does not have' in e for e in errors), errors)

    def test_a_page_over_the_limit_is_an_error(self):
        with patch.object(mirror, 'PAGE_LIMIT', 100):
            _, errors = built().render()
        self.assertTrue(any('over 100 bytes' in e for e in errors))

    def test_nothing_but_link_targets_changes(self):
        m = built()
        out, _ = m.render()
        def strip(s):
            spans = moves.links(s)
            return ''.join(s[a:b] for a, b in zip([0] + [e for _, e, _ in spans], [x for x, _, _ in spans] + [len(s)]))
        for source in (EN, ZH):
            for p in m.pages[source]:
                body = out[p.path].split('\n', mirror.HEADER_LINES)[mirror.HEADER_LINES]
                self.assertEqual(strip(body), strip(m.texts[source][p.start:p.end]), p.path)

    def test_first_pages(self):
        m = built()
        pages = m.first_pages(EN)
        self.assertEqual(pages['chapters/ONE.md'], page_of(m, EN, '003.md').path)


class HeaderTests(unittest.TestCase):
    def test_a_page_says_where_the_section_is(self):
        m = built()
        out, _ = m.render()
        one = out[f'{FOLDER}/001.md'].split('\n')[2]
        self.assertIn("This section's heading and text are in the [Chinese edition](001.zh.md); this page holds what the English file keeps of it, under no heading.", one)
        self.assertIn('[英文文件所留的部分](001.md)', out[f'{FOLDER}/001.zh.md'].split('\n')[2])
        self.assertIn('[中文](003.zh.md)', out[f'{FOLDER}/003.md'].split('\n')[2])
        self.assertIn('[英文版](003.md)', out[f'{FOLDER}/003.zh.md'].split('\n')[2])
        self.assertNotIn('Chinese edition', out[f'{FOLDER}/004.md'].split('\n')[2])

    def test_a_long_label_is_cut_at_a_word(self):
        self.assertEqual(mirror.short('Ren’s words quoted in passages that exist only in the Chinese edition'), 'Ren’s words quoted in passages that…')


class IndexTests(unittest.TestCase):
    def test_rows_and_what_only_one_edition_heads(self):
        index = built().render()[0][f'{FOLDER}/README.md']
        self.assertIn('section 4 has a heading only in STUDY.md; sections 1–2 have a heading only in STUDY.zh.md', index)
        rows = [l for l in index.split('\n') if l.startswith('| ') and not l.startswith('| §')]
        self.assertEqual([r.split(' | ')[0] for r in rows], ['| —', '| 1', '| 2', '| 3', '| 4', '| —'])
        self.assertIn('| 3 | Kept (P3) | [', index)
        self.assertIn('| 1 | 旧 | [2 lines, no heading](001.md) | [', index)
        self.assertIn('| English summary | [', index)

    def test_a_note_for_the_folder(self):
        config = {'mirrors': {'folders': CONFIG['mirrors']['folders'], 'notes': {FOLDER: 'Records bind one file.'}}}
        m = mirror.Mirror(config, texts={EN: EN_TEXT, ZH: ZH_TEXT})
        self.assertIn('\nRecords bind one file.\n', m.render()[0][f'{FOLDER}/README.md'])


class ErrorTests(unittest.TestCase):
    def test_a_heading_swallowed_by_a_fence(self):
        _, errors = built(en='# S\n\n## 1. A\n\n```text\n\n## 2. B\n\n## 3. C\n', zh='# 研\n').render()
        self.assertTrue(any('section 2 is inside code' in e for e in errors), errors)

    def test_a_number_twice(self):
        _, errors = built(en='# S\n\n## 2. A\n\n## 2. B\n', zh='# 研\n').render()
        self.assertTrue(any('2 sections numbered 2' in e for e in errors), errors)

    def test_a_page_no_longer_written(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            (root / FOLDER).mkdir(parents=True)
            (root / FOLDER / 'gone.md').write_text('old')
            (root / FOLDER / '003.md').write_text('old')
            m = mirror.Mirror(CONFIG, root=root, texts={EN: EN_TEXT, ZH: ZH_TEXT})
            _, errors = m.render()
        self.assertEqual(errors, [f'mirror: {FOLDER}/gone.md is no longer written from its source; remove it'])


class CitedTests(unittest.TestCase):
    def cited(self, entries, references=(), **more):
        return built(**more).cited({'history': [{'en': e} for e in entries], 'references': [{'path': EN}, *references]}, EN)

    def test_the_forms_histories_use(self):
        self.assertEqual(self.cited(['study section 358, DELEGATED-CHOICES D12', 'study sections 61 and 62', 'study sections 23–25 on LibreOffice format',
                                     "Study section 422's pending", 'study section 14 (_process/research/2026-10-05-x)', 'study sections 7, 8',
                                     'STUDY.md, section 221 added', 'no section here; a study of 3 sections']),
                         [7, 8, 14, 23, 24, 25, 61, 62, 221, 358, 422])

    def test_what_is_not_read(self):
        self.assertEqual(self.cited(['vocabulary of the naming study, section 7', 'Main-study section 28 consumes', 'the existing study §85',
                                     'study section 358, 12 October 2026', 'study sections 61 and 62, 2026-10-12']), [61, 62, 358])

    def test_a_citation_of_another_study_the_record_binds(self):
        other = {OTHER: '# O\n\n## 41. A\n\n## 42. B\n'}
        refs = [{'path': OTHER}]
        self.assertEqual(self.cited(['reconciled study sections 41–42 on formation'], refs, **other), [])
        self.assertEqual(self.cited(['study sections 41–43'], refs, **other), [41, 42, 43])  # not all of them are that study's headings
        self.assertEqual(self.cited(['STUDY.md, section 41'], refs, **other), [41])  # the entry names the file
        self.assertEqual(self.cited(['study sections 41–42']), [41, 42])  # the record binds no other study

    def test_record_sources(self):
        m = built()
        rows, errors = m.record_sources({'id': 'r', 'references': [{'path': EN}], 'history': [{'en': 'study sections 2 and 3'}]})
        self.assertEqual(errors, [])
        self.assertEqual(rows[EN]['index'], f'{FOLDER}/README.md')
        self.assertEqual([(n, p.rsplit('/', 1)[1], z) for n, p, z in rows[EN]['sections']], [(2, '002.zh.md', True), (3, '003.md', False)])
        _, errors = m.record_sources({'id': 'r', 'references': [{'path': EN}], 'history': [{'en': 'study section 9'}]})
        self.assertEqual(errors, [f'r: its history names section 9 of {EN}, which no edition has'])
        self.assertEqual(m.record_sources({'id': 'r', 'references': [{'path': 'other.md'}], 'history': [{'en': 'study section 9'}]}), ({}, []))

    def test_the_record_page_cell(self):
        base = registry.ROOT / 'theories/becoming/results/records'
        up = os.path.relpath(registry.ROOT, base)
        r = {'_mirror': {EN: {'index': f'{FOLDER}/README.md', 'sections': [(2, f'{FOLDER}/002.zh.md', True), (3, f'{FOLDER}/003.md', False)]}}}
        self.assertEqual(registry.source_cell(r, EN, base),
                         f'[STUDY.md]({up}/{FOLDER}/README.md) (generated mirror); its history names sections [2]({up}/{FOLDER}/002.zh.md) (Chinese), [3]({up}/{FOLDER}/003.md)')
        r = {'_mirror': {EN: {'index': f'{FOLDER}/README.md', 'sections': [(3, f'{FOLDER}/003.md', False)]}}}
        self.assertIn('; its history names section [3]', registry.source_cell(r, EN, base))
        self.assertEqual(registry.source_cell({}, 'a/b.md', base), registry.link('a/b.md', base))

    def test_generated_links_go_to_the_mirror(self):
        base = registry.ROOT / 'theories/becoming/results/records'
        up = os.path.relpath(registry.ROOT, base)
        with patch.object(registry, '_MIRRORS', built()):
            self.assertEqual(registry.mirrored(EN), f'{FOLDER}/README.md')
            self.assertEqual(registry.mirrored(f'{EN}#3-kept'), f'{FOLDER}/003.md#3-kept')
            self.assertEqual(registry.mirrored(f'{EN}#nowhere'), f'{EN}#nowhere')
            self.assertEqual(registry.mirrored('a/b.md#x'), 'a/b.md#x')
            self.assertEqual(registry.link(f'{EN}#3-kept', base, 'study'), f'[study]({up}/{FOLDER}/003.md#3-kept)')
            self.assertEqual(navigation.link(EN, 'README.md', 'the study'), f'[the study]({FOLDER}/README.md)')


class LeanCatalogueTests(unittest.TestCase):
    def test_a_mirrored_study_is_linked_at_its_page(self):
        with patch.object(lean_catalogue, '_mirror_folders', lambda: {EN: FOLDER}), \
                patch.object(lean_catalogue, '_mirror_links', lambda stamps: {EN: {'x/A.lean': f'{FOLDER}/003.md'}}), \
                patch.object(lean_catalogue, '_stamp', lambda path: (str(path), 0, 0)):
            self.assertEqual(lean_catalogue._mirror_page(EN, 'x/A.lean'), f'{FOLDER}/003.md')
            self.assertEqual(lean_catalogue._mirror_page(EN, 'x/B.lean'), f'{FOLDER}/README.md')
            self.assertEqual(lean_catalogue._mirror_page('other/DOC.md', 'x/A.lean'), 'other/DOC.md')

    def test_mirror_pages_are_not_documents_of_their_own(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp).resolve()
            (root / 'x').mkdir()
            (root / 'x/A.lean').write_text('')
            for name, up in (('_process/research/S.md', '../..'), ('_process/research/mirror/S/001.md', '../../../..')):
                (root / name).parent.mkdir(parents=True, exist_ok=True)
                (root / name).write_text(f'# T\n\n[a]({up}/x/A.lean)\n')
            with patch.object(lean_catalogue, 'ROOT', root), \
                    patch.object(lean_catalogue, '_mirror_folders', lambda: {'_process/research/S.md': '_process/research/mirror/S'}), \
                    patch.object(lean_catalogue, 'discover', lambda glob: ['_process/research/S.md', '_process/research/mirror/S/001.md']):
                docs, _ = lean_catalogue.documents()
        self.assertEqual(sorted(docs), ['_process/research/S.md'])


class CheckLinksTests(unittest.TestCase):
    def test_text_in_code_or_tex_is_not_a_link(self):
        body = '```text\n[audit](development/missing/AUDIT.md)\n```\n\nSee `[x](also-missing.md)` and \\([EX](0)\\).\n'
        self.assertEqual(research.check_links({'a/PAGE.md': body}), [])
        self.assertEqual(research.check_links({'a/PAGE.md': '[audit](development/missing/AUDIT.md)\n'}),
                         ['a/PAGE.md: missing link development/missing/AUDIT.md'])


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
        self.assertEqual([e for e in load_errors if 'no edition has' in e or e.startswith('mirror')], [])


if __name__ == '__main__':
    unittest.main()
