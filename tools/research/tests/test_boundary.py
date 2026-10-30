"""MV's boundary field (architecture/mv/BOUNDARY-FIELD.md): the check's rules, the generator's terms, checks, rule and
report on constants made for the case, the page lines and section, the status, and the Lean check on stub modules."""
import copy
import json
import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from tools.research import boundary, master_laws, registry

REVIEW = '_process/review.md'
SCOPE = {'role': 'scope', 'name': {'en': 'the continuation condition'}, 'premise': 'Becoming.Unrestricted',
         'not_entailed': 'Becoming.ReadsOnlyDynamics.not_entails', 'basis': {'en': 'Its scope.'}, 'review': REVIEW}
ORDER = {'role': 'order', 'name': {'en': 'C'}, 'premise': 'Becoming.Comparison', 'not_entailed': None,
         'absent': {'en': 'No theorem shows it.'}, 'basis': {'en': 'Its order.'}, 'review': REVIEW}
HYP = {'hypothesis': 'Becoming.Leaf.H', 'countermodel': 'Becoming.Leaf.form.needs_H', 'fit': 'Becoming.Leaf.form.H_needed'}
LEAF = ['Becoming.Leaf.form', 'Becoming.Leaf.H', 'Becoming.Leaf.form.needs_H', 'Becoming.Leaf.form.H_needed',
        'Becoming.Leaf.recovery', 'Becoming.Leaf.certified', 'Becoming.Leaf.part', 'Becoming.Leaf.bridge']


def standing(d, label, **more):
    return {'declaration': d, 'standing': label, 'basis': {'en': 'Why it stands so.'}, 'review': REVIEW, **more}


def at_hypothesis(d='Becoming.Flow.two', hyps=(HYP,), **more):
    return standing(d, 'under a stated hypothesis', form='Becoming.Leaf.form', hypotheses=[dict(h) for h in hyps],
                    recovery='Becoming.Leaf.recovery', certificate='Becoming.Leaf.certified', **more)


def carrier(*standings, premises=None, own=LEAF, status='recorded-checked', schema=2, ident='edge'):
    return {'id': ident, 'schema_version': schema, 'status': status, 'references': [{'role': 'review', 'path': REVIEW}],
            'laws': [{'en': 'The forms.', 'declarations': list(own)}],
            'boundary': {'standings': copy.deepcopy(list(standings)),
                         'premises_of_the_ethics': copy.deepcopy(premises if premises is not None else [SCOPE, ORDER])}}


WELL_FORMED = [standing('Becoming.Flow.row', 'derived', law=['Becoming.«所闭之界»'], bridges=['Becoming.Flow.bridge_iff'],
                        support=['Becoming.Flow.support']),
               at_hypothesis(bridges=['Becoming.Leaf.bridge']),
               standing('Becoming.Flow.balanced', 'balance in its statement', relational_part='Becoming.Leaf.part'),
               standing('Becoming.Flow.counted', 'counting')]


