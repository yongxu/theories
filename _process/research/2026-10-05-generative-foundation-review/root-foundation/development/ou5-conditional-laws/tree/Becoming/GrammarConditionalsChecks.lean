import Becoming.GrammarConditionals
import Becoming.GrammarTesting

/-!
# The checks the OU5 design cites (scratch only, not proposals)

The design's countermodel column and its review section name these: compositions of package laws
one or two steps long, and small nets a law's docstring describes. They are named so the audit
reads them; none is proposed for the package. This module imports `GrammarTesting` for the stages
(层), which `GrammarConditionals` does not reach.
-/

namespace Becoming

universe u

section Checks

variable {α : Type u}

/-! ## Conditions, beginnings and abiding (G08, G13, G16, G24) -/

/-- G16: what has no condition begins under every class (`«一之生»`, `«生于粗则生于细»`). -/
theorem check_unconditioned_begins_everywhere {R : «际» α} {y : α} (none : ∀ x, ¬ R x y)
    (E : «际» α) : «生» R E y :=
  «生于粗则生于细» R (fun _ _ _ => trivial) ((«一之生» R y).mpr none)

/-- G16, ZL-01-099 false as read: what has no condition abides under no class. -/
theorem check_unconditioned_not_abiding {R : «际» α} {y : α} (none : ∀ x, ¬ R x y) (E : «际» α) :
    ¬ «住» R E y :=
  fun ⟨⟨x, r, _⟩, _⟩ => none x r

/-- G08, G16, G24: the lone occurrence has no condition and ends: it begins and ends under the one. -/
theorem check_end_without_rise :
    «生» (fun _ _ : Unit => False) «一» () ∧ «亡» (fun _ _ : Unit => False) «一» () :=
  ⟨fun ⟨_, r, _⟩ => r, fun ⟨_, r, _⟩ => r⟩

/-- G16, ZL-02-070 false as read: what is its own condition begins under no class
(`«自缘则常»`, `«生住不并»`). -/
theorem check_own_condition_no_beginning {R E : «际» α} (hE : «类» E) {x : α} (h : R x x) :
    ¬ «生» R E x :=
  fun begins => «生住不并» ⟨begins, «自缘则常» h hE⟩

/-- G16, LZ-07-002 read against its commentary: the short line's end is not its own condition, and
it ends. -/
theorem check_short_end_not_own_condition : ¬ Map.short true true ∧ «亡» Map.short «一» true :=
  ⟨fun ⟨h, _⟩ => Bool.noConfusion h, Map.short_end⟩

/-- G13, ZL-21-113 false as read: counting, at one, ends under identity yet abides under the one and
does not end under it (`«四相俱时»`). -/
theorem check_impermanent_continuing :
    «亡» (fun m n : Nat => n = m + 1) «静» 1 ∧ «住» (fun m n : Nat => n = m + 1) «一» 1 ∧
      ¬ «亡» (fun m n : Nat => n = m + 1) «一» 1 :=
  match «四相俱时» (R := fun m n : Nat => n = m + 1) (x := 0) (z := 2)
      (fun h => Nat.noConfusion (Nat.succ.inj h)) rfl rfl with
  | ⟨_, ends, abides, _⟩ => ⟨ends, abides, fun e => e ⟨2, rfl, trivial⟩⟩

/-- G13, ZL-17-051 false as read: a result with no condition (`2`) abides under no class, while the
deed (`0`) goes on. -/
theorem check_result_without_deed :
    ∃ (R : «际» Nat), «有后» R «一» 0 ∧ (∀ x, ¬ R x 2) ∧ ∀ E, ¬ «住» R E 2 :=
  have none : ∀ x : Nat, ¬ (x = 0 ∧ (2 : Nat) = 1) := fun _ ⟨_, h⟩ => Nat.noConfusion (Nat.succ.inj h)
  ⟨fun a b => a = 0 ∧ b = 1, ⟨1, ⟨rfl, rfl⟩, trivial⟩, none,
   fun E => check_unconditioned_not_abiding (R := fun a b : Nat => a = 0 ∧ b = 1) none E⟩

/-! ## Ends and constancy (G02, G11, G14) -/

/-- G02: the short line ends, so it is not 全生成. -/
theorem check_short_not_generating : ¬ «全生成» Map.short «一» «静» false :=
  fun g => «全生成有终不并» ⟨g, Map.Short.degeneration⟩

/-- G11, G14: the one is not constant on the short line. -/
theorem check_short_not_constant : ¬ «有常» Map.short «一» := fun hc =>
  match («有常之逐点» _ «一»).mp hc false true trivial true ⟨rfl, rfl⟩ with
  | ⟨_, ⟨h, _⟩, _⟩ => Bool.noConfusion h

/-- G14: on the short line, `true` has a predecessor, the one is not constant, and `true` ends. -/
theorem check_short_end_true :
    «有前» Map.short «一» true ∧ ¬ «有常» Map.short «一» ∧ «亡» Map.short «一» true :=
  ⟨⟨false, ⟨rfl, rfl⟩, trivial⟩, check_short_not_constant, Map.short_end⟩

