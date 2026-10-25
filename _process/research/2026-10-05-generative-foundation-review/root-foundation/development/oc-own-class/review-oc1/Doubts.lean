/-! OC2 scratch checks. Definitions copied verbatim from Becoming/Grammar.lean, GrammarMap.lean and
GrammarPath.lean (commit 47b780e1c); only Init is imported. -/

namespace Scratch

universe u

abbrev «际» (α : Type u) : Type u := α → α → Prop

inductive «及» {α : Type u} (R : «际» α) : «际» α
  | one {x y : α} : R x y → «及» R x y
  | more {x y z : α} : R x y → «及» R y z → «及» R x z

structure «类» {α : Type u} (E : «际» α) : Prop where
  refl : ∀ x, E x x
  symm : ∀ {x y}, E x y → E y x
  trans : ∀ {x y z}, E x y → E y z → E x z

section
variable {α : Type u}

def «合» (R S : «际» α) : «际» α := fun x y => R x y ∧ S x y
def «续» (R E : «际» α) : «际» α := «合» R E
def «相续» (R E : «际» α) : «际» α := «及» («续» R E)
def «有后» (R E : «际» α) (x : α) : Prop := ∃ y, «续» R E x y
def «亡» (R E : «际» α) (x : α) : Prop := ¬ «有后» R E x
def «所及» (R L : «际» α) (x y : α) : Prop := x = y ∨ «相续» R L x y

theorem «线内同类» {R E : «际» α} (hE : «类» E) {x y : α}
    (line : «相续» R E x y) : E x y := by
  induction line with
  | one c => exact c.2
  | more c _ ih => exact hE.trans c.2 ih

def «所缘同于» (R E : «际» α) (m : α) : Prop := ∀ v, R m v → E m v

def «至终有常» (R E : «际» α) : Prop :=
  ∀ u u', E u u' → ∀ v, R u v → (∃ v', R u' v' ∧ E v v') ∨ ∀ w, ¬ R u' w

def «本类至终有常» (R E : «际» α) (m : α) : Prop :=
  ∀ u u', E m u → E m u' → ∀ v, R u v → (∃ v', R u' v' ∧ E v v') ∨ ∀ w, ¬ R u' w

def «二分» (P : α → Bool) : «际» α := fun x y => P x = P y

theorem «二分为类» (P : α → Bool) : «类» («二分» P) := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩

theorem «本类常闭则所缘同类» {R E : «际» α} (hE : «类» E) {m : α} (atClass : «本类至终有常» R E m)
    (goes : ∃ w, R m w) (held : «所缘同于» R E m) {u v : α} (alike : E u m) (step : R u v) : E v m :=
  match atClass u m (hE.symm alike) (hE.refl m) v step with
  | .inl ⟨v', hv', ev⟩ => hE.trans ev (hE.symm (held v' hv'))
  | .inr stops => match goes with
    | ⟨w, hw⟩ => absurd hw (stops w)

