"""Finite variable-boundary fragment: a scoped, *not universal*, model of 界变.

This is a finite construction over v2's typed open hypergraphs, with
partial injective traces of old boundary positions into new boundary positions.
A trace records persistence of interface identity, not a time duration.

Horizontal pasting is implemented ONLY when the connected seam is completely
preserved (possibly permuted identically by both systems). Outer input/output
interfaces MAY grow, shrink, or be reordered. The full changing-interface
bicategory/equipment and nonlinear dynamics are NOT implemented here.
"""
from __future__ import annotations
from dataclasses import dataclass
from typing import Dict, Mapping, Tuple
from .core import Edge, Graph, GrammarError, Match, Signature, glue
from .higher import OpenGraph, _horizontal_data, _valid_graph_map

PortPairs = Tuple[Tuple[int, int], ...]


def _pair_check(before: Tuple[str, ...], after: Tuple[str, ...], pairs: PortPairs,
                kind: str) -> None:
    old, new = set(), set()
    for p in pairs:
        if len(p) != 2 or not all(isinstance(x, int) for x in p):
            raise GrammarError(f'{kind} trace must contain integer pairs')
        i,j = p
        if i in old or j in new:
            raise GrammarError(f'{kind} trace must be injective')
        if i < 0 or i >= len(before) or j < 0 or j >= len(after):
            raise GrammarError(f'{kind} trace index out of range')
        if before[i] != after[j]:
            raise GrammarError(f'{kind} trace type mismatch')
        old.add(i); new.add(j)


@dataclass(frozen=True)
class InterfaceTrace:
    """Typed partial bijection between old and new *boundary occurrences*.

    Omitted old occurrences are withdrawn; omitted new occurrences are gained.
    It does not imply their internal graph vertices are created or destroyed.
    """
    inputs: PortPairs = ()
    outputs: PortPairs = ()

    def check(self, before: OpenGraph, after: OpenGraph) -> None:
        _pair_check(before.input_types, after.input_types, self.inputs, 'input')
        _pair_check(before.output_types, after.output_types, self.outputs, 'output')

    @classmethod
    def identity(cls, x: OpenGraph) -> 'InterfaceTrace':
        return cls(tuple((i,i) for i in range(len(x.input_types))),
                   tuple((i,i) for i in range(len(x.output_types))))

    def then(self, later: 'InterfaceTrace') -> 'InterfaceTrace':
        def join(a, b):
            bs = dict(b)
            return tuple((i,bs[j]) for i,j in a if j in bs)
        return InterfaceTrace(join(self.inputs,later.inputs),
                              join(self.outputs,later.outputs))


def _port_name(side: str, index: int) -> str:
    return f'{side}:{index}'


@dataclass
class Evolution:
    """Boundary-changing monic span, plus a partial interface identity trace.

    Unlike v2.Change, before and after need NOT have identical boundaries.
    Still, the common subgraph has injective embeddings in both graphs.
    """
    before: OpenGraph
    after: OpenGraph
    common: Graph
    into_before: Match
    into_after: Match
    trace: InterfaceTrace

    def check(self, sig: Signature) -> None:
        self.before.check(sig); self.after.check(sig)
        if self.common.ports:
            raise GrammarError('evolution common apex has no external port labels')
        _valid_graph_map(sig,self.common,self.before.graph,self.into_before)
        _valid_graph_map(sig,self.common,self.after.graph,self.into_after)
        self.trace.check(self.before,self.after)
        for side,pairs in (('in',self.trace.inputs),('out',self.trace.outputs)):
            for i,j in pairs:
                b = self.before.graph.ports[_port_name(side,i)]
                a = self.after.graph.ports[_port_name(side,j)]
                if not any(self.into_before.nodes[k] == b and
                           self.into_after.nodes[k] == a for k in self.common.nodes):
                    raise GrammarError(f'persistent {side} port lacks common witness: {i}->{j}')

    @classmethod
    def identity(cls, sig: Signature, x: OpenGraph) -> 'Evolution':
        x.check(sig)
        common = Graph(dict(x.graph.nodes),dict(x.graph.edges))
        incl = Match({k:k for k in common.nodes},{k:k for k in common.edges})
        y = cls(x,x,common,incl,incl,InterfaceTrace.identity(x))
        y.check(sig)
        return y