class FieldRules(unittest.TestCase):
    """The check's rules (§2), as registry.py applies them with the review's text."""
    def errors(self, r, text=None):
        field = r['boundary'] if isinstance(r['boundary'], dict) else {}
        named = '`' + '` `'.join(sorted({n for s in field.get('standings', []) if isinstance(s, dict)
                                         for n in [s.get('declaration'), *boundary.given_names(s)[0]] if isinstance(n, str)}
                                        | {'Becoming.Unrestricted', 'Becoming.ReadsOnlyDynamics.not_entails', 'Becoming.Comparison'})) + '`'
        with patch.object(registry, '_review_text', return_value=named if text is None else text):
            return registry.boundary_errors(r)

    def assertRefused(self, r, text):
        found = self.errors(r)
        self.assertTrue(any(text in e for e in found), (text, found))

    def test_a_well_formed_field_passes(self):
        self.assertEqual(self.errors(carrier(*WELL_FORMED)), [])

    def test_one_hypothesis_definition_may_serve_two_entries(self):
        other = at_hypothesis('Becoming.Flow.three', [{'hypothesis': 'Becoming.Leaf.H', 'countermodel': 'Becoming.Leaf.form.needs_H',
                                                       'fit': 'Becoming.Leaf.form.H_needed'}])
        self.assertEqual(self.errors(carrier(at_hypothesis(), other)), [])

    def test_the_record_carrying_it(self):
        self.assertRefused(carrier(*WELL_FORMED, schema=1), 'needs schema_version 2')
        for status in ('superseded', 'withdrawn'):
            self.assertRefused(carrier(*WELL_FORMED, status=status), 'superseded or withdrawn')
        a, b = carrier(*WELL_FORMED), carrier(*WELL_FORMED, ident='other')
        self.assertEqual(registry.boundary_across([a, b]), ['the boundary field is carried by more than one record: edge, other'])
        self.assertEqual(registry.boundary_across([a, {'id': 'plain'}]), [])

    def test_unknown_keys_at_every_level(self):
        r = carrier(*WELL_FORMED)
        r['boundary']['standing'] = []
        self.assertRefused(r, 'exactly the keys standings and premises_of_the_ethics')
        self.assertRefused(carrier(standing('Becoming.Flow.counted', 'counting', note=1)), 'keys outside the standing counting: note')
        self.assertRefused(carrier(at_hypothesis(hyps=[{**HYP, 'witness': 'x'}])), 'exactly the keys hypothesis, countermodel and fit')
        self.assertRefused(carrier(*WELL_FORMED, premises=[{**SCOPE, 'proof': 'x'}, ORDER]), 'unknown keys: proof')
        self.assertRefused(carrier(standing('Becoming.Flow.counted', 'counting', basis={'en': 'x', 'fr': 'y'})), 'its basis needs')
        r = carrier(*WELL_FORMED)
        r['boundary'] = []
        self.assertRefused(r, 'boundary must be an object')

    def test_each_standings_required_and_forbidden_keys(self):
        self.assertRefused(carrier(standing('Becoming.Flow.row', 'derived')), 'missing keys: law')
        s2 = at_hypothesis()
        del s2['certificate']
        self.assertRefused(carrier(s2), 'missing keys: certificate')
        self.assertRefused(carrier(standing('Becoming.Flow.counted', 'amounts', law=['Becoming.«所闭之界»'])), 'keys outside the standing amounts: law')
        self.assertRefused(carrier(standing('Becoming.Flow.counted', 'connected', relational_part='Becoming.Leaf.part')),
                           'keys outside the standing connected: relational_part')
        self.assertRefused(carrier(standing('Becoming.Flow.row', 'derived', law=['Becoming.«所闭之界»'], form='Becoming.Leaf.form')),
                           'keys outside the standing derived: form')
        for label in ('unplaced', 'premise', 'Derived'):
            self.assertRefused(carrier(standing('Becoming.Flow.row', label)), 'its standing must be one of')
        no_basis = standing('Becoming.Flow.counted', 'counting')
        del no_basis['basis']
        self.assertRefused(carrier(no_basis), 'missing keys: basis')

    def test_names_full_and_not_the_declaration(self):
        self.assertRefused(carrier(standing('Flow.row', 'counting')), 'its declaration must be a full Lean name')
        self.assertRefused(carrier(standing('Becoming.Flow.row', 'derived', law=['«所闭之界»'])), 'law must list full Lean names')
        short = at_hypothesis()
        short['form'] = 'Leaf.form'
        self.assertRefused(carrier(short), 'form must be a full Lean name')
        self.assertRefused(carrier(standing('Becoming.Flow.row', 'derived', law=['Becoming.Flow.row'])), 'names its own declaration')

    def test_empty_lists(self):
        self.assertRefused(carrier(standing('Becoming.Flow.row', 'derived', law=[])), 'law must be a nonempty list')
        self.assertRefused(carrier(standing('Becoming.Flow.row', 'derived', law=['Becoming.«所闭之界»'], bridges=[])),
                           'bridges must be a nonempty list')
        self.assertRefused(carrier(at_hypothesis(hyps=())), 'hypotheses must be a nonempty list')
        self.assertRefused(carrier(), 'boundary standings must be a nonempty list')

    def test_duplicates(self):
        self.assertRefused(carrier(standing('Becoming.Flow.counted', 'counting'), standing('Becoming.Flow.counted', 'amounts')),
                           'Becoming.Flow.counted has more than one standing')
        self.assertRefused(carrier(*WELL_FORMED, premises=[SCOPE, {**ORDER, 'role': 'scope'}]), 'one of role scope and one of role order')
        self.assertRefused(carrier(*WELL_FORMED, premises=[SCOPE]), 'exactly two items')
        for x in ('hypothesis', 'countermodel', 'fit'):
            second = {k: v + '2' for k, v in HYP.items()}
            second[x] = HYP[x]
            self.assertRefused(carrier(at_hypothesis(hyps=[HYP, second]), own=LEAF + [v + '2' for v in HYP.values()]),
                               f'its hypotheses repeat a {x}')
        self.assertRefused(carrier(standing('Becoming.Flow.row', 'derived', law=['Becoming.«所闭之界»'] * 2)), 'law lists a name twice')

    def test_law_bridges_and_support_are_disjoint(self):
        self.assertRefused(carrier(standing('Becoming.Flow.row', 'derived', law=['Becoming.«所闭之界»'], bridges=['Becoming.Flow.x'],
                                            support=['Becoming.Flow.x'])), 'bridges and support share Becoming.Flow.x')
        self.assertRefused(carrier(standing('Becoming.Flow.row', 'derived', law=['Becoming.«所闭之界»'], bridges=['Becoming.«所闭之界»'])),
                           'law and bridges share')

    def test_premises(self):
        self.assertRefused(carrier(*WELL_FORMED, premises=[SCOPE, {k: v for k, v in ORDER.items() if k != 'absent'}]),
                           'absent must say why')
        self.assertRefused(carrier(*WELL_FORMED, premises=[{**SCOPE, 'absent': {'en': 'x'}}, ORDER]), 'absent is allowed only')
        self.assertRefused(carrier(*WELL_FORMED, premises=[{**SCOPE, 'not_entailed': 'not_entails'}, ORDER]), 'not_entailed must be')
        self.assertRefused(carrier(*WELL_FORMED, premises=[{k: v for k, v in SCOPE.items() if k != 'not_entailed'}, ORDER]),
                           'missing keys: not_entailed')

    def test_the_review(self):
        self.assertRefused(carrier(standing('Becoming.Flow.counted', 'counting', review='_process/other.md')),
                           'is not a reference of role review')
        found = self.errors(carrier(*WELL_FORMED), text='`Becoming.Flow.row` and the rest unnamed.')
        self.assertTrue(any('does not name' in e and 'Becoming.Flow.bridge_iff' in e for e in found), found)
        self.assertTrue(any('does not name Becoming.Unrestricted, Becoming.ReadsOnlyDynamics.not_entails' in e for e in found), found)
        less_root = carrier(standing('Becoming.Flow.counted', 'counting'))
        self.assertEqual(self.errors(less_root, text='`Flow.counted` is counting; `Unrestricted`, `ReadsOnlyDynamics.not_entails`, '
                                                     '`Comparison`.'), [])
        self.assertTrue(self.errors(less_root, text='`counted` is counting; `Unrestricted`, `ReadsOnlyDynamics.not_entails`, `Comparison`.'))

    def test_introduced_names_are_the_records_own(self):
        self.assertRefused(carrier(at_hypothesis(), own=LEAF[1:]), "not among the declarations of the record's laws: Becoming.Leaf.form")
        self.assertRefused(carrier(standing('Becoming.Flow.b', 'balance in its statement', relational_part='Becoming.Other.part')),
                           'Becoming.Other.part')
        # a derived entry's laws, bridges and support are the grammar's and the models', not the record's
        self.assertEqual(self.errors(carrier(WELL_FORMED[0], own=[])), [])

    def test_the_messages_name_the_item(self):
        self.assertEqual(self.errors(carrier(standing('Becoming.Flow.counted', 'counting', note=1))),
                         ['boundary standing 1 (Becoming.Flow.counted): keys outside the standing counting: note'])


def const(module, kind, t=(), v=(), **extra):
    return {'m': module, 'k': kind, 't': list(t), 'v': list(v), **extra}


