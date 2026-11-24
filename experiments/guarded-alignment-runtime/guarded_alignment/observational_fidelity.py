"""Exact rational observational fidelity, multi-query feasibility, and fiber-split warnings.

AI-written (Wave U6 runtime, 24 November 2026). Pure Python 3 standard library using
``fractions.Fraction`` for exact arithmetic without floating-point rounding drift.
Mirrors ``ObservationalFidelity``:
- Finite probability distributions (``FinDist``), pushforward, data-processing TV distance.
- Exact ``mass_outside`` query TV blindness floor (O1 / G.1) with constructive attaining
  witness on nonempty carriers and explicit infeasibility on empty carriers.
- Coarsening (G.2) and macro-refinement monotonicity checks (v9 formal/61 §4, §8).
- Exact rational Simplex multi-query convex feasibility separation (G.3a / G.3b):
  separating per-query realizability, simultaneous marginal realizability, and joint fidelity.
- ``Zero-TV`` vs. ``FiberViabilitySplit`` warnings and three-regime error bounds
  (open-loop linear kernel TV vs. contractive closed-loop feedback tube).

Rule 2 note: Computes exact bounds on supplied finite models; does not assert finite-sample
convergence or that real systems match the supplied transition laws.
"""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
from typing import Any, Callable, Iterable, Mapping, Sequence


class FidelityError(ValueError):
    """Raised on invalid probability laws, kernels, or infeasible query specifications."""


def to_fraction(val: Fraction | int | str) -> Fraction:
    """Parse an exact rational value (rejecting floats to prevent rounding drift)."""
    if isinstance(val, Fraction):
        return val
    if isinstance(val, bool):
        raise FidelityError(f"Expected exact rational, got bool {val!r}")
    if isinstance(val, int):
        return Fraction(val, 1)
    if isinstance(val, str):
        return Fraction(val.strip())
    raise FidelityError(f"Exact rational required (Fraction, int, or str), got {type(val).__name__}")


def _dedup_tuple(items: Iterable[Any]) -> tuple[Any, ...]:
    out: list[Any] = []
    seen: set[Any] = set()
    for x in items:
        if x not in seen:
            seen.add(x)
            out.append(x)
    return tuple(out)


def _eval_map(fn_or_map: Mapping[Any, Any] | Callable[[Any], Any], x: Any) -> Any:
    if isinstance(fn_or_map, Mapping):
        if x not in fn_or_map:
            raise FidelityError(f"Map missing key {x!r}")
        return fn_or_map[x]
    return fn_or_map(x)


@dataclass(frozen=True)
class FinDist:
    """Exact rational probability law over a finite carrier."""

    carrier: tuple[Any, ...]
    weights: Mapping[Any, Fraction]

    def __post_init__(self) -> None:
        if len(self.carrier) == 0:
            raise FidelityError("FinDist cannot be constructed on an empty carrier")
        total = Fraction(0)
        for x in self.carrier:
            if x not in self.weights:
                raise FidelityError(f"FinDist missing weight for {x!r}")
            w = self.weights[x]
            if not isinstance(w, Fraction):
                raise FidelityError(f"FinDist weight for {x!r} must be Fraction")
            if w < 0:
                raise FidelityError(f"FinDist weight for {x!r} must be >= 0, got {w}")
            total += w
        if total != Fraction(1):
            raise FidelityError(f"FinDist weights must sum to 1, got {total}")

    def prob(self, x: Any) -> Fraction:
        return self.weights.get(x, Fraction(0))

    @classmethod
    def from_mapping(
        cls, weights: Mapping[Any, Fraction | int | str], carrier: Iterable[Any] | None = None
    ) -> "FinDist":
        car = _dedup_tuple(carrier if carrier is not None else weights.keys())
        exact = {x: to_fraction(weights.get(x, 0)) for x in car}
        return cls(carrier=car, weights=exact)

    @classmethod
    def dirac(cls, carrier: Iterable[Any], point: Any) -> "FinDist":
        car = _dedup_tuple(carrier)
        if point not in car:
            raise FidelityError(f"Dirac point {point!r} not in carrier")
        return cls(
            carrier=car,
            weights={x: (Fraction(1) if x == point else Fraction(0)) for x in car},
        )

    @classmethod
    def uniform(cls, carrier: Iterable[Any]) -> "FinDist":
        car = _dedup_tuple(carrier)
        if len(car) == 0:
            raise FidelityError("Cannot construct uniform FinDist on empty carrier")
        w = Fraction(1, len(car))
        return cls(carrier=car, weights={x: w for x in car})


