import Becoming.Grammar
import Becoming.GrammarMap

/-!
# What a line under a class must hold, and what a regularity takes in (所经必同, 常闭则后皆续)

Chapter 7 §4.6 joins two routes into one path to the future: a line goes on past a member's end
under a coarser class, and, through the conditions it runs through, reaches what those conditions
later feed. Two of its steps were shown only in witnesses (`Becoming.GrammarCases`). This module
states them for every carrier, relation and class.

* **What a line must pass, its class must hold (所经必同).** Where a region (a decided predicate `P`)
  is left under a class only into a set `C` (every step under the class from inside `P` to outside
  lands in `C`), a line under the class from inside the region to outside holds a member of `C`
  alike to its start, and reaches it (`«所经必同»`). So where no member of `C` is alike to the start,
  nothing outside the region is reached under that class (`«所经不同则不及»`). Read with a family as
  the region and its conditions as `C`: a class under which a line runs out of its family through
  its conditions must hold one of them, the one it passes. `SharedCondition.affecting_member_outside`
  is its case.
* **A regularity that holds a member's effects takes in all that follows (常闭则后皆续).** Call a
  member's effects *held* by a relation where everything it conditions is alike to it (`«所缘同于»`).
  This is a property of one member, not the constancy of a coarse net that `«闭合当且仅当有常»`
  calls closure. Under a constant class (`«有常»`), whatever is alike to a member whose effects the
  class holds conditions only what is alike to it (`«常闭则所缘同类»`), so everything downstream of
  anything alike to it is alike to it and on a line under the class from there (`«常闭则后皆续»`),
  and anything a line from a center reaches that is alike to the member carries the line on to all
  that follows it (`«常闭则所及皆及»`). Given constancy, holding a member's effects is equivalent to
  everything downstream of it being alike to it (`«常类之闭当且仅当后皆同类»`): the backward direction
  is the one-step case, and the forward direction is where constancy does its work.
* **Up to the net's end.** Constancy lets no line end after its first step (`«有常则相续不尽»`), so in
  a net where every line ends (finite and with no cycle, for example) no class under which anything
  continues is constant; `FiniteDescent` is a witness, where not even the one is. The laws above hold
  under a weaker condition, *constancy up to the net's end* (`«至终有常»`): whatever an alike
  occurrence conditions, this one conditions something alike to it, unless this one conditions
  nothing at all; so a line under the class ends only at an occurrence that conditions nothing.
  Constancy gives it (`«有常则至终有常»`), and a class under which a line ends at an occurrence that
  still conditions something lacks it (`«亡而网续则不至终有常»`, for any relation). Under it the same
  laws hold, for a member that conditions something where the start is another occurrence alike to
  it (`«至终常闭则后皆续»`, `«至终常闭则所及皆及»`, `«至终常类之闭当且仅当后皆同类»`); the constant forms
  are their corollaries. In a finite descent with two families the class of one family is narrower
  than the one, constant up to the net's end, and takes in everything downstream of its first birth
  and nothing of the other family, while the organism's class is not constant up to the net's end,
  its line ending at old age while the net goes on (`FiniteFamilies`). In a finite net with two families
  sharing a condition they affect, every premise holds at once: the class holding the families with
  their condition is narrower than the one, constant up to the net's end and holds the first member's
  effects, and its line from the first family's first birth reaches the second family past the first
  member's end, while the member's class is not constant up to the net's end
  (`FiniteSharedCondition`).
* **What leaves the class follows the line (出类随线).** Under a class constant up to the net's end,
  where a member conditions something not alike to it, every occurrence alike to the member that
  conditions anything conditions something alike to that effect and outside the class (`«出类随行»`),
  so every one on its line does (`«出类随线»`); where one such occurrence conditions nothing alike to
  that effect, the class is not constant up to the net's end (`«出类不随则不至终有常»`, witness
  `CleanStep`). This is nearly the definition of constancy up to the net's end read at a member the
  class does not close, and "alike to that effect" is only as fine as the class divides what lies
  outside it. Read with a class drawn by what a member intends [a reading; nothing in the Lean marks an
  intended effect]: such a class can be constant up to the net's end without holding the member's
  effects (`FiniteWake`, finite and without cycles), and then every step of its line that goes on has
  an effect outside it.
* **Neither premise can be dropped.** Where a member's line runs through a condition but the member's
  effects leave its class, a constant class holding the member with the condition does not take in
  what the condition feeds (`Unclosed`); and where the class is not constant, even up to the net's
  end, a member whose effects it holds need not have what follows them alike to it (`Inconstant`).
  `ThirdFed.constant_takes_third` in `Becoming.GrammarCases` needs constancy and not this premise: it
  is a one-step instance of `«有常之逐点»`, whose conclusion is alikeness to the member's next stage.

