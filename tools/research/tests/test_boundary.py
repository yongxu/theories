"""MV's boundary field (architecture/mv/BOUNDARY-FIELD.md): the check's rules, the generator's terms, checks, rule and
report on constants made for the case, the page lines and section, the status, and the Lean check on stub modules."""
import copy
import hashlib
import json
import os
import re
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from tools.research import boundary, shared_laws, registry

REVIEW = '_process/review.md'
SCOPE = {'role': 'scope', 'name': {'en': 'the continuation condition'}, 'premise': 'Becoming.Unrestricted',
         'not_entailed': 'Becoming.ReadsOnlyDynamics.not_entails', 'basis': {'en': 'Its scope.'}, 'review': REVIEW}
ORDER = {'role': 'order', 'name': {'en': 'C'}, 'premise': 'Becoming.Comparison', 'not_entailed': None,
         'absent': {'en': 'No theorem shows it.'}, 'basis': {'en': 'Its order.'}, 'review': REVIEW}
HYP = {'hypothesis': 'Becoming.Leaf.H', 'countermodel': 'Becoming.Leaf.form.needs_H', 'fit': 'Becoming.Leaf.form.H_needed'}
HYP2 = {'hypothesis': 'Becoming.Leaf.H2', 'countermodel': 'Becoming.Leaf.form.needs_H2', 'fit': 'Becoming.Leaf.form.H2_needed'}
LEAF = ['Becoming.Leaf.form', 'Becoming.Leaf.H', 'Becoming.Leaf.form.needs_H', 'Becoming.Leaf.form.H_needed',
        'Becoming.Leaf.recovery', 'Becoming.Leaf.certified', 'Becoming.Leaf.part', 'Becoming.Leaf.bridge', *HYP2.values()]


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


# Every name the field tests below give, written out, so that the review's test does not rest on given_names.
NAMED = ['Becoming.Flow.row', 'Becoming.«所闭之界»', 'Becoming.Flow.bridge_iff', 'Becoming.Flow.support', 'Becoming.Flow.two',
         'Becoming.Flow.three', 'Becoming.Leaf.form', 'Becoming.Leaf.H', 'Becoming.Leaf.form.needs_H', 'Becoming.Leaf.form.H_needed',
         'Becoming.Leaf.recovery', 'Becoming.Leaf.certified', 'Becoming.Leaf.bridge', 'Becoming.Flow.balanced', 'Becoming.Leaf.part',
         'Becoming.Flow.counted', 'Becoming.Unrestricted', 'Becoming.ReadsOnlyDynamics.not_entails', 'Becoming.Comparison']


def review(*names):
    return ' '.join(f'`{n}`' for n in names)


class FieldRules(unittest.TestCase):
    """The check's rules (§2), as registry.py applies them with the review's text."""
    def errors(self, r, text=None):
        with patch.object(registry, '_review_text', return_value=review(*NAMED) if text is None else text):
            return registry.boundary_errors(r)

    def assertRefused(self, r, text):
        found = self.errors(r)
        self.assertTrue(any(text in e for e in found), (text, found))

    def test_a_well_formed_field_passes(self):
        self.assertEqual(self.errors(carrier(*WELL_FORMED)), [])

    def test_one_hypothesis_definition_may_serve_two_entries(self):
        mine = ['Becoming.Leaf.form3', 'Becoming.Leaf.form3.needs_H', 'Becoming.Leaf.form3.H_needed', 'Becoming.Leaf.recovery3',
                'Becoming.Leaf.certified3']
        other = standing('Becoming.Flow.three', 'under a stated hypothesis', form=mine[0], recovery=mine[3], certificate=mine[4],
                         hypotheses=[{'hypothesis': 'Becoming.Leaf.H', 'countermodel': mine[1], 'fit': mine[2]}])
        self.assertEqual(self.errors(carrier(at_hypothesis(), other, own=LEAF + mine), text=review(*NAMED, *mine)), [])
        same = at_hypothesis('Becoming.Flow.three')  # the same form: its countermodel and fit are shared too
        self.assertEqual(self.errors(carrier(at_hypothesis(), same)), [])

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
        r = carrier(*WELL_FORMED, status=['withdrawn'])  # a record's own keys of another shape: refused, never a crash
        r['references'] = [{'role': 'review', 'path': [REVIEW]}, 3]
        self.assertRefused(r, 'is not a reference of role review')
        boundary.report(CONSTANTS, CENTRAL, AT_MODEL, F5, r, ANCHORS, lean=lean_passing)

    def test_each_standings_required_and_forbidden_keys(self):
        self.assertRefused(carrier(standing('Becoming.Flow.row', 'derived')), 'missing keys: law')
        for key in ('form', 'hypotheses', 'recovery', 'certificate'):
            s2 = at_hypothesis()
            del s2[key]
            self.assertRefused(carrier(s2), f'missing keys: {key}')
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
        for key in ('Becoming.«所闭之界»', 'Becoming.Flow.bridge_iff', 'Becoming.Flow.support', 'Becoming.Leaf.form.needs_H', 'Becoming.Leaf.form.H_needed', 'Becoming.Leaf.recovery',
                    'Becoming.Leaf.certified', 'Becoming.Leaf.bridge', 'Becoming.Leaf.part', 'Becoming.Leaf.H', 'Becoming.Leaf.form'):
            found = self.errors(carrier(*WELL_FORMED), text=review(*(n for n in NAMED if n != key)))
            self.assertEqual([e.rsplit(' ', 1)[-1] for e in found if 'does not name' in e], [key], key)
        unhashable = carrier(*WELL_FORMED, premises=[{**SCOPE, 'premise': {'en': 'x'}}, {**ORDER, 'not_entailed': ['x']}])
        self.assertTrue(any('premise must be a full Lean name' in e for e in self.errors(unhashable)))  # refused, not a crash
        self.assertTrue(any('its declaration must be a full Lean name' in e
                            for e in self.errors(carrier(standing(['Becoming.Flow.row'], 'counting')))))
        less_root = carrier(standing('Becoming.Flow.counted', 'counting'))
        self.assertEqual(self.errors(less_root, text='`Flow.counted` is counting; `Unrestricted`, `ReadsOnlyDynamics.not_entails`, '
                                                     '`Comparison`.'), [])
        self.assertTrue(self.errors(less_root, text='`counted` is counting; `Unrestricted`, `ReadsOnlyDynamics.not_entails`, `Comparison`.'))

    def test_introduced_names_are_the_records_own(self):
        for name in ('Becoming.Leaf.form', 'Becoming.Leaf.H', 'Becoming.Leaf.form.needs_H', 'Becoming.Leaf.form.H_needed',
                     'Becoming.Leaf.recovery', 'Becoming.Leaf.certified', 'Becoming.Leaf.bridge'):
            self.assertRefused(carrier(at_hypothesis(bridges=['Becoming.Leaf.bridge']), own=[x for x in LEAF if x != name]),
                               f"not among the declarations of the record's laws: {name}")
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
    'Becoming.«守数当且仅当可对»': const(G, 'thm', ['Becoming.«际»']),  # the grammar's balance form: a law, not an anchor
    'Becoming.«族»': const(G, 'ind'), 'Becoming.«族».brecOn': const(G, 'def', ['Becoming.«族»']),
    'Becoming.«族».brecOn.eq': const(G, 'thm', ['Becoming.«际»']),  # generated, under a generated brecOn
    'Becoming.Flow.Tree': const(F, 'ind'), 'Becoming.Flow.Tree.brecOn': const(F, 'def', ['Becoming.Flow.Tree']),
    'Becoming.Flow.Tree._proof_1': const(F, 'thm'),  # lifted out of a structure's default: under the inductive
    'Becoming.Flow.op': const(F, 'opaque'), 'Becoming.Flow.op._proof_1': const(F, 'thm'), 'Becoming.Flow.op._unsafe_rec': const(F, 'def'),
    'Becoming.Flow.op.eq_1': const(F, 'thm'),  # written by hand: Lean gives an opaque no equation lemma
    'Becoming.Flow.Chain.brecOn': const(F, 'thm'), 'Becoming.Flow.Chain.brecOn.go': const(F, 'thm'),  # a Prop inductive's: no go
    'Becoming.aux._@.Becoming.Flow._hyg.3': const(F, 'def'), 'Becoming.aux._proof_1._@.Becoming.Flow._hyg.3': const(F, 'thm'),
    'Becoming.halve._@.Becoming.Flow.42._hygCtx._hyg.3': const(F, 'def'),  # its equation lemmas come after the macro scopes
    'Becoming.Flow.Nest': const(F, 'ind'), 'Becoming.Flow.Nest.brecOn_1': const(F, 'def', ['Becoming.Flow.Nest']),  # a nested type's
    'Nat.fold.eq_def': const(F, 'thm'),  # an equation lemma of Init's definition, realized in a package module
    '_private.Becoming.Flow.0.PSigma.casesOn._arg_pusher': const(F, 'thm'),
    '_private.Becoming.Flow.0.Becoming.Flow.X.match_1._arg_pusher': const(F, 'thm'),
    'Becoming.Flow.unfolds': const(F, 'thm', [F], [LAW, 'Nat.fold.eq_def']),
    'Becoming.Flow.via_aux': const(F, 'thm', [F], ['Becoming.Flow.Tree.brecOn.go', 'Becoming.Flow.Tree.brecOn.eq']),
    'Becoming.Flow.Tree.brecOn.go': const(F, 'def', [], [LAW]), 'Becoming.Flow.Tree.brecOn.eq': const(F, 'thm', [], ['Becoming.Flow.fact']),
    'Becoming.Flow.row.inj': const(F, 'thm', [F], ['Becoming.Flow.fact']),  # written by hand: inj is generated for constructors
    'Becoming.Flow.via_named': const(F, 'thm', [F], [LAW, 'Becoming.Flow.row.inj']),
    'Becoming.Flow.Chain': const(F, 'ind'), 'Becoming.Flow.Chain.below': const(F, 'ind'),
    'Becoming.Flow.Chain.below.refl': const(F, 'ctor'), 'Becoming.Flow.X': const(F, 'def'), 'Becoming.Flow.X.match_1': const(F, 'def'),
    'Becoming.«容»': const(G, 'def', ['Becoming.«际»'], [LAW]),  # a «» name, where reaching stops
    'Becoming.Flow.through_term': const(F, 'thm', ['Becoming.«容»']),
    'Becoming.Flow.not_forwarder': const(F, 'thm', ['Becoming.«所闭»'], [LAW, 'Becoming.Flow.fact'], f=LAW, fk='pure'),
    'Becoming.Flow.forwarder2': const(F, 'thm', ['Becoming.«所闭»'], ['Becoming.Flow.forwarder'], f='Becoming.Flow.forwarder', fk='pure'),
    'Becoming.Flow.via_fw': const(F, 'thm', [F], ['Becoming.Flow.forwarder']),  # a proof naming a forwarder
    'Becoming.Flow.written_two': const(F, 'thm', ['Becoming.Dependence.level', 'Becoming.Flow.taken']),  # two of the three
    'Becoming.Unrestricted': const('Becoming.Significance', 'def'), 'Becoming.Comparison': const('Becoming.Extension', 'def'),
    'Becoming.ReadsOnlyDynamics.not_entails': const('Becoming.Significance', 'thm', ['Becoming.Unrestricted']),
}
for n in ('Becoming.Leaf.H', 'Becoming.Leaf.form.needs_H', 'Becoming.Leaf.form.H_needed', 'Becoming.Leaf.recovery',
          'Becoming.Leaf.certified', 'Becoming.Leaf.bridge', *HYP2.values()):
    CONSTANTS[n] = const('Becoming.Leaf', 'def' if n.endswith('.H') else 'thm')
ANCHORS = ['Becoming.Flow.Balances', 'Becoming.Flow.BalancesOn', 'Becoming.balance_over_stretch_on', 'Becoming.«守数当且仅当可对»']


