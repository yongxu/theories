import Becoming.Grammar
import Becoming.GrammarMap

/-!
# What a line under a class must hold, and what a regularity takes in (所经必同, 常闭则后皆续)

Chapter 7 §4.6 joins two routes into one path to the future: a line goes on past a member's end
under a coarser class, and, through the conditions it runs through, reaches what those conditions
later feed. Two of its steps were shown only in witnesses (`Becoming.GrammarCases`). This module
states them for every carrier, relation and class.

* **What a line must pass, its class must hold (所经必同).** Where a region (a decided predicate `P`)
  is left only into a set `C` (every step from inside `P` to outside lands in `C`), a line under a
  class from inside the region to outside holds a member of `C` alike to its start, and reaches it
  (`«所经必同»`). So where no member of `C` is alike to the start, nothing outside the region is
  reached under that class (`«所经不同则不及»`). Read with a family as the region and its conditions as
  `C`: a class under which a line runs through its conditions must hold them.
  `SharedCondition.affecting_member_outside` is its case.
* **A regularity that holds its member's effects takes in all that follows (常闭则后皆续).** Under a
  constant class (`«有常»`), call a member *closed* where everything it conditions is alike to it
  (`«闭于»`). Then whatever is alike to a closed member conditions only what is alike to it
  (`«常闭则所缘同类»`), so everything downstream of anything alike to it is alike to it and on a line
  under the class from there (`«常闭则后皆续»`), and anything a line from a center reaches that is
  alike to the member carries the line on to all that follows it (`«常闭则所及皆及»`). Under constancy
  the closure is exactly this: a member is closed exactly where everything downstream of it is alike
  to it (`«常类之闭当且仅当后皆同类»`). Read with a member and a condition it affects: a regularity
  holding all of a member's effects takes in whatever its conditions later feed.
* **Up to the net's end.** Constancy forbids a line to end at all (`«有常则续不尽»`), so in a finite
  world, where every line ends, no class with a continuation step is constant (`FiniteDescent`: not
  even the one). The laws above hold under a weaker condition: *constancy up to the net's end*
  (`«至终有常»`), where a line under the class ends only where the net itself ends there, not while
  what it is alike to goes on. Constancy gives it (`«有常则至终有常»`), and under it, for a closed member
  that conditions something, the same laws hold (`«至终常闭则后皆续»`, `«至终常闭则所及皆及»`,
  `«至终常类之闭当且仅当后皆同类»`); the constant forms are their corollaries. In the finite descent
  the class of descent is constant up to the net's end and takes in all that follows the first
  member's birth, while the organism's class is not, its line ending at old age while the net goes on
  (`FiniteDescent.descent_constant_to_end`, `FiniteDescent.member_not_constant_to_end`,
  `FiniteDescent.descent_takes_in_all`).
* **Neither premise can be dropped.** A constant class holding a condition with a member need not take
  in what the condition feeds where the member's effects leave its class (`Unclosed`); and a member
  closed under a class that is not constant need not have what follows its effects alike to it
  (`Inconstant`). `ThirdFed.constant_takes_third` in `Becoming.GrammarCases` is the pointwise form of
  constancy itself (`«有常之逐点»`), which needs neither premise.

Every declaration has an empty axiom report. The decided predicate in `«所经必同»` is what lets the
proof ask, of each occurrence on the line, whether it is still inside the region; no classical
principle is used.
-/

namespace Becoming

universe u

section Path

variable {α : Type u}

/-- **What a line must pass, its class must hold (所经必同).** Where every step from inside a region
`P` to outside it lands in `C`, a line under a class `E` from inside to outside holds a member of `C`
alike to its start, and reaches it. -/
theorem «所经必同» {R E : «际» α} (hE : «类» E) {P : α → Bool} {C : α → Prop}
    (exits : ∀ u v, P u = true → R u v → P v = false → C v) {x y : α}
    (inside : P x = true) (outside : P y = false) (reached : «所及» R E x y) :
    ∃ c, C c ∧ E x c ∧ «所及» R E x c := by
  have key : ∀ u w, «相续» R E u w → P u = true → P w = false → ∃ c, C c ∧ «所及» R E u c := by
    intro u w line
    induction line with
    | one c =>
      intro pu pw
      exact ⟨_, exits _ _ pu c.1 pw, .inr (.one c)⟩
    | @more a b _ c _ ih =>
      intro pa pw
      cases pb : P b with
      | false => exact ⟨b, exits a b pa c.1 pb, .inr (.one c)⟩
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
    (exits : ∀ u v, P u = true → R u v → P v = false → C v) {x y : α}
    (inside : P x = true) (outside : P y = false) (apart : ∀ c, C c → ¬ E x c) :
    ¬ «所及» R E x y := fun reached =>
  match «所经必同» hE exits inside outside reached with
  | ⟨c, hc, alike, _⟩ => apart c hc alike

