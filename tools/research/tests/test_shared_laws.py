"""MV: the line under each law from data/shared-laws.json, and the check's report of how far the data still matches."""
import hashlib
import json
import re
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from tools.research import shared_laws, registry

NAMES = {'closure': 'closure', 'balance': 'balance', 'return': 'finite runs', 'lumping': 'lumping', 'order': 'order'}
LABEL = '*Shared laws, by Lean dependency:* '


def measured(*entries):
    return {'names': NAMES, 'laws': {e['law']: e for e in entries}}


def law(*names):
    return {'en': 'A law.', 'zh': '一条律。', 'declarations': list(names)}


class SharedLawNote(unittest.TestCase):
    def note(self, e, i=1, names=('X.a',)):
        return registry.shared_law_note({'_shared_laws': measured({'law': i, 'declarations': list(names), **e})}, i, law(*names))

    def test_each_dependence(self):
        cases = [
            ({'shared_laws': ['closure', 'return'], 'grammar': True, 'dependence': 'grammar'},
             'closure and finite runs; its declarations reach the grammar.'),
            ({'shared_laws': [], 'grammar': True, 'dependence': 'grammar'},
             "no shared law's anchor; its declarations reach the grammar."),
            ({'shared_laws': ['order'], 'grammar': True, 'grammar_vocabulary_only': True, 'dependence': 'grammar'},
             "order; its declarations reach the grammar's vocabulary only."),
            ({'shared_laws': ['balance', 'lumping', 'order'], 'grammar': False, 'dependence': 'balance, represented'},
             'balance, lumping and order; its declarations do not reach the grammar, which represents balance and cannot '
             'state it without amounts.'),
            ({'shared_laws': ['order'], 'grammar': False, 'dependence': 'anchor, not reached'},
             'order; its declarations do not reach the grammar.'),
            ({'shared_laws': [], 'grammar': False, 'dependence': 'no shared law'},
             "no shared law's anchor among the constants its declarations use."),
        ]
        for e, text in cases:
            self.assertEqual(self.note(e), LABEL + text)

    def test_an_unknown_dependence_is_shown_as_it_is(self):
        e = {'shared_laws': ['closure'], 'grammar': True, 'dependence': 'reach by representation'}
        self.assertEqual(self.note(e), LABEL + 'closure; its declarations: reach by representation.')

    def test_central_defines_and_outside(self):
        e = {'shared_laws': ['balance'], 'grammar': False, 'dependence': 'balance, represented', 'defines': ['X.a'],
             'central': [{'declaration': 'X.a', 'category': 'shared law', 'dependence': 'anchor, not reached', 'shared_laws': ['order'],
                          'reason': "a law of its model (OU3d's review)"},
                         {'declaration': 'X.c', 'category': 'premise of the account', 'dependence': 'balance, represented',
                          'shared_laws': ['balance'], 'reason': 'support'}],
             'outside': ['Y.b']}
        text = self.note(e, names=('X.a', 'Y.b', 'X.c'))
        self.assertEqual(text, LABEL + 'its declarations include the anchor `X.a` itself; balance; its declarations do not reach the grammar, '
                         'which represents balance and cannot state it without amounts; the measure counts central declaration `X.a` '
                         '(taken alone: order; not reaching the grammar) as following from a shared law (not reaching the grammar: a law '
                         'of its model); '
                         'the measure counts central declaration `X.c` as following from a premise of the account (support); '
                         '1 of its declarations is not in the spine run and not measured, so this holds of the others only.')
        self.assertNotIn('OU3d', text)
        only_outside = {'law': 1, 'declarations': ['Y.b'], 'outside': ['Y.b']}
        self.assertEqual(registry.shared_law_note({'_shared_laws': measured(only_outside)}, 1, law('Y.b')),
                         LABEL + 'not measured: none of its declarations is in the spine run the measure reads.')

    def test_nothing_where_the_data_does_not_match_or_there_is_nothing_to_measure(self):
        e = {'law': 1, 'declarations': ['X.a'], 'shared_laws': [], 'grammar': False, 'dependence': 'no shared law'}
        r = {'_shared_laws': measured(e)}
        self.assertEqual(registry.shared_law_note(r, 1, law('X.a', 'X.b')), '')  # declarations changed
        self.assertEqual(registry.shared_law_note(r, 2, law('X.a')), '')  # a law the data has not read
        self.assertEqual(registry.shared_law_note({}, 1, law('X.a')), '')  # a record it has not read
        empty = {'law': 1, 'declarations': []}
        self.assertEqual(registry.shared_law_note({'_shared_laws': measured(empty)}, 1, law()), '')  # no declarations

    def test_same_dependence_other_shared_laws_and_the_grammar_reason(self):
        e = {'shared_laws': ['closure', 'balance'], 'grammar': True, 'dependence': 'grammar',
             'central': [{'declaration': 'X.a', 'category': 'shared law', 'dependence': 'grammar', 'shared_laws': []}]}
        self.assertTrue(self.note(e).endswith("the measure counts central declaration `X.a` (taken alone: no shared law's anchor; reaching "
                                              "the grammar) as following from a shared law (by reaching the grammar)."))
        d = {'shared_laws': [], 'grammar': False, 'dependence': 'no shared law',
             'central': [{'declaration': 'X.a', 'category': 'definitional or representational', 'dependence': 'no shared law',
                          'shared_laws': [], 'reason': 'Iff.rfl'}]}
        self.assertTrue(self.note(d).endswith('as following from its definitions (definitional or representational: Iff.rfl).'))

    def test_the_note_is_a_child_of_its_item(self):
        recs, _ = registry.load_records()
        r = next((x for x in recs if len(x.get('laws', [])) >= 10 and x.get('_shared_laws')
                  and registry.shared_law_note(x, 10, x['laws'][9])), None)
        if r is None:
            self.skipTest('no record with ten laws and data')
        lines = registry.render_record_v2(r).split('\n')
        widths = []
        for i, line in enumerate(lines[:-1]):
            m = re.match(r'\d+\. ', line)
            if m and '*Shared laws' in lines[i + 1]:
                widths.append(len(m.group(0)))
                self.assertTrue(lines[i + 1].startswith(' ' * len(m.group(0)) + '- '), lines[i + 1][:40])
        self.assertIn(4, widths)