/-- G02: the still occurrence keeps, so it is not 全生成. -/
theorem check_still_not_generating : ¬ «全生成» Map.still «一» «一» () :=
  fun g => «全生成全守不并» ⟨g, Map.Still.keeping⟩

/-- G11, CWS-P6+P7+P8-020 false as read: a class not constant under which a line never ends.
Counting up beside a lone occurrence, under the one. -/
theorem check_not_constant_yet_endless :
    ∃ (R : «际» (Option Nat)), ¬ «有常» R «一» ∧ «有前» R «一» (some 1) ∧ «不穷» R «一» (some 1) := by
  let R : «际» (Option Nat) := fun a b => ∃ m, a = some m ∧ b = some (m + 1)
  have fwd : ∀ m : Nat, R (some m) (some (m + 1)) := fun m => ⟨m, rfl, rfl⟩
  have onLine : ∀ {a b : Option Nat}, «相续» R «一» a b → ∃ c, b = some c := by
    intro a b l
    induction l with
    | one c' => match c'.1 with | ⟨m, _, hb⟩ => exact ⟨m + 1, hb⟩
    | more _ _ ih => exact ih
  refine ⟨R, fun hc => ?_, ⟨some 0, fwd 0, trivial⟩, fun y reach => ?_⟩
  · match («有常之逐点» R «一»).mp hc (some 0) none trivial (some 1) (fwd 0) with
    | ⟨_, ⟨_, h, _⟩, _⟩ => exact nomatch h
  · match reach with
    | .inl e => exact ⟨some 2, Eq.subst (motive := fun w => R w (some 2)) e (fwd 1), trivial⟩
    | .inr l => match onLine l with
      | ⟨c, e⟩ =>
        exact ⟨some (c + 1), Eq.subst (motive := fun w => R w (some (c + 1))) e.symm (fwd c), trivial⟩

/-! ## Alteration and passing through (G01) -/

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

/-- G01: two-way constancy is not needed for ending, altering and passing through: day and night
beside a lone occurrence. The one is not constant (the lone occurrence has no successor while the
others do), yet `some false` ends under identity, alters into `some true` under the one, and
`some true` passes through under the one. -/
theorem check_tong_without_constancy :
    ∃ (R : «际» (Option Bool)), ¬ «有常» R «一» ∧ «亡» R «静» (some false) ∧
      «异» R «一» «静» (some false) (some true) ∧ «通» R «一» (some true) := by
  let R : «际» (Option Bool) := fun a b => ∃ x, a = some x ∧ b = some (!x)
  have fwd : ∀ c : Bool, R (some c) (some (!c)) := fun c => ⟨c, rfl, rfl⟩
  have bwd : ∀ c : Bool, «逆» R (some c) (some (!c)) := fun c =>
    ⟨!c, rfl, Eq.subst (motive := fun b => some c = some b) (Bool.not_not c).symm rfl⟩
  have onPair : ∀ {S : «际» (Option Bool)}, (∀ a b, S a b → ∃ c, b = some c) →
      ∀ {a b : Option Bool}, «相续» S «一» a b → ∃ c, b = some c := by
    intro S hS a b l
    induction l with
    | one c' => exact hS _ _ c'.1
    | more _ _ ih => exact ih
  have rTo : ∀ a b, R a b → ∃ c, b = some c := fun _ _ ⟨x, _, hb⟩ => ⟨!x, hb⟩
  have rFrom : ∀ a b, «逆» R a b → ∃ c, b = some c := fun _ _ ⟨x, ha, _⟩ => ⟨x, ha⟩
  refine ⟨R, fun hc => ?_, fun ⟨y, ⟨x, hx, hy⟩, e⟩ => ?_, ⟨⟨fwd false, trivial⟩, fun e => ?_⟩, ?_, ?_⟩
  · match («有常之逐点» R «一»).mp hc (some false) none trivial (some true) (fwd false) with
    | ⟨_, ⟨_, h, _⟩, _⟩ => exact nomatch h
  · have hx' : x = false := (Option.some.inj hx).symm
    have e' : some false = some (!x) := e.trans hy
    exact Bool.noConfusion ((Option.some.inj e').trans (congrArg (fun b => !b) hx'))
  · exact Bool.noConfusion (Option.some.inj e)
  · intro y reach
    match reach with
    | .inl e => exact ⟨some false, Eq.subst (motive := fun w => R w (some false)) e (fwd true), trivial⟩
    | .inr l => match onPair rTo l with
      | ⟨c, e⟩ =>
        exact ⟨some (!c), Eq.subst (motive := fun w => R w (some (!c))) e.symm (fwd c), trivial⟩
  · intro y reach
    match reach with
    | .inl e =>
      exact ⟨some false, Eq.subst (motive := fun w => «逆» R w (some false)) e (bwd true), trivial⟩
    | .inr l => match onPair rFrom l with
      | ⟨c, e⟩ =>
        exact ⟨some (!c), Eq.subst (motive := fun w => «逆» R w (some (!c))) e.symm (bwd c), trivial⟩

/-! ## Along the core (G15) -/

