"""Finite oplax span semantics, Beck-Chevalley diagnostics, and guarded double syntax.

AI-written (Wave U6 runtime, 24 November 2026). Pure Python 3 standard library.
Mirrors ``Becoming.OplaxHistory`` and ``Becoming.DoubleKernel`` Part 4:
- Finite relational spans (``RelSpan``), span morphisms (``SpanHom``), exact pullback
  composition (``comp_span``), disjoint coproduct (``coprod_span``), and finite
  ``SpanFunctor`` with functoriality validation.
- Canonical oplax comparison ``chi : F(W x_D V) -> FW x_{FD} FV``, pullback universal
  lifting check (``FImageIsPullback``), and universal fiberwise Beck-Chevalley test
  (``chi_bijective_iff_bc_all``), explicitly flagging the vacuous empty-family trap.
- Constructive witnesses for emergent cross-seam creation (``0 -> 1``, ``2 -> 4``) and
  ``C2`` relational phase collapse (``2 -> 1``, ``2^n -> 1``).
- ``GuardedExpr`` / ``GuardedProof`` evaluator: allows strong ``par`` vs ``seq``
  distribution and one-way ``chiStep``, while rejecting unguarded ``chiInv`` unless
  supplied with an explicit verified ``BijCert`` / Beck-Chevalley witness.

Rule 2 note: Verifies exact finite-set categorical properties; empirical alignment
pipelines must independently justify finite state and functor abstractions.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Any, Callable, Iterable, Mapping, Union


class OplaxError(ValueError):
    """Raised on malformed spans, functors, or morphisms."""


class GuardedInterchangeError(OplaxError):
    """Raised when unguarded strict interchange (``ChiInv``) lacks a valid ``Bij``/BC guard."""

    def __init__(self, message: str, diagnostics: "ChiDiagnostics | None" = None) -> None:
        super().__init__(message)
        self.diagnostics = diagnostics


def _dedup_tuple(items: Iterable[Any]) -> tuple[Any, ...]:
    seen: list[Any] = []
    seen_set: set[Any] = set()
    for item in items:
        if item not in seen_set:
            seen_set.add(item)
            seen.append(item)
    return tuple(seen)


def _materialize_map(
    domain: tuple[Any, ...], fn_or_map: Mapping[Any, Any] | Callable[[Any], Any]
) -> dict[Any, Any]:
    if isinstance(fn_or_map, Mapping):
        out: dict[Any, Any] = {}
        for x in domain:
            if x not in fn_or_map:
                raise OplaxError(f"Map missing domain element {x!r}")
            out[x] = fn_or_map[x]
        return out
    return {x: fn_or_map(x) for x in domain}


@dataclass(frozen=True)
class PullbackElem:
    """Element ``(fst, snd)`` of a finite fiber product ``W x_D V``."""

    fst: Any
    snd: Any


@dataclass(frozen=True)
class RelSpan:
    """Finite relational span ``left_dom <-left- carrier -right-> right_dom``."""

    left_dom: tuple[Any, ...]
    right_dom: tuple[Any, ...]
    carrier: tuple[Any, ...]
    left_map: Mapping[Any, Any]
    right_map: Mapping[Any, Any]
    name: str = ""

    def __post_init__(self) -> None:
        left_set = set(self.left_dom)
        right_set = set(self.right_dom)
        for w in self.carrier:
            if w not in self.left_map or w not in self.right_map:
                raise OplaxError(f"Span {self.name!r}: missing endpoint map for {w!r}")
            if self.left_map[w] not in left_set:
                raise OplaxError(
                    f"Span {self.name!r}: left({w!r})={self.left_map[w]!r} not in left_dom"
                )
            if self.right_map[w] not in right_set:
                raise OplaxError(
                    f"Span {self.name!r}: right({w!r})={self.right_map[w]!r} not in right_dom"
                )

    @classmethod
    def create(
        cls,
        left_dom: Iterable[Any],
        right_dom: Iterable[Any],
        carrier: Iterable[Any],
        left: Mapping[Any, Any] | Callable[[Any], Any],
        right: Mapping[Any, Any] | Callable[[Any], Any],
        name: str = "",
    ) -> "RelSpan":
        ld = _dedup_tuple(left_dom)
        rd = _dedup_tuple(right_dom)
        car = _dedup_tuple(carrier)
        return cls(
            left_dom=ld,
            right_dom=rd,
            carrier=car,
            left_map=_materialize_map(car, left),
            right_map=_materialize_map(car, right),
            name=name,
        )

    def left(self, w: Any) -> Any:
        return self.left_map[w]

    def right(self, w: Any) -> Any:
        return self.right_map[w]


@dataclass(frozen=True)
class SpanHom:
    """Endpoint-preserving morphism ``src -> tgt`` of finite relational spans."""

    src: RelSpan
    tgt: RelSpan
    mapping: Mapping[Any, Any]

    def __post_init__(self) -> None:
        if self.src.left_dom != self.tgt.left_dom or self.src.right_dom != self.tgt.right_dom:
            raise OplaxError("SpanHom endpoints must share left_dom and right_dom")
        tgt_set = set(self.tgt.carrier)
        for w in self.src.carrier:
            if w not in self.mapping:
                raise OplaxError(f"SpanHom missing carrier element {w!r}")
            img = self.mapping[w]
            if img not in tgt_set:
                raise OplaxError(f"SpanHom image {img!r} not in target carrier")
            if self.tgt.left(img) != self.src.left(w):
                raise OplaxError(
                    f"SpanHom breaks left endpoint on {w!r}: "
                    f"{self.tgt.left(img)!r} != {self.src.left(w)!r}"
                )
            if self.tgt.right(img) != self.src.right(w):
                raise OplaxError(
                    f"SpanHom breaks right endpoint on {w!r}: "
                    f"{self.tgt.right(img)!r} != {self.src.right(w)!r}"
                )

    def apply(self, w: Any) -> Any:
        return self.mapping[w]

    @classmethod
    def identity(cls, span: RelSpan) -> "SpanHom":
        return cls(src=span, tgt=span, mapping={w: w for w in span.carrier})

    @classmethod
    def compose(cls, second: "SpanHom", first: "SpanHom") -> "SpanHom":
        if first.tgt != second.src:
            raise OplaxError("SpanHom composition boundary mismatch")
        return cls(
            src=first.src,
            tgt=second.tgt,
            mapping={w: second.apply(first.apply(w)) for w in first.src.carrier},
        )


def id_span(dom: Iterable[Any], name: str = "id") -> RelSpan:
    """Identity span ``A <-id- A -id-> A``."""
    d = _dedup_tuple(dom)
    return RelSpan.create(d, d, d, lambda x: x, lambda x: x, name=name)


def pullback_carrier(
    carrier_h: tuple[Any, ...],
    right_h: Mapping[Any, Any],
    carrier_k: tuple[Any, ...],
    left_k: Mapping[Any, Any],
) -> tuple[PullbackElem, ...]:
    """Exact finite fiber product ``{(w, v) | right_h[w] == left_k[v]}``."""
    return tuple(
        PullbackElem(w, v)
        for w in carrier_h
        for v in carrier_k
        if right_h[w] == left_k[v]
    )


def comp_span(first: RelSpan, second: RelSpan) -> RelSpan:
    """Sequential pullback composition ``H * K``."""
    if first.right_dom != second.left_dom:
        raise OplaxError(
            f"comp_span middle domain mismatch: {first.right_dom!r} != {second.left_dom!r}"
        )
    pb = pullback_carrier(first.carrier, first.right_map, second.carrier, second.left_map)
    return RelSpan.create(
        left_dom=first.left_dom,
        right_dom=second.right_dom,
        carrier=pb,
        left={p: first.left(p.fst) for p in pb},
        right={p: second.right(p.snd) for p in pb},
        name=f"({first.name}*{second.name})",
    )


def comp_span_hom(a: SpanHom, b: SpanHom) -> SpanHom:
    """Lift span morphisms ``a : H1 -> H2`` and ``b : K1 -> K2`` to ``H1*K1 -> H2*K2``."""
    src = comp_span(a.src, b.src)
    tgt = comp_span(a.tgt, b.tgt)
    return SpanHom(
        src=src,
        tgt=tgt,
        mapping={p: PullbackElem(a.apply(p.fst), b.apply(p.snd)) for p in src.carrier},
    )


def coprod_span(left_span: RelSpan, right_span: RelSpan) -> RelSpan:
    """Tagged disjoint coproduct ``H (+) H'`` matching Lean ``Sum.inl`` / ``Sum.inr``."""
    ld = tuple(("L", a) for a in left_span.left_dom) + tuple(("R", a) for a in right_span.left_dom)
    rd = tuple(("L", b) for b in left_span.right_dom) + tuple(("R", b) for b in right_span.right_dom)
    car = tuple(("L", w) for w in left_span.carrier) + tuple(("R", w) for w in right_span.carrier)
    lmap = {("L", w): ("L", left_span.left(w)) for w in left_span.carrier}
    lmap.update({("R", w): ("R", right_span.left(w)) for w in right_span.carrier})
    rmap = {("L", w): ("L", left_span.right(w)) for w in left_span.carrier}
    rmap.update({("R", w): ("R", right_span.right(w)) for w in right_span.carrier})
    return RelSpan(
        left_dom=ld,
        right_dom=rd,
        carrier=car,
        left_map=lmap,
        right_map=rmap,
        name=f"({left_span.name}+{right_span.name})",
    )


