"""v6: canonical n-step finite-seam comparison (a narrow pasting-coherence slice).

For a chain of >=2 compatible v5 SeamSteps, compare the horizontal pushout
of all local temporal pullbacks to the temporal pullback of horizontal
pushouts. This deliberately keeps v5's exact finite-typed-set scope. It does
not claim a full lax double category/equipment/coherence theorem.
"""
from .lineage import (
    Comparison, LineageError, TMap, SeamStep,
    horizontal, vertical, compose_spans, pair_key, unpack_pair,
)


def _flatten_left_nested(k: str, n: int) -> list[str]:
    if n == 1:
        return [k]
    left, right = unpack_pair(k)
    return _flatten_left_nested(left, n-1) + [right]


def _pair_left_nested(keys: list[str]) -> str:
    if len(keys) < 2:
        raise LineageError('requires at least two temporal witnesses')
    out = pair_key(keys[0], keys[1])
    for k in keys[2:]:
        out = pair_key(out, k)
    return out


def n_interchanger(steps: tuple[SeamStep, ...]) -> Comparison:
    if len(steps) < 2:
        raise LineageError('at least two steps required')
    for x,y in zip(steps,steps[1:]):
        if x.new != y.old:
            raise LineageError('temporal states differ')
    local=steps[0]
    for after in steps[1:]: local=vertical(local, after)
    local_h=horizontal(local)
    h_each=[horizontal(s) for s in steps]
    global_span=h_each[0].span
    for item in h_each[1:]: global_span=compose_spans(global_span,item.span)
    out={}
    for sid, inlet, injects in (
        (local.left, local_h.from_left, [h.from_left for h in h_each]),
        (local.right, local_h.from_right, [h.from_right for h in h_each]),
    ):
        for w in sid.witness.keys():
            pieces=_flatten_left_nested(w,len(steps))
            global_witness=_pair_left_nested([inject(p) for inject,p in zip(injects,pieces)])
            local_witness=inlet(w)
            if local_witness in out and out[local_witness] != global_witness:
                raise LineageError('seam comparison disagrees after pasting')
            out[local_witness] = global_witness
    return Comparison(local_h.span,global_span,
                      TMap(local_h.span.witness,global_span.witness,out))
