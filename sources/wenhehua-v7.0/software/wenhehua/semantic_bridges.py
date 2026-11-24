"""v6.0: semantic bridges for a typed compositional process grammar.

Scope: finite typed chains, exact rational stochastic kernels, finite stoichiometric
networks, mass-action-style linear flows, binary acyclic SCMs, finite Markov
quotients, and one-port positive metric networks. This file does NOT construct
or prove a general semantic double functor out of v5's lax interchanger.

Each bridge has explicit input data and domain assumptions. Similar-looking
wiring is never used to infer copying, conservation, or causality.
"""
from __future__ import annotations
from dataclasses import dataclass
from fractions import Fraction
from typing import Mapping, Hashable
from .core import GrammarError
from .probability import Kernel, quotient_markov

Q = Fraction


def require(condition: bool, message: str):
    if not condition:
        raise GrammarError(message)


@dataclass(frozen=True)
class Generator:
    name: str
    input_type: str
    output_type: str

    def check(self):
        require(all((self.name, self.input_type, self.output_type)), 'generator requires name and types')


@dataclass(frozen=True)
class Chain:
    """Typed, one-input/one-output path; not arbitrary cospan syntax."""
    generators: tuple[Generator, ...]

    def check(self):
        require(bool(self.generators), 'empty chains need an explicitly typed identity')
        for g in self.generators: g.check()
        for x, y in zip(self.generators, self.generators[1:]):
            require(x.output_type == y.input_type, f'incompatible interfaces: {x.output_type} != {y.input_type}')

    @property
    def type(self):
        self.check()
        return self.generators[0].input_type, self.generators[-1].output_type

    def then(self, after: 'Chain') -> 'Chain':
        self.check(); after.check()
        out = Chain(self.generators + after.generators)
        out.check(); return out


@dataclass(frozen=True)
class FiniteFunction:
    source: tuple[Hashable, ...]
    target: tuple[Hashable, ...]
    values: Mapping[Hashable, Hashable]

    def check(self):
        require(bool(self.source) and bool(self.target) and len(set(self.source)) == len(self.source)
                and len(set(self.target)) == len(self.target), 'finite function sets must be unique and nonempty')
        require(set(self.values) == set(self.source), 'function not total')
        require(set(self.values.values()) <= set(self.target), 'function maps outside codomain')

    def then(self, after: 'FiniteFunction') -> 'FiniteFunction':
        self.check(); after.check()
        require(self.target == after.source, 'function interfaces not identical: use explicit renaming')
        f = FiniteFunction(self.source, after.target,
                           {x: after.values[self.values[x]] for x in self.source})
        f.check(); return f

    def as_kernel(self) -> Kernel:
        self.check()
        result = Kernel(self.source, self.target,
                        {x: {y: Q(int(self.values[x] == y)) for y in self.target}
                         for x in self.source})
        result.check(); return result


def interpret_functions(chain: Chain, semantics: Mapping[str, tuple[str, str, FiniteFunction]]) -> FiniteFunction:
    """Partial interpretation. Raises if a generator has no semantics."""
    chain.check()
    vals = []
    for g in chain.generators:
        require(g.name in semantics, f'no deterministic meaning for {g.name}')
        inp, out, f = semantics[g.name]
        require((g.input_type, g.output_type) == (inp, out), 'semantic signature conflict')
        f.check(); vals.append(f)
    x = vals[0]
    for y in vals[1:]: x = x.then(y)
    return x


def interpret_kernels(chain: Chain, semantics: Mapping[str, tuple[str, str, Kernel]]) -> Kernel:
    chain.check()
    vals = []
    for g in chain.generators:
        require(g.name in semantics, f'no stochastic meaning for {g.name}')
        inp, out, k = semantics[g.name]
        require((g.input_type, g.output_type) == (inp, out), 'semantic signature conflict')
        k.check(); vals.append(k)
    result = vals[0]
    for after in vals[1:]: result = result.then(after)
    return result


@dataclass(frozen=True)
class StoichEvent:
    """One declared reaction event; delta is signed species count change."""
    name: str
    delta: Mapping[str, int]