def par_span_hom(a: SpanHom, b: SpanHom) -> SpanHom:
    """Lift span morphisms across tagged coproduct ``(+)``."""
    src = coprod_span(a.src, b.src)
    tgt = coprod_span(a.tgt, b.tgt)
    mapping = {("L", w): ("L", a.apply(w)) for w in a.src.carrier}
    mapping.update({("R", w): ("R", b.apply(w)) for w in b.src.carrier})
    return SpanHom(src=src, tgt=tgt, mapping=mapping)


def par_seq_dist_hom_lr(
    h: RelSpan, k: RelSpan, h_p: RelSpan, k_p: RelSpan
) -> SpanHom:
    """Strong distributivity ``(H*K) (+) (H'*K') -> (H (+) H') * (K (+) K')``."""
    src = coprod_span(comp_span(h, k), comp_span(h_p, k_p))
    tgt = comp_span(coprod_span(h, h_p), coprod_span(k, k_p))
    mapping = {
        (tag, elem): PullbackElem((tag, elem.fst), (tag, elem.snd))
        for tag, elem in src.carrier
    }
    return SpanHom(src=src, tgt=tgt, mapping=mapping)


def par_seq_dist_hom_rl(
    h: RelSpan, k: RelSpan, h_p: RelSpan, k_p: RelSpan
) -> SpanHom:
    """Inverse strong distributivity ``(H (+) H') * (K (+) K') -> (H*K) (+) (H'*K')``."""
    src = comp_span(coprod_span(h, h_p), coprod_span(k, k_p))
    tgt = coprod_span(comp_span(h, k), comp_span(h_p, k_p))
    mapping: dict[Any, Any] = {}
    for elem in src.carrier:
        tag_l, fst = elem.fst
        tag_r, snd = elem.snd
        if tag_l != tag_r:
            raise OplaxError("Cross-tag element cannot exist in disjoint coproduct pullback")
        mapping[elem] = (tag_l, PullbackElem(fst, snd))
    return SpanHom(src=src, tgt=tgt, mapping=mapping)


