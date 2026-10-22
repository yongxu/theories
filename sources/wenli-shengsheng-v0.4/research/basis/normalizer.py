#!/usr/bin/env python3
"""G1 -> G0 relative expressive sufficiency; no claim of irreducible minimality.

The old evaluator is imported read-only. Run normally to write results.json;
--check recomputes all checks and requires an exact saved-result match.
"""
from __future__ import annotations

import argparse
import copy
import hashlib
import importlib.util
import json
import random
from pathlib import Path

HERE = Path(__file__).resolve().parent
PORTABLE_ENGINE = HERE.parent / 'core/wenli.py'
if PORTABLE_ENGINE.is_file():
    ENGINE = PORTABLE_ENGINE
else:
    ROOT = next(p for p in HERE.parents if (p / 'outputs/10_组合文法参考实现_v0.3/wenli.py').exists())
    ENGINE = ROOT / 'outputs/10_组合文法参考实现_v0.3/wenli.py'
spec = importlib.util.spec_from_file_location('wenli_v03_basis', ENGINE)
wenli = importlib.util.module_from_spec(spec)
spec.loader.exec_module(wenli)
Model, GrammarError = wenli.Model, wenli.GrammarError

FORMULA_BASIS = {'true', 'atom', 'eq', 'not', 'and', 'exists', 'diamond'}
PROGRAM_BASIS = {'atomic', 'test', 'seq', 'choice', 'sync', 'star'}


class NormalizationLimit(ValueError):
    """An explicit implementation resource limit, not non-expressibility."""


def node(op, **fields):
    return {'op': op, **fields}


def atom(name, *args):
    return node('atom', name=name, args=list(args))


def const(name):
    return {'const': name}


def var(name):
    return {'var': name}


def atomic(name='a'):
    return node('atomic', name=name)


def walk(value):
    if isinstance(value, dict):
        if 'op' in value:
            yield value
        for item in value.values():
            yield from walk(item)
    elif isinstance(value, list):
        for item in value:
            yield from walk(item)


def size(expression):
    return sum(1 for _ in walk(expression))


def term_count(value):
    if isinstance(value, dict):
        return int(set(value) in ({'const'}, {'var'})) + sum(term_count(v) for v in value.values())
    if isinstance(value, list):
        return sum(term_count(v) for v in value)
    return 0


