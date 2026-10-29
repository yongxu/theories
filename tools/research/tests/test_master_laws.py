"""MV: the line under each law from data/master-laws.json, and the check's report of how far the data still matches."""
import json
import unittest
from unittest.mock import patch

from tools.research import registry

NAMES = {'closure': 'closure', 'balance': 'balance', 'return': 'finite runs', 'lumping': 'lumping', 'order': 'order'}


def measured(*entries):
    return {'names': NAMES, 'laws': {e['law']: e for e in entries}}


class MasterLawNote(unittest.TestCase):
    def law(self, *names):
        return {'en': 'A law.', 'zh': '一条律。', 'declarations': list(names)}

    def test_each_dependence(self):
        cases = [
            ({'master_laws': ['closure', 'return'], 'grammar': True, 'dependence': 'grammar'},
             '*Master laws:* closure and finite runs, reaching the grammar.'),
            ({'master_laws': ['balance', 'lumping', 'order'], 'grammar': False, 'dependence': 'balance, represented'},
             '*Master laws:* balance, lumping and order, not reaching the grammar (balance is represented in it both ways).'),
            ({'master_laws': ['order'], 'grammar': False, 'dependence': 'anchor, not reached'},
             '*Master laws:* order, not reaching the grammar.'),
            ({'master_laws': [], 'grammar': False, 'dependence': 'no master law'}, '*Master laws:* none among its reasons.'),
        ]
        for e, line in cases:
            r = {'_master_laws': measured({'law': 1, 'declarations': ['X.a'], **e})}
            self.assertEqual(registry.master_law_note(r, 1, self.law('X.a')), line)

    def test_central_and_outside(self):
        e = {'law': 2, 'declarations': ['X.a', 'Y.b'], 'master_laws': [], 'grammar': False, 'dependence': 'no master law',
             'central': [{'declaration': 'X.a', 'category': 'law of its model', 'reason': 'a bound'}], 'outside': ['Y.b']}
        note = registry.master_law_note({'_master_laws': measured(e)}, 2, self.law('X.a', 'Y.b'))
        self.assertEqual(note, '*Master laws:* none among its reasons; central declaration `X.a`: law of its model (a bound); '
                               '1 of its declarations lies outside the core run.')
        only_outside = {'law': 1, 'declarations': ['Y.b'], 'outside': ['Y.b']}
        self.assertEqual(registry.master_law_note({'_master_laws': measured(only_outside)}, 1, self.law('Y.b')),
                         '*Master laws:* not measured: its declarations lie outside the core run.')

    def test_nothing_where_the_data_does_not_match(self):
        e = {'law': 1, 'declarations': ['X.a'], 'master_laws': [], 'grammar': False, 'dependence': 'no master law'}
        r = {'_master_laws': measured(e)}
        self.assertEqual(registry.master_law_note(r, 1, self.law('X.a', 'X.b')), '')  # declarations changed
        self.assertEqual(registry.master_law_note(r, 2, self.law('X.a')), '')  # a law the data has not read
        self.assertEqual(registry.master_law_note({}, 1, self.law('X.a')), '')  # a record it has not read


class MasterLawsStatus(unittest.TestCase):
    def test_matched_stale_and_unmeasured(self):
        data = {'core_receipt': 'R1', 'names': NAMES, 'records': {'a': [{'law': 1, 'declarations': ['X.a']}]}}
        a = {'id': 'a', 'laws': [{'declarations': ['X.a']}, {'declarations': ['X.b']}],
             '_master_laws': {'names': NAMES, 'laws': {1: data['records']['a'][0]}}}
        with patch.object(registry, 'master_laws', return_value=data):
            status = registry.master_laws_status([a, {'id': 'b'}])
        self.assertEqual(status['laws_not_matched'], 1)
        self.assertEqual(status['first_not_matched'], ['a:2'])
        self.assertFalse(status['current'])
        with patch.object(registry, 'master_laws', return_value={}):
            self.assertEqual(registry.master_laws_status([a]), {'measured': False})

    def test_the_repository_file_reads(self):
        data = registry.master_laws()
        if not data:
            self.skipTest('no data/master-laws.json')
        self.assertTrue(set(data['names']) == set(NAMES))
        for ident, entries in data['records'].items():
            for e in entries:
                self.assertIn('declarations', e)
                if 'dependence' in e:
                    self.assertIn(e['dependence'], ('grammar', 'balance, represented', 'anchor, not reached', 'no master law'))
                    self.assertTrue(set(e['master_laws']) <= set(NAMES))
                    self.assertEqual(e['grammar'], e['dependence'] == 'grammar')


if __name__ == '__main__':
    unittest.main()