class TheTerms(unittest.TestCase):
    """§3.0 on constants made for the case."""
    @classmethod
    def setUpClass(cls):
        cls.T = boundary.Terms(CONSTANTS, ANCHORS)

    def test_grammar_laws(self):
        self.assertEqual(self.T.laws, {LAW, LAW2, 'Becoming.Law.constant_iff_core', 'Becoming.«守数当且仅当可对»'})
        for n in ('Becoming.kept_onward', 'Becoming.helper', 'Becoming.«两火»', 'Becoming.«非真则假»', 'Becoming.«所闭之界»._proof_1',
                  'Becoming.TwoCourses.core_iff', 'Becoming.MapRegions.«图»', 'Becoming.«族».brecOn.eq'):
            self.assertNotIn(n, self.T.laws, n)

    def test_root_constants_by_content(self):
        self.assertIn('Becoming.kept_onward', self.T.root)
        self.assertNotIn('Becoming.GrammarCourse.lockedAlike', self.T.root)  # a grammar-module constant built on a model
        self.assertNotIn('Becoming.TwoCourses.core_iff', self.T.root)  # a root statement proved off the root
        self.assertEqual(self.T.anchors, {'Becoming.Flow.Balances', 'Becoming.Flow.BalancesOn', 'Becoming.balance_over_stretch_on'})

    def test_auxiliaries_by_attachment(self):
        # a generated name under a declaration of the kind Lean generates it for, its constructors and its brecOn's
        # parts, and a private copy read by its user name; not one written by hand under a name Lean also uses
        self.assertEqual(boundary.components('Becoming.«a.b».c'), ['Becoming', '«a.b»', 'c'])
        for n in ('Becoming.«所闭之界»._proof_1', 'Becoming.«所闭之界»._proof_1_1', 'Becoming.Flow.Chain.below.refl',
                  'Becoming.Flow.Tree.brecOn.go', 'Becoming.Flow.X.match_1.eq_1', 'Becoming.Flow.Tree._proof_1',
                  'Becoming.Flow.op._proof_1', 'Becoming.Flow.op._unsafe_rec', 'Becoming.Flow.op.match_1',
                  'Becoming.aux._proof_1._@.Becoming.Flow._hyg.3', '_private.Becoming.Flow.0.Becoming.Flow.X.match_1.eq_1',
                  '_private.Becoming.Flow.0.Becoming.Flow.X.match_1._arg_pusher',
                  'Becoming.halve.«_@».Becoming.Flow.42._hygCtx._hyg.3.eq_1', 'Becoming.halve.«_@».Becoming.Flow.42._hygCtx._hyg.3.eq_def',
                  'Becoming.halve.«_@».Becoming.Flow.42._hygCtx._hyg.3._unsafe_rec', 'Becoming.Flow.Nest._sizeOf_2_eq',
                  'Becoming.Flow.Nest.below_1', 'Becoming.Flow.Nest.brecOn_1', 'Becoming.Flow.Nest.rec_1', 'Becoming.Flow.Nest.brecOn_1.go',
                  'Becoming.Flow.X.induct', 'Becoming.Flow.X.fun_cases_unfolding', 'Becoming.Flow.X.eq_unfold',
                  'Becoming.Flow.X.match_1.congr_eq_1', 'Becoming.Flow.X.mutual_induct_unfolding'):
            self.assertTrue(self.T.aux(n), n)
        for n in ('Becoming.Flow.row', 'Becoming.«a.rec».b', 'Becoming.Flow.recording', 'Becoming.Flow.row.inj',
                  'Becoming.Flow.X.casesOn', 'Becoming.Flow.Tree.eq_def', 'Becoming.Flow.row.brecOn.go', 'Becoming.Flow.Chain.below.other',
                  'Becoming.Flow.X.match_1.eq_1.mine', '_private.Becoming.Flow.0.Becoming.Flow.row.inj',
                  'Becoming.Flow.op.eq_1', 'Becoming.Flow.op.eq_def', 'Becoming.Flow.op.splitter', 'Becoming.Flow.Chain.brecOn.go',
                  'Becoming.Flow.Tree.match_1', 'Becoming.Flow.Chain.below.refl._proof_1', 'Becoming.Flow.Chain.below.refl.eq_1',
                  'Becoming.Flow.X.noConfusion', 'Becoming.Flow.Tree.noConfusion2', 'Becoming.Flow.X._aux_x', 'Becoming.Flow.Tree._sizeOf_',
                  'Becoming.aux._proof_1._@.Becoming.Other._hyg.3', 'Becoming.aux._@.Becoming.Flow._hyg.3',
                  'Becoming.halve.«_@».Becoming.Other.42._hygCtx._hyg.3.eq_1', 'Becoming.Flow.Tree.brecOn_1.go', 'Becoming.Flow.op.induct',
                  'Becoming.Flow.Tree.induct', 'Becoming.Flow.X.below_1', 'Becoming.Flow.Nest._sizeOf_2_eqx', 'Becoming.Flow.X.induct_',
                  'Becoming.Flow.X.congr_eq_',
                  # of a declaration the dump lacks: not generated until the Lean check gives its kind
                  'Nat.fold.eq_def', '_private.Becoming.Flow.0.PSigma.casesOn._arg_pusher'):
            self.assertFalse(self.T.aux(n), n)
        S = self.T.supplied({'Nat.fold': 'def', '_private.Becoming.Flow.0.PSigma.casesOn': 'def', 'Becoming.Flow.op': 'def', 'X': ''})
        self.assertTrue(S.aux('Nat.fold.eq_def') and S.aux('_private.Becoming.Flow.0.PSigma.casesOn._arg_pusher'))
        self.assertFalse(S.aux('Becoming.Flow.op.eq_1'))  # the dump's kind stands
        self.assertFalse(self.T.aux('Nat.fold.eq_def'))  # supplied to a copy only

    def test_the_names_the_dump_cannot_settle(self):
        # theorems whose standing turns on the kind of a declaration the dump lacks; one written under a namespace too
        self.assertEqual(boundary.outside(CONSTANTS), {'Nat.fold.eq_def', '_private.Becoming.Flow.0.PSigma.casesOn._arg_pusher'})
        self.assertEqual(boundary.outside({**CONSTANTS, 'Becoming.Space.inj': const(F, 'thm'), 'Becoming.Space.brecOn.eq': const(F, 'thm'),
                                           'Becoming.Space.brecOn': const(F, 'def'), 'Becoming.Space.eq_1': const(F, 'def'),
                                           'Becoming.Space.brecOn_1.go': const(F, 'thm'),
                                           'Becoming.halve.«_@».Becoming.Other.42._hygCtx._hyg.3.eq_1': const(F, 'thm'),
                                           'Becoming.halve.«_@».Becoming.Flow.42._hygCtx._hyg.3.eq_1': const(F, 'thm')})
                         - boundary.outside(CONSTANTS), {'Becoming.Space.inj', 'Becoming.Space.brecOn.eq', 'Becoming.Space.brecOn_1.go',
                                                         'Becoming.halve.«_@».Becoming.Other.42._hygCtx._hyg.3.eq_1'})

    def test_forwarders(self):
        # a proof naming another theorem is no forwarder; a forwarder of a forwarder forwards to its law
        self.assertEqual(self.T.forwarders, {'Becoming.Flow.forwarder': LAW, 'Becoming.Flow.projection': LAW2, 'Becoming.Flow.forwarder2': LAW})
        self.assertEqual((self.T.kind['Becoming.Flow.forwarder'], self.T.kind['Becoming.Flow.projection']), ('pure', 'projection'))
        self.assertEqual(self.T.law_of('Becoming.Flow.not_forwarder'), None)

    def test_the_walks(self):
        self.assertEqual(self.T.walk('Becoming.Flow.row'), {LAW, 'Becoming.Flow.bridge_iff', 'Becoming.Flow.support', 'Becoming.helper'})
        self.assertEqual(self.T.reach('Becoming.Flow.row'), {LAW, LAW2})
        self.assertEqual(self.T.reach('Becoming.Flow.via_helper'), {LAW})  # through a root helper without a «» name
        self.assertEqual(self.T.reach('Becoming.Flow.through_term'), set())  # stopping at a «» name
        self.assertEqual(self.T.walk('Becoming.Flow.via_aux'), {LAW, 'Becoming.Flow.fact'})  # through the auxiliaries
        self.assertEqual(self.T.walk('Becoming.Flow.via_named'), {LAW, 'Becoming.Flow.row.inj'})  # not through one written by hand

    def test_where_balance_enters(self):
        self.assertEqual(self.T.balance('Becoming.Flow.balanced')['anchor_in_statement'], ['Becoming.Flow.Balances'])
        self.assertTrue(self.T.balance('Becoming.Flow.written')['written_out'])
        self.assertFalse(self.T.balance('Becoming.Flow.written_two')['written_out'])  # all three, or balance is not written out
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
        failed = self.check('Becoming.Flow.via_named', law=[LAW])[0]  # a theorem written by hand under a generated name
        self.assertEqual(failed, ['D2: the proofs name theorems that are neither grammar laws, root theorems nor declared lemmas: Becoming.Flow.row.inj'])
        failed = self.check('Becoming.Flow.row', central=['Becoming.Flow.support'], law=[LAW], bridges=['Becoming.Flow.bridge_iff'],
                            support=['Becoming.Flow.support'])[0]
        self.assertEqual(failed, ['D2: the lemma Becoming.Flow.support is a central declaration'])
        self.assertIn(f'D3: the walk does not reach {LAW2}', self.check('Becoming.Flow.via_helper', law=[LAW, LAW2])[0])
        failed = self.check('Becoming.Flow.row', law=[LAW], bridges=['Becoming.Flow.bridge_iff'], support=['Becoming.Flow.support', 'Becoming.Flow.fact'])[0]
        self.assertEqual(failed, ['D4: the lemma Becoming.Flow.fact is not reached'])
        failed = self.check('Becoming.Flow.forwarder', law=[LAW], support=['Becoming.Flow.projection'])[0]
        self.assertIn('it is a grammar law or a forwarder of one', failed[0])
        failed = self.check('Becoming.Flow.row', law=[LAW], bridges=['Becoming.Flow.bridge_iff'], support=['Becoming.Flow.support', LAW2])[0]
        self.assertEqual(failed, [f'D4: the lemma {LAW2} is not reached as a lemma: it is a grammar law or a forwarder of one'])

    def test_balance_in_the_closure_fails_d5(self):
        # act_courses_unselected's shape: balance in the statement, or only in the proof
        self.assertEqual(self.check('Becoming.Flow.balanced', law=[LAW])[0], ['D5: balance enters its closure: Becoming.Flow.Balances'])
        self.assertEqual(self.check('Becoming.Flow.proof_balance', law=[LAW])[0],
                         ['D5: balance enters its closure: Becoming.balance_over_stretch_on'])

    def test_through_a_forwarder_and_an_auxiliary(self):
        self.assertEqual(self.check('Becoming.Flow.via_fw', law=[LAW])[0], [])  # D3: the law, through a forwarder
        self.assertEqual(self.check('Becoming.Flow.via_fw', law=[LAW], support=['Becoming.Flow.forwarder'])[0],
                         ['D4: the lemma Becoming.Flow.forwarder is not reached as a lemma: it is a grammar law or a forwarder of one'])
        self.assertEqual(self.check('Becoming.Flow.via_aux', law=[LAW], support=['Becoming.Flow.fact'])[0], [])  # reached through brecOn.eq

    def test_an_auxiliary_of_a_declaration_the_dump_lacks(self):
        failed = self.check('Becoming.Flow.unfolds', law=[LAW])[0]
        self.assertEqual(failed, ['D2: the proofs name theorems that are neither grammar laws, root theorems nor declared lemmas: Nat.fold.eq_def'])
        self.assertEqual(boundary.derived(self.T.supplied({'Nat.fold': 'def'}), 'Becoming.Flow.unfolds', {'law': [LAW]}, set())[0], [])
        self.assertEqual(boundary.derived(self.T.supplied({'Nat.fold': 'ctor'}), 'Becoming.Flow.unfolds', {'law': [LAW]}, set())[0], failed)

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
        self.assertEqual(boundary.rule('no shared law', {**self.NONE, 'written_out': True}, occurrence), 'balance in its statement')
        self.assertEqual(boundary.rule('grammar', {**self.NONE, 'proof_only': ['Becoming.Flow.Balances']}, occurrence), 'connected')
        self.assertEqual(boundary.rule('anchor, not reached', self.NONE, occurrence), 'at a represented model')
        self.assertEqual(boundary.rule('no shared law', self.NONE, [{'models': ['process']}]), 'at a represented model')
        self.assertEqual(boundary.rule('no shared law', self.NONE, own), 'own carrier')
        self.assertEqual(boundary.rule('balance, represented', self.NONE, []), 'unplaced')

    def test_the_facts(self):
        self.assertFalse(boundary.has_fact('connected', set(), self.NONE, []))
        self.assertTrue(boundary.has_fact('connected', {LAW}, self.NONE, []))
        self.assertTrue(boundary.has_fact('balance in its statement', set(), {**self.NONE, 'written_out': True}, []))
        self.assertFalse(boundary.has_fact('own carrier', set(), self.NONE, [{'models': ['own', 'process']}]))
        self.assertTrue(boundary.has_fact('at a represented model', set(), self.NONE, [{'models': ['own', 'process']}]))
        self.assertTrue(boundary.has_fact('own carrier', set(), self.NONE, [{'models': ['own']}]))
        self.assertFalse(boundary.has_fact('own carrier', set(), self.NONE, []))
        self.assertFalse(boundary.has_fact('balance in its statement', {LAW}, {**self.NONE, 'proof_only': ['Becoming.Flow.Balances']}, []))
        self.assertTrue(boundary.has_fact('balance in its statement', set(), {**self.NONE, 'anchor_in_statement': ['Becoming.Flow.Balances']}, []))