def vertical_evolution(sig: Signature, first: Evolution,
                       second: Evolution) -> Evolution:
    """Pullback composition when the middle presentation is *exactly identical*."""
    first.check(sig); second.check(sig)
    if first.after != second.before:
        raise GrammarError('middle network must match exactly (transport not provided)')
    m1nodes = {mid:k for k,mid in first.into_after.nodes.items()}
    m2nodes = {mid:k for k,mid in second.into_before.nodes.items()}
    nodes: Dict[str,str]={}; into_b:Dict[str,str]={}; into_a:Dict[str,str]={}
    middle_to_new={}
    for ix,mid in enumerate(sorted(set(m1nodes)&set(m2nodes))):
        name=f'P::v::{ix}'; middle_to_new[mid]=name
        nodes[name]=first.after.graph.nodes[mid]
        into_b[name]=first.into_before.nodes[m1nodes[mid]]
        into_a[name]=second.into_after.nodes[m2nodes[mid]]
    m1edges={mid:k for k,mid in first.into_after.edges.items()}
    m2edges={mid:k for k,mid in second.into_before.edges.items()}
    edges={}; eb={}; ea={}
    for ix,mid in enumerate(sorted(set(m1edges)&set(m2edges))):
        edge=first.after.graph.edges[mid]
        if any(n not in middle_to_new for n in edge.sources+edge.targets):
            raise GrammarError('non-closed pullback graph witness')
        name=f'P::e::{ix}'
        edges[name]=Edge(edge.kind,
                         tuple(middle_to_new[n] for n in edge.sources),
                         tuple(middle_to_new[n] for n in edge.targets))
        eb[name]=first.into_before.edges[m1edges[mid]]
        ea[name]=second.into_after.edges[m2edges[mid]]
    out=Evolution(first.before,second.after,Graph(nodes,edges),
                  Match(into_b,eb),Match(into_a,ea),first.trace.then(second.trace))
    out.check(sig)
    return out


def _is_total(trace: PortPairs, before_n: int, after_n: int) -> bool:
    return len(trace)==before_n==after_n and {i for i,_ in trace}==set(range(before_n)) and {j for _,j in trace}==set(range(after_n))


def horizontal_evolution(sig: Signature, left: Evolution,
                         right: Evolution) -> Evolution:
    """Paste changes with a fully persistent connected seam.

    Both traces of the connected boundary must describe the same typed
    bijection, but external boundaries can be altered freely.  If a seam
    is created/deleted or two sides disagree, composition is *not* inferred.
    """
    left.check(sig); right.check(sig)
    if left.before.output_types != right.before.input_types or \
       left.after.output_types != right.after.input_types:
        raise GrammarError('seam type mismatch before or after')
    seam = left.trace.outputs
    if set(seam) != set(right.trace.inputs) or not _is_total(
          seam,len(left.before.output_types),len(left.after.output_types)):
        raise GrammarError('seam evolution must be total and agreed by both sides')
    before, bleft, bright = _horizontal_data(sig,left.before,right.before)
    after, aleft, aright = _horizontal_data(sig,left.after,right.after)
    # The monic common pieces are glued exactly at enduring seam nodes.
    lports={};rports={}
    for i,_ in seam:
        lp=left.before.graph.ports[_port_name('out',i)]
        rp=right.before.graph.ports[_port_name('in',i)]
        lk=next(k for k,v in left.into_before.nodes.items() if v==lp)
        rk=next(k for k,v in right.into_before.nodes.items() if v==rp)
        lports[f's:{i}']=lk; rports[f's:{i}']=rk
    common=glue(sig,Graph(dict(left.common.nodes),dict(left.common.edges),lports),
                Graph(dict(right.common.nodes),dict(right.common.edges),rports),
                {k:k for k in lports}, hide=True)
    before_nodes={}; after_nodes={}; before_edges={}; after_edges={}
    for prefix,ev,b_incl,a_incl in (("L::",left,bleft,aleft),
                                   ("R::",right,bright,aright)):
        # Right seam nodes are assigned L:: identifiers in `glue`.
        for n in ev.common.nodes:
            raw=f'{prefix}{n}'
            if raw not in common.nodes:
                if prefix != 'R::' or n not in rports.values():
                    raise GrammarError('unexpected common-node identification')
                seam_name=next(p for p,v in rports.items() if v==n)
                raw=f'L::{lports[seam_name]}'
            bv=b_incl.nodes[ev.into_before.nodes[n]]
            av=a_incl.nodes[ev.into_after.nodes[n]]
            if raw in before_nodes and (before_nodes[raw]!=bv or after_nodes[raw]!=av):
                raise GrammarError('seam witness does not commute')
            before_nodes[raw]=bv; after_nodes[raw]=av
        for e in ev.common.edges:
            raw=f'{prefix}{e}'
            before_edges[raw]=b_incl.edges[ev.into_before.edges[e]]
            after_edges[raw]=a_incl.edges[ev.into_after.edges[e]]
    out=Evolution(before,after,Graph(dict(common.nodes),dict(common.edges)),
                  Match(before_nodes,before_edges),Match(after_nodes,after_edges),
                  InterfaceTrace(left.trace.inputs,right.trace.outputs))
    out.check(sig)
    return out