/-- A member is *closed* under a class where everything it conditions is alike to it (闭于). -/
def «闭于» (R E : «际» α) (m : α) : Prop := ∀ v, R m v → E m v

/-- **Constancy up to the net's end (至终有常).** Whatever an alike occurrence conditions, this one
conditions something alike, unless this one conditions nothing at all. A line under such a class ends
only where the net itself ends there, not while what it is alike to goes on. -/
def «至终有常» (R E : «际» α) : Prop :=
  ∀ u u', E u u' → ∀ v, R u v → (∃ v', R u' v' ∧ E v v') ∨ ∀ w, ¬ R u' w

/-- Constancy is constancy up to the net's end. -/
theorem «有常则至终有常» {R E : «际» α} (constant : «有常» R E) : «至终有常» R E :=
  fun u u' e v r => .inl ((«有常之逐点» R E).mp constant u u' e v r)

/-- **Up to the net's end, whatever is alike to a closed member that conditions something conditions
only what is alike to it.** -/
theorem «至终常闭则所缘同类» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) {m : α}
    (goes : ∃ w, R m w) (closed : «闭于» R E m) {u v : α} (alike : E u m) (step : R u v) : E v m :=
  match constant u m alike v step with
  | .inl ⟨v', hv', ev⟩ => hE.trans ev (hE.symm (closed v' hv'))
  | .inr stops => match goes with
    | ⟨w, hw⟩ => absurd hw (stops w)

/-- **A regularity that holds its member's effects takes in all that follows (常闭则后皆续), up to the
net's end.** Under a class constant up to the net's end, everything downstream of anything alike to a
closed member that conditions something is alike to it and lies on a line under the class from
there. -/
theorem «至终常闭则后皆续» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) {m : α}
    (goes : ∃ w, R m w) (closed : «闭于» R E m) {c t : α} (alike : E c m) (down : «及» R c t) :
    E t m ∧ «相续» R E c t := by
  induction down with
  | one step =>
    have et := «至终常闭则所缘同类» hE constant goes closed alike step
    exact ⟨et, .one ⟨step, hE.trans alike (hE.symm et)⟩⟩
  | @more a b _ step _ ih =>
    have eb : E b m := «至终常闭则所缘同类» hE constant goes closed alike step
    match ih eb with
    | ⟨et, rest⟩ => exact ⟨et, .more ⟨step, hE.trans alike (hE.symm eb)⟩ rest⟩

/-- Under a constant class, a member alike to something that conditions something conditions
something itself. -/
theorem «有常则同类者有后» {R E : «际» α} (constant : «有常» R E) {c m v : α} (alike : E c m)
    (step : R c v) : ∃ w, R m w :=
  match («有常之逐点» R E).mp constant c m alike v step with
  | ⟨w, hw, _⟩ => ⟨w, hw⟩

/-- **Under a constant class, whatever is alike to a closed member conditions only what is alike to
it.** -/
theorem «常闭则所缘同类» {R E : «际» α} (hE : «类» E) (constant : «有常» R E) {m : α}
    (closed : «闭于» R E m) {u v : α} (alike : E u m) (step : R u v) : E v m :=
  «至终常闭则所缘同类» hE («有常则至终有常» constant) («有常则同类者有后» constant alike step) closed
    alike step

/-- **A regularity that holds its member's effects takes in all that follows (常闭则后皆续).** Under a
constant class, everything downstream of anything alike to a closed member is alike to it and lies on
a line under the class from there. -/
theorem «常闭则后皆续» {R E : «际» α} (hE : «类» E) (constant : «有常» R E) {m : α}
    (closed : «闭于» R E m) {c t : α} (alike : E c m) (down : «及» R c t) :
    E t m ∧ «相续» R E c t :=
  match down with
  | .one step => «至终常闭则后皆续» hE («有常则至终有常» constant)
      («有常则同类者有后» constant alike step) closed alike (.one step)
  | .more step rest => «至终常闭则后皆续» hE («有常则至终有常» constant)
      («有常则同类者有后» constant alike step) closed alike (.more step rest)

