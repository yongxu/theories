"""A small, explicitly scoped compositional semantics for open directed graphs.

On single-input, single-output graphs containing *only* directed unary wire
edges, Boolean reachability composes by conjunction under a single shared
vertex boundary. It is not a semantics for general hypergraphs, multi-port
networks, security, causation, or time.
"""
from collections import defaultdict, deque
from .core import Signature, GrammarError
from .higher import OpenGraph, Change


def one_port_reachable(sig: Signature, network: OpenGraph) -> bool:
    network.check(sig)
    if len(network.input_types) != 1 or len(network.output_types) != 1:
        raise GrammarError('reachability semantics only supports one input and one output')
    adjacency=defaultdict(set)
    for e in network.graph.edges.values():
        if len(e.sources)!=1 or len(e.targets)!=1:
            raise GrammarError('reachability semantics only for unary directed edges')
        adjacency[e.sources[0]].add(e.targets[0])
    start=network.graph.ports['in:0']; goal=network.graph.ports['out:0']
    queue=deque([start]); visited={start}
    while queue:
        x=queue.popleft()
        if x==goal:
            return True
        for y in adjacency[x]:
            if y not in visited:
                visited.add(y); queue.append(y)
    return False


def preserves_reachability(sig: Signature, change: Change) -> bool:
    change.check(sig)
    return (one_port_reachable(sig,change.before) ==
            one_port_reachable(sig,change.after))