/-- G15: going back never ends alike along the core of the converse net (`«核同则同不穷»` at the
converse net). -/
theorem check_wushi_along_converse_core {R E : «际» α} (hE : «类» E) {y y' : α}
    (hk : «核» («逆» R) E y y') (beginningless : «不穷» («逆» R) E y) : «不穷» («逆» R) E y' :=
  «核同则同不穷» hE hk beginningless

/-- G15: the two-way core lies within the core of the converse net, so `«生于逆核下不变»` gives
`«生于位核下不变»`. -/
theorem check_position_core_within_converse_core (R E : «际» α) :
    «则» («位核» R E) («核» («逆» R) E) :=
  fun _ _ ⟨S, hSE, hs, _, hc', h⟩ => ⟨S, hSE, hs, hc', h⟩

/-- G15: the core of the converse net is not within the forward core. Three occurrences: `0` and `1`
have no condition, `0` conditions `2`, `1` conditions nothing. -/
theorem check_converse_core_wider :
    ∃ (R : «际» Nat), «核» («逆» R) «一» 0 1 ∧ ¬ «核» R «一» 0 1 := by
  let R : «际» Nat := fun a b => a = 0 ∧ b = 2
  refine ⟨R, ⟨fun u v => (u = 0 ∨ u = 1) ∧ (v = 0 ∨ v = 1), fun _ _ _ => trivial,
    fun _ _ ⟨a, b⟩ => ⟨b, a⟩, ?_, ⟨.inl rfl, .inr rfl⟩⟩, ?_⟩
  · apply («有常之逐点» («逆» R) _).mpr
    intro u u' ⟨hu, _⟩ v r
    match hu with
    | .inl h => exact absurd (h.symm.trans r.2) (fun e => Nat.noConfusion e)
    | .inr h => exact absurd (h.symm.trans r.2) (fun e => Nat.noConfusion (Nat.succ.inj e))
  · intro ⟨S, _, hs, hc, s01⟩
    match («有常之逐点» R S).mp hc 0 1 s01 2 ⟨rfl, rfl⟩ with
    | ⟨_, ⟨h, _⟩, _⟩ => exact Nat.noConfusion h

/-- G15, where the core does not join them: an occurrence whose line never ends beside one that
ends. A loop beside a lone occurrence; ending is kept along the core (`«亡于核下不变»`), so the core
does not put them together. -/
theorem check_endless_beside_ending :
    ∃ (R : «际» (Option Unit)), «不穷» R «一» (some ()) ∧ «亡» R «一» none ∧
      ¬ «核» R «一» (some ()) none := by
  let R : «际» (Option Unit) := fun a b => a = some () ∧ b = some ()
  have lands : ∀ {a b : Option Unit}, «相续» R «一» a b → b = some () := by
    intro a b l
    induction l with
    | one c => exact c.1.2
    | more _ _ ih => exact ih
  have ends : «亡» R «一» none := fun ⟨_, r, _⟩ => nomatch r.1
  refine ⟨R, fun y on => ?_, ends, fun hk => ?_⟩
  · have hy : y = some () := match on with
      | .inl e => e.symm
      | .inr l => lands l
    exact ⟨some (), ⟨hy, rfl⟩, trivial⟩
  · match hk with
    | ⟨S, hSE, hs, hc, h⟩ =>
      exact «亡于核下不变» ⟨fun _ => trivial, fun _ => trivial, fun _ _ => trivial⟩
        ⟨S, hSE, hs, hc, hs _ _ h⟩ ends ⟨some (), ⟨rfl, rfl⟩, trivial⟩

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

/-! ## Marks, conditions together, measures (G18, G19, G22) -/

/-- G18: what holds everywhere has no mark, and what holds nowhere has none (`«遍而无相»`). -/
theorem check_everywhere_no_mark_both {P : α → Prop} :
    ((∀ x, P x) → ¬ «有相» P) ∧ ((∀ x, ¬ P x) → ¬ «有相» P) :=
  ⟨«遍而无相», fun none ⟨⟨x, p⟩, _⟩ => none x p⟩

/-- G19: where nothing conditions, nothing is conditioned (`«能所相待»`). -/
theorem check_nothing_conditions_nothing_conditioned (R : «际» α) :
    (¬ ∃ x, «能» R x) → ¬ ∃ y, «所» R y :=
  fun none some => none ((«能所相待» R).mpr some)

/-- G19: the empty net: nothing conditions and nothing is conditioned. -/
theorem check_empty_net :
    (¬ ∃ x, «能» (fun _ _ : Unit => False) x) ∧ ¬ ∃ y, «所» (fun _ _ : Unit => False) y :=
  ⟨fun ⟨_, _, r⟩ => r, fun ⟨_, _, r⟩ => r⟩

/-- G22: a balance that reverses does not keep "heavier than" within "hangs lower than". -/
theorem check_reversing_balance : ¬ «则» («像» (fun b : Bool => !b) (fun a b => a = true ∧ b = false))
    (fun p q => p = true ∧ q = false) :=
  fun within => match within false true ⟨true, false, rfl, ⟨rfl, rfl⟩, rfl⟩ with
    | ⟨h, _⟩ => Bool.noConfusion h

end Checks

end Becoming
