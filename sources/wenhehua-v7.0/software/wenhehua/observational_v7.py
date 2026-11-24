"""v7: query-indexed, finite exact/approximate semantic preservation.

Scope: finite typed-set comparison chi: U -> V, rational probability measures,
finite deterministic observations on V, and finite Markov kernels.  These are
mathematical diagnostics; an arbitrary witness weight is NOT automatically a
physical probability or a causal effect.

No external Python dependencies. This module does NOT prove general
intercategory coherence, causal equivalence, or empirical validity.
"""
from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
from itertools import combinations
from typing import Hashable, Mapping, Sequence

from .lineage import TMap
from .probability import Kernel


class ObservationError(ValueError):
    """Ill-typed, non-normalized or outside the declared finite scope."""


def f(x) -> Fraction:
    try:
        return Fraction(x)
    except (ValueError, TypeError, ZeroDivisionError) as exc:
        raise ObservationError(f"not an exact rational: {x!r}") from exc


def probability(on: Sequence[Hashable], weights: Mapping[Hashable, Fraction]) -> dict[Hashable, Fraction]:
    if not on or len(set(on)) != len(on):
        raise ObservationError("probability space must be nonempty with unique keys")
    if set(weights) != set(on):
        raise ObservationError("probability must include every declared outcome, and no others")
    d = {x: f(weights[x]) for x in on}
    if any(x < 0 for x in d.values()) or sum(d.values(), Fraction(0)) != 1:
        raise ObservationError("finite probability not nonnegative and normalized")
    return d


def pushforward(distribution: Mapping[Hashable, Fraction], mapping: Mapping[Hashable, Hashable]):
    if set(distribution) != set(mapping):
        raise ObservationError("pushforward needs a total map on distribution support set")
    result: dict[Hashable, Fraction] = {}
    for source, weight in distribution.items():
        dest = mapping[source]
        result[dest] = result.get(dest, Fraction(0)) + f(weight)
    return result


def tv(d1: Mapping[Hashable, Fraction], d2: Mapping[Hashable, Fraction]) -> Fraction:
    """Total variation of finite probability distributions: half the L1 distance."""
    if (sum((f(x) for x in d1.values()), Fraction(0)) != 1
            or sum((f(x) for x in d2.values()), Fraction(0)) != 1
            or any(f(x) < 0 for x in list(d1.values())+list(d2.values()))):
        raise ObservationError("TV requires two probability distributions")
    return sum((abs(f(d1.get(x, 0))-f(d2.get(x, 0)))
                for x in set(d1) | set(d2)), Fraction(0)) / 2


def _validate_observation(chi: TMap, mu: Mapping[str, Fraction], observation: Mapping[str, Hashable]):
    chi_src = tuple(chi.domain.keys())
    chi_dst = tuple(chi.codomain.keys())
    if not chi_src:
        raise ObservationError("empty source has no normalized probability lift")
    p = probability(chi_dst, mu)
    if set(observation) != set(chi_dst):
        raise ObservationError("observation must be total on the global witness set")
    try:
        for o in observation.values(): hash(o)
    except TypeError as exc:
        raise ObservationError("observation labels must be hashable") from exc
    return p


@dataclass(frozen=True)
class ImageLiftReport:
    """Best achievable query-level lift (not a natural canonical probabilistic inverse)."""
    exact: bool
    tv_floor: Fraction
    excluded_labels: tuple[Hashable, ...]
    covered_labels: tuple[Hashable, ...]
    lift: Mapping[str, Fraction]
    observed_global: Mapping[Hashable, Fraction]
    observed_lift: Mapping[Hashable, Fraction]


def optimal_observed_lift(chi: TMap, mu: Mapping[str, Fraction],
                          observation: Mapping[str, Hashable]) -> ImageLiftReport:
    """Theorem: inf_{nu in Delta(U)} TV(q_*mu, (q chi)_*nu)
    equals mu(q^{-1}(O\\im(q chi))). Return one attaining nu.
    """
    p = _validate_observation(chi, mu, observation)
    source = chi.domain.keys()
    obs_of_source = {u: observation[chi(u)] for u in source}
    representatives: dict[Hashable, str] = {}
    for u in source: representatives.setdefault(obs_of_source[u], u)
    reachable = set(representatives)
    target = pushforward(p, observation)
    excluded = tuple(sorted((lab for lab in target if lab not in reachable), key=str))
    floor = sum((target[x] for x in excluded), Fraction(0))
    nu = {u: Fraction(0) for u in source}
    kept = Fraction(1) - floor
    if kept:
        for label, mass in target.items():
            if label in reachable: nu[representatives[label]] += mass / kept
    else:
        nu[source[0]] = Fraction(1)
    observed = pushforward(nu, obs_of_source)
    observed = {key: observed.get(key, Fraction(0)) for key in target}
    actual = tv(target, observed)
    if actual != floor:
        raise AssertionError(f"theoretical lift certificate failed: {actual} != {floor}")
    return ImageLiftReport(floor == 0, floor, excluded,
                           tuple(sorted(reachable, key=str)), nu, target, observed)


