"""Unit tests for guarded_alignment.double_kernel (T1, T2, Cor 4.0, Lem 6, T9)."""

from __future__ import annotations

import unittest

from guarded_alignment.double_kernel import (
    AssocH,
    AssocR,
    AssocV,
    AssocH3,
    AssocV3,
    Cell3GenSpec,
    CompH,
    CompH3,
    CompR,
    CompV,
    CompV3,
    CongH,
    CongH3,
    CongR,
    CongV,
    CongV3,
    Double3Sig,
    DoubleSig,
    Frame,
    Gen,
    Gen3,
    Id3,
    Id3CompH,
    Id3CompV,
    IdH,
    IdH3L,
    IdH3R,
    IdHCompV,
    IdHIdV,
    IdHL,
    IdHR,
    IdRL,
    IdRR,
    IdV,
    IdV3L,
    IdV3R,
    IdVCompH,
    IdVL,
    IdVR,
    Interchange,
    InterchangeHR,
    InterchangeHV,
    InterchangeVR,
    KernelError,
    Refl,
    Refl3,
    Symm,
    Symm3,
    Trans,
    Trans3,
    Transport3,
    TransportBase,
    TypedPath,
    check_3d_irreversibility,
    check_endpoints3,
    check_eq3_cert,
    check_eq_cert,
    check_weight_separation,
    extract_base_conservativity_cert,
    find_tally_separator,
    infer_frame,
    term_weight,
    verify_eq_cert,
)


def _grid_sig() -> DoubleSig:
    objs = frozenset(f"o{r}{c}" for r in range(4) for c in range(4))
    h_gens = {f"h{r}{c}": (f"o{r}{c}", f"o{r}{c+1}") for r in range(4) for c in range(3)}
    v_gens = {f"v{r}{c}": (f"o{r}{c}", f"o{r+1}{c}") for r in range(3) for c in range(4)}
    stub = DoubleSig(objs=objs, h_gens=h_gens, v_gens=v_gens, sq_gens={})
    sq_gens: dict[str, Frame] = {}
    for r in range(3):
        for c in range(3):
            sq_gens[f"a{r}{c}"] = Frame(
                tl=f"o{r}{c}",
                tr=f"o{r}{c+1}",
                bl=f"o{r+1}{c}",
                br=f"o{r+1}{c+1}",
                top=stub.h_path(f"o{r}{c}", f"h{r}{c}"),
                bot=stub.h_path(f"o{r+1}{c}", f"h{r+1}{c}"),
                left=stub.v_path(f"o{r}{c}", f"v{r}{c}"),
                right=stub.v_path(f"o{r}{c+1}", f"v{r}{c+1}"),
            )
    sq_gens["a00_alt"] = sq_gens["a00"]
    return DoubleSig(objs=objs, h_gens=h_gens, v_gens=v_gens, sq_gens=sq_gens)