G, P, F = 'Becoming.Grammar', 'Becoming.Prelude', 'Becoming.Flow'
LAW, LAW2 = 'Becoming.«所闭之界»', 'Becoming.«同行»'
CONSTANTS = {
    'Becoming.«际»': const(G, 'def'), 'Becoming.«所闭»': const(G, 'def', ['Becoming.«际»']),
    LAW: const(G, 'thm', ['Becoming.«所闭»'], ['Becoming.helper']),  # a law, proved through a root helper
    LAW2: const(G, 'thm', ['Becoming.«际»']),
    'Becoming.Law.constant_iff_core': const(G, 'thm', ['Becoming.«际»']),  # a law without a «» name
    'Becoming.«所闭之界»._proof_1': const(G, 'thm', ['Becoming.«际»']),  # an auxiliary
    'Becoming.Small': const(P, 'def'), 'Becoming.helper': const(P, 'thm', ['Becoming.Small']),
    'Becoming.kept_onward': const(G, 'thm', ['Becoming.Small'], [LAW]),  # a root helper whose statement names no «» term
    'Becoming.fire': const(G, 'def', cv=True), 'Becoming.«两火»': const(G, 'thm', ['Becoming.«际»', 'Becoming.fire']),
    'Becoming.«非真则假»': const(G, 'thm', ['Bool']),  # a fact of Bool: no «» term
    'Becoming.GrammarCourse.lockedAlike': const('Becoming.GrammarCourse', 'def', [F]),  # built on a model
    'Becoming.TwoCourses.core_iff': const('Becoming.GrammarCourse', 'thm', ['Becoming.«际»'], ['Becoming.Flow.fact']),
    'Becoming.MapRegions.«图»': const('Becoming.MapRegions', 'thm', ['Becoming.«际»']),  # a «» law of a leaf
    F: const(F, 'ind'), 'Becoming.Flow.Balances': const(F, 'def', [F]), 'Becoming.Flow.BalancesOn': const(F, 'def', [F]),
    'Becoming.balance_over_stretch_on': const(P, 'thm', ['Becoming.Small']),
    'Becoming.Dependence.level': const(F, 'def'), 'Becoming.Flow.taken': const(F, 'def'), 'Becoming.Flow.given': const(F, 'def'),
    'Becoming.Flow.fact': const(F, 'thm', [F]), 'Becoming.Flow.support': const(F, 'thm', [F]),
    'Becoming.Flow.bridge_iff': const(F, 'thm', [F, 'Becoming.«所闭»'], [LAW2]),
    'Becoming.Flow.holder': const(F, 'def', [], ['Becoming.Flow.support']),  # a definition holding a theorem
    'Becoming.Flow.row': const(F, 'thm', [F, 'Becoming.«所闭»'], [LAW, 'Becoming.Flow.bridge_iff', 'Becoming.Flow.holder', 'Becoming.helper']),
    'Becoming.Flow.steps': const(F, 'thm', [F], [LAW, 'Becoming.Flow.fact']),
    'Becoming.Flow.balanced': const(F, 'thm', ['Becoming.Flow.Balances'], [LAW]),
    'Becoming.Flow.written': const(F, 'thm', ['Becoming.Dependence.level', 'Becoming.Flow.taken', 'Becoming.Flow.given']),
    'Becoming.Flow.proof_balance': const(F, 'thm', [F], [LAW, 'Becoming.balance_over_stretch_on']),
    'Becoming.Flow.via_helper': const(F, 'thm', [F], ['Becoming.kept_onward']),
    'Becoming.Flow.forwarder': const(F, 'thm', ['Becoming.«所闭»'], [LAW], f=LAW, fk='pure'),
    'Becoming.Flow.projection': const(F, 'thm', ['Becoming.«际»'], [LAW2], f=LAW2, fk='projection'),
    'Becoming.Flow.counted': const(F, 'thm', [F]), 'Becoming.Flow.modelled': const(F, 'thm', [F]),
    'Becoming.Flow.own': const(F, 'thm', [F]), 'Becoming.Flow.two': const(F, 'thm', [F]),
    'Becoming.Leaf.form': const('Becoming.Leaf', 'thm', ['Becoming.«际»']), 'Becoming.Leaf.part': const('Becoming.Leaf', 'thm', [F]),
    'Becoming.Unrestricted': const('Becoming.Significance', 'def'), 'Becoming.Comparison': const('Becoming.Extension', 'def'),
    'Becoming.ReadsOnlyDynamics.not_entails': const('Becoming.Significance', 'thm', ['Becoming.Unrestricted']),
}
for n in ('Becoming.Leaf.H', 'Becoming.Leaf.form.needs_H', 'Becoming.Leaf.form.H_needed', 'Becoming.Leaf.recovery',
          'Becoming.Leaf.certified', 'Becoming.Leaf.bridge'):
    CONSTANTS[n] = const('Becoming.Leaf', 'def' if n.endswith('.H') else 'thm')
ANCHORS = ['Becoming.Flow.Balances', 'Becoming.Flow.BalancesOn', 'Becoming.balance_over_stretch_on', 'Becoming.«守数当且仅当可对»']


class TheTerms(unittest.TestCase):
    """§3.0 on constants made for the case."""
    @classmethod
    def setUpClass(cls):
        cls.T = boundary.Terms(CONSTANTS, ANCHORS)

    def test_grammar_laws(self):
        self.assertEqual(self.T.laws, {LAW, LAW2, 'Becoming.Law.constant_iff_core'})
        for n in ('Becoming.kept_onward', 'Becoming.helper', 'Becoming.«两火»', 'Becoming.«非真则假»', 'Becoming.«所闭之界»._proof_1',
                  'Becoming.TwoCourses.core_iff', 'Becoming.MapRegions.«图»'):
            self.assertNotIn(n, self.T.laws, n)

    def test_root_constants_by_content(self):
        self.assertIn('Becoming.kept_onward', self.T.root)
        self.assertNotIn('Becoming.GrammarCourse.lockedAlike', self.T.root)  # a grammar-module constant built on a model
        self.assertNotIn('Becoming.TwoCourses.core_iff', self.T.root)  # a root statement proved off the root
        self.assertEqual(self.T.anchors, {'Becoming.Flow.Balances', 'Becoming.Flow.BalancesOn', 'Becoming.balance_over_stretch_on'})

    def test_forwarders(self):
        self.assertEqual(self.T.forwarders, {'Becoming.Flow.forwarder': LAW, 'Becoming.Flow.projection': LAW2})
        self.assertEqual((self.T.kind['Becoming.Flow.forwarder'], self.T.kind['Becoming.Flow.projection']), ('pure', 'projection'))

    def test_the_walks(self):
        self.assertEqual(self.T.walk('Becoming.Flow.row'), {LAW, 'Becoming.Flow.bridge_iff', 'Becoming.Flow.support', 'Becoming.helper'})
        self.assertEqual(self.T.reach('Becoming.Flow.row'), {LAW, LAW2})
        self.assertEqual(self.T.reach('Becoming.Flow.via_helper'), {LAW})  # through a root helper without a «» name

    def test_where_balance_enters(self):
        self.assertEqual(self.T.balance('Becoming.Flow.balanced')['anchor_in_statement'], ['Becoming.Flow.Balances'])
        self.assertTrue(self.T.balance('Becoming.Flow.written')['written_out'])
        self.assertEqual(self.T.balance('Becoming.Flow.proof_balance'),
                         {'anchor_in_statement': [], 'written_out': False, 'proof_only': ['Becoming.balance_over_stretch_on']})


class TheDerivedChecks(unittest.TestCase):
    """D1 to D5 on the dump (§3.1)."""
    @classmethod
    def setUpClass(cls):
        cls.T = boundary.Terms(CONSTANTS, ANCHORS)

    def check(self, row, central=(), **e):
        return boundary.derived(self.T, row, e, set(central))

    def test_a_case_through_a_bridge_and_support(self):
        failed, report = self.check('Becoming.Flow.row', law=[LAW], bridges=['Becoming.Flow.bridge_iff'], support=['Becoming.Flow.support'])
        self.assertEqual(failed, [])
        self.assertEqual(report, {'laws_used_also': [LAW2], 'root_theorems_named': ['Becoming.helper'], 'forwarder': None})
        failed, report = self.check('Becoming.Flow.row', law=[LAW, LAW2], bridges=['Becoming.Flow.bridge_iff'], support=['Becoming.Flow.support'])
        self.assertEqual((failed, report['laws_used_also']), ([], []))  # two laws: the row joins two cases

    def test_each_failure(self):
        self.assertIn('D1: Becoming.kept_onward is not a grammar law', self.check('Becoming.Flow.via_helper', law=['Becoming.kept_onward'])[0])
        failed = self.check('Becoming.Flow.steps', law=[LAW])[0]
        self.assertEqual(failed, ['D2: the proofs name theorems that are neither grammar laws, root theorems nor declared lemmas: Becoming.Flow.fact'])
        failed = self.check('Becoming.Flow.row', central=['Becoming.Flow.support'], law=[LAW], bridges=['Becoming.Flow.bridge_iff'],
                            support=['Becoming.Flow.support'])[0]
        self.assertEqual(failed, ['D2: the lemma Becoming.Flow.support is a central declaration'])
        self.assertIn(f'D3: the walk does not reach {LAW2}', self.check('Becoming.Flow.via_helper', law=[LAW, LAW2])[0])
        failed = self.check('Becoming.Flow.row', law=[LAW], bridges=['Becoming.Flow.bridge_iff'], support=['Becoming.Flow.support', 'Becoming.Flow.fact'])[0]
        self.assertEqual(failed, ['D4: the lemma Becoming.Flow.fact is not reached'])
        failed = self.check('Becoming.Flow.forwarder', law=[LAW], support=['Becoming.Flow.projection'])[0]
        self.assertIn('it is a grammar law or a forwarder of one', failed[0])

    def test_balance_in_the_closure_fails_d5(self):
        # act_courses_unselected's shape: balance in the statement, or only in the proof
        self.assertEqual(self.check('Becoming.Flow.balanced', law=[LAW])[0], ['D5: balance enters its closure: Becoming.Flow.Balances'])
        self.assertEqual(self.check('Becoming.Flow.proof_balance', law=[LAW])[0],
                         ['D5: balance enters its closure: Becoming.balance_over_stretch_on'])

    def test_a_forwarder_row(self):
        failed, report = self.check('Becoming.Flow.forwarder', law=[LAW])
        self.assertEqual((failed, report['forwarder']), ([], {'law': LAW, 'kind': 'pure'}))
        failed, report = self.check('Becoming.Flow.projection', law=[LAW2])
        self.assertEqual((failed, report['forwarder']), ([], {'law': LAW2, 'kind': 'projection'}))  # one direction, reported so


