"""Declarative Human/AI pipeline DSL and structured diagnostic reports.

AI-written (Wave U6 runtime, 24 November 2026). Pure Python 3 standard library.
Provides crisp ``PROVED`` / ``GUARDED`` / ``OBSTRUCTED`` verdicts naming exact missing
guards, counterexample witnesses, and ``AGENTS.md`` Rule 2 assumption boundaries.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from enum import Enum
from fractions import Fraction
from typing import Any, Mapping

from .double_kernel import (
    AssocH,
    AssocV,
    Cell3GenSpec,
    CompH,
    CompV,
    CongH,
    CongV,
    Double3Sig,
    DoubleSig,
    EqCert,
    Frame,
    Gen,
    Gen3,
    Id3,
    IdH,
    IdHCompV,
    IdHIdV,
    IdHL,
    IdHR,
    IdV,
    IdVCompH,
    IdVL,
    IdVR,
    Interchange,
    KernelError,
    Refl,
    SqTerm,
    Symm,
    Trans,
    TypedPath,
    check_3d_irreversibility,
    check_endpoints3,
    check_eq_cert,
    check_weight_separation,
    find_tally_separator,
    infer_frame,
)
from .observational_fidelity import (
    FidelityError,
    FinDist,
    QuerySpec,
    check_coarsening,
    check_fiber_viability_split,
    check_macro_refinement,
    check_multi_query_feasibility,
    contractive_tube_bound,
    metric_slack,
    query_tv_floor,
    to_fraction,
)
from .oplax_history import (
    Atom,
    BijCert,
    ChiInv,
    ChiSquare,
    ChiStep,
    GuardedInterchangeError,
    OplaxError,
    PullbackElem,
    RelSpan,
    SeamHom,
    SeamObj,
    Seq,
    SpanFunctor,
    analyze_chi,
    analyze_chi_square,
    c2_pow_two_to_one_witness,
    c2_two_to_one_witness,
    collapse_nonempty_functor,
    emergent_two_to_four_witness,
    emergent_zero_to_one_witness,
    eval_guarded_proof,
    identity_functor,
    product_with_const_functor,
    seam_pullback_chi_square,
    synthesize_bij_cert,
)


class Verdict(str, Enum):
    """Three-state formal runtime verdict."""

    PROVED = "PROVED"
    GUARDED = "GUARDED"
    OBSTRUCTED = "OBSTRUCTED"


def _json_safe(obj: Any) -> Any:
    if isinstance(obj, Fraction):
        return f"{obj.numerator}/{obj.denominator}" if obj.denominator != 1 else str(obj.numerator)
    if isinstance(obj, Enum):
        return obj.value
    if isinstance(obj, PullbackElem):
        return [_json_safe(obj.fst), _json_safe(obj.snd)]
    if isinstance(obj, FinDist):
        return {str(k): _json_safe(v) for k, v in obj.weights.items()}
    if isinstance(obj, dict):
        return {str(k): _json_safe(v) for k, v in obj.items()}
    if isinstance(obj, (list, tuple)):
        return [_json_safe(x) for x in obj]
    return obj


@dataclass(frozen=True)
class CheckItem:
    """Single atomic formal check inside a diagnostic report."""

    label: str
    verdict: Verdict
    detail: str
    missing_guard: str | None = None
    witness: dict[str, Any] = field(default_factory=dict)

    def to_dict(self) -> dict[str, Any]:
        out: dict[str, Any] = {
            "label": self.label,
            "verdict": self.verdict.value,
            "detail": self.detail,
        }
        if self.missing_guard is not None:
            out["missing_guard"] = self.missing_guard
        if self.witness:
            out["witness"] = _json_safe(self.witness)
        return out


@dataclass(frozen=True)
class DiagnosticReport:
    """Structured report for a pipeline specification or alignment witness."""

    name: str
    verdict: Verdict
    summary: str
    checks: tuple[CheckItem, ...]
    rule2_boundary: str

    def to_dict(self) -> dict[str, Any]:
        return {
            "name": self.name,
            "verdict": self.verdict.value,
            "summary": self.summary,
            "checks": [c.to_dict() for c in self.checks],
            "rule2_boundary": self.rule2_boundary,
        }

    def format_text(self) -> str:
        lines = [
            f"[{self.verdict.value}] {self.name}",
            f"Summary: {self.summary}",
            "Checks:",
        ]
        for chk in self.checks:
            lines.append(f"  - [{chk.verdict.value}] {chk.label}: {chk.detail}")
            if chk.missing_guard:
                lines.append(f"      missing_guard: {chk.missing_guard}")
            if chk.witness:
                lines.append(f"      witness: {_json_safe(chk.witness)}")
        lines.append(f"Rule 2 boundary: {self.rule2_boundary}")
        return "\n".join(lines)


def combine_verdicts(checks: tuple[CheckItem, ...]) -> Verdict:
    """Aggregate atomic check verdicts: any OBSTRUCTED dominates, else any GUARDED, else PROVED."""
    if any(c.verdict == Verdict.OBSTRUCTED for c in checks):
        return Verdict.OBSTRUCTED
    if any(c.verdict == Verdict.GUARDED for c in checks):
        return Verdict.GUARDED
    return Verdict.PROVED


# --- Declarative JSON Spec Evaluators ---


def _parse_sq_term(sig: DoubleSig, node: Any) -> SqTerm:
    if isinstance(node, str):
        return Gen(node)
    if not isinstance(node, Mapping):
        raise KernelError(f"Expected SqTerm mapping or generator string, got {node!r}")
    op = node.get("op")
    if op == "gen":
        return Gen(str(node["name"]))
    if op == "idH":
        return IdH(sig.v_path(str(node["src"]), *node.get("edges", ())))
    if op == "idV":
        return IdV(sig.h_path(str(node["src"]), *node.get("edges", ())))
    if op == "compH":
        return CompH(_parse_sq_term(sig, node["left"]), _parse_sq_term(sig, node["right"]))
    if op == "compV":
        return CompV(_parse_sq_term(sig, node["top"]), _parse_sq_term(sig, node["bot"]))
    raise KernelError(f"Unknown SqTerm op {op!r}")


def _parse_eq_cert(sig: DoubleSig, node: Mapping[str, Any]) -> EqCert:
    rule = node.get("rule")
    if rule == "refl":
        return Refl(_parse_sq_term(sig, node["term"]))
    if rule == "symm":
        return Symm(_parse_eq_cert(sig, node["cert"]))
    if rule == "trans":
        return Trans(_parse_eq_cert(sig, node["first"]), _parse_eq_cert(sig, node["second"]))
    if rule == "congH":
        return CongH(_parse_eq_cert(sig, node["left"]), _parse_eq_cert(sig, node["right"]))
    if rule == "congV":
        return CongV(_parse_eq_cert(sig, node["top"]), _parse_eq_cert(sig, node["bot"]))
    if rule == "assocH":
        return AssocH(
            _parse_sq_term(sig, node["p"]),
            _parse_sq_term(sig, node["q"]),
            _parse_sq_term(sig, node["r"]),
        )
    if rule == "assocV":
        return AssocV(
            _parse_sq_term(sig, node["p"]),
            _parse_sq_term(sig, node["q"]),
            _parse_sq_term(sig, node["r"]),
        )
    if rule == "idH_l":
        return IdHL(_parse_sq_term(sig, node["p"]))
    if rule == "idH_r":
        return IdHR(_parse_sq_term(sig, node["p"]))
    if rule == "idV_l":
        return IdVL(_parse_sq_term(sig, node["p"]))
    if rule == "idV_r":
        return IdVR(_parse_sq_term(sig, node["p"]))
    if rule == "interchange":
        return Interchange(
            _parse_sq_term(sig, node["p"]),
            _parse_sq_term(sig, node["q"]),
            _parse_sq_term(sig, node["r"]),
            _parse_sq_term(sig, node["s"]),
        )
    if rule == "idH_compV":
        u = sig.v_path(str(node["u"]["src"]), *node["u"].get("edges", ()))
        v = sig.v_path(str(node["v"]["src"]), *node["v"].get("edges", ()))
        return IdHCompV(u, v)
    if rule == "idV_compH":
        f = sig.h_path(str(node["f"]["src"]), *node["f"].get("edges", ()))
        g = sig.h_path(str(node["g"]["src"]), *node["g"].get("edges", ()))
        return IdVCompH(f, g)
    if rule == "idH_idV":
        return IdHIdV(str(node["obj"]))
    raise KernelError(f"Unknown EqCert rule {rule!r}")


def _eval_strict_kernel_spec(spec: Mapping[str, Any]) -> DiagnosticReport:
    name = str(spec.get("name", "strict_kernel_pipeline"))
    checks: list[CheckItem] = []
    objs = frozenset(str(x) for x in spec["objs"])
    h_gens = {str(k): (str(v[0]), str(v[1])) for k, v in spec.get("h_gens", {}).items()}
    v_gens = {str(k): (str(v[0]), str(v[1])) for k, v in spec.get("v_gens", {}).items()}
    base_stub = DoubleSig(objs=objs, h_gens=h_gens, v_gens=v_gens, sq_gens={})
    sq_gens: dict[str, Frame] = {}
    for gname, fspec in spec.get("sq_gens", {}).items():
        top = base_stub.h_path(str(fspec["tl"]), *fspec.get("top", ()))
        bot = base_stub.h_path(str(fspec["bl"]), *fspec.get("bot", ()))
        left = base_stub.v_path(str(fspec["tl"]), *fspec.get("left", ()))
        right = base_stub.v_path(str(fspec["tr"]), *fspec.get("right", ()))
        sq_gens[str(gname)] = Frame(
            tl=str(fspec["tl"]),
            tr=str(fspec["tr"]),
            bl=str(fspec["bl"]),
            br=str(fspec["br"]),
            top=top,
            bot=bot,
            left=left,
            right=right,
        )
    sig = DoubleSig(objs=objs, h_gens=h_gens, v_gens=v_gens, sq_gens=sq_gens)

    for c_idx, c_spec in enumerate(spec.get("eq_certs", ())):
        label = str(c_spec.get("label", f"eq_cert_{c_idx}"))
        try:
            res = check_eq_cert(sig, _parse_eq_cert(sig, c_spec["cert"]))
            checks.append(
                CheckItem(
                    label=label,
                    verdict=Verdict.PROVED,
                    detail=f"EqCert verified with preserved frame ({res.frame.tl}->{res.frame.br})",
                    witness={"frame_corners": [res.frame.tl, res.frame.tr, res.frame.bl, res.frame.br]},
                )
            )
        except KernelError as exc:
            checks.append(
                CheckItem(
                    label=label,
                    verdict=Verdict.OBSTRUCTED,
                    detail=str(exc),
                    missing_guard="valid_2d_eq_cert",
                )
            )

    for s_idx, s_spec in enumerate(spec.get("tally_separations", ())):
        label = str(s_spec.get("label", f"tally_sep_{s_idx}"))
        lhs = _parse_sq_term(sig, s_spec["lhs"])
        rhs = _parse_sq_term(sig, s_spec["rhs"])
        if "weights" in s_spec:
            weights = {str(k): int(v) for k, v in s_spec["weights"].items()}
            wit = check_weight_separation(sig, lhs, rhs, weights)
        else:
            wit = find_tally_separator(sig, lhs, rhs)
        if wit is not None:
            checks.append(
                CheckItem(
                    label=label,
                    verdict=Verdict.OBSTRUCTED,
                    detail=(
                        f"Uncertified equality refuted via natTallyDoubleCat (Cor 4.0): "
                        f"weight(lhs)={wit.lhs_weight} != weight(rhs)={wit.rhs_weight} "
                        f"(same_frame={wit.same_frame})"
                    ),
                    missing_guard="no_strict_2d_eq_cert_exists",
                    witness={
                        "weights": wit.weights,
                        "lhs_weight": wit.lhs_weight,
                        "rhs_weight": wit.rhs_weight,
                        "same_frame": wit.same_frame,
                    },
                )
            )
        else:
            checks.append(
                CheckItem(
                    label=label,
                    verdict=Verdict.GUARDED,
                    detail="Generator tally did not separate lhs and rhs (non-refutation only)",
                )
            )

    if "cell3_gens" in spec:
        c3_gens = {
            str(k): Cell3GenSpec(_parse_sq_term(sig, v["src"]), _parse_sq_term(sig, v["tgt"]))
            for k, v in spec["cell3_gens"].items()
        }
        sig3 = Double3Sig(base=sig, cell3_gens=c3_gens)
        for gname in c3_gens:
            ep = check_endpoints3(sig3, Gen3(gname))
            checks.append(
                CheckItem(
                    label=f"cell3_gen:{gname}",
                    verdict=Verdict.PROVED,
                    detail=f"Directed 3-cell generator {gname!r} has matching 2D frame",
                    witness={"frame_corners": [ep.frame.tl, ep.frame.tr, ep.frame.bl, ep.frame.br]},
                )
            )
        for irr in spec.get("irreversibility_checks", ()):
            label = str(irr.get("label", "irreversibility_3d"))
            src = _parse_sq_term(sig, irr["src"])
            tgt = _parse_sq_term(sig, irr["tgt"])
            weights = {str(k): int(v) for k, v in irr["weights"].items()}
            iw = check_3d_irreversibility(sig3, src, tgt, weights)
            if iw is not None:
                checks.append(
                    CheckItem(
                        label=label,
                        verdict=Verdict.OBSTRUCTED,
                        detail=(
                            f"Reverse 3-cell obstructed by monotone tally: "
                            f"weight(src)={iw.src_weight} > weight(tgt)={iw.tgt_weight}"
                        ),
                        missing_guard="reversible_3d_generator_absent",
                        witness={
                            "weights": iw.weights,
                            "src_weight": iw.src_weight,
                            "tgt_weight": iw.tgt_weight,
                        },
                    )
                )
            else:
                checks.append(
                    CheckItem(
                        label=label,
                        verdict=Verdict.GUARDED,
                        detail="Monotone tally did not obstruct reverse 3-cell",
                    )
                )

    tup = tuple(checks)
    v = combine_verdicts(tup)
    return DiagnosticReport(
        name=name,
        verdict=v,
        summary=f"Evaluated {len(tup)} strict 2D/3D kernel check(s); overall verdict {v.value}.",
        checks=tup,
        rule2_boundary=(
            "Checks finite symbolic EqCert/Eq3Cert derivations and natTallyDoubleCat invariants; "
            "does not establish that any real-world workflow obeys strict double interchange."
        ),
    )


def _build_span_from_spec(s: Mapping[str, Any]) -> RelSpan:
    return RelSpan.create(
        left_dom=s["left_dom"],
        right_dom=s["right_dom"],
        carrier=s["carrier"],
        left=s["left"],
        right=s["right"],
        name=str(s.get("name", "span")),
    )


def _build_functor_from_spec(fspec: Mapping[str, Any]) -> SpanFunctor:
    kind = fspec.get("kind", "identity")
    if kind == "identity":
        return identity_functor()
    if kind == "collapse_unit":
        return collapse_nonempty_functor(str(fspec.get("name", "CollapseUnit")))
    if kind == "product_const":
        tags = tuple(fspec["tags"])
        return product_with_const_functor(tags, name=str(fspec.get("name", "ProdConst")))
    raise OplaxError(f"Unsupported declarative SpanFunctor kind {kind!r}")


def _eval_oplax_guard_spec(spec: Mapping[str, Any]) -> DiagnosticReport:
    name = str(spec.get("name", "oplax_guard_pipeline"))
    mode = spec.get("mode", "functor")
    checks: list[CheckItem] = []

    if mode == "builtin_emergent_0_1":
        diag = emergent_zero_to_one_witness()
        checks.append(_chi_diag_to_check("emergent_0_to_1", diag, attempt_strict_upgrade=True))
    elif mode == "builtin_emergent_2_4":
        diag = emergent_two_to_four_witness()
        checks.append(_chi_diag_to_check("emergent_2_to_4", diag, attempt_strict_upgrade=True))
    elif mode == "builtin_c2_2_1":
        diag = c2_two_to_one_witness()
        checks.append(_chi_diag_to_check("c2_2_to_1", diag, attempt_strict_upgrade=True))
    elif mode == "builtin_c2_pow2":
        n = int(spec.get("n", 3))
        diag = c2_pow_two_to_one_witness(n)
        checks.append(_chi_diag_to_check(f"c2_2^{n}_to_1", diag, attempt_strict_upgrade=True))
    elif mode == "seam_pushout":
        mid_d = SeamObj(
            tuple(spec["mid_d"]["L"]),
            tuple(spec["mid_d"]["R"]),
            tuple(spec["mid_d"]["S"]),
            spec["mid_d"]["l_map"],
            spec["mid_d"]["r_map"],
        )
        step_w = SeamObj(
            tuple(spec["step_w"]["L"]),
            tuple(spec["step_w"]["R"]),
            tuple(spec["step_w"]["S"]),
            spec["step_w"]["l_map"],
            spec["step_w"]["r_map"],
        )
        step_v = SeamObj(
            tuple(spec["step_v"]["L"]),
            tuple(spec["step_v"]["R"]),
            tuple(spec["step_v"]["S"]),
            spec["step_v"]["l_map"],
            spec["step_v"]["r_map"],
        )
        r_w = SeamHom(step_w, mid_d, spec["r_w"]["f_l"], spec["r_w"]["f_r"], spec["r_w"]["f_s"])
        l_v = SeamHom(step_v, mid_d, spec["l_v"]["f_l"], spec["l_v"]["f_r"], spec["l_v"]["f_s"])
        diag = analyze_chi_square(seam_pullback_chi_square(r_w, l_v, label=name))
        checks.append(_chi_diag_to_check("seam_pushout_chi", diag, attempt_strict_upgrade=True))
    elif mode == "functor":
        h = _build_span_from_spec(spec["span_h"])
        k = _build_span_from_spec(spec["span_k"])
        functor = _build_functor_from_spec(spec["functor"])
        diag = analyze_chi(functor, h, k)
        supply_bij = bool(spec.get("supply_bij_cert", False))
        # Always verify one-way oplax chiStep
        eval_guarded_proof(ChiStep(functor, Atom(h), Atom(k)))
        checks.append(
            CheckItem(
                label="oplax_chi_step",
                verdict=Verdict.PROVED,
                detail=f"One-way oplax chiStep {functor.name}(H*K) -> {functor.name}(H)*{functor.name}(K) valid",
                witness={"domain_size": diag.domain_size, "codomain_size": diag.codomain_size},
            )
        )
        if spec.get("attempt_chi_inv", True):
            bij: BijCert | None = synthesize_bij_cert(functor, h, k) if supply_bij else None
            try:
                res = eval_guarded_proof(ChiInv(functor, Atom(h), Atom(k), bij_cert=bij))
                checks.append(
                    CheckItem(
                        label="guarded_chi_inv",
                        verdict=Verdict.GUARDED,
                        detail=(
                            f"Guarded ChiInv accepted under verified BijCert + FImageIsPullback + "
                            f"universal Beck-Chevalley ({len(res.verified_bc_guards)} guard(s))"
                        ),
                        witness={
                            "domain_size": diag.domain_size,
                            "codomain_size": diag.codomain_size,
                            "universal_bc_holds": diag.universal_bc_holds,
                        },
                    )
                )
            except GuardedInterchangeError as exc:
                miss = (
                    "explicit_bij_cert_and_bc_guard"
                    if diag.is_bijective
                    else "chi_bijectivity_and_universal_bc"
                )
                checks.append(
                    CheckItem(
                        label="guarded_chi_inv",
                        verdict=Verdict.OBSTRUCTED,
                        detail=str(exc),
                        missing_guard=miss,
                        witness=_chi_witness_dict(diag),
                    )
                )
    else:
        raise OplaxError(f"Unsupported oplax_guard mode {mode!r}")

    tup = tuple(checks)
    v = combine_verdicts(tup)
    return DiagnosticReport(
        name=name,
        verdict=v,
        summary=f"Evaluated oplax span/BC guard ({mode}); overall verdict {v.value}.",
        checks=tup,
        rule2_boundary=(
            "Certifies exact finite-set chi bijectivity, FImageIsPullback, and universal Beck-Chevalley; "
            "does not certify that an empirical system's macro abstraction matches this finite functor."
        ),
    )


def _chi_witness_dict(diag: Any) -> dict[str, Any]:
    out: dict[str, Any] = {
        "domain_size": diag.domain_size,
        "codomain_size": diag.codomain_size,
        "is_injective": diag.is_injective,
        "is_surjective": diag.is_surjective,
        "f_image_is_pullback": diag.f_image_is_pullback,
        "universal_bc_holds": diag.universal_bc_holds,
        "empty_family_vacuously_bijective": diag.empty_family_vacuously_bijective,
    }
    if diag.collision_witness is not None:
        out["collision_witness"] = list(diag.collision_witness)
    if diag.emergent_witness is not None:
        out["emergent_witness"] = diag.emergent_witness
    if diag.bc_failure is not None:
        out["bc_failure"] = {
            "family": diag.bc_failure.family_label,
            "fiber_v": diag.bc_failure.fiber_v,
            "reason": diag.bc_failure.reason,
        }
    return out


def _chi_diag_to_check(label: str, diag: Any, attempt_strict_upgrade: bool) -> CheckItem:
    if diag.is_bijective and diag.f_image_is_pullback and diag.universal_bc_holds:
        return CheckItem(
            label=label,
            verdict=Verdict.GUARDED,
            detail=(
                f"{diag.label}: chi ({diag.domain_size}->{diag.codomain_size}) is bijective; "
                f"FImageIsPullback and universal BC hold"
            ),
            witness=_chi_witness_dict(diag),
        )
    reasons: list[str] = []
    if not diag.is_injective:
        reasons.append("non-injective (relational collapse)")
    if not diag.is_surjective:
        reasons.append("non-surjective (emergent cross-seam history)")
    if diag.empty_family_vacuously_bijective:
        reasons.append("empty-family BC holds vacuously")
    guard = (
        "chi_bijectivity_and_universal_bc"
        if attempt_strict_upgrade
        else "pullback_preservation"
    )
    return CheckItem(
        label=label,
        verdict=Verdict.OBSTRUCTED,
        detail=f"{diag.label} ({diag.domain_size}->{diag.codomain_size}): " + "; ".join(reasons),
        missing_guard=guard,
        witness=_chi_witness_dict(diag),
    )


def _eval_fidelity_spec(spec: Mapping[str, Any]) -> DiagnosticReport:
    name = str(spec.get("name", "observational_fidelity_pipeline"))
    checks: list[CheckItem] = []

    if "query_floor" in spec:
        qf = spec["query_floor"]
        mu = FinDist.from_mapping(qf["mu"])
        rep = query_tv_floor(qf["chi"], qf["q"], mu, qf["src_carrier"])
        if not rep.feasible:
            checks.append(
                CheckItem(
                    label="query_tv_floor",
                    verdict=Verdict.OBSTRUCTED,
                    detail=rep.reason,
                    missing_guard="nonempty_local_carrier",
                    witness={"outside_observations": list(rep.outside_observations)},
                )
            )
        elif rep.floor > 0:
            checks.append(
                CheckItem(
                    label="query_tv_floor",
                    verdict=Verdict.OBSTRUCTED,
                    detail=rep.reason,
                    missing_guard="surjective_query_image_on_support",
                    witness={
                        "floor": rep.floor,
                        "attained_tv": rep.attained_tv,
                        "outside_observations": list(rep.outside_observations),
                        "attaining_nu": rep.attaining_nu,
                    },
                )
            )
        else:
            checks.append(
                CheckItem(
                    label="query_tv_floor",
                    verdict=Verdict.PROVED,
                    detail="Exact query TV floor is 0 (attained constructively)",
                    witness={"floor": rep.floor, "attaining_nu": rep.attaining_nu},
                )
            )

    if "coarsening" in spec:
        cs = spec["coarsening"]
        mu = FinDist.from_mapping(cs["mu"])
        crep = check_coarsening(cs["chi"], cs["q_fine"], cs["coarsen_map"], mu, cs["src_carrier"])
        checks.append(
            CheckItem(
                label="coarsening_check",
                verdict=Verdict.OBSTRUCTED if crep.conceals_blindness else Verdict.PROVED,
                detail=(
                    f"fine_floor={crep.fine_floor}, coarse_floor={crep.coarse_floor}, "
                    f"concealed_gap={crep.concealed_gap}"
                ),
                missing_guard="non_concealing_query_coarsening" if crep.conceals_blindness else None,
                witness={
                    "fine_floor": crep.fine_floor,
                    "coarse_floor": crep.coarse_floor,
                    "concealed_gap": crep.concealed_gap,
                },
            )
        )

    if "macro_refinement" in spec:
        mr = spec["macro_refinement"]
        mu = FinDist.from_mapping(mr["mu"])
        mrep = check_macro_refinement(
            mr["refine_map"], mr["chi_fine"], mr["q"], mu, mr["coarse_carrier"], mr["fine_carrier"]
        )
        checks.append(
            CheckItem(
                label="macro_refinement_mono",
                verdict=Verdict.PROVED if mrep.monotone_holds else Verdict.OBSTRUCTED,
                detail=(
                    f"coarse_floor={mrep.coarse_floor} -> fine_floor={mrep.fine_floor} "
                    f"(improvement={mrep.improvement})"
                ),
                witness={
                    "coarse_floor": mrep.coarse_floor,
                    "fine_floor": mrep.fine_floor,
                    "improvement": mrep.improvement,
                },
            )
        )

    if "multi_query" in spec:
        mq = spec["multi_query"]
        qspecs = [
            QuerySpec(str(q["name"]), q["query_map"], FinDist.from_mapping(q["target_dist"]))
            for q in mq["queries"]
        ]
        joint_chi = mq.get("joint_chi")
        joint_target = FinDist.from_mapping(mq["joint_target"]) if "joint_target" in mq else None
        mrep = check_multi_query_feasibility(
            mq["src_carrier"], qspecs, joint_chi=joint_chi, joint_target=joint_target
        )
        is_ok = mrep.regime == "JOINTLY_REALIZABLE"
        checks.append(
            CheckItem(
                label="multi_query_convex_feasibility",
                verdict=Verdict.PROVED if is_ok else Verdict.OBSTRUCTED,
                detail=(
                    f"regime={mrep.regime}, per_query_realizable={mrep.per_query_realizable}, "
                    f"simultaneous_min_tv_sum={mrep.simultaneous_min_tv_sum}, "
                    f"joint_min_tv={mrep.joint_min_tv}"
                ),
                missing_guard=None if is_ok else mrep.regime.lower(),
                witness={
                    "per_query_floors": mrep.per_query_floors,
                    "simultaneous_min_tv_sum": mrep.simultaneous_min_tv_sum,
                    "simultaneous_witness": mrep.simultaneous_witness,
                    "joint_min_tv": mrep.joint_min_tv,
                },
            )
        )

    if "fiber_split" in spec:
        fs = spec["fiber_split"]
        frep = check_fiber_viability_split(fs["proj_map"], fs["viable_pred"], fs["states"])
        checks.append(
            CheckItem(
                label="fiber_viability_split",
                verdict=Verdict.OBSTRUCTED if frep.has_split else Verdict.PROVED,
                detail=frep.warning,
                missing_guard="fiber_consistent_viability_projection" if frep.has_split else None,
                witness=(
                    {
                        "viable_state": frep.viable_state,
                        "collapsing_state": frep.collapsing_state,
                        "shared_projection": frep.shared_projection,
                        "projected_tv": frep.projected_tv,
                    }
                    if frep.has_split
                    else {}
                ),
            )
        )

    if "contractive_tube" in spec:
        ct = spec["contractive_tube"]
        alpha = to_fraction(ct["alpha"])
        eps = to_fraction(ct["eps"])
        r0 = to_fraction(ct["init_radius"])
        steps = int(ct["steps"])
        at_steps = metric_slack(alpha, eps, steps, r0)
        bound = contractive_tube_bound(alpha, eps, r0)
        checks.append(
            CheckItem(
                label="contractive_closed_loop_tube",
                verdict=Verdict.GUARDED,
                detail=(
                    f"Contractive tube (alpha={alpha}, eps={eps}): "
                    f"slack(step={steps})={at_steps} <= uniform_bound={bound}"
                ),
                witness={"slack_at_steps": at_steps, "uniform_bound": bound},
            )
        )

    tup = tuple(checks)
    v = combine_verdicts(tup)
    return DiagnosticReport(
        name=name,
        verdict=v,
        summary=f"Evaluated {len(tup)} exact-rational fidelity check(s); overall verdict {v.value}.",
        checks=tup,
        rule2_boundary=(
            "Exact Fraction arithmetic on finite carriers; empirical transition laws and finite-sample "
            "estimation uncertainty are outside these formal guarantees."
        ),
    )


def _eval_coupled_alignment_spec(spec: Mapping[str, Any]) -> DiagnosticReport:
    """High-level coupled multi-agent shared-substrate pipeline check."""
    name = str(spec.get("name", "coupled_alignment_pipeline"))
    observe_phase = bool(spec.get("observe_relative_phase", False))
    stock_init = int(spec.get("initial_stock", 1))
    min_stock = int(spec.get("min_viable_stock", 1))

    # Coupled 2-agent state space ((b1, b2), stock_init) matching C2CoupledAlignmentWitness
    states = [
        f"({int(b1)},{int(b2)},stock={stock_init})"
        for b1 in (False, True)
        for b2 in (False, True)
    ]
    viable_pred: dict[str, bool] = {}
    proj_map: dict[str, str] = {}
    for b1 in (False, True):
        for b2 in (False, True):
            st = f"({int(b1)},{int(b2)},stock={stock_init})"
            in_phase = b1 == b2
            # In-phase keeps stock eternally; anti-phase overdraws by 1 every step.
            viable_pred[st] = (stock_init >= min_stock) and in_phase
            if observe_phase:
                proj_map[st] = f"phase={'in' if in_phase else 'anti'},stock={stock_init}"
            else:
                proj_map[st] = f"stock={stock_init}"

    checks: list[CheckItem] = []

    # 1. Oplax C2 comparison square: componentwise quotient collapses 2->1; phase-aware preserves 2->2
    if observe_phase:
        sq = ChiSquare(
            label="PhaseAwareC2(2->2)",
            f_pb_carrier=("in_phase", "anti_phase"),
            f_h_carrier=("in_phase", "anti_phase"),
            f_k_carrier=("in_phase", "anti_phase"),
            f_d_carrier=("in_phase", "anti_phase"),
            f_right={"in_phase": "in_phase", "anti_phase": "anti_phase"},
            f_left={"in_phase": "in_phase", "anti_phase": "anti_phase"},
            f_fst={"in_phase": "in_phase", "anti_phase": "anti_phase"},
            f_snd={"in_phase": "in_phase", "anti_phase": "anti_phase"},
        )
        diag = analyze_chi_square(sq)
    else:
        diag = c2_two_to_one_witness()
    checks.append(_chi_diag_to_check("coupled_c2_chi_bc", diag, attempt_strict_upgrade=True))

    # 2. Zero-TV vs FiberViabilitySplit check
    frep = check_fiber_viability_split(proj_map, viable_pred, states)
    checks.append(
        CheckItem(
            label="coupled_viability_projection",
            verdict=Verdict.OBSTRUCTED if frep.has_split else Verdict.GUARDED,
            detail=(
                frep.warning
                if frep.has_split
                else "Phase-aware projection separates viable in-phase from depleting anti-phase fibers"
            ),
            missing_guard="relative_phase_observability_guard" if frep.has_split else None,
            witness=(
                {
                    "viable_state": frep.viable_state,
                    "collapsing_state": frep.collapsing_state,
                    "shared_projection": frep.shared_projection,
                    "projected_tv": frep.projected_tv,
                }
                if frep.has_split
                else {"distinct_projections": sorted(set(proj_map.values()))}
            ),
        )
    )

    tup = tuple(checks)
    v = combine_verdicts(tup)
    return DiagnosticReport(
        name=name,
        verdict=v,
        summary=(
            f"Coupled 2-agent shared-substrate audit (observe_relative_phase={observe_phase}): "
            f"verdict {v.value}."
        ),
        checks=tup,
        rule2_boundary=(
            "Models two coupled agents over a discrete shared stock; applying this obstruction or "
            "phase-aware guard to real RLHF/multi-agent deployments requires checking actual cross-agent "
            "substrate coupling."
        ),
    )


def evaluate_pipeline_spec(spec: Mapping[str, Any]) -> DiagnosticReport:
    """Evaluate a declarative JSON/dict pipeline specification into a ``DiagnosticReport``."""
    kind = spec.get("kind")
    if kind == "strict_kernel":
        return _eval_strict_kernel_spec(spec)
    if kind == "oplax_guard":
        return _eval_oplax_guard_spec(spec)
    if kind == "observational_fidelity":
        return _eval_fidelity_spec(spec)
    if kind == "coupled_alignment":
        return _eval_coupled_alignment_spec(spec)
    if kind == "alignment_proposal":
        from .proposal_audit import evaluate_alignment_proposal

        return evaluate_alignment_proposal(spec)
    if kind == "suite":
        sub_reports = [evaluate_pipeline_spec(sub) for sub in spec.get("pipelines", ())]
        checks = tuple(
            CheckItem(
                label=r.name,
                verdict=r.verdict,
                detail=r.summary,
                witness={"sub_checks": [c.to_dict() for c in r.checks]},
            )
            for r in sub_reports
        )
        v = combine_verdicts(checks)
        return DiagnosticReport(
            name=str(spec.get("name", "pipeline_suite")),
            verdict=v,
            summary=f"Suite of {len(sub_reports)} pipeline(s); overall verdict {v.value}.",
            checks=checks,
            rule2_boundary="Aggregates formal finite-model checks; Rule 2 empirical boundary applies to every sub-pipeline.",
        )
    raise FidelityError(f"Unsupported pipeline kind {kind!r}")