class SharedLawsStatus(unittest.TestCase):
    def setUp(self):
        self.dir = tempfile.TemporaryDirectory()
        self.root = Path(self.dir.name)
        (self.root / 'measure.py').write_text('measure')
        self.receipt = self.root / 'receipt.json'
        self.receipt_status = 'passed'

    def tearDown(self):
        self.dir.cleanup()

    def status(self, data, records, receipt_sources):
        self.receipt.write_text(json.dumps({'utc': 'R', 'status': self.receipt_status, 'source_sha256': receipt_sources}))
        with patch.object(registry, 'ROOT', self.root), patch.object(registry, 'CORE_RECEIPT', 'receipt.json'), \
                patch.object(registry, 'shared_laws', return_value=data):
            return registry.shared_laws_status(records)

    def data(self, sources, inputs=None):
        return {'core_receipt': 'R', 'names': NAMES, 'inputs_sha256': inputs or {'measure.py': registry.digest(self.root / 'measure.py')},
                'core_sources_sha256': hashlib.sha256(json.dumps(sources, sort_keys=True).encode()).hexdigest(),
                'records': {'a': [{'law': 1, 'declarations': ['X.a']}]}}

    def record(self, *laws_):
        return {'id': 'a', 'laws': list(laws_), '_shared_laws': {'names': NAMES, 'laws': {1: {'law': 1, 'declarations': ['X.a']}}}}

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

    def test_a_failed_receipt_or_a_saved_dump_is_never_current(self):
        s = {'Becoming.A': 'h1'}
        self.receipt_status = 'failed'
        self.assertFalse(self.status(self.data(s), [self.record({'declarations': ['X.a']})], s)['core_sources_current'])
        self.receipt_status = 'passed'
        self.assertFalse(self.status({**self.data(s), 'from_dump': True}, [self.record({'declarations': ['X.a']})], s)['current'])

    def test_unmeasured_and_unreadable(self):
        self.assertEqual(self.status({}, [], {}), {'measured': False})
        self.assertIn('error', self.status({'error': 'x does not parse'}, [], {}))


