import Becoming.Fragments
import Becoming.Joining

/-!
# Local units: where a joining recovers the ends of what it joins

A joining (`Becoming.Joining`) may leave some fragment unchanged whatever it joins with
(`Joining.TwoSidedUnit`); such a fragment is a unit of what it joins with unchanged (`LeftUnit`,
`RightUnit`). Units are read off the joining alone, with no ends supplied.

* Where joining is associative, each fragment has at most one unit on each side
  (`LeftUnit.unique`, `RightUnit.unique`), so any two assignments of units agree
  (`units_agree`).
* Fragments that join share a unit: the right unit of the first is the left unit of the second
  (`commonUnit_of_composable`). Where joining is also functional, a unit of a fragment is a unit
  of what it joins into (`LeftUnit.of_joined`, `RightUnit.of_joined`).
* That a common unit suffices for joining is exactly that every two pairs joining in a chain
  extend to the chain (`chainComplete_iff_commonUnit_suffices`); it is a law of its own: the
  joining in which `true` joins with `false` alone (`atMostOnce`) is functional, associative and
  has units, and two `true`s share a unit and do not join (`atMostOnce_not_chainComplete`).
* A one-to-one correspondence carrying a joining carries its neutral fragments and units
  (`twoSidedUnit_transport`, `leftUnit_transport`, `rightUnit_transport`).

On the traced fragments of a process (`Fragment.Traces`, `Fragment.joining`) all four laws hold
with no hypothesis: joining is functional, associative and chain-complete, and the neutral
fragments are exactly those staying at a configuration (`Fragment.twoSidedUnit_iff_idle`), the left
unit of a fragment the one staying at its start and the right unit the one staying at its finish
(`Fragment.leftUnit_iff`, `Fragment.rightUnit_iff`). The ends of a fragment are recovered from
the joining alone. Read through whether a fragment takes its step, the traced fragments of the
process that moves once join as `atMostOnce` (`Fragment.steps_reads`): the description keeps
functionality, associativity and units and loses chain completion.

Every declaration's axiom report is empty. Ported from `Generative.ExplanatoryLocalUnits` and the
join `Becoming.UnitTraces` (bridge fold F3E, 18 October 2026); the port is a restatement on the
core's joinings, not a new result. The periphery's `budgetJoin` is `atMostOnce` here.
-/

universe u v u' v'

namespace Becoming

open Generative

namespace Joining

variable {F : Type u} {G : Type v}

/-- Two fragments join into something. -/
def Composable (J : Joining F) (a b : F) : Prop := ∃ c, J a b c

/-- Joining is associative: `a` and `b` join into what joins `c` into `d` exactly where `b` and `c`
join into what `a` joins into `d`. -/
def Associative (J : Joining F) : Prop :=
  ∀ a b c d, (∃ m, J a b m ∧ J m c d) ↔ (∃ n, J b c n ∧ J a n d)

/-- A fragment leaving what it joins with unchanged, on either side. -/
def TwoSidedUnit (J : Joining F) (e : F) : Prop :=
  (∀ a c, J e a c → c = a) ∧ (∀ a c, J a e c → c = a)

/-- A neutral fragment joining before `a` into `a`. -/
def LeftUnit (J : Joining F) (e a : F) : Prop := J.TwoSidedUnit e ∧ J e a a

/-- A neutral fragment joining after `a` into `a`. -/
def RightUnit (J : Joining F) (e a : F) : Prop := J.TwoSidedUnit e ∧ J a e a

/-- Every fragment has a unit on each side. -/
def HasUnits (J : Joining F) : Prop :=
  (∀ a, ∃ e, J.LeftUnit e a) ∧ (∀ a, ∃ e, J.RightUnit e a)

/-- A right unit of `a` that is a left unit of `b`. -/
def CommonUnit (J : Joining F) (a b : F) : Prop := ∃ e, J.RightUnit e a ∧ J.LeftUnit e b

/-- Two pairs joining in a chain extend to the chain. -/
def ChainComplete (J : Joining F) : Prop :=
  ∀ a b c, J.Composable a b → J.Composable b c → ∃ m d, J a b m ∧ J m c d

