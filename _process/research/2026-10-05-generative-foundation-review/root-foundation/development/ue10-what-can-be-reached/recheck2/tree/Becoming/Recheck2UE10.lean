import Becoming.ComparingCourses
import Becoming.ReachableRanges

/-!
# UE10 second re-check probes

Probes of the folded `Becoming.ReachableRanges` (sha256 `0c5db3a2…f1f3`; re-check RECHECK2-UE10.md).
Not proposed for landing as written. `Becoming.ComparingCourses` is imported only for Q6, which
compares the lagged order with UE9's.

* Q1: `Web.KeepsWidening.not_listed` follows from the chain law in one line, as the removed
  `Web.not_listed_of_chain` had it.
* Q2: the lexical half of `Reaching.not_above_wider_now` still needs each chosen course's start.
* Q3: covering is not the strict part of range inclusion: it is reflexive.
* Q4: `WiderNow.Full`'s climb does not exceed `none`'s course, while each course of
  `WiderNow.TwoSided` exceeds the other.
* Q5: on `WiderNow`'s process, wherever the climb's course exceeds `none`'s, the lagged order never
  ranks `none` above the climb, whatever the admissions.
* Q6: with fixed conditions on a determined process, the lagged order against UE9's: the first part
  is the strict part of inclusion, UE9's order lies inside it, and the converse holds where exceeding
  back is decided.
-/

namespace Becoming

namespace Recheck2UE10

open Generative

/-! ## Q1. The landed law over a listed type from the chain law -/

section Chains

variable {F C : Type} {W : Web F C} {l : Nat → C → Nat}

/-- **Q1.** Over a listed type of formations no level path keeps widening by name, from the chain
law and the chain's own pigeonhole. -/
theorem not_listed_via_chain {fs : List F} (every : ∀ f, f ∈ fs) {T : Nat} :
    ¬ W.KeepsWidening Web.itself l T :=
  fun keeps => keeps.chain.not_listed ⟨fs, fun _ f _ => every f⟩

end Chains

/-! ## Q2. The lexical order's start premises -/

namespace Three

inductive Config
  | lo
  | mid
  | hi

def process : Process Config Unit := Law.process id

def adm : Config → Nat → Prop
  | .lo, _ => False
  | .mid, x => x = 0
  | .hi, x => x ≤ 1

/-- Staying at `c`. -/
def stay (c : Config) : Run process := ⟨fun _ => c, fun _ => (), fun _ => rfl⟩

theorem hi_widens_mid_range : (stay .hi).RangeWidens adm (stay .mid) :=
  ⟨fun _ _ zero => Eq.subst (motive := fun y => y ≤ 1) (zero : _ = 0).symm (Nat.zero_le 1),
   0, 1, Nat.le_refl 1, fun one => Nat.noConfusion (one : (1 : Nat) = 0)⟩

/-- `lo`'s course read as realized runs at `hi`; the others stay. -/
def offStart : Config → Run process
  | .lo => stay .hi
  | .mid => stay .mid
  | .hi => stay .hi

/-- **Q2a.** Without `lo`'s course starting at `lo`, the lexical order ranks `lo` above `mid`,
which starts a course and admits now what `lo` does not. -/
theorem start_needed :
    adm .mid 0 ∧ ¬ adm .lo 0 ∧ (offStart .mid).state 0 = .mid ∧
      Reaching.Lexical process adm offStart .lo .mid :=
  ⟨rfl, id, rfl, .inl hi_widens_mid_range⟩

/-- `hi`'s course read as realized runs at `lo`; the others stay. -/
def offStart' : Config → Run process
  | .lo => stay .lo
  | .mid => stay .mid
  | .hi => stay .lo

