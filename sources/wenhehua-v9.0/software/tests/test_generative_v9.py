"""Certificates, semantic soundness, and adversarial boundary checks.

These finite examples test an executable kernel.  They do not constitute a
machine-checked proof of the free-double-category universal property.
"""

import unittest

from wenhehua.generative_v9 import (
    Arrow, Equality, EventCountModel, FiniteMap, Frame, FunctionModel, KernelError, Path,
    RewriteRule, RewriteStep, RewriteTheory, RewriteTrace, Signature,
    SquareGenerator, Term, congruence, reflexivity, symmetry, transitivity,
)


def grid(size=3):
    objects = [f"o{i}{j}" for i in range(size + 1) for j in range(size + 1)]
    horizontal = [Arrow(f"h{i}{j}", f"o{i}{j}", f"o{i}{j+1}") for i in range(size + 1) for j in range(size)]
    vertical = [Arrow(f"v{i}{j}", f"o{i}{j}", f"o{i+1}{j}") for i in range(size) for j in range(size + 1)]
    paths = Signature(objects, horizontal, vertical)
    squares = [SquareGenerator(f"s{i}{j}", Frame(
        paths.path("h", f"o{i}{j}", f"h{i}{j}"),
        paths.path("h", f"o{i+1}{j}", f"h{i+1}{j}"),
        paths.path("v", f"o{i}{j}", f"v{i}{j}"),
        paths.path("v", f"o{i}{j+1}", f"v{i}{j+1}"),
    )) for i in range(size) for j in range(size)]
    return Signature(objects, horizontal, vertical, squares)


def event_signature():
    base = Signature(("A",), (Arrow("f", "A", "A"), Arrow("g", "A", "A")))
    f, g, unit = base.path("h", "A", "f"), base.path("h", "A", "g"), base.path("v", "A")
    same = Frame(f, f, unit, unit)
    return Signature(("A",), tuple(base.horizontal.values()), squares=(
        SquareGenerator("p", same), SquareGenerator("q", same), SquareGenerator("r", same),
        SquareGenerator("s", Frame(g, g, unit, unit)),
    ))