class Normalizer:
    """Validate G1, inline closed DAG definitions, alpha-rename, then erase sugar.

    Results are ordinary G1 JSON using only G0 constructors. All quantifier
    binders get globally fresh names. A definition starts a fresh lexical
    environment, matching G1's closed-reference semantics.
    """

    def __init__(self, model_data, max_nodes=100_000):
        if type(max_nodes) is not int or max_nodes < 1:
            raise ValueError('max_nodes must be a positive integer')
        try:
            self.model = Model(model_data)
        except RecursionError as exc:
            raise NormalizationLimit('model or definition nesting exceeds the Python stack limit') from exc
        self.max_nodes = max_nodes
        self.allocations = 0
        self.next_variable = 0

    def _node(self, op, **fields):
        self.allocations += 1
        if self.allocations > self.max_nodes:
            raise NormalizationLimit('expanded tree exceeds the configured construction budget')
        return node(op, **fields)

    def _fresh(self):
        name = f'__g0v{self.next_variable}'
        self.next_variable += 1
        return name

    def _term(self, term, env):
        return const(term['const']) if 'const' in term else var(env[term['var']])

    def _fold(self, op, args, empty=None):
        if not args:
            return empty()
        # All four target binary operators are associative. A balanced tree
        # avoids an artificial linear Python stack depth, preserving seq order.
        def balanced(left, right):
            if right - left == 1:
                return args[left]
            middle = (left + right) // 2
            return self._node(op, args=[balanced(left, middle), balanced(middle, right)])
        return balanced(0, len(args))

    def _true(self):
        return self._node('true')

    def _false(self):
        return self._node('not', arg=self._true())

    def _skip(self):
        return self._node('test', condition=self._true())

    def _empty_relation(self):
        return self._node('test', condition=self._false())

    def _f(self, f, env):
        op = f['op']
        if op == 'true':
            return self._true()
        if op == 'false':
            return self._false()
        if op == 'atom':
            return self._node('atom', name=f['name'], args=[self._term(t, env) for t in f['args']])
        if op == 'eq':
            return self._node('eq', left=self._term(f['left'], env), right=self._term(f['right'], env))
        if op == 'not':
            return self._node('not', arg=self._f(f['arg'], env))
        if op == 'and':
            return self._fold('and', [self._f(x, env) for x in f['args']], self._true)
        if op == 'or':
            # De Morgan handles zero operands as NOT TRUE, without a domain assumption.
            terms = [self._node('not', arg=self._f(x, env)) for x in f['args']]
            return self._node('not', arg=self._fold('and', terms, self._true))
        if op == 'implies':
            return self._node('not', arg=self._node('and', args=[
                self._f(f['left'], env), self._node('not', arg=self._f(f['right'], env))]))
        if op in {'exists', 'forall'}:
            fresh = self._fresh()
            body = self._f(f['body'], {**env, f['var']: fresh})
            if op == 'forall':
                body = self._node('not', arg=body)
            result = self._node('exists', var=fresh, sort=f['sort'], body=body)
            return self._node('not', arg=result) if op == 'forall' else result
        if op in {'diamond', 'box'}:
            program, body = self._p(f['program'], env), self._f(f['body'], env)
            if op == 'box':
                body = self._node('not', arg=body)
            result = self._node('diamond', program=program, body=body)
            return self._node('not', arg=result) if op == 'box' else result
        if op == 'fref':
            return self._f(self.model.formula_defs[f['name']], {})
        raise AssertionError('unreachable after G1 validation')

    def _p(self, p, env):
        op = p['op']
        if op == 'atomic':
            return self._node('atomic', name=p['name'])
        if op == 'skip':
            return self._skip()
        if op == 'test':
            return self._node('test', condition=self._f(p['condition'], env))
        if op in {'seq', 'choice', 'sync'}:
            args = [self._p(x, env) for x in p['args']]
            empty = self._skip if op == 'seq' else self._empty_relation
            return self._fold(op, args, empty)
        if op == 'star':
            return self._node('star', body=self._p(p['body'], env))
        if op == 'repeat':
            if p['count'] > self.max_nodes:
                raise NormalizationLimit('repeat count alone exceeds the expanded-tree budget')
            return self._fold('seq', [self._p(p['body'], env) for _ in range(p['count'])], self._skip)
        if op == 'pref':
            return self._p(self.model.program_defs[p['name']], {})
        raise AssertionError('unreachable after G1 validation')

    def _convert(self, expression, kind):
        checker = self.model.check_formula if kind == 'formula' else self.model.check_program
        try:
            checker(expression)  # Also rejects invalid dead branches and bad zero-repeat bodies.
            self.allocations, self.next_variable = 0, 0
            result = (self._f if kind == 'formula' else self._p)(expression, {})
            checker(result)
            for sub in walk(result):
                if sub['op'] not in FORMULA_BASIS | PROGRAM_BASIS:
                    raise AssertionError('non-basis constructor survived')
                if sub['op'] in {'and', 'seq', 'choice', 'sync'} and len(sub['args']) != 2:
                    raise AssertionError('basis constructor must be binary')
        except RecursionError as exc:
            raise NormalizationLimit('input, expansion, or output nesting exceeds the Python stack limit') from exc
        return result

    def formula(self, expression):
        return self._convert(expression, 'formula')

    def program(self, expression):
        return self._convert(expression, 'program')