/-- **Q2b.** Without `hi`'s course starting at `hi`, the lexical order ranks `mid` above `hi`,
which starts a course and admits now what `mid` does not. -/
theorem start'_needed :
    adm .hi 1 ∧ ¬ adm .mid 1 ∧ (offStart' .mid).state 0 = .mid ∧
      Reaching.Lexical process adm offStart' .mid .hi :=
  ⟨Nat.le_refl 1, fun one => Nat.noConfusion (one : (1 : Nat) = 0), rfl,
   .inl ⟨fun _ _ no => (no : False).elim, 0, 0, rfl, id⟩⟩

end Three

/-! ## Q3. Covering is reflexive, not a strict part -/

/-- **Q3.** On `WiderNow`'s determined process `none` covers itself, while the strict part of range
inclusion does not relate `none`'s course to itself. -/
theorem covering_not_strict :
    Reaching.Covers WiderNow.process WiderNow.adm none none ∧
      ¬ ((WiderNow.course none).RangeIncludes WiderNow.adm (WiderNow.course none) ∧
        ¬ (WiderNow.course none).RangeIncludes WiderNow.adm (WiderNow.course none)) :=
  ⟨Reaching.Covers.refl none, fun ⟨includes, notBack⟩ => notBack includes⟩

/-! ## Q4. Which other admissions give a pair of the witness's kind -/

/-- **Q4a.** On `WiderNow.Full` the climb's course does not exceed `none`'s. -/
theorem full_climb_not_exceeding :
    ¬ (WiderNow.course (some 0)).RangeExceeds WiderNow.Full.adm (WiderNow.course none) :=
  fun ⟨_, _, _, no⟩ => no trivial

/-- **Q4b.** On `WiderNow.TwoSided` each course exceeds the other. -/
theorem twoSided_exceeds_both :
    (WiderNow.course none).RangeExceeds WiderNow.TwoSided.adm (WiderNow.course (some 0)) ∧
      (WiderNow.course (some 0)).RangeExceeds WiderNow.TwoSided.adm (WiderNow.course none) :=
  ⟨⟨0, .inr 0, trivial, id⟩, ⟨1, .inl 1, Nat.le_refl _, fun same => Nat.noConfusion same⟩⟩

/-! ## Q5. On the witness's process the lag never ranks `none` above an exceeding climb -/

/-- **Q5.** On `WiderNow`'s process, for any admissions, where the climb's course exceeds `none`'s,
`none` covers the climb at no lag, so the lagged order does not rank `none` above the climb. -/
theorem not_ranked_above_exceeding_climb {X : Type} {adm : Option Nat → X → Prop}
    (exceeds : (WiderNow.course (some 0)).RangeExceeds adm (WiderNow.course none)) :
    ¬ Reaching.WidensOrLater WiderNow.process adm none (some 0) :=
  have noLag : ¬ ∃ d, Reaching.CoversLater WiderNow.process adm d none (some 0) :=
    fun ⟨d, covers⟩ => match covers (WiderNow.course (some 0)) rfl, exceeds with
      | ⟨r, start, later⟩, ⟨t, x, yes, no⟩ =>
        no (Eq.subst (motive := fun c => adm c x)
          (Law.runs_agree r (WiderNow.course none) start (t + d)) (later t x yes))
  fun
    | .inl widens => noLag ⟨0, Reaching.CoversLater.zero.mpr widens.1⟩
    | .inr ⟨later, _⟩ => noLag later

/-! ## Q6. The lagged order against UE9's, with fixed conditions -/

section Determined

variable {S : Type} {A : Type} {P : Process S A}

/-- **Q6a.** On a determined process with fixed conditions, the lagged order is the strict part of
inclusion of the two courses' levels joined to UE9's widening with a lag of them. -/
theorem widensOrLater_conditions_iff {F C : Type} (K : Conditions S F C)
    (unique : ∀ q q' : Run P, q.state 0 = q'.state 0 → ∀ t, q.state t = q'.state t)
    {s s' : S} {r r' : Run P} (start : r.state 0 = s) (start' : r'.state 0 = s') :
    Reaching.WidensOrLater P K.dependence.AdmitsAt s s' ↔
      ((K.dependence.along r).Includes (K.dependence.along r).level (K.dependence.along r').level ∧
          ¬ (K.dependence.along r).Includes (K.dependence.along r').level
            (K.dependence.along r).level) ∨
        (K.dependence.along r).WidensWithLag (K.dependence.along r).level
          (K.dependence.along r').level :=
  Reaching.widensOrLater_iff_of_unique unique start start'

/-- **Q6b.** UE9's order of the two courses' levels lies inside the lagged order. -/
theorem widensOrLater_of_ue9 {F C : Type} (K : Conditions S F C)
    (unique : ∀ q q' : Run P, q.state 0 = q'.state 0 → ∀ t, q.state t = q'.state t)
    {s s' : S} {r r' : Run P} (start : r.state 0 = s) (start' : r'.state 0 = s')
    (ue9 : (K.dependence.along r).WidensOrWithLag (K.dependence.along r).level
      (K.dependence.along r').level) :
    Reaching.WidensOrLater P K.dependence.AdmitsAt s s' :=
  (widensOrLater_conditions_iff K unique start start').mpr (match ue9 with
    | .inl ⟨includes, t, f, yes, no⟩ => .inl ⟨includes, fun back => no (back t f yes)⟩
    | .inr lag => .inr lag)

/-- **Q6c.** Where the inclusion back is decided against exceeding, the lagged order gives UE9's
order of the two courses' levels. -/
theorem ue9_of_widensOrLater_decided {F C : Type} (K : Conditions S F C)
    (unique : ∀ q q' : Run P, q.state 0 = q'.state 0 → ∀ t, q.state t = q'.state t)
    {s s' : S} {r r' : Run P} (start : r.state 0 = s) (start' : r'.state 0 = s')
    (decided : (K.dependence.along r).Includes (K.dependence.along r').level
        (K.dependence.along r).level ∨
      (K.dependence.along r).Exceeds (K.dependence.along r).level (K.dependence.along r').level)
    (lagged : Reaching.WidensOrLater P K.dependence.AdmitsAt s s') :
    (K.dependence.along r).WidensOrWithLag (K.dependence.along r).level
      (K.dependence.along r').level :=
  match (widensOrLater_conditions_iff K unique start start').mp lagged with
  | .inl ⟨includes, notBack⟩ => match decided with
    | .inl back => (notBack back).elim
    | .inr exceeds => .inl ⟨includes, exceeds⟩
  | .inr lag => .inr lag

end Determined

end Recheck2UE10

end Becoming