class BoundaryTests(unittest.TestCase):
    def test_signature_cannot_be_rebound_or_mutated(self):
        sig = event_signature()
        with self.assertRaises(AttributeError):
            sig.objects = frozenset(("fake",))
        with self.assertRaises(AttributeError):
            sig.squares = {}
        with self.assertRaises(TypeError):
            sig.squares["forged"] = sig.squares["p"]

    def test_paths_include_objects_axes_and_order(self):
        sig = grid()
        a = sig.path("h", "o00", "h00")
        b = sig.path("h", "o01", "h01")
        c = sig.path("h", "o02", "h02")
        self.assertEqual(sig.then(sig.then(a, b), c), sig.then(a, sig.then(b, c)))
        self.assertEqual(sig.then(sig.path("h", "o00"), a), a)
        with self.assertRaises(KernelError):
            sig.check_path(Path("h", "o00", "o03", ("h00",)))
        with self.assertRaises(KernelError):
            sig.then(a, sig.path("v", "o01", "v01"))

    def test_path_constructor_rejects_undeclared_or_broken_edges(self):
        sig = grid()
        for edges in (("missing",), ("h00", "h02")):
            with self.subTest(edges=edges), self.assertRaises(KernelError):
                sig.path("h", "o00", *edges)

    def test_signature_rejects_duplicate_and_bad_square_corners(self):
        with self.assertRaises(KernelError):
            Signature(("A",), (Arrow("x", "A", "A"), Arrow("x", "A", "A")))
        sig = grid()
        frame = sig.boundary(sig.atom("s00"))
        wrong = Frame(frame.top, frame.bottom, frame.left, sig.path("v", "o02", "v02"))
        with self.assertRaises(KernelError):
            Signature(sig.objects, tuple(sig.horizontal.values()), tuple(sig.vertical.values()), (SquareGenerator("bad", wrong),))

    def test_pasting_checks_full_seam_not_only_endpoints(self):
        base = Signature(("A",), (Arrow("f", "A", "A"),), (Arrow("u", "A", "A"), Arrow("v", "A", "A")))
        f, u, v = base.path("h", "A", "f"), base.path("v", "A", "u"), base.path("v", "A", "v")
        sig = Signature(base.objects, tuple(base.horizontal.values()), tuple(base.vertical.values()), (
            SquareGenerator("a", Frame(f, f, u, u)), SquareGenerator("b", Frame(f, f, v, v)),
        ))
        with self.assertRaises(KernelError):
            sig.h(sig.atom("a"), sig.atom("b"))

    def test_both_pasting_directions_reject_unmatched_boundaries(self):
        sig = grid()
        for op in (sig.h, sig.v):
            with self.subTest(op=op.__name__), self.assertRaises(KernelError):
                op(sig.atom("s00"), sig.atom("s11"))

    def test_rechecking_raw_terms_catches_bypassed_builders(self):
        sig = grid()
        malformed = [Term("h", args=(sig.atom("s00"),)), Term("atom", "missing"),
                     Term("hid", sig.path("h", "o00")), Term("vid", sig.path("v", "o00")),
                     Term("h", "extra", (sig.atom("s00"), sig.atom("s01")))]
        for term in malformed:
            with self.subTest(term=term), self.assertRaises(KernelError):
                sig.boundary(term)

    def test_typed_composition_is_not_commutative(self):
        sig = event_signature()
        p, s = sig.atom("p"), sig.atom("s")
        ps, sp = sig.h(p, s), sig.h(s, p)
        self.assertNotEqual(sig.boundary(ps), sig.boundary(sp))
        with self.assertRaises(KernelError):
            sig.verify(Equality("refl", ps, sp))