def base_model(seed=None):
    rng = random.Random(seed)
    states = ['s0', 's1', 's2', 's3', 's4']
    items = [] if seed is not None and seed % 6 == 0 else ['a', 'b']
    domains = {'Item': items, 'Empty': [], 'Kind': ['a']}
    constants = {name: {'sort': 'Item', 'value': name} for name in items}
    constants['kind_a'] = {'sort': 'Kind', 'value': 'a'}
    if seed is None:
        live = {'s0': [['a']], 's1': [['b']], 's2': [['a'], ['b']], 's3': [], 's4': [['a']]}
        p_true, q_true = {'s0', 's2', 's4'}, {'s1', 's4'}
        a = [['s0', 's1'], ['s0', 's2'], ['s1', 's3'], ['s2', 's2'], ['s3', 's4']]
        b = [['s0', 's2'], ['s2', 's1'], ['s4', 's0']]
    else:
        live = {s: [[i] for i in items if rng.randrange(2)] for s in states}
        p_true = {s for s in states if rng.randrange(2)}
        q_true = {s for s in states if rng.randrange(2)}
        a = [[s, t] for s in states for t in states if rng.random() < .23]
        b = [[s, t] for s in states for t in states if rng.random() < .23]
    predicates = {
        'P': {'sorts': [], 'kind': 'descriptive', 'true_at': {s: [[]] if s in p_true else [] for s in states}},
        'Q': {'sorts': [], 'kind': 'descriptive', 'true_at': {s: [[]] if s in q_true else [] for s in states}},
        'Live': {'sorts': ['Item'], 'kind': 'descriptive', 'true_at': live},
        'Rel': {'sorts': ['Item', 'Item'], 'kind': 'descriptive', 'true_at': {s: [[i, j] for i in items for j in items if (i == j) or s == 's2'] for s in states}}
    }
    fdefs = {
        'AllLive': node('forall', var='x', sort='Item', body=atom('Live', var('x'))),
        'AnyLive': node('exists', var='x', sort='Item', body=atom('Live', var('x'))),
        'ViaGate': node('diamond', program=node('pref', name='Gate'), body=atom('Q')),
        'EmptyAll': node('forall', var='z', sort='Empty', body=node('false')),
        'NestedLocal': node('exists', var='x', sort='Item', body=node('and', args=[atom('Live', var('x')), node('fref', name='AllLive')]))
    }
    pdefs = {'Gate': node('test', condition=node('fref', name='AnyLive')),
             'Route': node('seq', args=[atomic(), node('star', body=node('choice', args=[atomic('b'), node('test', condition=atom('P'))]))]),
             'LocalGate': node('test', condition=node('fref', name='NestedLocal'))}
    return {'context_id': 'v04-relative-basis-fixed-typed-signature', 'closed_world': True,
            'states': states, 'sorts': domains, 'constants': constants, 'predicates': predicates,
            'programs': {'a': a, 'b': b, 'none': []}, 'formula_defs': fdefs, 'program_defs': pdefs,
            'norms': {'Policy': {'actions': ['act'], 'judgments': {s: {'act': 'undetermined'} for s in states}}}}


def model_cost(data):
    interpreted = {k: v for k, v in data.items() if k not in {'formula_defs', 'program_defs'}}
    return {'state_symbols': len(data['states']), 'context_id_utf8_bytes': len(data['context_id'].encode('utf-8')),
            'sort_symbols': len(data['sorts']), 'domain_elements_typed': sum(map(len, data['sorts'].values())),
            'constant_symbols': len(data['constants']), 'predicate_symbols': len(data['predicates']),
            'predicate_signature_slots': sum(len(p['sorts']) for p in data['predicates'].values()),
            'predicate_state_tables': sum(len(p['true_at']) for p in data['predicates'].values()),
            'positive_tuples': sum(len(rows) for p in data['predicates'].values() for rows in p['true_at'].values()),
            'atomic_program_symbols': len(data['programs']), 'atomic_program_edges': sum(map(len, data['programs'].values())),
            'norm_judgments': sum(len(row) for n in data.get('norms', {}).values() for row in n['judgments'].values()),
            'definition_nodes': sum(size(d) for key in ['formula_defs', 'program_defs'] for d in data.get(key, {}).values()),
            'definition_term_occurrences': sum(term_count(d) for key in ['formula_defs', 'program_defs'] for d in data.get(key, {}).values()),
            'definition_binding_slots': sum(n['op'] in {'forall', 'exists'} for key in ['formula_defs', 'program_defs'] for d in data.get(key, {}).values() for n in walk(d)),
            'interpretation_canonical_json_bytes_excluding_definitions': len(json.dumps(interpreted, ensure_ascii=False, separators=(',', ':'), sort_keys=True).encode('utf-8'))}


