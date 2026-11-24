"""Explicit typed interface-mediators (junction generators), version 4.

A generator edge can have several inputs/outputs (hyperedge arity). Its name
must be declared in Signature.edges with exactly the required types. This is
*syntax*, NOT a claim about resource cloning, conservation, or causal laws.
No implicit source duplication, sink merging, discard, or unit conversion.
"""
from __future__ import annotations
from .core import Edge,Graph,Signature,GrammarError
from .higher import OpenGraph, horizontal


def junction(sig: Signature, kind: str,
             inputs: tuple[str,...], outputs: tuple[str,...]) -> OpenGraph:
    """A single primitive mediator with ordered typed open inputs/outputs."""
    sig_types=sig.edges.get(kind)
    if sig_types is None or sig_types != (tuple(inputs), tuple(outputs)):
        raise GrammarError('adapter generator is not declared with these arities/types')
    nodes={}
    sources=[];targets=[];ports={}
    for i,t in enumerate(inputs):
        name=f'source:{i}';nodes[name]=t;sources.append(name);ports[f'in:{i}']=name
    for j,t in enumerate(outputs):
        name=f'target:{j}';nodes[name]=t;targets.append(name);ports[f'out:{j}']=name
    out=OpenGraph(Graph(nodes,{'mediator':Edge(kind,tuple(sources),tuple(targets))},ports),
                  tuple(inputs),tuple(outputs))
    out.check(sig)
    return out


def connect_with_adapter(sig:Signature,left:OpenGraph,
                         mediator:OpenGraph,right:OpenGraph)->OpenGraph:
    """Composition with an explicit intermediate process, no implicit coercion."""
    left.check(sig);mediator.check(sig);right.check(sig)
    if left.output_types!=mediator.input_types or mediator.output_types!=right.input_types:
        raise GrammarError('adapter interface type/arity mismatch')
    return horizontal(sig,horizontal(sig,left,mediator),right)
