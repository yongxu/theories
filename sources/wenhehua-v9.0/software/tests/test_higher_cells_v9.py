import unittest

from wenhehua.generative_v9 import (
    Equality, KernelError, RewriteRule, RewriteTheory,
    reflexivity, symmetry,
)
from wenhehua.higher_cells_v9 import (
    ThreeBoundary, ThreeCell, ThreeGenerator, ThreeTheory,
)
from tests.test_generative_v9 import event_signature, grid


class ThreeDimensionalTests(unittest.TestCase):
    def setUp(self):
        self.sig = event_signature()
        self.p, self.q, self.r, self.s = (self.sig.atom(n) for n in ("p", "q", "r", "s"))
        self.theory = ThreeTheory(self.sig, (
            ThreeGenerator("pq", self.p, self.q),
            ThreeGenerator("qr", self.q, self.r),
            ThreeGenerator("pq_other", self.p, self.q),
        ))

    def test_generation_and_identity_have_checked_parallel_boundaries(self):
        self.assertEqual(self.theory.boundary(self.theory.gen("pq")), ThreeBoundary(self.p, self.q))
        self.assertEqual(self.theory.boundary(self.theory.identity(self.p)), ThreeBoundary(self.p, self.p))
        with self.assertRaises(KernelError):
            ThreeTheory(self.sig, (ThreeGenerator("bad", self.p, self.s),))

    def test_three_composition_directions_compute_both_endpoints(self):
        a, b = self.theory.gen("pq"), self.theory.gen("qr")
        self.assertEqual(self.theory.boundary(self.theory.h(a, b)), ThreeBoundary(self.sig.h(self.p, self.q), self.sig.h(self.q, self.r)))
        self.assertEqual(self.theory.boundary(self.theory.v(a, b)), ThreeBoundary(self.sig.v(self.p, self.q), self.sig.v(self.q, self.r)))
        self.assertEqual(self.theory.boundary(self.theory.z(a, b)), ThreeBoundary(self.p, self.r))
        with self.assertRaises(KernelError):
            self.theory.z(b, a)

    def test_invalid_pasting_seams_cannot_be_hidden_by_3d_wrapper(self):
        sig = grid()
        theory = ThreeTheory(sig)
        a, d = theory.identity(sig.atom("s00")), theory.identity(sig.atom("s11"))
        for op in (theory.h, theory.v):
            with self.subTest(op=op.__name__), self.assertRaises(KernelError):
                op(a, d)

    def test_middle_transport_must_be_a_valid_2d_equality_with_bound_endpoints(self):
        a, b = self.theory.gen("pq"), self.theory.gen("qr")
        unit_q = self.sig.axiom("hunit_left", self.q)
        b_new = self.theory.transport(b, source=unit_q)
        with self.assertRaises(KernelError):
            self.theory.z(a, b_new)
        composite = self.theory.z(a, b_new, symmetry(unit_q))
        self.assertEqual(self.theory.boundary(composite), ThreeBoundary(self.p, self.r))
        with self.assertRaises(KernelError):
            self.theory.z(a, b_new, reflexivity(self.p))
        with self.assertRaises(KernelError):
            self.theory.z(a, b_new, Equality("refl", self.q, unit_q.left))

    def test_endpoint_transport_is_not_a_new_directed_event(self):
        cell = self.theory.gen("pq")
        src = self.sig.axiom("hunit_left", self.p)
        dst = self.sig.axiom("hunit_left", self.q)
        changed = self.theory.transport(cell, source=src, target=symmetry(dst))
        self.assertEqual(self.theory.boundary(changed), ThreeBoundary(src.left, dst.left))
        self.assertEqual(self.theory.event_counts(cell), self.theory.event_counts(changed))
        with self.assertRaises(KernelError):
            self.theory.transport(cell, source=dst)

    def test_named_third_events_are_not_erased(self):
        a, b = self.theory.gen("pq"), self.theory.gen("pq_other")
        self.assertEqual(self.theory.boundary(a), self.theory.boundary(b))
        self.assertNotEqual(a, b)
        self.assertNotEqual(self.theory.event_counts(a), self.theory.event_counts(b))

    def test_raw_associativity_is_not_misreported_as_quotient_equality(self):
        a, b, c = self.theory.gen("pq"), self.theory.gen("qr"), self.theory.identity(self.r)
        left = self.theory.z(self.theory.z(a, b), c)
        right = self.theory.z(a, self.theory.z(b, c))
        self.assertEqual(self.theory.boundary(left), self.theory.boundary(right))
        self.assertNotEqual(left, right)
        self.assertEqual(self.theory.event_counts(left), self.theory.event_counts(right))

    def test_hv_endpoint_representatives_require_explicit_structural_transport(self):
        sig = grid()
        theory = ThreeTheory(sig)
        a, b, c, d = (theory.identity(sig.atom(n)) for n in ("s00", "s01", "s10", "s11"))
        left = theory.v(theory.h(a, b), theory.h(c, d))
        right = theory.h(theory.v(a, c), theory.v(b, d))
        proof = sig.axiom("exchange", *(sig.atom(n) for n in ("s00", "s01", "s10", "s11")))
        self.assertNotEqual(theory.boundary(left), theory.boundary(right))
        changed = theory.transport(left, source=symmetry(proof), target=proof)
        self.assertEqual(theory.boundary(changed), theory.boundary(right))
        self.assertNotEqual(changed, right)  # No implemented 3D quotient decision.

    def test_malformed_raw_cells_and_declaration_mutation_rejected(self):
        cases = [ThreeCell("gen", "unknown"), ThreeCell("id", "p"),
                 ThreeCell("h", args=(self.theory.gen("pq"),)),
                 ThreeCell("z", args=(self.theory.gen("pq"), self.theory.gen("qr")), evidence=(reflexivity(self.q), reflexivity(self.q))),
                 ThreeCell("transport", args=(self.theory.gen("pq"),), evidence=(reflexivity(self.p),))]
        for case in cases:
            with self.subTest(op=case.op), self.assertRaises(KernelError):
                self.theory.boundary(case)
        with self.assertRaises(AttributeError):
            self.theory.generators = {}

    def test_concrete_rewrite_trace_lifts_to_typed_3d_composition(self):
        rewriting = RewriteTheory(self.sig, (RewriteRule("pq", self.p, self.q), RewriteRule("qr", self.q, self.r)))
        three = ThreeTheory.from_rewrite_theory(rewriting)
        source = self.sig.h(self.p, self.s)
        first = rewriting.apply("pq", source, (0,))
        second = rewriting.apply("qr", first.target, (0,))
        trace = rewriting.trace(first, second)
        lifted = three.lift_trace(rewriting, trace)
        self.assertEqual(three.boundary(lifted), ThreeBoundary(trace.source, trace.target))
        self.assertEqual(three.event_counts(lifted), (("pq", 1), ("qr", 1)))
        self.assertEqual(three.boundary(three.lift_trace(rewriting, rewriting.identity(self.p))), ThreeBoundary(self.p, self.p))

    def test_contextual_rewrite_lift_requires_declared_third_generator(self):
        rewriting = RewriteTheory(self.sig, (RewriteRule("new", self.p, self.q),))
        with self.assertRaises(KernelError):
            self.theory.lift_step(rewriting, rewriting.apply("new", self.p))


if __name__ == "__main__":
    unittest.main()
