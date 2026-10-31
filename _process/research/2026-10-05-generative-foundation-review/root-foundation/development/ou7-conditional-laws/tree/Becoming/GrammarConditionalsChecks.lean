import Becoming.GrammarConditionals
import Becoming.GrammarTesting

/-!
# The checks the OU7 design cites (scratch only, not proposals)

The design's family rows and its review section name these: compositions of package laws one or two
steps long, which the home section states as text. They are named so the audit reads them; none is
proposed for the package, and every counterexample the design proposes for the core is a witness in
`GrammarConditionals`. This module imports `GrammarTesting` for the stages (层), which
`GrammarConditionals` does not reach.
-/

namespace Becoming

universe u

section Checks

variable {α : Type u}

/-! ## Conditions, beginnings and abiding (G13, G16) -/

/-- G16: what has no condition begins under every class (`«一之生»`, `«生于粗则生于细»`). -/
theorem check_unconditioned_begins_everywhere {R : «际» α} {y : α} (none : ∀ x, ¬ R x y)
    (E : «际» α) : «生» R E y :=
  «生于粗则生于细» R (fun _ _ _ => trivial) ((«一之生» R y).mpr none)

/-- G16, ZL-01-099 false as read: what has no condition abides under no class. -/
theorem check_unconditioned_not_abiding {R : «际» α} {y : α} (none : ∀ x, ¬ R x y) (E : «际» α) :
    ¬ «住» R E y :=
  fun ⟨⟨x, r, _⟩, _⟩ => none x r

/-- G16, ZL-02-070 false as read: what is its own condition begins under no class
(`«自缘则常»`, `«生住不并»`); `«自缘而不生之例»` is its instance. -/
theorem check_own_condition_no_beginning {R E : «际» α} (hE : «类» E) {x : α} (h : R x x) :
    ¬ «生» R E x :=
  fun begins => «生住不并» ⟨begins, «自缘则常» h hE⟩

/-- G16, LZ-07-002 read against its commentary: the short line's end is not its own condition, and
it ends. -/
theorem check_short_end_not_own_condition : ¬ Map.short true true ∧ «亡» Map.short «一» true :=
  ⟨fun ⟨h, _⟩ => Bool.noConfusion h, Map.short_end⟩

/-! ## Alteration and passing through (G01, G02) -/

/-- G01, G02: where every step leaves `E`, every continuation under `L` alters from `L` under `E`. -/
theorem check_parted_steps_alter {R L E : «际» α} (leaves : ∀ a b, R a b → ¬ E a b) {x y : α}
    (c : «续» R L x y) : «异» R L E x y :=
  ⟨c, leaves x y c.1⟩

/-- G01, XCS-11-009 (往來不窮謂之通): where every step leaves `E`, the line under `L` from `x` never ends
exactly where every place on it alters. One unfolding of the definitions. -/
theorem check_unending_is_altering {R L E : «际» α} (leaves : ∀ a b, R a b → ¬ E a b) (x : α) :
    «不穷» R L x ↔ ∀ y, (x = y ∨ «相续» R L x y) → ∃ z, «异» R L E y z :=
  ⟨fun endless y on => match endless y on with
    | ⟨z, c⟩ => ⟨z, check_parted_steps_alter leaves c⟩,
   fun alters y on => match alters y on with
    | ⟨z, c, _⟩ => ⟨z, c⟩⟩

