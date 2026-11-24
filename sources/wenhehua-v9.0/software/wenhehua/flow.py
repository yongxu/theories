"""A finite continuous-time material-flow semantics with exact mass balances.

This is an ODE vector-field constructor, not an integration engine or a
categorical equivalence between graph rewriting and differential equations.
"""
from dataclasses import dataclass
from fractions import Fraction
from typing import Callable, Mapping, Tuple
from .core import GrammarError

Rate = Callable[[Mapping[str,Fraction]], Fraction]

@dataclass(frozen=True)
class Arc:
    src: str
    dst: str
    rate: Rate

@dataclass(frozen=True)
class External:
    node: str
    rate: Rate

@dataclass(frozen=True)
class MassFlow:
    nodes: Tuple[str,...]
    arcs: Tuple[Arc,...]
    influx: Tuple[External,...]=()
    outflux: Tuple[External,...]=()

    def check(self):
        if not self.nodes or len(set(self.nodes))!=len(self.nodes):
            raise GrammarError('flow nodes must be distinct and nonempty')
        for arc in self.arcs:
            if arc.src not in self.nodes or arc.dst not in self.nodes:
                raise GrammarError('flow arc endpoint outside system')
        for ext in self.influx+self.outflux:
            if ext.node not in self.nodes:
                raise GrammarError('external flux endpoint outside system')

    def derivative(self, state:Mapping[str,Fraction]):
        self.check()
        if set(state)!=set(self.nodes):
            raise GrammarError('missing or extra state variable')
        dx={n:Fraction(0) for n in self.nodes}
        for arc in self.arcs:
            q=Fraction(arc.rate(state)); dx[arc.src]-=q; dx[arc.dst]+=q
        for ext in self.influx:
            dx[ext.node]+=Fraction(ext.rate(state))
        for ext in self.outflux:
            dx[ext.node]-=Fraction(ext.rate(state))
        return dx

    def boundary_balance(self,state:Mapping[str,Fraction]):
        self.check()
        return (sum((Fraction(e.rate(state)) for e in self.influx),Fraction(0)) -
                sum((Fraction(e.rate(state)) for e in self.outflux),Fraction(0)))

    def verify_balance(self,state:Mapping[str,Fraction])->bool:
        return sum(self.derivative(state).values(),Fraction(0))==self.boundary_balance(state)