@dataclass(frozen=True)
class StoichNetwork:
    species: tuple[str, ...]
    events: tuple[StoichEvent, ...]
    quantity_units: Mapping[str, str]  # e.g. all mol, but species identities differ

    def check(self):
        require(bool(self.species) and len(set(self.species)) == len(self.species), 'species invalid')
        require(set(self.quantity_units) == set(self.species), 'every species needs a unit')
        require(all(isinstance(u, str) and u for u in self.quantity_units.values()), 'empty unit')
        require(len(set(self.quantity_units.values())) == 1,
                'network requires a common species amount unit or explicit conversion')
        require(len({e.name for e in self.events}) == len(self.events), 'reaction names duplicate')
        for event in self.events:
            require(bool(event.name), 'unnamed event')
            require(set(event.delta) <= set(self.species), 'reaction uses undeclared species')
            require(all(type(n) is int for n in event.delta.values()), 'stoichiometry must be integral')

    def conservation_certificate(self, weights: Mapping[str, int | Q]) -> dict[str, Q]:
        self.check(); require(set(weights) == set(self.species), 'all species need weights')
        return {e.name: sum((Q(weights[s]) * Q(e.delta.get(s, 0)) for s in self.species), Q(0))
                for e in self.events}

    def combined_event(self, names: tuple[str, ...]) -> dict[str, int]:
        """Algebraic sum of declared event vectors, NOT an enabled-firing proof."""
        self.check()
        idx = {e.name: e for e in self.events}
        require(all(n in idx for n in names), 'unknown reaction name')
        return {s: sum(idx[n].delta.get(s, 0) for n in names) for s in self.species}


@dataclass(frozen=True)
class LinearRate:
    name: str
    driving_species: str
    coefficient: Q


@dataclass(frozen=True)
class ContinuousReaction:
    stoich: StoichNetwork
    rates: Mapping[str, LinearRate]

    def check(self):
        self.stoich.check()
        require(set(self.rates) == {e.name for e in self.stoich.events}, 'one rate per reaction')
        for key, rate in self.rates.items():
            require(rate.name == key, 'rate must match reaction')
            require(rate.driving_species in self.stoich.species, 'unknown rate species')
            require(Q(rate.coefficient) >= 0, 'negative kinetic coefficient')

    def derivative(self, state: Mapping[str, Q]) -> dict[str, Q]:
        self.check(); require(set(state) == set(self.stoich.species), 'state species mismatch')
        require(all(Q(x) >= 0 for x in state.values()), 'negative concentrations')
        res = {s: Q(0) for s in self.stoich.species}
        for event in self.stoich.events:
            rate = self.rates[event.name]
            speed = Q(rate.coefficient) * Q(state[rate.driving_species])
            for s in self.stoich.species:
                res[s] += Q(event.delta.get(s, 0)) * speed
        return res

    def weighted_balance(self, state: Mapping[str, Q], weights: Mapping[str, Q]) -> Q:
        require(set(weights) == set(self.stoich.species), 'weights mismatch')
        derivative = self.derivative(state)
        return sum((Q(weights[s]) * derivative[s] for s in self.stoich.species), Q(0))


@dataclass(frozen=True)
class BinarySCM:
    """Exactly two binary variables: one exogenous Bernoulli root, child copies root.

    Causal intervention replaces the assignment equation for the intervened
    variable; it is not conditioning on an observation.
    """
    root: str
    child: str
    root_p_one: Q = Q(1, 2)

    def check(self):
        require(set((self.root, self.child)) == {'X', 'Y'} and self.root != self.child,
                'SCM must contain X and Y in one of the two orders')
        require(Q(0) <= Q(self.root_p_one) <= Q(1), 'invalid Bernoulli parameter')

    def joint(self, intervene: Mapping[str, int] | None = None) -> dict[tuple[int, int], Q]:
        self.check()
        do = {} if intervene is None else dict(intervene)
        require(set(do) <= {'X', 'Y'} and all(v in (0, 1) and type(v) is int for v in do.values()),
                'invalid intervention')
        out = {(x, y): Q(0) for x in (0, 1) for y in (0, 1)}
        for noise, prob in ((0, Q(1) - Q(self.root_p_one)), (1, Q(self.root_p_one))):
            vals = {self.root: do.get(self.root, noise)}
            vals[self.child] = do.get(self.child, vals[self.root])
            out[(vals['X'], vals['Y'])] += prob
        return out

    def marginal_y_one(self, intervene: Mapping[str, int] | None = None) -> Q:
        return sum((p for (x, y), p in self.joint(intervene).items() if y == 1), Q(0))