def locality_formula(f):
    """Observation radius in the specified local, forward, star-free fragment."""
    op = f['op']
    if op in {'true', 'false'} or op == 'atom' and f['name'] == 'Goal' and f['args'] == []:
        return 0
    if op == 'not':
        return locality_formula(f['arg'])
    if op in {'and', 'or'}:
        return max((locality_formula(x) for x in f['args']), default=0)
    if op == 'implies':
        return max(locality_formula(f['left']), locality_formula(f['right']))
    if op in {'diamond', 'box'}:
        displacement, observed = locality_program(f['program'])
        return max(observed, displacement + locality_formula(f['body']))
    raise ValueError('outside the fixed local star-free lower-bound fragment')


def locality_program(p):
    op = p['op']
    if op == 'atomic' and p['name'] == 'a':
        return 1, 1
    if op == 'skip':
        return 0, 0
    if op == 'test':
        return 0, locality_formula(p['condition'])
    if op == 'seq':
        displacement, observed = 0, 0
        for child in p['args']:
            length, radius = locality_program(child)
            observed = max(observed, displacement + radius)
            displacement += length
        return displacement, observed
    if op in {'choice', 'sync'}:
        if op == 'sync' and len(p['args']) < 2:
            raise ValueError('sync needs at least two arguments')
        pairs = [locality_program(x) for x in p['args']]
        return max((x[0] for x in pairs), default=0), max((x[1] for x in pairs), default=0)
    if op == 'repeat':
        if type(p['count']) is not int or p['count'] < 0:
            raise ValueError('invalid repeat count')
        length, radius = locality_program(p['body'])
        n = p['count']
        return (n * length, (n - 1) * length + radius) if n else (0, 0)
    raise ValueError('outside the fixed local star-free lower-bound fragment')