class TheRule(unittest.TestCase):
    """§3.5 and the facts readings need (§3.4)."""
    NONE = {'anchor_in_statement': [], 'written_out': False, 'proof_only': []}

    def test_every_branch(self):
        occurrence, own = [{'models': ['occurrence', 'own']}], [{'models': ['own']}]
        self.assertEqual(boundary.rule('grammar', {**self.NONE, 'anchor_in_statement': ['Becoming.Flow.Balances']}, []), 'balance in its statement')
        self.assertEqual(boundary.rule('no master law', {**self.NONE, 'written_out': True}, occurrence), 'balance in its statement')
        self.assertEqual(boundary.rule('grammar', {**self.NONE, 'proof_only': ['Becoming.Flow.Balances']}, occurrence), 'connected')
        self.assertEqual(boundary.rule('anchor, not reached', self.NONE, occurrence), 'at a represented model')
        self.assertEqual(boundary.rule('no master law', self.NONE, [{'models': ['process']}]), 'at a represented model')
        self.assertEqual(boundary.rule('no master law', self.NONE, own), 'own carrier')
        self.assertEqual(boundary.rule('balance, represented', self.NONE, []), 'unplaced')

    def test_the_facts(self):
        self.assertFalse(boundary.has_fact('connected', set(), self.NONE, []))
        self.assertTrue(boundary.has_fact('connected', {LAW}, self.NONE, []))
        self.assertTrue(boundary.has_fact('balance in its statement', set(), {**self.NONE, 'written_out': True}, []))
        self.assertFalse(boundary.has_fact('own carrier', set(), self.NONE, [{'models': ['own', 'process']}]))
        self.assertTrue(boundary.has_fact('at a represented model', set(), self.NONE, [{'models': ['own', 'process']}]))


CENTRAL = {n: {'category': 'master law', 'dependence': d} for n, d in (
    ('Becoming.Flow.row', 'grammar'), ('Becoming.Flow.steps', 'grammar'), ('Becoming.Flow.balanced', 'grammar'),
    ('Becoming.Flow.written', 'no master law'), ('Becoming.Flow.proof_balance', 'grammar'), ('Becoming.Flow.via_helper', 'grammar'),
    ('Becoming.Flow.forwarder', 'grammar'), ('Becoming.Flow.counted', 'no master law'), ('Becoming.Flow.modelled', 'anchor, not reached'),
    ('Becoming.Flow.own', 'no master law'), ('Becoming.Flow.two', 'no master law'), ('Becoming.Flow.absent', 'no master law'))}
AT_MODEL = {'Becoming.Flow.modelled': [{'of': 'Becoming.Flow.modelled', 'record': 'm', 'law': 2, 'declaration': 'Becoming.M.reading',
                                        'models': ['occurrence'], 'review': REVIEW}],
            'Becoming.Flow.own': [{'of': 'Becoming.Flow.own', 'record': 'm', 'law': 3, 'declaration': 'Becoming.M.own',
                                   'models': ['own'], 'review': REVIEW}]}
F5 = {n: ('reaching the grammar' if x['dependence'] == 'grammar' else 'stated at a represented model' if n == 'Becoming.Flow.modelled'
          else 'stated on its own carrier only' if n == 'Becoming.Flow.own' else 'the rest') for n, x in CENTRAL.items()}


def lean_passing(query, modules):
    return ({'entries': [{'row': e['row'], 'form': e['form'], 'passed': True, 'failures': [], 'statement_names': ['Becoming.«际»'],
                          'recovery_uses': [e['form']]} for e in query['entries']],
             'admitted': {n: True for n in query['names']}, 'equivalence': {n: True for n in query['equivalences']}},
            {'ran': True, 'toolchain': 'T', 'modules_sha256': 'K', 'check_sha256': 'S'})