class TestDoubleKernel(unittest.TestCase):
    def setUp(self) -> None:
        self.sig = _grid_sig()

    def test_nil_paths_distinct_across_objects(self) -> None:
        self.assertNotEqual(TypedPath.nil("o00"), TypedPath.nil("o01"))
        self.assertNotEqual(infer_frame(self.sig, IdH(TypedPath.nil("o00"))),
                            infer_frame(self.sig, IdH(TypedPath.nil("o01"))))

    def test_t1_unique_framing_and_boundary_rejection(self) -> None:
        p, q = Gen("a00"), Gen("a01")
        f = infer_frame(self.sig, CompH(p, q))
        self.assertEqual((f.tl, f.tr, f.bl, f.br), ("o00", "o02", "o10", "o12"))
        self.assertEqual(f.top.edges, ("h00", "h01"))
        # Mismatched CompH rejected
        with self.assertRaises(KernelError):
            infer_frame(self.sig, CompH(Gen("a00"), Gen("a11")))
        # Mismatched CompV rejected
        with self.assertRaises(KernelError):
            infer_frame(self.sig, CompV(Gen("a00"), Gen("a01")))

    def test_all_10_eq_cert_laws_preserve_frame_and_tally(self) -> None:
        sig = self.sig
        a00, a01, a02 = Gen("a00"), Gen("a01"), Gen("a02")
        a10, a11, a20 = Gen("a10"), Gen("a11"), Gen("a20")
        weights = {k: i + 1 for i, k in enumerate(sorted(sig.sq_gens))}

        certs = [
            AssocH(a00, a01, a02),
            IdHL(a00),
            IdHR(a00),
            AssocV(a00, a10, a20),
            IdVL(a00),
            IdVR(a00),
            Interchange(a00, a01, a10, a11),
            IdHCompV(sig.v_path("o00", "v00"), sig.v_path("o10", "v10")),
            IdVCompH(sig.h_path("o00", "h00"), sig.h_path("o01", "h01")),
            IdHIdV("o00"),
            CongH(IdHL(a00), Refl(a01)),
            CongV(IdVL(a00), Symm(IdVR(a10))),
            Trans(AssocH(a00, a01, a02), Symm(AssocH(a00, a01, a02))),
        ]
        for cert in certs:
            res = check_eq_cert(sig, cert)
            self.assertEqual(infer_frame(sig, res.lhs), res.frame)
            self.assertEqual(infer_frame(sig, res.rhs), res.frame)
            self.assertEqual(term_weight(res.lhs, weights), term_weight(res.rhs, weights))

    def test_cor4_0_same_frame_generator_separation(self) -> None:
        lhs, rhs = Gen("a00"), Gen("a00_alt")
        self.assertEqual(infer_frame(self.sig, lhs), infer_frame(self.sig, rhs))
        wit = find_tally_separator(self.sig, lhs, rhs)
        self.assertIsNotNone(wit)
        assert wit is not None
        self.assertTrue(wit.same_frame)
        self.assertNotEqual(wit.lhs_weight, wit.rhs_weight)
        # Explicit custom weights check
        wit2 = check_weight_separation(self.sig, lhs, rhs, {"a00": 0, "a00_alt": 1})
        self.assertIsNotNone(wit2)
        assert wit2 is not None
        self.assertEqual((wit2.lhs_weight, wit2.rhs_weight), (0, 1))

    def test_relative_3d_lem6_t9_and_irreversibility(self) -> None:
        sig = self.sig
        a00, a00_alt = Gen("a00"), Gen("a00_alt")
        a01, a10, a11 = Gen("a01"), Gen("a10"), Gen("a11")
        sig3 = Double3Sig(
            base=sig,
            cell3_gens={
                "rho": Cell3GenSpec(a00, a00_alt),
                "tau": Cell3GenSpec(a00_alt, a00_alt),
            },
        )
        g_rho = Gen3("rho")
        g_tau = Gen3("tau")
        ep = check_endpoints3(sig3, CompR(g_rho, g_tau))
        self.assertEqual((ep.src, ep.tgt), (a00, a00_alt))

        # Check rich Eq3Cert rules preserve endpoints modulo 2D EqCert (Lem 6)
        c3_certs = [
            Refl3(g_rho),
            Symm3(IdRL(g_rho)),
            Trans3(IdRL(g_rho), Symm3(IdRR(g_rho))),
            TransportBase(g_rho, Symm(IdHL(a00)), Symm(IdHR(a00_alt))),
            AssocR(g_rho, g_tau, Id3(a00_alt)),
            AssocH3(g_rho, Id3(a01), Id3(Gen("a02"))),
            IdH3L(g_rho),
            IdH3R(g_rho),
            AssocV3(g_rho, Id3(a10), Id3(Gen("a20"))),
            IdV3L(g_rho),
            IdV3R(g_rho),
            InterchangeHV(g_rho, Id3(a01), Id3(a10), Id3(a11)),
            InterchangeHR(g_rho, g_tau, Id3(a01), Id3(a01)),
            InterchangeVR(g_rho, g_tau, Id3(a10), Id3(a10)),
            Id3CompH(a00, a01),
            Id3CompV(a00, a10),
            CongR(IdRL(g_rho), Refl3(g_tau)),
            CongH3(IdRL(g_rho), Refl3(Id3(a01))),
            CongV3(IdRL(g_rho), Refl3(Id3(a10))),
        ]
        for c3 in c3_certs:
            res = check_eq3_cert(sig3, c3)
            verify_eq_cert(sig, res.src_eq_cert, res.lhs_endpoints.src, res.rhs_endpoints.src)
            verify_eq_cert(sig, res.tgt_eq_cert, res.lhs_endpoints.tgt, res.rhs_endpoints.tgt)

        # T9 base conservativity on genuine non-trivial Id3(lhs2) === Id3(rhs2) via InterchangeHV!
        lhs2 = CompV(CompH(a00, a01), CompH(a10, a11))
        rhs2 = CompH(CompV(a00, a10), CompV(a01, a11))
        step1 = Id3CompV(CompH(a00, a01), CompH(a10, a11))
        step2 = CongV3(Id3CompH(a00, a01), Id3CompH(a10, a11))
        step3 = InterchangeHV(Id3(a00), Id3(a01), Id3(a10), Id3(a11))
        step4 = CongH3(Symm3(Id3CompV(a00, a10)), Symm3(Id3CompV(a01, a11)))
        step5 = Symm3(Id3CompH(CompV(a00, a10), CompV(a01, a11)))
        t9_cert = Trans3(step1, Trans3(step2, Trans3(step3, Trans3(step4, step5))))
        base_res = extract_base_conservativity_cert(sig3, t9_cert)
        self.assertEqual(base_res.lhs, lhs2)
        self.assertEqual(base_res.rhs, rhs2)

        # 3D irreversibility via monotone tally (no reverse Cell3Term from a00_alt to a00)
        sig3_irr = Double3Sig(base=sig, cell3_gens={"rho": Cell3GenSpec(a00, a00_alt)})
        w_mono = {g: (1 if g == "a00_alt" else 0) for g in sig.sq_gens}
        iw = check_3d_irreversibility(sig3_irr, a00_alt, a00, w_mono)
        self.assertIsNotNone(iw)
        assert iw is not None
        self.assertEqual((iw.src_weight, iw.tgt_weight), (1, 0))
        self.assertIsNone(check_3d_irreversibility(sig3_irr, a00, a00_alt, w_mono))


if __name__ == "__main__":
    unittest.main()