Every declaration has an empty axiom report. The decided predicate in `«所经必同»` is what lets the
proof ask, of each occurrence on the line, whether it is still inside the region; no classical
principle is used.
-/

namespace Becoming

universe u

section Path

variable {α : Type u}

/-- **What a line must pass, its class must hold (所经必同).** Where every step under a class `E` from
inside a region `P` to outside it lands in `C`, a line under `E` from inside to outside holds a member
of `C` alike to its start, and reaches it. -/
theorem «所经必同» {R E : «际» α} (hE : «类» E) {P : α → Bool} {C : α → Prop}
    (exits : ∀ u v, P u = true → «续» R E u v → P v = false → C v) {x y : α}
    (inside : P x = true) (outside : P y = false) (reached : «所及» R E x y) :
    ∃ c, C c ∧ E x c ∧ «所及» R E x c := by
  have key : ∀ u w, «相续» R E u w → P u = true → P w = false → ∃ c, C c ∧ «所及» R E u c := by
    intro u w line
    induction line with
    | one c =>
      intro pu pw
      exact ⟨_, exits _ _ pu c pw, .inr (.one c)⟩
    | @more a b _ c _ ih =>
      intro pa pw
      cases pb : P b with
      | false => exact ⟨b, exits a b pa c pb, .inr (.one c)⟩
      | true =>
        match ih pb pw with
        | ⟨d, hd, .inl e⟩ => exact ⟨d, hd, .inr (e ▸ .one c)⟩
        | ⟨d, hd, .inr rest⟩ => exact ⟨d, hd, .inr (.more c rest)⟩
  match reached with
  | .inl e => exact absurd (e ▸ inside) (by rw [outside]; exact Bool.false_ne_true)
  | .inr line =>
    match key x y line inside outside with
    | ⟨c, hc, .inl e⟩ => exact ⟨c, hc, e ▸ hE.refl x, .inl e⟩
    | ⟨c, hc, .inr l⟩ => exact ⟨c, hc, «线内同类» hE l, .inr l⟩

/-- **Where the class holds nothing the line must pass, nothing beyond is reached.** -/
theorem «所经不同则不及» {R E : «际» α} (hE : «类» E) {P : α → Bool} {C : α → Prop}
    (exits : ∀ u v, P u = true → «续» R E u v → P v = false → C v) {x y : α}
    (inside : P x = true) (outside : P y = false) (apart : ∀ c, C c → ¬ E x c) :
    ¬ «所及» R E x y := fun reached =>
  match «所经必同» hE exits inside outside reached with
  | ⟨c, hc, alike, _⟩ => apart c hc alike

/-- A member's effects are *held* by a relation where everything it conditions is alike to it
(所缘同于). This is a property of one member, not the constancy of a coarse net that
`«闭合当且仅当有常»` calls closure. -/
def «所缘同于» (R E : «际» α) (m : α) : Prop := ∀ v, R m v → E m v

/-- **Constancy up to the net's end (至终有常).** Whatever an alike occurrence conditions, this one
conditions something alike to it, unless this one conditions nothing at all; so a line under the class
ends only at an occurrence that conditions nothing. -/
def «至终有常» (R E : «际» α) : Prop :=
  ∀ u u', E u u' → ∀ v, R u v → (∃ v', R u' v' ∧ E v v') ∨ ∀ w, ¬ R u' w

/-- Constancy is constancy up to the net's end. -/
theorem «有常则至终有常» {R E : «际» α} (constant : «有常» R E) : «至终有常» R E :=
  fun u u' e v r => .inl ((«有常之逐点» R E).mp constant u u' e v r)

/-- **A relation under which a line ends at an occurrence that still conditions something is not
constant up to the net's end (亡而网续则不至终有常).** The up-to-the-end form of `«有亡之续则不有常»`,
for any relation `E`, a class or not. -/
theorem «亡而网续则不至终有常» {R E : «际» α} {x y : α} (hxy : «续» R E x y)
    (ends : «亡» R E y) (goes : ∃ w, R y w) : ¬ «至终有常» R E := fun constant =>
  match constant x y hxy.2 y hxy.1 with
  | .inl ⟨v', hv', ev⟩ => ends ⟨v', hv', ev⟩
  | .inr stops => match goes with
    | ⟨w, hw⟩ => stops w hw

