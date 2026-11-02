#!/usr/bin/env python3
"""U4e: RootForms.some_depends states its witness, not only that it is not refuted (the Lean review's finding at
RootForms :119); its six uses apply the negations to it. Applied in the tree given as argv[1]."""
import sys
from pathlib import Path

p = Path(sys.argv[1]) / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/RootForms.lean'
t = p.read_text(encoding='utf-8')
pairs = [
    ("""theorem some_depends : ¬ ¬ ∃ x, everywhere x ∧ everywhere x :=
  fun none => none ⟨(), trivial, trivial⟩""",
     """theorem some_depends : ∃ x, everywhere x ∧ everywhere x :=
  ⟨(), trivial, trivial⟩"""),
    ("""  fun h => some_depends (@h Unit everywhere nowhere everywhere noneRelated inherits_vacuous
    undepended_vacuous)""",
     """  fun h => @h Unit everywhere nowhere everywhere noneRelated inherits_vacuous undepended_vacuous
    some_depends"""),
    ("""  fun given => some_depends (descent_forms_no_dependence given inherits_vacuous undepended_vacuous)""",
     """  fun given => descent_forms_no_dependence given inherits_vacuous undepended_vacuous some_depends"""),
    ("""  fun h => some_depends (@h Unit everywhere nowhere everywhere allRelated given_everywhere
    undepended_nowhere)""",
     """  fun h => @h Unit everywhere nowhere everywhere allRelated given_everywhere undepended_nowhere
    some_depends"""),
    ("""  fun inherits => some_depends (descent_forms_no_dependence given_everywhere inherits
    undepended_nowhere)""",
     """  fun inherits => descent_forms_no_dependence given_everywhere inherits undepended_nowhere
    some_depends"""),
    ("""  fun h => some_depends (@h Unit everywhere everywhere everywhere allRelated given_everywhere
    inherits_everywhere)""",
     """  fun h => @h Unit everywhere everywhere everywhere allRelated given_everywhere inherits_everywhere
    some_depends"""),
    ("""  fun undepended => some_depends (descent_forms_no_dependence given_everywhere inherits_everywhere
    undepended)""",
     """  fun undepended => descent_forms_no_dependence given_everywhere inherits_everywhere undepended
    some_depends"""),
]
for old, new in pairs:
    assert t.count(old) == 1, old[:70]
    t = t.replace(old, new)
assert 'some_depends (' not in t
p.write_text(t, encoding='utf-8')
print('RootForms: some_depends strengthened, six uses applied')