CENTRAL = {n: {'category': 'shared law', 'dependence': d} for n, d in (
    ('Becoming.Flow.row', 'grammar'), ('Becoming.Flow.steps', 'grammar'), ('Becoming.Flow.balanced', 'grammar'),
    ('Becoming.Flow.written', 'no shared law'), ('Becoming.Flow.proof_balance', 'grammar'), ('Becoming.Flow.via_helper', 'grammar'),
    ('Becoming.Flow.forwarder', 'grammar'), ('Becoming.Flow.counted', 'no shared law'), ('Becoming.Flow.modelled', 'anchor, not reached'),
    ('Becoming.Flow.own', 'no shared law'), ('Becoming.Flow.two', 'no shared law'), ('Becoming.Flow.absent', 'no shared law'))}
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
        rep = self.report(standing('Becoming.Flow.own', 'own carrier'), standing('Becoming.Flow.counted', 'balance in its statement'))
        self.assertEqual([x['declaration'] for x in rep['unverified']], ['Becoming.Flow.counted'])
        self.assertEqual(rep['rows']['Becoming.Flow.own']['placed'], 'reading')

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
        self.assertEqual(seen[0][1], ['Becoming.Flow', 'Becoming.Grammar', 'Becoming.Leaf'])  # the module of every name sent
        self.assertEqual((seen[0][0]['names'], seen[0][0]['equivalences']), ([LAW], ['Becoming.Flow.bridge_iff']))
        rep = self.report(*entries, lean=failing)
        failed = {x['declaration']: x['failed'] for x in rep['unverified']}
        self.assertEqual(failed['Becoming.Flow.two'], ['the discharge condition fails: the recovery uses [Becoming.Flow.fact]'])
        self.assertEqual(failed['Becoming.Flow.row'], [f'D1: the Lean check does not admit {LAW}',
                                                       'D6: the bridge Becoming.Flow.bridge_iff is not an equivalence'])
        self.assertEqual(rep['rows']['Becoming.Flow.two']['label'], 'unplaced')
        def dropping(query, modules):
            out, info = lean_passing(query, modules)
            out['entries'] = []
            return out, info
        rep = self.report(*entries, lean=dropping)
        self.assertEqual({x['declaration']: x['failed'] for x in rep['unverified']}, {'Becoming.Flow.two': ['the Lean check gave no result']})
        def silent(query, modules):  # an entry that did not pass, with no failures given
            out, info = lean_passing(query, modules)
            out['entries'][0].update(passed=False, failures=[])
            return out, info
        rep = self.report(*entries, lean=silent)
        self.assertEqual({x['declaration']: x['failed'] for x in rep['unverified']}, {'Becoming.Flow.two': ['the Lean check did not pass it']})
        for bad in ([], {'entries': [1]}, {'entries': [], 'admitted': []}, {'entries': [{'row': ['Becoming.Flow.two'], 'passed': True}]},
                    {'entries': [{'row': {}, 'passed': True}]}):
            rep = self.report(*entries, lean=lambda q, m, bad=bad: (bad, {'ran': True}))
            self.assertEqual(len(rep['unverified']), 2, bad)
            self.assertEqual(rep['lean_check'], {'ran': False, 'reason': 'the Lean check gave malformed output'})
        def saying(query, modules):  # an admission or an equivalence given as something other than true
            out, info = lean_passing(query, modules)
            return {**out, 'admitted': {k: 'yes' for k in out['admitted']}, 'equivalence': {k: 1 for k in out['equivalence']}}, info
        rep = self.report(*entries, lean=saying)
        self.assertEqual({x['declaration']: x['failed'] for x in rep['unverified']}['Becoming.Flow.row'],
                         [f'D1: the Lean check does not admit {LAW}', 'D6: the bridge Becoming.Flow.bridge_iff is not an equivalence'])
        seen.clear()
        self.report(*entries, standing('Becoming.Flow.steps', 'derived', law=[LAW2]),
                    standing('Becoming.Flow.counted', 'derived', law=['Becoming.«两火»'], support=['Becoming.Nowhere']), lean=recording)
        # the check runs before D1 to D5, so an entry failing D2 is sent; one breaking the field's rules is not
        self.assertEqual(seen[0][0]['names'], sorted([LAW, LAW2]))
        self.assertEqual(seen[0][0]['generated'], ['Nat.fold.eq_def', '_private.Becoming.Flow.0.PSigma.casesOn._arg_pusher'])
        seen.clear()
        self.report(at_hypothesis(), lean=recording)
        self.assertEqual(seen[0][0]['generated'], [])  # nothing to settle without a derived entry
        rep = self.report(*entries, lean=lambda q, m: (None, {'ran': False, 'reason': 'not in the cache'}))
        self.assertEqual(len(rep['unverified']), 2)
        self.assertTrue(all(x['failed'] == ['the Lean check did not run: not in the cache'] for x in rep['unverified']))
        self.assertEqual(rep['lean_check'], {'ran': False, 'reason': 'not in the cache'})
        rep = self.report(standing('Becoming.Flow.counted', 'counting'), lean=None)  # nothing to check: Lean is not run
        self.assertEqual(rep['lean_check'], {'ran': False, 'reason': 'nothing to check'})

    def test_the_lean_checks_kinds_for_d2(self):
        # an auxiliary of Init's declaration, realized in a package module: D2 takes the kind before it from the check
        central = {**CENTRAL, 'Becoming.Flow.unfolds': {'category': 'shared law', 'dependence': 'grammar'}}
        f5 = {**F5, 'Becoming.Flow.unfolds': 'reaching the grammar'}
        def kinds(given):
            def run(query, modules):
                out, info = lean_passing(query, modules)
                return {**out, 'kinds': given}, info
            return run
        def unverified(lean):
            r = carrier(standing('Becoming.Flow.unfolds', 'derived', law=[LAW]))
            return {x['declaration']: x['failed'] for x in boundary.report(CONSTANTS, central, AT_MODEL, f5, r, ANCHORS, lean=lean)['unverified']}
        d2 = ['D2: the proofs name theorems that are neither grammar laws, root theorems nor declared lemmas: Nat.fold.eq_def']
        self.assertEqual(unverified(kinds({'Nat.fold': 'def', 'Nat.fold.eq_def': 'thm'})), {})
        self.assertEqual(unverified(lean_passing), {'Becoming.Flow.unfolds': d2})  # no kinds: it fails closed
        self.assertEqual(unverified(kinds({'Nat.fold': 'ind'})), {'Becoming.Flow.unfolds': d2})
        self.assertEqual(unverified(lambda q, m: (None, {'ran': False, 'reason': 'x'})),  # and says the check did not run
                         {'Becoming.Flow.unfolds': d2 + ['the Lean check did not run, so the kinds of names the dump lacks are not known: x']})
        self.assertEqual(unverified(kinds([])),  # malformed kinds: the check's output is refused
                         {'Becoming.Flow.unfolds': d2 + ['the Lean check did not run, so the kinds of names the dump lacks are not known: '
                                                         'the Lean check gave malformed output']})

    def test_the_lean_check_when_the_checker_cannot_be_set_up(self):
        def missing():
            raise FileNotFoundError('no lean binary')
        with patch.object(boundary, 'checker', missing):
            out, info = boundary.lean_check({'entries': [], 'names': [LAW], 'equivalences': []}, [])
        self.assertEqual((out, info), (None, {'ran': False, 'reason': 'the checker could not be set up: FileNotFoundError: no lean binary'}))
        with tempfile.TemporaryDirectory() as scratch:
            check = Path(scratch) / 'check.lean'
            check.write_text('-- no import line\n')
            with patch.object(boundary, 'CHECK', check), self.assertRaisesRegex(RuntimeError, 'does not begin with import Lean'):
                boundary.run_check(Path(scratch), [], {}, ['lean'], 1)
        self.assertEqual(boundary.local(f'error at {Path.home()}/x and /tmp/w1/B.lean:\n  line 3', Path('/tmp/w1')),
                         'error at ~/x and <scratch>/B.lean: line 3')  # a rerun in the same state writes the same data

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
        r = carrier(standing('Becoming.Flow.counted', 'counting'))
        r['boundary']['standings'].insert(0, 1)
        rep = boundary.report(CONSTANTS, CENTRAL, AT_MODEL, F5, r, ANCHORS, lean=lean_passing)  # an item that is no object
        self.assertEqual(rep['unverified'], [{'item': 1, 'declaration': None, 'standing': None,
                                              'failed': ["its record breaks the check's rules: a standing must be an object"]}])
        self.assertEqual(rep['rows']['Becoming.Flow.counted']['placed'], 'reading')
        self.assertEqual(registry.boundary_status([r], {'boundary': rep})['boundary_unverified'],
                         ["standing 1: its record breaks the check's rules: a standing must be an object"])
        r['boundary']['standings'].pop(0)
        r['boundary']['premises_of_the_ethics'][1] = None
        rep = boundary.report(CONSTANTS, CENTRAL, AT_MODEL, F5, r, ANCHORS, lean=lean_passing)
        whole = "its record breaks the check's rules: premises_of_the_ethics lists exactly two items, one of role scope and one of role order"
        self.assertEqual(rep['premises_of_the_ethics'][1], {'item': 2, 'result': 'unverified',
                                                            'failed': [whole, "its record breaks the check's rules: a premise must be an object"]})
        self.assertEqual(registry.boundary_status([r], {'boundary': rep})['boundary_premises_unverified'][1],
                         f"premise 2: None ({whole}; its record breaks the check's rules: a premise must be an object)")
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
        self.assertEqual(list(rep['against_f5']), list(boundary.LABELS))  # every label, zeros included
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
        rep = self.report(standing('Becoming.Flow.counted', 'counting'), premises=[{**SCOPE, 'not_entailed': 'Becoming.Comparison'}, ORDER])
        self.assertEqual(rep['premises_of_the_ethics'][0]['failed'], ['Becoming.Comparison is not a theorem of the run'])

    def test_the_counts_of_the_boundary_record(self):
        self.assertEqual(shared_laws.counted_in('edge', 1, ['edge'], {('edge', 1)}), 'counts_at_boundary_record')
        self.assertEqual(shared_laws.counted_in('m', 2, ['edge'], {('m', 2)}), 'counts_at_model')
        self.assertEqual(shared_laws.counted_in('m', 1, ['edge'], {('m', 2)}), 'counts')
        self.assertEqual(shared_laws.counted_in('m', 1, [], set()), 'counts')
        # the generator's tables: each law in one, the boundary record's laws apart, one carrying items there only
        loaded = [{'id': 'edge', 'laws': [{'declarations': ['Becoming.Leaf.form']}, {'declarations': ['Becoming.Leaf.part']}]},
                  {'id': 'm', 'laws': [{'declarations': ['Becoming.Flow.row']}, {'declarations': ['Becoming.Flow.own']}]}]
        checked = {('edge', 2): [{'declaration': 'Becoming.Leaf.part', 'verified': True}], ('m', 2): [{'declaration': 'Becoming.M.own', 'verified': True}]}
        def above(n):
            return True, True, frozenset({'balance'} if n == 'Becoming.Leaf.part' else ())
        for carrying, laws in ((['edge'], [1, 1, 2]), ([], [2, 2, 0])):
            records, tables = shared_laws.law_entries(loaded, CONSTANTS, above, {}, set(), checked, {}, carrying)
            self.assertEqual([tables[k]['laws'] for k in shared_laws.COUNTED], laws, carrying)
            self.assertEqual(list(tables['counts']), list(tables['counts_at_boundary_record']))
        self.assertEqual((tables['counts_at_model']['grammar'], tables['counts_at_model']['balance']), (2, 1))
        _, two = shared_laws.law_entries(loaded, CONSTANTS, above, {}, set(), checked, {}, ['edge', 'm'])
        self.assertEqual([two[k]['laws'] for k in shared_laws.COUNTED], [0, 0, 4])  # with two carriers, both records' laws apart
        self.assertEqual(records['edge'][1]['statements_at_model'], checked['edge', 2])
        # the data's boundary: the report for one carrier, an error naming both for two, nothing for none
        self.assertEqual(shared_laws.boundary_data(['edge'], lambda rid: {'record': rid}), {'record': 'edge'})
        self.assertEqual(shared_laws.boundary_data(['edge', 'm'], lambda rid: self.fail('no report for two carriers')),
                         {'error': 'the boundary field is carried by more than one record', 'records': ['edge', 'm']})
        self.assertIsNone(shared_laws.boundary_data([], lambda rid: self.fail('no report without a carrier')))
        ec = type('EC', (), {'__file__': str(shared_laws.MEASURE), 'COVERAGE': shared_laws.MEASURE})
        self.assertLessEqual({'tools/research/boundary.py', 'tools/research/boundary_check.lean'}, set(shared_laws.hashed_inputs(ec)))


class ThroughTheCheck(unittest.TestCase):
    """The field through registry.validate: on a schema-1 record, on a schema-2 record with the review's text, and on
    two records."""
    def test_validate(self):
        from tools.research.tests.test_schema2 import TemporaryRoot
        field = {'standings': [standing('Becoming.Flow.counted', 'counting', review='Law.lean')],
                 'premises_of_the_ethics': [{**SCOPE, 'review': 'Law.lean'}, {**ORDER, 'review': 'Law.lean'}]}
        with TemporaryRoot() as t:
            errors = registry.validate([t.record(boundary=copy.deepcopy(field))])[0]
            self.assertIn('example: boundary standing 1 (Becoming.Flow.counted): its review Law.lean does not name Becoming.Flow.counted', errors)
            (t.root / 'Law.lean').write_text('`Becoming.Flow.counted` `Becoming.Unrestricted` `Becoming.ReadsOnlyDynamics.not_entails` '
                                             '`Becoming.Comparison`\n')
            self.assertEqual([e for e in registry.validate([t.record(boundary=copy.deepcopy(field))])[0] if 'boundary' in e], [])
            errors = registry.validate([t.record(boundary=copy.deepcopy(field), schema_version=1)])[0]
            self.assertTrue(any('schema-2 fields need schema_version 2:' in e and e.endswith(', boundary') for e in errors), errors)
            two = [t.record(boundary=copy.deepcopy(field)), t.record(boundary=copy.deepcopy(field), id='example2',
                                                                      _record_path='records/example2.json')]
            self.assertIn('the boundary field is carried by more than one record: example, example2', registry.validate(two)[0])


