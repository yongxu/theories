"""Unit tests for guarded_alignment.oplax_history (chi, BC, emergent, C2, GuardedProof)."""

from __future__ import annotations

import unittest

from guarded_alignment.oplax_history import (
    Assemble,
    AssembleCong,
    Atom,
    BijCert,
    ChiInv,
    ChiStep,
    GuardedInterchangeError,
    IdExpr,
    Par,
    ParCong,
    ParSeqDistLR,
    ParSeqDistRL,
    PullbackElem,
    ReflProof,
    RelSpan,
    Seq,
    SeqCong,
    TransProof,
    analyze_chi,
    c2_pow_two_to_one_witness,
    c2_two_to_one_witness,
    collapse_nonempty_functor,
    comp_span,
    emergent_two_to_four_witness,
    emergent_zero_to_one_witness,
    eval_guarded_expr,
    eval_guarded_proof,
    identity_functor,
    product_with_const_functor,
    synthesize_bij_cert,
)


def _sample_spans() -> tuple[RelSpan, RelSpan]:
    h = RelSpan.create(
        left_dom=("a0", "a1"),
        right_dom=("d0", "d1"),
        carrier=("w0", "w1"),
        left={"w0": "a0", "w1": "a1"},
        right={"w0": "d0", "w1": "d1"},
        name="H",
    )
    k = RelSpan.create(
        left_dom=("d0", "d1"),
        right_dom=("c0", "c1"),
        carrier=("v0", "v1"),
        left={"v0": "d0", "v1": "d1"},
        right={"v0": "c0", "v1": "c1"},
        name="K",
    )
    return h, k


