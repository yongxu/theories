"""文·合·化 v1.2 — finite typed open multigraph calculus.

This is a deliberately *restricted*, executable model, not a general implementation
of arbitrary cospans or all adhesive-category DPO rewriting.

- 文: finite typed directed multigraph with named ports at vertices.
- 合: quotient of disjoint union along a discrete *typed vertex* interface.
- 化: injective node/edge DPO-style matching, preserving specified L<-K->R.

No auto-copying, no implicit physics, no unrestricted feedback semantics.
"""
from __future__ import annotations
from dataclasses import dataclass, field
from itertools import count
from typing import Dict, Tuple, Mapping, Optional, Iterable, Callable, Sequence

class GrammarError(Exception):
    """A rule or construction does not satisfy its stated preconditions."""

@dataclass(frozen=True)
class Edge:
    kind: str
    sources: Tuple[str, ...]
    targets: Tuple[str, ...]

@dataclass
class Graph:
    nodes: Dict[str, str] = field(default_factory=dict)
    edges: Dict[str, Edge] = field(default_factory=dict)
    ports: Dict[str, str] = field(default_factory=dict)

    def check(self, sig: 'Signature') -> None:
        for n, typ in self.nodes.items():
            if typ not in sig.node_types:
                raise GrammarError(f'unknown node type {typ}: {n}')
        for name, edge in self.edges.items():
            if edge.kind not in sig.edges:
                raise GrammarError(f'unknown edge type {edge.kind}: {name}')
            src, dst = sig.edges[edge.kind]
            if len(src) != len(edge.sources) or len(dst) != len(edge.targets):
                raise GrammarError(f'arity mismatch: {name}')
            for n, kind in zip(edge.sources, src):
                if n not in self.nodes or self.nodes[n] != kind:
                    raise GrammarError(f'source type mismatch: {name}/{n}')
            for n, kind in zip(edge.targets, dst):
                if n not in self.nodes or self.nodes[n] != kind:
                    raise GrammarError(f'target type mismatch: {name}/{n}')
        for port, node in self.ports.items():
            if node not in self.nodes:
                raise GrammarError(f'unbound port {port}')

@dataclass(frozen=True)
class Signature:
    node_types: frozenset[str]
    edges: Mapping[str, Tuple[Tuple[str, ...], Tuple[str, ...]]]

@dataclass(frozen=True)
class Match:
    """Injective typed graph morphism from a pattern into a host."""
    nodes: Mapping[str, str]
    edges: Mapping[str, str]

@dataclass
class Rule:
    name: str
    lhs: Graph
    rhs: Graph
    keep_nodes: Mapping[str, str] = field(default_factory=dict)
    keep_edges: Mapping[str, str] = field(default_factory=dict)

    def check(self, sig: Signature) -> None:
        self.lhs.check(sig)
        self.rhs.check(sig)
        if len(set(self.keep_nodes.values())) != len(self.keep_nodes):
            raise GrammarError('K node inclusion into R not injective')
        if len(set(self.keep_edges.values())) != len(self.keep_edges):
            raise GrammarError('K edge inclusion into R not injective')
        for l, r in self.keep_nodes.items():
            if l not in self.lhs.nodes or r not in self.rhs.nodes:
                raise GrammarError('bad preserved node id')
            if self.lhs.nodes[l] != self.rhs.nodes[r]:
                raise GrammarError('preserved node changes type')
        for l, r in self.keep_edges.items():
            if l not in self.lhs.edges or r not in self.rhs.edges:
                raise GrammarError('bad preserved edge id')
            a, b = self.lhs.edges[l], self.rhs.edges[r]
            if a.kind != b.kind:
                raise GrammarError('preserved edge changes type')
            try:
                a_src = tuple(self.keep_nodes[n] for n in a.sources)
                a_dst = tuple(self.keep_nodes[n] for n in a.targets)
            except KeyError as ex:
                raise GrammarError('preserved edge endpoint must be preserved node') from ex
            if a_src != b.sources or a_dst != b.targets:
                raise GrammarError('preserved edge endpoints changed')
        # Rule-local ports are NOT modeled by this limited rewriting API.
        # Host ports are protected separately during application.
        if self.lhs.ports or self.rhs.ports:
            raise GrammarError('rule-local ports unsupported; host ports are protected')


def _fresh(existing: Iterable[str], prefix: str) -> str:
    used = set(existing)
    for n in count():
        cand = f'{prefix}{n}'
        if cand not in used:
            return cand
    raise AssertionError('unreachable')