@dataclass(frozen=True)
class MetricEdge:
    start: str
    end: str
    length: Q


@dataclass(frozen=True)
class OpenMetricNetwork:
    nodes: tuple[str, ...]
    edges: tuple[MetricEdge, ...]
    input_node: str
    output_node: str
    port_type: str = 'distance-node'
    length_unit: str = 'm'

    def check(self):
        require(len(set(self.nodes)) == len(self.nodes) and bool(self.nodes), 'metric nodes invalid')
        require(self.input_node in self.nodes and self.output_node in self.nodes, 'port missing')
        require(bool(self.port_type) and bool(self.length_unit), 'unit or type missing')
        for e in self.edges:
            require(e.start in self.nodes and e.end in self.nodes, 'edge endpoint not in graph')
            require(Q(e.length) >= 0, 'negative lengths unsupported')

    def shortest_path(self) -> Q | None:
        """Exact Bellman-Ford over nonnegative rational lengths; None if unreachable."""
        self.check()
        d: dict[str, Q | None] = {x: None for x in self.nodes}
        d[self.input_node] = Q(0)
        for _ in range(len(self.nodes) - 1):
            changed = False
            for e in self.edges:
                if d[e.start] is None: continue
                cand = d[e.start] + Q(e.length)
                if d[e.end] is None or cand < d[e.end]:
                    d[e.end] = cand; changed = True
            if not changed: break
        return d[self.output_node]

    def then(self, other: 'OpenMetricNetwork') -> 'OpenMetricNetwork':
        """One-port gluing; prefix names except shared junction to avoid collisions."""
        self.check(); other.check()
        require(self.port_type == other.port_type and self.length_unit == other.length_unit,
                'metric interface/unit mismatch')
        left = {x: f'L:{x}' for x in self.nodes}
        right = {x: (left[self.output_node] if x == other.input_node else f'R:{x}')
                 for x in other.nodes}
        nodes = tuple(dict.fromkeys([left[x] for x in self.nodes] + [right[x] for x in other.nodes]))
        edges = tuple(MetricEdge(left[e.start], left[e.end], Q(e.length)) for e in self.edges) + \
                tuple(MetricEdge(right[e.start], right[e.end], Q(e.length)) for e in other.edges)
        result = OpenMetricNetwork(nodes, edges, left[self.input_node], right[other.output_node],
                                   self.port_type, self.length_unit)
        result.check(); return result


def check_markov_abstraction(k: Kernel, abstraction: Mapping[Hashable, Hashable],
                             port_shapes: Mapping[Hashable, tuple[tuple[str, ...], tuple[str, ...]]] | None = None
                             ) -> Kernel:
    """Exact strong lumpability +, optionally, interface constancy on fibers."""
    return quotient_markov(k, abstraction, port_shapes)