def pushforward(
    fn_or_map: Mapping[Any, Any] | Callable[[Any], Any],
    dist: FinDist,
    target_carrier: Iterable[Any] | None = None,
) -> FinDist:
    """Exact pushforward distribution ``f_* dist``."""
    images = {u: _eval_map(fn_or_map, u) for u in dist.carrier}
    car = _dedup_tuple(target_carrier if target_carrier is not None else images.values())
    car_set = set(car)
    acc = {y: Fraction(0) for y in car}
    for u in dist.carrier:
        y = images[u]
        if y not in car_set:
            raise FidelityError(f"Pushforward image {y!r} not in target_carrier")
        acc[y] += dist.prob(u)
    return FinDist(carrier=car, weights=acc)


def tv_dist(mu: FinDist, nu: FinDist) -> Fraction:
    """Exact normalized total variation distance ``(1/2) * sum |mu(y) - nu(y)|``."""
    support = _dedup_tuple(list(mu.carrier) + list(nu.carrier))
    l1 = sum((abs(mu.prob(y) - nu.prob(y)) for y in support), Fraction(0))
    return l1 * Fraction(1, 2)


def prod_dist(mu1: FinDist, mu2: FinDist) -> FinDist:
    """Exact independent product law ``mu1 x mu2``."""
    car = tuple((x, y) for x in mu1.carrier for y in mu2.carrier)
    weights = {(x, y): mu1.prob(x) * mu2.prob(y) for x in mu1.carrier for y in mu2.carrier}
    return FinDist(carrier=car, weights=weights)


# --- Exact Query TV Blindness Floor (O1 / G.1) ---


def mass_outside(
    fn_or_map: Mapping[Any, Any] | Callable[[Any], Any],
    lam0: FinDist,
    src_carrier: Iterable[Any],
) -> Fraction:
    """Exact probability mass of ``lam0`` lying outside ``im(f)``."""
    image = {_eval_map(fn_or_map, u) for u in src_carrier}
    return sum((lam0.prob(o) for o in lam0.carrier if o not in image), Fraction(0))


@dataclass(frozen=True)
class QueryFloorReport:
    """Exact ``O1`` / ``G.1`` query blindness floor and attaining local witness."""

    feasible: bool
    floor: Fraction
    outside_observations: tuple[Any, ...]
    attaining_nu: FinDist | None
    attained_tv: Fraction | None
    reason: str


def query_tv_floor(
    chi: Mapping[Any, Any] | Callable[[Any], Any],
    q: Mapping[Any, Any] | Callable[[Any], Any],
    mu: FinDist,
    src_carrier: Iterable[Any],
    obs_carrier: Iterable[Any] | None = None,
) -> QueryFloorReport:
    """Compute exact ``massOutside (q o chi) (q_* mu)`` and attaining ``nu in FinDist(U)``."""
    u_car = _dedup_tuple(src_carrier)
    lam0 = pushforward(q, mu, target_carrier=obs_carrier)
    if len(u_car) == 0:
        return QueryFloorReport(
            feasible=False,
            floor=Fraction(1),
            outside_observations=lam0.carrier,
            attaining_nu=None,
            attained_tv=None,
            reason="Empty local carrier U admits no FinDist U (empty_source_infeasible)",
        )

    f_map = {u: _eval_map(q, _eval_map(chi, u)) for u in u_car}
    preimage_rep: dict[Any, Any] = {}
    for u in u_car:
        o = f_map[u]
        if o not in preimage_rep:
            preimage_rep[o] = u

    outside = tuple(o for o in lam0.carrier if o not in preimage_rep)
    floor = sum((lam0.prob(o) for o in outside), Fraction(0))

    # Construct attaining nu_star achieving tv_dist == floor exactly.
    nu_w = {u: Fraction(0) for u in u_car}
    for o in lam0.carrier:
        if o in preimage_rep:
            nu_w[preimage_rep[o]] += lam0.prob(o)
    nu_w[u_car[0]] += floor
    nu_star = FinDist(carrier=u_car, weights=nu_w)
    achieved = tv_dist(pushforward(f_map, nu_star, target_carrier=lam0.carrier), lam0)
    return QueryFloorReport(
        feasible=True,
        floor=floor,
        outside_observations=outside,
        attaining_nu=nu_star,
        attained_tv=achieved,
        reason=(
            "Zero query TV floor attained"
            if floor == 0
            else f"Positive query TV blindness floor {floor} outside im(q o chi)"
        ),
    )