/-- **Up to the net's end, whatever is alike to a member that conditions something, and whose effects
the class holds, conditions only what is alike to it.** -/
theorem «至终常闭则所缘同类» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) {m : α}
    (goes : ∃ w, R m w) (held : «所缘同于» R E m) {u v : α} (alike : E u m) (step : R u v) : E v m :=
  match constant u m alike v step with
  | .inl ⟨v', hv', ev⟩ => hE.trans ev (hE.symm (held v' hv'))
  | .inr stops => match goes with
    | ⟨w, hw⟩ => absurd hw (stops w)

/-- **A regularity that holds a member's effects takes in all that follows (常闭则后皆续), up to the
net's end.** Under a class constant up to the net's end, everything downstream of anything alike to a
member that conditions something, and whose effects the class holds, is alike to it and lies on a line
under the class from there. That the member conditions something is needed where the start is another
occurrence alike to it. -/
theorem «至终常闭则后皆续» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) {m : α}
    (goes : ∃ w, R m w) (held : «所缘同于» R E m) {c t : α} (alike : E c m) (down : «及» R c t) :
    E t m ∧ «相续» R E c t := by
  induction down with
  | one step =>
    have et := «至终常闭则所缘同类» hE constant goes held alike step
    exact ⟨et, .one ⟨step, hE.trans alike (hE.symm et)⟩⟩
  | @more a b _ step _ ih =>
    have eb : E b m := «至终常闭则所缘同类» hE constant goes held alike step
    match ih eb with
    | ⟨et, rest⟩ => exact ⟨et, .more ⟨step, hE.trans alike (hE.symm eb)⟩ rest⟩

/-- Under a constant class, what is alike to an occurrence that conditions something conditions
something itself. -/
theorem «有常则同类者有所缘» {R E : «际» α} (constant : «有常» R E) {c m v : α} (alike : E c m)
    (step : R c v) : ∃ w, R m w :=
  match («有常之逐点» R E).mp constant c m alike v step with
  | ⟨w, hw, _⟩ => ⟨w, hw⟩

/-- **Under a constant class, whatever is alike to a member whose effects the class holds conditions
only what is alike to it.** -/
theorem «常闭则所缘同类» {R E : «际» α} (hE : «类» E) (constant : «有常» R E) {m : α}
    (held : «所缘同于» R E m) {u v : α} (alike : E u m) (step : R u v) : E v m :=
  «至终常闭则所缘同类» hE («有常则至终有常» constant) («有常则同类者有所缘» constant alike step) held
    alike step

/-- **A regularity that holds a member's effects takes in all that follows (常闭则后皆续).** Under a
constant class, everything downstream of anything alike to a member whose effects the class holds is
alike to it and lies on a line under the class from there. -/
theorem «常闭则后皆续» {R E : «际» α} (hE : «类» E) (constant : «有常» R E) {m : α}
    (held : «所缘同于» R E m) {c t : α} (alike : E c m) (down : «及» R c t) :
    E t m ∧ «相续» R E c t :=
  match down with
  | .one step => «至终常闭则后皆续» hE («有常则至终有常» constant)
      («有常则同类者有所缘» constant alike step) held alike (.one step)
  | .more step rest => «至终常闭则后皆续» hE («有常则至终有常» constant)
      («有常则同类者有所缘» constant alike step) held alike (.more step rest)

/-- **What a line reaches alike to a member that conditions something, and whose effects the class
holds, it carries on to all that follows**, up to the net's end. -/
theorem «至终常闭则所及皆及» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) {m x c t : α}
    (goes : ∃ w, R m w) (held : «所缘同于» R E m) (toC : «所及» R E x c) (alike : E c m)
    (down : «及» R c t) : «所及» R E x t :=
  «所及之传递» toC (.inr («至终常闭则后皆续» hE constant goes held alike down).2)

/-- **What a line reaches alike to a member whose effects the class holds, it carries on to all that
follows.** Under a constant class, where a line from a center reaches an occurrence alike to such a
member, it reaches everything downstream of that occurrence. -/
theorem «常闭则所及皆及» {R E : «际» α} (hE : «类» E) (constant : «有常» R E) {m x c t : α}
    (held : «所缘同于» R E m) (toC : «所及» R E x c) (alike : E c m) (down : «及» R c t) :
    «所及» R E x t :=
  «所及之传递» toC (.inr («常闭则后皆续» hE constant held alike down).2)