# --- Finite SpanFunctor & Canonical Oplax Comparison chi ---


@dataclass(frozen=True)
class SpanFunctor:
    """Finite functor acting on finite sets (tuples) and total maps."""

    name: str
    on_obj: Callable[[tuple[Any, ...]], tuple[Any, ...]]
    on_map: Callable[[tuple[Any, ...], tuple[Any, ...], Mapping[Any, Any]], dict[Any, Any]]

    def on_span(self, span: RelSpan) -> RelSpan:
        fl = _dedup_tuple(self.on_obj(span.left_dom))
        fr = _dedup_tuple(self.on_obj(span.right_dom))
        fw = _dedup_tuple(self.on_obj(span.carrier))
        f_left = self.on_map(span.carrier, span.left_dom, span.left_map)
        f_right = self.on_map(span.carrier, span.right_dom, span.right_map)
        return RelSpan(
            left_dom=fl,
            right_dom=fr,
            carrier=fw,
            left_map=f_left,
            right_map=f_right,
            name=f"{self.name}({span.name})",
        )

    def on_hom(self, hom: SpanHom) -> SpanHom:
        return SpanHom(
            src=self.on_span(hom.src),
            tgt=self.on_span(hom.tgt),
            mapping=self.on_map(hom.src.carrier, hom.tgt.carrier, hom.mapping),
        )

    def verify_laws(
        self,
        domains: Iterable[tuple[Any, ...]],
        composable_pairs: Iterable[tuple[tuple[Any, ...], tuple[Any, ...], tuple[Any, ...], Mapping[Any, Any], Mapping[Any, Any]]],
    ) -> None:
        """Check ``map_id`` and ``map_comp`` on supplied finite test domains and maps."""
        for dom in domains:
            fd = self.on_obj(dom)
            id_m = self.on_map(dom, dom, {x: x for x in dom})
            for fx in fd:
                if id_m.get(fx) != fx:
                    raise OplaxError(
                        f"Functor {self.name!r} failed map_id on {fx!r}: got {id_m.get(fx)!r}"
                    )
        for a, b, c, f, g in composable_pairs:
            fg = {x: g[f[x]] for x in a}
            lhs = self.on_map(a, c, fg)
            ff = self.on_map(a, b, f)
            gg = self.on_map(b, c, g)
            rhs = {fx: gg[ff[fx]] for fx in self.on_obj(a)}
            if lhs != rhs:
                raise OplaxError(f"Functor {self.name!r} failed map_comp: {lhs!r} != {rhs!r}")


def identity_functor() -> SpanFunctor:
    return SpanFunctor(
        name="Id",
        on_obj=lambda dom: _dedup_tuple(dom),
        on_map=lambda src, tgt, m: {x: m[x] for x in src},
    )


def collapse_nonempty_functor(name: str = "CollapseUnit") -> SpanFunctor:
    """Functor collapsing every nonempty finite set to ``('unit',)`` and empty to ``()``."""
    def _obj(dom: tuple[Any, ...]) -> tuple[Any, ...]:
        return ("unit",) if len(dom) > 0 else ()

    def _map(src: tuple[Any, ...], tgt: tuple[Any, ...], m: Mapping[Any, Any]) -> dict[Any, Any]:
        if len(src) == 0:
            return {}
        if len(tgt) == 0:
            raise OplaxError("No total map from nonempty to empty set")
        return {"unit": "unit"}

    return SpanFunctor(name=name, on_obj=_obj, on_map=_map)


def product_with_const_functor(tag_set: tuple[Any, ...], name: str = "ProdConst") -> SpanFunctor:
    """Strong pullback-preserving functor ``X |-> X x tag_set``."""
    tags = _dedup_tuple(tag_set)
    return SpanFunctor(
        name=name,
        on_obj=lambda dom: tuple((x, t) for x in dom for t in tags),
        on_map=lambda src, tgt, m: {(x, t): (m[x], t) for x in src for t in tags},
    )


def compute_chi_hom(functor: SpanFunctor, h: RelSpan, k: RelSpan) -> SpanHom:
    """Compute canonical oplax comparison ``chi : F(H*K) -> F(H)*F(K)``."""
    hk = comp_span(h, k)
    f_hk = functor.on_span(hk)
    f_h = functor.on_span(h)
    f_k = functor.on_span(k)
    fh_fk = comp_span(f_h, f_k)
    f_fst = functor.on_map(hk.carrier, h.carrier, {p: p.fst for p in hk.carrier})
    f_snd = functor.on_map(hk.carrier, k.carrier, {p: p.snd for p in hk.carrier})
    chi_map = {u: PullbackElem(f_fst[u], f_snd[u]) for u in f_hk.carrier}
    return SpanHom(src=f_hk, tgt=fh_fk, mapping=chi_map)