# --- Coarsening & Macro-Refinement Monotonicity (G.2, v9 formal/61 §4, §8) ---


@dataclass(frozen=True)
class CoarseningReport:
    """Effect of post-composing a query with a coarsening map ``c : O_fine -> O_coarse``."""

    fine_floor: Fraction
    coarse_floor: Fraction
    concealed_gap: Fraction
    monotone_holds: bool
    conceals_blindness: bool


def check_coarsening(
    chi: Mapping[Any, Any] | Callable[[Any], Any],
    q_fine: Mapping[Any, Any] | Callable[[Any], Any],
    coarsen_map: Mapping[Any, Any] | Callable[[Any], Any],
    mu: FinDist,
    src_carrier: Iterable[Any],
) -> CoarseningReport:
    """Verify post-composition coarsening lowers query TV floor and flag concealed gaps."""
    r_fine = query_tv_floor(chi, q_fine, mu, src_carrier)
    q_coarse = {v: _eval_map(coarsen_map, _eval_map(q_fine, v)) for v in mu.carrier}
    r_coarse = query_tv_floor(chi, q_coarse, mu, src_carrier)
    gap = r_fine.floor - r_coarse.floor
    return CoarseningReport(
        fine_floor=r_fine.floor,
        coarse_floor=r_coarse.floor,
        concealed_gap=gap,
        monotone_holds=(r_coarse.floor <= r_fine.floor),
        conceals_blindness=(gap > 0),
    )


@dataclass(frozen=True)
class MacroRefinementReport:
    """Monotonicity check for macro refinement ``chi_coarse = chi_fine o refine_map``."""

    coarse_floor: Fraction
    fine_floor: Fraction
    improvement: Fraction
    monotone_holds: bool


def check_macro_refinement(
    refine_map: Mapping[Any, Any] | Callable[[Any], Any],
    chi_fine: Mapping[Any, Any] | Callable[[Any], Any],
    q: Mapping[Any, Any] | Callable[[Any], Any],
    mu: FinDist,
    coarse_carrier: Iterable[Any],
    fine_carrier: Iterable[Any],
) -> MacroRefinementReport:
    """Verify finer macro partition weakly lowers the query TV floor."""
    c_car = _dedup_tuple(coarse_carrier)
    f_car = _dedup_tuple(fine_carrier)
    f_set = set(f_car)
    chi_coarse: dict[Any, Any] = {}
    for uc in c_car:
        uf = _eval_map(refine_map, uc)
        if uf not in f_set:
            raise FidelityError(f"refine_map({uc!r})={uf!r} not in fine_carrier")
        chi_coarse[uc] = _eval_map(chi_fine, uf)
    r_coarse = query_tv_floor(chi_coarse, q, mu, c_car)
    r_fine = query_tv_floor(chi_fine, q, mu, f_car)
    return MacroRefinementReport(
        coarse_floor=r_coarse.floor,
        fine_floor=r_fine.floor,
        improvement=r_coarse.floor - r_fine.floor,
        monotone_holds=(r_fine.floor <= r_coarse.floor),
    )


# --- Exact Rational Simplex Solver & Multi-Query Convex Feasibility (G.3a / G.3b) ---


