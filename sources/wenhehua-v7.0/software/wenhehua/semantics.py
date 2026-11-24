"""Optional domain semantics (not consequences of the bare graph syntax).

Petri nets show how a concrete resource semantics requires additional data.
Finite deterministic abstractions check a particular semantics-preservation law.
"""
from dataclasses import dataclass
from typing import Dict, Mapping, Optional
from .core import GrammarError

@dataclass(frozen=True)
class Reaction:
    consume: Mapping[str, int]
    produce: Mapping[str, int]

@dataclass
class PetriModel:
    """Finite discrete Petri-style token semantics with place type annotations."""
    places: Dict[str,str]
    reactions: Dict[str,Reaction]
    marking: Dict[str,int]

    def check(self):
        if set(self.marking) != set(self.places):
            raise GrammarError('marking must specify each place')
        if any(type(n) is not int or n<0 for n in self.marking.values()):
            raise GrammarError('markings must be nonnegative integers')
        for name,r in self.reactions.items():
            for d in (r.consume,r.produce):
                for place,amount in d.items():
                    if place not in self.places or type(amount) is not int or amount<0:
                        raise GrammarError('invalid reaction stoichiometry '+name)

    def can_fire(self, name):
        self.check()
        if name not in self.reactions: raise GrammarError('unknown reaction')
        return all(self.marking[p]>=n for p,n in self.reactions[name].consume.items())

    def fire(self, name):
        if not self.can_fire(name): raise GrammarError('reaction disabled by resource shortage')
        r=self.reactions[name]
        result=dict(self.marking)
        for p,n in r.consume.items(): result[p]-=n
        for p,n in r.produce.items(): result[p]+=n
        self.marking=result
        return dict(result)

    def reaction_preserves(self, weights: Mapping[str,int]) -> Dict[str,bool]:
        self.check()
        if set(weights)!=set(self.places): raise GrammarError('weights require all places')
        return {name:sum(weights[p]*n for p,n in r.consume.items()) ==
                     sum(weights[p]*n for p,n in r.produce.items())
                for name,r in self.reactions.items()}

    def total(self, weights):
        return sum(weights[p]*n for p,n in self.marking.items())


def strong_lumpability(states, transition, alpha):
    """Exact finite Markov-chain aggregation (strong lumpability).

    transition: state -> mapping(next_state -> rational probability).
    alpha: state -> macro label.

    All declared rows must sum exactly to 1; use fractions.Fraction for
    rational probabilities. This checks each microstate in each block, not
    merely one selected initial distribution. Returns a conflict witness.
    """
    from fractions import Fraction
    states = tuple(states)
    if not states or len(set(states)) != len(states):
        raise GrammarError('states must be nonempty and distinct')
    known = set(states)
    macro = {}
    for s in states:
        if s not in transition:
            raise GrammarError('missing transition row')
        row = transition[s]
        if set(row) - known:
            raise GrammarError('transition points outside declared states')
        try:
            probs = {n: Fraction(p) for n, p in row.items()}
        except (ValueError, TypeError, ZeroDivisionError) as ex:
            raise GrammarError('invalid probability') from ex
        if any(p < 0 for p in probs.values()) or sum(probs.values(), Fraction(0)) != 1:
            raise GrammarError('transition probabilities must be nonnegative and sum to 1')
        coarse_s = alpha(s)
        aggregated = {}
        for n, prob in probs.items():
            coarse_n = alpha(n)
            aggregated[coarse_n] = aggregated.get(coarse_n, Fraction(0)) + prob
        # Include zero-probability coarse outcomes in all blocks.
        all_blocks = {alpha(x) for x in states}
        aggregated = {block: aggregated.get(block, Fraction(0)) for block in all_blocks}
        if coarse_s in macro and macro[coarse_s] != aggregated:
            return False, macro, (s, coarse_s, macro[coarse_s], aggregated)
        macro[coarse_s] = aggregated
    return True, macro, None
