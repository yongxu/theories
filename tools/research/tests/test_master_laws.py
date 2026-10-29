"""MV: the line under each law from data/master-laws.json, and the check's report of how far the data still matches."""
import hashlib
import json
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from tools.research import registry

NAMES = {'closure': 'closure', 'balance': 'balance', 'return': 'finite runs', 'lumping': 'lumping', 'order': 'order'}
LABEL = '*Master laws, by Lean dependency:* '


def measured(*entries):
    return {'names': NAMES, 'laws': {e['law']: e for e in entries}}


def law(*names):
    return {'en': 'A law.', 'zh': '一条律。', 'declarations': list(names)}


class MasterLawNote(unittest.TestCase):
    def note(self, e, i=1, names=('X.a',)):
        return registry.master_law_note({'_master_laws': measured({'law': i, 'declarations': list(names), **e})}, i, law(*names))

    def test_each_dependence(self):
        cases = [
            ({'master_laws': ['closure', 'return'], 'grammar': True, 'dependence': 'grammar'},
             'closure and finite runs; its declarations reach the grammar.'),
            ({'master_laws': [], 'grammar': True, 'dependence': 'grammar'},
             "no master law's anchor; its declarations reach the grammar."),
            ({'master_laws': ['order'], 'grammar': True, 'grammar_vocabulary_only': True, 'dependence': 'grammar'},
             "order; its declarations reach the grammar's vocabulary only."),
            ({'master_laws': ['balance', 'lumping', 'order'], 'grammar': False, 'dependence': 'balance, represented'},
             'balance, lumping and order; its declarations do not reach the grammar, which represents balance and cannot '
             'state it without amounts.'),
            ({'master_laws': ['order'], 'grammar': False, 'dependence': 'anchor, not reached'},
             'order; its declarations do not reach the grammar.'),
            ({'master_laws': [], 'grammar': False, 'dependence': 'no master law'},
             "no master law's anchor among the constants its declarations use."),
        ]
        for e, text in cases:
            self.assertEqual(self.note(e), LABEL + text)

    def test_an_unknown_dependence_is_shown_as_it_is(self):
        e = {'master_laws': ['closure'], 'grammar': True, 'dependence': 'reach by representation'}
        self.assertEqual(self.note(e), LABEL + 'closure; its declarations: reach by representation.')

    def test_central_defines_and_outside(self):
        e = {'master_laws': ['balance'], 'grammar': False, 'dependence': 'balance, represented', 'defines': ['X.a'],
             'central': [{'declaration': 'X.a', 'category': 'master law', 'dependence': 'anchor, not reached',
                          'reason': "a law of its model (OU3d's review)"},
                         {'declaration': 'X.c', 'category': 'premise of the account', 'dependence': 'balance, represented',
                          'reason': 'support'}],
             'outside': ['Y.b']}
        text = self.note(e, names=('X.a', 'Y.b', 'X.c'))
        self.assertEqual(text, LABEL + 'it defines the anchor `X.a`; balance; its declarations do not reach the grammar, which represents '
                         'balance and cannot state it without amounts; the measure counts central declaration `X.a` (on an anchor, not '
                         'reaching the grammar alone) as following from a master law (not reaching the grammar: a law of its model); '
                         'the measure counts central declaration `X.c` as following from a premise of the account (support); '
                         '1 of its declarations is not in the spine run and not measured, so this holds of the others only.')
        self.assertNotIn('OU3d', text)
        only_outside = {'law': 1, 'declarations': ['Y.b'], 'outside': ['Y.b']}
        self.assertEqual(registry.master_law_note({'_master_laws': measured(only_outside)}, 1, law('Y.b')),
                         LABEL + 'not measured: none of its declarations is in the spine run the measure reads.')

    def test_nothing_where_the_data_does_not_match_or_there_is_nothing_to_measure(self):
        e = {'law': 1, 'declarations': ['X.a'], 'master_laws': [], 'grammar': False, 'dependence': 'no master law'}
        r = {'_master_laws': measured(e)}
        self.assertEqual(registry.master_law_note(r, 1, law('X.a', 'X.b')), '')  # declarations changed
        self.assertEqual(registry.master_law_note(r, 2, law('X.a')), '')  # a law the data has not read
        self.assertEqual(registry.master_law_note({}, 1, law('X.a')), '')  # a record it has not read
        empty = {'law': 1, 'declarations': []}
        self.assertEqual(registry.master_law_note({'_master_laws': measured(empty)}, 1, law()), '')  # no declarations

    def test_the_note_is_a_child_of_its_item(self):
        laws = [law('X.a') for _ in range(11)]
        e = {'master_laws': [], 'grammar': False, 'dependence': 'no master law'}
        r = {'schema_version': 2, 'id': 'r', 'title': {'en': 'R'}, 'statement': {'en': 'S.'}, 'laws': laws,
             '_master_laws': measured(*[{'law': i, 'declarations': ['X.a'], **e} for i in range(1, 12)])}
        lines = []
        for i, item in enumerate(r['laws'], 1):  # the render loop's two lines for each law
            note = registry.master_law_note(r, i, item)
            lines += [f'{i}. ' + item['en'], ' ' * len(f'{i}. ') + '- ' + note]
        self.assertTrue(lines[1].startswith('   - '))
        self.assertTrue(lines[19].startswith('    - '))  # under '10. ', four spaces
        source = Path(registry.__file__).read_text()
        self.assertIn("lines += [' ' * len(f'{i}. ') + '- ' + note]", source)


