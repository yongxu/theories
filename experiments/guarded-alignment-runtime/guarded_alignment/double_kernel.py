"""Strict 2D double-category and relative 3D certificate kernel.

AI-written (Wave U6 runtime, 24 November 2026). Pure Python 3 standard library.
Mirrors ``Becoming.DoubleKernel`` Parts 1-3:
- Typed object-carrying paths (``TypedPath``), 4-boundary ``Frame``, ``DoubleSig``,
  5-constructor ``SqTerm``, and unique boundary framing (T1).
- Explicit 10-rule strict double-category equality certificate checker (``EqCert``, T2).
- Additive generator-tally model (``NatTallyDoubleCat``, Cor 4.0) separating terms that
  share the exact same 4-boundary frame.
- Conservative relative 3D extension (``Double3Sig``, ``Cell3Term``, ``Eq3Cert``,
  Lem 6, T9) and monotone-weight irreversibility certification.

Rule 2 note: This checker verifies supplied symbolic derivations and semantic tally
refutations; it does not assert that any empirical system obeys strict double laws.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Mapping, Union


class KernelError(ValueError):
    """Raised when a 2D/3D signature, term, or certificate violates typing rules."""


@dataclass(frozen=True)
class TypedPath:
    """Directed path carrying explicit endpoints so ``nil(x) != nil(y)`` for ``x != y``."""

    src: str
    tgt: str
    edges: tuple[str, ...] = ()

    @classmethod
    def nil(cls, obj: str) -> "TypedPath":
        return cls(src=obj, tgt=obj, edges=())


def validate_path(
    path: TypedPath,
    objs: frozenset[str],
    edges: Mapping[str, tuple[str, str]],
    direction: str,
) -> None:
    """Verify every endpoint and edge in ``path`` matches the signature graph."""
    if path.src not in objs:
        raise KernelError(f"{direction} path source {path.src!r} is not a signature object")
    if path.tgt not in objs:
        raise KernelError(f"{direction} path target {path.tgt!r} is not a signature object")
    cur = path.src
    for edge in path.edges:
        if edge not in edges:
            raise KernelError(f"Unknown {direction} generator edge {edge!r}")
        e_src, e_tgt = edges[edge]
        if e_src != cur:
            raise KernelError(
                f"{direction} edge {edge!r} expects source {e_src!r}, got {cur!r}"
            )
        cur = e_tgt
    if cur != path.tgt:
        raise KernelError(
            f"{direction} path ends at {cur!r}, declared target is {path.tgt!r}"
        )


def path_comp(first: TypedPath, second: TypedPath) -> TypedPath:
    """Compose composable typed paths ``first : x -> y`` and ``second : y -> z``."""
    if first.tgt != second.src:
        raise KernelError(
            f"Path composition mismatch: {first.tgt!r} != {second.src!r}"
        )
    return TypedPath(src=first.src, tgt=second.tgt, edges=first.edges + second.edges)


@dataclass(frozen=True)
class Frame:
    """Four-boundary square frame with matching corner objects."""

    tl: str
    tr: str
    bl: str
    br: str
    top: TypedPath
    bot: TypedPath
    left: TypedPath
    right: TypedPath

    def validate_corners(self) -> None:
        if (self.top.src, self.top.tgt) != (self.tl, self.tr):
            raise KernelError(
                f"Frame top endpoints {(self.top.src, self.top.tgt)} != {(self.tl, self.tr)}"
            )
        if (self.bot.src, self.bot.tgt) != (self.bl, self.br):
            raise KernelError(
                f"Frame bot endpoints {(self.bot.src, self.bot.tgt)} != {(self.bl, self.br)}"
            )
        if (self.left.src, self.left.tgt) != (self.tl, self.bl):
            raise KernelError(
                f"Frame left endpoints {(self.left.src, self.left.tgt)} != {(self.tl, self.bl)}"
            )
        if (self.right.src, self.right.tgt) != (self.tr, self.br):
            raise KernelError(
                f"Frame right endpoints {(self.right.src, self.right.tgt)} != {(self.tr, self.br)}"
            )


@dataclass(frozen=True)
class DoubleSig:
    """Bidirectional 2D signature ``Sigma = (O, H, V, A; boundary)``."""

    objs: frozenset[str]
    h_gens: Mapping[str, tuple[str, str]]
    v_gens: Mapping[str, tuple[str, str]]
    sq_gens: Mapping[str, Frame]

    def __post_init__(self) -> None:
        self.validate()

    def validate(self) -> None:
        for name, (src, tgt) in self.h_gens.items():
            if src not in self.objs or tgt not in self.objs:
                raise KernelError(f"HGen {name!r} endpoints {(src, tgt)} outside objs")
        for name, (src, tgt) in self.v_gens.items():
            if src not in self.objs or tgt not in self.objs:
                raise KernelError(f"VGen {name!r} endpoints {(src, tgt)} outside objs")
        for name, frame in self.sq_gens.items():
            self.validate_frame(frame, context=f"SqGen {name!r}")

    def validate_h_path(self, path: TypedPath) -> None:
        validate_path(path, self.objs, self.h_gens, "horizontal")

    def validate_v_path(self, path: TypedPath) -> None:
        validate_path(path, self.objs, self.v_gens, "vertical")

    def validate_frame(self, frame: Frame, context: str = "frame") -> None:
        for corner in (frame.tl, frame.tr, frame.bl, frame.br):
            if corner not in self.objs:
                raise KernelError(f"{context}: corner {corner!r} outside objs")
        frame.validate_corners()
        self.validate_h_path(frame.top)
        self.validate_h_path(frame.bot)
        self.validate_v_path(frame.left)
        self.validate_v_path(frame.right)

    def h_path(self, start: str, *edges: str) -> TypedPath:
        cur = start
        for edge in edges:
            if edge not in self.h_gens:
                raise KernelError(f"Unknown horizontal edge {edge!r}")
            src, tgt = self.h_gens[edge]
            if src != cur:
                raise KernelError(f"Horizontal edge {edge!r} expects {src!r}, got {cur!r}")
            cur = tgt
        path = TypedPath(src=start, tgt=cur, edges=edges)
        self.validate_h_path(path)
        return path

    def v_path(self, start: str, *edges: str) -> TypedPath:
        cur = start
        for edge in edges:
            if edge not in self.v_gens:
                raise KernelError(f"Unknown vertical edge {edge!r}")
            src, tgt = self.v_gens[edge]
            if src != cur:
                raise KernelError(f"Vertical edge {edge!r} expects {src!r}, got {cur!r}")
            cur = tgt
        path = TypedPath(src=start, tgt=cur, edges=edges)
        self.validate_v_path(path)
        return path


# --- Five-constructor 2D square terms ---


@dataclass(frozen=True)
class Gen:
    name: str


@dataclass(frozen=True)
class IdH:
    path: TypedPath


@dataclass(frozen=True)
class IdV:
    path: TypedPath


@dataclass(frozen=True)
class CompH:
    left: "SqTerm"
    right: "SqTerm"


@dataclass(frozen=True)
class CompV:
    top: "SqTerm"
    bot: "SqTerm"


SqTerm = Union[Gen, IdH, IdV, CompH, CompV]


def infer_frame(sig: DoubleSig, term: SqTerm) -> Frame:
    """Compute the unique compatible 4-boundary ``Frame`` of ``term`` (T1).

    Raises ``KernelError`` if any internal boundary or corner disagrees.
    """
    if isinstance(term, Gen):
        if term.name not in sig.sq_gens:
            raise KernelError(f"Unknown square generator {term.name!r}")
        return sig.sq_gens[term.name]
    if isinstance(term, IdH):
        sig.validate_v_path(term.path)
        a, c = term.path.src, term.path.tgt
        return Frame(a, a, c, c, TypedPath.nil(a), TypedPath.nil(c), term.path, term.path)
    if isinstance(term, IdV):
        sig.validate_h_path(term.path)
        a, b = term.path.src, term.path.tgt
        return Frame(a, b, a, b, term.path, term.path, TypedPath.nil(a), TypedPath.nil(b))
    if isinstance(term, CompH):
        fp = infer_frame(sig, term.left)
        fq = infer_frame(sig, term.right)
        if fp.tr != fq.tl or fp.br != fq.bl or fp.right != fq.left:
            raise KernelError(
                f"CompH vertical interface mismatch: right={fp.right} vs left={fq.left}"
            )
        return Frame(
            tl=fp.tl,
            tr=fq.tr,
            bl=fp.bl,
            br=fq.br,
            top=path_comp(fp.top, fq.top),
            bot=path_comp(fp.bot, fq.bot),
            left=fp.left,
            right=fq.right,
        )
    if isinstance(term, CompV):
        fp = infer_frame(sig, term.top)
        fq = infer_frame(sig, term.bot)
        if fp.bl != fq.tl or fp.br != fq.tr or fp.bot != fq.top:
            raise KernelError(
                f"CompV horizontal interface mismatch: bot={fp.bot} vs top={fq.top}"
            )
        return Frame(
            tl=fp.tl,
            tr=fp.tr,
            bl=fq.bl,
            br=fq.br,
            top=fp.top,
            bot=fq.bot,
            left=path_comp(fp.left, fq.left),
            right=path_comp(fp.right, fq.right),
        )
    raise KernelError(f"Unsupported SqTerm node: {term!r}")


# --- 10-Rule 2D Equality Certificate Tree (EqCert, T2) ---


@dataclass(frozen=True)
class Refl:
    term: SqTerm


@dataclass(frozen=True)
class Symm:
    cert: "EqCert"


@dataclass(frozen=True)
class Trans:
    first: "EqCert"
    second: "EqCert"


@dataclass(frozen=True)
class CongH:
    left: "EqCert"
    right: "EqCert"


@dataclass(frozen=True)
class CongV:
    top: "EqCert"
    bot: "EqCert"


@dataclass(frozen=True)
class AssocH:
    p: SqTerm
    q: SqTerm
    r: SqTerm


@dataclass(frozen=True)
class IdHL:
    p: SqTerm


@dataclass(frozen=True)
class IdHR:
    p: SqTerm


@dataclass(frozen=True)
class AssocV:
    p: SqTerm
    q: SqTerm
    r: SqTerm


@dataclass(frozen=True)
class IdVL:
    p: SqTerm


@dataclass(frozen=True)
class IdVR:
    p: SqTerm


@dataclass(frozen=True)
class Interchange:
    p: SqTerm
    q: SqTerm
    r: SqTerm
    s: SqTerm


@dataclass(frozen=True)
class IdHCompV:
    u: TypedPath
    v: TypedPath


@dataclass(frozen=True)
class IdVCompH:
    f: TypedPath
    g: TypedPath


@dataclass(frozen=True)
class IdHIdV:
    obj: str


EqCert = Union[
    Refl,
    Symm,
    Trans,
    CongH,
    CongV,
    AssocH,
    IdHL,
    IdHR,
    AssocV,
    IdVL,
    IdVR,
    Interchange,
    IdHCompV,
    IdVCompH,
    IdHIdV,
]


@dataclass(frozen=True)
class EqCertResult:
    """Verified endpoints and shared 4-boundary frame of an ``EqCert`` (T2)."""

    lhs: SqTerm
    rhs: SqTerm
    frame: Frame


def check_eq_cert(sig: DoubleSig, cert: EqCert) -> EqCertResult:
    """Verify a 2D ``EqCert`` derivation and confirm frame preservation (T2)."""
    if isinstance(cert, Refl):
        frame = infer_frame(sig, cert.term)
        return EqCertResult(cert.term, cert.term, frame)
    if isinstance(cert, Symm):
        res = check_eq_cert(sig, cert.cert)
        return EqCertResult(res.rhs, res.lhs, res.frame)
    if isinstance(cert, Trans):
        r1 = check_eq_cert(sig, cert.first)
        r2 = check_eq_cert(sig, cert.second)
        if r1.rhs != r2.lhs:
            raise KernelError(f"Trans mismatch: {r1.rhs!r} != {r2.lhs!r}")
        if r1.frame != r2.frame:
            raise KernelError(f"Trans frame mismatch: {r1.frame!r} != {r2.frame!r}")
        return EqCertResult(r1.lhs, r2.rhs, r1.frame)
    if isinstance(cert, CongH):
        rl = check_eq_cert(sig, cert.left)
        rr = check_eq_cert(sig, cert.right)
        lhs = CompH(rl.lhs, rr.lhs)
        rhs = CompH(rl.rhs, rr.rhs)
        frame = infer_frame(sig, lhs)
        if infer_frame(sig, rhs) != frame:
            raise KernelError("CongH internal frame inconsistency")
        return EqCertResult(lhs, rhs, frame)
    if isinstance(cert, CongV):
        rt = check_eq_cert(sig, cert.top)
        rb = check_eq_cert(sig, cert.bot)
        lhs = CompV(rt.lhs, rb.lhs)
        rhs = CompV(rt.rhs, rb.rhs)
        frame = infer_frame(sig, lhs)
        if infer_frame(sig, rhs) != frame:
            raise KernelError("CongV internal frame inconsistency")
        return EqCertResult(lhs, rhs, frame)
    if isinstance(cert, AssocH):
        lhs = CompH(CompH(cert.p, cert.q), cert.r)
        rhs = CompH(cert.p, CompH(cert.q, cert.r))
        return _check_law_pair(sig, lhs, rhs, "AssocH")
    if isinstance(cert, IdHL):
        fp = infer_frame(sig, cert.p)
        lhs = CompH(IdH(fp.left), cert.p)
        return _check_law_pair(sig, lhs, cert.p, "IdHL")
    if isinstance(cert, IdHR):
        fp = infer_frame(sig, cert.p)
        lhs = CompH(cert.p, IdH(fp.right))
        return _check_law_pair(sig, lhs, cert.p, "IdHR")
    if isinstance(cert, AssocV):
        lhs = CompV(CompV(cert.p, cert.q), cert.r)
        rhs = CompV(cert.p, CompV(cert.q, cert.r))
        return _check_law_pair(sig, lhs, rhs, "AssocV")
    if isinstance(cert, IdVL):
        fp = infer_frame(sig, cert.p)
        lhs = CompV(IdV(fp.top), cert.p)
        return _check_law_pair(sig, lhs, cert.p, "IdVL")
    if isinstance(cert, IdVR):
        fp = infer_frame(sig, cert.p)
        lhs = CompV(cert.p, IdV(fp.bot))
        return _check_law_pair(sig, lhs, cert.p, "IdVR")
    if isinstance(cert, Interchange):
        lhs = CompV(CompH(cert.p, cert.q), CompH(cert.r, cert.s))
        rhs = CompH(CompV(cert.p, cert.r), CompV(cert.q, cert.s))
        return _check_law_pair(sig, lhs, rhs, "Interchange")
    if isinstance(cert, IdHCompV):
        sig.validate_v_path(cert.u)
        sig.validate_v_path(cert.v)
        lhs = IdH(path_comp(cert.u, cert.v))
        rhs = CompV(IdH(cert.u), IdH(cert.v))
        return _check_law_pair(sig, lhs, rhs, "IdHCompV")
    if isinstance(cert, IdVCompH):
        sig.validate_h_path(cert.f)
        sig.validate_h_path(cert.g)
        lhs = IdV(path_comp(cert.f, cert.g))
        rhs = CompH(IdV(cert.f), IdV(cert.g))
        return _check_law_pair(sig, lhs, rhs, "IdVCompH")
    if isinstance(cert, IdHIdV):
        if cert.obj not in sig.objs:
            raise KernelError(f"IdHIdV object {cert.obj!r} outside objs")
        lhs = IdH(TypedPath.nil(cert.obj))
        rhs = IdV(TypedPath.nil(cert.obj))
        return _check_law_pair(sig, lhs, rhs, "IdHIdV")
    raise KernelError(f"Unsupported EqCert node: {cert!r}")


def _check_law_pair(sig: DoubleSig, lhs: SqTerm, rhs: SqTerm, label: str) -> EqCertResult:
    fl = infer_frame(sig, lhs)
    fr = infer_frame(sig, rhs)
    if fl != fr:
        raise KernelError(f"{label} frame mismatch: {fl!r} != {fr!r}")
    return EqCertResult(lhs, rhs, fl)


def verify_eq_cert(
    sig: DoubleSig, cert: EqCert, expected_lhs: SqTerm, expected_rhs: SqTerm
) -> EqCertResult:
    """Verify ``cert`` proves ``expected_lhs == expected_rhs`` in ``sig``."""
    res = check_eq_cert(sig, cert)
    if res.lhs != expected_lhs or res.rhs != expected_rhs:
        raise KernelError(
            f"EqCert proves ({res.lhs!r}, {res.rhs!r}), expected ({expected_lhs!r}, {expected_rhs!r})"
        )
    return res


# --- Additive Weight Tally Separator (natTallyDoubleCat, Cor 4.0) ---


def term_weight(term: SqTerm, weights: Mapping[str, int]) -> int:
    """Evaluate a 2D term in ``natTallyDoubleCat`` under nonnegative generator weights."""
    if isinstance(term, Gen):
        w = weights.get(term.name, 0)
        if w < 0:
            raise KernelError(f"Generator weight for {term.name!r} must be >= 0, got {w}")
        return w
    if isinstance(term, (IdH, IdV)):
        return 0
    if isinstance(term, CompH):
        return term_weight(term.left, weights) + term_weight(term.right, weights)
    if isinstance(term, CompV):
        return term_weight(term.top, weights) + term_weight(term.bot, weights)
    raise KernelError(f"Unsupported SqTerm node: {term!r}")


def generator_multiset(term: SqTerm) -> dict[str, int]:
    """Count occurrences of each square generator inside ``term``."""
    if isinstance(term, Gen):
        return {term.name: 1}
    if isinstance(term, (IdH, IdV)):
        return {}
    if isinstance(term, CompH):
        return _merge_counts(generator_multiset(term.left), generator_multiset(term.right))
    if isinstance(term, CompV):
        return _merge_counts(generator_multiset(term.top), generator_multiset(term.bot))
    raise KernelError(f"Unsupported SqTerm node: {term!r}")


def _merge_counts(a: dict[str, int], b: dict[str, int]) -> dict[str, int]:
    out = dict(a)
    for k, v in b.items():
        out[k] = out.get(k, 0) + v
    return out


@dataclass(frozen=True)
class TallySeparationWitness:
    """Refutation witness proving ``not EqCert(lhs, rhs)`` via ``natTallyDoubleCat`` (Cor 4.0)."""

    weights: dict[str, int]
    lhs_weight: int
    rhs_weight: int
    same_frame: bool


def check_weight_separation(
    sig: DoubleSig, lhs: SqTerm, rhs: SqTerm, weights: Mapping[str, int]
) -> TallySeparationWitness | None:
    """Check whether ``weights`` separates ``lhs`` and ``rhs`` in ``natTallyDoubleCat``."""
    fl = infer_frame(sig, lhs)
    fr = infer_frame(sig, rhs)
    wl = term_weight(lhs, weights)
    wr = term_weight(rhs, weights)
    if wl == wr:
        return None
    return TallySeparationWitness(
        weights=dict(weights),
        lhs_weight=wl,
        rhs_weight=wr,
        same_frame=(fl == fr),
    )


def find_tally_separator(
    sig: DoubleSig, lhs: SqTerm, rhs: SqTerm
) -> TallySeparationWitness | None:
    """Synthesize a 0/1 generator weight separating ``lhs`` and ``rhs`` when counts differ."""
    fl = infer_frame(sig, lhs)
    fr = infer_frame(sig, rhs)
    c_lhs = generator_multiset(lhs)
    c_rhs = generator_multiset(rhs)
    for gen_name in sorted(set(c_lhs) | set(c_rhs)):
        if c_lhs.get(gen_name, 0) != c_rhs.get(gen_name, 0):
            weights = {g: (1 if g == gen_name else 0) for g in sig.sq_gens}
            return TallySeparationWitness(
                weights=weights,
                lhs_weight=c_lhs.get(gen_name, 0),
                rhs_weight=c_rhs.get(gen_name, 0),
                same_frame=(fl == fr),
            )
    return None


# --- Conservative Relative 3D Extension (Double3Sig, Cell3Term, Eq3Cert, Lem 6, T9) ---


@dataclass(frozen=True)
class Cell3GenSpec:
    """Directed 3-cell generator between parallel well-framed 2D terms."""

    src: SqTerm
    tgt: SqTerm


@dataclass(frozen=True)
class Double3Sig:
    """Relative 3D extension ``(D_Sigma, G_3)`` over a 2D ``DoubleSig``."""

    base: DoubleSig
    cell3_gens: Mapping[str, Cell3GenSpec]

    def __post_init__(self) -> None:
        self.validate()

    def validate(self) -> None:
        self.base.validate()
        for name, spec in self.cell3_gens.items():
            fs = infer_frame(self.base, spec.src)
            ft = infer_frame(self.base, spec.tgt)
            if fs != ft:
                raise KernelError(
                    f"Cell3Gen {name!r} endpoints have distinct frames: {fs!r} != {ft!r}"
                )


@dataclass(frozen=True)
class Gen3:
    name: str


@dataclass(frozen=True)
class Id3:
    sq: SqTerm


@dataclass(frozen=True)
class CompR:
    first: "Cell3Term"
    second: "Cell3Term"
    mid_cert: EqCert | None = None


@dataclass(frozen=True)
class CompH3:
    left: "Cell3Term"
    right: "Cell3Term"


@dataclass(frozen=True)
class CompV3:
    top: "Cell3Term"
    bot: "Cell3Term"


@dataclass(frozen=True)
class Transport3:
    inner: "Cell3Term"
    src_cert: EqCert
    tgt_cert: EqCert


Cell3Term = Union[Gen3, Id3, CompR, CompH3, CompV3, Transport3]


@dataclass(frozen=True)
class Endpoints3Result:
    """Verified 2D endpoints and common 4-boundary frame of a ``Cell3Term``."""

    src: SqTerm
    tgt: SqTerm
    frame: Frame


def check_endpoints3(sig3: Double3Sig, cell: Cell3Term) -> Endpoints3Result:
    """Verify ``HasEndpoints3`` for ``cell`` and return ``(src, tgt, frame)``."""
    base = sig3.base
    if isinstance(cell, Gen3):
        if cell.name not in sig3.cell3_gens:
            raise KernelError(f"Unknown 3-cell generator {cell.name!r}")
        spec = sig3.cell3_gens[cell.name]
        return Endpoints3Result(spec.src, spec.tgt, infer_frame(base, spec.src))
    if isinstance(cell, Id3):
        frame = infer_frame(base, cell.sq)
        return Endpoints3Result(cell.sq, cell.sq, frame)
    if isinstance(cell, CompR):
        e1 = check_endpoints3(sig3, cell.first)
        e2 = check_endpoints3(sig3, cell.second)
        if cell.mid_cert is None:
            if e1.tgt != e2.src:
                raise KernelError(
                    f"CompR requires EqCert linking {e1.tgt!r} to {e2.src!r}"
                )
        else:
            verify_eq_cert(base, cell.mid_cert, e1.tgt, e2.src)
        return Endpoints3Result(e1.src, e2.tgt, e1.frame)
    if isinstance(cell, CompH3):
        el = check_endpoints3(sig3, cell.left)
        er = check_endpoints3(sig3, cell.right)
        src = CompH(el.src, er.src)
        tgt = CompH(el.tgt, er.tgt)
        frame = infer_frame(base, src)
        if infer_frame(base, tgt) != frame:
            raise KernelError("CompH3 target frame mismatch")
        return Endpoints3Result(src, tgt, frame)
    if isinstance(cell, CompV3):
        et = check_endpoints3(sig3, cell.top)
        eb = check_endpoints3(sig3, cell.bot)
        src = CompV(et.src, eb.src)
        tgt = CompV(et.tgt, eb.tgt)
        frame = infer_frame(base, src)
        if infer_frame(base, tgt) != frame:
            raise KernelError("CompV3 target frame mismatch")
        return Endpoints3Result(src, tgt, frame)
    if isinstance(cell, Transport3):
        inner = check_endpoints3(sig3, cell.inner)
        sr = check_eq_cert(base, cell.src_cert)
        tr = check_eq_cert(base, cell.tgt_cert)
        if sr.lhs != inner.src:
            raise KernelError(
                f"Transport3 src_cert starts at {sr.lhs!r}, expected {inner.src!r}"
            )
        if tr.lhs != inner.tgt:
            raise KernelError(
                f"Transport3 tgt_cert starts at {tr.lhs!r}, expected {inner.tgt!r}"
            )
        return Endpoints3Result(sr.rhs, tr.rhs, inner.frame)
    raise KernelError(f"Unsupported Cell3Term node: {cell!r}")


# --- 3-Cell Equality Certificates (Eq3Cert, Lem 6, T9) ---


@dataclass(frozen=True)
class Refl3:
    cell: Cell3Term


@dataclass(frozen=True)
class Symm3:
    cert: "Eq3Cert"


@dataclass(frozen=True)
class Trans3:
    first: "Eq3Cert"
    second: "Eq3Cert"


@dataclass(frozen=True)
class TransportBase:
    inner: Cell3Term
    src_cert: EqCert
    tgt_cert: EqCert


@dataclass(frozen=True)
class AssocR:
    c1: Cell3Term
    c2: Cell3Term
    c3: Cell3Term
    mid12: EqCert | None = None
    mid23: EqCert | None = None


@dataclass(frozen=True)
class IdRL:
    cell: Cell3Term


@dataclass(frozen=True)
class IdRR:
    cell: Cell3Term


@dataclass(frozen=True)
class AssocH3:
    c1: Cell3Term
    c2: Cell3Term
    c3: Cell3Term


@dataclass(frozen=True)
class IdH3L:
    cell: Cell3Term


@dataclass(frozen=True)
class IdH3R:
    cell: Cell3Term


@dataclass(frozen=True)
class AssocV3:
    c1: Cell3Term
    c2: Cell3Term
    c3: Cell3Term


@dataclass(frozen=True)
class IdV3L:
    cell: Cell3Term


@dataclass(frozen=True)
class IdV3R:
    cell: Cell3Term


@dataclass(frozen=True)
class InterchangeHV:
    c1: Cell3Term
    c2: Cell3Term
    c3: Cell3Term
    c4: Cell3Term


@dataclass(frozen=True)
class InterchangeHR:
    c1: Cell3Term
    c2: Cell3Term
    c3: Cell3Term
    c4: Cell3Term
    mid12: EqCert | None = None
    mid34: EqCert | None = None


@dataclass(frozen=True)
class InterchangeVR:
    c1: Cell3Term
    c2: Cell3Term
    c3: Cell3Term
    c4: Cell3Term
    mid12: EqCert | None = None
    mid34: EqCert | None = None


@dataclass(frozen=True)
class Id3CompH:
    p: SqTerm
    q: SqTerm


@dataclass(frozen=True)
class Id3CompV:
    p: SqTerm
    q: SqTerm


@dataclass(frozen=True)
class CongR:
    first: "Eq3Cert"
    second: "Eq3Cert"
    mid_lhs: EqCert | None = None
    mid_rhs: EqCert | None = None


@dataclass(frozen=True)
class CongH3:
    left: "Eq3Cert"
    right: "Eq3Cert"


@dataclass(frozen=True)
class CongV3:
    top: "Eq3Cert"
    bot: "Eq3Cert"


Eq3Cert = Union[
    Refl3,
    Symm3,
    Trans3,
    TransportBase,
    AssocR,
    IdRL,
    IdRR,
    AssocH3,
    IdH3L,
    IdH3R,
    AssocV3,
    IdV3L,
    IdV3R,
    InterchangeHV,
    InterchangeHR,
    InterchangeVR,
    Id3CompH,
    Id3CompV,
    CongR,
    CongH3,
    CongV3,
]


@dataclass(frozen=True)
class Eq3CertResult:
    """Verified 3-cell equality with constructive 2D endpoint certificates (Lem 6 / T9)."""

    lhs: Cell3Term
    rhs: Cell3Term
    lhs_endpoints: Endpoints3Result
    rhs_endpoints: Endpoints3Result
    src_eq_cert: EqCert
    tgt_eq_cert: EqCert


def check_eq3_cert(sig3: Double3Sig, cert: Eq3Cert) -> Eq3CertResult:
    """Verify a 3D ``Eq3Cert`` and synthesize 2D ``EqCert``s linking endpoints (Lem 6)."""
    base = sig3.base
    if isinstance(cert, Refl3):
        ep = check_endpoints3(sig3, cert.cell)
        return Eq3CertResult(cert.cell, cert.cell, ep, ep, Refl(ep.src), Refl(ep.tgt))
    if isinstance(cert, Symm3):
        r = check_eq3_cert(sig3, cert.cert)
        return Eq3CertResult(
            r.rhs, r.lhs, r.rhs_endpoints, r.lhs_endpoints,
            Symm(r.src_eq_cert), Symm(r.tgt_eq_cert),
        )
    if isinstance(cert, Trans3):
        r1 = check_eq3_cert(sig3, cert.first)
        r2 = check_eq3_cert(sig3, cert.second)
        if r1.rhs != r2.lhs:
            raise KernelError(f"Trans3 mismatch: {r1.rhs!r} != {r2.lhs!r}")
        return Eq3CertResult(
            r1.lhs,
            r2.rhs,
            r1.lhs_endpoints,
            r2.rhs_endpoints,
            Trans(r1.src_eq_cert, r2.src_eq_cert),
            Trans(r1.tgt_eq_cert, r2.tgt_eq_cert),
        )
    if isinstance(cert, TransportBase):
        lhs = cert.inner
        rhs = Transport3(cert.inner, cert.src_cert, cert.tgt_cert)
        el = check_endpoints3(sig3, lhs)
        er = check_endpoints3(sig3, rhs)
        return Eq3CertResult(lhs, rhs, el, er, cert.src_cert, cert.tgt_cert)
    if isinstance(cert, AssocR):
        lhs = CompR(CompR(cert.c1, cert.c2, cert.mid12), cert.c3, cert.mid23)
        rhs = CompR(cert.c1, CompR(cert.c2, cert.c3, cert.mid23), cert.mid12)
        return _check_3d_same_endpoints(sig3, lhs, rhs)
    if isinstance(cert, IdRL):
        ep = check_endpoints3(sig3, cert.cell)
        lhs = CompR(Id3(ep.src), cert.cell)
        return _check_3d_same_endpoints(sig3, lhs, cert.cell)
    if isinstance(cert, IdRR):
        ep = check_endpoints3(sig3, cert.cell)
        lhs = CompR(cert.cell, Id3(ep.tgt))
        return _check_3d_same_endpoints(sig3, lhs, cert.cell)
    if isinstance(cert, AssocH3):
        e1 = check_endpoints3(sig3, cert.c1)
        e2 = check_endpoints3(sig3, cert.c2)
        e3 = check_endpoints3(sig3, cert.c3)
        lhs = CompH3(CompH3(cert.c1, cert.c2), cert.c3)
        rhs = CompH3(cert.c1, CompH3(cert.c2, cert.c3))
        el = check_endpoints3(sig3, lhs)
        er = check_endpoints3(sig3, rhs)
        sc = AssocH(e1.src, e2.src, e3.src)
        tc = AssocH(e1.tgt, e2.tgt, e3.tgt)
        verify_eq_cert(base, sc, el.src, er.src)
        verify_eq_cert(base, tc, el.tgt, er.tgt)
        return Eq3CertResult(lhs, rhs, el, er, sc, tc)
    if isinstance(cert, IdH3L):
        ep = check_endpoints3(sig3, cert.cell)
        lhs = CompH3(Id3(IdH(ep.frame.left)), cert.cell)
        el = check_endpoints3(sig3, lhs)
        sc, tc = IdHL(ep.src), IdHL(ep.tgt)
        verify_eq_cert(base, sc, el.src, ep.src)
        verify_eq_cert(base, tc, el.tgt, ep.tgt)
        return Eq3CertResult(lhs, cert.cell, el, ep, sc, tc)
    if isinstance(cert, IdH3R):
        ep = check_endpoints3(sig3, cert.cell)
        lhs = CompH3(cert.cell, Id3(IdH(ep.frame.right)))
        el = check_endpoints3(sig3, lhs)
        sc, tc = IdHR(ep.src), IdHR(ep.tgt)
        verify_eq_cert(base, sc, el.src, ep.src)
        verify_eq_cert(base, tc, el.tgt, ep.tgt)
        return Eq3CertResult(lhs, cert.cell, el, ep, sc, tc)
    if isinstance(cert, AssocV3):
        e1 = check_endpoints3(sig3, cert.c1)
        e2 = check_endpoints3(sig3, cert.c2)
        e3 = check_endpoints3(sig3, cert.c3)
        lhs = CompV3(CompV3(cert.c1, cert.c2), cert.c3)
        rhs = CompV3(cert.c1, CompV3(cert.c2, cert.c3))
        el = check_endpoints3(sig3, lhs)
        er = check_endpoints3(sig3, rhs)
        sc = AssocV(e1.src, e2.src, e3.src)
        tc = AssocV(e1.tgt, e2.tgt, e3.tgt)
        verify_eq_cert(base, sc, el.src, er.src)
        verify_eq_cert(base, tc, el.tgt, er.tgt)
        return Eq3CertResult(lhs, rhs, el, er, sc, tc)
    if isinstance(cert, IdV3L):
        ep = check_endpoints3(sig3, cert.cell)
        lhs = CompV3(Id3(IdV(ep.frame.top)), cert.cell)
        el = check_endpoints3(sig3, lhs)
        sc, tc = IdVL(ep.src), IdVL(ep.tgt)
        verify_eq_cert(base, sc, el.src, ep.src)
        verify_eq_cert(base, tc, el.tgt, ep.tgt)
        return Eq3CertResult(lhs, cert.cell, el, ep, sc, tc)
    if isinstance(cert, IdV3R):
        ep = check_endpoints3(sig3, cert.cell)
        lhs = CompV3(cert.cell, Id3(IdV(ep.frame.bot)))
        el = check_endpoints3(sig3, lhs)
        sc, tc = IdVR(ep.src), IdVR(ep.tgt)
        verify_eq_cert(base, sc, el.src, ep.src)
        verify_eq_cert(base, tc, el.tgt, ep.tgt)
        return Eq3CertResult(lhs, cert.cell, el, ep, sc, tc)
    if isinstance(cert, InterchangeHV):
        e1 = check_endpoints3(sig3, cert.c1)
        e2 = check_endpoints3(sig3, cert.c2)
        e3 = check_endpoints3(sig3, cert.c3)
        e4 = check_endpoints3(sig3, cert.c4)
        lhs = CompV3(CompH3(cert.c1, cert.c2), CompH3(cert.c3, cert.c4))
        rhs = CompH3(CompV3(cert.c1, cert.c3), CompV3(cert.c2, cert.c4))
        el = check_endpoints3(sig3, lhs)
        er = check_endpoints3(sig3, rhs)
        sc = Interchange(e1.src, e2.src, e3.src, e4.src)
        tc = Interchange(e1.tgt, e2.tgt, e3.tgt, e4.tgt)
        verify_eq_cert(base, sc, el.src, er.src)
        verify_eq_cert(base, tc, el.tgt, er.tgt)
        return Eq3CertResult(lhs, rhs, el, er, sc, tc)
    if isinstance(cert, InterchangeHR):
        e1 = check_endpoints3(sig3, cert.c1)
        e3 = check_endpoints3(sig3, cert.c3)
        mid_h = CongH(
            cert.mid12 if cert.mid12 is not None else Refl(e1.tgt),
            cert.mid34 if cert.mid34 is not None else Refl(e3.tgt),
        )
        lhs = CompH3(CompR(cert.c1, cert.c2, cert.mid12), CompR(cert.c3, cert.c4, cert.mid34))
        rhs = CompR(CompH3(cert.c1, cert.c3), CompH3(cert.c2, cert.c4), mid_h)
        return _check_3d_same_endpoints(sig3, lhs, rhs)
    if isinstance(cert, InterchangeVR):
        e1 = check_endpoints3(sig3, cert.c1)
        e3 = check_endpoints3(sig3, cert.c3)
        mid_v = CongV(
            cert.mid12 if cert.mid12 is not None else Refl(e1.tgt),
            cert.mid34 if cert.mid34 is not None else Refl(e3.tgt),
        )
        lhs = CompV3(CompR(cert.c1, cert.c2, cert.mid12), CompR(cert.c3, cert.c4, cert.mid34))
        rhs = CompR(CompV3(cert.c1, cert.c3), CompV3(cert.c2, cert.c4), mid_v)
        return _check_3d_same_endpoints(sig3, lhs, rhs)
    if isinstance(cert, Id3CompH):
        lhs = Id3(CompH(cert.p, cert.q))
        rhs = CompH3(Id3(cert.p), Id3(cert.q))
        return _check_3d_same_endpoints(sig3, lhs, rhs)
    if isinstance(cert, Id3CompV):
        lhs = Id3(CompV(cert.p, cert.q))
        rhs = CompV3(Id3(cert.p), Id3(cert.q))
        return _check_3d_same_endpoints(sig3, lhs, rhs)
    if isinstance(cert, CongR):
        r1 = check_eq3_cert(sig3, cert.first)
        r2 = check_eq3_cert(sig3, cert.second)
        lhs = CompR(r1.lhs, r2.lhs, cert.mid_lhs)
        mid_rhs = cert.mid_rhs
        if mid_rhs is None:
            mid_l = cert.mid_lhs if cert.mid_lhs is not None else Refl(r1.lhs_endpoints.tgt)
            mid_rhs = Trans(Symm(r1.tgt_eq_cert), Trans(mid_l, r2.src_eq_cert))
        rhs = CompR(r1.rhs, r2.rhs, mid_rhs)
        el = check_endpoints3(sig3, lhs)
        er = check_endpoints3(sig3, rhs)
        return Eq3CertResult(lhs, rhs, el, er, r1.src_eq_cert, r2.tgt_eq_cert)
    if isinstance(cert, CongH3):
        rl = check_eq3_cert(sig3, cert.left)
        rr = check_eq3_cert(sig3, cert.right)
        lhs = CompH3(rl.lhs, rr.lhs)
        rhs = CompH3(rl.rhs, rr.rhs)
        el = check_endpoints3(sig3, lhs)
        er = check_endpoints3(sig3, rhs)
        sc = CongH(rl.src_eq_cert, rr.src_eq_cert)
        tc = CongH(rl.tgt_eq_cert, rr.tgt_eq_cert)
        verify_eq_cert(base, sc, el.src, er.src)
        verify_eq_cert(base, tc, el.tgt, er.tgt)
        return Eq3CertResult(lhs, rhs, el, er, sc, tc)
    if isinstance(cert, CongV3):
        rt = check_eq3_cert(sig3, cert.top)
        rb = check_eq3_cert(sig3, cert.bot)
        lhs = CompV3(rt.lhs, rb.lhs)
        rhs = CompV3(rt.rhs, rb.rhs)
        el = check_endpoints3(sig3, lhs)
        er = check_endpoints3(sig3, rhs)
        sc = CongV(rt.src_eq_cert, rb.src_eq_cert)
        tc = CongV(rt.tgt_eq_cert, rb.tgt_eq_cert)
        verify_eq_cert(base, sc, el.src, er.src)
        verify_eq_cert(base, tc, el.tgt, er.tgt)
        return Eq3CertResult(lhs, rhs, el, er, sc, tc)
    raise KernelError(f"Unsupported Eq3Cert node: {cert!r}")


def _check_3d_same_endpoints(
    sig3: Double3Sig, lhs: Cell3Term, rhs: Cell3Term
) -> Eq3CertResult:
    el = check_endpoints3(sig3, lhs)
    er = check_endpoints3(sig3, rhs)
    if el.src != er.src or el.tgt != er.tgt:
        raise KernelError(
            f"3D law endpoint mismatch: ({el.src!r}, {el.tgt!r}) != ({er.src!r}, {er.tgt!r})"
        )
    return Eq3CertResult(lhs, rhs, el, er, Refl(el.src), Refl(el.tgt))


def extract_base_conservativity_cert(sig3: Double3Sig, cert: Eq3Cert) -> EqCertResult:
    """For an ``Eq3Cert`` between ``Id3(P)`` and ``Id3(Q)``, extract base ``EqCert P Q`` (T9)."""
    res = check_eq3_cert(sig3, cert)
    if not isinstance(res.lhs, Id3) or not isinstance(res.rhs, Id3):
        raise KernelError("T9 base conservativity applies to Eq3Cert between Id3(P) and Id3(Q)")
    return verify_eq_cert(sig3.base, res.src_eq_cert, res.lhs.sq, res.rhs.sq)


@dataclass(frozen=True)
class IrreversibilityWitness:
    """Monotone 2-cell tally witness proving no ``Cell3Term`` exists from ``src`` to ``tgt``."""

    weights: dict[str, int]
    src_weight: int
    tgt_weight: int


def check_3d_irreversibility(
    sig3: Double3Sig, src: SqTerm, tgt: SqTerm, weights: Mapping[str, int]
) -> IrreversibilityWitness | None:
    """Certify irreversibility ``not exists Gamma : src ==> tgt`` via monotone generator tally."""
    infer_frame(sig3.base, src)
    infer_frame(sig3.base, tgt)
    for name, spec in sig3.cell3_gens.items():
        if term_weight(spec.src, weights) > term_weight(spec.tgt, weights):
            raise KernelError(
                f"Weights are not monotone on 3-cell generator {name!r}: "
                f"{term_weight(spec.src, weights)} > {term_weight(spec.tgt, weights)}"
            )
    ws = term_weight(src, weights)
    wt = term_weight(tgt, weights)
    if ws <= wt:
        return None
    return IrreversibilityWitness(weights=dict(weights), src_weight=ws, tgt_weight=wt)