/-- G01, XCS-11-009 both ways: where every step leaves `E` either way, passing through is altering at
every place, going and coming. -/
theorem check_tong_is_unending_bian {R L E : «际» α} (leaves : ∀ a b, R a b → ¬ E a b)
    (leaves' : ∀ a b, R b a → ¬ E a b) (x : α) :
    «通» R L x ↔ (∀ y, (x = y ∨ «相续» R L x y) → ∃ z, «异» R L E y z) ∧
      (∀ y, (x = y ∨ «相续» («逆» R) L x y) → ∃ z, «异» («逆» R) L E y z) :=
  ⟨fun ⟨go, come⟩ => ⟨(check_unending_is_altering leaves x).mp go,
     (check_unending_is_altering (R := «逆» R) leaves' x).mp come⟩,
   fun ⟨go, come⟩ => ⟨(check_unending_is_altering leaves x).mpr go,
     (check_unending_is_altering (R := «逆» R) leaves' x).mpr come⟩⟩

/-! ## Along the core (G15) -/

/-- G15: going back never ends alike along the core of the converse net (`«核同则同不穷»` at the
converse net). -/
theorem check_wushi_along_converse_core {R E : «际» α} (hE : «类» E) {y y' : α}
    (hk : «核» («逆» R) E y y') (beginningless : «不穷» («逆» R) E y) : «不穷» («逆» R) E y' :=
  «核同则同不穷» hE hk beginningless

/-- G15, `«依于无始而有始之例»`'s verdict needs a class that tells the two kinds apart: under the one
the occurrence of the other kind has a predecessor. -/
theorem check_kinds_told_apart :
    «有前» (fun x y : Bool × Nat =>
      (x.1 = true ∧ y.1 = true ∧ x.2 = y.2 + 1) ∨ (x = (true, 0) ∧ y = (false, 0))) «一» (false, 0) :=
  ⟨(true, 0), .inr ⟨rfl, rfl⟩, trivial⟩

/-! ## Stages and the core (G21) -/

/-- Each stage of inquiry lies within the one before. -/
theorem check_inquiry_descends {R E : «际» α} : ∀ k u u', «诘» R E (k + 1) u u' → «诘» R E k u u'
  | 0, _, _, ⟨e, _, _⟩ => e
  | k + 1, _, _, ⟨e, f, b⟩ =>
    ⟨e, fun v r => match f v r with | ⟨v', r', s⟩ => ⟨v', r', check_inquiry_descends k v v' s⟩,
     fun v' r' => match b v' r' with | ⟨v, r, s⟩ => ⟨v, r, check_inquiry_descends k v v' s⟩⟩

/-- Each stage lies within `E`. -/
theorem check_stage_within {R E : «际» α} : ∀ k x y, «层» R E k x y → E x y
  | 0, _, _, h => h
  | k + 1, x, y, ⟨l, _, _⟩ => check_stage_within k x y l

/-- G21: the stages (层, `GrammarTesting`) and the stages of inquiry (诘, `GrammarCandidates`) are one
relation at every stage, defined two ways. -/
theorem check_stage_eq_inquiry {R E : «际» α} : ∀ k x y, «层» R E k x y ↔ «诘» R E k x y
  | 0, _, _ => Iff.rfl
  | k + 1, x, y =>
    ⟨fun ⟨l, f, b⟩ => ⟨check_stage_within k x y l,
       fun v r => match f v r with | ⟨v', r', s⟩ => ⟨v', r', (check_stage_eq_inquiry k v v').mp s⟩,
       fun v' r' => match b v' r' with | ⟨v, r, s⟩ => ⟨v, r, (check_stage_eq_inquiry k v v').mp s⟩⟩,
     fun ⟨e, f, b⟩ => ⟨(check_stage_eq_inquiry k x y).mpr (check_inquiry_descends k x y ⟨e, f, b⟩),
       fun v r => match f v r with | ⟨v', r', s⟩ => ⟨v', r', (check_stage_eq_inquiry k v v').mpr s⟩,
       fun v' r' => match b v' r' with | ⟨v, r, s⟩ => ⟨v, r, (check_stage_eq_inquiry k v v').mpr s⟩⟩⟩

/-- G21, XZ-ZM-044 under its premise: where being told apart at no stage is constant, what the core
does not join is not alike at every stage. -/
theorem check_telling_apart_needs_a_stage {R E : «际» α} (hE : «则» E («逆» E))
    (hc : «有常» R (fun u u' => ∀ k, «诘» R E k u u')) {u u' : α} (apart : ¬ «核» R E u u') :
    ¬ ∀ k, «诘» R E k u u' :=
  fun h => apart («不可致诘而有常则混而为一» hE hc h)

/-! ## Dependence within a region (G09) -/

/-- G09, the temporal readings: where every `Q` in the region `W` has a condition with `P` in `W`,
and nothing in `W` is `P`, nothing in `W` is `Q` (`«所依无则依者无»` on the region). -/
theorem check_dependence_within_region {R : «际» α} {W P Q : α → Prop}
    (dep : «依» R (fun x => W x ∧ P x) (fun y => W y ∧ Q y)) (none : ¬ ∃ x, W x ∧ P x) :
    ¬ ∃ y, W y ∧ Q y :=
  «所依无则依者无» dep none

/-- G09: without the condition in the region the law fails: a result whose condition lies before the
region stays in it when nothing in it is the condition. -/
theorem check_dependence_outside_region :
    ∃ (R : «际» Nat) (W P Q : Nat → Prop), «依» R P Q ∧ (¬ ∃ x, W x ∧ P x) ∧ ∃ y, W y ∧ Q y :=
  ⟨fun a b => a = 0 ∧ b = 1, fun x => x = 1, fun x => x = 0, fun y => y = 1,
   fun _ q => ⟨0, ⟨rfl, q⟩, rfl⟩, fun ⟨_, w, p⟩ => Nat.noConfusion (w.symm.trans p), ⟨1, rfl, rfl⟩⟩

/-! ## Marks and conditions together (G18, G19) -/

/-- G18: what holds everywhere has no mark, and what holds nowhere has none (`«遍而无相»`). -/
theorem check_everywhere_no_mark_both {P : α → Prop} :
    ((∀ x, P x) → ¬ «有相» P) ∧ ((∀ x, ¬ P x) → ¬ «有相» P) :=
  ⟨«遍而无相», fun none ⟨⟨x, p⟩, _⟩ => none x p⟩

/-- G19: where nothing conditions, nothing is conditioned (`«能所相待»`). -/
theorem check_nothing_conditions_nothing_conditioned (R : «际» α) :
    (¬ ∃ x, «能» R x) → ¬ ∃ y, «所» R y :=
  fun none some => none ((«能所相待» R).mpr some)

end Checks

end Becoming