# --- Unified ChiSquare, Pullback Universal Property, & Universal Beck-Chevalley ---


@dataclass(frozen=True)
class ChiSquare:
    """F-image comparison square ``F(W x_D V) --(f_fst, f_snd)--> FW x_{FD} FV``.

    Uniform carrier for ``SpanFunctor`` actions, ``SeamObj`` pushouts, and ``C2`` orbit quotients.
    """

    label: str
    f_pb_carrier: tuple[Any, ...]
    f_h_carrier: tuple[Any, ...]
    f_k_carrier: tuple[Any, ...]
    f_d_carrier: tuple[Any, ...]
    f_right: Mapping[Any, Any]
    f_left: Mapping[Any, Any]
    f_fst: Mapping[Any, Any]
    f_snd: Mapping[Any, Any]

    def __post_init__(self) -> None:
        for u in self.f_pb_carrier:
            w = self.f_fst[u]
            v = self.f_snd[u]
            if self.f_right[w] != self.f_left[v]:
                raise OplaxError(
                    f"ChiSquare {self.label!r} fails commutation on {u!r}: "
                    f"f_right({w!r})={self.f_right[w]!r} != f_left({v!r})={self.f_left[v]!r}"
                )

    def target_pullback(self) -> tuple[PullbackElem, ...]:
        return pullback_carrier(
            self.f_h_carrier, self.f_right, self.f_k_carrier, self.f_left
        )

    def chi_map(self) -> dict[Any, PullbackElem]:
        return {u: PullbackElem(self.f_fst[u], self.f_snd[u]) for u in self.f_pb_carrier}


def chi_square_from_functor(functor: SpanFunctor, h: RelSpan, k: RelSpan) -> ChiSquare:
    """Build a ``ChiSquare`` from a finite ``SpanFunctor`` and composable spans ``(H, K)``."""
    hk = comp_span(h, k)
    f_hk = functor.on_span(hk)
    f_h = functor.on_span(h)
    f_k = functor.on_span(k)
    f_fst = functor.on_map(hk.carrier, h.carrier, {p: p.fst for p in hk.carrier})
    f_snd = functor.on_map(hk.carrier, k.carrier, {p: p.snd for p in hk.carrier})
    return ChiSquare(
        label=f"{functor.name}({h.name}*{k.name})",
        f_pb_carrier=f_hk.carrier,
        f_h_carrier=f_h.carrier,
        f_k_carrier=f_k.carrier,
        f_d_carrier=f_h.right_dom,
        f_right=f_h.right_map,
        f_left=f_k.left_map,
        f_fst=f_fst,
        f_snd=f_snd,
    )


@dataclass(frozen=True)
class BCFailureWitness:
    """Concrete family and fiber ``v`` witnessing failure of ``bcMap`` bijectivity."""

    family_label: str
    fiber_v: Any
    reason: str
    left_size: int
    right_size: int


@dataclass(frozen=True)
class ChiDiagnostics:
    """Complete categorical diagnosis of ``chi : F(W x_D V) -> FW x_{FD} FV``."""

    label: str
    domain_size: int
    codomain_size: int
    chi_map: dict[Any, PullbackElem]
    is_injective: bool
    is_surjective: bool
    is_bijective: bool
    f_image_is_pullback: bool
    universal_bc_holds: bool
    empty_family_vacuously_bijective: bool
    collision_witness: tuple[Any, Any, PullbackElem] | None
    emergent_witness: PullbackElem | None
    bc_failure: BCFailureWitness | None
    inv_map: dict[PullbackElem, Any] | None


def check_bc_for_family(
    square: ChiSquare,
    family: Mapping[Any, tuple[Any, ...]],
    v: Any,
    family_label: str,
) -> BCFailureWitness | None:
    """Evaluate exact fiberwise Beck-Chevalley ``bcMap(E, v) : BCLeft -> BCRight``."""
    bc_left = [
        (u, val)
        for u in square.f_pb_carrier
        if square.f_snd[u] == v
        for val in family[square.f_fst[u]]
    ]
    bc_right = [
        (w, val)
        for w in square.f_h_carrier
        if square.f_right[w] == square.f_left[v]
        for val in family[w]
    ]
    images: dict[tuple[Any, Any], tuple[Any, Any]] = {}
    for item in bc_left:
        u, val = item
        img = (square.f_fst[u], val)
        if img in images:
            return BCFailureWitness(
                family_label=family_label,
                fiber_v=v,
                reason=f"bcMap not injective: {images[img]!r} and {item!r} both map to {img!r}",
                left_size=len(bc_left),
                right_size=len(bc_right),
            )
        images[img] = item
    for target in bc_right:
        if target not in images:
            return BCFailureWitness(
                family_label=family_label,
                fiber_v=v,
                reason=f"bcMap not surjective: {target!r} has no lift in BCLeft",
                left_size=len(bc_left),
                right_size=len(bc_right),
            )
    return None