class EqualityTests(unittest.TestCase):
    def test_horizontal_and_vertical_associativity_are_certified_not_erased(self):
        sig = grid()
        for rule, names in (("hassoc", ("s00", "s01", "s02")), ("vassoc", ("s00", "s10", "s20"))):
            proof = sig.axiom(rule, *(sig.atom(name) for name in names))
            self.assertNotEqual(proof.left, proof.right)
            self.assertTrue(sig.verify(proof))
            self.assertTrue(sig.verify(symmetry(proof)))

    def test_exchange_uses_same_four_named_generators(self):
        sig = grid()
        proof = sig.axiom("exchange", *(sig.atom(name) for name in ("s00", "s01", "s10", "s11")))
        self.assertNotEqual(proof.left, proof.right)
        self.assertEqual(sig.boundary(proof.left), sig.boundary(proof.right))
        self.assertTrue(sig.verify(proof))

    def test_all_unit_laws_including_identity_composition(self):
        sig = grid()
        a = sig.atom("s00")
        for rule in ("hunit_left", "hunit_right", "vunit_top", "vunit_bottom"):
            with self.subTest(rule=rule):
                self.assertTrue(sig.verify(sig.axiom(rule, a)))
        self.assertTrue(sig.verify(sig.axiom("hid_comp", sig.path("v", "o00", "v00"), sig.path("v", "o10", "v10"))))
        self.assertTrue(sig.verify(sig.axiom("vid_comp", sig.path("h", "o00", "h00"), sig.path("h", "o01", "h01"))))
        self.assertTrue(sig.verify(sig.axiom("double_unit", "o00")))

    def test_congruence_symmetry_transitivity_replay(self):
        sig = grid()
        a, b, c = (sig.atom(n) for n in ("s00", "s01", "s10"))
        unit = sig.axiom("hunit_left", a)
        horizontal = congruence("h", unit, reflexivity(b))
        vertical = congruence("v", unit, reflexivity(c))
        self.assertTrue(sig.verify(horizontal))
        self.assertTrue(sig.verify(vertical))
        self.assertTrue(sig.verify(transitivity(horizontal, symmetry(horizontal))))

    def test_same_boundary_named_events_do_not_become_equal(self):
        sig = event_signature()
        p, q = sig.atom("p"), sig.atom("q")
        self.assertEqual(sig.boundary(p), sig.boundary(q))
        self.assertNotEqual(p, q)
        count_model = EventCountModel(sig)
        self.assertNotEqual(count_model.interpret(p), count_model.interpret(q))
        for rule in ("refl", "exchange", "invented_semantic_equality"):
            with self.subTest(rule=rule), self.assertRaises(KernelError):
                sig.verify(Equality(rule, p, q))

    def test_certificate_must_bind_endpoints_and_premises(self):
        sig = event_signature()
        p, q = sig.atom("p"), sig.atom("q")
        forged = [Equality("sym", q, p, (reflexivity(p),)),
                  Equality("trans", p, q, (reflexivity(p), reflexivity(q))),
                  Equality("refl", p, p, (reflexivity(p),)),
                  Equality("hunit_left", p, p)]
        for proof in forged:
            with self.subTest(proof=proof.rule), self.assertRaises(KernelError):
                sig.verify(proof)

    def test_all_structural_axioms_preserve_nontrivial_function_semantics(self):
        sig = grid()
        model = FunctionModel(sig, {o: ("0", "1") for o in sig.objects},
                              {a: ("1", "0") for a in sig.horizontal},
                              {a: ("1", "0") for a in sig.vertical})
        a = sig.atom("s00")
        proofs = [sig.axiom("hassoc", *(sig.atom(n) for n in ("s00", "s01", "s02"))),
                  sig.axiom("vassoc", *(sig.atom(n) for n in ("s00", "s10", "s20"))),
                  sig.axiom("exchange", *(sig.atom(n) for n in ("s00", "s01", "s10", "s11"))),
                  sig.axiom("hid_comp", sig.path("v", "o00", "v00"), sig.path("v", "o10", "v10")),
                  sig.axiom("vid_comp", sig.path("h", "o00", "h00"), sig.path("h", "o01", "h01")),
                  sig.axiom("double_unit", "o00")]
        proofs.extend(sig.axiom(rule, a) for rule in ("hunit_left", "hunit_right", "vunit_top", "vunit_bottom"))
        proofs.extend((reflexivity(a), symmetry(proofs[0]), transitivity(proofs[0], symmetry(proofs[0])),
                       congruence("h", sig.axiom("hunit_left", a), reflexivity(sig.atom("s01"))),
                       congruence("v", sig.axiom("hunit_left", a), reflexivity(sig.atom("s10")))))
        count_model = EventCountModel(sig)
        for proof in proofs:
            with self.subTest(rule=proof.rule):
                self.assertTrue(model.respects(proof))
                self.assertTrue(count_model.respects(proof))