REVIEW = '_process/review.md'


def at_model(declaration, of, models=('occurrence',), review=REVIEW):
    return {'declaration': declaration, 'of': of, 'models': list(models), 'review': review}


def carrying_record(*items, status='recorded-checked', reviews=(REVIEW,)):
    """Law 1 states the row X.row; law 2 carries the statements at a model."""
    return {'id': 'a', 'status': status, 'references': [{'role': 'review', 'path': p} for p in reviews],
            'laws': [law('X.row'), {**law('M.reading', 'M.lemma'), 'statements_at_model': list(items)}]}


class StatementsAtModelRules(unittest.TestCase):
    """F5's field as the check reads it (architecture/mv/F5-MODEL-STATEMENTS.md §1)."""
    def errors(self, r):
        return registry.statements_at_model_errors(r)

    def test_a_well_formed_item_passes(self):
        self.assertEqual(self.errors(carrying_record(at_model('M.reading', 'X.row', ('process', 'occurrence')))), [])

    def test_the_key_set_of_a_law_is_closed_but_english_alone_stays_allowed(self):
        r = {'id': 'a', 'laws': [{'en': 'A law.', 'declarations': ['X.a']}, {**law('X.b'), 'statment_at_model': []}]}
        self.assertEqual(self.errors(r), ['law 2: keys must lie among en, zh, declarations, statements_at_model: statment_at_model'])

    def test_each_rule(self):
        cases = [
            (carrying_record({'declaration': 'M.reading', 'of': 'X.row', 'models': ['own']}), 'exactly the keys'),
            (carrying_record(at_model('M.reading', 'X.row', ())), 'models must be'),
            (carrying_record(at_model('M.reading', 'X.row', ('own', 'own'))), 'models must be'),
            (carrying_record(at_model('M.reading', 'X.row', ('world',))), 'models must be'),
            (carrying_record(at_model('M.other', 'X.row')), 'is not among its declarations'),
            (carrying_record(at_model('M.reading', 'X.elsewhere')), 'no other law of the record'),
            (carrying_record(at_model('M.reading', 'M.lemma')), 'holds the row of one'),
            (carrying_record(at_model('M.reading', 'X.row', review='_process/other.md')), 'not a reference of role review'),
            (carrying_record(at_model('M.reading', 'X.row'), status='superseded'), 'superseded or withdrawn'),
            (carrying_record(at_model('M.reading', 'X.row'), at_model('M.reading', 'X.row', ('own',))), 'more than one item'),
        ]
        for r, text in cases:
            found = self.errors(r)
            self.assertTrue(any(text in e for e in found), (text, found))
        empty = carrying_record()
        self.assertTrue(any('nonempty list' in e for e in self.errors(empty)))

    def test_the_review_must_name_the_theorem_it_checked(self):
        r = carrying_record(at_model('M.reading', 'X.row'))
        with patch.object(registry, '_review_text', return_value='We read `M.lemma` only.'):
            self.assertEqual(self.errors(r), [f'law 2: its review {REVIEW} does not name M.reading'])
        for named in ('Row 1: `reading` states it at the model.', 'Row 1: `M.reading` states it.'):
            with patch.object(registry, '_review_text', return_value=named):
                self.assertEqual(self.errors(r), [])
        for unnamed in ('The readings, `reading_iff` among them.', 'the reading of it'):
            with patch.object(registry, '_review_text', return_value=unnamed):
                self.assertTrue(self.errors(r), unnamed)  # a longer name, or the word outside code, is not the name

    def test_a_theorem_in_two_records(self):
        a, b = carrying_record(at_model('M.reading', 'X.row')), {**carrying_record(at_model('M.reading', 'X.row')), 'id': 'b'}
        self.assertEqual(registry.statements_at_model_across([a, b]),
                         ['M.reading: the statement at a model of items in more than one record: a, b'])
        self.assertEqual(registry.statements_at_model_across([a]), [])