def glue(sig: Signature, left: Graph, right: Graph,
         along: Mapping[str, str], *, hide: bool = True) -> Graph:
    """Pushout along a *discrete*, typed vertex boundary via ports.

    along maps a port-name in left to a port-name in right. Only vertex
    identifications are supported; no existing edges are identified.
    """
    left.check(sig); right.check(sig)
    # Validate existence BEFORE dereferencing ports: preserve domain-specific errors.
    if any(p not in left.ports or q not in right.ports for p, q in along.items()):
        raise GrammarError('missing connection port')
    if len(set(along.values())) != len(along):
        raise GrammarError('non-injective boundary port mapping')
    if (len(set(left.ports[p] for p in along)) != len(along) or
        len(set(right.ports[p] for p in along.values())) != len(along)):
        raise GrammarError('boundary vertex injections must be injective')
    for lp, rp in along.items():
        if lp not in left.ports or rp not in right.ports:
            raise GrammarError(f'missing connection port: {lp}, {rp}')
        if left.nodes[left.ports[lp]] != right.nodes[right.ports[rp]]:
            raise GrammarError(f'boundary type mismatch at {lp}/{rp}')
    result = Graph(nodes={f'L::{n}': t for n, t in left.nodes.items()},
                   edges={f'L::{n}': Edge(e.kind,
                         tuple(f'L::{x}' for x in e.sources),
                         tuple(f'L::{x}' for x in e.targets)) for n, e in left.edges.items()},
                   ports={f'L.{p}': f'L::{n}' for p, n in left.ports.items()})
    mapping = {n: f'R::{n}' for n in right.nodes}
    for lp, rp in along.items():
        mapping[right.ports[rp]] = f'L::{left.ports[lp]}'
    # Left & right interfaces are injective and node-only: no two right nodes
    # are identified with each other except by forbidden non-injective mapping.
    if len(set(mapping.values())) != len(mapping):
        raise GrammarError('several right nodes identified with one left node')
    for rn, typ in right.nodes.items():
        out_n = mapping[rn]
        if out_n in result.nodes and result.nodes[out_n] != typ:
            raise GrammarError('identified node type differs')
        result.nodes[out_n] = typ
    for eid, e in right.edges.items():
        result.edges[f'R::{eid}'] = Edge(e.kind,
            tuple(mapping[n] for n in e.sources),
            tuple(mapping[n] for n in e.targets))
    for p, n in right.ports.items():
        result.ports[f'R.{p}'] = mapping[n]
    if hide:
        for lp, rp in along.items():
            result.ports.pop(f'L.{lp}')
            result.ports.pop(f'R.{rp}')
    result.check(sig)
    return result


def rename_ports(sig: Signature, graph: Graph, names: Mapping[str, str], *,
                 strict: bool = True) -> Graph:
    """Rename *external* interface labels; graph identity and connectivity stay fixed.

    With strict=True every exposed port must be explicitly mapped. The caller
    is responsible for choosing stable semantic names, not implicit L./R. paths.
    """
    graph.check(sig)
    if strict and set(names) != set(graph.ports):
        raise GrammarError('port renaming must cover exactly all exposed ports')
    if any(p not in graph.ports for p in names):
        raise GrammarError('unknown port in renaming')
    new_names = {p: names.get(p, p) for p in graph.ports}
    if any(not isinstance(q, str) or not q for q in new_names.values()):
        raise GrammarError('port names must be nonempty strings')
    if len(set(new_names.values())) != len(new_names):
        raise GrammarError('duplicate external port name after renaming')
    out = Graph(dict(graph.nodes), dict(graph.edges),
                {new_names[p]: node for p, node in graph.ports.items()})
    out.check(sig)
    return out


def compose_pair(sig: Signature, first: Graph, second: Graph) -> Graph:
    """Canonical two-port sequential wiring: in/out labels are stable.

    This is a special-case serial composition, NOT a universal composition
    operator or a proof of behavior equivalence.
    """
    first.check(sig); second.check(sig)
    if set(first.ports) != {'in', 'out'} or set(second.ports) != {'in', 'out'}:
        raise GrammarError('compose_pair requires exactly in/out exposed ports')
    joined = glue(sig, first, second, {'out': 'in'}, hide=True)
    return rename_ports(sig, joined, {'L.in': 'in', 'R.out': 'out'})


def compose_series(sig: Signature, graphs: Sequence[Graph]) -> Graph:
    """Fold compose_pair over an ordered, nonempty series of two-port graphs."""
    if not graphs:
        raise GrammarError('empty series needs an explicitly typed identity')
    current = graphs[0]
    for nxt in graphs[1:]:
        current = compose_pair(sig, current, nxt)
    return current


def match_graph(pattern: Graph, host: Graph, sig: Signature,
                accept: Optional[Callable[[Match], bool]] = None) -> Optional[Match]:
    """Find the first injective typed morphism. Intended for small examples."""
    pattern.check(sig); host.check(sig)
    pnodes = list(pattern.nodes)
    hedges = list(host.edges)
    if len(pnodes) > len(host.nodes) or len(pattern.edges) > len(host.edges):
        return None

    def backtrack_nodes(i: int, mapping: Dict[str, str]) -> Optional[Match]:
        if i == len(pnodes):
            pedges = list(pattern.edges)
            def backtrack_edges(j: int, em: Dict[str, str]) -> Optional[Match]:
                if j == len(pedges):
                    m = Match(dict(mapping), dict(em))
                    return m if accept is None or accept(m) else None
                peid = pedges[j]
                e = pattern.edges[peid]
                src = tuple(mapping[n] for n in e.sources)
                tgt = tuple(mapping[n] for n in e.targets)
                for heid in hedges:
                    if heid not in em.values() and host.edges[heid] == Edge(e.kind, src, tgt):
                        em[peid] = heid
                        found = backtrack_edges(j + 1, em)
                        if found: return found
                        del em[peid]
                return None
            return backtrack_edges(0, {})
        node = pnodes[i]
        for hid, kind in host.nodes.items():
            if kind == pattern.nodes[node] and hid not in mapping.values():
                mapping[node] = hid
                found = backtrack_nodes(i + 1, mapping)
                if found: return found
                del mapping[node]
        return None
    return backtrack_nodes(0, {})