class TheReport(unittest.TestCase):
    """The generator's report (§3.4, §3.6, §4), with the Lean check stubbed."""
    def report(self, *standings, premises=None, lean=lean_passing, **more):
        r = carrier(*standings, premises=premises, **more)
        return boundary.report(CONSTANTS, CENTRAL, AT_MODEL, F5, r, ANCHORS, lean=lean)

    def test_precedence(self):
        rep = self.report(standing('Becoming.Flow.row', 'derived', law=[LAW], bridges=['Becoming.Flow.bridge_iff'], support=['Becoming.Flow.support']),
                          standing('Becoming.Flow.counted', 'counting'),
                          standing('Becoming.Flow.steps', 'derived', law=[LAW]),
                          standing('Becoming.Flow.modelled', 'amounts'))
        rows = rep['rows']
        self.assertEqual((rows['Becoming.Flow.row']['label'], rows['Becoming.Flow.row']['placed']), ('derived', 'checked entry'))
        self.assertEqual((rows['Becoming.Flow.counted']['label'], rows['Becoming.Flow.counted']['placed']), ('counting', 'reading'))
        self.assertEqual(rows['Becoming.Flow.modelled']['label'], 'amounts')  # a reading over the rule
        self.assertEqual(rows['Becoming.Flow.modelled']['rule'], 'at a represented model')
        # a failing entry falls to the rule, never to a reading
        self.assertEqual((rows['Becoming.Flow.steps']['label'], rows['Becoming.Flow.steps']['placed']), ('connected', 'the rule'))
        self.assertEqual([x['declaration'] for x in rep['unverified']], ['Becoming.Flow.steps'])
        self.assertEqual(rows['Becoming.Flow.balanced']['label'], 'balance in its statement')
        self.assertEqual(rows['Becoming.Flow.absent']['label'], 'unplaced')

    def test_a_reading_of_a_computed_label_needs_the_rules_fact(self):
        rep = self.report(standing('Becoming.Flow.counted', 'connected'), standing('Becoming.Flow.own', 'at a represented model'),
                          standing('Becoming.Flow.via_helper', 'connected'), standing('Becoming.Flow.modelled', 'own carrier'),
                          standing('Becoming.Flow.written', 'balance in its statement'))
        self.assertEqual(sorted(x['declaration'] for x in rep['unverified']),
                         ['Becoming.Flow.counted', 'Becoming.Flow.modelled', 'Becoming.Flow.own'])
        self.assertEqual(rep['rows']['Becoming.Flow.counted']['label'], 'unplaced')
        self.assertEqual(rep['rows']['Becoming.Flow.via_helper']['placed'], 'reading')
        self.assertEqual(rep['rows']['Becoming.Flow.written']['placed'], 'reading')

    def test_the_lean_check(self):
        def failing(query, modules):
            out, info = lean_passing(query, modules)
            out['entries'][0].update(passed=False, failures=['the discharge condition fails: the recovery uses [Becoming.Flow.fact]'])
            out['equivalence']['Becoming.Flow.bridge_iff'] = False
            out['admitted'][LAW] = False
            return out, info
        seen = []
        def recording(query, modules):
            seen.append((query, modules))
            return lean_passing(query, modules)
        entries = (at_hypothesis(), standing('Becoming.Flow.row', 'derived', law=[LAW], bridges=['Becoming.Flow.bridge_iff'],
                                             support=['Becoming.Flow.support']))
        rep = self.report(*entries, lean=recording)
        self.assertEqual(rep['rows']['Becoming.Flow.two']['label'], 'under a stated hypothesis')
        self.assertEqual(rep['rows']['Becoming.Flow.two']['entry']['report']['recovery_uses'], ['Becoming.Leaf.form'])
        self.assertEqual(seen[0][1], ['Becoming.Leaf'])
        self.assertEqual((seen[0][0]['names'], seen[0][0]['equivalences']), ([LAW], ['Becoming.Flow.bridge_iff']))
        rep = self.report(*entries, lean=failing)
        failed = {x['declaration']: x['failed'] for x in rep['unverified']}
        self.assertEqual(failed['Becoming.Flow.two'], ['the discharge condition fails: the recovery uses [Becoming.Flow.fact]'])
        self.assertEqual(failed['Becoming.Flow.row'], [f'D1: the Lean check does not admit {LAW}',
                                                       'D6: the bridge Becoming.Flow.bridge_iff is not an equivalence'])
        self.assertEqual(rep['rows']['Becoming.Flow.two']['label'], 'unplaced')
        rep = self.report(*entries, lean=lambda q, m: (None, {'ran': False, 'reason': 'not in the cache'}))
        self.assertEqual(len(rep['unverified']), 2)
        self.assertTrue(all(x['failed'] == ['the Lean check did not run: not in the cache'] for x in rep['unverified']))
        self.assertEqual(rep['lean_check'], {'ran': False, 'reason': 'not in the cache'})
        rep = self.report(standing('Becoming.Flow.counted', 'counting'), lean=None)  # nothing to check: Lean is not run
        self.assertEqual(rep['lean_check'], {'ran': False, 'reason': 'nothing to check'})

    def test_robustness(self):
        rep = self.report(standing('Becoming.Flow.fact', 'counting'), standing('Becoming.Flow.absent', 'counting'),
                          standing('Becoming.Flow.counted', 'derived', law=['Becoming.Nowhere']))
        failed = {x['declaration']: x['failed'] for x in rep['unverified']}
        self.assertEqual(failed['Becoming.Flow.fact'], ['not a central declaration of COVERAGE.json'])
        self.assertEqual(failed['Becoming.Flow.absent'], ['not in the spine run: Becoming.Flow.absent'])
        self.assertEqual(failed['Becoming.Flow.counted'], ['not in the spine run: Becoming.Nowhere'])
        for field in ({'standings': [1, {'standing': 'counting'}, {'declaration': 'Becoming.Flow.counted', 'standing': 'x'}],
                       'premises_of_the_ethics': [None, {'role': 'scope'}]},
                      {'standings': 'none', 'premises_of_the_ethics': {}}, [], None):
            r = carrier(standing('Becoming.Flow.counted', 'counting'))
            r['boundary'] = field
            rep = boundary.report(CONSTANTS, CENTRAL, AT_MODEL, F5, r, ANCHORS, lean=lean_passing)
            self.assertTrue(rep['field_failures'] or rep['unverified'], field)
            self.assertEqual(sum(rep['counts'].values()), len(CENTRAL))
        rep = self.report(standing('Becoming.Flow.counted', 'counting', note=1))
        self.assertEqual(rep['unverified'][0]['failed'], ["its record breaks the check's rules: keys outside the standing counting: note"])
        rep = self.report(standing('Becoming.Flow.counted', 'counting'), status='withdrawn')
        self.assertEqual(rep['rows']['Becoming.Flow.counted']['placed'], 'the rule')

    def test_counts_groups_and_f5(self):
        rep = self.report(standing('Becoming.Flow.row', 'derived', law=[LAW], bridges=['Becoming.Flow.bridge_iff'], support=['Becoming.Flow.support']),
                          standing('Becoming.Flow.forwarder', 'derived', law=[LAW]), standing('Becoming.Flow.counted', 'counting'),
                          at_hypothesis())
        self.assertEqual(sum(rep['counts'].values()), len(CENTRAL))
        self.assertEqual(sum(rep['groups'].values()), len(CENTRAL))
        self.assertEqual(rep['groups']['on the edge'], 3)
        self.assertEqual(rep['groups']['below the grammar'], 1)
        self.assertEqual(sum(n for v in rep['against_f5'].values() for n in v.values()), len(CENTRAL))
        self.assertEqual(rep['against_f5']['derived'], {'reaching the grammar': 2, 'stated at a represented model': 0,
                                                        'stated on its own carrier only': 0, 'the rest': 0})
        self.assertEqual(rep['derived_by_forwarder'], [{'declaration': 'Becoming.Flow.forwarder', 'law': LAW, 'kind': 'pure'}])
        self.assertEqual(rep['rows']['Becoming.Flow.proof_balance']['balance']['proof_only'], ['Becoming.balance_over_stretch_on'])
        self.assertEqual(rep['rows']['Becoming.Flow.proof_balance']['label'], 'connected')  # balance in the proof places nothing

    def test_the_premises(self):
        rep = self.report(standing('Becoming.Flow.counted', 'counting'))
        self.assertEqual([(p['role'], p['result']) for p in rep['premises_of_the_ethics']], [('scope', 'not entailed'), ('order', 'not shown')])
        rep = self.report(standing('Becoming.Flow.counted', 'counting'),
                          premises=[{**SCOPE, 'not_entailed': 'Becoming.Flow.fact'}, {**ORDER, 'premise': 'Becoming.Flow.fact'}])
        self.assertEqual([(p['result'], p['failed']) for p in rep['premises_of_the_ethics']],
                         [('unverified', ['the type of Becoming.Flow.fact does not name Becoming.Unrestricted']),
                          ('unverified', ['Becoming.Flow.fact is not a definition of the run'])])

    def test_the_counts_of_the_boundary_record(self):
        self.assertEqual(master_laws.counted_in('edge', 1, ['edge'], {('edge', 1)}), 'counts_at_boundary_record')
        self.assertEqual(master_laws.counted_in('m', 2, ['edge'], {('m', 2)}), 'counts_at_model')
        self.assertEqual(master_laws.counted_in('m', 1, ['edge'], {('m', 2)}), 'counts')
        self.assertEqual(master_laws.counted_in('m', 1, [], set()), 'counts')