class ThePages(unittest.TestCase):
    """The standing lines and the boundary record's section (§5), and what re-renders (§3.6)."""
    def setUp(self):
        self.declared = carrier(standing('Becoming.Flow.row', 'derived', law=[LAW], bridges=['Becoming.Flow.bridge_iff'],
                                         support=['Becoming.Flow.support']),
                                at_hypothesis(), standing('Becoming.Flow.counted', 'counting'),
                                standing('Becoming.Flow.balanced', 'balance in its statement', relational_part='Becoming.Leaf.part'),
                                standing('Becoming.Flow.steps', 'derived', law=[LAW]),
                                standing('Becoming.Flow.via_helper', 'amounts'), standing('Becoming.Flow.absent', 'counting'))
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
                         f'*Place of `Becoming.Flow.row`:* derived, a case of `{LAW}` through `Becoming.Flow.bridge_iff`, with the '
                         f'support `Becoming.Flow.support`, using also `{LAW2}` (declared in [edge](edge.md); the closed set checked against '
                         'the Lean, the bridges checked as equivalences; the case read in [review.md](../../../../_process/review.md)). '
                         'Root theorems its proofs name: `Becoming.helper` (Init not shown).')
        self.assertEqual(self.line('Becoming.Flow.two'),
                         '*Place of `Becoming.Flow.two`:* under a stated hypothesis, the root form `Becoming.Leaf.form` at its model, '
                         'with hypothesis `Becoming.Leaf.H`, with its countermodel and fit (declared in [edge](edge.md); checked in Lean: the '
                         'form, its countermodels, the certificate and the discharge condition; the hypotheses read as the row\'s relational '
                         'content in [review.md](../../../../_process/review.md)).')
        self.assertEqual(self.line('Becoming.Flow.counted'),
                         '*Place of `Becoming.Flow.counted`:* counting, a reading: Why it stands so ([review.md](../../../../_process/review.md)); '
                         "the rule gives unplaced (none of the rule's tests holds).")
        self.assertEqual(self.line('Becoming.Flow.via_helper'),  # a reading where the rule differs: its label and its reason
                         '*Place of `Becoming.Flow.via_helper`:* amounts, a reading: Why it stands so ([review.md](../../../../_process/review.md)); '
                         f'the rule gives connected (it reaches `{LAW}` among its reasons; not declared a case of one).')
        self.assertEqual(self.line('Becoming.Flow.balanced'),
                         '*Place of `Becoming.Flow.balanced`:* balance in its statement, a reading: Why it stands so '
                         '([review.md](../../../../_process/review.md)); the rule gives the same; its relational part: `Becoming.Leaf.part`.')
        self.assertEqual(self.line('Becoming.Flow.forwarder'),
                         f'*Place of `Becoming.Flow.forwarder`, by the rule:* connected (it reaches `{LAW}` among its reasons; not '
                         'declared a case of one).')
        self.assertEqual(self.line('Becoming.Flow.written'),
                         '*Place of `Becoming.Flow.written`, by the rule:* balance in its statement (balance written out in its statement).')
        self.assertEqual(self.line('Becoming.Flow.modelled'),
                         "*Place of `Becoming.Flow.modelled`, by the rule:* at a represented model (F5's verified items at the occurrence model).")
        self.assertEqual(self.line('Becoming.Flow.own'),
                         "*Place of `Becoming.Flow.own`, by the rule:* own carrier (F5's verified items on its own carrier only).")
        self.assertEqual(self.line('Becoming.Flow.absent'),  # an unverified entry: the reason does not say none was declared
                         "*Place of `Becoming.Flow.absent`, by the rule:* unplaced (no place verified, and none of the rule's tests holds; "
                         'the declared place, counting, is unverified: not in the spine run: Becoming.Flow.absent).')
        self.assertEqual(self.line('Becoming.Flow.steps'),
                         f'*Place of `Becoming.Flow.steps`, by the rule:* connected (it reaches `{LAW}` among its reasons; not verified as a '
                         'case of one; the declared place, derived, is unverified: D2: the proofs name theorems that are neither grammar '
                         'laws, root theorems nor declared lemmas: Becoming.Flow.fact).')
        unplaced = copy.deepcopy(self.declared)
        unplaced['boundary']['standings'].pop()
        self.data = {'boundary': boundary.report(CONSTANTS, CENTRAL, AT_MODEL, F5, unplaced, ANCHORS, lean=lean_passing)}
        self.declared = unplaced
        self.assertEqual(self.line('Becoming.Flow.absent'),
                         "*Place of `Becoming.Flow.absent`, by the rule:* unplaced (no place declared, and none of the rule's tests holds).")

    def test_the_other_sentences(self):
        # a forwarder row, standing 2 with two hypotheses and a bridge, an anchor in the statement, two represented models
        at_model = {**AT_MODEL, 'Becoming.Flow.modelled': AT_MODEL['Becoming.Flow.modelled'] + [
            {'of': 'Becoming.Flow.modelled', 'record': 'm', 'law': 4, 'declaration': 'Becoming.M.process', 'models': ['process'], 'review': REVIEW}]}
        self.declared = carrier(standing('Becoming.Flow.forwarder', 'derived', law=[LAW]),
                                at_hypothesis(hyps=(HYP, HYP2), bridges=['Becoming.Leaf.bridge']))
        self.data = {'boundary': boundary.report(CONSTANTS, CENTRAL, at_model, F5, self.declared, ANCHORS, lean=lean_passing)}
        line = lambda d: registry.standing_line(d, self.records([d], matched_at_model=('m:2', 'm:3', 'm:4'))[0]['_standings']['rows'][d],
                                                'edge', lambda i: f'[{i}]({i}.md)', registry.ROOT / 'theories/becoming/results/records')
        self.assertEqual(line('Becoming.Flow.forwarder'),
                         f'*Place of `Becoming.Flow.forwarder`:* derived, a case of `{LAW}` (it forwards to `{LAW}`, of kind pure) (declared '
                         'in [edge](edge.md); the closed set checked against the Lean; the case read in [review.md](../../../../_process/review.md)).')
        self.assertEqual(line('Becoming.Flow.two'),
                         '*Place of `Becoming.Flow.two`:* under a stated hypothesis, the root form `Becoming.Leaf.form` at its model, with '
                         'hypotheses `Becoming.Leaf.H` and `Becoming.Leaf.H2`, each with its countermodel and fit, through the bridges '
                         '`Becoming.Leaf.bridge` (declared in [edge](edge.md); checked in Lean: the form, its countermodels, the certificate and '
                         "the discharge condition; the hypotheses read as the row's relational content in [review.md](../../../../_process/review.md)).")
        self.assertEqual(line('Becoming.Flow.balanced'),
                         '*Place of `Becoming.Flow.balanced`, by the rule:* balance in its statement (`Becoming.Flow.Balances` in its statement).')
        self.assertEqual(line('Becoming.Flow.modelled'),
                         "*Place of `Becoming.Flow.modelled`, by the rule:* at a represented model (F5's verified items at the occurrence and "
                         'process models).')

    def test_the_section_follows_the_laws(self):
        edge = self.records()[-1]
        r = json.loads(json.dumps(next(x for x in registry.load_records()[0] if x.get('schema_version') == 2 and x.get('laws')
                                       and x.get('hypotheses')), ensure_ascii=False))
        r.pop('_standings', None)
        r['_boundary'] = edge['_boundary']
        page = registry.render_record_v2(r)
        self.assertLess(page.index('## Laws'), page.index('## Places on the edge'))
        self.assertLess(page.index('## Places on the edge'), page.index('## Conditions'))
        # AG review, 9 November 2026: 08 §7 places each central declaration; the old heading's anchor still lands
        self.assertIn('<a id="standings-on-the-edge"></a>\n## Places on the edge', page)
        self.assertNotIn('Standing of `', page)

    def test_one_line_per_central_declaration_and_record(self):
        records = self.records(['Becoming.Flow.row', 'Becoming.Flow.fact', 'Becoming.Flow.counted', 'Becoming.Flow.row'], ['Becoming.Flow.row'])
        self.assertEqual(list(records[0]['_standings']['rows']), ['Becoming.Flow.counted', 'Becoming.Flow.row'])
        self.assertEqual(list(records[1]['_standings']['rows']), ['Becoming.Flow.row'])
        r = json.loads(json.dumps({**next(x for x in registry.load_records()[0] if x.get('schema_version') == 2 and x.get('laws')),
                                   'laws': records[0]['laws'], '_standings': records[0]['_standings']}, ensure_ascii=False))
        r.pop('_shared_laws', None)
        page = registry.render_record_v2(r)
        self.assertEqual(page.count('   - *Place of `Becoming.Flow.row`:*'), 1)  # a child of law 1, once though named twice
        self.assertEqual(page.count('   - *Place of `Becoming.Flow.counted`:*'), 1)

    def test_lines_hidden_when_not_matched(self):
        now = copy.deepcopy(self.declared)
        now['boundary']['standings'][2]['basis'] = {'en': 'Another reason.'}
        rows = self.records(['Becoming.Flow.counted', 'Becoming.Flow.row'], now=now)[0]['_standings']['rows']
        self.assertEqual(list(rows), ['Becoming.Flow.row'])  # the changed entry's line is hidden, the others stay
        self.assertNotIn('_standings', self.records(['Becoming.Flow.modelled'], matched_at_model=())[0])  # the F5 law it cites changed
        self.assertIn('_standings', self.records(['Becoming.Flow.modelled'])[0])
        moved = {**copy.deepcopy(self.declared), 'id': 'elsewhere'}
        self.assertNotIn('_standings', self.records(['Becoming.Flow.row'], now=moved)[0])  # the data read another record
        # a reading beside the rule's F5 label states F5's items too, so it waits for the F5 law as the rule's line does
        self.declared = carrier(standing('Becoming.Flow.modelled', 'amounts'))
        self.data = {'boundary': boundary.report(CONSTANTS, CENTRAL, AT_MODEL, F5, self.declared, ANCHORS, lean=lean_passing)}
        self.assertEqual(self.data['boundary']['rows']['Becoming.Flow.modelled']['rule'], 'at a represented model')
        self.assertNotIn('_standings', self.records(['Becoming.Flow.modelled'], matched_at_model=())[0])
        self.assertIn('_standings', self.records(['Becoming.Flow.modelled'])[0])

    def test_the_record_around_the_field(self):
        # what the rules read besides the field: a change there leaves every verdict in doubt
        for change in (lambda r: r['references'].append({'role': 'review', 'path': '_process/another.md'}),
                       lambda r: r.update(status='recorded-open'), lambda r: r['laws'][0]['declarations'].pop(),
                       lambda r: r['boundary'].update(note={'en': 'x'})):
            now = copy.deepcopy(self.declared)
            change(now)
            shown, not_matched = registry.boundary_matching([now], self.data)
            named = set(registry._grouped(self.declared['boundary'])) | set(registry._grouped(now['boundary']))
            self.assertEqual(shown, set(self.data['boundary']['rows']) - named)  # the rule's rows outside the field stay
            self.assertIn('Becoming.Flow.forwarder', shown)
            self.assertEqual(not_matched, ['the field', *sorted(named), 'premises_of_the_ethics'])
            records = [now, {'id': 'p', 'laws': [{'declarations': ['Becoming.Flow.forwarder', 'Becoming.Flow.row']}]}]
            registry.attach_standings(records, self.data, {'m:2', 'm:3'})
            self.assertEqual(list(records[1]['_standings']['rows']), ['Becoming.Flow.forwarder'])
            section = '\n'.join(x for x in registry.boundary_section(now, registry.ROOT) if isinstance(x, str))
            self.assertIn("*Not matched:* the record around this field (its status, schema, reviews or laws) or the field's own keys "
                          'changed since the data read it, so no entry of the field is matched (Becoming.Flow.', section)
        self.assertEqual(registry.boundary_matching([copy.deepcopy(self.declared)], self.data)[1], [])

    def test_a_carrier_the_data_has_not_read(self):
        unread = carrier(standing('Becoming.Flow.counted', 'counting'))
        for data in ({}, {'boundary': {'record': 'another', 'declared': {}, 'rows': {}}}):
            records = [copy.deepcopy(unread), {'id': 'another', 'laws': []}]
            registry.attach_standings(records, data, set())
            self.assertEqual(records[0]['_boundary'], {'not_matched': ['Becoming.Flow.counted', 'premises_of_the_ethics']})
            self.assertNotIn('_boundary', records[1])  # the data's record carries the field no longer
            section = '\n'.join(x for x in registry.boundary_section(records[0], registry.ROOT) if isinstance(x, str))
            self.assertIn('*Not matched:* the data read another version of this field (Becoming.Flow.counted and premises_of_the_ethics)', section)

    def test_pages_unchanged_without_the_field(self):
        records = [r for r in registry.load_records()[0] if r.get('schema_version') == 2 and r.get('laws')][:40]
        for r in records:
            r.pop('_standings', None)
            r.pop('_boundary', None)
        before = [registry.render_record_v2(copy.deepcopy(r)) for r in records]
        registry.attach_standings(records, {'records': {}}, set())
        self.assertEqual([registry.render_record_v2(r) for r in records], before)

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
        # each premise's theorem in 08 §7's words (RW): the condition's reads only the dynamics, C's reads no order;
        # since 9 November 2026 the items are said as the hypotheses ranking results take, not as scope and order roles
        self.assertIn('**Hypotheses the ranking results take**, each only where a theorem takes it:', text)
        self.assertIn('- **Whose losses count:** the continuation condition, `Becoming.Unrestricted`; where there is a standpoint and a '
                      'formation, no statement reading only the dynamics and holding of some dynamics entails it, by '
                      '`Becoming.ReadsOnlyDynamics.not_entails`', text)
        self.assertIn('- **How courses are ranked:** C, `Becoming.Comparison`; no theorem shows it unentailed by the dynamics: No theorem shows it.', text)
        self.assertNotIn('**For scope**', text)
        self.assertNotIn('**For order**', text)
        self.assertIn(f'- `Becoming.Flow.row`: derived (a checked entry): a case of `{LAW}`; bridges `Becoming.Flow.bridge_iff`; support '
                      '`Becoming.Flow.support`.', text)
        self.assertIn('- `Becoming.Flow.two`: under a stated hypothesis (a checked entry): the form `Becoming.Leaf.form`; `Becoming.Leaf.H` '
                      '(countermodel `Becoming.Leaf.form.needs_H`, fit `Becoming.Leaf.form.H_needed`); recovery `Becoming.Leaf.recovery`; '
                      'certificate `Becoming.Leaf.certified`.', text)
        self.assertIn('- `Becoming.Flow.steps`: connected (by the rule; the declared place, derived, is unverified).', text)
        self.assertIn('- `Becoming.Flow.balanced`: balance in its statement (a reading; the rule gives the same).', text)
        self.assertIn('- `Becoming.Flow.counted`: counting (a reading; the rule gives unplaced).', text)
        for group in ('On the edge', 'Below the grammar', 'Distances', 'Unplaced'):
            self.assertIn(group, text)
        now = copy.deepcopy(self.declared)
        now['boundary']['premises_of_the_ethics'][1]['absent'] = {'en': 'Changed.'}
        edge = self.records(now=now)[-1]
        self.assertIn('*Not matched:* the data read another version of this field (premises_of_the_ethics)',
                      '\n'.join(x for x in registry.boundary_section(edge, registry.ROOT) if isinstance(x, str)))
        edge = self.records()[-1]  # a premise's absent of another shape is left out of its line, not a crash
        for bad in ('No theorem shows it.', ['x'], 1.5):
            edge['_boundary']['premises_of_the_ethics'][1]['absent'] = bad
            text = '\n'.join(x for x in registry.boundary_section(edge, registry.ROOT) if isinstance(x, str))
            self.assertIn('- **How courses are ranked:** C, `Becoming.Comparison`; no theorem shows it unentailed by the dynamics.', text)

    def test_what_re_renders_after_a_change_to_the_boundary_record(self):
        records = [{'id': 'edge', '_record_path': 'theories/becoming/results/records/edge.json', 'boundary': {}, 'references': [],
                    'dependencies': [], 'laws': []},
                   {'id': 'naming', '_record_path': 'theories/becoming/results/records/naming.json', 'references': [], 'dependencies': [],
                    'laws': [{'declarations': ['Becoming.Flow.row']}]},
                   {'id': 'other', '_record_path': 'theories/becoming/results/records/other.json', 'references': [], 'dependencies': [],
                    'laws': [{'declarations': ['Becoming.Flow.fact']}]}]
        with patch.object(registry, 'shared_laws', return_value=self.data):
            self.assertEqual(registry.affected_ids(records, {'theories/becoming/results/records/edge.json'}), {'edge', 'naming'})
            self.assertEqual(registry.affected_ids(records, {'theories/becoming/results/records/other.json'}), {'other'})
            # the data changed: every record with laws, and the boundary record, which has none here
            self.assertEqual(registry.affected_ids(records, {registry.SHARED_LAWS}), {'edge', 'naming', 'other'})
        with patch.object(registry, 'shared_laws', return_value=self.data):
            # the boundary record deleted: the data's record, though it is gone
            self.assertEqual(registry.affected_ids(records[1:], {'theories/becoming/results/records/edge.json'}), {'naming'})
            # an F5 carrier changed: the rule's lines citing its laws show or hide
            cited = [{'id': 'm', '_record_path': 'theories/becoming/results/records/m.json', 'references': [], 'dependencies': [], 'laws': []},
                     {'id': 'shows', '_record_path': 'theories/becoming/results/records/shows.json', 'references': [], 'dependencies': [],
                      'laws': [{'declarations': ['Becoming.Flow.modelled']}]}]
            self.assertEqual(registry.affected_ids(records + cited, {'theories/becoming/results/records/m.json'}), {'m', 'shows'})
        unread = {'records': {'naming': [{'law': 1, 'central': [{'declaration': 'Becoming.Flow.row'}]}]}}  # U4's first landing
        with patch.object(registry, 'shared_laws', return_value=unread):
            self.assertEqual(registry.affected_ids(records, {'theories/becoming/results/records/edge.json'}), {'edge', 'naming'})