def _solve_l1_simplex_exact(
    n_vars: int,
    query_rows: Sequence[tuple[list[Fraction], Fraction]],
    max_iters: int = 5000,
) -> tuple[Fraction, list[Fraction]]:
    """Minimize ``sum_k |row_k . x - target_k|`` over the probability simplex ``x >= 0, sum x = 1``.

    Uses exact ``Fraction`` tableau Simplex with Bland's anti-cycling rule starting from the
    exact feasible vertex ``x = (1, 0, ..., 0)``.
    """
    if n_vars <= 0:
        raise FidelityError("Simplex requires at least one source variable")
    m_q = len(query_rows)
    # Variables: x_0..x_{n-1}, p_0..p_{m_q-1}, n_0..n_{m_q-1}
    total_vars = n_vars + 2 * m_q
    n_rows = 1 + m_q

    # Build initial tableau [A | b] with row 0: sum(x) = 1, rows 1..m_q: row_k . x - p_k + n_k = t_k
    tab: list[list[Fraction]] = [[Fraction(0)] * (total_vars + 1) for _ in range(n_rows)]
    for j in range(n_vars):
        tab[0][j] = Fraction(1)
    tab[0][-1] = Fraction(1)

    basis: list[int] = [0]  # x_0 is basic in row 0
    obj = [Fraction(0)] * total_vars
    for k, (coeffs, target) in enumerate(query_rows):
        row = tab[1 + k]
        for j in range(n_vars):
            row[j] = coeffs[j]
        p_col = n_vars + 2 * k
        n_col = n_vars + 2 * k + 1
        row[p_col] = Fraction(-1)
        row[n_col] = Fraction(1)
        row[-1] = target
        obj[p_col] = Fraction(1)
        obj[n_col] = Fraction(1)
        # Eliminate x_0 using row 0 so x_0 = 1, x_{j>0} = 0 is basic feasible:
        c0 = row[0]
        if c0 != 0:
            for col in range(total_vars + 1):
                row[col] -= c0 * tab[0][col]
        # Now RHS = target - c0. Make basic slack p_k or n_k have +1 and RHS >= 0.
        if row[-1] >= 0:
            basis.append(n_col)
        else:
            for col in range(total_vars + 1):
                row[col] = -row[col]
            basis.append(p_col)

    def pivot(p_row: int, p_col: int) -> None:
        piv = tab[p_row][p_col]
        for col in range(total_vars + 1):
            tab[p_row][col] /= piv
        for r in range(n_rows):
            if r == p_row:
                continue
            factor = tab[r][p_col]
            if factor != 0:
                for col in range(total_vars + 1):
                    tab[r][col] -= factor * tab[p_row][col]
        basis[p_row] = p_col

    for _ in range(max_iters):
        # Compute reduced weights: c_j - sum_r c_{B[r]} * tab[r][j]
        enter_col = -1
        for col in range(total_vars):
            rc = obj[col] - sum((obj[basis[r]] * tab[r][col] for r in range(n_rows)), Fraction(0))
            if rc < 0:
                enter_col = col  # Bland's rule: smallest index with negative reduced weight
                break
        if enter_col == -1:
            break

        leave_row = -1
        best_ratio: Fraction | None = None
        for r in range(n_rows):
            a_re = tab[r][enter_col]
            if a_re > 0:
                ratio = tab[r][-1] / a_re
                if best_ratio is None or ratio < best_ratio or (
                    ratio == best_ratio and basis[r] < basis[leave_row]
                ):
                    best_ratio = ratio
                    leave_row = r
        if leave_row == -1:
            raise FidelityError("Simplex LP unexpectedly unbounded")
        pivot(leave_row, enter_col)
    else:
        raise FidelityError("Simplex iteration limit exceeded")

    sol = [Fraction(0)] * total_vars
    for r, b_col in enumerate(basis):
        sol[b_col] = tab[r][-1]
    l1_opt = sum((obj[col] * sol[col] for col in range(total_vars)), Fraction(0))
    return l1_opt, sol[:n_vars]


@dataclass(frozen=True)
class QuerySpec:
    """Single finite query ``q : U -> O`` and exact target observation distribution."""

    name: str
    query_map: Mapping[Any, Any]
    target_dist: FinDist


@dataclass(frozen=True)
class MultiQueryReport:
    """Exact 3-way multi-query convex feasibility separation report (G.3a / G.3b)."""

    per_query_floors: dict[str, Fraction]
    per_query_realizable: bool
    simultaneous_min_tv_sum: Fraction
    simultaneous_realizable: bool
    simultaneous_witness: FinDist | None
    joint_min_tv: Fraction | None
    joint_realizable: bool | None
    regime: str