def lower_bound_checks():
    goal, a, truth = atom('Goal'), atomic(), node('true')
    formulas = {
        'one_step': (node('diamond', program=a, body=goal), 1),
        'zero_displacement_deep_test': (node('diamond', program=node('test', condition=node('diamond', program=node('seq', args=[a, a, a]), body=goal)), body=truth), 3),
        'box_vacuity_after_test': (node('box', program=node('seq', args=[a, node('test', condition=node('diamond', program=a, body=goal))]), body=node('false')), 2),
        'sync_far_test': (node('diamond', program=node('sync', args=[a, node('seq', args=[a, node('test', condition=node('diamond', program=node('seq', args=[a, a]), body=goal))])]), body=truth), 3),
        'empty_and': (node('and', args=[]), 0), 'empty_or': (node('or', args=[]), 0),
        'empty_seq': (node('diamond', program=node('seq', args=[]), body=goal), 0),
        'empty_choice': (node('diamond', program=node('choice', args=[]), body=goal), 0),
        'repeat_zero': (node('diamond', program=node('repeat', count=0, body=a), body=goal), 0),
        'fixed_repeat_seven': (node('diamond', program=node('repeat', count=7, body=a), body=goal), 7)
    }
    results = []
    reach = node('diamond', program=node('star', body=a), body=goal)
    for name, (formula, expected_radius) in formulas.items():
        radius = locality_formula(formula)
        assert radius == expected_radius
        n = radius + 1
        states = ['s' + str(i) for i in range(n + 1)]
        data = {'context_id': 'v04-star-free-local-chain-pair', 'closed_world': True,
                'states': states, 'sorts': {}, 'constants': {},
                'predicates': {'Goal': {'sorts': [], 'kind': 'descriptive', 'true_at': {s: [] for s in states}}},
                'programs': {'a': [[states[i], states[i + 1]] for i in range(n)]}}
        negative = Model(data)
        positive_data = copy.deepcopy(data)
        positive_data['predicates']['Goal']['true_at'][states[-1]] = [[]]
        positive = Model(positive_data)
        assert positive._signature() == negative._signature()
        assert positive.programs == negative.programs
        same = positive.holds(formula, 's0') == negative.holds(formula, 's0')
        reach_positive, reach_negative = positive.holds(reach, 's0'), negative.holds(reach, 's0')
        assert same and reach_positive and not reach_negative
        results.append({'case': name, 'radius': radius, 'chain_edges': n, 'chain_states': n + 1,
                        'candidate_agrees': same, 'reach_positive': reach_positive, 'reach_negative': reach_negative, 'pass': True})
    try:
        locality_formula(reach)
    except ValueError:
        pass
    else:
        raise AssertionError('star must be outside the bounded-radius fragment')
    return results


def boundary_cases(data):
    truth, false, p, q, a = node('true'), node('false'), atom('P'), atom('Q'), atomic()
    formulas = {
        'false': false, 'empty_and': node('and', args=[]), 'empty_or': node('or', args=[]),
        'unary_and': node('and', args=[p]), 'unary_or': node('or', args=[p]),
        'or_three': node('or', args=[p, q, node('not', arg=p)]),
        'implies': node('implies', left=p, right=q),
        'forall_empty': node('forall', var='e', sort='Empty', body=false),
        'exists_empty': node('exists', var='e', sort='Empty', body=truth),
        'box_deadlock': node('box', program=atomic('none'), body=false),
        'diamond_deadlock': node('diamond', program=atomic('none'), body=truth),
        'named_cross_kind': node('fref', name='ViaGate'),
        'closed_definition_same_binder': node('exists', var='x', sort='Item', body=node('and', args=[atom('Live', var('x')), node('fref', name='AllLive')])),
        'closed_program_same_binder': node('exists', var='x', sort='Item', body=node('diamond', program=node('pref', name='LocalGate'), body=atom('Live', var('x')))),
        'object_binding_across_test': node('exists', var='x', sort='Item', body=node('diamond', program=node('seq', args=[node('test', condition=atom('Live', var('x'))), a]), body=atom('Live', var('x')))),
        'empty_domain_survives_modal': node('box', program=node('test', condition=node('forall', var='z', sort='Empty', body=false)), body=node('fref', name='EmptyAll')),
        'typed_equality': node('eq', left=const('kind_a'), right=const('kind_a')),
        'quantified_equality': node('forall', var='x', sort='Item', body=node('exists', var='y', sort='Item', body=node('eq', left=var('x'), right=var('y')))),
        'forall_program_test_scope': node('forall', var='x', sort='Item', body=node('box', program=node('test', condition=atom('Live', var('x'))), body=atom('Live', var('x')))),
        'binder_reserved_prefix': node('exists', var='__g0v0', sort='Item', body=node('and', args=[atom('Live', var('__g0v0')), node('fref', name='AnyLive')]))
    }
    programs = {
        'skip': node('skip'), 'empty_seq': node('seq', args=[]), 'empty_choice': node('choice', args=[]),
        'unary_seq': node('seq', args=[a]), 'unary_choice': node('choice', args=[a]),
        'repeat_zero': node('repeat', body=a, count=0), 'repeat_one': node('repeat', body=a, count=1),
        'repeat_four': node('repeat', body=node('choice', args=[a, atomic('b')]), count=4),
        'sync_disjoint': node('sync', args=[a, atomic('none')]),
        'sync_common_end': node('sync', args=[a, atomic('b')]),
        'sync_three': node('sync', args=[node('choice', args=[a, atomic('b')]), a, node('star', body=a)]),
        'star_empty': node('star', body=node('choice', args=[])),
        'test_false': node('test', condition=false),
        'star_test_and_choice': node('star', body=node('choice', args=[node('test', condition=p), node('seq', args=[a, atomic('b')])])),
        'named_program': node('pref', name='Route'), 'named_formula_in_test': node('test', condition=node('fref', name='NestedLocal'))
    }
    return formulas, programs