/-- **What leaves the class follows each alike step (出类随行).** Under a class constant up to the net's
end, where a member conditions something not alike to it, whatever is alike to the member and
conditions anything conditions something alike to that effect and not alike to itself. Nearly the
definition of constancy up to the net's end, read at a member that the class does not close. -/
theorem «出类随行» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) {m c u : α}
    (alike : E c m) (effect : R m u) (outside : ¬ E m u) (goes : ∃ w, R c w) :
    ∃ x, R c x ∧ E u x ∧ ¬ E c x :=
  match constant m c (hE.symm alike) u effect with
  | .inl ⟨x, hx, ux⟩ => ⟨x, hx, ux, fun cx => outside (hE.trans (hE.symm alike) (hE.trans cx (hE.symm ux)))⟩
  | .inr stops => match goes with
    | ⟨w, hw⟩ => absurd hw (stops w)

/-- **What leaves the class follows the line (出类随线).** Under a class constant up to the net's end,
where a member conditions something not alike to it, every occurrence on its line under the class that
conditions anything conditions something alike to that effect and outside the class. -/
theorem «出类随线» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) {m c u : α}
    (line : «所及» R E m c) (effect : R m u) (outside : ¬ E m u) (goes : ∃ w, R c w) :
    ∃ x, R c x ∧ E u x ∧ ¬ E c x :=
  «出类随行» hE constant
    (match line with
     | .inl e => e ▸ hE.refl m
     | .inr l => hE.symm («线内同类» hE l)) effect outside goes

/-- **Where nothing leaving the class follows, the class is not constant up to the net's end
(出类不随则不至终有常).** Where a member conditions something not alike to it, and an occurrence alike
to the member conditions something but nothing alike to that effect, the class is not constant up to
the net's end. -/
theorem «出类不随则不至终有常» {R E : «际» α} (hE : «类» E) {m c u : α} (alike : E c m)
    (effect : R m u) (outside : ¬ E m u) (goes : ∃ w, R c w) (clean : ∀ x, R c x → ¬ E u x) :
    ¬ «至终有常» R E := fun constant =>
  match «出类随行» hE constant alike effect outside goes with
  | ⟨x, hx, ux, _⟩ => clean x hx ux

/-- **Up to the net's end, a class holds a member's effects exactly where everything downstream of the
member is alike to it.** The backward direction is the one-step case; the forward direction is where
constancy up to the net's end does its work. -/
theorem «至终常类之闭当且仅当后皆同类» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) {m : α} :
    «所缘同于» R E m ↔ ∀ t, «及» R m t → E m t :=
  ⟨fun held _ down =>
     match down with
     | .one step => hE.symm («至终常闭则后皆续» hE constant ⟨_, step⟩ held (hE.refl m) (.one step)).1
     | .more step rest =>
       hE.symm («至终常闭则后皆续» hE constant ⟨_, step⟩ held (hE.refl m) (.more step rest)).1,
   fun all v step => all v (.one step)⟩

/-- **Under constancy, a class holds a member's effects exactly where everything downstream of the
member is alike to it.** -/
theorem «常类之闭当且仅当后皆同类» {R E : «际» α} (hE : «类» E) (constant : «有常» R E) {m : α} :
    «所缘同于» R E m ↔ ∀ t, «及» R m t → E m t :=
  «至终常类之闭当且仅当后皆同类» hE («有常则至终有常» constant)

end Path

/-! ## Neither premise can be dropped -/

namespace Unclosed

/-! A member `m` conditioning a condition `c` and an effect `v`, the condition conditioning the member
back and feeding `t`; `m` and `c` in one class, `t` and `v` in another. The class is constant and the
member's line runs through the condition, but the member's effect `v` leaves its class, and what the
condition feeds is not reached. -/

inductive Occ | c | m | t | v

def step : «际» Occ
  | .c, .c => False
  | .c, .m => True
  | .c, .t => True
  | .c, .v => False
  | .m, .c => True
  | .m, .m => False
  | .m, .t => False
  | .m, .v => True
  | .t, .c => False
  | .t, .m => False
  | .t, .t => False
  | .t, .v => False
  | .v, .c => False
  | .v, .m => False
  | .v, .t => False
  | .v, .v => False

/-- The first class holds the condition and the member, the second what they condition beyond. -/
def upper : Occ → Bool
  | .c => true
  | .m => true
  | .t => false
  | .v => false

def same : «际» Occ := fun x y => upper x = upper y

theorem same_class : «类» same := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩

theorem constant : «有常» step same := by
  apply («有常之逐点» step same).mpr
  intro u u' e x r
  match u, u', x, e, r with
  | .c, .c, .m, _, _ => exact ⟨.m, trivial, rfl⟩
  | .c, .c, .t, _, _ => exact ⟨.t, trivial, rfl⟩
  | .c, .m, .m, _, _ => exact ⟨.c, trivial, rfl⟩
  | .c, .m, .t, _, _ => exact ⟨.v, trivial, rfl⟩
  | .m, .c, .c, _, _ => exact ⟨.m, trivial, rfl⟩
  | .m, .c, .v, _, _ => exact ⟨.t, trivial, rfl⟩
  | .m, .m, .c, _, _ => exact ⟨.c, trivial, rfl⟩
  | .m, .m, .v, _, _ => exact ⟨.v, trivial, rfl⟩
  | .c, .t, _, e, _ => exact Bool.noConfusion e
  | .c, .v, _, e, _ => exact Bool.noConfusion e
  | .m, .t, _, e, _ => exact Bool.noConfusion e
  | .m, .v, _, e, _ => exact Bool.noConfusion e

/-- **A constant class holding a member with a condition its line runs through, where the member's
effects leave the class, does not take in what the condition feeds.** -/
theorem not_taken_in :
    «续» step same .m .c ∧ step .c .t ∧ ¬ «所缘同于» step same .m ∧ ¬ same .t .m ∧
      ¬ «所及» step same .m .t :=
  ⟨⟨trivial, rfl⟩, trivial, fun held => Bool.noConfusion (held .v trivial),
   fun e => Bool.noConfusion e,
   fun reached => match reached with
     | .inl e => Occ.noConfusion e
     | .inr line => Bool.noConfusion («线内同类» same_class line)⟩

end Unclosed

namespace Inconstant

/-! A member `m` conditioning `v` alike to it, `v` conditioning `w` in a second class: the class holds
the member's effects but is not constant, even up to the net's end, and what follows its effect is not
alike to it. -/

inductive Occ | m | v | w

def step : «际» Occ
  | .m, .m => False
  | .m, .v => True
  | .m, .w => False
  | .v, .m => False
  | .v, .v => False
  | .v, .w => True
  | .w, .m => False
  | .w, .v => False
  | .w, .w => False

def upper : Occ → Bool
  | .m => true
  | .v => true
  | .w => false

def same : «际» Occ := fun x y => upper x = upper y

theorem same_class : «类» same := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩

/-- **A class that holds a member's effects but is not constant, even up to the net's end, need not
have what follows them alike to the member.** -/
theorem not_all_follow :
    «所缘同于» step same .m ∧ ¬ «至终有常» step same ∧ ¬ «有常» step same ∧ «及» step .m .w ∧
      ¬ same .w .m :=
  have notToEnd : ¬ «至终有常» step same := fun constant =>
    match constant .v .m rfl .w trivial with
    | .inl ⟨.v, _, e⟩ => Bool.noConfusion e
    | .inl ⟨.m, h, _⟩ => h
    | .inl ⟨.w, h, _⟩ => h
    | .inr stops => stops .v trivial
  ⟨fun x r => match x, r with
     | .v, _ => rfl,
   notToEnd,
   fun constant => notToEnd («有常则至终有常» constant),
   «及».more (R := step) (x := .m) (y := .v) (z := .w) trivial («及».one (R := step) (x := .v) (y := .w) trivial),
   fun e => Bool.noConfusion e⟩

end Inconstant

namespace FiniteFamilies

/-! Two families, each with two members in turn, each member young then old, the second member's birth
following the first's old age, and nothing after the second member's old age: a finite net in which
every line ends. An occurrence is its family and its stage `0` to `3` (first young, first old, second
young, second old). -/

abbrev Occ := Bool × Nat

/-- Within a family, each stage below the last goes on to the next. -/
def step : «际» Occ := fun x y => x.1 = y.1 ∧ y.2 = x.2 + 1 ∧ x.2 < 3

/-- The class of a family. -/
def family : «际» Occ := fun x y => x.1 = y.1

/-- The class of one member: its family and whether it is the second member. -/
def member : «际» Occ := fun x y => x.1 = y.1 ∧ (decide (2 ≤ x.2) = decide (2 ≤ y.2))

theorem family_class : «类» family := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩

/-- **The family's class is narrower than the one**: the two families are not alike. -/
theorem family_narrower : ¬ family (false, 0) (true, 0) := fun e => Bool.noConfusion e

/-- **In a finite net the one is not constant**: the second member's old age conditions nothing. -/
theorem one_not_constant : ¬ «有常» step («一» : «际» Occ) := fun constant =>
  match («有常之逐点» step «一»).mp constant (false, 2) (false, 3) trivial (false, 3)
      ⟨rfl, rfl, Nat.lt_succ_self 2⟩ with
  | ⟨_, ⟨_, _, h⟩, _⟩ => Nat.lt_irrefl 3 h

