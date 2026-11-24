"""Finite stochastic, mode-dependent interfaces: a guarded interaction tree slice.

Each event emits according to the *current* mode, then selects the next mode.
This is not a full implementation of Spivak's polynomial-tree structures.
"""
from dataclasses import dataclass
from fractions import Fraction
from typing import Mapping,Tuple
from .core import GrammarError

@dataclass(frozen=True)
class Mode:
    input_actions: Tuple[str,...]
    output_types: Tuple[str,...]

@dataclass(frozen=True)
class ModeMachine:
    modes: Mapping[str,Mode]
    transitions: Mapping[Tuple[str,str],Mapping[Tuple[str,Tuple[Tuple[str,str],...]],Fraction]]

    def check(self):
        if not self.modes:
            raise GrammarError('machine requires modes')
        for label,mode in self.modes.items():
            if not mode.input_actions or len(set(mode.input_actions))!=len(mode.input_actions):
                raise GrammarError(f'mode {label} has no unique allowed action names')
            for action in mode.input_actions:
                key=(label,action)
                if key not in self.transitions:
                    raise GrammarError(f'missing mode transition {key}')
                row=self.transitions[key]
                if not row:
                    raise GrammarError('empty outcome distribution')
                total=Fraction(0)
                for (next_mode,emission), p in row.items():
                    if next_mode not in self.modes:
                        raise GrammarError('transition to unknown mode')
                    if (len(emission)!=len(mode.output_types) or
                        any(not isinstance(v,(tuple,list)) or len(v)!=2 or v[0]!=kind
                            for v,kind in zip(emission,mode.output_types))):
                        raise GrammarError('emission does not fit current-mode typed interface')
                    prob=Fraction(p)
                    if prob<0:raise GrammarError('negative probability')
                    total+=prob
                if total!=1:
                    raise GrammarError('mode transition probabilities not normalized')
        if set(self.transitions)!={(s,a) for s,m in self.modes.items() for a in m.input_actions}:
            raise GrammarError('unexpected transition key')

    def step(self,mode:str,action:str):
        self.check()
        if (mode,action) not in self.transitions:
            raise GrammarError('action not available in current interface')
        return self.transitions[mode,action]