def demo_data() -> dict:
    """Reproducible exact examples shared by the PDF and unit tests."""
    flip = FiniteFunction((0, 1), (0, 1), {0: 1, 1: 0})
    chain = Chain((Generator('flip', 'Bit', 'Bit'), Generator('noise', 'Bit', 'Bit')))
    noisy = Kernel((0, 1), (0, 1), {0: {0: Q(3, 4), 1: Q(1, 4)},
                                      1: {0: Q(1, 4), 1: Q(3, 4)}})
    out = interpret_kernels(chain, {'flip': ('Bit', 'Bit', flip.as_kernel()),
                                    'noise': ('Bit', 'Bit', noisy)})
    hydro = StoichNetwork(('H2', 'O2', 'H2O'),
                 (StoichEvent('water', {'H2': -2, 'O2': -1, 'H2O': 2}),),
                 {'H2': 'mol', 'O2': 'mol', 'H2O': 'mol'})
    conserved_h = hydro.conservation_certificate({'H2': 2, 'O2': 0, 'H2O': 2})
    conserved_o = hydro.conservation_certificate({'H2': 0, 'O2': 2, 'H2O': 1})
    flow_s = StoichNetwork(('A', 'B', 'C'),
                 (StoichEvent('ab', {'A': -1, 'B': 1}),
                  StoichEvent('bc', {'B': -1, 'C': 1})),
                 {'A': 'mol', 'B': 'mol', 'C': 'mol'})
    flow = ContinuousReaction(flow_s, {'ab': LinearRate('ab', 'A', Q(1, 4)),
                                       'bc': LinearRate('bc', 'B', Q(1, 3))})
    deriv = flow.derivative({'A': Q(8), 'B': Q(6), 'C': Q(1)})
    scm_a = BinarySCM('X', 'Y'); scm_b = BinarySCM('Y', 'X')
    micro = Kernel(('a', 'b', 'c'), ('a', 'b', 'c'), {
        'a': {'a': Q(1, 2), 'b': Q(1, 4), 'c': Q(1, 4)},
        'b': {'a': Q(1, 4), 'b': Q(1, 2), 'c': Q(1, 4)},
        'c': {'a': Q(1, 4), 'b': Q(1, 4), 'c': Q(1, 2)}})
    coarse = check_markov_abstraction(micro, {'a': 'AB', 'b': 'AB', 'c': 'C'})
    g1 = OpenMetricNetwork(('s', 'j'), (MetricEdge('s', 'j', Q(3)),), 's', 'j')
    g2 = OpenMetricNetwork(('x', 't'), (MetricEdge('x', 't', Q(4)),), 'x', 't')
    return {
        'stochastic': str(out.rows[0][1]),
        'stochastic_expected': '3/4',
        'resource_H_balance': str(conserved_h['water']),
        'resource_O_balance': str(conserved_o['water']),
        'continuous_derivative': {k: str(v) for k, v in deriv.items()},
        'continuous_total_balance': str(flow.weighted_balance({'A': Q(8), 'B': Q(6), 'C': Q(1)},
                                                               {'A': Q(1), 'B': Q(1), 'C': Q(1)})),
        'causal_observational_equal': scm_a.joint() == scm_b.joint(),
        'causal_doX1_forward_Y1': str(scm_a.marginal_y_one({'X': 1})),
        'causal_doX1_reverse_Y1': str(scm_b.marginal_y_one({'X': 1})),
        'coarse_P_AB_to_C': str(coarse.rows['AB']['C']),
        'metric_sequential_distance': str(g1.then(g2).shortest_path())
    }


@dataclass(frozen=True)
class TraceCoverage:
    """Measure-theoretic support check for ONE finite v5 comparison map.

    Weights here are formal nonnegative weights on global witness tokens.
    Calling them probabilities or causal contributions requires a separate
    empirical/modeling assumption and appropriate normalization.
    """
    represented: Q
    unrepresented: Q

    @property
    def full(self) -> bool:
        return self.unrepresented == 0


def trace_coverage(comparison, global_weights: Mapping[str, Q]) -> TraceCoverage:
    """How much declared global witness mass lies outside image(chi)?

    For any non-surjective chi, a point mass at an omitted witness has no
    push-forward lift from local witnesses. This is a *support* obstruction,
    not a physical or causal finding.
    """
    codomain = set(comparison.vertical_after_horizontal.witness.keys())
    require(set(global_weights) == codomain, 'declare weight for every global history')
    masses = {k: Q(v) for k, v in global_weights.items()}
    require(all(v >= 0 for v in masses.values()), 'negative witness weights invalid')
    image = set(comparison.comparison.mapping.values())
    return TraceCoverage(sum((v for k, v in masses.items() if k in image), Q(0)),
                         sum((v for k, v in masses.items() if k not in image), Q(0)))