/-- **Under associativity, a fragment has at most one left unit.** -/
theorem LeftUnit.unique {J : Joining F} (assoc : J.Associative) {e f a : F} (unit : J.LeftUnit e a)
    (unit' : J.LeftUnit f a) : e = f :=
  match (assoc e f a a).mpr ⟨a, unit'.2, unit.2⟩ with
  | ⟨_, joined, _⟩ => (unit'.1.2 _ _ joined).symm.trans (unit.1.1 _ _ joined)

/-- **Under associativity, a fragment has at most one right unit.** -/
theorem RightUnit.unique {J : Joining F} (assoc : J.Associative) {e f a : F}
    (unit : J.RightUnit e a) (unit' : J.RightUnit f a) : e = f :=
  match (assoc a e f a).mp ⟨a, unit.2, unit'.2⟩ with
  | ⟨_, joined, _⟩ => (unit'.1.2 _ _ joined).symm.trans (unit.1.1 _ _ joined)

/-- Where every fragment has units, a neutral fragment joins itself into itself. -/
theorem TwoSidedUnit.self {J : Joining F} (units : J.HasUnits) {e : F} (neutral : J.TwoSidedUnit e) :
    J e e e :=
  match units.1 e with
  | ⟨f, _, joined⟩ => Eq.subst (motive := fun x => J x e e) (neutral.2 f e joined).symm joined

/-- **Under associativity and units, each fragment has exactly one unit on each side.** -/
theorem units_unique {J : Joining F} (assoc : J.Associative) (units : J.HasUnits) (a : F) :
    (∃ e, J.LeftUnit e a ∧ ∀ f, J.LeftUnit f a → f = e) ∧
      (∃ e, J.RightUnit e a ∧ ∀ f, J.RightUnit f a → f = e) :=
  match units.1 a, units.2 a with
  | ⟨e, unit⟩, ⟨f, unit'⟩ =>
    ⟨⟨e, unit, fun _ other => LeftUnit.unique assoc other unit⟩,
     ⟨f, unit', fun _ other => RightUnit.unique assoc other unit'⟩⟩

/-- **Fragments that join share a unit**, under associativity and units. -/
theorem commonUnit_of_joined {J : Joining F} (assoc : J.Associative) (units : J.HasUnits)
    {a b c : F} (joined : J a b c) : J.CommonUnit a b :=
  match units.2 a with
  | ⟨e, unit⟩ => match (assoc a e b c).mp ⟨a, unit.2, joined⟩ with
    | ⟨m, joined', _⟩ =>
      ⟨e, unit, unit.1, Eq.subst (motive := fun x => J e b x) (unit.1.1 b m joined') joined'⟩

/-- **Composable fragments share a unit**, under associativity and units. -/
theorem commonUnit_of_composable {J : Joining F} (assoc : J.Associative) (units : J.HasUnits)
    {a b : F} : J.Composable a b → J.CommonUnit a b
  | ⟨_, joined⟩ => commonUnit_of_joined assoc units joined

/-- **A left unit of a fragment is a left unit of what it joins into**, under associativity and
functionality. -/
theorem LeftUnit.of_joined {J : Joining F} (assoc : J.Associative) (fn : J.Functional)
    {a b c e : F} (joined : J a b c) (unit : J.LeftUnit e a) : J.LeftUnit e c :=
  match (assoc e a b c).mp ⟨a, unit.2, joined⟩ with
  | ⟨n, joined', joinedE⟩ =>
    ⟨unit.1, Eq.subst (motive := fun x => J e x c) (fn a b n c joined' joined) joinedE⟩

/-- **A right unit of a fragment is a right unit of what it is joined into**, under associativity
and functionality. -/
theorem RightUnit.of_joined {J : Joining F} (assoc : J.Associative) (fn : J.Functional)
    {a b c e : F} (joined : J a b c) (unit : J.RightUnit e b) : J.RightUnit e c :=
  match (assoc a b e c).mpr ⟨b, unit.2, joined⟩ with
  | ⟨n, joined', joinedE⟩ =>
    ⟨unit.1, Eq.subst (motive := fun x => J x e c) (fn a b n c joined' joined) joinedE⟩

/-- **Where pairs joining in a chain extend to the chain, a common unit suffices for joining.** -/
theorem ChainComplete.composable {J : Joining F} (complete : J.ChainComplete) {a b : F} :
    J.CommonUnit a b → J.Composable a b
  | ⟨e, unit, unit'⟩ => match complete a e b ⟨a, unit.2⟩ ⟨b, unit'.2⟩ with
    | ⟨m, d, first, second⟩ =>
      ⟨d, Eq.subst (motive := fun x => J x b d) (unit.1.2 a m first) second⟩

/-- **Under associativity, units and chain completion, fragments join exactly where they share a
unit.** -/
theorem composable_iff_commonUnit {J : Joining F} (assoc : J.Associative) (units : J.HasUnits)
    (complete : J.ChainComplete) (a b : F) : J.Composable a b ↔ J.CommonUnit a b :=
  ⟨commonUnit_of_composable assoc units, complete.composable⟩

/-- **Chain completion is exactly that a common unit suffices for joining**, under associativity,
functionality and units. -/
theorem chainComplete_iff_commonUnit_suffices {J : Joining F} (assoc : J.Associative)
    (fn : J.Functional) (units : J.HasUnits) :
    J.ChainComplete ↔ ∀ a b, J.CommonUnit a b → J.Composable a b :=
  ⟨fun complete _ _ => complete.composable,
   fun enough _ _ c ⟨m, first⟩ second =>
    match commonUnit_of_composable assoc units second with
    | ⟨e, unit, unit'⟩ => match enough m c ⟨e, RightUnit.of_joined assoc fn first unit, unit'⟩ with
      | ⟨d, joined⟩ => ⟨m, d, first, joined⟩⟩

/-- **Any two assignments of units agree**, under associativity. -/
theorem units_agree {J : Joining F} (assoc : J.Associative) (left right left' right' : F → F)
    (unitsL : ∀ a, J.LeftUnit (left a) a) (unitsR : ∀ a, J.RightUnit (right a) a)
    (unitsL' : ∀ a, J.LeftUnit (left' a) a) (unitsR' : ∀ a, J.RightUnit (right' a) a) :
    ∀ a, left a = left' a ∧ right a = right' a :=
  fun a => ⟨LeftUnit.unique assoc (unitsL a) (unitsL' a), RightUnit.unique assoc (unitsR a) (unitsR' a)⟩

/-- **A one-to-one correspondence carrying a joining carries its neutral fragments.** -/
theorem twoSidedUnit_transport {J : Joining F} {K : Joining G} {f : F → G}
    (one : ∀ a b, f a = f b → a = b) (onto : ∀ b, ∃ a, f a = b)
    (carries : ∀ a b c, J a b c ↔ K (f a) (f b) (f c)) (e : F) : J.TwoSidedUnit e ↔ K.TwoSidedUnit (f e) :=
  ⟨fun neutral =>
    ⟨fun a c joined => match onto a, onto c with
      | ⟨x, atX⟩, ⟨y, atY⟩ =>
        atY.symm.trans ((congrArg f (neutral.1 x y ((carries e x y).mpr
          (Eq.subst (motive := fun w => K (f e) (f x) w) atY.symm
            (Eq.subst (motive := fun w => K (f e) w c) atX.symm joined))))).trans atX),
     fun a c joined => match onto a, onto c with
      | ⟨x, atX⟩, ⟨y, atY⟩ =>
        atY.symm.trans ((congrArg f (neutral.2 x y ((carries x e y).mpr
          (Eq.subst (motive := fun w => K (f x) (f e) w) atY.symm
            (Eq.subst (motive := fun w => K w (f e) c) atX.symm joined))))).trans atX)⟩,
   fun neutral =>
    ⟨fun a c joined => one c a (neutral.1 _ _ ((carries e a c).mp joined)),
     fun a c joined => one c a (neutral.2 _ _ ((carries a e c).mp joined))⟩⟩

/-- **A one-to-one correspondence carrying a joining carries left units.** -/
theorem leftUnit_transport {J : Joining F} {K : Joining G} {f : F → G}
    (one : ∀ a b, f a = f b → a = b) (onto : ∀ b, ∃ a, f a = b)
    (carries : ∀ a b c, J a b c ↔ K (f a) (f b) (f c)) (e a : F) :
    J.LeftUnit e a ↔ K.LeftUnit (f e) (f a) :=
  ⟨fun unit => ⟨(twoSidedUnit_transport one onto carries e).mp unit.1, (carries e a a).mp unit.2⟩,
   fun unit => ⟨(twoSidedUnit_transport one onto carries e).mpr unit.1, (carries e a a).mpr unit.2⟩⟩

/-- **A one-to-one correspondence carrying a joining carries right units.** -/
theorem rightUnit_transport {J : Joining F} {K : Joining G} {f : F → G}
    (one : ∀ a b, f a = f b → a = b) (onto : ∀ b, ∃ a, f a = b)
    (carries : ∀ a b c, J a b c ↔ K (f a) (f b) (f c)) (e a : F) :
    J.RightUnit e a ↔ K.RightUnit (f e) (f a) :=
  ⟨fun unit => ⟨(twoSidedUnit_transport one onto carries e).mp unit.1, (carries a e a).mp unit.2⟩,
   fun unit => ⟨(twoSidedUnit_transport one onto carries e).mpr unit.1, (carries a e a).mpr unit.2⟩⟩

/-- Neutrality passes between joinings holding at the same triples. -/
theorem TwoSidedUnit.of_iff {J K : Joining F} (same : ∀ a b c, J a b c ↔ K a b c) {e : F}
    (neutral : K.TwoSidedUnit e) : J.TwoSidedUnit e :=
  ⟨fun a c joined => neutral.1 a c ((same e a c).mp joined),
   fun a c joined => neutral.2 a c ((same a e c).mp joined)⟩

/-! ## At most once -/

/-- `true` joins with `false` alone, into `true`; `false` joins with itself into `false`. -/
def atMostOnce : Joining Bool := fun a b c => (a = false ∨ b = false) ∧ c = (a || b)

theorem atMostOnce_functional : atMostOnce.Functional :=
  fun _ _ _ _ first second => first.2.trans second.2.symm

theorem atMostOnce_assoc : atMostOnce.Associative
  | false, b, c, d => ⟨fun ⟨m, first, second⟩ =>
      ⟨d, Eq.subst (motive := fun x => atMostOnce x c d) (show m = b from first.2) second, ⟨.inl rfl, rfl⟩⟩,
    fun ⟨n, first, second⟩ =>
      ⟨b, ⟨.inl rfl, rfl⟩, Eq.subst (motive := fun x => atMostOnce b c x) (show n = d from second.2.symm) first⟩⟩
  | true, false, false, _ => ⟨fun ⟨_, first, second⟩ =>
      ⟨false, ⟨.inl rfl, rfl⟩,
        Eq.subst (motive := fun x => atMostOnce true false x)
          (second.2.trans (congrArg (fun x => x || false) first.2)).symm ⟨.inr rfl, rfl⟩⟩,
    fun ⟨_, first, second⟩ =>
      ⟨true, ⟨.inr rfl, rfl⟩,
        Eq.subst (motive := fun x => atMostOnce true false x)
          (second.2.trans (congrArg (fun x => true || x) first.2)).symm ⟨.inr rfl, rfl⟩⟩⟩
  | true, false, true, d => ⟨fun ⟨_, first, second⟩ =>
      absurd (Eq.subst (motive := fun x => atMostOnce x true d) first.2 second)
        fun ⟨either, _⟩ => match either with
          | .inl no => Bool.noConfusion no
          | .inr no => Bool.noConfusion no,
    fun ⟨_, first, second⟩ =>
      absurd (Eq.subst (motive := fun x => atMostOnce true x d) first.2 second)
        fun ⟨either, _⟩ => match either with
          | .inl no => Bool.noConfusion no
          | .inr no => Bool.noConfusion no⟩
  | true, true, _, _ => ⟨fun ⟨_, ⟨either, _⟩, _⟩ => match either with
      | .inl no => Bool.noConfusion no
      | .inr no => Bool.noConfusion no,
    fun ⟨_, first, second⟩ =>
      absurd (Eq.subst (motive := fun x => atMostOnce true x _) first.2 second)
        fun ⟨either, _⟩ => match either with
          | .inl no => Bool.noConfusion no
          | .inr no => Bool.noConfusion no⟩

/-- `false` is neutral for `atMostOnce`. -/
theorem atMostOnce_twoSidedUnit : atMostOnce.TwoSidedUnit false :=
  ⟨fun _ _ joined => joined.2, fun a _ joined => joined.2.trans (match a with
    | false => rfl
    | true => rfl)⟩

theorem atMostOnce_has_units : atMostOnce.HasUnits :=
  ⟨fun _ => ⟨false, atMostOnce_twoSidedUnit, ⟨.inl rfl, rfl⟩⟩,
   fun a => ⟨false, atMostOnce_twoSidedUnit, ⟨.inr rfl, match a with
    | false => rfl
    | true => rfl⟩⟩⟩

/-- **Two `true`s share a unit and do not join.** -/
theorem atMostOnce_commonUnit_not_composable :
    atMostOnce.CommonUnit true true ∧ ¬ atMostOnce.Composable true true :=
  ⟨⟨false, ⟨atMostOnce_twoSidedUnit, ⟨.inr rfl, rfl⟩⟩, ⟨atMostOnce_twoSidedUnit, ⟨.inl rfl, rfl⟩⟩⟩,
   fun ⟨_, either, _⟩ => match either with
    | .inl no => Bool.noConfusion no
    | .inr no => Bool.noConfusion no⟩

/-- **`atMostOnce` is not chain-complete**: functional, associative and with units, it shares a
unit between two `true`s that do not join. -/
theorem atMostOnce_not_chainComplete : ¬ atMostOnce.ChainComplete :=
  fun complete => atMostOnce_commonUnit_not_composable.2
    (complete.composable atMostOnce_commonUnit_not_composable.1)

end Joining

namespace Fragment

variable {S : Type u} {A : Type v}

/-- The traced fragments of a process. -/
abbrev Traces (P : Process S A) := { f : Fragment S A // Traced P f }

/-- The joining of the traced fragments of a process. -/
def joining (P : Process S A) : Joining (Traces P) := fun f g h => Joined P f.val g.val h.val

/-- The traced fragment staying at a configuration. -/
def idleTrace (P : Process S A) (s : S) : Traces P := ⟨idle s, idle_traced P s⟩

/-- Traced fragments are equal where the fragments are. -/
theorem Traces.ext {P : Process S A} : ∀ {f g : Traces P}, f.val = g.val → f = g
  | ⟨_, _⟩, ⟨_, _⟩, rfl => rfl

/-- **Joining traced fragments is functional.** -/
theorem joining_functional (P : Process S A) : (joining P).Functional :=
  fun _ _ _ _ first second => Traces.ext (joined_functional first second)

/-- **Joining traced fragments is associative.** -/
theorem joining_assoc (P : Process S A) : (joining P).Associative := fun a b c d =>
  ⟨fun ⟨m, first, second⟩ => match (joined_assoc P a.val b.val c.val d.val).mp ⟨m.val, first, second⟩ with
    | ⟨n, first', second'⟩ => ⟨⟨n, joined_traced first'⟩, first', second'⟩,
   fun ⟨n, first, second⟩ => match (joined_assoc P a.val b.val c.val d.val).mpr ⟨n.val, first, second⟩ with
    | ⟨m, first', second'⟩ => ⟨⟨m, joined_traced first'⟩, first', second'⟩⟩

/-- **The fragment staying at a configuration is neutral.** -/
theorem idle_twoSidedUnit (P : Process S A) (s : S) : (joining P).TwoSidedUnit (idleTrace P s) :=
  ⟨fun a _ joined => Traces.ext (joined.2.symm.trans
      (Eq.subst (motive := fun x => merge (idle x) a.val = a.val) joined.1.2.2.symm
        (joined_idle_left a.property).2)),
   fun a _ joined => Traces.ext (joined.2.symm.trans
      (Eq.subst (motive := fun x => merge a.val (idle x) = a.val) joined.1.2.2
        (joined_idle_right a.property).2))⟩

/-- **Every traced fragment has units**: the fragments staying at its start and at its finish. -/
theorem has_units (P : Process S A) : (joining P).HasUnits :=
  ⟨fun a => ⟨idleTrace P a.val.start, idle_twoSidedUnit P _, joined_idle_left a.property⟩,
   fun a => ⟨idleTrace P a.val.finish, idle_twoSidedUnit P _, joined_idle_right a.property⟩⟩

/-- **Joining traced fragments is chain-complete.** -/
theorem chainComplete (P : Process S A) : (joining P).ChainComplete :=
  fun _ _ c ⟨m, first⟩ ⟨_, second⟩ =>
    have joint : Joint P m.val c.val :=
      Eq.subst (motive := fun x => Joint P x c.val) first.2 (joint_chain_left first.1 second.1)
    ⟨m, ⟨merge m.val c.val, merge_traced joint⟩, first, joint, rfl⟩

/-- **The left unit of a traced fragment is the fragment staying at its start.** -/
theorem leftUnit_iff (P : Process S A) (e a : Traces P) :
    (joining P).LeftUnit e a ↔ e = idleTrace P a.val.start :=
  have unit : (joining P).LeftUnit (idleTrace P a.val.start) a :=
    ⟨idle_twoSidedUnit P _, joined_idle_left a.property⟩
  ⟨fun unit' => Joining.LeftUnit.unique (joining_assoc P) unit' unit,
   fun same => Eq.subst (motive := fun x => (joining P).LeftUnit x a) same.symm unit⟩

/-- **The right unit of a traced fragment is the fragment staying at its finish.** -/
theorem rightUnit_iff (P : Process S A) (e a : Traces P) :
    (joining P).RightUnit e a ↔ e = idleTrace P a.val.finish :=
  have unit : (joining P).RightUnit (idleTrace P a.val.finish) a :=
    ⟨idle_twoSidedUnit P _, joined_idle_right a.property⟩
  ⟨fun unit' => Joining.RightUnit.unique (joining_assoc P) unit' unit,
   fun same => Eq.subst (motive := fun x => (joining P).RightUnit x a) same.symm unit⟩

/-- **Traced fragments join exactly where they share a unit.** -/
theorem composable_iff_commonUnit (P : Process S A) (a b : Traces P) :
    (joining P).Composable a b ↔ (joining P).CommonUnit a b :=
  Joining.composable_iff_commonUnit (joining_assoc P) (has_units P) (chainComplete P) a b

/-- **The neutral traced fragments are exactly those staying at a configuration**: the
configurations are recovered from the joining alone. -/
theorem twoSidedUnit_iff_idle (P : Process S A) (e : Traces P) :
    (joining P).TwoSidedUnit e ↔ ∃ s, e = idleTrace P s :=
  ⟨fun neutral => ⟨e.val.start, (leftUnit_iff P e e).mp ⟨neutral, neutral.self (has_units P)⟩⟩,
   fun ⟨s, same⟩ => Eq.subst (motive := (joining P).TwoSidedUnit) same.symm (idle_twoSidedUnit P s)⟩

theorem idleTrace_injective (P : Process S A) (s t : S) (same : idleTrace P s = idleTrace P t) :
    s = t :=
  congrArg (fun f : Traces P => f.val.start) same

/-- **A neutral traced fragment stays at exactly one configuration.** -/
theorem twoSidedUnit_stays_once (P : Process S A) (e : Traces P) (neutral : (joining P).TwoSidedUnit e) :
    ∃ s, e = idleTrace P s ∧ ∀ t, e = idleTrace P t → t = s :=
  match (twoSidedUnit_iff_idle P e).mp neutral with
  | ⟨s, same⟩ => ⟨s, same, fun t same' => idleTrace_injective P t s (same'.symm.trans same)⟩

/-- **Each traced fragment has exactly one unit on each side.** -/
theorem units_unique (P : Process S A) (a : Traces P) :
    (∃ e, (joining P).LeftUnit e a ∧ ∀ f, (joining P).LeftUnit f a → f = e) ∧
      (∃ e, (joining P).RightUnit e a ∧ ∀ f, (joining P).RightUnit f a → f = e) :=
  Joining.units_unique (joining_assoc P) (has_units P) a

/-- **A left unit of a traced fragment is a left unit of what it joins into.** -/
theorem LeftUnit.of_joined {P : Process S A} {a b c e : Traces P} (joined : joining P a b c)
    (unit : (joining P).LeftUnit e a) : (joining P).LeftUnit e c :=
  Joining.LeftUnit.of_joined (joining_assoc P) (joining_functional P) joined unit

/-- **A right unit of a traced fragment is a right unit of what it is joined into.** -/
theorem RightUnit.of_joined {P : Process S A} {a b c e : Traces P} (joined : joining P a b c)
    (unit : (joining P).RightUnit e b) : (joining P).RightUnit e c :=
  Joining.RightUnit.of_joined (joining_assoc P) (joining_functional P) joined unit

/-! ## Read through whether a fragment takes the step -/

/-- Whether a course of moves takes a step. -/
def stepsWord : List Unit → Bool
  | [] => false
  | _ :: _ => true

/-- Whether a traced fragment of the process that moves once takes its step. -/
def steps (f : Traces once) : Bool := stepsWord f.val.word

/-- A trace of the process that moves once stays, or is the one step. -/
theorem once_trace_cases : ∀ {s t : Bool} {w : List Unit}, Trace once s w t →
    (w = [] ∧ s = t) ∨ (w = [()] ∧ s = false ∧ t = true)
  | _, _, _, .nil _ => .inl ⟨rfl, rfl⟩
  | _, _, _, .cons step (.nil _) => .inr ⟨rfl, step.1, step.2⟩
  | _, _, _, .cons step (.cons step' _) => Bool.noConfusion (step.2.symm.trans step'.1)

/-- The traced fragments of the process that moves once, read through whether they take the step. -/
def stepsImage : Joining Bool := (joining once).image steps

theorem steps_reads_mp {a b c : Bool} : stepsImage a b c → Joining.atMostOnce a b c :=
  fun ⟨x, y, z, atX, atY, atZ, joined⟩ =>
    have word : z.val.word = x.val.word ++ y.val.word := (congrArg Fragment.word joined.2).symm
    match once_trace_cases x.property, once_trace_cases y.property with
    | .inl ⟨stays, _⟩, _ =>
      have first : false = a := (congrArg stepsWord stays).symm.trans atX
      have last : b = c :=
        atY.symm.trans ((congrArg (fun w => stepsWord (w ++ y.val.word)) stays).symm.trans
          ((congrArg stepsWord word).symm.trans atZ))
      Eq.subst (motive := fun x => Joining.atMostOnce x b c) first
        (Eq.subst (motive := fun x => Joining.atMostOnce false b x) last ⟨.inl rfl, rfl⟩)
    | .inr ⟨_, _, _⟩, .inl ⟨stays, _⟩ =>
      have second : false = b := (congrArg stepsWord stays).symm.trans atY
      have last : a = c :=
        atX.symm.trans ((congrArg stepsWord (ListTests.append_nil x.val.word)).symm.trans
          ((congrArg (fun w => stepsWord (x.val.word ++ w)) stays).symm.trans
            ((congrArg stepsWord word).symm.trans atZ)))
      Eq.subst (motive := fun x => Joining.atMostOnce a x c) second
        (Eq.subst (motive := fun x => Joining.atMostOnce a false x) last
          ⟨.inr rfl, match a with
            | false => rfl
            | true => rfl⟩)
    | .inr ⟨_, _, finishes⟩, .inr ⟨_, starts, _⟩ =>
      Bool.noConfusion (finishes.symm.trans (joined.1.2.2.trans starts))

theorem steps_reads_mpr : ∀ {a b c : Bool}, Joining.atMostOnce a b c → stepsImage a b c
  | false, false, _, ⟨_, at_⟩ =>
    Eq.subst (motive := fun x => stepsImage false false x) at_.symm
      ⟨idleTrace once false, idleTrace once false, idleTrace once false, rfl, rfl, rfl,
        ⟨idle_traced _ _, idle_traced _ _, rfl⟩, rfl⟩
  | false, true, _, ⟨_, at_⟩ =>
    Eq.subst (motive := fun x => stepsImage false true x) at_.symm
      ⟨idleTrace once false, ⟨passage, passage_traced⟩, ⟨passage, passage_traced⟩, rfl, rfl, rfl,
        ⟨idle_traced _ _, passage_traced, rfl⟩, rfl⟩
  | true, false, _, ⟨_, at_⟩ =>
    Eq.subst (motive := fun x => stepsImage true false x) at_.symm
      ⟨⟨passage, passage_traced⟩, idleTrace once true, ⟨passage, passage_traced⟩, rfl, rfl, rfl,
        ⟨passage_traced, idle_traced _ _, rfl⟩, rfl⟩
  | true, true, _, ⟨.inl no, _⟩ => Bool.noConfusion no
  | true, true, _, ⟨.inr no, _⟩ => Bool.noConfusion no

/-- **Read through whether a fragment takes the step, the traced fragments of the process that
moves once join as `atMostOnce`.** -/
theorem steps_reads (a b c : Bool) : stepsImage a b c ↔ Joining.atMostOnce a b c :=
  ⟨steps_reads_mp, steps_reads_mpr⟩

theorem stepsImage_functional : stepsImage.Functional := fun a b c d first second =>
  Joining.atMostOnce_functional a b c d ((steps_reads a b c).mp first) ((steps_reads a b d).mp second)

theorem stepsImage_assoc : stepsImage.Associative := fun a b c d =>
  ⟨fun ⟨m, first, second⟩ =>
    match (Joining.atMostOnce_assoc a b c d).mp
        ⟨m, (steps_reads a b m).mp first, (steps_reads m c d).mp second⟩ with
    | ⟨n, first', second'⟩ => ⟨n, (steps_reads b c n).mpr first', (steps_reads a n d).mpr second'⟩,
   fun ⟨n, first, second⟩ =>
    match (Joining.atMostOnce_assoc a b c d).mpr
        ⟨n, (steps_reads b c n).mp first, (steps_reads a n d).mp second⟩ with
    | ⟨m, first', second'⟩ => ⟨m, (steps_reads a b m).mpr first', (steps_reads m c d).mpr second'⟩⟩

theorem stepsImage_has_units : stepsImage.HasUnits :=
  ⟨fun a => match Joining.atMostOnce_has_units.1 a with
    | ⟨e, neutral, joined⟩ =>
      ⟨e, Joining.TwoSidedUnit.of_iff steps_reads neutral, (steps_reads e a a).mpr joined⟩,
   fun a => match Joining.atMostOnce_has_units.2 a with
    | ⟨e, neutral, joined⟩ =>
      ⟨e, Joining.TwoSidedUnit.of_iff steps_reads neutral, (steps_reads a e a).mpr joined⟩⟩

/-- **Read through whether a fragment takes the step, the joining is not chain-complete**, though
the traced fragments themselves are (`chainComplete`): the description loses the chain of two
steps. -/
theorem stepsImage_not_chainComplete : ¬ stepsImage.ChainComplete := fun complete =>
  Joining.atMostOnce_not_chainComplete fun a b c ⟨m, first⟩ ⟨n, second⟩ =>
    match complete a b c ⟨m, (steps_reads a b m).mpr first⟩ ⟨n, (steps_reads b c n).mpr second⟩ with
    | ⟨m', d, first', second'⟩ => ⟨m', d, (steps_reads a b m').mp first', (steps_reads m' c d).mp second'⟩

end Fragment

end Becoming