class MasterLawsStatus(unittest.TestCase):
    def setUp(self):
        self.dir = tempfile.TemporaryDirectory()
        self.root = Path(self.dir.name)
        (self.root / 'measure.py').write_text('measure')
        self.receipt = self.root / 'receipt.json'

    def tearDown(self):
        self.dir.cleanup()

    def status(self, data, records, receipt_sources):
        self.receipt.write_text(json.dumps({'utc': 'R', 'source_sha256': receipt_sources}))
        with patch.object(registry, 'ROOT', self.root), patch.object(registry, 'CORE_RECEIPT', 'receipt.json'), \
                patch.object(registry, 'master_laws', return_value=data):
            return registry.master_laws_status(records)

    def data(self, sources, inputs=None):
        return {'core_receipt': 'R', 'names': NAMES, 'inputs_sha256': inputs or {'measure.py': registry.digest(self.root / 'measure.py')},
                'core_sources_sha256': hashlib.sha256(json.dumps(sources, sort_keys=True).encode()).hexdigest(),
                'records': {'a': [{'law': 1, 'declarations': ['X.a']}]}}

    def record(self, *laws_):
        return {'id': 'a', 'laws': list(laws_), '_master_laws': {'names': NAMES, 'laws': {1: {'law': 1, 'declarations': ['X.a']}}}}

    def test_current_when_sources_inputs_and_laws_match(self):
        s = {'Becoming.A': 'h1'}
        status = self.status(self.data(s), [self.record({'declarations': ['X.a']}), {'id': 'b'}], s)
        self.assertTrue(status['current'])
        self.assertEqual(status['laws_not_matched'], 0)

    def test_stale_by_sources_by_inputs_and_by_laws(self):
        s = {'Becoming.A': 'h1'}
        self.assertFalse(self.status(self.data(s), [self.record({'declarations': ['X.a']})], {'Becoming.A': 'h2'})['core_sources_current'])
        changed = self.status(self.data(s, {'measure.py': 'old'}), [self.record({'declarations': ['X.a']})], s)
        self.assertEqual(changed['inputs_changed'], ['measure.py'])
        self.assertFalse(changed['current'])
        laws = self.status(self.data(s), [self.record({'declarations': ['X.a']}, {'declarations': ['X.b']}, {'declarations': []})], s)
        self.assertEqual((laws['laws_not_matched'], laws['first_not_matched']), (1, ['a:2']))  # a law with no declarations is not counted

    def test_unmeasured_and_unreadable(self):
        self.assertEqual(self.status({}, [], {}), {'measured': False})
        self.assertIn('error', self.status({'error': 'x does not parse'}, [], {}))


class TheRepositoryFile(unittest.TestCase):
    def test_it_reads(self):
        data = registry.master_laws()
        if not data:
            self.skipTest('no data/master-laws.json')
        self.assertNotIn('error', data)
        self.assertEqual(list(data['names']), list(NAMES))
        for ident, entries in data['records'].items():
            for e in entries:
                self.assertIn('declarations', e)
                if 'dependence' in e:
                    self.assertIn(e['dependence'], ('grammar', 'balance, represented', 'anchor, not reached', 'no master law'))
                    self.assertEqual(e['master_laws'], [k for k in NAMES if k in e['master_laws']])
                    self.assertEqual(e['grammar'], e['dependence'] == 'grammar')


if __name__ == '__main__':
    unittest.main()