/-- **Up to the net's end the family's class is constant**: whatever an occurrence of the family
conditions, every other conditions the next stage of the same family, unless it is the last. -/
theorem family_constant_to_end : «至终有常» step family := by
  intro u u' e v r
  match Nat.decLt u'.2 3 with
  | .isTrue h => exact .inl ⟨(u'.1, u'.2 + 1), ⟨rfl, rfl, h⟩, r.1.symm.trans e⟩
  | .isFalse h => exact .inr (fun _ s => h s.2.2)

/-- **The organism's class is not constant up to the net's end**: the first member's line ends at its
old age while the net goes on to the second member's birth. -/
theorem member_not_constant_to_end : ¬ «至终有常» step member :=
  «亡而网续则不至终有常» (x := (false, 0)) (y := (false, 1))
    ⟨⟨rfl, rfl, Nat.lt_succ_of_le (Nat.le_succ_of_le (Nat.le_succ 0))⟩, rfl, rfl⟩
    (fun ⟨z, ⟨_, e2, _⟩, ⟨_, d⟩⟩ => by
      have hz : z.2 = 2 := e2
      rw [hz] at d
      exact Bool.noConfusion d)
    ⟨(false, 2), rfl, rfl, Nat.lt_succ_of_le (Nat.le_succ_of_le (Nat.le_refl 1))⟩

/-- Everything the first birth of a family conditions is in its family. -/
theorem first_birth_held (f : Bool) : «所缘同于» step family (f, 0) := fun _ s => s.1

/-- **Up to the net's end, the family's class takes in everything downstream of the family's first
birth.** -/
theorem family_takes_in_all {f : Bool} {t : Occ} (down : «及» step (f, 0) t) :
    «所及» step family (f, 0) t :=
  «至终常闭则所及皆及» (m := (f, 0)) family_class family_constant_to_end ⟨(f, 1), rfl, rfl, Nat.zero_lt_succ 2⟩
    (first_birth_held f) (.inl rfl) (family_class.refl _) down

/-- **And nothing of the other family**: no line under any relation leaves a family. -/
theorem other_family_outside (E : «际» Occ) (n : Nat) : ¬ «所及» step E (false, 0) (true, n) := by
  have stays : ∀ x y, «相续» step E x y → y.1 = x.1 := by
    intro x y line
    induction line with
    | one c => exact c.1.1.symm
    | more c _ ih => exact ih.trans c.1.1.symm
  intro reached
  match reached with
  | .inl e => exact Bool.noConfusion (congrArg Prod.fst e)
  | .inr line => exact Bool.noConfusion (stays _ _ line)

end FiniteFamilies


namespace FiniteSharedCondition

/-! Two families and a condition they share, each of four stages, and a fourth thing joined to nothing.
Each family's stage goes on to its next and to the condition's next; the condition's stage goes on to
each family's next and to its own; nothing goes on after stage `3`. The class "living or the
condition" holds the families with the condition and leaves the fourth thing out. Here every premise
of the path holds at once: a member's line ends, the class is constant up to the net's end and
narrower than the one, it holds the first member's effects, and its line from the first family's
first birth reaches the second family past that member's end. -/

/-- The first family, the second, the shared condition, and a fourth thing joined to nothing. -/
inductive Kind | a | b | r | x

abbrev Occ := Kind × Nat

/-- Which kinds condition which. -/
def link : Kind → Kind → Prop
  | .a, .a => True
  | .a, .b => False
  | .a, .r => True
  | .a, .x => False
  | .b, .a => False
  | .b, .b => True
  | .b, .r => True
  | .b, .x => False
  | .r, .a => True
  | .r, .b => True
  | .r, .r => True
  | .r, .x => False
  | .x, .a => False
  | .x, .b => False
  | .x, .r => False
  | .x, .x => False

/-- A stage below the last goes on to the next stage of the kinds it conditions. -/
def step : «际» Occ := fun u v => link u.1 v.1 ∧ v.2 = u.2 + 1 ∧ u.2 < 3

/-- Living or the condition, as against the fourth thing. -/
def joined : Kind → Bool
  | .a => true
  | .b => true
  | .r => true
  | .x => false

/-- The class holding the families with their condition. -/
def held : «际» Occ := fun u v => joined u.1 = joined v.1

/-- The class of one member: its kind and whether it is the second member (stages `2` and `3`). -/
def member : «际» Occ := fun u v => u.1 = v.1 ∧ decide (2 ≤ u.2) = decide (2 ≤ v.2)

