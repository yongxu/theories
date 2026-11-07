import hashlib
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

from tools.research import indexes, lean_catalogue, reading_catalogue, session_map


class EnglishTests(unittest.TestCase):
    def test_pairs_render_their_english(self):
        e = reading_catalogue.english
        self.assertEqual(e('有条件的形式结果已检查 / Checked conditional formal result'), 'Checked conditional formal result')
        self.assertEqual(e('基础 / Foundation'), 'Foundation')
        self.assertEqual(e('Knowledge within becoming / 生成中的知识'), 'Knowledge within becoming')
        # English that quotes a Chinese term keeps it; a slash inside English stays.
        self.assertEqual(e('生生的奠基 / A foundation of 生生'), 'A foundation of 生生')
        self.assertEqual(e('Formation/change and use'), 'Formation/change and use')
        self.assertEqual(e('本然良知的生成演化'), '本然良知的生成演化')

    def test_paired_field_falls_back_to_chinese(self):
        self.assertEqual(reading_catalogue.pick({'argument_en': '', 'argument_zh': '中文'}, 'argument'), '中文')
        self.assertEqual(reading_catalogue.pick({'argument_en': 'English', 'argument_zh': '中文'}, 'argument'), 'English')

    def test_rendered_entry_is_english_and_keeps_the_former_heading_anchor(self):
        d = {'id': 'x', 'source': 'theories/becoming/chapters/X.md', 'title_zh': '标题', 'title_en': 'Title',
             'category': 'mechanism', 'status': '已检查 / Checked', 'argument_zh': '论证', 'argument_en': 'Argument',
             'significance_zh': '意义', 'significance_en': 'Significance', 'scope_zh': '范围', 'scope_en': 'Scope',
             'next_zh': '后续', 'next_en': 'Next: more', 'source_sha256': 'ab' * 32}
        body = reading_catalogue.chapter_volume([d], 'A–L', {'x': d['source']})
        self.assertIn('## Title', body)
        self.assertIn('<a id="标题--title"></a>', body)
        self.assertIn('**Next:** more', body)
        self.assertIn('source changed after this reading', body)
        visible = '\n'.join(l for l in body.splitlines() if not l.startswith('<a id='))
        self.assertNotRegex(visible, r'[\u4e00-\u9fff]')