def joint_observation(observations: Sequence[Mapping[str, Hashable]]) -> dict[str, tuple]:
    if not observations:
        raise ObservationError("supply at least one observation")
    keys = set(observations[0])
    if any(set(q) != keys for q in observations):
        raise ObservationError("all observations must have same global witness domain")
    return {v: tuple(q[v] for q in observations) for v in observations[0]}


def _solve_nonnegative(A: list[list[Fraction]], b: list[Fraction]) -> list[Fraction] | None:
    """Gaussian elimination with free variables = 0; used on enumerated supports."""
    if not A: return None
    m, n = len(A), len(A[0])
    tab = [[f(x) for x in A[r]] + [f(b[r])] for r in range(m)]
    pivots = []
    current = 0
    for col in range(n):
        pos = next((r for r in range(current, m) if tab[r][col]), None)
        if pos is None: continue
        tab[current], tab[pos] = tab[pos], tab[current]
        scale = tab[current][col]
        tab[current] = [x/scale for x in tab[current]]
        for r in range(m):
            if r == current: continue
            factor = tab[r][col]
            if factor:
                tab[r] = [a-factor*c for a,c in zip(tab[r],tab[current])]
        pivots.append((current,col)); current += 1
        if current == m: break
    if any(not any(row[:-1]) and row[-1] for row in tab): return None
    sol = [Fraction(0)]*n
    for row,col in pivots: sol[col] = tab[row][-1]
    if any(x < 0 for x in sol): return None
    if any(sum((a*s for a,s in zip(row,sol)),Fraction(0)) != y
           for row,y in zip(A,b)):
        return None
    return sol


@dataclass(frozen=True)
class JointLiftReport:
    feasible: bool
    lift: Mapping[str, Fraction] | None
    checked_support_subsets: int
    outcomes_count: int


def common_lift(chi: TMap, mu: Mapping[str, Fraction],
                observations: Sequence[Mapping[str, Hashable]],
                max_source: int = 12) -> JointLiftReport:
    """Exact rational simultaneous marginal-query lift on small finite supports.

    Each query is compared as a marginal, using ONE shared source distribution.
    This is weaker than preserving the combined joint tuple query.
    Testing all small source-support subsets is exponential, by design.
    """
    if not observations:
        raise ObservationError("at least one query required")
    p = _validate_observation(chi, mu, observations[0])
    for obs in observations[1:]: _validate_observation(chi, mu, obs)
    source = chi.domain.keys()
    if len(source) > max_source:
        raise ObservationError("exact support enumeration limited: use an LP backend for larger problems")
    target = chi.codomain.keys()
    # One normalization equation plus one equation per query-outcome.
    row_specs = [(j,lab) for j,q in enumerate(observations)
                 for lab in dict.fromkeys(q.values())]
    A = [[Fraction(1) for _ in source]]
    b = [Fraction(1)]
    for j,lab in row_specs:
        q = observations[j]
        A.append([Fraction(int(q[chi(u)] == lab)) for u in source])
        b.append(sum((p[v] for v in target if q[v] == lab), Fraction(0)))
    examined = 0
    for n in range(1,min(len(source),len(A))+1):
        for cols in combinations(range(len(source)), n):
            examined += 1
            projected = [[row[i] for i in cols] for row in A]
            x = _solve_nonnegative(projected, b)
            if x is None: continue
            witness = {u: Fraction(0) for u in source}
            for i,val in zip(cols,x): witness[source[i]] = val
            # Defensive verification of each marginal in original coordinates.
            if all(tv(pushforward(p,q),
                      pushforward(witness,{u:q[chi(u)] for u in source})) == 0
                   for q in observations):
                return JointLiftReport(True,witness,examined,len(row_specs))
    return JointLiftReport(False,None,examined,len(row_specs))