class Generator:
    def __init__(self, data, seed):
        self.data, self.rng, self.serial = data, random.Random(seed), 0

    def fresh(self):
        self.serial += 1
        return 'r' + str(self.serial)

    def leaf(self, env):
        options = [node('true'), node('false'), atom('P'), atom('Q'), node('fref', name=self.rng.choice(list(self.data['formula_defs'])))]
        terms = [const(c) for c, d in self.data['constants'].items() if d['sort'] == 'Item'] + [var(v) for v, s in env.items() if s == 'Item']
        if terms:
            options.extend([atom('Live', self.rng.choice(terms)), atom('Rel', self.rng.choice(terms), self.rng.choice(terms)), node('eq', left=self.rng.choice(terms), right=self.rng.choice(terms))])
        return self.rng.choice(options)

    def formula(self, depth, env=None):
        env = env or {}
        if depth <= 0:
            return self.leaf(env)
        op = self.rng.choice(['leaf', 'not', 'and', 'or', 'implies', 'forall', 'exists', 'diamond', 'box'])
        if op == 'leaf':
            return self.leaf(env)
        if op == 'not':
            return node(op, arg=self.formula(depth - 1, env))
        if op in {'and', 'or'}:
            return node(op, args=[self.formula(depth - 1, env) for _ in range(self.rng.randrange(4))])
        if op == 'implies':
            return node(op, left=self.formula(depth - 1, env), right=self.formula(depth - 1, env))
        if op in {'exists', 'forall'}:
            v, sort = self.fresh(), self.rng.choice(['Item', 'Empty'])
            return node(op, var=v, sort=sort, body=self.formula(depth - 1, {**env, v: sort}))
        return node(op, program=self.program(depth - 1, env), body=self.formula(depth - 1, env))

    def program(self, depth, env=None):
        env = env or {}
        if depth <= 0:
            return self.rng.choice([atomic(), atomic('b'), atomic('none'), node('skip'), node('pref', name='Route')])
        op = self.rng.choice(['atomic', 'test', 'seq', 'choice', 'sync', 'repeat', 'star'])
        if op == 'atomic':
            return atomic(self.rng.choice(list(self.data['programs'])))
        if op == 'test':
            return node(op, condition=self.formula(depth - 1, env))
        if op in {'seq', 'choice', 'sync'}:
            count = self.rng.randrange(2, 4) if op == 'sync' else self.rng.randrange(4)
            return node(op, args=[self.program(depth - 1, env) for _ in range(count)])
        if op == 'repeat':
            return node(op, count=self.rng.randrange(5), body=self.program(depth - 1, env))
        return node(op, body=self.program(depth - 1, env))


