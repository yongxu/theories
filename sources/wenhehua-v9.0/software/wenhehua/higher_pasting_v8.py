"""v8: a deliberately small, typed model of higher pasting and its limits.

This is NOT a construction of a free double category/intercategory.
The strict-square part checks syntax and interchange in one concrete model.
The witness part checks a canonical finite 'local then glue' comparison.
The base-change part checks the finite-set Beck--Chevalley fiber criterion.
"""
from dataclasses import dataclass
from typing import Dict, Tuple, List, Hashable


@dataclass(frozen=True)
class Square:
    top: Tuple[str, ...]
    bottom: Tuple[str, ...]
    left: Tuple[str, ...]
    right: Tuple[str, ...]
    tiles: Tuple[Tuple[str, ...], ...]

    @staticmethod
    def atom(label: str, top: str, bottom: str, left: str, right: str) -> 'Square':
        return Square((top,), (bottom,), (left,), (right,), ((label,),))

    def horizontal(self, other: 'Square') -> 'Square':
        if self.right != other.left or len(self.tiles) != len(other.tiles):
            raise ValueError('horizontal pasting: incompatible vertical boundary')
        return Square(self.top + other.top, self.bottom + other.bottom,
                      self.left, other.right,
                      tuple(a + b for a, b in zip(self.tiles, other.tiles)))

    def vertical(self, other: 'Square') -> 'Square':
        if self.bottom != other.top or len(self.tiles[0]) != len(other.tiles[0]):
            raise ValueError('vertical pasting: incompatible horizontal boundary')
        return Square(self.top, other.bottom, self.left + other.left,
                      self.right + other.right, self.tiles + other.tiles)


@dataclass(frozen=True)
class Witness:
    name: str
    side: str  # A or B; seam witness sets empty in this deliberately narrow model
    source: str
    target: str


def compare_local_global(first: Tuple[Witness, ...], second: Tuple[Witness, ...],
                         middle_identifications: Dict[str, str]):
    """Compute L -> G for a disjoint union of two step-witness sets glued in the middle.

    Local histories must stay in one side A or B across both steps.
    Global histories can switch sides at a middle-state point identified by a seam.
    Returned comparison is an inclusion of pairs of witness names, hence injective here.
    More general spans-of-cospans can have non-injective comparisons; not modeled here.
    """
    def glued(s):
        return middle_identifications.get(s, s)

    global_paths = {(x.name, y.name) for x in first for y in second
                    if glued(x.target) == glued(y.source)}
    local_paths = {(x.name, y.name) for x in first for y in second
                   if x.side == y.side and x.target == y.source}
    if not local_paths <= global_paths:
        raise AssertionError('local-to-global comparison is not well defined')
    return {'local': local_paths, 'global': global_paths,
            'missing_global': global_paths - local_paths,
            'injective': True, 'surjective': local_paths == global_paths}


def is_pullback_square(A: Tuple[str, ...], Bp: Tuple[str, ...],
                       Ap: Tuple[str, ...], f: Dict[str, str],
                       g: Dict[str, str], fp: Dict[str, str], gp: Dict[str, str]) -> bool:
    """The square Ap -> A, Ap -> B', A -> B, B' -> B is a finite pullback iff
    a' |-> (gp(a'),fp(a')) bijects onto {(a,b'): f(a)=g(b')}.
    """
    if any(f[gp[z]] != g[fp[z]] for z in Ap):
        return False
    actual = [(gp[z], fp[z]) for z in Ap]
    target = [(a, b) for a in A for b in Bp if f[a] == g[b]]
    return len(actual) == len(set(actual)) and set(actual) == set(target)


def fiber_counts(A: Tuple[str, ...], Bp: Tuple[str, ...], Ap: Tuple[str, ...],
                 f: Dict[str, str], g: Dict[str, str],
                 fp: Dict[str, str], gp: Dict[str, str], P: Dict[str, int]):
    """Cardinalities of g*Sigma_f(P) and Sigma_f' g'*(P), per b' in B'.
    The canonical base-change map is an isomorphism for ALL P if square is pullback.
    """
    if any(f[gp[z]] != g[fp[z]] for z in Ap):
        raise ValueError('square is not commutative')
    left = {b: sum(P[a] for a in A if f[a] == g[b]) for b in Bp}
    right = {b: sum(P[gp[z]] for z in Ap if fp[z] == b) for b in Bp}
    return left, right