def check_multi_query_feasibility(
    src_carrier: Iterable[Any],
    queries: Sequence[QuerySpec],
    joint_chi: Mapping[Any, Any] | Callable[[Any], Any] | None = None,
    joint_target: FinDist | None = None,
) -> MultiQueryReport:
    """Run exact ``Fraction`` 3-way separation: per-query vs. simultaneous vs. joint."""
    u_car = _dedup_tuple(src_carrier)
    if len(u_car) == 0:
        raise FidelityError("Multi-query feasibility requires nonempty src_carrier")

    per_floors: dict[str, Fraction] = {}
    simplex_rows: list[tuple[list[Fraction], Fraction]] = []
    for qs in queries:
        per_floors[qs.name] = mass_outside(qs.query_map, qs.target_dist, u_car)
        obs_all = _dedup_tuple(list(qs.target_dist.carrier) + [qs.query_map[u] for u in u_car])
        for o in obs_all:
            coeffs = [Fraction(1) if qs.query_map[u] == o else Fraction(0) for u in u_car]
            simplex_rows.append((coeffs, qs.target_dist.prob(o)))

    per_ok = all(f == 0 for f in per_floors.values())
    l1_sum, x_opt = _solve_l1_simplex_exact(len(u_car), simplex_rows)
    sim_tv_sum = l1_sum * Fraction(1, 2)
    sim_ok = sim_tv_sum == Fraction(0)
    sim_witness = FinDist(carrier=u_car, weights={u_car[i]: x_opt[i] for i in range(len(u_car))})

    joint_min_tv: Fraction | None = None
    joint_ok: bool | None = None
    if joint_chi is not None and joint_target is not None:
        j_rep = query_tv_floor(joint_chi, lambda v: v, joint_target, u_car, joint_target.carrier)
        joint_min_tv = j_rep.floor
        joint_ok = joint_min_tv == Fraction(0)

    if not per_ok:
        regime = "PER_QUERY_INFEASIBLE"
    elif not sim_ok:
        regime = "G3A_PER_QUERY_VS_SIMULTANEOUS_SEPARATION"
    elif joint_ok is False:
        regime = "G3B_SIMULTANEOUS_MARGINAL_VS_JOINT_SEPARATION"
    else:
        regime = "JOINTLY_REALIZABLE"

    return MultiQueryReport(
        per_query_floors=per_floors,
        per_query_realizable=per_ok,
        simultaneous_min_tv_sum=sim_tv_sum,
        simultaneous_realizable=sim_ok,
        simultaneous_witness=sim_witness,
        joint_min_tv=joint_min_tv,
        joint_realizable=joint_ok,
        regime=regime,
    )


# --- Zero-TV vs FiberViabilitySplit Warnings ---


@dataclass(frozen=True)
class FiberSplitReport:
    """Detection of ``FiberViabilitySplit`` coexisting with ``Zero-TV`` macro agreement."""

    has_split: bool
    viable_state: Any | None
    collapsing_state: Any | None
    shared_projection: Any | None
    projected_tv: Fraction | None
    warning: str


def check_fiber_viability_split(
    proj_map: Mapping[Any, Any] | Callable[[Any], Any],
    viable_pred: Mapping[Any, bool] | Callable[[Any], bool],
    states: Iterable[Any],
    dist_viable: FinDist | None = None,
    dist_collapsing: FinDist | None = None,
) -> FiberSplitReport:
    """Check for two states sharing a macro projection yet disagreeing on viability."""
    st_list = _dedup_tuple(states)
    by_proj: dict[Any, list[Any]] = {}
    for s in st_list:
        p = _eval_map(proj_map, s)
        by_proj.setdefault(p, []).append(s)

    for proj_val, fiber in by_proj.items():
        viable = [s for s in fiber if bool(_eval_map(viable_pred, s))]
        non_viable = [s for s in fiber if not bool(_eval_map(viable_pred, s))]
        if viable and non_viable:
            u_ok, u_bad = viable[0], non_viable[0]
            p_ok = dist_viable if dist_viable is not None else FinDist.dirac(st_list, u_ok)
            p_bad = dist_collapsing if dist_collapsing is not None else FinDist.dirac(st_list, u_bad)
            tv_proj = tv_dist(pushforward(proj_map, p_ok), pushforward(proj_map, p_bad))
            warn = (
                f"ZERO_TV_FIBER_VIABILITY_SPLIT: states {u_ok!r} (viable) and {u_bad!r} "
                f"(non-viable) share projection {proj_val!r} with projected TV={tv_proj}; "
                f"no macro viability predicate Kq is both sound and complete"
            )
            return FiberSplitReport(
                has_split=True,
                viable_state=u_ok,
                collapsing_state=u_bad,
                shared_projection=proj_val,
                projected_tv=tv_proj,
                warning=warn,
            )

    return FiberSplitReport(
        has_split=False,
        viable_state=None,
        collapsing_state=None,
        shared_projection=None,
        projected_tv=None,
        warning="No fiber viability split detected on inspected finite state set",
    )