class ThePages(unittest.TestCase):
    """The standing lines and the boundary record's section (§5), and what re-renders (§3.6)."""
    def setUp(self):
        self.declared = carrier(standing('Becoming.Flow.row', 'derived', law=[LAW], bridges=['Becoming.Flow.bridge_iff'],
                                         support=['Becoming.Flow.support']),
                                at_hypothesis(), standing('Becoming.Flow.counted', 'counting'),
                                standing('Becoming.Flow.balanced', 'balance in its statement', relational_part='Becoming.Leaf.part'),
                                standing('Becoming.Flow.steps', 'derived', law=[LAW]))
        self.data = {'boundary': boundary.report(CONSTANTS, CENTRAL, AT_MODEL, F5, self.declared, ANCHORS, lean=lean_passing)}

    def records(self, *laws, matched_at_model=('m:2', 'm:3'), now=None):
        pages = [{'id': f'p{k}', 'laws': [{'en': 'A law.', 'declarations': list(names)}]} for k, names in enumerate(laws)]
        records = pages + [now or copy.deepcopy(self.declared)]
        registry.attach_standings(records, self.data, set(matched_at_model))
        return records

    def line(self, d):
        rows = self.records([d])[0]['_standings']['rows']
        return registry.standing_line(d, rows[d], 'edge', lambda i: f'[{i}]({i}.md)', registry.ROOT / 'theories/becoming/results/records')

    def test_each_standings_sentence(self):
        self.assertEqual(self.line('Becoming.Flow.row'),
                         f'*Standing of `Becoming.Flow.row`:* derived, a case of `{LAW}` through `Becoming.Flow.bridge_iff`, with the '
                         f'support `Becoming.Flow.support`, using also `{LAW2}` (declared in [edge](edge.md); the closed set checked against '
                         'the Lean, the bridges checked as equivalences; the case read in [review.md](../../../../_process/review.md)). '
                         'Root theorems its proofs name: `Becoming.helper` (Init not shown).')
        self.assertEqual(self.line('Becoming.Flow.two'),
                         '*Standing of `Becoming.Flow.two`:* under a stated hypothesis, the root form `Becoming.Leaf.form` at its model, '
                         'with hypothesis `Becoming.Leaf.H`, with its countermodel and fit (declared in [edge](edge.md); checked in Lean: the '
                         'form, its countermodels, the certificate and the discharge condition; the hypotheses read as the row\'s relational '
                         'content in [review.md](../../../../_process/review.md)).')
        self.assertEqual(self.line('Becoming.Flow.counted'),
                         '*Standing of `Becoming.Flow.counted`:* counting, a reading: Why it stands so ([review.md](../../../../_process/review.md)).')
        self.assertEqual(self.line('Becoming.Flow.balanced'),
                         '*Standing of `Becoming.Flow.balanced`:* balance in its statement, a reading: Why it stands so '
                         '([review.md](../../../../_process/review.md)); the rule gives the same; its relational part: `Becoming.Leaf.part`.')
        self.assertEqual(self.line('Becoming.Flow.via_helper'),
                         f'*Standing of `Becoming.Flow.via_helper`, by the rule:* connected (it reaches `{LAW}` among its reasons; not '
                         'declared a case of one).')
        self.assertEqual(self.line('Becoming.Flow.written'),
                         '*Standing of `Becoming.Flow.written`, by the rule:* balance in its statement (balance written out in its statement).')
        self.assertEqual(self.line('Becoming.Flow.modelled'),
                         "*Standing of `Becoming.Flow.modelled`, by the rule:* at a represented model (F5's verified items at the occurrence model).")
        self.assertEqual(self.line('Becoming.Flow.own'),
                         "*Standing of `Becoming.Flow.own`, by the rule:* own carrier (F5's verified items on its own carrier only).")
        self.assertEqual(self.line('Becoming.Flow.absent'),
                         "*Standing of `Becoming.Flow.absent`, by the rule:* unplaced (no standing declared, and none of the rule's tests holds).")
        self.assertTrue(self.line('Becoming.Flow.steps').endswith(
            '; the declared standing, derived, is unverified: D2: the proofs name theorems that are neither grammar laws, root theorems '
            'nor declared lemmas: Becoming.Flow.fact).'))

    def test_one_line_per_central_declaration_and_record(self):
        records = self.records(['Becoming.Flow.row', 'Becoming.Flow.fact', 'Becoming.Flow.counted', 'Becoming.Flow.row'], ['Becoming.Flow.row'])
        self.assertEqual(list(records[0]['_standings']['rows']), ['Becoming.Flow.counted', 'Becoming.Flow.row'])
        self.assertEqual(list(records[1]['_standings']['rows']), ['Becoming.Flow.row'])
        r = json.loads(json.dumps({**next(x for x in registry.load_records()[0] if x.get('schema_version') == 2 and x.get('laws')),
                                   'laws': records[0]['laws'], '_standings': records[0]['_standings']}, ensure_ascii=False))
        r.pop('_master_laws', None)
        page = registry.render_record_v2(r)
        self.assertEqual(page.count('   - *Standing of `Becoming.Flow.row`:*'), 1)  # a child of law 1, once though named twice
        self.assertEqual(page.count('   - *Standing of `Becoming.Flow.counted`:*'), 1)

    def test_lines_hidden_when_not_matched(self):
        now = copy.deepcopy(self.declared)
        now['boundary']['standings'][2]['basis'] = {'en': 'Another reason.'}
        rows = self.records(['Becoming.Flow.counted', 'Becoming.Flow.row'], now=now)[0]['_standings']['rows']
        self.assertEqual(list(rows), ['Becoming.Flow.row'])  # the changed entry's line is hidden, the others stay
        self.assertNotIn('_standings', self.records(['Becoming.Flow.modelled'], matched_at_model=())[0])  # the F5 law it cites changed
        self.assertIn('_standings', self.records(['Becoming.Flow.modelled'])[0])
        moved = {**copy.deepcopy(self.declared), 'id': 'elsewhere'}
        self.assertNotIn('_standings', self.records(['Becoming.Flow.row'], now=moved)[0])  # the data read another record

    def test_nothing_without_the_field(self):
        records = [{'id': 'p', 'laws': [{'declarations': ['Becoming.Flow.row']}]}]
        registry.attach_standings(records, {}, set())
        registry.attach_standings(records, {'boundary': {'error': 'two', 'records': ['a', 'b']}}, set())
        self.assertEqual(records, [{'id': 'p', 'laws': [{'declarations': ['Becoming.Flow.row']}]}])
        self.assertEqual(registry.boundary_section({'id': 'p'}, registry.ROOT), [])

    def test_the_boundary_records_section(self):
        edge = self.records()[-1]
        section = registry.boundary_section(edge, registry.ROOT / 'theories/becoming/results/records')
        text = '\n'.join(x if isinstance(x, str) else x[1] for x in section)
        self.assertIn(f'**Counts** of the {len(CENTRAL)} central declarations: on the edge 2 (derived 1, under a stated hypothesis 1); '
                      'below the grammar 1; distances', text)
        self.assertIn('- **For scope**, the continuation condition: `Becoming.Unrestricted`; not entailed by any statement reading only '
                      'the dynamics, by `Becoming.ReadsOnlyDynamics.not_entails`', text)
        self.assertIn('- **For order**, C: `Becoming.Comparison`; no theorem shows it unentailed by the dynamics: No theorem shows it.', text)
        self.assertIn(f'- `Becoming.Flow.row`: derived (a checked entry): a case of `{LAW}`; bridges `Becoming.Flow.bridge_iff`; support '
                      '`Becoming.Flow.support`.', text)
        self.assertIn('- `Becoming.Flow.two`: under a stated hypothesis (a checked entry): the form `Becoming.Leaf.form`; `Becoming.Leaf.H` '
                      '(countermodel `Becoming.Leaf.form.needs_H`, fit `Becoming.Leaf.form.H_needed`); recovery `Becoming.Leaf.recovery`; '
                      'certificate `Becoming.Leaf.certified`.', text)
        self.assertIn('- `Becoming.Flow.steps`: connected (by the rule; the declared standing, derived, is unverified).', text)
        self.assertIn('- `Becoming.Flow.balanced`: balance in its statement (a reading; the rule gives the same).', text)
        for group in ('On the edge', 'Below the grammar', 'Distances', 'Unplaced'):
            self.assertIn(group, text)
        now = copy.deepcopy(self.declared)
        now['boundary']['premises_of_the_ethics'][1]['absent'] = {'en': 'Changed.'}
        edge = self.records(now=now)[-1]
        self.assertIn('*Not matched:* the data read another version of this field (premises_of_the_ethics)',
                      '\n'.join(x for x in registry.boundary_section(edge, registry.ROOT) if isinstance(x, str)))

    def test_what_re_renders_after_a_change_to_the_boundary_record(self):
        records = [{'id': 'edge', '_record_path': 'theories/becoming/results/records/edge.json', 'boundary': {}, 'references': [],
                    'dependencies': [], 'laws': []},
                   {'id': 'naming', '_record_path': 'theories/becoming/results/records/naming.json', 'references': [], 'dependencies': [],
                    'laws': [{'declarations': ['Becoming.Flow.row']}]},
                   {'id': 'other', '_record_path': 'theories/becoming/results/records/other.json', 'references': [], 'dependencies': [],
                    'laws': [{'declarations': ['Becoming.Flow.fact']}]}]
        with patch.object(registry, 'master_laws', return_value=self.data):
            self.assertEqual(registry.affected_ids(records, {'theories/becoming/results/records/edge.json'}), {'edge', 'naming'})
            self.assertEqual(registry.affected_ids(records, {'theories/becoming/results/records/other.json'}), {'other'})


