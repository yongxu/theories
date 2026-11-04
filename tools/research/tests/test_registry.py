"""Check registry failure modes without changing sources or scientific receipts."""
import copy
import json
import unittest
from unittest.mock import patch

from tools.research import registry


class SourceDeclarationTests(unittest.TestCase):
    def test_named_instance_with_namespace_attributes_and_priority(self):
        sources = [
            'namespace Becoming.Expansion\ninstance kind_decided : DecidableEq Kind := by decide\n',
            'instance Expansion.kind_decided : DecidableEq Kind := by decide\n',
            '@[reducible] private instance (priority := 100) kind_decided : DecidableEq Kind := by decide\n',
            'instance (priority := low)\n  kind_decided [Inhabited Kind] : DecidableEq Kind := by decide\n',
        ]
        for source in sources:
            with self.subTest(source=source):
                self.assertTrue(registry.declaration_in_source(source, 'Becoming.Expansion.kind_decided'))

    def test_anonymous_instance_type_and_binders_are_not_names(self):
        sources = [
            'instance : kind_decided := by infer_instance\n',
            'instance (priority := 100) : kind_decided := by infer_instance\n',
            'instance (kind_decided : Type) : Inhabited kind_decided := by infer_instance\n',
            'instance [kind_decided : Inhabited Kind] : Nonempty Kind := by infer_instance\n',
            'instance\n  : kind_decided := by infer_instance\n',
            'instance kind_decided_other : DecidableEq Kind := by decide\n',
        ]
        for source in sources:
            with self.subTest(source=source):
                self.assertFalse(registry.declaration_in_source(source, 'Becoming.Expansion.kind_decided'))

    def test_existing_dotted_and_primed_declarations_remain_exact(self):
        self.assertTrue(registry.declaration_in_source('protected theorem Run.reach (h : True) : True := h',
                                                      'Becoming.Run.reach'))
        self.assertTrue(registry.declaration_in_source("def Example.value' : Nat := 0", "Example.value'"))
        self.assertFalse(registry.declaration_in_source("def Example.value' : Nat := 0", 'Example.value'))


class ReceiptDeclarationNameTests(unittest.TestCase):
    def test_every_receipt_format_lists_its_names(self):
        receipt = {'modules': [
            {'module': 'Becoming.A', 'declarations': [{'kind': 'theorem', 'name': 'Becoming.a'}],
             'axiom_dependencies': {'Becoming.a': []}},
            {'audited_declarations': ['Generative.Model.b'], 'axioms_by_declaration': {'Generative.Model.c': []}},
            {'empty_axiom_audits': ['Generative.D.d'], 'standard_axiom_audits': {'Generative.D.e': ['propext']},
             'standard_dependency_audits': {'Generative.D.f': ['propext']}, 'nonempty_audits': {'Generative.D.g': ['propext']}},
            {'declarations': ['Generative.E.h'], 'audits': [{'name': 'Generative.E.i'}], 'empty_axiom_audits': 0},
            'not a module']}
        self.assertEqual(registry.receipt_declaration_names(receipt),
                         {'Becoming.a', 'Generative.Model.b', 'Generative.Model.c', 'Generative.D.d', 'Generative.D.e',
                          'Generative.D.f', 'Generative.D.g', 'Generative.E.h', 'Generative.E.i'})

    def test_receipt_without_module_list_lists_nothing(self):
        self.assertEqual(registry.receipt_declaration_names({'modules': {'x': 1}}), set())
        self.assertEqual(registry.receipt_declaration_names({}), set())


class RegistryTests(unittest.TestCase):
    def setUp(self):
        self.records = [json.loads(p.read_text()) for p in sorted(registry.RECORDS.glob('*.json'))]
        self.proved = next(r for r in self.records if r['status'] == 'recorded-checked')

    def errors(self):
        return '\n'.join(registry.validate(self.records)[0])

    def test_current_records_are_structurally_valid(self):
        self.assertEqual(self.errors(), '')

    def test_case_insensitive_alias_collision(self):
        self.records[0]['aliases'].append(self.records[1]['id'].upper())
        self.assertIn('duplicate alias', self.errors())

    def test_missing_dependency(self):
        self.records[0]['dependencies'].append({'id': 'missing-result', 'relation': 'formal-reuse', 'detail': {'zh': '测试', 'en': 'test'}})
        self.assertIn('missing or self result link', self.errors())

    def test_dependency_cycle(self):
        a, b = self.records[:2]
        for x, y in [(a, b), (b, a)]:
            x['dependencies'].append({'id': y['id'], 'relation': 'application', 'detail': {'zh': '测试', 'en': 'test'}})
        self.assertIn('circular result dependency', self.errors())

    def test_checked_without_receipt_is_rejected(self):
        self.proved['references'] = [r for r in self.proved['references'] if r['role'] != 'receipt']
        self.assertIn('needs proof source and existing receipt', self.errors())

    def test_wrong_receipt_binding_is_rejected(self):
        self.proved['proof_bindings'][0]['sha256_pointer'] = '/no-such-source'
        self.assertIn('invalid proof receipt binding', self.errors())

    def test_unelaborated_declaration_name_is_rejected(self):
        for r in self.records:
            refs = {x['path']: x for x in r.get('references', [])}
            for binding in r.get('proof_bindings', []):
                data = json.loads((registry.ROOT / binding['receipt']).read_text())
                module = binding['sha256_pointer'].rsplit('/', 1)[-1]
                names = refs[binding['source']].get('declarations', [])
                if names and any(m.get('module') == module for m in data.get('modules', [])):
                    names.append('Nowhere.' + names[0].split('.')[-1])
                    self.assertIn('declarations not elaborated', self.errors())
                    return
        self.skipTest('no receipt lists elaborated declarations')

    def test_unelaborated_alias_is_rejected(self):
        for r in self.records:
            for alias in r.get('aliases', []):
                if alias.startswith('Becoming.') and r.get('proof_bindings'):
                    r['aliases'].append(alias + '_nowhere')
                    self.assertIn('alias not elaborated', self.errors())
                    return
        self.skipTest('no record has a Lean alias and a receipt binding')

    def test_open_target_cannot_be_claimed_complete(self):
        next(r for r in self.records if r['kind'] == 'target')['status'] = 'reviewed-scoped'
        self.assertIn('a target cannot be marked completed', self.errors())

    def test_source_drift_is_reported_without_rewriting_hash(self):
        original = copy.deepcopy(self.records)
        path = registry.ROOT / self.proved['canonical_source']
        real_digest = registry.digest
        with patch.object(registry, 'digest', side_effect=lambda p: '0' * 64 if p == path else real_digest(p)):
            _, drift = registry.validate(self.records)
        self.assertTrue(any(d['path'] == self.proved['canonical_source'] for d in drift))
        self.assertEqual(original, self.records)

    def test_outside_reference_rejected(self):
        self.records[0]['references'][0]['path'] = '../../outside-the-repository'
        self.assertIn('missing or unsafe reference', self.errors())