def bare(*standings, **more):
    """A carrier whose law declares nothing, so that the status reads no law of it."""
    return carrier(*standings, own=[], **more)


class TheStatus(unittest.TestCase):
    """The status's four lists, current, and the error (§3.6). The core receipt and the inputs match, and the carrier's
    law declares nothing, so that `current` turns on the boundary field alone."""
    def setUp(self):
        self.dir = tempfile.TemporaryDirectory()
        (Path(self.dir.name) / 'receipt.json').write_text(json.dumps({'utc': 'R', 'status': 'passed', 'source_sha256': {}}))
        self.patches = [patch.object(registry, 'ROOT', Path(self.dir.name)), patch.object(registry, 'CORE_RECEIPT', 'receipt.json')]
        for x in self.patches:
            x.start()

    def tearDown(self):
        for x in self.patches:
            x.stop()
        self.dir.cleanup()

    def status(self, data, records):
        with patch.object(registry, 'shared_laws', return_value=data):
            return registry.shared_laws_status(records)

    def base(self, boundary_data):
        return {'core_receipt': 'R', 'names': {}, 'inputs_sha256': {}, 'records': {},
                'core_sources_sha256': hashlib.sha256(json.dumps({}, sort_keys=True).encode()).hexdigest(),
                **({'boundary': boundary_data} if boundary_data is not None else {})}

    def test_the_four_lists_and_current(self):
        declared = bare(standing('Becoming.Flow.steps', 'derived', law=[LAW]), standing('Becoming.Flow.counted', 'counting'),
                           premises=[SCOPE, {**ORDER, 'premise': 'Becoming.Flow.fact'}])
        rep = boundary.report(CONSTANTS, CENTRAL, AT_MODEL, F5, declared, ANCHORS, lean=lean_passing)
        status = self.status(self.base(rep), [copy.deepcopy(declared)])
        self.assertEqual(status['boundary_unverified'], ['Becoming.Flow.steps (derived): D2: the proofs name theorems that are neither '
                                                         'grammar laws, root theorems nor declared lemmas: Becoming.Flow.fact'])
        self.assertEqual(status['boundary_premises_unverified'], ['order: Becoming.Flow.fact (Becoming.Flow.fact is not a definition of the run)'])
        self.assertEqual(status['boundary_unplaced'], ['Becoming.Flow.absent', 'Becoming.Flow.two'])
        self.assertEqual(status['boundary_not_matched'], [])
        self.assertTrue(status['current'])  # unverified entries leave the data current; a changed field does not
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
        declared = bare(standing('Becoming.Flow.counted', 'counting'))
        rep = boundary.report(CONSTANTS, CENTRAL, AT_MODEL, F5, declared, ANCHORS, lean=lean_passing)
        status = self.status(self.base(rep), [declared])
        self.assertEqual((status['boundary_unverified'], status['boundary_premises_unverified']), ([], []))

    def test_without_the_field_and_with_two_records(self):
        status = self.status(self.base(None), [{'id': 'p'}])
        self.assertEqual([status[k] for k in ('boundary_unverified', 'boundary_premises_unverified', 'boundary_unplaced',
                                              'boundary_not_matched')], [[], [], [], []])
        self.assertNotIn('boundary_error', status)
        self.assertTrue(status['current'])
        status = self.status(self.base({'error': 'the boundary field is carried by more than one record', 'records': ['a', 'b']}),
                             [bare(ident='a'), bare(ident='b')])
        self.assertEqual(status['boundary_error'], 'the boundary field is carried by more than one record: a, b')
        self.assertFalse(status['current'])
        self.assertEqual(status['boundary_not_matched'], [])

    def test_the_field_fails_as_a_whole(self):
        declared = bare(standing('Becoming.Flow.counted', 'counting'))
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
theorem «同之自» (X : Type) (x : X) : x = x := rfl
def «同» (X : Type) : {r : «际» X // ∀ x, r x x} := ⟨fun a b => a = b, «同之自» X⟩
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
theorem Model.eq_props {a : Prop} : (a ∧ True) = a := propext ⟨And.left, fun h => ⟨h, trivial⟩⟩
theorem Model.eq_predicates : (fun x : Nat => Model.rel x x) = (fun x => Model.rel x x) := rfl
theorem Model.next_rel : ∀ x, Model.rel x (Model.next x) := fun _ => rfl
def Model.step : {f : Nat → Nat // ∀ x, Model.rel x (f x)} := ⟨Model.next, Model.next_rel⟩
def Model.step_tactic : {f : Nat → Nat // ∀ x, Model.rel x (f x)} := ⟨Model.next, by intro x; exact Model.next_rel x⟩
structure Model.Onward where
  f : Nat → Nat
  ok : ∀ x, Model.rel x (f x)
def Model.onward : Model.Onward := ⟨Model.next, fun _ => rfl⟩
def Model.half (n : Nat) : Nat := if n < 2 then 0 else Model.half (n / 2) + 1
termination_by n
decreasing_by omega
def Model.relH : «际» Nat := fun a b => b = Model.half a
theorem Model.relH_total : ¬ ∃ x, ∀ y, ¬ Model.relH x y := fun ⟨x, h⟩ => h (Model.half x) rfl
inductive Model.Tone where | low | high deriving DecidableEq
def Model.pick (a b : Model.Tone) : Model.Tone := if a = b then a else b
def Model.relT : «际» Model.Tone := fun a b => b = Model.pick a a
theorem Model.relT_total : ¬ ∃ x, ∀ y, ¬ Model.relT x y := fun ⟨x, h⟩ => h (Model.pick x x) rfl
def Model.three : Fin 3 := ⟨2, by decide⟩
def Model.relF : «际» Nat := fun a b => b = a + Model.three.val
theorem Model.relF_total : ¬ ∃ x, ∀ y, ¬ Model.relF x y := fun ⟨x, h⟩ => h (x + Model.three.val) rfl
def Model.relR : «际» Nat := fun a b => a = b
theorem Model.pair_row : ¬ ∃ x, ¬ ((∃ y, Model.rel x y) ∧ Model.relR x x) := fun ⟨x, h⟩ => h ⟨⟨Model.next x, rfl⟩, rfl⟩
theorem Model.next.inj {a b : Nat} (e : Model.next a = Model.next b) : a = b := by unfold Model.next at e; omega
def Model.relI : «际» Nat := fun a b => Model.next a = Model.next b → a = b
theorem Model.relI_total : ¬ ∃ x, ∀ y, ¬ Model.relI x y := fun ⟨x, h⟩ => h x (fun _ => rfl)
theorem Model.comm (a b : Nat) : a + b = b + a := Nat.add_comm a b
theorem Model.comm.elim (a b : Nat) : a + b = b + a := by omega
theorem Model.elim.comm (a b : Nat) : a + b = b + a := by omega
def Model.relS : «际» Nat := fun a b => a + b = b + a
theorem Model.relS_total : ¬ ∃ x, ∀ y, ¬ Model.relS x y := fun ⟨x, h⟩ => h x (Nat.add_comm x x)
def Model.stepE : {f : Nat → Nat // ∀ x, Model.relS x (f x)} := ⟨Model.next, fun x => Model.comm.elim x (Model.next x)⟩
def Model.step_aux : {f : Nat → Nat // ∀ x, Model.rel x (f x)} := ⟨Model.next, fun x => id (Model.next_rel x)⟩
def Model.relL : «际» Nat := fun _ b => b < 3
theorem Model.relL_total : ¬ ∃ x, ∀ y, ¬ Model.relL x y := fun ⟨_, h⟩ => h 2 (Nat.lt_succ_self 2)
def Model.relU : «际» Nat := fun a b => b = if a < 2 then 0 else Model.half (a / 2) + 1
theorem Model.relU_total : ¬ ∃ x, ∀ y, ¬ Model.relU x y := fun ⟨_, h⟩ => h _ rfl
inductive Model.Reach : Nat → Nat → Prop
  | refl (n : Nat) : Model.Reach n n
  | step {a b : Nat} : Model.Reach a b → Model.Reach a (b + 1)
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
def onward_held : Total Model.rel := fun x => ⟨Model.next x, rfl⟩
theorem rel_total_through_held : ¬ ∃ x, ∀ y, ¬ Model.rel x y := total_form onward_held
theorem rel_total_through_held_certified : @Model.rel_total = @rel_total_through_held := rfl
theorem rel_total_through_data : ¬ ∃ x, ∀ y, ¬ Model.rel x y := total_form (fun x => ⟨Model.step.1 x, Model.step.2 x⟩)
theorem rel_total_through_data_certified : @Model.rel_total = @rel_total_through_data := rfl
theorem small_form {X : Type} {r : «际» X} {q : X → Nat} (small : SmallAll r q) : ¬ ∃ x, ∀ y, ¬ r x y :=
  fun ⟨x, h⟩ => match (small x).2 with | ⟨y, hy⟩ => h y hy
theorem rel_total_through_tactic : ¬ ∃ x, ∀ y, ¬ Model.rel x y :=
  total_form (fun x => ⟨Model.step_tactic.1 x, Model.step_tactic.2 x⟩)
theorem rel_total_through_tactic_certified : @Model.rel_total = @rel_total_through_tactic := rfl
theorem rel_total_through_rfl : ¬ ∃ x, ∀ y, ¬ Model.rel x y := total_form (fun x => ⟨Model.onward.f x, Model.onward.ok x⟩)
theorem rel_total_through_rfl_certified : @Model.rel_total = @rel_total_through_rfl := rfl
theorem relH_at_model : ¬ ∃ x, ∀ y, ¬ Model.relH x y := total_form (fun x => ⟨Model.half x, rfl⟩)
theorem relH_certified : @Model.relH_total = @relH_at_model := rfl
theorem relT_at_model : ¬ ∃ x, ∀ y, ¬ Model.relT x y := total_form (fun x => ⟨Model.pick x x, rfl⟩)
theorem relT_certified : @Model.relT_total = @relT_at_model := rfl
theorem relF_at_model : ¬ ∃ x, ∀ y, ¬ Model.relF x y := total_form (fun x => ⟨x + Model.three.val, rfl⟩)
theorem relF_certified : @Model.relF_total = @relF_at_model := rfl
def Refl {X : Type} (s : «际» X) : Prop := ∀ x, («同» X).1 x x → s x x
def allRel : «际» Unit := fun _ _ => True
theorem pair_form {X : Type} {r s : «际» X} (total : Total r) (refl : Refl s) : ¬ ∃ x, ¬ ((∃ y, r x y) ∧ s x x) :=
  fun ⟨x, h⟩ => h ⟨total x, refl x rfl⟩
theorem refl_all : Refl allRel := fun _ _ => trivial
theorem total_all : Total allRel := fun _ => ⟨(), trivial⟩
theorem pair_fails_total : ∃ x, ¬ ((∃ y, noneRel x y) ∧ allRel x x) := ⟨(), fun ⟨⟨_, f⟩, _⟩ => f⟩
theorem pair_fails_refl : ∃ x, ¬ ((∃ y, allRel x y) ∧ noneRel x x) := ⟨(), fun ⟨_, f⟩ => f⟩
theorem pair_form.needs_total : ¬ ∀ {X : Type} {r s : «际» X}, Refl s → ¬ ∃ x, ¬ ((∃ y, r x y) ∧ s x x) :=
  fun h => @h Unit noneRel allRel refl_all pair_fails_total
theorem pair_form.total_needed : ¬ Total noneRel := fun total => @pair_form Unit noneRel allRel total refl_all pair_fails_total
theorem pair_form.needs_refl : ¬ ∀ {X : Type} {r s : «际» X}, Total r → ¬ ∃ x, ¬ ((∃ y, r x y) ∧ s x x) :=
  fun h => @h Unit allRel noneRel total_all pair_fails_refl
theorem pair_form.refl_needed : ¬ Refl noneRel := fun refl => @pair_form Unit allRel noneRel total_all refl pair_fails_refl
theorem pair_at_model : ¬ ∃ x, ¬ ((∃ y, Model.rel x y) ∧ Model.relR x x) :=
  pair_form (fun x => ⟨Model.next x, rfl⟩) (fun _ _ => rfl)
theorem pair_certified : @Model.pair_row = @pair_at_model := rfl
theorem relI_through_inj : ¬ ∃ x, ∀ y, ¬ Model.relI x y := total_form (fun x => ⟨x, Model.next.inj⟩)
theorem relI_certified : @Model.relI_total = @relI_through_inj := rfl
theorem relS_through_elim : ¬ ∃ x, ∀ y, ¬ Model.relS x y := total_form (fun x => ⟨Model.stepE.1 x, Model.stepE.2 x⟩)
theorem relS_certified : @Model.relS_total = @relS_through_elim := rfl
theorem rel_total_through_aux : ¬ ∃ x, ∀ y, ¬ Model.rel x y := total_form (fun x => ⟨Model.step_aux.1 x, Model.step_aux.2 x⟩)
theorem rel_total_through_aux_certified : @Model.rel_total = @rel_total_through_aux := rfl
theorem rel_total_through_have : ¬ ∃ x, ∀ y, ¬ Model.rel x y :=
  total_form (fun x => have h := Model.next_rel x; ⟨Model.next x, h⟩)
theorem rel_total_through_have_certified : @Model.rel_total = @rel_total_through_have := rfl
theorem relL_through_proof : ¬ ∃ x, ∀ y, ¬ Model.relL x y := total_form (fun _ => ⟨2, Model.three._proof_1⟩)
theorem relL_certified : @Model.relL_total = @relL_through_proof := rfl
theorem relU_through_eq_def : ¬ ∃ x, ∀ y, ¬ Model.relU x y := total_form (fun x => ⟨Model.half x, Model.half.eq_def x⟩)
theorem relU_certified : @Model.relU_total = @relU_through_eq_def := rfl
end Becoming.Leaf
''',
    'Becoming/GrammarCourse.lean': '''import Becoming.Model
namespace Becoming
theorem GrammarCourse.built_on_model : ∀ x, ∃ y, Model.rel x y := Model.rel_onward
end Becoming
''',
    'Becoming/Edge.lean': '''import Becoming.Leaf
namespace Becoming
-- proofs Lean lifts out of a structure's default, a class's default and a constructor's optional argument
structure Edge.Cfg where
  k : Nat
  bound : Fin (k + 2) := ⟨k + 1, by omega⟩
def Edge.cfg : Edge.Cfg := { k := 1 }
def Edge.relC : «际» Nat := fun a b => b = a + Edge.cfg.bound.val
theorem Edge.relC_total : ¬ ∃ x, ∀ y, ¬ Edge.relC x y := fun ⟨x, h⟩ => h (x + Edge.cfg.bound.val) rfl
theorem Edge.relC_at : ¬ ∃ x, ∀ y, ¬ Edge.relC x y := Leaf.total_form (fun x => ⟨x + Edge.cfg.bound.val, rfl⟩)
theorem Edge.relC_certified : @Edge.relC_total = @Edge.relC_at := rfl
class Edge.Big (n : Nat) where
  witness : Fin (n + 1) := ⟨n, by omega⟩
instance Edge.big3 : Edge.Big 3 := {}
def Edge.relW : «际» Nat := fun a b => b = a + (Edge.Big.witness (n := 3)).val
theorem Edge.relW_total : ¬ ∃ x, ∀ y, ¬ Edge.relW x y := fun ⟨x, h⟩ => h (x + (Edge.Big.witness (n := 3)).val) rfl
theorem Edge.relW_at : ¬ ∃ x, ∀ y, ¬ Edge.relW x y := Leaf.total_form (fun x => ⟨x + (Edge.Big.witness (n := 3)).val, rfl⟩)
theorem Edge.relW_certified : @Edge.relW_total = @Edge.relW_at := rfl
inductive Edge.Foo where
  | mk (x : Fin 3 := ⟨2, by omega⟩)
def Edge.foo : Edge.Foo := Edge.Foo.mk
def Edge.Foo.val : Edge.Foo → Nat | .mk x => x.val
def Edge.relO : «际» Nat := fun a b => b = a + Edge.foo.val
theorem Edge.relO_total : ¬ ∃ x, ∀ y, ¬ Edge.relO x y := fun ⟨x, h⟩ => h (x + Edge.foo.val) rfl
theorem Edge.relO_at : ¬ ∃ x, ∀ y, ¬ Edge.relO x y := Leaf.total_form (fun x => ⟨x + Edge.foo.val, rfl⟩)
theorem Edge.relO_certified : @Edge.relO_total = @Edge.relO_at := rfl
-- the equation lemmas of a definition of two arguments by well-founded recursion, and of mutual ones
def Edge.ack : Nat → Nat → Nat
  | 0, n => n + 1
  | m + 1, 0 => Edge.ack m 1
  | m + 1, n + 1 => Edge.ack m (Edge.ack (m + 1) n)
termination_by m n => (m, n)
def Edge.relA : «际» Nat := fun a b => Edge.ack 0 a = b
theorem Edge.relA_total : ¬ ∃ x, ∀ y, ¬ Edge.relA x y := fun ⟨x, h⟩ => h (Edge.ack 0 x) rfl
theorem Edge.relA_eq : ¬ ∃ x, ∀ y, ¬ Edge.relA x y := Leaf.total_form (fun x => ⟨x + 1, Edge.ack.eq_1 x⟩)
theorem Edge.relA_certified : @Edge.relA_total = @Edge.relA_eq := rfl
mutual
def Edge.evW : Nat → Bool
  | 0 => true
  | n + 1 => Edge.odW n
termination_by n => n
def Edge.odW : Nat → Bool
  | 0 => false
  | n + 1 => Edge.evW n
termination_by n => n
end
def Edge.relE : «际» Nat := fun _ b => Edge.evW b = true
theorem Edge.relE_total : ¬ ∃ x, ∀ y, ¬ Edge.relE x y := fun ⟨_, h⟩ => h 0 Edge.evW.eq_1
theorem Edge.relE_eq : ¬ ∃ x, ∀ y, ¬ Edge.relE x y := Leaf.total_form (fun _ => ⟨0, Edge.evW.eq_1⟩)
theorem Edge.relE_certified : @Edge.relE_total = @Edge.relE_eq := rfl
-- a declaration with a hygienic name
macro "edge_bound" n:ident : command => `(def aux : Fin 6 := ⟨5, by decide⟩
  def $n : Nat := aux.val)
edge_bound Edge.hb
def Edge.relB : «际» Nat := fun a b => b = a + Edge.hb
theorem Edge.relB_total : ¬ ∃ x, ∀ y, ¬ Edge.relB x y := fun ⟨x, h⟩ => h (x + Edge.hb) rfl
theorem Edge.relB_at : ¬ ∃ x, ∀ y, ¬ Edge.relB x y := Leaf.total_form (fun x => ⟨x + Edge.hb, rfl⟩)
theorem Edge.relB_certified : @Edge.relB_total = @Edge.relB_at := rfl
-- names Lean never gives an opaque, a Prop inductive's brecOn, a structure or an inductive, written by hand
opaque Edge.op : Nat
theorem Edge.op.eq_1 (a b : Nat) : a + b = b + a := by omega
theorem Edge.op.eq_def (a b : Nat) : a + b = b + a := by omega
inductive Edge.Rp : Nat → Prop
  | z : Edge.Rp 0
  | s {n : Nat} : Edge.Rp n → Edge.Rp (n + 1)
theorem Edge.Rp.brecOn.eq (a b : Nat) : a + b = b + a := by omega
theorem Edge.Rp.brecOn.go (a b : Nat) : a + b = b + a := by omega
theorem Edge.Cfg.elim (a b : Nat) : a + b = b + a := by omega
theorem Edge.Foo.inj (a b : Nat) : a + b = b + a := by omega
theorem Edge.relS_eq1 : ¬ ∃ x, ∀ y, ¬ Model.relS x y := Leaf.total_form (fun x => ⟨0, Edge.op.eq_1 x 0⟩)
theorem Edge.relS_eq1_certified : @Model.relS_total = @Edge.relS_eq1 := rfl
theorem Edge.relS_go : ¬ ∃ x, ∀ y, ¬ Model.relS x y := Leaf.total_form (fun x => ⟨0, Edge.Rp.brecOn.go x 0⟩)
theorem Edge.relS_go_certified : @Model.relS_total = @Edge.relS_go := rfl
def Edge.stepO : {f : Nat → Nat // ∀ x, Model.relS x (f x)} := ⟨fun x => x + 1, fun x => Edge.op.eq_1 x (x + 1)⟩
theorem Edge.relS_data : ¬ ∃ x, ∀ y, ¬ Model.relS x y := Leaf.total_form (fun x => ⟨Edge.stepO.1 x, Edge.stepO.2 x⟩)
theorem Edge.relS_data_certified : @Model.relS_total = @Edge.relS_data := rfl
-- its own statement (x + 2): Lean reuses a lifted proof of the same statement, stepO's
def Edge.stepC : {f : Nat → Nat // ∀ x, Model.relS x (f x)} := ⟨fun x => x + 2, fun x => Edge.Cfg.elim x (x + 2)⟩
theorem Edge.relS_elim : ¬ ∃ x, ∀ y, ¬ Model.relS x y := Leaf.total_form (fun x => ⟨Edge.stepC.1 x, Edge.stepC.2 x⟩)
theorem Edge.relS_elim_certified : @Model.relS_total = @Edge.relS_elim := rfl
-- an opaque with the proof Lean lifts out of it, a partial definition, and a recursive inductive of a type
opaque Edge.seven : Fin 8 := ⟨7, by decide⟩
partial def Edge.loop (n : Nat) : Nat := if n = 0 then 0 else Edge.loop (n - 1)
inductive Edge.Tree where
  | leaf
  | node (l r : Edge.Tree)
def Edge.Tree.size : Edge.Tree → Nat
  | .leaf => 1
  | .node l r => l.size + r.size
-- an equation lemma of Init's definition, which Lean realizes here
theorem Edge.init_row (r : «际» Nat) : r = r ∧ Nat.fold 0 (fun i _ a => a + i) 0 = 0 :=
  ⟨«际之自» r, by unfold Nat.fold; rfl⟩
-- a nested inductive type, with the auxiliaries Lean adds for it (`_sizeOf_2_eq`, `below_1`, `brecOn_1` and its parts,
-- `rec_1`), and a definition over it by well-founded recursion, whose equation lemma reaches `_sizeOf_2_eq`
inductive Edge.Nest where
  | node : List Edge.Nest → Edge.Nest
def Edge.Nest.count : Edge.Nest → Nat
  | .node ts => 1 + (ts.attach.map (fun ⟨t, _⟩ => Edge.Nest.count t)).sum
termination_by t => sizeOf t
def Edge.relN : «际» Nat := fun _ b => (Edge.Nest.node []).count = b
theorem Edge.relN_total : ¬ ∃ x, ∀ y, ¬ Edge.relN x y := fun ⟨_, h⟩ => h _ rfl
theorem Edge.relN_eq : ¬ ∃ x, ∀ y, ¬ Edge.relN x y := Leaf.total_form (fun _ => ⟨_, Edge.Nest.count.eq_1 []⟩)
theorem Edge.relN_certified : @Edge.relN_total = @Edge.relN_eq := rfl
theorem Edge.nest_row (r : «际» Nat) : r = r ∧ (Edge.Nest.node []).count = 1 :=
  ⟨«际之自» r, by rw [Edge.Nest.count.eq_1]; rfl⟩
-- a declaration a macro makes by well-founded recursion: Lean names its equation lemmas after the macro scopes
-- (`halve.«_@».M._hyg.3.eq_def`, under `halve._@.M._hyg.3`); a row through one (a recovery through one needs a tactic,
-- since the macro cannot name the lemma, and the tactic's `congrArg` is a fact)
macro "edge_halve" row:ident : command => `(def halve (n : Nat) : Nat := if n < 2 then 0 else halve (n / 2) + 1
  termination_by n
  decreasing_by omega
  theorem $row (r : «际» Nat) : r = r ∧ halve 1 = 0 := ⟨«际之自» r, by unfold halve; rfl⟩)
edge_halve Edge.mac_row
-- what Lean realizes on use: a definition's functional induction and cases, its unfolding lemma
theorem Edge.realized : True := by
  have := @Model.half.induct; have := @Model.half.induct_unfolding; have := @Model.half.fun_cases
  have := @Model.half.fun_cases_unfolding; have := @Model.half.eq_unfold; have := @Edge.evW.mutual_induct
  have := @Edge.evW.mutual_induct_unfolding; have := @Edge.Tree.size.fun_cases; trivial
end Becoming
''',
}
M, E = 'Becoming.Model.', 'Becoming.Edge.'
GENERATED = [M + n for n in (  # each under a declaration of the kind Lean generates it for, in the stubs
    'half._proof_1', 'half._unsafe_rec', 'half._sunfold', 'half.eq_def', 'half.eq_1', 'comm.elim._proof_1_1', 'three._proof_1',
    'instDecidableEqTone._proof_2', 'rel_total.match_1_1', 'rel_total.match_1_1.eq_1', 'rel_total.match_1_1.splitter',
    'rel_total.match_1_1.congr_eq_1',
    'next.proof_2', 'next._aux_3', 'Onward.f._default', 'Onward._sizeOf_1', 'Onward._sizeOf_inst', 'Onward.casesOn',
    'Onward.ctorIdx', 'Onward.noConfusion', 'Onward.noConfusionType', 'Onward.rec', 'Onward.recOn', 'Onward.mk._flat_ctor',
    'Onward.mk.inj', 'Onward.mk.injEq', 'Onward.mk.noConfusion', 'Onward.mk.sizeOf_spec', 'Tone.ctorElim', 'Tone.ctorElimType',
    'Tone.toCtorIdx', 'Tone.ofNat_ctorIdx', 'Tone.high.elim', 'Reach.below', 'Reach.below.refl', 'half.induct',
    'half.induct_unfolding', 'half.fun_cases', 'half.fun_cases_unfolding', 'half.eq_unfold')] + [E + n for n in (
    'Cfg._proof_1', 'Big._proof_1', 'Foo._proof_1', 'Cfg.bound._default', 'ack.eq_1', 'ack._unary._proof_1', 'ack._unary.eq_def',
    'evW._mutual.eq_def', 'seven._proof_1', 'loop._unsafe_rec', 'Tree.below', 'Tree.brecOn', 'Tree.brecOn.go', 'Tree.brecOn.eq',
    'Tree.leaf.elim', 'Tree.size._sunfold', 'Tree.size.fun_cases', 'evW.mutual_induct', 'evW.mutual_induct_unfolding',
    'Nest._sizeOf_2', 'Nest._sizeOf_2_eq', 'Nest.below_1', 'Nest.brecOn_1', 'Nest.brecOn_1.go', 'Nest.brecOn_1.eq', 'Nest.rec_1')] + [
    '_private.Becoming.Leaf.0.Becoming.Model.rel_total.match_1_1.eq_1',  # read by its user name
    '_private.Becoming.Edge.0.Becoming.Edge.ack.match_1._arg_pusher', '_private.Becoming.Edge.0.PSigma.casesOn._arg_pusher',
    'Nat.fold.eq_def']  # of a declaration of Init, realized in a package module
# not generated: written by hand under a name Lean also uses, under a declaration of another kind, under none, a part no
# generated declaration has, and near misses of each pattern
NOT_GENERATED = [M + n for n in (
    'next.inj', 'comm.elim', 'elim.comm', 'next.casesOn', 'Tone.eq_def', 'Tone.low.rec', 'next_rel._sunfold', 'Reach.below.other',
    'Reach.brecOn.go', 'Reach.brecOn.eq', 'rel_total.match_1_1.eq_1.mine', 'next.match_1.eq_1', 'next.match_', 'next.match_1_',
    'next.match_1__2', 'next.match_a', 'next.proof_', 'next._proof_', 'next.proof_1a', 'next.eq_x', 'next.ofNat', 'next.recursion',
    'next.elim_of', 'next.injective', 'next.below_one', 'Tone.low._proof_1', 'Tone.low.match_1', 'Tone.match_1', 'Tone.low.eq_1',
    'next.noConfusion', 'Onward.noConfusion2', 'next._aux_x', 'Onward._sizeOf_x', 'Onward._sizeOf_', 'Onward.mk.brecOn',
    'comm._unsafe_rec', 'Tone._unsafe_rec', 'Tone.low._unsafe_rec', 'comm._arg_pusher', 'comm.fun_cases', 'Tone.induct',
    'half.below_1', 'half.brecOn_1', 'half.rec_1', 'Onward.mk.rec_1', 'half._sizeOf_2_eq', 'half.induct_', 'half.congr_eq_',
    'Reach.brecOn_1.go', 'comm.congr_eq_1', 'Tone.congr_eq_1', 'Tone.mutual_induct', 'comm.mutual_induct_unfolding',
    'Tone.induct_unfolding', 'comm.fun_cases_unfolding', 'comm.splitter', 'Tone._aux_1', 'comm._default', 'next.injEq',
    'Tone.sizeOf_spec', 'Tone._flat_ctor', 'next._sizeOf_inst', 'Onward.mk.binductionOn', 'comm.recOn',
    'Tone.low.noConfusionType', 'next.ctorIdx', 'Tone.low.toCtorIdx', 'comm.ofNat_ctorIdx', 'next.ctorElim',
    'Onward.mk.ctorElimType')] + [E + n for n in (
    'op.eq_1', 'op.eq_def', 'Rp.brecOn.go', 'Rp.brecOn.eq', 'Cfg.elim', 'Foo.inj', 'seven.eq_1', 'loop.eq_1', 'loop._sunfold',
    'seven._arg_pusher', 'seven.induct', 'op.eq_unfold', 'Nest._sizeOf_2_eqx', 'Nest.brecOn_1.other', 'Nest.below_1a')] + [
    'match_1', '_private.Becoming.Leaf.0.Becoming.Model.next.inj']
SPINE = registry.ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


class TheLeanCheck(unittest.TestCase):
    """boundary_check.lean on stub modules: a form passing every test; recoveries through a model fact, a fact held in
    a definition, one a model's data carries, one through a tactic's proof, one through a theorem written by hand under a
    name Lean also uses (directly or carried by data, on a definition, a theorem, an opaque, a Prop inductive's brecOn or
    a structure), one inside the proof Lean lifts out of data, one through a have, and another declaration's lifted proof
    named itself, which fail; recoveries through the proofs Lean generates (an rfl in a model's data, a termination
    proof, a derived DecidableEq, a decide, an equation lemma, a structure's, a class's and a constructor's default, the
    equation lemmas of definitions by well-founded recursion of two arguments and of mutual ones, a macro's declaration),
    which pass; a form with two hypotheses whose definitions hold proofs only in types; a hypothesis with an amount
    behind a prelude definition; an absent certificate; the name test (by module and by content); the equivalence test
    (an Iff, an Eq of propositions, an Eq at a type of values); and the check's copy of §3.0's rule, held to boundary.py's
    on the constants THEOREM-CONNECTIVITY-DUMP.lean writes of the stubs, with D2 through Init's equation lemma. Skipped
    without the installed toolchain, which the test runs directly, so that nothing is downloaded."""
    @classmethod
    def setUpClass(cls):
        toolchain = (SPINE / 'lean-toolchain').read_text().strip() if (SPINE / 'lean-toolchain').is_file() else ''
        binary = Path.home() / '.elan/toolchains' / toolchain.replace('/', '--').replace(':', '---') / 'bin/lean'
        cls.lean = [str(binary)]
        if not toolchain or not binary.is_file() or subprocess.run(cls.lean + ['--version'], capture_output=True).returncode != 0:
            raise unittest.SkipTest('the Lean toolchain is not installed')
        cls.dir = tempfile.mkdtemp(prefix='boundary-stubs-')
        work = Path(cls.dir)
        for path, text in STUBS.items():
            (work / path).parent.mkdir(parents=True, exist_ok=True)
            (work / path).write_text(text)
            p = subprocess.run(cls.lean + [f'--root={work}', '-o', str(work / path.replace('.lean', '.olean')), path], cwd=work,
                               env={**os.environ, 'LEAN_PATH': str(work)}, capture_output=True, text=True)
            if p.returncode != 0:
                raise AssertionError(p.stdout + p.stderr)
        # THEOREM-CONNECTIVITY-DUMP.lean on the stubs, its imports replaced: the constants as the generator reads them
        dump = re.sub(r'\A(import .*\n)+', 'import Lean\n' + ''.join(f'import Becoming.{m}\n' for m in ('Leaf', 'GrammarCourse', 'Edge')),
                      boundary.TC.with_name('THEOREM-CONNECTIVITY-DUMP.lean').read_text())
        (work / 'Dump.lean').write_text(dump)
        p = subprocess.run(cls.lean + ['Dump.lean'], cwd=work, capture_output=True, text=True,
                           env={**os.environ, 'LEAN_PATH': str(work), 'THEOREM_CONNECTIVITY_OUT': str(work / 'dump.jsonl')})
        if p.returncode != 0:
            raise AssertionError(p.stdout + p.stderr)
        cls.C = {x['n']: x for x in map(json.loads, (work / 'dump.jsonl').read_text().splitlines())}
        # its theorems with macro scopes before the last component, which the check reads listed
        cls.scoped = sorted(n for n in cls.C if '«_@»' in boundary.components(n) and cls.C[n]['k'] == 'thm')
        L = 'Becoming.Leaf.'
        def entry(form, hyp, recovery, certificate, row='Becoming.Model.rel_total'):
            return {'row': row, 'form': L + form, 'recovery': L + recovery, 'certificate': L + certificate,
                    'hypotheses': [{'hypothesis': L + hyp, 'countermodel': L + 'total_form.needs_total', 'fit': L + 'total_form.total_needed'}]}
        pair = {'row': 'Becoming.Model.pair_row', 'form': L + 'pair_form', 'recovery': L + 'pair_at_model', 'certificate': L + 'pair_certified',
                'hypotheses': [{'hypothesis': L + h, 'countermodel': L + f'pair_form.needs_{n}', 'fit': L + f'pair_form.{n}_needed'}
                               for h, n in (('Total', 'total'), ('Refl', 'refl'))]}
        def edge(rel, recovery, row=None):  # the row rel_total, recovered by recovery, certified by rel_certified
            return {**entry('total_form', 'Total', 'x', 'x', row or f'Becoming.Edge.{rel}_total'),
                    'recovery': f'Becoming.Edge.{recovery}', 'certificate': f'Becoming.Edge.{rel}_certified'}
        cls.out = boundary.run_check(work, ['Becoming.Leaf', 'Becoming.GrammarCourse', 'Becoming.Edge'], {
            'entries': [entry('total_form', 'Total', 'rel_total_at_model', 'rel_total_certified'),
                        entry('total_form', 'Total', 'rel_total_through_fact', 'rel_total_through_fact_certified'),
                        entry('small_form', 'SmallAll', 'rel_total_at_model', 'rel_total_certified'),
                        entry('total_form', 'Total', 'rel_total_at_model', 'absent_certificate'),
                        entry('total_form', 'Total', 'rel_total_through_held', 'rel_total_through_held_certified'),
                        entry('total_form', 'Total', 'rel_total_through_data', 'rel_total_through_data_certified'),
                        entry('total_form', 'Total', 'rel_total_through_tactic', 'rel_total_through_tactic_certified'),
                        entry('total_form', 'Total', 'rel_total_through_rfl', 'rel_total_through_rfl_certified'),
                        entry('total_form', 'Total', 'relH_at_model', 'relH_certified', 'Becoming.Model.relH_total'),
                        entry('total_form', 'Total', 'relT_at_model', 'relT_certified', 'Becoming.Model.relT_total'),
                        entry('total_form', 'Total', 'relF_at_model', 'relF_certified', 'Becoming.Model.relF_total'),
                        pair,
                        entry('total_form', 'Total', 'relI_through_inj', 'relI_certified', 'Becoming.Model.relI_total'),
                        entry('total_form', 'Total', 'relS_through_elim', 'relS_certified', 'Becoming.Model.relS_total'),
                        entry('total_form', 'Total', 'rel_total_through_aux', 'rel_total_through_aux_certified'),
                        entry('total_form', 'Total', 'rel_total_through_have', 'rel_total_through_have_certified'),
                        entry('total_form', 'Total', 'relL_through_proof', 'relL_certified', 'Becoming.Model.relL_total'),
                        entry('total_form', 'Total', 'relU_through_eq_def', 'relU_certified', 'Becoming.Model.relU_total'),
                        edge('relC', 'relC_at'), edge('relW', 'relW_at'), edge('relO', 'relO_at'), edge('relA', 'relA_eq'),
                        edge('relE', 'relE_eq'), edge('relB', 'relB_at'),
                        *(edge(r, r, 'Becoming.Model.relS_total') for r in ('relS_eq1', 'relS_go', 'relS_data', 'relS_elim')),
                        edge('relN', 'relN_eq')],
            'names': ['Becoming.«际之自»', 'Becoming.Model.rel_total', 'Becoming.Small', 'Becoming.Absent',
                      'Becoming.GrammarCourse.built_on_model'],
            'equivalences': ['Becoming.Model.and_swap', 'Becoming.Model.size_zero', 'Becoming.Model.rel_total',
                             'Becoming.Model.eq_props', 'Becoming.Model.eq_predicates'],
            'generated': GENERATED + NOT_GENERATED + cls.scoped}, cls.lean, 600)

    @classmethod
    def tearDownClass(cls):
        shutil.rmtree(cls.dir, ignore_errors=True)

    def test_a_form_passing_every_test(self):
        self.assertEqual((self.out['entries'][0]['passed'], self.out['entries'][0]['failures']), (True, []))
        self.assertEqual(self.out['entries'][0]['recovery_uses'], ['Becoming.Leaf.total_form'])

    def test_the_failures(self):
        self.assertIn('the discharge condition fails: the recovery uses [Becoming.Model.rel_onward]', self.out['entries'][1]['failures'])
        self.assertIn('the hypothesis Becoming.Leaf.SmallAll names amounts: [Nat, LE.le]', self.out['entries'][2]['failures'])
        self.assertEqual((self.out['entries'][3]['passed'], self.out['entries'][3]['failures']),
                         (False, ['not in the environment: [Becoming.Leaf.absent_certificate]']))
        self.assertEqual(self.out['entries'][4]['failures'],  # a fact held in a definition is a proof the recovery uses
                         ['the discharge condition fails: the recovery uses [Becoming.Leaf.onward_held]'])
        self.assertEqual(self.out['entries'][5]['failures'],  # and so is one a model's data carries
                         ['the discharge condition fails: the recovery uses [Becoming.Model.next_rel]'])
        self.assertEqual(self.out['entries'][6]['failures'],  # through a tactic's proof, inline in the data
                         ['the discharge condition fails: the recovery uses [Becoming.Model.next_rel]'])
        for i, used in ((12, 'Becoming.Model.next.inj'),  # a theorem written by hand as next.inj, on a definition
                        (13, 'Becoming.Model.comm.elim'),  # one written as comm.elim, on a theorem, carried by data
                        (14, 'Becoming.Model.next_rel'),  # inside the proof Lean lifts out of data, _proof_1
                        (15, 'Becoming.Model.next_rel'),  # through a have
                        (16, 'Becoming.Model.three._proof_1')):  # another declaration's lifted proof, named itself
            self.assertEqual((self.out['entries'][i]['passed'], self.out['entries'][i]['failures']),
                             (False, [f'the discharge condition fails: the recovery uses [{used}]']), i)

    def test_generated_proofs_are_walked_through(self):
        # rfl in a model's data, a termination proof, a derived DecidableEq and a decide: Lean makes each a package
        # theorem `_proof_N` (or `ofNat_ctorIdx`), walked through, so none is a proof the recovery uses
        # and an equation lemma named itself is walked through too
        for i, row, projected in zip((7, 8, 9, 10, 17), ('rel_total', 'relH_total', 'relT_total', 'relF_total', 'relU_total'),
                                     (['Becoming.Model.Onward.ok'], [], [], [], [])):
            x = self.out['entries'][i]
            self.assertEqual((x['row'], x['passed'], x['failures']), ('Becoming.Model.' + row, True, []))
            self.assertEqual(x['recovery_uses'], ['Becoming.Leaf.total_form', *projected])

    def test_lifted_proofs_equation_lemmas_and_hygienic_names(self):
        # proofs Lean lifts out of a structure's default, a class's default and a constructor's optional argument (each
        # under the inductive), the equation lemmas of a definition of two arguments by well-founded recursion and of
        # mutual ones (through `_arg_pusher`), and a proof lifted out of a declaration a macro makes: walked through
        for i, row in zip(range(18, 24), ('relC', 'relW', 'relO', 'relA', 'relE', 'relB')):
            x = self.out['entries'][i]
            self.assertEqual((x['row'], x['passed'], x['failures']), (f'Becoming.Edge.{row}_total', True, []), i)
            self.assertEqual(x['recovery_uses'], ['Becoming.Leaf.total_form'], i)
        # theorems written by hand under names Lean gives no opaque, no Prop inductive's brecOn and no structure: facts
        for i, used in ((24, 'Becoming.Edge.op.eq_1'), (25, 'Becoming.Edge.Rp.brecOn.go'), (26, 'Becoming.Edge.op.eq_1'),
                        (27, 'Becoming.Edge.Cfg.elim')):
            self.assertEqual((self.out['entries'][i]['passed'], self.out['entries'][i]['failures']),
                             (False, [f'the discharge condition fails: the recovery uses [{used}]']), i)
        # a recovery through the equation lemma of a definition over a nested type, which reaches `_sizeOf_2_eq`:
        # walked through
        x = self.out['entries'][28]
        self.assertEqual((x['row'], x['passed'], x['failures']), ('Becoming.Edge.relN_total', True, []))
        self.assertEqual(x['recovery_uses'], ['Becoming.Leaf.total_form'])

    def test_types_are_not_walked(self):
        # a proof inside a definition named only in a type (a hypothesis, F's conclusion, a binder's type) is no fact
        x = self.out['entries'][11]
        self.assertEqual((x['passed'], x['failures']), (True, []))
        self.assertEqual(x['facts'], {'Becoming.Leaf.pair_form.total_needed': ['Becoming.Leaf.refl_all', 'Becoming.Leaf.pair_fails_total'],
                                      'Becoming.Leaf.pair_form.refl_needed': ['Becoming.Leaf.total_all', 'Becoming.Leaf.pair_fails_refl']})
        self.assertEqual(x['recovery_uses'], ['Becoming.Leaf.pair_form'])

    def test_the_pattern_of_generated_auxiliaries(self):
        # boundary.py's AUX on the dump's kinds, with the check's kinds of the names the dump lacks, is this file's copy
        self.assertEqual({n: k for n, k in self.out['kinds'].items() if n in self.C}, {n: self.C[n]['k'] for n in self.out['kinds'] if n in self.C})
        self.assertEqual(self.C[E + 'seven']['k'], 'opaque')
        terms = boundary.Terms(self.C, []).supplied(self.out['kinds'])
        self.assertEqual(self.out['generated'], {n: terms.aux(n) for n in GENERATED + NOT_GENERATED + self.scoped})
        self.assertTrue(self.scoped)  # the dump's theorems with macro scopes before the last component, listed
        self.assertEqual({n for n, g in self.out['generated'].items() if not g}, set(NOT_GENERATED))
        hygienic = [n for n in self.C if ('._@.' in n or '«_@»' in boundary.components(n)) and self.C[n]['k'] == 'thm']
        self.assertTrue(any('«_@»' in boundary.components(n) for n in hygienic))  # the scopes before the last component
        self.assertTrue(hygienic and all(terms.aux(n) for n in hygienic), hygienic)  # a macro's lifted proof and lemmas
        # the theorems whose kind before them the dump lacks, and D2 on the dump: through Init's equation lemma
        self.assertEqual(boundary.outside(self.C), {'Nat.fold.eq_def', '_private.Becoming.Edge.0.PSigma.casesOn._arg_pusher',
                                                    '_private.Becoming.Edge.0.PSum.casesOn._arg_pusher'})
        row = (E + 'init_row', {'law': ['Becoming.«际之自»']}, set())
        self.assertEqual(boundary.derived(terms, *row)[0], [])
        self.assertEqual(boundary.derived(boundary.Terms(self.C, []), *row)[0],
                         ['D2: the proofs name theorems that are neither grammar laws, root theorems nor declared lemmas: Nat.fold.eq_def'])
        # through a macro's equation lemma (its scopes before the last component), and one reaching a nested type's
        # `_sizeOf_2_eq`
        for name in ('mac_row', 'nest_row'):
            self.assertEqual(boundary.derived(terms, E + name, {'law': ['Becoming.«际之自»']}, set())[0], [], name)

    def test_the_name_and_equivalence_tests(self):
        # a grammar module's theorem built on a model is refused by its content
        self.assertEqual(self.out['admitted'], {'Becoming.«际之自»': True, 'Becoming.Model.rel_total': False, 'Becoming.Small': True,
                                                'Becoming.Absent': False, 'Becoming.GrammarCourse.built_on_model': False})
        self.assertEqual(self.out['equivalence'], {'Becoming.Model.and_swap': True, 'Becoming.Model.size_zero': False,
                                                   'Becoming.Model.rel_total': False, 'Becoming.Model.eq_props': True,
                                                   'Becoming.Model.eq_predicates': True})


class TheRepositoryFile(unittest.TestCase):
    def test_the_boundary_report_when_present(self):
        data = registry.shared_laws()
        if not data or 'boundary' not in data:
            self.skipTest('no record carries the boundary field')
        b = data['boundary']
        if 'error' in b:
            self.assertGreater(len(b['records']), 1)
            return
        self.assertEqual(sum(b['counts'].values()), len(b['rows']))
        self.assertEqual(sum(b['groups'].values()), len(b['rows']))
        self.assertEqual(set(b['counts']), set(boundary.LABELS))
        self.assertEqual(set(data['counts_at_boundary_record']), set(data['counts']))

    def test_the_premises_are_said_as_the_hypotheses_ranking_results_take(self):
        # 9 November 2026 (AG seventh pass): C is a requirement on an order, not a second premise of the ethics; widening
        # is what additive weightings counting each listed item above zero rank higher; the ranking reaches courses whose
        # admissions end; that a life forms a self-concerned order is not shown
        carriers = [r for r in registry.load_records()[0] if isinstance(r.get('boundary'), dict)]
        if not carriers:
            self.skipTest('no record carries the boundary field')
        for r in carriers:
            premises = r['boundary']['premises_of_the_ethics']
            said = json.dumps(premises, ensure_ascii=False)
            for old in ('no second premise', 'courses that end', 'every positive weighting', 'argued, not shown',
                        'fixes scope', 'an order ranking each course'):
                self.assertNotIn(old, said, (r['id'], old))
            order = next(p for p in premises if p.get('role') == 'order')
            self.assertIn('requirement', order['name']['en'])
            self.assertIn('self-concern', order['name']['en'])
            self.assertIn('additive', order['basis']['en'])


if __name__ == '__main__':
    unittest.main()
