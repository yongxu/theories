#!/usr/bin/env python3
"""GS6 after its review: board rule 9 applied to the rest of GrammarCases and GrammarScope. Each direct induction that
re-proves a general law of the core is replaced by the law, statements unchanged: TwoLines.line_in_family by «线内同类»;
SharedCondition.fed_outside by «所经不同则不及» under the one with no exit (fed_step and fed_stays go, first_never_left
comes); ThirdThing.family_keeps_third by «续即缘当且仅当含族»; LineOfDescent.Endless.member_line by «线内同类».
Edits the kit tree (tree/Becoming/GrammarCases.lean, tree/Becoming/GrammarScope.lean).
usage (from the checkout root): python3 -B <kit>/lean_edits_gs6.py"""
from pathlib import Path

HERE = Path(__file__).resolve().parent
CASES, SCOPE = HERE / 'tree/Becoming/GrammarCases.lean', HERE / 'tree/Becoming/GrammarScope.lean'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


edit(CASES, """/-- A line stays within its family. -/
theorem line_in_family {E : «际» Occ} {x y : Occ} (line : «相续» step E x y) : y.1 = x.1 := by
  induction line with
  | one c => exact c.1.1
  | more c _ ih => exact ih.trans c.1.1
""", """/-- A line stays within its family: every step keeps the family, so a line under any relation is a
line under the family line's class, whose ends are alike (`«线内同类»`). -/
theorem line_in_family {E : «际» Occ} {x y : Occ} (line : «相续» step E x y) : y.1 = x.1 :=
  («线内同类» family_class («及之单调» (fun _ _ c => ⟨c.1, c.1.1.symm⟩) _ _ line)).symm
""")
edit(CASES, """/-- A step along `fed`, from a member of the first family, stays in it. -/
theorem fed_step {E : «际» Occ} {m : Nat} {y : Occ} (c : «续» fed E (.a m) y) : ∃ k, y = .a k :=
  match y, c with
  | .a k, _ => ⟨k, rfl⟩
  | .b _, c => False.elim c.1
  | .r _, c => False.elim c.1

/-- A line along `fed`, under any relation, from a member of the first family, stays in the first
family. -/
theorem fed_stays {E : «际» Occ} {x y : Occ} (line : «相续» fed E x y) :
    ∀ m, x = .a m → ∃ k, y = .a k := by
  induction line with
  | one c =>
    intro m e
    subst e
    exact fed_step c
  | more c _ ih =>
    intro m e
    subst e
    match fed_step c with
    | ⟨k, e'⟩ => exact ih k e'

/-- **Where the members only feed from a condition they do not affect, no relation reaches the other
line**: under every relation, the line from the first family's first member reaches no member of the
second. -/
theorem fed_outside (E : «际» Occ) (n : Nat) : ¬ «所及» fed E (.a 0) (.b n) := fun reached =>
  match reached with
  | .inl e => Occ.noConfusion e
  | .inr line => match fed_stays line 0 rfl with
    | ⟨_, e⟩ => Occ.noConfusion e
""", """/-- Along `fed`, the first family is never left. -/
theorem first_never_left (u v : Occ) (inside : firstFamily u = true) (s : fed u v)
    (outside : firstFamily v = false) : False :=
  match u, v, inside, s, outside with
  | .a _, .a _, _, _, e => Bool.noConfusion e
  | .a _, .b _, _, s, _ => s
  | .a _, .r _, _, s, _ => s
  | .b _, _, e, _, _ => Bool.noConfusion e
  | .r _, _, e, _, _ => Bool.noConfusion e

/-- **Where the members only feed from a condition they do not affect, no relation reaches the other
line**: under every relation, the line from the first family's first member reaches no member of the
second. A line under any relation is a line under the one, and along `fed` the first family is never
left, so the one has nothing outside it to pass (`«所经不同则不及»` with no exit). -/
theorem fed_outside (E : «际» Occ) (n : Nat) : ¬ «所及» fed E (.a 0) (.b n) := fun reached =>
  «所经不同则不及» (P := firstFamily) (C := fun _ => False) «一为类»
    (fun u v inside s outside => first_never_left u v inside s.1 outside) rfl rfl
    (fun _ none _ => none)
    (match reached with
     | .inl e => .inl e
     | .inr line => .inr («及之单调» (fun _ _ c => ⟨c.1, trivial⟩) _ _ line))
""")
edit(CASES, """/-- The class of being joined keeps every stage of the third thing apart from the rest. -/
theorem family_keeps_third {x y : Occ} (fam : «同族» step «一» x y) : third x = third y := by
  induction fam with
  | refl _ => rfl
  | step c => exact step_keeps_third c.1
  | symm _ ih => exact ih.symm
  | trans _ _ ih₁ ih₂ => exact ih₁.trans ih₂
""", """/-- The class of being joined keeps every stage of the third thing apart from the rest: no condition
joins the third thing to the rest, so "the third thing or not" has 缘 as its continuation and contains
the class of being joined (`«续即缘当且仅当含族»`). -/
theorem family_keeps_third {x y : Occ} (fam : «同族» step «一» x y) : third x = third y :=
  («续即缘当且仅当含族» step (sameValue_class third)).mp
    (fun _ _ => ⟨fun h => h.1, fun h => ⟨h, step_keeps_third h⟩⟩) _ _ fam
""")
edit(SCOPE, """/-- A line under the member's class stays with one member. -/
theorem member_line {x y : Occ} (line : «相续» step member x y) : y.1 = x.1 := by
  induction line with
  | one c => exact c.2.symm
  | more c _ ih => exact ih.trans c.2.symm
""", """/-- A line under the member's class stays with one member (`«线内同类»`). -/
theorem member_line {x y : Occ} (line : «相续» step member x y) : y.1 = x.1 :=
  («线内同类» member_class line).symm
""")
print('lean edits: line_in_family, fed_outside (first_never_left), family_keeps_third, member_line')
