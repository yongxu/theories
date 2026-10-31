import Becoming.GrammarLaws

/-!
# Not going out of a region (不出): what a relation crosses, on the root

A region is delimited from the rest by what it holds, and a relation crosses that delimitation where
it bears a member to something outside (the root chapter's reading of boundaries, 01 §9.9). The
grammar states the closed region (`«闭»`): whatever a member bears the relation to is a member. This
module states not going out (`«不出»`) for every carrier, relation and region, how it differs from
being closed, how going out and coming in are related, and where on a line a crossing lies. It adds
one definition and changes no definition of an earlier module.

| name | reading |
|---|---|
| `«不出»` | nothing in a region goes out of it along a relation: no member bears it to something outside |

* **Closed, and not gone out of.** A closed region is not gone out of (`«闭则不出»`), an occurrence's
  closure among them (`«所闭不出»`, the closure law `«所闭之界»` read through `«不出»`). Not going out
  of a region is exactly the closedness of what is not outside it (`«不出当且仅当不外者闭»`): its
  members bear the relation only to what is not outside. No decision is used. Where membership is
  stable, whatever is not outside the region lying in it, the two coincide
  (`«不外者内则不出当且仅当闭»`). That they coincide for every relation and region is exactly excluded
  middle (`«不出皆闭当且仅当排中»`), a lemma of that law, not a calibration: the need comes from
  membership being any proposition, not from the relation.
* **Going out and coming in.** Nothing comes into a region along a relation, nothing outside bearing it
  to a member, where the region is not gone out of along the converse (`«逆»`), and that is exactly
  that nothing outside the region goes out of what lies outside it (`«逆之不出当且仅当外者不出»`), with
  no decision. Along a symmetric relation nothing goes out of a region exactly where nothing comes in
  (`«对称则不出当且仅当逆不出»`); some relation that is not symmetric has a closed region come into
  (`«闭而有入之例»`).
* **The crossing on a line.** A line (相续) under any class from a member to something outside means
  the region is not one nothing goes out of (`«内至外之线则非不出»`), with no decision; it names no
  step going out. Where every step of continuation keeps to the region, its end a member wherever its
  start is, or goes out of it, from a member to something outside, the line has a step going out,
  given with its place on the line: reached from the start, and reaching the end (`«内至外之线有出步»`).
  It is `«两端分则中有标»` with keeping to the region, which is transitive, as what the line's ends
  fail. Where membership is decided every step is of one of the two kinds (`«定则内至外之线有出步»`); a
  line under a class leaving a decided region only into a set passes a member of the set this way
  (`«所经必同»`, `Becoming.GrammarPath`).

The World's cut is this module's `«不出»` at a valuation's relation, by definition, and 04 §1's law of
crossing is read on 07 §4.1's boundaries in `Becoming.ConveyanceBoundaries`. What is not shown: a
graded boundary, and which relation a self's boundary is drawn along (07 §4.2). Every declaration has
an empty axiom report.
-/

namespace Becoming

universe u

/-! ## Not going out (不出) -/

section NotGoingOut

variable {α : Type u}

/-- Nothing in a region goes out of it along a relation (不出): no member bears the relation to
something outside. -/
def «不出» (R : «际» α) (P : α → Prop) : Prop := ∀ x y, P x → ¬ P y → ¬ R x y

/-- **A closed region is not gone out of.** -/
theorem «闭则不出» {R : «际» α} {P : α → Prop} (closed : «闭» R P) : «不出» R P :=
  fun x y inside outside related => outside (closed x y inside related)

/-- **An occurrence's closure is not gone out of**, as every closed region: nothing within it bears the
relation to what lies beyond it. It is the closure law `«所闭之界»` read through `«不出»`. -/
theorem «所闭不出» (R : «际» α) (x : α) : «不出» R («所闭» R x) :=
  fun _ _ within beyond => «所闭之界» within beyond

/-- **Not going out of a region is the closedness of what is not outside it.** Nothing in `P` bears
`R` to something outside `P` exactly where the region of what is not outside `P` is closed under `R`.
No decision is used. -/
theorem «不出当且仅当不外者闭» {R : «际» α} {P : α → Prop} :
    «不出» R P ↔ «闭» R (fun y => ¬ ¬ P y) :=
  ⟨fun none x y notOutside related outside =>
      notOutside fun inside => none x y inside outside related,
   fun closed x y inside outside related => closed x y (fun out => out inside) related outside⟩

/-- **Where membership is stable, not going out is being closed.** Where whatever is not outside `P`
lies in `P`, nothing in `P` going out of it along `R` is `P`'s being closed under `R`. -/
theorem «不外者内则不出当且仅当闭» {R : «际» α} {P : α → Prop} (stable : ∀ y, ¬ ¬ P y → P y) :
    «不出» R P ↔ «闭» R P :=
  ⟨fun none x y inside related => stable y fun outside => none x y inside outside related,
   «闭则不出»⟩

/-- **That not going out is always being closed is exactly excluded middle.** That every region nothing
goes out of, along every relation on every carrier in `Type`, is closed is exactly excluded middle. It
is a lemma of `«不外者内则不出当且仅当闭»`, the law that needs it, not a calibration: the need comes
from membership being any proposition. -/
theorem «不出皆闭当且仅当排中» :
    (∀ (α : Type) (R : «际» α) (P : α → Prop), «不出» R P → «闭» R P) ↔ ∀ Q : Prop, Q ∨ ¬ Q := by
  constructor
  · intro closes Q
    have stable : ∀ S : Prop, ¬ ¬ S → S := fun S notNot =>
      match closes Bool (fun x y => x = false ∧ y = true) (fun b => b = false ∨ S)
          (fun _ _ _ outside _ => notNot fun s => outside (.inr s)) false true (.inl rfl)
          ⟨rfl, rfl⟩ with
      | .inl wrong => Bool.noConfusion wrong
      | .inr s => s
    exact stable _ fun none => none (.inr fun q => none (.inl q))
  · intro decided α R P none x y inside related
    match decided (P y) with
    | .inl holds => exact holds
    | .inr outside => exact absurd related (none x y inside outside)

end NotGoingOut

/-! ## Going out and coming in -/

section ComingIn

variable {α : Type u}

/-- **Nothing comes into a region exactly where nothing goes out of what lies outside it.** Nothing
outside `P` bears `R` to a member of `P` (`P` is not gone out of along the converse of `R`) exactly
where nothing outside `P` bears `R` to something not outside `P`. No decision is used. -/
theorem «逆之不出当且仅当外者不出» {R : «际» α} {P : α → Prop} :
    «不出» («逆» R) P ↔ «不出» R (fun y => ¬ P y) :=
  ⟨fun none x y outside notOutside related =>
      notOutside fun inside => none y x inside outside related,
   fun none x y inside outside related => none y x outside (fun out => out inside) related⟩

/-- **Along a symmetric relation, nothing goes out of a region exactly where nothing comes in.** -/
theorem «对称则不出当且仅当逆不出» {R : «际» α} {P : α → Prop} (symm : «则» R («逆» R)) :
    «不出» R P ↔ «不出» («逆» R) P :=
  ⟨fun none x y inside outside related => none x y inside outside (symm y x related),
   fun none x y inside outside related => none x y inside outside (symm x y related)⟩

/-- **A closed region come into: a witness.** Some relation that is not symmetric has a region closed
under it with something outside bearing it to a member: on two occurrences, the relation from the
first to the second, and the region of the second. Along a symmetric relation no closed region is
come into (`«闭则不出»`, `«对称则不出当且仅当逆不出»`). -/
theorem «闭而有入之例» :
    ∃ (R : «际» Bool) (P : Bool → Prop),
      «闭» R P ∧ (∃ x y, ¬ P x ∧ P y ∧ R x y) ∧ ¬ «则» R («逆» R) :=
  ⟨fun x y => x = false ∧ y = true, fun b => b = true, fun _ _ _ related => related.2,
   ⟨false, true, Bool.false_ne_true, rfl, ⟨rfl, rfl⟩⟩,
   fun symm => Bool.false_ne_true (show true = false ∧ false = true from symm false true ⟨rfl, rfl⟩).2⟩

end ComingIn

/-! ## The crossing on a line -/

section Lines

variable {α : Type u}

/-- **A region a line leaves is not one nothing goes out of.** Where a line (相续) under `E` runs from
a member of `P` to something outside `P`, `P` is not `«不出»` along `R`. No decision is used, and no
step going out is named: `«内至外之线有出步»` names one where every step keeps to `P` or goes out of
it. -/
theorem «内至外之线则非不出» {R E : «际» α} {P : α → Prop} {x y : α} (line : «相续» R E x y)
    (inside : P x) (outside : ¬ P y) : ¬ «不出» R P :=
  fun none => «闭之及» («不出当且仅当不外者闭».mp none) (fun out => out inside)
    («相续含于及» R E x y line) outside

/-- **A line from inside to outside has a step going out, placed on the line.** Where every step of
continuation under `E` either keeps to `P`, its end a member wherever its start is, or goes out of it,
from a member to something outside, a line under `E` from a member of `P` to something outside `P` has
a step from a member to something outside, given with its place on the line: reached from the start,
and reaching the end. It is `«两端分则中有标»` with keeping to `P`, which is transitive, as what the
line's ends fail. -/
theorem «内至外之线有出步» {R E : «际» α} {P : α → Prop}
    (split : ∀ u v, «续» R E u v → (P u → P v) ∨ (P u ∧ ¬ P v)) {x y : α} (line : «相续» R E x y)
    (inside : P x) (outside : ¬ P y) :
    ∃ u v, «续» R E u v ∧ (P u ∧ ¬ P v) ∧ (x = u ∨ «相续» R E x u) ∧ (v = y ∨ «相续» R E v y) :=
  «两端分则中有标» (K := fun a b => P a → P b) (P := fun a b => P a ∧ ¬ P b) split
    (fun keep keep' held => keep' (keep held)) line fun keep => outside (keep inside)

/-- **Where membership is decided, a line from inside to outside has a step going out**, placed on the
line. -/
theorem «定则内至外之线有出步» {R E : «际» α} {P : α → Prop} (decided : ∀ a, P a ∨ ¬ P a) {x y : α}
    (line : «相续» R E x y) (inside : P x) (outside : ¬ P y) :
    ∃ u v, «续» R E u v ∧ (P u ∧ ¬ P v) ∧ (x = u ∨ «相续» R E x u) ∧ (v = y ∨ «相续» R E v y) :=
  «内至外之线有出步» (fun u v _ => match decided u, decided v with
    | _, .inl held => .inl fun _ => held
    | .inl member, .inr out => .inr ⟨member, out⟩
    | .inr notMember, .inr _ => .inl fun member => absurd member notMember) line inside outside

end Lines

end Becoming
