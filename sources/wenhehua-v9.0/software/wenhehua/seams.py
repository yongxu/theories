"""v4.0: finite *changing shared seam* composition, explicitly certified.

This module handles typed discrete node interfaces only. A SeamContract supplies a
partial injective *continuity witness* of the shared seam. Untraced ports may
be born, withdrawn, or relinked. Old and new composites are formed by pushout.

The shared witness is formed by gluing preserved local pieces only along the
explicitly continuous seam. It must embed injectively into BOTH composites.
If noncontinuous interface fusion/fission creates collisions, the caller must
choose either strict rejection or explicit epistemic weakening of the witness
(`forget_conflicts`), which removes *all* involved witness vertices and their
incident edges. This operation forgets claims of identity; it is not a
physical deletion or a general DPO rule. No resource copying, behavior,
causal equivalence, or full changing-boundary double category is established.
"""
from __future__ import annotations
from dataclasses import dataclass
from typing import Literal
from .core import Graph, Match, GrammarError, Signature, glue
from .higher import _horizontal_data
from .evolving import Evolution, InterfaceTrace


@dataclass(frozen=True)
class SeamContract:
    """Required explicit certificate of positions continuous through change.

    `pairs` contains (old_seam_index, new_seam_index). Identifies only those
    typed boundary occurrences whose node identity is witnessed on BOTH sides.
    `strict`: refuse a conflicting change witness.
    `forget_conflicts`: discard ALL colliding witness vertices plus incident
    edges, then validate the remaining witness. Not a canonical repair.
    """
    pairs: tuple[tuple[int,int], ...]
    policy: Literal['strict', 'forget_conflicts'] = 'strict'


def horizontal_changing_seam(
        sig: Signature, left: Evolution, right: Evolution,
        contract: SeamContract) -> Evolution:
    """Paste two changes even if shared interface arity differs between stages.

    A successful result is a *typed monic span witness*, not a guarantee that
    temporal/behavioral/resource semantics are preserved. The outer boundary
    traces must survive in the glued witness; otherwise fail.
    """
    left.check(sig)
    right.check(sig)
    if left.before.output_types != right.before.input_types:
        raise GrammarError('old shared seam types disagree')
    if left.after.output_types != right.after.input_types:
        raise GrammarError('new shared seam types disagree')
    if contract.policy not in ('strict','forget_conflicts'):
        raise GrammarError('unsupported seam conflict policy')
    # Equality of sets (not tuple order) is intentional: the trace is an
    # injective partial graph of a function, not a prescribed enumeration.
    if set(left.trace.outputs) != set(right.trace.inputs) or \
       set(left.trace.outputs) != set(contract.pairs) or \
       len(set(contract.pairs)) != len(contract.pairs):
        raise GrammarError('seam traces must be agreed and explicitly certified')

    before, bleft, bright = _horizontal_data(sig,left.before,right.before)
    after, aleft, aright = _horizontal_data(sig,left.after,right.after)

    # Which common vertices witness each explicitly continuous seam port?
    lports, rports = {}, {}
    for old,new in contract.pairs:
        left_b = left.before.graph.ports[f'out:{old}']
        right_b = right.before.graph.ports[f'in:{old}']
        left_w = [k for k,v in left.into_before.nodes.items() if v == left_b]
        right_w = [k for k,v in right.into_before.nodes.items() if v == right_b]
        if len(left_w)!=1 or len(right_w)!=1:
            raise GrammarError('certified persistent seam lacks unique witness')
        k=f'joint:{old}'
        lports[k] = left_w[0]
        rports[k] = right_w[0]

    joint = glue(sig,
         Graph(dict(left.common.nodes),dict(left.common.edges),lports),
         Graph(dict(right.common.nodes),dict(right.common.edges),rports),
         {k:k for k in lports}, hide=True)
    # For merged common seam nodes, check the right image agrees with the
    # image induced by the left witness in BOTH ambient composites.
    remap = {}
    for k,l_node in lports.items():
        r_node = rports[k]
        remap[f'R::{r_node}'] = f'L::{l_node}'

    bnodes, anodes, bedges, aedges = {}, {}, {}, {}
    for prefix,evolution,bi,ai in (
        ('L::',left,bleft,aleft),('R::',right,bright,aright)
    ):
        for n in evolution.common.nodes:
            key=remap.get(f'{prefix}{n}',f'{prefix}{n}')
            bv=bi.nodes[evolution.into_before.nodes[n]]
            av=ai.nodes[evolution.into_after.nodes[n]]
            if key in bnodes:
                if bnodes[key] != bv or anodes[key] != av:
                    raise GrammarError('persistent shared seam diagram does not commute')
            else:
                bnodes[key]=bv; anodes[key]=av
        for e in evolution.common.edges:
            key=f'{prefix}{e}'
            bedges[key]=bi.edges[evolution.into_before.edges[e]]
            aedges[key]=ai.edges[evolution.into_after.edges[e]]

    def collisions(leg: dict[str,str]) -> set[str]:
        rev={}
        for common_id,img in leg.items():
            rev.setdefault(img,[]).append(common_id)
        return {c for colliders in rev.values() if len(colliders)>1 for c in colliders}

    conflicted = collisions(bnodes) | collisions(anodes)
    if conflicted:
        if contract.policy == 'strict':
            raise GrammarError('untraced seam causes non-monic witness: explicit weakening or adapter required')
        # Deliberately forget BOTH claims at any collision (never infer which
        # identity survives a fusion/fission). Only delete from the *witness*.
        keep = set(joint.nodes) - conflicted
        nodes = {n:t for n,t in joint.nodes.items() if n in keep}
        edges = {e:v for e,v in joint.edges.items()
                 if all(x in keep for x in v.sources+v.targets)}
        bnodes={n:v for n,v in bnodes.items() if n in keep}
        anodes={n:v for n,v in anodes.items() if n in keep}
        bedges={e:v for e,v in bedges.items() if e in edges}
        aedges={e:v for e,v in aedges.items() if e in edges}
        joint=Graph(nodes,edges)

    result = Evolution(before,after,Graph(dict(joint.nodes),dict(joint.edges)),
         Match(bnodes,bedges),Match(anodes,aedges),
         InterfaceTrace(left.trace.inputs,right.trace.outputs))
    result.check(sig)
    return result
