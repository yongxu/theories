import json
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
from tools.research import completion  # noqa: E402

LEAN = """namespace Becoming

variable {F : Type} (W : Web F)

/-- doc -/
theorem Web.base (h : W.Balances) : True := trivial

theorem Web.next (d : Decidable True) : True :=
  W.base trivial

namespace Inner
theorem deeper : True := Web.next (W := W) (isTrue trivial)
end Inner

end Becoming
"""


class ParserTests(unittest.TestCase):
    def setUp(self):
        self.dir = tempfile.TemporaryDirectory()
        path = Path(self.dir.name) / 'M.lean'
        path.write_text(LEAN)
        self.decls = {d['full']: d for d in completion.parse_module(path)}

    def tearDown(self):
        self.dir.cleanup()

    def test_full_names_statements_and_proofs(self):
        self.assertEqual(set(self.decls), {'Becoming.Web.base', 'Becoming.Web.next', 'Becoming.Inner.deeper'})
        self.assertIn('W.Balances', self.decls['Becoming.Web.base']['statement'])
        self.assertIn('W.base', self.decls['Becoming.Web.next']['proof'])

    def test_reading_takes_namespace_and_used_variables(self):
        text = completion.reading(self.decls['Becoming.Web.base'])
        self.assertIn('Web', text)
        self.assertIn('W : Web F', text)

    def test_references_resolve_by_namespace_and_field_notation(self):
        refs = completion._references(self.decls)
        self.assertEqual(refs('Becoming.Web.next'), frozenset({'Becoming.Web.base'}))
        self.assertEqual(refs('Becoming.Inner.deeper'), frozenset({'Becoming.Web.next'}))
        self.assertTrue(completion.reaches(self.decls, 'Becoming.Inner.deeper', 'Becoming.Web.base'))
        self.assertFalse(completion.reaches(self.decls, 'Becoming.Web.base', 'Becoming.Web.next'))

    def test_references_resolve_in_opened_namespaces(self):
        decls = {'Becoming.Other.law': {'proof': 'rfl'},
                 'Becoming.Flow.uses': {'proof': 'law held', 'opens': ['Other']}}
        self.assertEqual(completion._references(decls)('Becoming.Flow.uses'), frozenset({'Becoming.Other.law'}))

    def test_references_drop_projections_after_a_qualified_name(self):
        decls = {'Becoming.Web.base_iff': {'proof': 'Iff.rfl'},
                 'Becoming.Other.uses': {'proof': 'Web.base_iff.mpr held'}}
        self.assertEqual(completion._references(decls)('Becoming.Other.uses'), frozenset({'Becoming.Web.base_iff'}))


class RegisterTests(unittest.TestCase):
    def cov(self):
        return {'rows': [{'id': 'r', 'open_items': [1]}], 'open_register': {'classes': ['further proof', 'philosophical warrant']}}

    def test_logical_premise_needs_meets_unrefuted_and_calibration(self):
        cov = {'rows': [{'id': 'r', 'declarations': ['Becoming.X.a']}],
               'premises': {'items': [{'name': 'decided', 'pattern': r'\bDecidable\b', 'kind': 'logical', 'witnesses': [],
                                       'meets': ['m'], 'unrefuted': [], 'calibration': ['c']}]}}
        decls = {'Becoming.X.a': {'full': 'Becoming.X.a', 'statement': '[Decidable p] : p'}}
        findings, used = completion.k3(cov, decls)
        self.assertEqual(used, {'decided': ['Becoming.X.a']})
        self.assertEqual(len(findings), 1)
        self.assertIn('without unrefuted', findings[0])
        cov['premises']['items'][0]['unrefuted'] = ['u']
        self.assertEqual(completion.k3(cov, decls)[0], [])

    def test_open_register_classes_and_open_parts(self):
        chapter = ('### 8.1 Open items, ranked\n\n1. **A** (further proof; a remark). *Open:* x.\n'
                   '2. **B** (philosophical warrant, §8.5). No formal work.\n3. **A** (guess). x\n\n### 8.2 Next\n')
        findings, items = completion.k7(self.cov(), chapter)
        self.assertEqual([i['class'] for i in items], ['further proof', 'philosophical warrant', 'guess'])
        self.assertTrue(any('class "guess"' in f for f in findings))
        self.assertTrue(any('item 3 (A): no open part' in f for f in findings))
        self.assertTrue(any('"A" listed 2 times' in f for f in findings))

    def test_validation_reports_unknown_names_and_records(self):
        cov = json.loads((ROOT / completion.COVERAGE).read_text())
        cov['rows'][0]['declarations'] = cov['rows'][0]['declarations'] + ['Becoming.no_such_law']
        cov['rows'][0]['records'] = cov['rows'][0]['records'] + ['no-such-record']
        decls = {n: {} for r in cov['rows'] for n in r['declarations'] if n != 'Becoming.no_such_law'}
        decls.update({w: {} for p in cov['premises']['items'] for w in p['witnesses']})
        decls.update({w: {} for p in cov['premises']['items'] for k in ('meets', 'unrefuted', 'calibration') for w in p.get(k, [])})
        decls.update({i: {} for r in cov['rows'] for v in r.get('instances', {}).values() for i in v})
        decls.update({x: {} for c in cov.get('unity', {}).get('constructions', []) for x in c['declarations']})
        decls.update({n: {} for n in cov['ethics_chain']['steps']})
        decls.update({x[k]: {} for x in cov['representation']['natural_number_laws'] for k in ('law', 'dense') if x.get(k)})
        decls.update({a: {} for law in cov.get('master_laws', []) for a in law['anchors']})
        records = {r for row in cov['rows'] for r in row['records']} - {'no-such-record'}
        errors = completion.validate(cov, decls, records)
        self.assertEqual(len(errors), 2, errors)

    def test_validation_reports_unknown_master_law_anchors(self):
        cov = json.loads((ROOT / completion.COVERAGE).read_text())
        decls = completion.sources()
        records = {p.stem for p in (ROOT / completion.RECORDS).glob('*.json')}
        cov['master_laws'] = cov['master_laws'] + [{'id': 'none', 'name': 'None', 'statement': '', 'anchors': ['Becoming.no_such_anchor']}]
        errors = completion.validate(cov, decls, records)
        self.assertEqual(errors, ['coverage: master law none: anchor Becoming.no_such_anchor is not a declaration of the core'])


class RepositoryTests(unittest.TestCase):
    def test_the_coverage_file_validates_against_the_core(self):
        result = completion.evaluate()
        self.assertEqual(result['errors'], [])
        self.assertEqual(set(result['met']), {'K1', 'K2', 'K3', 'K4', 'K5', 'K6', 'K7'})


if __name__ == '__main__':
    unittest.main()