def _admissible(host: Graph, rule: Rule, match: Match) -> bool:
    """Check DPO dangling condition and protected host interface."""
    remove_nodes = {match.nodes[n] for n in rule.lhs.nodes if n not in rule.keep_nodes}
    remove_edges = {match.edges[e] for e in rule.lhs.edges if e not in rule.keep_edges}
    if any(node in remove_nodes for node in host.ports.values()):
        return False
    return not any(eid not in remove_edges and
                   (set(edge.sources) | set(edge.targets)) & remove_nodes
                   for eid, edge in host.edges.items())


def rewrite(sig: Signature, host: Graph, rule: Rule,
            match: Optional[Match] = None) -> Graph:
    """Small DPO-style rewrite with injective graph matching and dangling check.

    Important restrictions: category is finite typed directed multigraphs;
    K injections are specified by keep_nodes and keep_edges; external host
    ports are preserved (deleting a port-bearing vertex is forbidden).
    """
    host.check(sig); rule.check(sig)
    if match is None:
        match = match_graph(rule.lhs, host, sig,
                            accept=lambda m: _admissible(host, rule, m))
    if match is None:
        raise GrammarError(f'no match for {rule.name}')
    if set(match.nodes) != set(rule.lhs.nodes) or set(match.edges) != set(rule.lhs.edges):
        raise GrammarError('incomplete match')
    if len(set(match.nodes.values())) != len(match.nodes) or len(set(match.edges.values())) != len(match.edges):
        raise GrammarError('match not injective')
    for l, h in match.nodes.items():
        if h not in host.nodes or host.nodes[h] != rule.lhs.nodes[l]:
            raise GrammarError('match node type mismatch')
    for l, h in match.edges.items():
        e, f = rule.lhs.edges[l], host.edges.get(h)
        if f != Edge(e.kind, tuple(match.nodes[n] for n in e.sources),
                                  tuple(match.nodes[n] for n in e.targets)):
            raise GrammarError('match edge structure mismatch')

    remove_nodes = {match.nodes[n] for n in rule.lhs.nodes if n not in rule.keep_nodes}
    remove_edges = {match.edges[e] for e in rule.lhs.edges if e not in rule.keep_edges}
    for port, node in host.ports.items():
        if node in remove_nodes:
            raise GrammarError(f'dangling open port {port}')
    for edge_name, e in host.edges.items():
        if edge_name not in remove_edges and (set(e.sources) | set(e.targets)) & remove_nodes:
            raise GrammarError(f'dangling edge {edge_name}')
    out = Graph(nodes={n:t for n,t in host.nodes.items() if n not in remove_nodes},
                edges={n:e for n,e in host.edges.items() if n not in remove_edges},
                ports=dict(host.ports))
    r_to_h = {r: match.nodes[l] for l,r in rule.keep_nodes.items()}
    for rn, typ in rule.rhs.nodes.items():
        if rn not in r_to_h:
            hid = _fresh(out.nodes, f'{rule.name}::n::')
            out.nodes[hid] = typ
            r_to_h[rn] = hid
    for reid, e in rule.rhs.edges.items():
        if reid not in set(rule.keep_edges.values()):
            eid = _fresh(out.edges, f'{rule.name}::e::')
            out.edges[eid] = Edge(e.kind,
                tuple(r_to_h[n] for n in e.sources),
                tuple(r_to_h[n] for n in e.targets))
    out.check(sig)
    return out


def compatible_abstraction(states: Iterable, micro_step, alpha) -> tuple:
    """Check deterministic macro closure on a *complete, closed finite* state space.

    No claim of approximate, causal, or stochastic abstraction is made.
    A counterexample returns (state, coarse_state, expected_next, observed_next).
    """
    states = tuple(states)
    if not states or len(set(states)) != len(states):
        raise GrammarError('abstraction requires nonempty distinct finite states')
    known = set(states)
    macro = {}
    for s in states:
        nxt_micro = micro_step(s)
        if nxt_micro not in known:
            raise GrammarError('micro dynamics leave the declared state space')
        a, nxt = alpha(s), alpha(nxt_micro)
        if a in macro and macro[a] != nxt:
            return False, macro, (s, a, macro[a], nxt)
        macro[a] = nxt
    return True, macro, None