class OneLanguageTests(unittest.TestCase):
    """Pages render English, falling back to Chinese; the record keeps both."""
    def test_text_field_needs_one_nonempty_language(self):
        for value in ({'en': 'x'}, {'zh': '中'}, {'en': 'x', 'zh': ''}, {'en': ' ', 'zh': '中'}):
            self.assertTrue(registry.pair(value), value)
        for value in (None, 'x', {}, {'en': ' '}, {'en': 'x', 'zh': 3}, {'zh': None}):
            self.assertFalse(registry.pair(value), value)
        self.assertEqual(registry.en({'en': 'English', 'zh': '中文'}), 'English')
        self.assertEqual(registry.en({'en': ' ', 'zh': '中文'}), '中文')
        self.assertEqual(registry.en({'zh': '中文'}), '中文')

    def test_former_heading_anchor_is_kept_once(self):
        page = registry.finish([registry.heading('#', 'Register', '登记 / Register'), '', '## Plain', '',
                                registry.heading('##', 'Plain', 'Plain'), registry.heading('##', 'Next', 'Next / 下一步'),
                                '<a id="next--下一步"></a>'])
        self.assertTrue(page.startswith('<a id="登记--register"></a>\n# Register\n'))
        self.assertEqual(page.count('<a id="next--下一步"></a>'), 1)  # already present, not repeated
        self.assertNotIn('<a id="plain-1"></a>', page)  # a heading that kept its text keeps its anchor

    def test_repository_pages_keep_former_anchors_and_render_english(self):
        from tools.research.reading_catalogue import anchors_from_text
        records, errors = registry.load_records()
        self.assertEqual(errors, [])
        for r in records[:40]:
            page = registry.render_record(r)
            with self.subTest(id=r['id']):
                self.assertNotIn(' / 证据', page)
                self.assertIn('evidence--证据' if r.get('schema_version') == 2 else '沿革-history', anchors_from_text(page))

    def test_superseded_record_names_its_successor_under_next(self):
        records, errors = registry.load_records()
        self.assertEqual(errors, [])
        superseded = [r for r in records if r.get('status') == 'superseded' and r.get('schema_version') == 2]
        self.assertTrue(superseded)
        for r in superseded:
            page = registry.render_record(r)
            with self.subTest(id=r['id']):
                self.assertIn(f'Superseded by [{r["superseded_by"]}](', page)
                self.assertIn('When this record was current, its next step read: ' + registry.en(r['next_delta']), page)
        current = next(r for r in records if r.get('status') != 'superseded' and r.get('schema_version') == 2)
        self.assertNotIn('When this record was current', registry.render_record(current))

    def test_rebinding_history_folds_into_one_counted_line(self):
        r = {'id': 'example', 'history': [
            {'en': '2026-10-09: added as a result.', 'zh': '新增。'},
            {'en': '2026-10-12 P58b: validation scope re-pointed to consolidated receipt 20261011T232354.807725Z. The claim is unchanged.', 'zh': '重新指向。'},
            {'en': '15 October 2026, landing P109 (study section 131): rebound to the new receipts and rehashed: X.md.', 'zh': '重绑。'},
            {'en': '2026-10-09: P12b corrected this record following the fifth review; the consolidated checker was rerun.', 'zh': '更正。'},
        ]}
        lines = registry.history_lines(r)
        self.assertEqual(lines[0], '- 2026-10-09: added as a result.')
        self.assertIn('P12b corrected this record', lines[1])  # changes the record's text: stays visible
        self.assertEqual(len(lines), 3)
        self.assertTrue(lines[2].startswith('- 2 rebinding entries (2026-10-12 to 2026-10-15): '))
        self.assertIn('[record](example.json)', lines[2])
        self.assertEqual(registry.history_lines({'id': 'x', 'history': r['history'][:1]}), ['- 2026-10-09: added as a result.'])


if __name__ == '__main__':
    unittest.main()