def analyze_chi_square(square: ChiSquare) -> ChiDiagnostics:
    """Run ``chi``, ``FImageIsPullback``, and universal Beck-Chevalley checks (S4)."""
    target_pb = square.target_pullback()
    cmap = square.chi_map()

    # Injectivity & surjectivity
    seen_img: dict[PullbackElem, Any] = {}
    collision: tuple[Any, Any, PullbackElem] | None = None
    for u, img in cmap.items():
        if img in seen_img and collision is None:
            collision = (seen_img[img], u, img)
        else:
            seen_img[img] = u

    emergent: PullbackElem | None = None
    for pb_elem in target_pb:
        if pb_elem not in seen_img:
            emergent = pb_elem
            break

    is_inj = collision is None
    is_surj = emergent is None
    is_bij = is_inj and is_surj

    # Universal pullback property: every compatible (w, v) lifts uniquely
    f_pb = True
    for pb_elem in target_pb:
        lifts = [
            u
            for u in square.f_pb_carrier
            if square.f_fst[u] == pb_elem.fst and square.f_snd[u] == pb_elem.snd
        ]
        if len(lifts) != 1:
            f_pb = False
            break

    # Empty-family BC trap check (vacuously true everywhere!)
    empty_fam = {w: () for w in square.f_h_carrier}
    empty_bc_ok = all(
        check_bc_for_family(square, empty_fam, v, "Empty") is None
        for v in square.f_k_carrier
    )

    # Non-empty families: Unit, 2-element, and point-indicator families
    bc_failure: BCFailureWitness | None = None
    test_families: list[tuple[str, dict[Any, tuple[Any, ...]]]] = [
        ("Unit", {w: (0,) for w in square.f_h_carrier}),
        ("Bool", {w: (False, True) for w in square.f_h_carrier}),
    ]
    for w0 in square.f_h_carrier:
        test_families.append(
            (f"Indicator({w0!r})", {w: ((0,) if w == w0 else ()) for w in square.f_h_carrier})
        )
    for fam_label, fam in test_families:
        for v in square.f_k_carrier:
            fail = check_bc_for_family(square, fam, v, fam_label)
            if fail is not None:
                bc_failure = fail
                break
        if bc_failure is not None:
            break

    inv_map = {img: u for u, img in cmap.items()} if is_bij else None
    return ChiDiagnostics(
        label=square.label,
        domain_size=len(square.f_pb_carrier),
        codomain_size=len(target_pb),
        chi_map=cmap,
        is_injective=is_inj,
        is_surjective=is_surj,
        is_bijective=is_bij,
        f_image_is_pullback=f_pb,
        universal_bc_holds=(bc_failure is None),
        empty_family_vacuously_bijective=empty_bc_ok,
        collision_witness=collision,
        emergent_witness=emergent,
        bc_failure=bc_failure,
        inv_map=inv_map,
    )


def analyze_chi(functor: SpanFunctor, h: RelSpan, k: RelSpan) -> ChiDiagnostics:
    """Analyze canonical ``chi`` for a ``SpanFunctor`` on composable spans ``(H, K)``."""
    return analyze_chi_square(chi_square_from_functor(functor, h, k))


# --- Emergent Cross-Seam Witnesses (0 -> 1 & 2 -> 4) ---


@dataclass(frozen=True)
class SeamObj:
    """Finite 2-piece + 1-seam diagram ``L <-l_map- S -r_map-> R``."""

    left_set: tuple[Any, ...]
    right_set: tuple[Any, ...]
    seam_set: tuple[Any, ...]
    l_map: Mapping[Any, Any]
    r_map: Mapping[Any, Any]

    def pushout(self) -> tuple[tuple[Any, ...], dict[Any, Any], dict[Any, Any]]:
        """Compute finite colimit (pushout) ``L +_S R`` via union-find."""
        nodes = [("L", x) for x in self.left_set] + [("R", y) for y in self.right_set]
        parent = {n: n for n in nodes}

        def find(n: tuple[str, Any]) -> tuple[str, Any]:
            while parent[n] != n:
                parent[n] = parent[parent[n]]
                n = parent[n]
            return n

        for s in self.seam_set:
            rl = find(("L", self.l_map[s]))
            rr = find(("R", self.r_map[s]))
            if rl != rr:
                parent[rr] = rl

        reps = _dedup_tuple(find(n) for n in nodes)
        inl = {x: find(("L", x)) for x in self.left_set}
        inr = {y: find(("R", y)) for y in self.right_set}
        return reps, inl, inr


@dataclass(frozen=True)
class SeamHom:
    """Morphism of 2-piece + 1-seam diagrams."""

    src: SeamObj
    tgt: SeamObj
    f_l: Mapping[Any, Any]
    f_r: Mapping[Any, Any]
    f_s: Mapping[Any, Any]

    def __post_init__(self) -> None:
        for s in self.src.seam_set:
            if self.tgt.l_map[self.f_s[s]] != self.f_l[self.src.l_map[s]]:
                raise OplaxError(f"SeamHom commL fails on {s!r}")
            if self.tgt.r_map[self.f_s[s]] != self.f_r[self.src.r_map[s]]:
                raise OplaxError(f"SeamHom commR fails on {s!r}")

    def on_pushout(self) -> dict[Any, Any]:
        _, src_inl, src_inr = self.src.pushout()
        _, tgt_inl, tgt_inr = self.tgt.pushout()
        out: dict[Any, Any] = {}
        for x in self.src.left_set:
            out[src_inl[x]] = tgt_inl[self.f_l[x]]
        for y in self.src.right_set:
            out[src_inr[y]] = tgt_inr[self.f_r[y]]
        return out