class TheStatus(unittest.TestCase):
    """The status's four lists, current, and the error (§3.6)."""
    def status(self, data, records):
        with patch.object(registry, 'master_laws', return_value=data):
            return registry.master_laws_status(records)

    def base(self, boundary_data):
        return {'core_receipt': 'R', 'names': {}, 'inputs_sha256': {}, 'core_sources_sha256': '', 'records': {},
                **({'boundary': boundary_data} if boundary_data is not None else {})}

    def test_the_four_lists_and_current(self):
        declared = carrier(standing('Becoming.Flow.steps', 'derived', law=[LAW]), standing('Becoming.Flow.counted', 'counting'),
                           premises=[SCOPE, {**ORDER, 'premise': 'Becoming.Flow.fact'}])
        rep = boundary.report(CONSTANTS, CENTRAL, AT_MODEL, F5, declared, ANCHORS, lean=lean_passing)
        status = self.status(self.base(rep), [copy.deepcopy(declared)])
        self.assertEqual(status['boundary_unverified'], ['Becoming.Flow.steps (derived): D2: the proofs name theorems that are neither '
                                                         'grammar laws, root theorems nor declared lemmas: Becoming.Flow.fact'])
        self.assertEqual(status['boundary_premises_unverified'], ['order: Becoming.Flow.fact (Becoming.Flow.fact is not a definition of the run)'])
        self.assertEqual(status['boundary_unplaced'], ['Becoming.Flow.absent', 'Becoming.Flow.two'])
        self.assertEqual(status['boundary_not_matched'], [])
        now = copy.deepcopy(declared)
        now['boundary']['standings'].pop()
        status = self.status(self.base(rep), [now])
        self.assertEqual(status['boundary_not_matched'], ['Becoming.Flow.counted'])
        self.assertFalse(status['current'])
        self.assertEqual(self.status(self.base(rep), [])['boundary_not_matched'],
                         ['Becoming.Flow.counted', 'Becoming.Flow.steps', 'premises_of_the_ethics'])  # no record carries it now
        self.assertEqual(self.status(self.base(None), [declared])['boundary_not_matched'],
                         ['Becoming.Flow.counted', 'Becoming.Flow.steps', 'premises_of_the_ethics'])  # the data has not read it

    def test_premises_not_shown_are_not_unverified(self):
        declared = carrier(standing('Becoming.Flow.counted', 'counting'))
        rep = boundary.report(CONSTANTS, CENTRAL, AT_MODEL, F5, declared, ANCHORS, lean=lean_passing)
        status = self.status(self.base(rep), [declared])
        self.assertEqual((status['boundary_unverified'], status['boundary_premises_unverified']), ([], []))

    def test_without_the_field_and_with_two_records(self):
        status = self.status(self.base(None), [{'id': 'p'}])
        self.assertEqual([status[k] for k in ('boundary_unverified', 'boundary_premises_unverified', 'boundary_unplaced',
                                              'boundary_not_matched')], [[], [], [], []])
        self.assertNotIn('boundary_error', status)
        status = self.status(self.base({'error': 'the boundary field is carried by more than one record', 'records': ['a', 'b']}),
                             [carrier(ident='a'), carrier(ident='b')])
        self.assertEqual(status['boundary_error'], 'the boundary field is carried by more than one record: a, b')
        self.assertFalse(status['current'])
        self.assertEqual(status['boundary_not_matched'], [])

    def test_the_field_fails_as_a_whole(self):
        declared = carrier(standing('Becoming.Flow.counted', 'counting'))
        declared['boundary'] = {'standings': [], 'premises_of_the_ethics': []}
        rep = boundary.report(CONSTANTS, CENTRAL, AT_MODEL, F5, declared, ANCHORS, lean=lean_passing)
        self.assertEqual(self.status(self.base(rep), [declared])['boundary_unverified'][0],
                         "the field: its record breaks the check's rules: boundary standings must be a nonempty list")