class ReadingGateTests(unittest.TestCase):
    def test_changed_source_is_drift_not_error_and_editions_need_no_entry(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            chapters = root / 'theories/becoming/chapters'
            chapters.mkdir(parents=True)
            (root / 'theories/x').mkdir(parents=True)
            (chapters / 'A.md').write_text('# A\n')
            (chapters / 'A.zh.md').write_text('# 甲\n')
            (chapters / 'README.md').write_text('# index\n')
            (root / 'theories/x/README.md').write_text('# X\n')
            (root / 'manifest.json').write_text(json.dumps({'files': {}}))
            row = {'category': 'c', 'status': 's', 'title_en': 't', 'argument_en': 'a', 'significance_en': 's',
                   'scope_en': 's', 'next_en': 'n'}
            chapter = {**row, 'id': 'a', 'source': 'theories/becoming/chapters/A.md', 'source_sha256': 'old'}
            branch = {**row, 'id': 'x', 'source': 'theories/x/README.md',
                      'source_sha256': hashlib.sha256((root / 'theories/x/README.md').read_bytes()).hexdigest()}
            with patch.object(reading_catalogue, 'ROOT', root), patch.object(reading_catalogue, 'CANON', chapters), \
                    patch.object(reading_catalogue, 'MANIFEST', root / 'manifest.json'), \
                    patch.object(reading_catalogue, 'historical_chapters', return_value=set()):
                errors, drift = reading_catalogue.validate([chapter], [branch])
            self.assertEqual(errors, [])
            self.assertEqual(drift, {'a': 'theories/becoming/chapters/A.md'})


class LeanGroupTests(unittest.TestCase):
    def test_receipt_layers_decide_the_becoming_groups(self):
        layers = {'x/lean/becoming/Becoming/Frame.lean': ('core', 'h'), 'x/lean/GenerativeCore.lean': ('foundation', 'h'),
                  'x/lean/becoming/Becoming/Hexagrams.lean': ('instance', 'h'), 'x/lean/becoming/Becoming/Coverage.lean': ('application', 'h')}
        with patch.object(lean_catalogue, 'receipt_layers', return_value=layers):
            self.assertEqual(lean_catalogue.group('x/lean/becoming/Becoming/Frame.lean'), 'becoming-core')
            self.assertEqual(lean_catalogue.group('x/lean/becoming/Becoming/Hexagrams.lean'), 'becoming-ring')
            self.assertEqual(lean_catalogue.group('x/lean/becoming/Becoming/Coverage.lean'), 'becoming-ring')
            self.assertEqual(lean_catalogue.group('x/lean/GenerativeCore.lean'), 'becoming-core')
            self.assertEqual(lean_catalogue.group('a/universal-ethics/B.lean'), 'ethics')

    def test_receipt_layers_read_paths_relative_to_the_lean_root(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            receipt = root / 'lean/becoming/receipt.json'
            receipt.parent.mkdir(parents=True)
            receipt.write_text(json.dumps({'modules': [{'module': 'M', 'layer': 'core'}, {'module': 'I', 'layer': 'inherited'}],
                                           'source_paths': {'M': 'becoming/M.lean', 'I': 'I.lean'},
                                           'source_sha256': {'M': 'abc', 'I': 'def'}}))
            (root / '_process').mkdir()
            (root / '_process/research-config.json').write_text(json.dumps({'lean_receipt': 'lean/becoming/receipt.json'}))
            lean_catalogue.receipt_layers.cache_clear()
            try:
                with patch.object(lean_catalogue, 'ROOT', root):
                    self.assertEqual(lean_catalogue.receipt_layers(), {'lean/becoming/M.lean': ('core', 'abc')})
            finally:
                lean_catalogue.receipt_layers.cache_clear()

    def test_catalogue_labels_are_english(self):
        for title, _, significance in lean_catalogue.GROUPS.values():
            self.assertNotRegex(title + significance, r'[一-鿿]')
        for label in lean_catalogue.ROLE_LABELS.values():
            self.assertNotRegex(label, r'[一-鿿]')


def _lean(modules: int, theorems: int) -> dict:
    """A manifest of one group's modules, each with `theorems` theorems."""
    files = [{'path': f'x/lean/becoming/Becoming/M{i:02}.lean', 'role': 'working-source', 'group': 'becoming-core', 'sha256': f's{i}'}
             for i in range(modules)]
    contents = {f's{i}': {'declarations': [{'kind': 'theorem', 'qualified_name_hint': f'M{i:02}.t{j}', 'line': j + 1} for j in range(theorems)],
                          'imports': [], 'print_axioms_commands': 0} for i in range(modules)}
    return {'files': files, 'contents_by_sha256': contents}


class LeanPageTests(unittest.TestCase):
    """A group too large for one page GitHub shows is listed on parts, its own page their index."""

    def setUp(self):
        for patcher in (patch.object(lean_catalogue, 'doc_links', lambda file, sources: 'Theory'),
                        patch.object(lean_catalogue, 'PART_LIMIT', 20_000)):
            patcher.start()
            self.addCleanup(patcher.stop)

    def test_a_group_that_fits_keeps_one_page(self):
        manifest = _lean(3, 5)
        parts = lean_catalogue.layout(manifest, {})
        self.assertEqual([len(p) for p in parts['becoming-core']], [3])
        page = lean_catalogue.render_declarations(manifest, {}, 'becoming-core', parts)
        self.assertIn('<summary>M00.lean', page)
        self.assertEqual(lean_catalogue.module_pages(parts)['x/lean/becoming/Becoming/M02.lean'], 'becoming-core.md')

    def test_a_large_group_is_split_into_parts_each_within_the_limit_and_its_page_keeps_every_anchor(self):
        manifest = _lean(12, 40)
        parts = lean_catalogue.layout(manifest, {})['becoming-core']
        self.assertGreater(len(parts), 1)
        self.assertEqual([f['path'] for p in parts for f in p], [f['path'] for f in manifest['files']])  # contiguous, in order
        index = lean_catalogue.render_declarations(manifest, {}, 'becoming-core', {'becoming-core': parts})
        anchors = reading_catalogue.anchors_from_text(index)
        for f in manifest['files']:
            self.assertIn(lean_catalogue.anchor(f['path']), anchors)
        self.assertNotIn('<summary>', index)
        self.assertIn(f'(../lean-declarations/becoming-core-part-2.md#{lean_catalogue.anchor(parts[1][0]["path"])})', index)
        sizes = []
        for n in range(1, len(parts) + 1):
            body = lean_catalogue._part(manifest, {}, 'becoming-core', parts, n)
            sizes.append(len(body.encode()))
            self.assertLessEqual(sizes[-1], lean_catalogue.PART_LIMIT)
            for f in parts[n - 1]:
                self.assertIn(f'<a id="{lean_catalogue.anchor(f["path"])}"></a>', body)
            self.assertIn('(../lean-declarations/becoming-core.md)', body)  # the group's page
        self.assertLess(max(sizes) - min(sizes), lean_catalogue.PART_LIMIT // 3)  # about equal
        listing = lean_catalogue.render_declarations(manifest, {}, parts={'becoming-core': parts})
        self.assertIn(f'(lean-declarations/becoming-core-part-1.md#{lean_catalogue.anchor(parts[0][0]["path"])})', listing)

    def test_pack_falls_back_to_filling_in_order_where_equal_parts_would_overflow(self):
        members = [{'path': str(i)} for i in range(4)]
        room = lean_catalogue.PART_LIMIT - 4_000
        third = room * 6 // 10
        parts = lean_catalogue._pack(members[:3], [third] * 3)  # equal halves would put two in one part, over the room
        self.assertEqual([[f['path'] for f in p] for p in parts], [['0'], ['1'], ['2']])


    def test_one_module_larger_than_a_part_takes_a_part_alone(self):
        room = lean_catalogue.PART_LIMIT - 4_000
        members = [{'path': str(i)} for i in range(3)]
        parts = lean_catalogue._pack(members, [10, room * 2, 10])
        self.assertEqual([[f['path'] for f in p] for p in parts], [['0'], ['1'], ['2']])

    def test_a_page_over_the_limit_or_left_behind_stops_the_catalogue(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            out = root / 'theories/becoming/results'
            (out / 'lean-declarations').mkdir(parents=True)
            (out / 'lean-declarations/ethics-part-3.md').write_text('left by a group that needs fewer parts\n')
            (out / 'lean-declarations/ethics.md').write_text('written\n')
            base = 'theories/becoming/results'
            with patch.object(lean_catalogue, 'ROOT', root), patch.object(lean_catalogue, 'OUT', out), \
                    patch.object(lean_catalogue, 'PAGE_LIMIT', 100):
                found = lean_catalogue.problems({f'{base}/lean-declarations/ethics.md': 'x' * 101, f'{base}/data/big.json': 'x' * 500})
        self.assertEqual(found, [f'{base}/lean-declarations/ethics.md: 101 bytes, more than the 100 GitHub shows',
                                 f'{base}/lean-declarations/ethics-part-3.md: a page the catalogue no longer writes; remove it by name'])


class LeanPageSizeTests(unittest.TestCase):
    def test_the_bound_is_the_atlas_bound(self):
        from tools.research import atlas
        self.assertEqual(lean_catalogue.PAGE_LIMIT, atlas.PAGE_LIMIT)

    def test_every_declaration_page_in_this_checkout_is_within_what_github_shows(self):
        folder = lean_catalogue.OUT / 'lean-declarations'
        pages = sorted(folder.glob('*.md')) + [lean_catalogue.OUT / 'LEAN-INDEX.md', lean_catalogue.OUT / 'LEAN-DECLARATIONS.md']
        self.assertGreater(len(pages), 10)
        for page in pages:
            with self.subTest(page=page.name):
                self.assertLessEqual(page.stat().st_size, lean_catalogue.PAGE_LIMIT)


class IndexTests(unittest.TestCase):
    def test_directive_kind_heuristic(self):
        self.assertEqual(indexes.kind_of("decision to fold Part II"), 'decision')
        self.assertEqual(indexes.kind_of("correction that selection is through a model"), 'correction')
        self.assertEqual(indexes.kind_of("2026-10-08-wisdom-paper-direction.md"), 'direction')
        self.assertEqual(indexes.kind_of("notes.md"), 'record')

    def test_chapter_status(self):
        table = {'K.md': ('Statement source', 'Cited by §3.')}
        status = lambda n, g=frozenset(): indexes.chapter_status(n, table, set(g))[0]
        self.assertEqual(status('01-ROOT.md'), 'chapter')
        self.assertEqual(status('THE-THEORY-OF-BECOMING.md'), 'kept')  # the overview lives one level up
        self.assertEqual(status('THE-THEORY-OF-BECOMING-REFERENCE.md'), 'reference')
        self.assertEqual(status('K.zh.md'), 'Chinese edition')
        self.assertEqual(status('K.md'), 'kept')
        self.assertEqual(status('CLAIMS.md', {'theories/becoming/chapters/CLAIMS.md'}), 'generated')

    def test_stated_date_reads_the_first_date_in_any_of_three_forms(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            for name, head in (('a.md', '# A\n\n19 October 2026. See [x](../2026-10-06-x/README.md).'),
                               ('b.md', '# B\n\nWritten 2026-10-19.'),
                               ('c.md', '# C\n\n2026年10月9日。审读，见 [x](../2026-10-06-x/README.md)。'),
                               ('d.md', '# D\n\nNo date.')):
                (root / name).write_text(head)
            self.assertEqual([indexes.stated_date(n, root) for n in ('a.md', 'b.md', 'c.md', 'd.md')],
                             ['2026-10-19', '2026-10-19', '2026-10-09', ''])

    def test_section_11_table_is_read(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            (root / 'theories/becoming/chapters').mkdir(parents=True)
            (root / indexes.CANONICAL).write_text('| Kind | Chapter | Status |\n|---|---|---|\n| Method | [NONDUAL-METHOD](NONDUAL-METHOD.md) | Read first. |\n')
            self.assertEqual(indexes.chapter_table(root), {'NONDUAL-METHOD.md': ('Method', 'Read first.')})

    def test_shared_source_numbers_get_letters(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            for d in ('15-a', '15-b', '16-c', 'named'):
                (root / 'sources' / d).mkdir(parents=True)
            with patch.object(indexes, 'files_under', return_value=[]):
                groups = {g['dir']: g['alias'] for g in indexes.source_groups(root)}
            self.assertEqual(groups, {'15-a': '15a', '15-b': '15b', '16-c': '16', 'named': ''})

    def test_every_index_page_is_marked_generated(self):
        pages = indexes.render()
        self.assertEqual(set(pages), {indexes.CHAPTERS + '/README.md', indexes.STUDIES + '/README.md', indexes.ROOT_FOUNDATION + '/INDEX.md',
                                      indexes.ROOT_FOUNDATION + '/REVIEWS.md', 'sources/README.md', indexes.DIRECTIVE_INDEX})
        for body in pages.values():
            self.assertIn('<!-- Generated by ', body)
        self.assertNotIn('sources/README.md', {p for p in pages if p.startswith('sources/') and p != 'sources/README.md'})

    def test_session_map_check_writes_nothing(self):
        with patch.object(session_map, 'write_json') as write:
            data, inv = session_map.read(session_map.DATA), session_map.read(session_map.INVENTORY)
            with patch('builtins.print'):
                session_map.check(data, inv, session_map.render(data, inv), write=False)
            write.assert_not_called()


if __name__ == '__main__':
    unittest.main()