def seam_pullback_chi_square(r_w: SeamHom, l_v: SeamHom, label: str = "SeamPushout") -> ChiSquare:
    """Compute exact pushout ``ChiSquare`` for composable seam maps ``W -> D <- V``."""
    if r_w.tgt != l_v.tgt:
        raise OplaxError("Seam pullback requires matching middle SeamObj D")
    w_obj, v_obj, d_obj = r_w.src, l_v.src, r_w.tgt
    pb_l = pullback_carrier(w_obj.left_set, r_w.f_l, v_obj.left_set, l_v.f_l)
    pb_r = pullback_carrier(w_obj.right_set, r_w.f_r, v_obj.right_set, l_v.f_r)
    pb_s = pullback_carrier(w_obj.seam_set, r_w.f_s, v_obj.seam_set, l_v.f_s)
    pb_obj = SeamObj(
        left_set=pb_l,
        right_set=pb_r,
        seam_set=pb_s,
        l_map={p: PullbackElem(w_obj.l_map[p.fst], v_obj.l_map[p.snd]) for p in pb_s},
        r_map={p: PullbackElem(w_obj.r_map[p.fst], v_obj.r_map[p.snd]) for p in pb_s},
    )
    proj_w = SeamHom(
        src=pb_obj,
        tgt=w_obj,
        f_l={p: p.fst for p in pb_l},
        f_r={p: p.fst for p in pb_r},
        f_s={p: p.fst for p in pb_s},
    )
    proj_v = SeamHom(
        src=pb_obj,
        tgt=v_obj,
        f_l={p: p.snd for p in pb_l},
        f_r={p: p.snd for p in pb_r},
        f_s={p: p.snd for p in pb_s},
    )
    q_pb, _, _ = pb_obj.pushout()
    q_w, _, _ = w_obj.pushout()
    q_v, _, _ = v_obj.pushout()
    q_d, _, _ = d_obj.pushout()
    return ChiSquare(
        label=label,
        f_pb_carrier=q_pb,
        f_h_carrier=q_w,
        f_k_carrier=q_v,
        f_d_carrier=q_d,
        f_right=r_w.on_pushout(),
        f_left=l_v.on_pushout(),
        f_fst=proj_w.on_pushout(),
        f_snd=proj_v.on_pushout(),
    )


def emergent_zero_to_one_witness() -> ChiDiagnostics:
    """Canonical ``0 -> 1`` emergent cross-seam witness (``EmergentCrossSeamWitness``)."""
    mid_d = SeamObj(("l",), ("r",), ("s",), {"s": "l"}, {"s": "r"})
    step_w = SeamObj(("l",), (), (), {}, {})
    step_v = SeamObj((), ("r",), (), {}, {})
    r_w = SeamHom(step_w, mid_d, {"l": "l"}, {}, {})
    l_v = SeamHom(step_v, mid_d, {}, {"r": "r"}, {})
    return analyze_chi_square(seam_pullback_chi_square(r_w, l_v, label="Emergent(0->1)"))


def emergent_two_to_four_witness() -> ChiDiagnostics:
    """Canonical ``2 -> 4`` diagonal-local vs mixed-global non-surjective witness."""
    sq = ChiSquare(
        label="Emergent(2->4)",
        f_pb_carrier=(False, True),
        f_h_carrier=(False, True),
        f_k_carrier=(False, True),
        f_d_carrier=("mid",),
        f_right={False: "mid", True: "mid"},
        f_left={False: "mid", True: "mid"},
        f_fst={False: False, True: True},
        f_snd={False: False, True: True},
    )
    return analyze_chi_square(sq)


# --- C2 Relational Phase Collapse Witnesses (2 -> 1 & 2^n -> 1) ---


def c2_two_to_one_witness() -> ChiDiagnostics:
    """Canonical ``C2`` orbit ``2 -> 1`` non-injective witness (``C2RelativeLossWitness``)."""
    sq = ChiSquare(
        label="C2Orbit(2->1)",
        f_pb_carrier=("in_phase", "anti_phase"),
        f_h_carrier=("orbit",),
        f_k_carrier=("orbit",),
        f_d_carrier=("orbit",),
        f_right={"orbit": "orbit"},
        f_left={"orbit": "orbit"},
        f_fst={"in_phase": "orbit", "anti_phase": "orbit"},
        f_snd={"in_phase": "orbit", "anti_phase": "orbit"},
    )
    return analyze_chi_square(sq)


def c2_pow_two_to_one_witness(n: int) -> ChiDiagnostics:
    """``C2`` diagonal-flip orbit collapse on ``n+1`` bits: ``2^n -> 1`` (``n >= 1``)."""
    if n < 1:
        raise OplaxError(f"c2_pow_two_to_one_witness requires n >= 1, got {n}")
    # Joint C2 orbits on Bool^(n+1) are indexed by relative phase vectors in Bool^n.
    orbits: list[tuple[bool, ...]] = [()]
    for _ in range(n):
        orbits = [vec + (b,) for vec in orbits for b in (False, True)]
    orb_tuple = tuple(orbits)
    sq = ChiSquare(
        label=f"C2Orbit(2^{n}->1)",
        f_pb_carrier=orb_tuple,
        f_h_carrier=("orbit",),
        f_k_carrier=("orbit",),
        f_d_carrier=("orbit",),
        f_right={"orbit": "orbit"},
        f_left={"orbit": "orbit"},
        f_fst={orb: "orbit" for orb in orb_tuple},
        f_snd={orb: "orbit" for orb in orb_tuple},
    )
    return analyze_chi_square(sq)