def const(module, kind, t=(), v=()):
    return {'m': module, 'k': kind, 't': list(t), 'v': list(v)}


class StatementsAtModelVerified(unittest.TestCase):
    """The generator's tests of an item (F5-MODEL-STATEMENTS.md §2), on constants made for the case."""
    def setUp(self):
        M, R = 'Becoming.ModelStatements', 'Becoming.Rows'
        self.C = {
            'Becoming.row': const(R, 'thm', ['Becoming.Web']), 'Becoming.row2': const(R, 'thm'),
            'Becoming.Web': const('Becoming.Basic', 'ind'), 'Becoming.Web.Supported': const(R, 'def', ['Becoming.Web']),
            'Becoming.«则»': const('Becoming.Grammar', 'def'), 'Becoming.«际»': const('Becoming.Grammar', 'def'),
            'Becoming.World.withinStep': const('Becoming.WorldRepresentation', 'def'),
            'Becoming.Web.partialIdentity': const('Becoming.WorldRepresentation', 'def'),
            # requiring is the leaf's relation; living, one level further, reaches the World's relation within a step
            f'{M}.living': const(M, 'def', v=[f'{M}.requiring', 'Becoming.«则»']),
            f'{M}.requiring': const(M, 'def', v=['Becoming.World.withinStep']),
            f'{M}.lemma': const(M, 'thm', v=['Becoming.row']),
            f'{M}.reading': const(M, 'thm', ['Becoming.«际»', f'{M}.living', 'Becoming.Web', 'Becoming.Web.Supported',
                                             'Becoming.Web.partialIdentity'], [f'{M}.lemma']),
            f'{M}.closure': const(M, 'thm', ['Becoming.«则»', f'{M}.living'], [f'{M}.reading']),
            f'{M}.other': const(M, 'thm', ['Becoming.«际»'], ['Becoming.row']),
        }
        self.M = M

    def verify(self, declaration, of, models=('occurrence',), law_names=(), central=frozenset(), others=frozenset()):
        return shared_laws.verify(self.C, at_model(declaration, of, models), list(law_names), set(central), set(others))

    def test_a_reading_through_a_lemma_with_the_model_two_definitions_down(self):
        failed, terms, kept = self.verify(f'{self.M}.reading', 'Becoming.row')
        self.assertEqual(failed, [])
        self.assertEqual(terms, ['Becoming.«则»'])  # «际» is not a grammar term here
        self.assertEqual(kept, ['Becoming.Web', 'Becoming.Web.Supported'])  # the leaf, «际» and partialIdentity are not kept

    def test_each_failure(self):
        self.assertEqual(self.verify(f'{self.M}.reading', 'Becoming.row2')[0], ['its proof does not reach the row'])
        self.assertEqual(self.verify(f'{self.M}.other', 'Becoming.row')[0], ['its statement names no grammar term',
                                                                             'its statement names no relation of the occurrence model'])
        self.assertEqual(self.verify(f'{self.M}.reading', 'Becoming.row', ('process',))[0],
                         ['its statement names no relation of the process model'])
        self.assertEqual(self.verify(f'{self.M}.reading', 'Becoming.row', ('own',))[0], [])  # own is not checked
        self.assertEqual(self.verify('Becoming.absent', 'Becoming.row')[0], ['not in the spine run'])
        self.assertEqual(self.verify(f'{self.M}.reading', 'Becoming.row', law_names=['Becoming.row2'], central={'Becoming.row2'})[0],
                         ['its law holds the central declaration Becoming.row2'])

    def test_which_items_block_the_walk(self):
        x1, x2, x3, x4 = (at_model(f'M.t{k}', of) for k, of in ((1, 'R'), (2, 'R'), (3, 'R'), (4, 'R2')))
        declared = [('a', 2, x1), ('a', 2, x2), ('a', 3, x3), ('b', 2, x4)]
        self.assertEqual(shared_laws.blocked(declared, 'a', 2, x1), {'M.t3', 'M.t4'})  # x2: the same law and the same row

    def test_an_item_the_check_refuses_is_unverified_not_a_crash(self):
        def failures(item, r=None, more=()):
            r = r or carrying_record(item)
            return shared_laws.shape_failures(r, 2, item, [(r['id'], 2, item), *more])
        shape, rules = ['not in the shape the check requires'], ["its record breaks the check's rules"]
        good = at_model('M.reading', 'X.row')
        for bad in ({**good, 'models': 'occurrence'}, {**good, 'models': ['world']}, {**good, 'declaration': ['M.reading']},
                    {**good, 'extra': 1}):
            self.assertEqual(failures(bad), shape)
        self.assertEqual(failures(good), [])
        self.assertEqual(failures(at_model('M.reading', 'X.elsewhere')), rules)  # the row on no other law
        self.assertEqual(failures(good, carrying_record(good, status='withdrawn')), rules)
        self.assertEqual(failures(at_model('M.reading', 'X.row', review='_process/other.md')), rules)  # not a review reference
        self.assertEqual(failures(good, more=[('b', 4, dict(good))]), rules)  # the theorem of two items
        r = carrying_record(good)
        r['laws'][1]['declarations'].append('X.other')
        self.assertEqual(failures(good, r, more=[('a', 1, at_model('X.row', 'X.other'))]), rules)  # a carrying law holds a row

    def test_the_path_through_another_item(self):
        # closure reaches the row only through reading: refused where reading is another row's item, allowed where it is
        # the same law's statement of the same row (the generator leaves it out of others then)
        self.assertEqual(self.verify(f'{self.M}.closure', 'Becoming.row', others={f'{self.M}.reading'})[0],
                         ['its proof does not reach the row'])
        self.assertEqual(self.verify(f'{self.M}.closure', 'Becoming.row')[0], [])