class DirectedRewriteTests(unittest.TestCase):
    def setUp(self):
        self.sig = event_signature()
        self.p, self.q, self.r, self.s = (self.sig.atom(n) for n in ("p", "q", "r", "s"))
        self.theory = RewriteTheory(self.sig, (RewriteRule("pq", self.p, self.q), RewriteRule("qr", self.q, self.r), RewriteRule("pr", self.p, self.r)))

    def test_rule_requires_parallel_two_dimensional_boundaries(self):
        with self.assertRaises(KernelError):
            RewriteTheory(self.sig, (RewriteRule("bad", self.p, self.s),))

    def test_rewrite_in_a_nested_context_preserves_external_boundary(self):
        source = self.sig.h(self.sig.h(self.p, self.p), self.s)
        step = self.theory.apply("pq", source, (0, 1))
        self.assertEqual(step.target, self.sig.h(self.sig.h(self.p, self.q), self.s))
        self.assertEqual(self.sig.boundary(source), self.sig.boundary(step.target))
        self.assertTrue(self.theory.verify_step(step))

    def test_rewrite_direction_and_concrete_match_are_enforced(self):
        with self.assertRaises(KernelError):
            self.theory.apply("pq", self.q)
        with self.assertRaises(KernelError):
            self.theory.apply("unknown", self.p)
        with self.assertRaises(KernelError):
            self.theory.apply("pq", self.p, (0,))

    def test_step_target_cannot_be_forged(self):
        with self.assertRaises(KernelError):
            self.theory.verify_step(RewriteStep("pq", self.p, self.r))
        with self.assertRaises(AttributeError):
            self.theory.rules = {}

    def test_trace_is_associative_unital_and_keeps_history(self):
        first = self.theory.trace(self.theory.apply("pq", self.p))
        second = self.theory.trace(self.theory.apply("qr", self.q))
        end = self.theory.identity(self.r)
        self.assertEqual(self.theory.then(self.theory.then(first, second), end),
                         self.theory.then(first, self.theory.then(second, end)))
        two_steps = self.theory.then(first, second)
        direct = self.theory.trace(self.theory.apply("pr", self.p))
        self.assertEqual((two_steps.source, two_steps.target), (direct.source, direct.target))
        self.assertNotEqual(two_steps, direct)
        self.assertEqual(self.theory.then(self.theory.identity(self.p), two_steps), two_steps)

    def test_trace_rejects_gaps_and_fake_empty_path(self):
        pq = self.theory.apply("pq", self.p)
        pr = self.theory.apply("pr", self.p)
        with self.assertRaises(KernelError):
            self.theory.verify_trace(RewriteTrace(self.p, self.r, (pq, pr)))
        with self.assertRaises(KernelError):
            self.theory.verify_trace(RewriteTrace(self.p, self.q))

    def test_directed_steps_and_structural_equalities_are_distinct_types(self):
        step = self.theory.apply("pq", self.p)
        with self.assertRaises(KernelError):
            self.sig.verify(step)
        with self.assertRaises(KernelError):
            self.theory.verify_step(reflexivity(self.p))


class FunctionModelTests(unittest.TestCase):
    def test_rejects_noncommuting_generator_interpretation(self):
        sig = grid(1)
        horizontal = {a: ("0", "1") for a in sig.horizontal}
        vertical = {a: ("0", "1") for a in sig.vertical}
        vertical["v01"] = ("1", "0")
        with self.assertRaises(KernelError):
            FunctionModel(sig, {o: ("0", "1") for o in sig.objects}, horizontal, vertical)

    def test_rejects_partial_or_nontotal_semantics(self):
        sig = event_signature()
        with self.assertRaises(KernelError):
            FunctionModel(sig, {"A": ("0", "1")}, {"f": ("0", "1")}, {})
        with self.assertRaises(KernelError):
            FunctionModel(sig, {"A": ("0", "1")}, {"f": ("0",), "g": ("0", "1")}, {})
        with self.assertRaises(KernelError):
            FiniteMap("A", "A", ("0",), ("0",), ("outside",))

    def test_thin_observation_is_explicitly_not_faithful(self):
        sig = event_signature()
        model = FunctionModel(sig, {"A": ("0", "1")}, {"f": ("1", "0"), "g": ("0", "0")}, {})
        p, q = sig.atom("p"), sig.atom("q")
        self.assertNotEqual(p, q)
        self.assertEqual(model.interpret(p), model.interpret(q))
        self.assertNotEqual(model.interpret(sig.h(p, sig.atom("s"))), model.interpret(sig.h(sig.atom("s"), p)))

    def test_empty_signature_and_empty_carriers_are_supported(self):
        self.assertEqual(Signature(()).objects, frozenset())
        sig = event_signature()
        model = FunctionModel(sig, {"A": ()}, {"f": (), "g": ()}, {})
        self.assertTrue(model.respects(sig.axiom("double_unit", "A")))


if __name__ == "__main__":
    unittest.main()