/-- **What a line reaches alike to a closed member, it carries on to all that follows**, up to the
net's end. -/
theorem «至终常闭则所及皆及» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) {m x c t : α}
    (goes : ∃ w, R m w) (closed : «闭于» R E m) (toC : «所及» R E x c) (alike : E c m)
    (down : «及» R c t) : «所及» R E x t :=
  «所及之传递» toC (.inr («至终常闭则后皆续» hE constant goes closed alike down).2)

/-- **What a line reaches alike to a closed member, it carries on to all that follows.** Under a
constant class, where a line from a center reaches an occurrence alike to a closed member, it reaches
everything downstream of that occurrence. -/
theorem «常闭则所及皆及» {R E : «际» α} (hE : «类» E) (constant : «有常» R E) {m x c t : α}
    (closed : «闭于» R E m) (toC : «所及» R E x c) (alike : E c m) (down : «及» R c t) :
    «所及» R E x t :=
  «所及之传递» toC (.inr («常闭则后皆续» hE constant closed alike down).2)

/-- **Up to the net's end the closure is exactly this: a member that conditions something is closed
exactly where everything downstream of it is alike to it.** -/
theorem «至终常类之闭当且仅当后皆同类» {R E : «际» α} (hE : «类» E) (constant : «至终有常» R E) {m : α}
    (goes : ∃ w, R m w) : «闭于» R E m ↔ ∀ t, «及» R m t → E m t :=
  ⟨fun closed _ down => hE.symm («至终常闭则后皆续» hE constant goes closed (hE.refl m) down).1,
   fun all v step => all v (.one step)⟩

/-- **Under constancy the closure is exactly this: a member is closed exactly where everything
downstream of it is alike to it.** -/
theorem «常类之闭当且仅当后皆同类» {R E : «际» α} (hE : «类» E) (constant : «有常» R E) {m : α} :
    «闭于» R E m ↔ ∀ t, «及» R m t → E m t :=
  ⟨fun closed _ down => hE.symm («常闭则后皆续» hE constant closed (hE.refl m) down).1,
   fun all v step => all v (.one step)⟩

end Path

/-! ## Neither premise can be dropped -/

namespace Unclosed

/-! A condition `c` held alike with a member `m`, `c` feeding `t` and `m` conditioning `v`, with `t`
and `v` in a second class: the class is constant and holds the condition with the member, but the
member's effect leaves its class, and what the condition feeds is not taken in. -/

inductive Occ | c | m | t | v

def step : «际» Occ
  | .c, .c => False
  | .c, .m => False
  | .c, .t => True
  | .c, .v => False
  | .m, .c => False
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

/-- The first class holds the condition and the member, the second what they condition. -/
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
  | .c, .c, .t, _, _ => exact ⟨.t, trivial, rfl⟩
  | .c, .m, .t, _, _ => exact ⟨.v, trivial, rfl⟩
  | .m, .c, .v, _, _ => exact ⟨.t, trivial, rfl⟩
  | .m, .m, .v, _, _ => exact ⟨.v, trivial, rfl⟩
  | .c, .t, _, e, _ => exact Bool.noConfusion e
  | .c, .v, _, e, _ => exact Bool.noConfusion e
  | .m, .t, _, e, _ => exact Bool.noConfusion e
  | .m, .v, _, e, _ => exact Bool.noConfusion e

/-- **A constant class holding a condition with a member, where the member's effect leaves its class,
does not take in what the condition feeds.** -/
theorem not_taken_in :
    same .c .m ∧ step .c .t ∧ ¬ «闭于» step same .m ∧ ¬ same .t .m ∧ ¬ «所及» step same .c .t :=
  ⟨rfl, trivial, fun closed => Bool.noConfusion (closed .v trivial),
   fun e => Bool.noConfusion e,
   fun reached => match reached with
     | .inl e => Occ.noConfusion e
     | .inr line => Bool.noConfusion («线内同类» same_class line)⟩

end Unclosed

namespace Inconstant

/-! A member `m` conditioning `v` alike to it, `v` conditioning `w` in a second class: the member is
closed but the class is not constant, and what follows its effect is not alike to it. -/

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