# --- Exact Rational Markov Kernels & Contractive Closed-Loop Bounds (G.4a / G.4b) ---


@dataclass(frozen=True)
class FinKernel:
    """Exact rational finite Markov kernel ``X -> FinDist(Y)``."""

    src_carrier: tuple[Any, ...]
    tgt_carrier: tuple[Any, ...]
    rows: Mapping[Any, FinDist]

    def __post_init__(self) -> None:
        for x in self.src_carrier:
            if x not in self.rows:
                raise FidelityError(f"FinKernel missing row for {x!r}")
            if self.rows[x].carrier != self.tgt_carrier:
                raise FidelityError(f"FinKernel row {x!r} carrier mismatch")

    def apply(self, dist: FinDist) -> FinDist:
        acc = {y: Fraction(0) for y in self.tgt_carrier}
        for x in self.src_carrier:
            px = dist.prob(x)
            if px != 0:
                row = self.rows[x]
                for y in self.tgt_carrier:
                    acc[y] += px * row.prob(y)
        return FinDist(carrier=self.tgt_carrier, weights=acc)

    def max_tv_diff(self, other: "FinKernel") -> Fraction:
        if self.src_carrier != other.src_carrier or self.tgt_carrier != other.tgt_carrier:
            raise FidelityError("Kernel comparison requires matching carriers")
        return max((tv_dist(self.rows[x], other.rows[x]) for x in self.src_carrier), default=Fraction(0))


def iter_kernel(kernel: FinKernel, steps: int, init: FinDist) -> FinDist:
    """Iterate an endokernel ``steps`` times from ``init``."""
    if steps < 0:
        raise FidelityError(f"steps must be >= 0, got {steps}")
    cur = init
    for _ in range(steps):
        cur = kernel.apply(cur)
    return cur


def tensor_kernel(k1: FinKernel, k2: FinKernel) -> FinKernel:
    """Independent product kernel ``K1 (x) K2`` (G.4b)."""
    src = tuple((x1, x2) for x1 in k1.src_carrier for x2 in k2.src_carrier)
    tgt = tuple((y1, y2) for y1 in k1.tgt_carrier for y2 in k2.tgt_carrier)
    rows = {
        (x1, x2): prod_dist(k1.rows[x1], k2.rows[x2])
        for x1 in k1.src_carrier
        for x2 in k2.src_carrier
    }
    return FinKernel(src_carrier=src, tgt_carrier=tgt, rows=rows)


def metric_slack(alpha: Fraction, eps: Fraction, steps: int, init_radius: Fraction) -> Fraction:
    """Exact contractive closed-loop recurrence ``r_{k+1} = alpha * r_k + eps``."""
    if not (Fraction(0) <= alpha < Fraction(1)):
        raise FidelityError(f"Contraction rate alpha must lie in [0, 1), got {alpha}")
    if eps < 0 or init_radius < 0 or steps < 0:
        raise FidelityError("eps, init_radius, and steps must be nonnegative")
    cur = init_radius
    for _ in range(steps):
        cur = alpha * cur + eps
    return cur


def contractive_tube_bound(alpha: Fraction, eps: Fraction, init_radius: Fraction) -> Fraction:
    """Uniform all-horizon bound ``max(init_radius, eps / (1 - alpha))``."""
    if not (Fraction(0) <= alpha < Fraction(1)):
        raise FidelityError(f"Contraction rate alpha must lie in [0, 1), got {alpha}")
    if eps < 0 or init_radius < 0:
        raise FidelityError("eps and init_radius must be nonnegative")
    return max(init_radius, eps / (Fraction(1) - alpha))