# The Lean check on stub modules (§8): a prelude, a grammar, a model and a leaf, compiled in a temporary folder.
STUBS = {
    'Becoming/Prelude.lean': '''namespace Becoming
def Small (n : Nat) : Prop := n ≤ 1
end Becoming
''',
    'Becoming/Grammar.lean': '''import Becoming.Prelude
namespace Becoming
def «际» (X : Type) : Type := X → X → Prop
theorem «际之自» {X : Type} (r : «际» X) : r = r := rfl
end Becoming
''',
    'Becoming/Model.lean': '''import Becoming.Grammar
namespace Becoming
def Model.next (n : Nat) : Nat := n + 1
def Model.rel : «际» Nat := fun a b => b = Model.next a
theorem Model.rel_total : ¬ ∃ x, ∀ y, ¬ Model.rel x y := fun ⟨x, h⟩ => h (Model.next x) rfl
theorem Model.rel_onward : ∀ x, ∃ y, Model.rel x y := fun x => ⟨Model.next x, rfl⟩
theorem Model.and_swap {a b : Prop} : a ∧ b ↔ b ∧ a := ⟨fun ⟨x, y⟩ => ⟨y, x⟩, fun ⟨x, y⟩ => ⟨y, x⟩⟩
theorem Model.size_zero : ([] : List Nat).length = 0 := rfl
end Becoming
''',
    'Becoming/Leaf.lean': '''import Becoming.Model
namespace Becoming.Leaf
def Total {X : Type} (r : «际» X) : Prop := ∀ x, ∃ y, r x y
def SmallAll {X : Type} (r : «际» X) (q : X → Nat) : Prop := ∀ x, Small (q x) ∧ ∃ y, r x y
def noneRel : «际» Unit := fun _ _ => False
theorem none_unrelated : ∃ x, ∀ y, ¬ noneRel x y := ⟨(), fun _ f => f⟩
theorem total_form {X : Type} {r : «际» X} (total : Total r) : ¬ ∃ x, ∀ y, ¬ r x y :=
  fun ⟨x, h⟩ => match total x with | ⟨y, hy⟩ => h y hy
theorem total_form.needs_total : ¬ ∀ {X : Type} {r : «际» X}, ¬ ∃ x, ∀ y, ¬ r x y :=
  fun h => @h Unit noneRel none_unrelated
theorem total_form.total_needed : ¬ Total noneRel := fun total => total_form total none_unrelated
theorem rel_total_at_model : ¬ ∃ x, ∀ y, ¬ Model.rel x y := total_form (fun x => ⟨Model.next x, rfl⟩)
theorem rel_total_certified : @Model.rel_total = @rel_total_at_model := rfl
theorem rel_total_through_fact : ¬ ∃ x, ∀ y, ¬ Model.rel x y := total_form Model.rel_onward
theorem rel_total_through_fact_certified : @Model.rel_total = @rel_total_through_fact := rfl
theorem small_form {X : Type} {r : «际» X} {q : X → Nat} (small : SmallAll r q) : ¬ ∃ x, ∀ y, ¬ r x y :=
  fun ⟨x, h⟩ => match (small x).2 with | ⟨y, hy⟩ => h y hy
end Becoming.Leaf
''',
}
SPINE = registry.ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
LEAN = Path.home() / '.elan/bin/lean'


class TheLeanCheck(unittest.TestCase):
    """boundary_check.lean on stub modules: a form passing every test, a recovery through a model fact, a hypothesis
    with an amount behind a prelude definition, the name test and the equivalence test. Skipped without the toolchain."""
    @classmethod
    def setUpClass(cls):
        toolchain = (SPINE / 'lean-toolchain').read_text().strip() if (SPINE / 'lean-toolchain').is_file() else ''
        cls.lean = [str(LEAN), '+' + toolchain]
        if not LEAN.is_file() or not toolchain or subprocess.run(cls.lean + ['--version'], capture_output=True).returncode != 0:
            raise unittest.SkipTest('the Lean toolchain is absent')
        cls.dir = tempfile.mkdtemp(prefix='boundary-stubs-')
        work = Path(cls.dir)
        for path, text in STUBS.items():
            (work / path).parent.mkdir(parents=True, exist_ok=True)
            (work / path).write_text(text)
            p = subprocess.run(cls.lean + [f'--root={work}', '-o', str(work / path.replace('.lean', '.olean')), path], cwd=work,
                               env={**os.environ, 'LEAN_PATH': str(work)}, capture_output=True, text=True)
            if p.returncode != 0:
                raise AssertionError(p.stdout + p.stderr)
        L = 'Becoming.Leaf.'
        def entry(form, hyp, recovery, certificate):
            return {'row': 'Becoming.Model.rel_total', 'form': L + form, 'recovery': L + recovery, 'certificate': L + certificate,
                    'hypotheses': [{'hypothesis': L + hyp, 'countermodel': L + 'total_form.needs_total', 'fit': L + 'total_form.total_needed'}]}
        cls.out = boundary.run_check(work, ['Becoming.Leaf'], {
            'entries': [entry('total_form', 'Total', 'rel_total_at_model', 'rel_total_certified'),
                        entry('total_form', 'Total', 'rel_total_through_fact', 'rel_total_through_fact_certified'),
                        entry('small_form', 'SmallAll', 'rel_total_at_model', 'rel_total_certified'),
                        entry('total_form', 'Total', 'rel_total_at_model', 'absent_certificate')],
            'names': ['Becoming.«际之自»', 'Becoming.Model.rel_total', 'Becoming.Small', 'Becoming.Absent'],
            'equivalences': ['Becoming.Model.and_swap', 'Becoming.Model.size_zero', 'Becoming.Model.rel_total']}, cls.lean, 600)

    @classmethod
    def tearDownClass(cls):
        shutil.rmtree(cls.dir, ignore_errors=True)

    def test_a_form_passing_every_test(self):
        self.assertEqual((self.out['entries'][0]['passed'], self.out['entries'][0]['failures']), (True, []))
        self.assertEqual(self.out['entries'][0]['recovery_uses'], ['Becoming.Leaf.total_form'])

    def test_the_failures(self):
        self.assertIn('the discharge condition fails: the recovery uses [Becoming.Model.rel_onward]', self.out['entries'][1]['failures'])
        self.assertIn('the hypothesis Becoming.Leaf.SmallAll names amounts: [Nat, LE.le]', self.out['entries'][2]['failures'])
        self.assertFalse(self.out['entries'][3]['passed'])

    def test_the_name_and_equivalence_tests(self):
        self.assertEqual(self.out['admitted'], {'Becoming.«际之自»': True, 'Becoming.Model.rel_total': False, 'Becoming.Small': True,
                                                'Becoming.Absent': False})
        self.assertEqual(self.out['equivalence'], {'Becoming.Model.and_swap': True, 'Becoming.Model.size_zero': False,
                                                   'Becoming.Model.rel_total': False})


class TheRepositoryFile(unittest.TestCase):
    def test_the_boundary_report_when_present(self):
        data = registry.master_laws()
        if not data or 'boundary' not in data:
            self.skipTest('no record carries the boundary field')
        b = data['boundary']
        if 'error' in b:
            return
        self.assertEqual(sum(b['counts'].values()), len(b['rows']))
        self.assertEqual(sum(b['groups'].values()), len(b['rows']))
        self.assertEqual(set(b['counts']), set(boundary.LABELS))
        self.assertEqual(set(data['counts_at_boundary_record']), set(data['counts']))


if __name__ == '__main__':
    unittest.main()