# --- Guarded Oplax Double Syntax & Evaluator (DoubleKernel.lean Part 4) ---


@dataclass(frozen=True)
class BijCert:
    """Explicit constructive bijection witness certifying ``chi`` upgrade."""

    to_map: Mapping[Any, Any]
    inv_map: Mapping[Any, Any]

    def verify_against_chi(self, chi_hom: SpanHom) -> None:
        src_car = chi_hom.src.carrier
        tgt_car = chi_hom.tgt.carrier
        if set(self.to_map.keys()) != set(src_car):
            raise GuardedInterchangeError("BijCert.to_map domain does not match F(H*K)")
        if set(self.inv_map.keys()) != set(tgt_car):
            raise GuardedInterchangeError("BijCert.inv_map domain does not match F(H)*F(K)")
        for u in src_car:
            if self.to_map[u] != chi_hom.apply(u):
                raise GuardedInterchangeError(
                    f"BijCert.to_map disagrees with chi on {u!r}: "
                    f"{self.to_map[u]!r} != {chi_hom.apply(u)!r}"
                )
            if self.inv_map.get(self.to_map[u]) != u:
                raise GuardedInterchangeError(f"BijCert left_inv failed on {u!r}")
        for y in tgt_car:
            if self.to_map.get(self.inv_map[y]) != y:
                raise GuardedInterchangeError(f"BijCert right_inv failed on {y!r}")


def synthesize_bij_cert(functor: SpanFunctor, h: RelSpan, k: RelSpan) -> BijCert | None:
    """Construct a verified ``BijCert`` for ``chi(F, H, K)`` iff ``chi`` is bijective."""
    diag = analyze_chi(functor, h, k)
    if not diag.is_bijective or diag.inv_map is None:
        return None
    return BijCert(to_map=dict(diag.chi_map), inv_map=dict(diag.inv_map))


@dataclass(frozen=True)
class Atom:
    span: RelSpan


@dataclass(frozen=True)
class IdExpr:
    dom: tuple[Any, ...]
    name: str = "id"


@dataclass(frozen=True)
class Seq:
    first: "GuardedExpr"
    second: "GuardedExpr"


@dataclass(frozen=True)
class Par:
    left: "GuardedExpr"
    right: "GuardedExpr"


@dataclass(frozen=True)
class Assemble:
    functor: SpanFunctor
    inner: "GuardedExpr"


GuardedExpr = Union[Atom, IdExpr, Seq, Par, Assemble]


def eval_guarded_expr(expr: GuardedExpr) -> RelSpan:
    """Evaluate a ``GuardedExpr`` into a concrete finite ``RelSpan``."""
    if isinstance(expr, Atom):
        return expr.span
    if isinstance(expr, IdExpr):
        return id_span(expr.dom, name=expr.name)
    if isinstance(expr, Seq):
        return comp_span(eval_guarded_expr(expr.first), eval_guarded_expr(expr.second))
    if isinstance(expr, Par):
        return coprod_span(eval_guarded_expr(expr.left), eval_guarded_expr(expr.right))
    if isinstance(expr, Assemble):
        return expr.functor.on_span(eval_guarded_expr(expr.inner))
    raise OplaxError(f"Unsupported GuardedExpr node: {expr!r}")


@dataclass(frozen=True)
class ReflProof:
    expr: GuardedExpr


@dataclass(frozen=True)
class TransProof:
    first: "GuardedProof"
    second: "GuardedProof"


@dataclass(frozen=True)
class SeqCong:
    first: "GuardedProof"
    second: "GuardedProof"


@dataclass(frozen=True)
class ParCong:
    left: "GuardedProof"
    right: "GuardedProof"


@dataclass(frozen=True)
class AssembleCong:
    functor: SpanFunctor
    inner: "GuardedProof"


@dataclass(frozen=True)
class ParSeqDistLR:
    e1: GuardedExpr
    e2: GuardedExpr
    e1_p: GuardedExpr
    e2_p: GuardedExpr


@dataclass(frozen=True)
class ParSeqDistRL:
    e1: GuardedExpr
    e2: GuardedExpr
    e1_p: GuardedExpr
    e2_p: GuardedExpr


@dataclass(frozen=True)
class ChiStep:
    functor: SpanFunctor
    e1: GuardedExpr
    e2: GuardedExpr


@dataclass(frozen=True)
class ChiInv:
    functor: SpanFunctor
    e1: GuardedExpr
    e2: GuardedExpr
    bij_cert: BijCert | None = None


GuardedProof = Union[
    ReflProof,
    TransProof,
    SeqCong,
    ParCong,
    AssembleCong,
    ParSeqDistLR,
    ParSeqDistRL,
    ChiStep,
    ChiInv,
]


@dataclass(frozen=True)
class GuardedProofResult:
    """Sound evaluation result of a ``GuardedProof`` with verified BC guard records."""

    src_expr: GuardedExpr
    tgt_expr: GuardedExpr
    span_hom: SpanHom
    verified_bc_guards: tuple[ChiDiagnostics, ...]


