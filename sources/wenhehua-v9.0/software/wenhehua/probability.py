"""Exact rational finite Markov kernels and interface-aware coarse graining.

Finite sets only; no conditioning, Bayesian inference, or causal interventions.
Input/output interfaces have explicit type identities, and no implicit copy.
"""
from __future__ import annotations
from dataclasses import dataclass
from fractions import Fraction
from typing import Hashable, Mapping, Tuple
from .core import GrammarError


def _fraction(p):
    try: return Fraction(p)
    except (ValueError,TypeError,ZeroDivisionError) as ex:
        raise GrammarError('invalid rational probability') from ex


@dataclass(frozen=True)
class Kernel:
    source: Tuple[Hashable, ...]
    target: Tuple[Hashable, ...]
    rows: Mapping[Hashable, Mapping[Hashable, Fraction]]

    def check(self):
        if not self.source or not self.target or len(set(self.source))!=len(self.source) or len(set(self.target))!=len(self.target):
            raise GrammarError('finite state sets must be nonempty and unique')
        if set(self.rows)!=set(self.source):
            raise GrammarError('missing probability rows')
        for s in self.source:
            row=self.rows[s]
            if set(row)-set(self.target):
                raise GrammarError('probability outside target set')
            vals=[_fraction(x) for x in row.values()]
            if any(x<0 for x in vals) or sum(vals,Fraction(0))!=1:
                raise GrammarError('probability row not normalized')

    def then(self, after: 'Kernel') -> 'Kernel':
        self.check(); after.check()
        if self.target != after.source:
            raise GrammarError('kernel interfaces differ; explicit reindexing required')
        rows={}
        for a in self.source:
            rows[a]={c:sum((_fraction(self.rows[a].get(b,0))*_fraction(after.rows[b].get(c,0))
                             for b in self.target),Fraction(0)) for c in after.target}
        out=Kernel(self.source,after.target,rows);out.check();return out

    def tensor(self, other: 'Kernel') -> 'Kernel':
        self.check();other.check()
        source=tuple((a,b) for a in self.source for b in other.source)
        target=tuple((x,y) for x in self.target for y in other.target)
        rows={(a,b):{(x,y):_fraction(self.rows[a].get(x,0))*_fraction(other.rows[b].get(y,0))
                     for x,y in target} for a,b in source}
        out=Kernel(source,target,rows);out.check();return out


def quotient_markov(k:Kernel, alpha:Mapping[Hashable,Hashable],
                    shapes:Mapping[Hashable,Tuple[Tuple[str,...],Tuple[str,...]]]|None=None):
    """Strong lumpability; if provided, interface shapes must be constant on fibers.

    Returns macro kernel.  Raises GrammarError with a *counterexample witness*
    if macro transition probabilities or visible interface schemas disagree.
    """
    k.check()
    if k.source != k.target:
        raise GrammarError('quotient expects a transition kernel on one state space')
    if set(alpha)!=set(k.source):
        raise GrammarError('alpha must be specified for every microstate')
    blocks=list(dict.fromkeys(alpha[x] for x in k.source))
    for i,s in enumerate(k.source):
        for t in k.source[i+1:]:
            if alpha[s]==alpha[t] and shapes is not None:
                if s not in shapes or t not in shapes or shapes[s]!=shapes[t]:
                    raise GrammarError(f'interface abstraction conflict: {s} vs {t}')
    aggregated={}
    for s in k.source:
        coarse=alpha[s]
        row={b:sum((_fraction(k.rows[s].get(n,0)) for n in k.target if alpha[n]==b),Fraction(0))
             for b in blocks}
        if coarse in aggregated and aggregated[coarse]!=row:
            raise GrammarError(f'strong lumpability violated at microstate {s}: {aggregated[coarse]} != {row}')
        aggregated[coarse]=row
    out=Kernel(tuple(blocks),tuple(blocks),aggregated)
    out.check();return out