def run_checks():
    checks, input_ops, output_ops = [], set(), set()
    stats = {'models': 25, 'formula_inputs': 0, 'state_truth_comparisons': 0,
             'program_inputs': 0, 'full_relation_comparisons': 0,
             'true_results': 0, 'false_results': 0, 'nonempty_nonidentity_relations': 0}
    examples = []
    for index, seed in enumerate([None] + list(range(24))):
        data = base_model(seed)
        original, converter = Model(data), Normalizer(data)
        stripped = copy.deepcopy(data)
        stripped['formula_defs'], stripped['program_defs'] = {}, {}
        reduced_model = Model(stripped)
        formulas, programs = boundary_cases(data)
        generator = Generator(data, index + 9403)
        formulas.update({f'generated_formula_{i}': generator.formula(4) for i in range(90)})
        programs.update({f'generated_program_{i}': generator.program(4) for i in range(60)})
        for name, expression in formulas.items():
            reduced = converter.formula(expression)
            stats['formula_inputs'] += 1
            input_ops.update(s['op'] for s in walk(expression)); output_ops.update(s['op'] for s in walk(reduced))
            for state in original.states:
                first, second = original.holds(expression, state), reduced_model.holds(reduced, state)
                assert first == second, (seed, name, state, expression, reduced)
                stats['state_truth_comparisons'] += 1
                stats['true_results' if first else 'false_results'] += 1
            if index == 0 and not name.startswith('generated'):
                checks.append({'case': name, 'kind': 'formula', 'pass': True, 'truth_by_state': {s: original.holds(expression, s) for s in original.states}})
                if name in {'closed_definition_same_binder', 'forall_empty', 'empty_or', 'box_deadlock'}:
                    examples.append({'name': name, 'original': expression, 'normalized': reduced,
                                     'source_nodes': size(expression), 'target_nodes': size(reduced),
                                     'source_term_occurrences': term_count(expression), 'target_term_occurrences': term_count(reduced),
                                     'source_binding_slots': sum(s['op'] in {'forall', 'exists'} for s in walk(expression)),
                                     'target_binding_slots': sum(s['op'] in {'forall', 'exists'} for s in walk(reduced))})
        for name, expression in programs.items():
            reduced = converter.program(expression)
            stats['program_inputs'] += 1
            input_ops.update(s['op'] for s in walk(expression)); output_ops.update(s['op'] for s in walk(reduced))
            first, second = original.relation(expression), reduced_model.relation(reduced)
            assert first == second, (seed, name, expression, reduced)
            stats['full_relation_comparisons'] += 1
            if first and first != original._identity():
                stats['nonempty_nonidentity_relations'] += 1
            if index == 0 and not name.startswith('generated'):
                checks.append({'case': name, 'kind': 'program', 'pass': True, 'edge_count': len(first)})

    # Rejections remain rejections rather than being silently normalized away.
    bad = [
        ('empty_sync', 'program', node('sync', args=[])),
        ('unary_sync', 'program', node('sync', args=[atomic()])),
        ('zero_repeat_bad_body', 'program', node('repeat', body=atomic('missing'), count=0)),
        ('bool_repeat', 'program', node('repeat', body=atomic(), count=True)),
        ('negative_repeat', 'program', node('repeat', body=atomic(), count=-1)),
        ('shadowing', 'formula', node('exists', var='x', sort='Item', body=node('forall', var='x', sort='Item', body=node('true')))),
        ('free_variable', 'formula', atom('Live', var('x'))),
        ('extra_key', 'formula', {'op': 'false', 'args': []}),
        ('cross_sort_equality', 'formula', node('eq', left=const('a'), right=const('kind_a')))
    ]
    converter = Normalizer(base_model())
    for name, kind, expression in bad:
        try:
            getattr(converter, kind)(expression)
        except GrammarError:
            checks.append({'case': name, 'kind': 'rejection', 'pass': True})
        else:
            raise AssertionError('accepted invalid input ' + name)
    for name, mutation in [('cyclic_definitions', lambda d: d['program_defs'].update(Gate=node('test', condition=node('fref', name='ViaGate')))),
                           ('definition_capture', lambda d: d['formula_defs'].update(Capture=atom('Live', var('outside'))))]:
        data = base_model(); mutation(data)
        try:
            Normalizer(data)
        except GrammarError:
            checks.append({'case': name, 'kind': 'rejection', 'pass': True})
        else:
            raise AssertionError('accepted invalid model ' + name)
    try:
        Normalizer(base_model(), max_nodes=20).program(node('repeat', body=atomic(), count=1000))
    except NormalizationLimit:
        checks.append({'case': 'explicit_expansion_limit', 'kind': 'resource_limit', 'pass': True})
    else:
        raise AssertionError('resource limit missing')

    deep = node('true')
    for _ in range(2000):
        deep = node('not', arg=deep)
    try:
        converter.formula(deep)
    except NormalizationLimit:
        checks.append({'case': 'explicit_stack_depth_limit', 'kind': 'resource_limit', 'pass': True})
    else:
        raise AssertionError('deep source unexpectedly lacked a documented limit')
    for count in [600, 1000]:
        source = node('repeat', count=count, body=atomic())
        reduced = converter.program(source)
        assert converter.model.relation(source) == converter.model.relation(reduced)
        assert size(reduced) == 2 * count - 1
        checks.append({'case': f'balanced_expansion_repeat_{count}', 'kind': 'program', 'pass': True, 'target_nodes': size(reduced)})

    costs = []
    for count in [0, 1, 2, 8, 32, 128]:
        expr = node('repeat', count=count, body=atomic())
        normalized = converter.program(expr)
        costs.append({'repeat_literal': count, 'original_constructor_nodes': size(expr), 'normalized_constructor_nodes': size(normalized),
                      'original_canonical_json_bytes': len(json.dumps(expr, separators=(',', ':')).encode()),
                      'normalized_canonical_json_bytes': len(json.dumps(normalized, separators=(',', ':')).encode())})
    assert input_ops == {'true', 'false', 'atom', 'eq', 'not', 'and', 'or', 'implies', 'forall', 'exists', 'diamond', 'box', 'fref', 'atomic', 'skip', 'test', 'seq', 'choice', 'sync', 'repeat', 'star', 'pref'}
    assert output_ops == FORMULA_BASIS | PROGRAM_BASIS
    return {'version': 'v0.4-relative-basis', 'all_pass': True,
            'claim': 'G0 and G1 have the same Formula/Program expressive power over the unchanged interpreted signature; irreducible minimum is not proved.',
            'engine_sha256': hashlib.sha256(ENGINE.read_bytes()).hexdigest(),
            'basis': {'formula': sorted(FORMULA_BASIS), 'program': sorted(PROGRAM_BASIS), 'binary': ['and', 'seq', 'choice', 'sync'], 'term_forms': ['const', 'var'], 'constructor_count': 13, 'source_constructor_count': 22},
            'statistics': stats, 'boundary_checks': checks, 'reviewable_expansions': examples,
            'all_source_constructors_exercised': sorted(input_ops), 'all_target_constructors_exercised': sorted(output_ops),
            'domain_cost_not_erased': model_cost(base_model()), 'repeat_expansion_costs': costs,
            'lower_bound_witness_checks': lower_bound_checks(),
            'verification_limits': ['Finite differential checking supports the implementation; the general result relies on the written mutual structural induction.',
                                    'The normalizer preserves typed atoms, equality and atomic program interpretations, not their empirical truth.',
                                    'The default 100000-constructor construction budget and Python stack depth are explicit operational limits, not failures of expressive sufficiency.']}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true', help='recompute and compare with saved results.json without writing')
    args = parser.parse_args()
    result = run_checks()
    destination = HERE / 'results.json'
    if args.check:
        saved = json.loads(destination.read_text(encoding='utf-8'))
        if saved != result:
            raise SystemExit('FAIL: recomputed results differ from saved results.json')
    else:
        destination.write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print(json.dumps({'all_pass': True, 'saved_result_match': bool(args.check), **result['statistics'], 'boundary_checks': len(result['boundary_checks'])}, ensure_ascii=False))


if __name__ == '__main__':
    main()