def kernel_sup_tv(k: Kernel, other: Kernel) -> Fraction:
    k.check();other.check()
    if k.source != other.source or k.target != other.target:
        raise ObservationError("kernel TV requires identical typed state listings")
    return max(tv({y:f(k.rows[x].get(y,0)) for y in k.target},
                  {y:f(other.rows[x].get(y,0)) for y in k.target})
               for x in k.source)


@dataclass(frozen=True)
class ErrorCertificate:
    per_stage: tuple[Fraction, ...]
    certified_bound: Fraction
    actual_error: Fraction
    kind: str


def composition_error(pairs: Sequence[tuple[Kernel,Kernel]]) -> ErrorCertificate:
    """Bound sup-TV of composed kernels by min(1, sum stage sup-TV)."""
    if not pairs:
        raise ObservationError("at least one kernel pair required")
    diffs = tuple(kernel_sup_tv(a,b) for a,b in pairs)
    exact = pairs[0][0]; approx = pairs[0][1]
    for a,b in pairs[1:]: exact=exact.then(a); approx=approx.then(b)
    real = kernel_sup_tv(exact,approx)
    bound=min(Fraction(1),sum(diffs,Fraction(0)))
    if real>bound: raise AssertionError("kernel composition bound violated")
    return ErrorCertificate(diffs,bound,real,"sequential")


def parallel_error(pairs: Sequence[tuple[Kernel,Kernel]]) -> ErrorCertificate:
    """Independent tensors only. NOT a bound for arbitrarily correlated coupling."""
    if not pairs: raise ObservationError("at least one kernel pair required")
    diffs=tuple(kernel_sup_tv(a,b) for a,b in pairs)
    exact=pairs[0][0];approx=pairs[0][1]
    for a,b in pairs[1:]: exact=exact.tensor(a);approx=approx.tensor(b)
    actual=kernel_sup_tv(exact,approx)
    bound=min(Fraction(1),sum(diffs,Fraction(0)))
    if actual>bound: raise AssertionError("kernel tensor bound violated")
    return ErrorCertificate(diffs,bound,actual,"independent-tensor")


def observe_kernel(kernel: Kernel, outcome_label: Mapping[Hashable,Hashable]) -> Kernel:
    kernel.check()
    if set(outcome_label)!=set(kernel.target):
        raise ObservationError("kernel observation not total on output interface")
    names=tuple(dict.fromkeys(outcome_label.values()))
    rows={x:{o:sum((f(kernel.rows[x].get(y,0)) for y in kernel.target
                     if outcome_label[y]==o),Fraction(0)) for o in names}
          for x in kernel.source}
    result=Kernel(kernel.source,names,rows); result.check();return result


def stochastic_data_processing(distribution_a, distribution_b, kernel:Kernel) -> tuple[Fraction,Fraction]:
    kernel.check()
    pa=probability(kernel.source,distribution_a)
    pb=probability(kernel.source,distribution_b)
    def evolve(p):
        return {y:sum((p[x]*f(kernel.rows[x].get(y,0))
                      for x in kernel.source),Fraction(0)) for y in kernel.target}
    before=tv(pa,pb)
    after=tv(evolve(pa),evolve(pb))
    if after>before: raise AssertionError("data processing violated")
    return before,after


def coarsen_observation(observation: Mapping[str, Hashable],
                        lump: Mapping[Hashable, Hashable]) -> dict[str, Hashable]:
    """Coarsening q_fine to q_coarse = h o q_fine; no hidden identity claims."""
    if set(lump) != set(observation.values()):
        raise ObservationError("coarsening must be total on fine observable labels")
    return {v:lump[label] for v,label in observation.items()}


@dataclass(frozen=True)
class RefinementCertificate:
    fine_defect: Fraction
    coarse_defect: Fraction
    monotone: bool


def refinement_certificate(chi:TMap, mu:Mapping[str,Fraction],
                           fine:Mapping[str,Hashable],
                           lump:Mapping[Hashable,Hashable]) -> RefinementCertificate:
    """Theorem: missing-image probability cannot increase upon coarsening."""
    coarse=coarsen_observation(fine,lump)
    fine_loss=optimal_observed_lift(chi,mu,fine).tv_floor
    coarse_loss=optimal_observed_lift(chi,mu,coarse).tv_floor
    if coarse_loss>fine_loss: raise AssertionError("coarsening monotonicity failed")
    return RefinementCertificate(fine_loss,coarse_loss,True)