theorem held_class : «类» held := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩

theorem link_joined : ∀ k k', link k k' → joined k = true ∧ joined k' = true
  | .a, .a, _ => ⟨rfl, rfl⟩
  | .a, .r, _ => ⟨rfl, rfl⟩
  | .b, .b, _ => ⟨rfl, rfl⟩
  | .b, .r, _ => ⟨rfl, rfl⟩
  | .r, .a, _ => ⟨rfl, rfl⟩
  | .r, .b, _ => ⟨rfl, rfl⟩
  | .r, .r, _ => ⟨rfl, rfl⟩
  | .a, .b, h => False.elim h
  | .a, .x, h => False.elim h
  | .b, .a, h => False.elim h
  | .b, .x, h => False.elim h
  | .r, .x, h => False.elim h
  | .x, .a, h => False.elim h
  | .x, .b, h => False.elim h
  | .x, .r, h => False.elim h
  | .x, .x, h => False.elim h

theorem link_self : ∀ k, joined k = true → link k k
  | .a, _ => trivial
  | .b, _ => trivial
  | .r, _ => trivial
  | .x, h => Bool.noConfusion h

/-- **The class is narrower than the one**: it leaves the fourth thing out. -/
theorem held_narrower : ¬ held (.a, 0) (.x, 0) := fun e => Bool.noConfusion e

/-- **In this finite net the one is not constant.** -/
theorem one_not_constant : ¬ «有常» step («一» : «际» Occ) := fun constant =>
  match («有常之逐点» step «一»).mp constant (.a, 2) (.a, 3) trivial (.a, 3)
      ⟨trivial, rfl, Nat.lt_succ_self 2⟩ with
  | ⟨_, ⟨_, _, h⟩, _⟩ => Nat.lt_irrefl 3 h

/-- **Up to the net's end the class holding the families with their condition is constant.** -/
theorem held_constant_to_end : «至终有常» step held := by
  intro u u' e v r
  have hu : joined u.1 = true := (link_joined _ _ r.1).1
  have hv : joined v.1 = true := (link_joined _ _ r.1).2
  have hu' : joined u'.1 = true := e ▸ hu
  match Nat.decLt u'.2 3 with
  | .isTrue h => exact .inl ⟨(u'.1, u'.2 + 1), ⟨link_self _ hu', rfl, h⟩, hv.trans hu'.symm⟩
  | .isFalse h => exact .inr (fun _ s => h s.2.2)

/-- **The class holds the first member's effects**: everything the first family's first birth
conditions is in it. -/
theorem first_birth_held : «所缘同于» step held (.a, 0) := fun _ s => ((link_joined _ _ s.1).2).symm

/-- **The member's line ends while the net goes on**, so the member's class is not constant up to the
net's end. -/
theorem member_not_constant_to_end : ¬ «至终有常» step member :=
  «亡而网续则不至终有常» (x := (.a, 0)) (y := (.a, 1))
    ⟨⟨trivial, rfl, Nat.zero_lt_succ 2⟩, rfl, rfl⟩
    (fun ⟨z, ⟨_, e2, _⟩, ⟨k, d⟩⟩ => by
      have hz : z.2 = 2 := e2
      rw [hz] at d
      exact Bool.noConfusion d)
    ⟨(.a, 2), trivial, rfl, Nat.lt_succ_of_le (Nat.le_succ 1)⟩

/-- **The line under the class from the first family's first birth reaches the second family past the
first member's end**, through the condition the first member affects: the second family's stage `2`,
after the first member's line has ended at stage `1`. -/
theorem reaches_other_past_end : «所及» step held (.a, 0) (.b, 2) :=
  «至终常闭则所及皆及» (m := (.a, 0)) held_class held_constant_to_end
    (⟨(.a, 1), trivial, rfl, Nat.zero_lt_succ 2⟩ : ∃ w, step (.a, 0) w) first_birth_held (.inl rfl) rfl
    («及».more (x := (Kind.a, 0)) (y := (Kind.r, 1)) (z := (Kind.b, 2)) ⟨trivial, rfl, Nat.zero_lt_succ 2⟩
      («及».one ⟨trivial, rfl, Nat.lt_succ_of_le (Nat.le_succ 1)⟩))

/-- **And not the fourth thing**, joined to nothing. -/
theorem fourth_outside (n : Nat) : ¬ «所及» step held (.a, 0) (.x, n) := fun reached =>
  match reached with
  | .inl e => Kind.noConfusion (congrArg Prod.fst e)
  | .inr line => Bool.noConfusion («线内同类» held_class line)