theorem «闭则外分无关» {R E F : «际» α} (hE : «类» E) (hF : «类» F) {m : α}
    (same : ∀ x, E m x ↔ F m x) (goes : ∃ w, R m w) (held : «所缘同于» R E m)
    (atClass : «本类至终有常» R E m) : «本类至终有常» R F m ∧ «所缘同于» R F m :=
  ⟨fun u u' mu mu' v step =>
     match atClass u u' ((same u).mpr mu) ((same u').mpr mu') v step with
     | .inl ⟨v', hv', ev⟩ =>
       have mv : E m v :=
         hE.symm («本类常闭则所缘同类» hE atClass goes held (hE.symm ((same u).mpr mu)) step)
       .inl ⟨v', hv', hF.trans (hF.symm ((same v).mp mv)) ((same v').mp (hE.trans mv ev))⟩
     | .inr stops => .inr stops,
   fun v step => (same v).mp (held v step)⟩

theorem firstStep {R E : «际» α} {x z : α} (l : «相续» R E x z) : ∃ y, «续» R E x y := by
  cases l with
  | one c => exact ⟨_, c⟩
  | more c _ => exact ⟨_, c⟩

/-! ### Constructive forms (to check that suggested lemmas can have an empty axiom report). -/
theorem onlyThroughOutsideDec {R E F : «际» α} (hE : «类» E) (hF : «类» F) {m : α} {P : α → Bool}
    (decides : ∀ x, E m x ↔ P x = P m) (same : ∀ x, E m x ↔ F m x)
    (outside : ∀ v v', ¬ P v = P m → (E v v' ↔ F v v')) :
    «本类至终有常» R E m ↔ «本类至终有常» R F m :=
  have key : ∀ v v', (E v v' ↔ F v v') := fun v v' =>
    match decEq (P v) (P m) with
    | isTrue vm =>
      have mv : E m v := (decides v).mpr vm
      ⟨fun ev => hF.trans (hF.symm ((same v).mp mv)) ((same v').mp (hE.trans mv ev)),
       fun fv => hE.trans (hE.symm mv) ((same v').mpr (hF.trans ((same v).mp mv) fv))⟩
    | isFalse nv => outside v v' nv
  ⟨fun a u u' mu mu' v s => match a u u' ((same u).mpr mu) ((same u').mpr mu') v s with
     | .inl ⟨v', h, e⟩ => .inl ⟨v', h, (key v v').mp e⟩
     | .inr st => .inr st,
   fun a u u' mu mu' v s => match a u u' ((same u).mp mu) ((same u').mp mu') v s with
     | .inl ⟨v', h, e⟩ => .inl ⟨v', h, (key v v').mpr e⟩
     | .inr st => .inr st⟩

theorem «异三则同» : ∀ {a b c : Bool}, ¬ a = c → ¬ b = c → b = a
  | true, true, _, _, _ => rfl
  | false, false, _, _, _ => rfl
  | true, false, true, h, _ => absurd rfl h
  | true, false, false, _, h => absurd rfl h
  | false, true, true, _, h => absurd rfl h
  | false, true, false, h, _ => absurd rfl h

/-- The reading's sufficient condition, constructively: every occurrence alike to `m` conditions
something inside and something outside its block, or conditions nothing. -/
theorem splitSufficientDec {R : «际» α} {P : α → Bool} {m : α}
    (both : ∀ u, P m = P u →
      ((∃ x, R u x ∧ P u = P x) ∧ (∃ x, R u x ∧ ¬ P u = P x)) ∨ ∀ w, ¬ R u w) :
    «本类至终有常» R («二分» P) m := fun u u' mu mu' v s =>
  have uu : P u' = P u := Eq.trans (Eq.symm mu') mu
  match both u' mu' with
  | .inr st => .inr st
  | .inl ⟨⟨x, hx, ux⟩, ⟨y, hy, uy⟩⟩ =>
    match decEq (P u) (P v) with
    | isTrue stays => .inl ⟨x, hx, Eq.trans (Eq.symm stays) (Eq.trans (Eq.symm uu) ux)⟩
    | isFalse leaves =>
      .inl ⟨y, hy, «异三则同» (fun yu => uy (Eq.trans uu (Eq.symm yu))) (fun vu => leaves (Eq.symm vu))⟩

/-! ### T6. "every division that gives the member the same class gives the same verdict":
the two-way form follows from «闭则外分无关» applied both ways. -/
theorem sameVerdict {R E F : «际» α} (hE : «类» E) (hF : «类» F) {m : α}
    (same : ∀ x, E m x ↔ F m x) (goes : ∃ w, R m w) (held : «所缘同于» R E m) :
    «本类至终有常» R E m ↔ «本类至终有常» R F m :=
  ⟨fun a => («闭则外分无关» hE hF same goes held a).1,
   fun a => («闭则外分无关» hF hE (fun x => (same x).symm) goes
      (fun v s => (same v).mp (held v s)) a).1⟩

/-! ### T8. Holding a member's effects (P4's predicate) does not depend on how what lies outside
the member's class is divided. -/
theorem heldInvariant {R E F : «际» α} {m : α} (same : ∀ x, E m x ↔ F m x) :
    «所缘同于» R E m ↔ «所缘同于» R F m :=
  ⟨fun h v s => (same v).mp (h v s), fun h v s => (same v).mpr (h v s)⟩

/-! ### T7. "It bears on the condition only through 'alike to that effect', for an effect that
leaves the member's class": provable as a lemma (two classes with the member's class in common and
the same alikeness to every effect that leaves it give the same verdict). -/
theorem onlyThroughOutside {R E F : «际» α} (hE : «类» E) (hF : «类» F) {m : α}
    (same : ∀ x, E m x ↔ F m x) (outside : ∀ v v', ¬ E m v → (E v v' ↔ F v v')) :
    «本类至终有常» R E m ↔ «本类至终有常» R F m := by
  have key : ∀ v v', (E v v' ↔ F v v') := by
    intro v v'
    match Classical.em (E m v) with
    | .inl mv => exact ⟨fun ev => hF.trans (hF.symm ((same v).mp mv)) ((same v').mp (hE.trans mv ev)),
        fun fv => hE.trans (hE.symm ((same v).mpr ((same v).mp mv)))
          ((same v').mpr (hF.trans ((same v).mp mv) fv))⟩
    | .inr nv => exact outside v v' nv
  constructor
  · intro a u u' mu mu' v s
    match a u u' ((same u).mpr mu) ((same u').mpr mu') v s with
    | .inl ⟨v', h, e⟩ => exact .inl ⟨v', h, (key v v').mp e⟩
    | .inr st => exact .inr st
  · intro a u u' mu mu' v s
    match a u u' ((same u).mp mu) ((same u').mp mu') v s with
    | .inl ⟨v', h, e⟩ => exact .inl ⟨v', h, (key v v').mpr e⟩
    | .inr st => exact .inr st

/-! ### T10. The sufficient condition of "Which class P2 reads", under the split. -/
theorem splitSufficient {R : «际» α} {P : α → Bool} {m : α}
    (both : ∀ u, P m = P u → (∃ w, R u w) →
      (∃ x, R u x ∧ P u = P x) ∧ (∃ x, R u x ∧ ¬ P u = P x)) :
    «本类至终有常» R («二分» P) m := by
  intro u u' mu mu' v s
  match Classical.em (∃ w, R u' w) with
  | .inr no => exact .inr (fun w h => no ⟨w, h⟩)
  | .inl yes =>
    have uu : P u' = P u := Eq.trans (Eq.symm mu') mu
    match Classical.em (P u = P v) with
    | .inl stays =>
      match (both u' mu' yes).1 with
      | ⟨x, hx, ux⟩ => exact .inl ⟨x, hx, show P v = P x from
          Eq.trans (Eq.symm stays) (Eq.trans (Eq.symm uu) ux)⟩
    | .inr leaves =>
      match (both u' mu' yes).2 with
      | ⟨x, hx, ux⟩ =>
        exact .inl ⟨x, hx, show P v = P x by
          cases hv : P v <;> cases hx' : P x <;> cases hu : P u <;> simp_all⟩

end

/-! ### T1. The hypothesis that the member conditions something is needed in «闭则外分无关»:
`m` conditions nothing (so it holds its effects vacuously), `c` and `c2` alike to it condition
`v` and `v2` outside. The split meets the condition at `m`; a finer division, with `m`'s class the
same, does not. -/
namespace T1
set_option linter.constructorNameAsVariable false
inductive Occ | m | c | c2 | v | v2
def step : «际» Occ
  | .c, .v => True
  | .c2, .v2 => True
  | _, _ => False
def inClass : Occ → Bool
  | .m => true | .c => true | .c2 => true | .v => false | .v2 => false
def kind : Occ → Nat
  | .m => 0 | .c => 0 | .c2 => 0 | .v => 1 | .v2 => 2
def finer : «际» Occ := fun x y => kind x = kind y
theorem finer_class : «类» finer := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩
theorem same_class : ∀ y, «二分» inClass .m y ↔ finer .m y := by
  intro y; cases y <;> simp [«二分», finer, inClass, kind]
theorem nothing : ∀ w, ¬ step .m w := by intro w; cases w <;> exact id
theorem held_split : «所缘同于» step («二分» inClass) .m := fun v h => absurd h (nothing v)
theorem split_at : «本类至终有常» step («二分» inClass) .m := by
  intro u u' mu mu' v r
  cases u <;> cases u' <;> cases v <;> simp_all [step, «二分», inClass] <;>
    first
    | exact .inl ⟨.v, trivial, rfl⟩
    | exact .inl ⟨.v2, trivial, rfl⟩
    | exact .inr (fun w h => by cases w <;> exact h)
theorem finer_not_at : ¬ «本类至终有常» step finer .m := fun a =>
  match a .c .c2 rfl rfl .v trivial with
  | .inl ⟨v', r, e⟩ => by cases v' <;> simp_all [step, finer, kind]
  | .inr st => st .v2 trivial
/-- Same class at `m`, `m`'s effects held (vacuously), different verdicts. -/
theorem goes_needed :
    (∀ y, «二分» inClass .m y ↔ finer .m y) ∧ «所缘同于» step («二分» inClass) .m ∧
      «本类至终有常» step («二分» inClass) .m ∧ ¬ «本类至终有常» step finer .m :=
  ⟨same_class, held_split, split_at, finer_not_at⟩
end T1

/-! ### T2. The record's correspondence: under the split, of a self that holds its effects, the
condition asks more than "that its line go on at every alike step that goes on". `m → i`,
`i → j`, `i → b`; the class `{m, i, j}` against `{b}`. -/
namespace T2
inductive Occ | m | i | j | b
def step : «际» Occ
  | .m, .i => True
  | .i, .j => True
  | .i, .b => True
  | _, _ => False
def inClass : Occ → Bool
  | .m => true | .i => true | .j => true | .b => false
theorem held : «所缘同于» step («二分» inClass) .m := by
  intro v r; cases v <;> simp_all [step, «二分», inClass]
/-- Every alike occurrence that conditions anything continues the line. -/
theorem line_goes_on : ∀ u, «二分» inClass .m u → (∃ w, step u w) →
    ∃ x, step u x ∧ «二分» inClass u x := by
  intro u mu ⟨w, hw⟩
  cases u <;> cases w <;> simp_all [step, «二分», inClass]
  · exact ⟨.i, trivial, rfl⟩
  · exact ⟨.j, trivial, rfl⟩
  · exact ⟨.j, trivial, rfl⟩
theorem not_at : ¬ «本类至终有常» step («二分» inClass) .m := fun a =>
  match a .i .m rfl rfl .b trivial with
  | .inl ⟨v', r, e⟩ => by cases v' <;> simp_all [step, «二分», inClass]
  | .inr st => st .i trivial
end T2

/-! ### T3. `Inconstant` fails the condition at the member's class too (the Lean shows only the
global failure). Net copied from GrammarPath's `Inconstant`. -/
namespace T3
inductive Occ | m | v | w
def step : «际» Occ
  | .m, .v => True
  | .v, .w => True
  | _, _ => False
def upper : Occ → Bool
  | .m => true | .v => true | .w => false
def same : «际» Occ := fun x y => upper x = upper y
theorem not_at : ¬ «本类至终有常» step same .m := fun a =>
  match a .v .m rfl rfl .w trivial with
  | .inl ⟨v', r, e⟩ => by cases v' <;> simp_all [step, same, upper]
  | .inr st => st .v trivial
end T3

/-! ### T4. Without P4, "what is alike to oneself downstream lies on one's line": `m → b → t`,
the class `{m, t}` against `{b}`. The condition holds at `m`; `t` is alike to `m` and downstream,
and is not reached. -/
namespace T4
inductive Occ | m | b | t
def step : «际» Occ
  | .m, .b => True
  | .b, .t => True
  | _, _ => False
def inClass : Occ → Bool
  | .m => true | .b => false | .t => true
theorem at_class : «本类至终有常» step («二分» inClass) .m := by
  intro u u' mu mu' v r
  cases u <;> cases u' <;> cases v <;> simp_all [step, «二分», inClass] <;>
    first
    | exact .inl ⟨.b, trivial, rfl⟩
    | exact .inr (fun w h => by cases w <;> exact h)
theorem alike_downstream : «二分» inClass .m .t ∧ «及» step .m .t :=
  ⟨rfl, «及».more (R := step) (x := Occ.m) (y := Occ.b) (z := Occ.t) (by simp [step])
    («及».one (R := step) (x := Occ.b) (y := Occ.t) (by simp [step]))⟩
theorem not_reached : ¬ «所及» step («二分» inClass) .m .t := by
  intro h
  rcases h with e | line
  · exact Occ.noConfusion e
  · obtain ⟨y, hy⟩ := firstStep line
    revert hy
    cases y <;> simp [«续», «合», step, «二分», inClass]
theorem not_held : ¬ «所缘同于» step («二分» inClass) .m := fun h =>
  Bool.noConfusion (h .b trivial)
end T4

/-! ### T5. P2's gloss: under the split, every line from `m` ends only at an occurrence that
conditions nothing, yet the condition at `m` fails (CleanStep at the member's class):
`m → i`, `m → u`, `i → j`; the class `{m, i, j}` against `{u}`. -/
namespace T5
inductive Occ | m | i | j | u
def step : «际» Occ
  | .m, .i => True
  | .m, .u => True
  | .i, .j => True
  | _, _ => False
def inClass : Occ → Bool
  | .m => true | .i => true | .j => true | .u => false
theorem not_at : ¬ «本类至终有常» step («二分» inClass) .m := fun a =>
  match a .m .i rfl rfl .u trivial with
  | .inl ⟨v', r, e⟩ => by cases v' <;> simp_all [step, «二分», inClass]
  | .inr st => st .j trivial
/-- Wherever a line from `m` ends, the net ends there too. -/
theorem ends_only_at_net_end : ∀ y, «相续» step («二分» inClass) .m y →
    «亡» step («二分» inClass) y → ∀ w, ¬ step y w := by
  intro y _ ends w r
  have hm : «有后» step («二分» inClass) .m := ⟨.i, ⟨trivial, rfl⟩⟩
  have hi : «有后» step («二分» inClass) .i := ⟨.j, ⟨trivial, rfl⟩⟩
  cases y <;> cases w <;> simp [step] at r
  all_goals first | exact ends hm | exact ends hi
/-- And the discrete class meets the condition at every member of every net, while a line under it
can end at its first occurrence with the net going on. -/
theorem discrete_at {α : Type} (R : «际» α) (m : α) : «本类至终有常» R (fun x y => x = y) m :=
  fun u u' mu mu' v r => .inl ⟨v, (mu.symm.trans mu') ▸ r, rfl⟩
end T5

/-! ### T9. The sufficient condition is for the split only: every alike occurrence that conditions
anything conditions something inside and something outside; the split meets the condition at `m`, a
finer division with the same class at `m` does not. -/
namespace T9
inductive Occ | m | c | i | j | b | d
def step : «际» Occ
  | .m, .i => True
  | .m, .b => True
  | .c, .j => True
  | .c, .d => True
  | _, _ => False
def inClass : Occ → Bool
  | .m => true | .c => true | .i => true | .j => true | .b => false | .d => false
def kind : Occ → Nat
  | .m => 0 | .c => 0 | .i => 0 | .j => 0 | .b => 1 | .d => 2
def finer : «际» Occ := fun x y => kind x = kind y
theorem same_class : ∀ y, «二分» inClass .m y ↔ finer .m y := by
  intro y; cases y <;> simp [«二分», finer, inClass, kind]
theorem both : ∀ u, inClass .m = inClass u → (∃ w, step u w) →
    (∃ x, step u x ∧ inClass u = inClass x) ∧ (∃ x, step u x ∧ ¬ inClass u = inClass x) := by
  intro u mu ⟨w, hw⟩
  cases u <;> cases w <;> simp_all [step, inClass]
  · exact ⟨⟨.i, trivial, rfl⟩, ⟨.b, trivial, by decide⟩⟩
  · exact ⟨⟨.i, trivial, rfl⟩, ⟨.b, trivial, by decide⟩⟩
  · exact ⟨⟨.j, trivial, rfl⟩, ⟨.d, trivial, by decide⟩⟩
  · exact ⟨⟨.j, trivial, rfl⟩, ⟨.d, trivial, by decide⟩⟩
theorem split_at : «本类至终有常» step («二分» inClass) .m := splitSufficient both
theorem finer_not_at : ¬ «本类至终有常» step finer .m := fun a =>
  match a .m .c rfl rfl .b trivial with
  | .inl ⟨v', r, e⟩ => by cases v' <;> simp_all [step, finer, kind]
  | .inr st => st .j trivial
end T9

/-! ### T11. FinerOutside's "Where" clause read as a general law fails: `m → b`, `c → d`, `c → i`;
both alike occurrences condition something outside, in two places, and the split fails at `m`. -/
namespace T11
inductive Occ | m | c | i | b | d
def step : «际» Occ
  | .m, .b => True
  | .c, .d => True
  | .c, .i => True
  | _, _ => False
def inClass : Occ → Bool
  | .m => true | .c => true | .i => true | .b => false | .d => false
theorem split_not_at : ¬ «本类至终有常» step («二分» inClass) .m := fun a =>
  match a .c .m rfl rfl .i trivial with
  | .inl ⟨v', r, e⟩ => by cases v' <;> simp_all [step, «二分», inClass]
  | .inr st => st .b trivial
end T11

end Scratch

#print axioms Scratch.sameVerdict
#print axioms Scratch.onlyThroughOutsideDec
#print axioms Scratch.splitSufficientDec
#print axioms Scratch.heldInvariant
#print axioms Scratch.onlyThroughOutside
#print axioms Scratch.splitSufficient
#print axioms Scratch.T1.goes_needed
#print axioms Scratch.T2.not_at
#print axioms Scratch.T3.not_at
#print axioms Scratch.T4.not_reached
#print axioms Scratch.T5.ends_only_at_net_end
#print axioms Scratch.T9.finer_not_at