def eval_guarded_proof(proof: GuardedProof) -> GuardedProofResult:
    """Evaluate a ``GuardedProof``, rejecting unguarded ``ChiInv`` without valid ``Bij``/BC."""
    if isinstance(proof, ReflProof):
        sp = eval_guarded_expr(proof.expr)
        return GuardedProofResult(proof.expr, proof.expr, SpanHom.identity(sp), ())
    if isinstance(proof, TransProof):
        r1 = eval_guarded_proof(proof.first)
        r2 = eval_guarded_proof(proof.second)
        if r1.tgt_expr != r2.src_expr:
            raise OplaxError(f"TransProof mismatch: {r1.tgt_expr!r} != {r2.src_expr!r}")
        return GuardedProofResult(
            r1.src_expr,
            r2.tgt_expr,
            SpanHom.compose(r2.span_hom, r1.span_hom),
            r1.verified_bc_guards + r2.verified_bc_guards,
        )
    if isinstance(proof, SeqCong):
        r1 = eval_guarded_proof(proof.first)
        r2 = eval_guarded_proof(proof.second)
        return GuardedProofResult(
            Seq(r1.src_expr, r2.src_expr),
            Seq(r1.tgt_expr, r2.tgt_expr),
            comp_span_hom(r1.span_hom, r2.span_hom),
            r1.verified_bc_guards + r2.verified_bc_guards,
        )
    if isinstance(proof, ParCong):
        rl = eval_guarded_proof(proof.left)
        rr = eval_guarded_proof(proof.right)
        return GuardedProofResult(
            Par(rl.src_expr, rr.src_expr),
            Par(rl.tgt_expr, rr.tgt_expr),
            par_span_hom(rl.span_hom, rr.span_hom),
            rl.verified_bc_guards + rr.verified_bc_guards,
        )
    if isinstance(proof, AssembleCong):
        ri = eval_guarded_proof(proof.inner)
        return GuardedProofResult(
            Assemble(proof.functor, ri.src_expr),
            Assemble(proof.functor, ri.tgt_expr),
            proof.functor.on_hom(ri.span_hom),
            ri.verified_bc_guards,
        )
    if isinstance(proof, ParSeqDistLR):
        h = eval_guarded_expr(proof.e1)
        k = eval_guarded_expr(proof.e2)
        h_p = eval_guarded_expr(proof.e1_p)
        k_p = eval_guarded_expr(proof.e2_p)
        return GuardedProofResult(
            Par(Seq(proof.e1, proof.e2), Seq(proof.e1_p, proof.e2_p)),
            Seq(Par(proof.e1, proof.e1_p), Par(proof.e2, proof.e2_p)),
            par_seq_dist_hom_lr(h, k, h_p, k_p),
            (),
        )
    if isinstance(proof, ParSeqDistRL):
        h = eval_guarded_expr(proof.e1)
        k = eval_guarded_expr(proof.e2)
        h_p = eval_guarded_expr(proof.e1_p)
        k_p = eval_guarded_expr(proof.e2_p)
        return GuardedProofResult(
            Seq(Par(proof.e1, proof.e1_p), Par(proof.e2, proof.e2_p)),
            Par(Seq(proof.e1, proof.e2), Seq(proof.e1_p, proof.e2_p)),
            par_seq_dist_hom_rl(h, k, h_p, k_p),
            (),
        )
    if isinstance(proof, ChiStep):
        h = eval_guarded_expr(proof.e1)
        k = eval_guarded_expr(proof.e2)
        return GuardedProofResult(
            Assemble(proof.functor, Seq(proof.e1, proof.e2)),
            Seq(Assemble(proof.functor, proof.e1), Assemble(proof.functor, proof.e2)),
            compute_chi_hom(proof.functor, h, k),
            (),
        )
    if isinstance(proof, ChiInv):
        h = eval_guarded_expr(proof.e1)
        k = eval_guarded_expr(proof.e2)
        diag = analyze_chi(proof.functor, h, k)
        if proof.bij_cert is None:
            raise GuardedInterchangeError(
                "Unguarded ChiInv rejected: explicit BijCert and Beck-Chevalley verification required",
                diagnostics=diag,
            )
        chi_hom = compute_chi_hom(proof.functor, h, k)
        try:
            proof.bij_cert.verify_against_chi(chi_hom)
        except GuardedInterchangeError as exc:
            raise GuardedInterchangeError(str(exc), diagnostics=diag) from exc
        if not (diag.is_bijective and diag.f_image_is_pullback and diag.universal_bc_holds):
            raise GuardedInterchangeError(
                "ChiInv rejected: chi fails FImageIsPullback or universal Beck-Chevalley",
                diagnostics=diag,
            )
        inv_hom = SpanHom(
            src=chi_hom.tgt,
            tgt=chi_hom.src,
            mapping=dict(proof.bij_cert.inv_map),
        )
        return GuardedProofResult(
            Seq(Assemble(proof.functor, proof.e1), Assemble(proof.functor, proof.e2)),
            Assemble(proof.functor, Seq(proof.e1, proof.e2)),
            inv_hom,
            (diag,),
        )
    raise OplaxError(f"Unsupported GuardedProof node: {proof!r}")
