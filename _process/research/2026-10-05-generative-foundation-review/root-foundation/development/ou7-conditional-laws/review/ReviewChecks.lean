import Becoming.GrammarConditionals

/-! Review checks for the OU5 design (scratch, not proposals). -/

namespace Becoming

universe u

section Checks

variable {α : Type u}

/-! ### 1. `«穷则变»` is `«生于细而续于粗则异»` read in the converse net (definitional). -/
theorem review_qiong_is_dual {R E F : «际» α} {x y : α} (ends : «亡» R E x) (continues : «续» R F x y) :
    «异» R F E x y :=
  «生于细而续于粗则异» (R := «逆» R) (E := «逆» F) (F := «逆» E) (x := y) (y := x) ends continues

/-! ### 2. `«感而遂通»` is `«两向有常则通»` with `«有常则续不尽»`: one line. -/
theorem review_gan_is_composition {R E : «际» α} (hE : «类» E) (hc : «有常» R E) (hc' : «有常» («逆» R) E)
    {x : α} (affected : «有前» R E x) : «通» R E x :=
  «两向有常则通» hE hc hc' ⟨affected, «有常则续不尽» hc affected⟩

/-! ### 3. `«无缘不起当且仅当皆有缘»` from `«一之生»`. -/
theorem review_wuyuan_from_yizhisheng (R : «际» α) :
    (∀ y, ¬ «生» R «一» y) ↔ ∀ y, ¬¬ ∃ x, R x y :=
  ⟨fun h y none => h y ((«一之生» R y).mpr (fun x r => none ⟨x, r⟩)),
   fun h y b => h y (fun ⟨x, r⟩ => ((«一之生» R y).mp b) x r)⟩

/-! ### 4. `«无异当且仅当类不分续»` is pure logic, for any two relations. -/
theorem review_wuyi_is_logic {C F : «际» α} :
    (∀ x y, ¬ (C x y ∧ ¬ F x y)) ↔ ∀ x y, C x y → ¬¬ F x y :=
  ⟨fun none x y c apart => none x y ⟨c, apart⟩, fun kept x y ⟨c, apart⟩ => kept x y c apart⟩

/-! ### 5. Beginning is kept along the core of the converse net (no forward constancy needed),
so "a beginning is kept only along the two-way core" is false. -/
theorem review_sheng_kept_along_converse_core {R E : «际» α} (hE : «类» E) {y y' : α}
    (hk : «核» («逆» R) E y y') (hy : «生» R E y) : «生» R E y' :=
  fun ⟨w', hr, he⟩ => match hk with
    | ⟨S, hSE, hs, hc, hyy⟩ =>
      match («有常之逐点» («逆» R) S).mp hc y' y (hs y y' hyy) w' hr with
      | ⟨w, hrw, hww⟩ =>
        hy ⟨w, hrw, hE.trans (hE.trans (hE.symm (hSE w' w hww)) he) (hE.symm (hSE y y' hyy))⟩

/-! ### 6. Beginninglessness (going back never ends) is kept along the converse core: the exact
mirror of `«不穷于核下不变»`, by that theorem at the converse net. -/
theorem review_wushi_kept_along_converse_core {R E : «际» α} (hE : «类» E) {y y' : α}
    (hk : «核» («逆» R) E y y') (beginningless : «不穷» («逆» R) E y) : «不穷» («逆» R) E y' :=
  «不穷于核下不变» hE hk beginningless

/-! ### 7. The converse core is not inside the two-way core in general: a pair the converse core
puts together that the forward core does not (so 5 is not a case of `«生于位核下不变»`).
Three points: 0 and 1 both have no condition; 0 conditions 2, 1 conditions nothing. -/
theorem review_converse_core_wider :
    ∃ (R : «际» Nat), «核» («逆» R) «一» 0 1 ∧ ¬ «核» R «一» 0 1 := by
  let R : «际» Nat := fun a b => a = 0 ∧ b = 2
  refine ⟨R, ⟨fun u v => (u = 0 ∨ u = 1) ∧ (v = 0 ∨ v = 1), fun _ _ _ => trivial,
    fun _ _ ⟨a, b⟩ => ⟨b, a⟩, ?_, ⟨.inl rfl, .inr rfl⟩⟩, ?_⟩
  · apply («有常之逐点» («逆» R) _).mpr
    intro u u' ⟨hu, _⟩ v r
    -- «逆» R u v = R v u: v = 0 ∧ u = 2, but u is 0 or 1
    match hu with
    | .inl h => exact absurd (h.symm.trans r.2) (fun e => Nat.noConfusion e)
    | .inr h => exact absurd (h.symm.trans r.2) (fun e => Nat.noConfusion (Nat.succ.inj e))
  · intro ⟨S, _, hs, hc, s01⟩
    match («有常之逐点» R S).mp hc 0 1 s01 2 ⟨rfl, rfl⟩ with
    | ⟨_, ⟨h, _⟩, _⟩ => exact Nat.noConfusion h

/-! ### 8. Two-way constancy is not necessary for 穷 → 变 → 通: day and night beside a lone point.
The one is not constant (the lone point has no successor while the others do), yet `false` ends
under identity, alters into `true` under the one, and `true` passes through under the one. -/
theorem review_tong_without_constancy :
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
    have : y = some (!x) := hy
    have e' : some false = some (!x) := e.trans this
    exact Bool.noConfusion ((Option.some.inj e').trans (congrArg (fun b => !b) hx'))
  · exact Bool.noConfusion (Option.some.inj e)
  · intro y reach
    match reach with
    | .inl e => exact ⟨some false, Eq.subst (motive := fun w => R w (some false)) e (fwd true), trivial⟩
    | .inr l => match onPair rTo l with
      | ⟨c, e⟩ => exact ⟨some (!c), Eq.subst (motive := fun w => R w (some (!c))) e.symm (fwd c), trivial⟩
  · intro y reach
    match reach with
    | .inl e => exact ⟨some false, Eq.subst (motive := fun w => «逆» R w (some false)) e (bwd true), trivial⟩
    | .inr l => match onPair rFrom l with
      | ⟨c, e⟩ => exact ⟨some (!c), Eq.subst (motive := fun w => «逆» R w (some (!c))) e.symm (bwd c), trivial⟩

/-! ### 9. G03 with a local premise: no place of the line from `x` reaches itself along
continuation (instead of `«无环» R`, nothing anywhere reaches itself along 缘). -/
open GrammarLaws in
theorem review_line_local_bound {R E : «际» α} {l : List α} {g : Nat → α} {n : Nat}
    (noReturn : ∀ i, i ≤ n → ¬ «相续» R E (g i) (g i))
    (steps : ∀ i, i < n → «续» R E (g i) (g (i + 1))) (held : ∀ i, i ≤ n → g i ∈ l) :
    n < l.length :=
  match Nat.lt_or_ge n l.length with
  | .inl lt => lt
  | .inr ge =>
    match revisits_within l g (fun i le => held i (Nat.le_trans le ge)) with
    | ⟨i, _, lt, le, same⟩ => match gap_of_lt lt with
      | ⟨d, gap⟩ =>
        have within : i + (d + 1) ≤ n :=
          Eq.subst (motive := fun k => k ≤ n) gap (Nat.le_trans le ge)
        have reach : «相续» R E (g i) (g (i + (d + 1))) :=
          «线则及» (R := «续» R E) (fun k lt => steps k lt) d i within
        absurd (Eq.subst (motive := fun w => «相续» R E (g i) w)
          ((congrArg g gap).symm.trans same.symm) reach)
          (noReturn i (Nat.le_trans (Nat.le_trans (Nat.le_add_right i (d + 1)) (Nat.le_of_eq gap.symm)) (Nat.le_trans le ge)))

/-! ### 10. The converse of G11/G14 (CWS-P6+P7+P8-020, 「不爾，便無恒相持用」) fails: a class not
constant under which a line never ends. Counting up beside a lone point under the one. -/
theorem review_not_constant_yet_endless :
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
      | ⟨c, e⟩ => exact ⟨some (c + 1), Eq.subst (motive := fun w => R w (some (c + 1))) e.symm (fwd c), trivial⟩

/-! ### 11. ZL-01-099 「若無因而有萬物者，是則為常」 read in the grammar: an unconditioned
occurrence abides under no class (it begins under every class), so "no condition gives 常" is
false as read; the design pairs "no condition" with 斷 instead. -/
theorem review_unconditioned_not_abiding {R : «际» α} {y : α} (none : ∀ x, ¬ R x y) (E : «际» α) :
    ¬ «住» R E y :=
  fun ⟨⟨x, r, _⟩, _⟩ => none x r

end Checks

end Becoming