/-- **A closed member under a class that is not constant need not have what follows its effects alike
to it.** -/
theorem not_all_follow :
    «闭于» step same .m ∧ ¬ «有常» step same ∧ «及» step .m .w ∧ ¬ same .w .m :=
  ⟨fun x r => match x, r with
     | .v, _ => rfl,
   fun constant => match («有常之逐点» step same).mp constant .v .m rfl .w trivial with
     | ⟨.v, _, e⟩ => Bool.noConfusion e,
   «及».more (R := step) (x := .m) (y := .v) (z := .w) trivial («及».one (R := step) (x := .v) (y := .w) trivial),
   fun e => Bool.noConfusion e⟩

end Inconstant


namespace FiniteDescent

/-! Two members in turn, each young then old, the second's birth following the first's old age, and
nothing after the second's old age: a finite world in which every line ends. -/

/-- The first member young and old, the second member young and old. -/
inductive Occ | firstYoung | firstOld | secondYoung | secondOld

def step : «际» Occ
  | .firstYoung, .firstYoung => False
  | .firstYoung, .firstOld => True
  | .firstYoung, .secondYoung => False
  | .firstYoung, .secondOld => False
  | .firstOld, .firstYoung => False
  | .firstOld, .firstOld => False
  | .firstOld, .secondYoung => True
  | .firstOld, .secondOld => False
  | .secondYoung, .firstYoung => False
  | .secondYoung, .firstOld => False
  | .secondYoung, .secondYoung => False
  | .secondYoung, .secondOld => True
  | .secondOld, _ => False

/-- Which member an occurrence is. -/
def second : Occ → Bool
  | .firstYoung => false
  | .firstOld => false
  | .secondYoung => true
  | .secondOld => true

/-- The class of one member: the organism's. -/
def member : «际» Occ := fun x y => second x = second y

/-- **In a finite world constancy picks out nothing: not even the class of descent, the one, is
constant**, since a line ends at the second member's old age. -/
theorem descent_not_constant : ¬ «有常» step («一» : «际» Occ) := fun constant =>
  match («有常之逐点» step «一»).mp constant .secondYoung .secondOld trivial .secondOld trivial with
  | ⟨.firstYoung, h, _⟩ => h
  | ⟨.firstOld, h, _⟩ => h
  | ⟨.secondYoung, h, _⟩ => h
  | ⟨.secondOld, h, _⟩ => h

/-- **Up to the net's end the class of descent is constant**: whatever any occurrence conditions, every
other conditions something, unless it is the last. -/
theorem descent_constant_to_end : «至终有常» step («一» : «际» Occ) := by
  intro _ u' _ _ _
  match u' with
  | .firstYoung => exact .inl ⟨.firstOld, trivial, trivial⟩
  | .firstOld => exact .inl ⟨.secondYoung, trivial, trivial⟩
  | .secondYoung => exact .inl ⟨.secondOld, trivial, trivial⟩
  | .secondOld => exact .inr (fun w => match w with
      | .firstYoung => id
      | .firstOld => id
      | .secondYoung => id
      | .secondOld => id)

/-- **The organism's class is not constant even up to the net's end**: the first member's line ends at
its old age while the net goes on to the second member's birth. -/
theorem member_not_constant_to_end : ¬ «至终有常» step member := fun constant =>
  match constant .firstOld .firstYoung rfl .secondYoung trivial with
  | .inl ⟨.firstOld, _, e⟩ => Bool.noConfusion e
  | .inl ⟨.firstYoung, h, _⟩ => h
  | .inl ⟨.secondYoung, h, _⟩ => h
  | .inl ⟨.secondOld, h, _⟩ => h
  | .inr stops => stops .firstOld trivial

/-- **So up to the net's end, the class of descent takes in all that follows the first member's
birth**: the first member's birth is closed under the one and conditions something, and everything
downstream of it lies on its line. -/
theorem descent_takes_in_all {t : Occ} (down : «及» step .firstYoung t) :
    «所及» step («一» : «际» Occ) .firstYoung t :=
  «至终常闭则所及皆及» (m := .firstYoung) «一为类» descent_constant_to_end
    (⟨.firstOld, trivial⟩ : ∃ w, step .firstYoung w) (fun _ _ => trivial) (.inl rfl) trivial down

end FiniteDescent

end Becoming