end FiniteSharedCondition


namespace CleanStep

/-! A member `m` conditioning `i` and `u`; `i` goes on to `j` and conditions nothing outside the class.
The class holding `m`, `i` and `j` and keeping `u` apart is not constant, even up to the net's end.
Read as an agent, `i` would be an intended effect that goes on with no side effect; that is a
reading. -/

inductive Occ | m | i | j | u

def step : «际» Occ
  | .m, .m => False
  | .m, .i => True
  | .m, .j => False
  | .m, .u => True
  | .i, .m => False
  | .i, .i => False
  | .i, .j => True
  | .i, .u => False
  | .j, .m => False
  | .j, .i => False
  | .j, .j => False
  | .j, .u => False
  | .u, .m => False
  | .u, .i => False
  | .u, .j => False
  | .u, .u => False

/-- The line held by the class, as against what leaves it. -/
def intended : Occ → Bool
  | .m => true
  | .i => true
  | .j => true
  | .u => false

def own : «际» Occ := fun x y => intended x = intended y

theorem own_class : «类» own := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩

/-- **An occurrence alike to the member that goes on with nothing outside the class makes the class fail
constancy up to the net's end** (`«出类不随则不至终有常»`). -/
theorem not_constant_to_end : ¬ «至终有常» step own :=
  «出类不随则不至终有常» own_class (m := .m) (c := .i) (u := .u) rfl trivial (fun e => Bool.noConfusion e)
    ⟨.j, trivial⟩ (fun x r => match x, r with
      | .j, _ => fun e => Bool.noConfusion e)

end CleanStep

namespace FiniteWake

/-! A member `m` conditioning `i` and `u`, `i` conditioning `j` and `u₂`, and nothing after: finite and
without cycles. The class holding `m`, `i` and `j` and keeping `u` and `u₂` apart is constant up to the
net's end though not constant, does not hold the member's effects, and every step of its line that
goes on has an effect outside it. Read as an agent with a wake, `i` and `j` would be its intended line
and `u`, `u₂` its side effects; that is a reading. -/

inductive Occ | m | i | j | u | u₂

def step : «际» Occ
  | .m, .m => False
  | .m, .i => True
  | .m, .j => False
  | .m, .u => True
  | .m, .u₂ => False
  | .i, .m => False
  | .i, .i => False
  | .i, .j => True
  | .i, .u => False
  | .i, .u₂ => True
  | .j, .m => False
  | .j, .i => False
  | .j, .j => False
  | .j, .u => False
  | .j, .u₂ => False
  | .u, .m => False
  | .u, .i => False
  | .u, .j => False
  | .u, .u => False
  | .u, .u₂ => False
  | .u₂, .m => False
  | .u₂, .i => False
  | .u₂, .j => False
  | .u₂, .u => False
  | .u₂, .u₂ => False

def line : Occ → Bool
  | .m => true
  | .i => true
  | .j => true
  | .u => false
  | .u₂ => false

def own : «际» Occ := fun x y => line x = line y

theorem own_class : «类» own := ⟨fun _ => rfl, Eq.symm, Eq.trans⟩

/-- **The class is constant up to the net's end.** -/
theorem constant_to_end : «至终有常» step own := by
  intro x x' e v r
  cases x <;> cases v <;> cases x' <;>
    first
    | exact False.elim r
    | exact Bool.noConfusion e
    | exact .inl ⟨.i, trivial, rfl⟩
    | exact .inl ⟨.j, trivial, rfl⟩
    | exact .inl ⟨.u, trivial, rfl⟩
    | exact .inl ⟨.u₂, trivial, rfl⟩
    | exact .inr (fun w h => by cases w <;> exact False.elim h)

/-- **It is not constant**: `j` is alike to `m` and conditions nothing. -/
theorem not_constant : ¬ «有常» step own := fun constant =>
  match («有常之逐点» step own).mp constant .m .j rfl .i trivial with
  | ⟨w, h, _⟩ => by cases w <;> exact False.elim h

/-- **It does not hold the member's effects.** -/
theorem not_held : ¬ «所缘同于» step own .m := fun held => Bool.noConfusion (held .u trivial)

/-- **Every step of its line that goes on has an effect outside it.** -/
theorem wake_follows {c : Occ} (onLine : «所及» step own .m c) (goes : ∃ w, step c w) :
    ∃ x, step c x ∧ own .u x ∧ ¬ own c x :=
  «出类随线» own_class constant_to_end onLine trivial (fun e => Bool.noConfusion e) goes

end FiniteWake

end Becoming