def item_data(declaration='M.reading', of='X.row', verified=True, models=('occurrence',), **extra):
    return {**at_model(declaration, of, models), 'verified': verified, 'grammar_terms': ['Becoming.«则»', 'Becoming.«而»'],
            'other_terms': ['Becoming.Web'], 'row_dependence': 'no shared law', **extra}


class StatementsAtModelLines(unittest.TestCase):
    """F5's lines on a record page (F5-MODEL-STATEMENTS.md §5), through the real render."""
    def page(self, items_declared, items_data, elsewhere=()):
        recs, _ = registry.load_records()
        r = next(x for x in recs if len(x.get('laws', [])) >= 2 and x.get('_shared_laws'))
        r = json.loads(json.dumps({k: v for k, v in r.items() if k != '_shared_laws'}))
        r['laws'] = [law('X.row'), {**law('M.reading'), 'statements_at_model': items_declared}] + r['laws'][2:]
        e1 = {'law': 1, 'declarations': ['X.row'], 'shared_laws': [], 'grammar': False, 'dependence': 'no shared law',
              'stated_at_model': [{'of': 'X.row', 'record': r['id'], 'law': 2, 'declaration': 'M.reading',
                                   'models': items_data[0]['models'], 'review': REVIEW}, *elsewhere]}
        e2 = {'law': 2, 'declarations': ['M.reading'], 'shared_laws': ['closure'], 'grammar': True, 'dependence': 'grammar',
              'statements_at_model': items_data}
        matched = [f'{r["id"]}:2'] if registry.declared_items(e2) == items_declared else []
        r['_shared_laws'] = {'names': NAMES, 'laws': {1: e1, 2: e2}, 'matched_at_model': matched + ['b:3']}
        json.dumps(r, ensure_ascii=False)  # records are dumped as JSON by the check
        return registry.render_record_v2(r)

    def test_both_lines_where_the_data_verified_what_the_record_declares(self):
        page = self.page([at_model('M.reading', 'X.row')], [item_data()],
                         [{'of': 'X.row', 'record': 'b', 'law': 3, 'declaration': 'N.reading', 'models': ['own', 'process'],
                           'review': REVIEW}])
        self.assertIn("   - *At a model (declared; reviewed in [review.md](", page)
        self.assertIn("):* `M.reading` states `X.row` at a World's occurrence model. Computed: its proof reaches the row; its "
                      "statement names, directly or through its module's definitions, `Becoming.«则»` and `Becoming.«而»`; it keeps "
                      "`Becoming.Web` in other terms. The row taken alone: on no shared law's anchor.", page)
        self.assertIn("):* `X.row` is stated at a World's occurrence model by `M.reading` (law 2 of this record).", page)
        self.assertIn("):* `X.row` is stated at the row's own carrier and a process's model by `N.reading` ([b](", page)
        self.assertEqual(page.count('*At a model (declared; reviewed in'), 3)  # every line marks what is declared
        self.assertIn(LABEL + 'closure; its declarations reach the grammar.', page)  # the dependency facts stay as measured

    def test_an_item_only_on_its_rows_own_carrier_is_not_labelled_at_a_model(self):
        page = self.page([at_model('M.reading', 'X.row', ('own',))], [item_data(models=('own',))])
        self.assertNotIn('*At a model', page)
        self.assertEqual(page.count("*On its own carrier (declared; reviewed in"), 2)
        self.assertIn("`M.reading` states `X.row` at the row's own carrier.", page)

    def test_nothing_where_unverified_or_not_what_the_record_declares(self):
        page = self.page([at_model('M.reading', 'X.row')], [item_data(verified=False, failed=['its proof does not reach the row'])])
        self.assertNotIn('states `X.row`', page)
        page = self.page([at_model('M.reading', 'X.row', ('own',))], [item_data()])
        self.assertNotIn('*At a model', page)  # the record changed its models since the data read it

    def test_the_status_counts_changed_items_and_lists_unverified_ones(self):
        e = {'law': 1, 'declarations': ['M.reading'], 'statements_at_model': [item_data(verified=False, failed=['not in the spine run'])]}
        data = {'core_receipt': 'R', 'names': NAMES, 'inputs_sha256': {}, 'core_sources_sha256': '', 'records': {'a': [e]}}
        r = {'id': 'a', 'laws': [{**law('M.reading'), 'statements_at_model': [at_model('M.reading', 'X.other')]}],
             '_shared_laws': {'names': NAMES, 'laws': {1: e}}}
        with patch.object(registry, 'shared_laws', return_value=data):
            status = registry.shared_laws_status([r])
        self.assertEqual((status['laws_not_matched'], status['first_not_matched']), (1, ['a:1']))
        self.assertEqual(status['statements_at_model_unverified'], ['a:1:M.reading (not in the spine run)'])