class TestOplaxHistory(unittest.TestCase):
    def test_emergent_witnesses_zero_to_one_and_two_to_four(self) -> None:
        d01 = emergent_zero_to_one_witness()
        self.assertEqual((d01.domain_size, d01.codomain_size), (0, 1))
        self.assertTrue(d01.is_injective)
        self.assertFalse(d01.is_surjective)
        self.assertFalse(d01.is_bijective)
        self.assertFalse(d01.f_image_is_pullback)
        self.assertFalse(d01.universal_bc_holds)
        self.assertTrue(d01.empty_family_vacuously_bijective)
        self.assertIsNotNone(d01.emergent_witness)
        self.assertIsNotNone(d01.bc_failure)

        d24 = emergent_two_to_four_witness()
        self.assertEqual((d24.domain_size, d24.codomain_size), (2, 4))
        self.assertTrue(d24.is_injective)
        self.assertFalse(d24.is_surjective)
        self.assertFalse(d24.f_image_is_pullback)
        self.assertFalse(d24.universal_bc_holds)
        self.assertEqual(d24.emergent_witness, PullbackElem(False, True))

    def test_c2_witnesses_two_to_one_and_pow_two_to_one(self) -> None:
        d21 = c2_two_to_one_witness()
        self.assertEqual((d21.domain_size, d21.codomain_size), (2, 1))
        self.assertFalse(d21.is_injective)
        self.assertTrue(d21.is_surjective)
        self.assertFalse(d21.f_image_is_pullback)
        self.assertFalse(d21.universal_bc_holds)
        self.assertTrue(d21.empty_family_vacuously_bijective)
        self.assertIsNotNone(d21.collision_witness)

        for n in (1, 2, 3, 4):
            dn = c2_pow_two_to_one_witness(n)
            self.assertEqual((dn.domain_size, dn.codomain_size), (2**n, 1))
            self.assertFalse(dn.is_injective)
            self.assertTrue(dn.is_surjective)
            self.assertFalse(dn.universal_bc_holds)

    def test_functor_laws_and_chi_bijective_iff_bc_all(self) -> None:
        h, k = _sample_spans()
        id_f = identity_functor()
        prod_f = product_with_const_functor(("t0", "t1"))
        col_f = collapse_nonempty_functor()

        for f in (id_f, prod_f, col_f):
            f.verify_laws(
                domains=[h.left_dom, h.right_dom, h.carrier],
                composable_pairs=[
                    (h.carrier, h.right_dom, h.right_dom, h.right_map, {"d0": "d0", "d1": "d1"})
                ],
            )

        # Pullback-preserving functors pass chi, FImageIsPullback, and universal BC
        for good_f in (id_f, prod_f):
            diag = analyze_chi(good_f, h, k)
            self.assertTrue(diag.is_bijective)
            self.assertTrue(diag.f_image_is_pullback)
            self.assertTrue(diag.universal_bc_holds)

        # Disjoint-middle collapse creates emergent 0 -> 1 history!
        h_disj = RelSpan.create(("a",), ("d0", "d1"), ("w",), {"w": "a"}, {"w": "d0"}, name="Hd")
        k_disj = RelSpan.create(("d0", "d1"), ("c",), ("v",), {"v": "d1"}, {"v": "c"}, name="Kd")
        bad_diag = analyze_chi(col_f, h_disj, k_disj)
        self.assertEqual((bad_diag.domain_size, bad_diag.codomain_size), (0, 1))
        self.assertFalse(bad_diag.is_bijective)
        self.assertFalse(bad_diag.f_image_is_pullback)
        self.assertFalse(bad_diag.universal_bc_holds)
        self.assertTrue(bad_diag.empty_family_vacuously_bijective)

    def test_guarded_proof_strong_par_seq_and_guarded_chi_inv(self) -> None:
        h, k = _sample_spans()
        e1, e2 = Atom(h), Atom(k)

        # Strong two-sided par/seq distributivity is ALWAYS valid
        lr = eval_guarded_proof(ParSeqDistLR(e1, e2, e1, e2))
        rl = eval_guarded_proof(ParSeqDistRL(e1, e2, e1, e2))
        rt = eval_guarded_proof(TransProof(ParSeqDistLR(e1, e2, e1, e2), ParSeqDistRL(e1, e2, e1, e2)))
        for x in rt.span_hom.src.carrier:
            self.assertEqual(rt.span_hom.apply(x), x)
        self.assertEqual(len(lr.span_hom.src.carrier), len(rl.span_hom.src.carrier))

        # Congruence & idExpr sanity
        self.assertEqual(len(eval_guarded_expr(IdExpr(("a", "b"))).carrier), 2)
        eval_guarded_proof(SeqCong(ReflProof(e1), ReflProof(e2)))
        eval_guarded_proof(ParCong(ReflProof(e1), ReflProof(e2)))
        eval_guarded_proof(AssembleCong(identity_functor(), ReflProof(e1)))

        # One-way ChiStep always works
        prod_f = product_with_const_functor(("ctx0", "ctx1"))
        step = eval_guarded_proof(ChiStep(prod_f, e1, e2))
        self.assertEqual(step.src_expr, Assemble(prod_f, Seq(e1, e2)))

        # Unguarded ChiInv MUST be rejected even when functor IS pullback-preserving
        with self.assertRaises(GuardedInterchangeError):
            eval_guarded_proof(ChiInv(prod_f, e1, e2, bij_cert=None))

        # Forged BijCert MUST be rejected
        with self.assertRaises(GuardedInterchangeError):
            eval_guarded_proof(ChiInv(prod_f, e1, e2, bij_cert=BijCert({}, {})))

        # Explicit verified BijCert upgrades ChiInv and certifies BC
        bij = synthesize_bij_cert(prod_f, h, k)
        self.assertIsNotNone(bij)
        upgraded = eval_guarded_proof(ChiInv(prod_f, e1, e2, bij_cert=bij))
        self.assertEqual(len(upgraded.verified_bc_guards), 1)
        self.assertTrue(upgraded.verified_bc_guards[0].universal_bc_holds)

        # On a non-pullback-preserving collapse functor, no BijCert exists
        col_f = collapse_nonempty_functor()
        h_disj = RelSpan.create(("a",), ("d0", "d1"), ("w",), {"w": "a"}, {"w": "d0"})
        k_disj = RelSpan.create(("d0", "d1"), ("c",), ("v",), {"v": "d1"}, {"v": "c"})
        self.assertIsNone(synthesize_bij_cert(col_f, h_disj, k_disj))
        self.assertEqual(len(comp_span(h_disj, k_disj).carrier), 0)
        with self.assertRaises(GuardedInterchangeError) as ctx:
            eval_guarded_proof(ChiInv(col_f, Atom(h_disj), Atom(k_disj), bij_cert=None))
        self.assertIsNotNone(ctx.exception.diagnostics)
        assert ctx.exception.diagnostics is not None
        self.assertFalse(ctx.exception.diagnostics.is_surjective)


if __name__ == "__main__":
    unittest.main()
