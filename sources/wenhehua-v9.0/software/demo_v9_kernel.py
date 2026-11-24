"""Run with: python3 demo_v9_kernel.py.  Exact, deterministic demonstration."""

import json

from wenhehua.generative_v9 import (
    Arrow, Equality, EventCountModel, Frame, FunctionModel, KernelError, RewriteRule,
    RewriteTheory, Signature, SquareGenerator,
)
from wenhehua.higher_cells_v9 import ThreeTheory


def example_signature():
    objects = [f"o{i}{j}" for i in range(3) for j in range(3)]
    horizontal = [Arrow(f"h{i}{j}", f"o{i}{j}", f"o{i}{j+1}") for i in range(3) for j in range(2)]
    vertical = [Arrow(f"v{i}{j}", f"o{i}{j}", f"o{i+1}{j}") for i in range(2) for j in range(3)]
    base = Signature(objects, horizontal, vertical)
    names = (("a", "b"), ("c", "d"))
    squares = [SquareGenerator(names[i][j], Frame(
        base.path("h", f"o{i}{j}", f"h{i}{j}"),
        base.path("h", f"o{i+1}{j}", f"h{i+1}{j}"),
        base.path("v", f"o{i}{j}", f"v{i}{j}"),
        base.path("v", f"o{i}{j+1}", f"v{i}{j+1}"),
    )) for i in range(2) for j in range(2)]
    squares.append(SquareGenerator("a_fast", squares[0].frame))
    return Signature(objects, horizontal, vertical, squares)


def main():
    sig = example_signature()
    a, b, c, d = (sig.atom(name) for name in ("a", "b", "c", "d"))
    proof = sig.axiom("exchange", a, b, c, d)
    model = FunctionModel(sig, {o: ("0", "1") for o in sig.objects},
                          {name: ("1", "0") for name in sig.horizontal},
                          {name: ("1", "0") for name in sig.vertical})
    theory = RewriteTheory(sig, (RewriteRule("choose_fast", a, sig.atom("a_fast")),))
    count_model = EventCountModel(sig)
    step = theory.apply("choose_fast", sig.h(a, b), (0,))
    trace = theory.trace(step)
    three = ThreeTheory.from_rewrite_theory(theory)
    lifted = three.lift_trace(theory, trace)
    transported = three.transport(lifted, source=sig.axiom("hunit_left", trace.source))
    three.v(lifted, three.identity(sig.h(c, d)))
    three.z(lifted, three.identity(trace.target))

    rejected = {}
    checks = {
        "wrong_complete_seam": lambda: sig.h(a, d),
        "same_frame_is_not_structural_equality": lambda: sig.verify(Equality("refl", a, sig.atom("a_fast"))),
        "directed_step_is_not_equality": lambda: sig.verify(step),
        "reverse_rewrite_not_declared": lambda: theory.apply("choose_fast", sig.atom("a_fast")),
    }
    for name, check in checks.items():
        try:
            check()
        except KernelError as exc:
            rejected[name] = str(exc)
        else:
            raise AssertionError("bad construction accepted: " + name)

    frame = sig.boundary(proof.left)
    result = {
        "scope": "typed square terms, structural equality certificates, directed contextual rewrites",
        "signature": {"objects": len(sig.objects), "h_edges": len(sig.horizontal), "v_edges": len(sig.vertical), "square_generators": len(sig.squares)},
        "exchange": {
            "raw_terms_identical": proof.left == proof.right,
            "certificate_accepted": sig.verify(proof),
            "finite_function_semantics_preserved": model.respects(proof),
            "named_event_counts_preserved": count_model.respects(proof),
            "top_word": frame.top.edges,
            "bottom_word": frame.bottom.edges,
            "left_word": frame.left.edges,
            "right_word": frame.right.edges,
        },
        "directed_rewrite": {
            "rule": step.rule,
            "context_address": step.position,
            "trace_valid": theory.verify_trace(trace),
            "boundary_preserved": sig.boundary(step.source) == sig.boundary(step.target),
            "thin_observation_identifies_events": model.interpret(a) == model.interpret(sig.atom("a_fast")),
            "syntactic_events_remain_distinct": a != sig.atom("a_fast"),
            "count_semantics_separates_events": count_model.interpret(a) != count_model.interpret(sig.atom("a_fast")),
        },
        "third_dimension": {
            "contextual_rewrite_lifted": three.boundary(lifted).source == trace.source and three.boundary(lifted).target == trace.target,
            "named_events": three.event_counts(lifted),
            "transport_adds_no_directed_events": three.event_counts(transported) == three.event_counts(lifted),
            "constructors": ["identity", "generator", "h", "v", "z", "certified_endpoint_transport"],
            "full_quotient_equality_algorithm_implemented": False,
        },
        "rejections": rejected,
        "limitations": [
            "No general equality-search or normalization algorithm is implemented.",
            "No complete 3-dimensional quotient equality algorithm is implemented.",
            "The finite-function observation is thin and is not a faithful semantics.",
            "Typed directed rewrites alone do not certify behavior preservation in richer models.",
        ],
    }
    print(json.dumps(result, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