class TheRepositoryFile(unittest.TestCase):
    def test_it_reads(self):
        data = registry.shared_laws()
        if not data:
            self.skipTest('no data/shared-laws.json')
        self.assertNotIn('error', data)
        self.assertEqual(list(data['names']), list(NAMES))
        for ident, entries in data['records'].items():
            for e in entries:
                self.assertIn('declarations', e)
                if 'dependence' in e:
                    self.assertIn(e['dependence'], ('grammar', 'balance, represented', 'anchor, not reached', 'no shared law'))
                    self.assertEqual(e['shared_laws'], [k for k in NAMES if k in e['shared_laws']])
                    self.assertEqual(e['grammar'], e['dependence'] == 'grammar')
                for x in e.get('statements_at_model', []):
                    self.assertEqual(set(x) - {'failed'}, {'declaration', 'of', 'models', 'review', 'verified', 'grammar_terms',
                                                           'other_terms', 'row_dependence'})
        if 'counts_at_model' in data:
            self.assertEqual(set(data['counts_at_model']), set(data['counts']))
            self.assertEqual(set(data['central_reach']['counts']), {'reaching the grammar', 'stated at a represented model',
                                                                    'stated on its own carrier only', 'the rest'})
            for row, items in data['central_reach']['rows'].items():
                self.assertTrue(all(x['of'] == row for x in items))


if __name__ == '__main__':
    unittest.main()
