import Becoming.WideningOnTheMap

/-!
# Transformative Viability Order (`Becoming.TransformativeViability`)

AI-written (Milestone 1C, 23 November 2026). Working names are used for the transformative
extension (`MacroAdmits`, `MacroIncludes`, `MacroExceeds`, `ReserveSafe`, `ReserveGuarded`,
`TransformativeViable`, `StrictTransformativeViable`, `TransformsViably`, `TransformsViablyAlong`).

## What this module establishes

1. **Macro-capability realization and reserve-guarded transformation**:
   - `Web.MacroAdmits W cap l t k` reads whether level configuration `l : C → Nat` admits at
     step `t` some formation `f` realizing macro capability `k`.
   - `TransformativeViable W Viable cap l l'` (and `StrictTransformativeViable`) compare two level
     paths by substrate viability `Viable l` and macro-capability inclusion/exceeding, separating
     genuine capability-preserving reconfiguration from both narrow by-name inclusion (`Web.Widens`)
     and reserve-destroying churn (`Steps.same` generation).
   - `widens_implies_transformativeViable` shows `Web.Widens` implies `TransformativeViable` under
     `ReserveGuarded W Viable`.
2. **Longitudinal transformation (`TransformsViably`) and `Web.Linked` succession**:
   - `TransformsViably W Safe cap T` requires substrate reserve safety (`ReserveSafe Safe T`),
     non-loss of realized macro capabilities across `T ≤ s ≤ t`, and genuine micro-turnover at
     every step from `T` (`∀ t, T ≤ t → ∃ f, W.Admits (W.level t) t f ∧ ¬ W.Admits (W.level (t + 1)) (t + 1) f`),
     excluding trivial stasis.
   - `TransformsViablyAlong W Safe cap R T` links succession cleanly to `Becoming.Web.Linked R`,
     with `TransformsViablyAlong.mono`, `transformsViably_iff_along_capSame`, and
     `not_along_itself_of_transformsViably`.
3. **Three-regime separation (`ThreeRegime`)**:
   - Explicitly separates `l_evolve` (strictly transformatively viable despite `W.Mixed l_evolve l_legacy`
     and `¬ W.Widens l_evolve l_legacy`), `l_legacy`, and `l_churn` (`W.Mixed l_churn l_legacy` with
     pure-generation `«全生成» Steps.next «一» (Steps.same QChurn) 1` yet `¬ TransformativeViable`).
4. **Finite balanced conserving transformation without keeping widening (`FiniteGainless`)**:
   - An explicit 3-condition finite `Conserving` → `Gainless`, `ClosedAt all`, `BalancesOn all`,
     `RequiresWithin all` web/flow satisfying `¬ web.KeepsWidening Web.itself web.level 0` (via
     `Becoming.Flow.whole_not_keepsWidening`), `TransformsViably web (fun t => 1 ≤ web.level t .cSub) cap 0`,
     and explicit step-by-step micro-turnover.

Every declaration has an empty axiom report and zero `sorry`.
-/

namespace Becoming

section MacroOrder

variable {F C K : Type}

namespace Web

variable (W : Web F C)

/-- Macro-capability admission: levels `l` admit at step `t` some formation realizing capability `k`. -/
def MacroAdmits (cap : F → K) (l : C → Nat) (t : Nat) (k : K) : Prop :=
  ∃ f, cap f = k ∧ W.Admits l t f

/-- Macro-capability inclusion: at every step, `l` realizes every capability `l'` realizes. -/
def MacroIncludes (cap : F → K) (l l' : Nat → C → Nat) : Prop :=
  ∀ t k, W.MacroAdmits cap (l' t) t k → W.MacroAdmits cap (l t) t k

/-- Macro-capability exceeding: at some step, `l` realizes a capability `l'` does not. -/
def MacroExceeds (cap : F → K) (l l' : Nat → C → Nat) : Prop :=
  ∃ t k, W.MacroAdmits cap (l t) t k ∧ ¬ W.MacroAdmits cap (l' t) t k

variable {W}

/-- Inclusion of admitted formations preserves every realized macro capability. -/
theorem Includes.macroIncludes {cap : F → K} {l l' : Nat → C → Nat} (inc : W.Includes l l') :
    W.MacroIncludes cap l l' :=
  fun t _ ⟨f, hcap, hadm⟩ => ⟨f, hcap, inc t f hadm⟩

theorem MacroIncludes.refl {cap : F → K} (l : Nat → C → Nat) : W.MacroIncludes cap l l :=
  fun _ _ h => h

theorem MacroIncludes.trans {cap : F → K} {l₁ l₂ l₃ : Nat → C → Nat}
    (h₁₂ : W.MacroIncludes cap l₁ l₂) (h₂₃ : W.MacroIncludes cap l₂ l₃) :
    W.MacroIncludes cap l₁ l₃ :=
  fun t k hk => h₁₂ t k (h₂₃ t k hk)

end Web

/-- Reserve safety from step `T` onward along a single-web trajectory. -/
def ReserveSafe (Safe : Nat → Prop) (T : Nat) : Prop :=
  ∀ t, T ≤ t → Safe t

/-- A viability predicate on level paths is reserve-guarded when widening a viable path preserves
    viability. -/
def ReserveGuarded (W : Web F C) (Viable : (Nat → C → Nat) → Prop) : Prop :=
  ∀ l l', W.Widens l l' → Viable l' → Viable l

/-- Transformative viability of `l` over `l'`: `l` stays reserve-viable and preserves all realized
    macro capabilities of `l'`. -/
def TransformativeViable (W : Web F C) (Viable : (Nat → C → Nat) → Prop) (cap : F → K)
    (l l' : Nat → C → Nat) : Prop :=
  Viable l ∧ W.MacroIncludes cap l l'

/-- Strict transformative viability: `l` is transformatively viable over `l'` and unlocks some macro
    capability `l'` lacks. -/
def StrictTransformativeViable (W : Web F C) (Viable : (Nat → C → Nat) → Prop) (cap : F → K)
    (l l' : Nat → C → Nat) : Prop :=
  TransformativeViable W Viable cap l l' ∧ W.MacroExceeds cap l l'

/-- Under `ReserveGuarded`, exact widening of a viable course implies transformative viability. -/
theorem widens_implies_transformativeViable {W : Web F C} {Viable : (Nat → C → Nat) → Prop}
    {cap : F → K} {l l' : Nat → C → Nat}
    (guarded : ReserveGuarded W Viable) (viable' : Viable l') (widens : W.Widens l l') :
    TransformativeViable W Viable cap l l' :=
  ⟨guarded l l' widens viable', Web.Includes.macroIncludes widens.1⟩

/-- Longitudinal transformative viability of `W.level` from `T`: reserves stay safe, every realized
    macro capability continues across `T ≤ s ≤ t`, and every step exhibits genuine micro-turnover
    (non-stasis). -/
def TransformsViably (W : Web F C) (Safe : Nat → Prop) (cap : F → K) (T : Nat) : Prop :=
  ReserveSafe Safe T ∧
    (∀ s t, T ≤ s → s ≤ t → ∀ k, W.MacroAdmits cap (W.level s) s k → W.MacroAdmits cap (W.level t) t k) ∧
    (∀ t, T ≤ t → ∃ f, W.Admits (W.level t) t f ∧ ¬ W.Admits (W.level (t + 1)) (t + 1) f)

/-- Transformative viability along an explicit formation continuation `R` via `Becoming.Web.Linked`. -/
def TransformsViablyAlong (W : Web F C) (Safe : Nat → Prop) (cap : F → K)
    (R : Nat → F → F → Prop) (T : Nat) : Prop :=
  ReserveSafe Safe T ∧
    (∀ s t, T ≤ s → s ≤ t → ∀ f, W.Admits (W.level s) s f →
      ∃ g, Web.Linked R s f t g ∧ W.Admits (W.level t) t g ∧ cap g = cap f) ∧
    (∀ t, T ≤ t → ∃ f, W.Admits (W.level t) t f ∧ ¬ W.Admits (W.level (t + 1)) (t + 1) f)

/-- Weakening-free monotonicity of `TransformsViablyAlong` under more continuation links. -/
theorem TransformsViablyAlong.mono {W : Web F C} {Safe : Nat → Prop} {cap : F → K}
    {R S : Nat → F → F → Prop} {T : Nat}
    (within : ∀ t g f, R t g f → S t g f) (tv : TransformsViablyAlong W Safe cap R T) :
    TransformsViablyAlong W Safe cap S T :=
  ⟨tv.1,
   fun s t hs hst f hadm => match tv.2.1 s t hs hst f hadm with
     | ⟨g, linked, hadm', hcap⟩ => ⟨g, Web.Linked.mono within linked, hadm', hcap⟩,
   tv.2.2⟩

/-- Any `TransformsViablyAlong` yields `TransformsViably`. -/
theorem TransformsViablyAlong.to_transformsViably {W : Web F C} {Safe : Nat → Prop} {cap : F → K}
    {R : Nat → F → F → Prop} {T : Nat} (tv : TransformsViablyAlong W Safe cap R T) :
    TransformsViably W Safe cap T :=
  ⟨tv.1,
   fun s t hs hst _ ⟨f, hcap, hadm⟩ => match tv.2.1 s t hs hst f hadm with
     | ⟨g, _, hadm', hsame⟩ => ⟨g, hsame.trans hcap, hadm'⟩,
   tv.2.2⟩

private theorem linked_capSame_steps {cap : F → K} {f g : F} (h : cap f = cap g) :
    ∀ k s : Nat, Web.Linked (fun _ a b => cap a = cap b) s f (s + k + 1) g
  | 0, s => .next h (.here (s + 1) g)
  | k + 1, s => .next rfl (congrArg (· + 1) (Nat.succ_add s k) ▸ linked_capSame_steps h k (s + 1))

private theorem linked_capSame_of_le {cap : F → K} {s t : Nat} {f g : F}
    (h : cap f = cap g) (lt : s < t) :
    Web.Linked (fun _ a b => cap a = cap b) s f t g := by
  obtain ⟨k, hk⟩ := le_dest lt
  have hk' : t = s + k + 1 := hk.trans (Nat.add_right_comm s 1 k)
  rw [hk']
  exact linked_capSame_steps h k s

/-- `TransformsViably` coincides with `TransformsViablyAlong` along the capability-preserving
    continuation `fun _ a b => cap a = cap b`. -/
theorem transformsViably_iff_along_capSame {W : Web F C} {Safe : Nat → Prop} {cap : F → K} {T : Nat} :
    TransformsViably W Safe cap T ↔
      TransformsViablyAlong W Safe cap (fun _ a b => cap a = cap b) T :=
  ⟨fun ⟨hsafe, hmacro, hturn⟩ =>
     ⟨hsafe,
      fun s t hs hst f hadm =>
        match Nat.eq_or_lt_of_le hst with
        | .inl same => by
          subst same
          exact ⟨f, .here s f, hadm, rfl⟩
        | .inr lt =>
          match hmacro s t hs hst (cap f) ⟨f, rfl, hadm⟩ with
          | ⟨g, hcap, hadm'⟩ => ⟨g, linked_capSame_of_le hcap.symm lt, hadm', hcap⟩,
      hturn⟩,
   TransformsViablyAlong.to_transformsViably⟩

/-- Micro-turnover rules out static by-name preservation along `Web.itself`. -/
theorem not_along_itself_of_transformsViably {W : Web F C} {Safe : Nat → Prop} {cap : F → K}
    {T : Nat} : ¬ TransformsViablyAlong W Safe cap Web.itself T := fun ⟨_, hlink, hturn⟩ =>
  match hturn T (Nat.le_refl T) with
  | ⟨f, hadm, noadm⟩ =>
    match hlink T (T + 1) (Nat.le_refl T) (Nat.le_succ T) f hadm with
    | ⟨_, linked, hadm', _⟩ => noadm ((Web.Linked.itself_same linked).2 ▸ hadm')

end MacroOrder

/-! ## Three-Regime Separation Witness (`ThreeRegime`) -/

namespace ThreeRegime

inductive Cond | cSub | cOld | cNew | cPlus
inductive Form | fSub | fOld | fNew | fPlus | fChurn (t : Nat)
inductive Cap | kSub | kFunc | kExtra

def cap : Form → Cap
  | .fSub => .kSub
  | .fOld => .kFunc
  | .fNew => .kFunc
  | .fPlus => .kExtra
  | .fChurn _ => .kExtra

private def natEq : Nat → Nat → Bool
  | 0 => fun | 0 => true | _ + 1 => false
  | n + 1 => fun | 0 => false | m + 1 => natEq n m

private theorem natEq_self : ∀ n : Nat, natEq n n = true
  | 0 => rfl
  | n + 1 => natEq_self n

private theorem natEq_succ_false : ∀ n : Nat, natEq (n + 1) n = false
  | 0 => rfl
  | n + 1 => natEq_succ_false n

def reqCond (_ : Nat) : Form → Cond → Prop
  | .fSub => fun | .cSub => True | .cOld => False | .cNew => False | .cPlus => False
  | .fOld => fun | .cSub => True | .cOld => True | .cNew => False | .cPlus => False
  | .fNew => fun | .cSub => True | .cOld => False | .cNew => True | .cPlus => False
  | .fPlus => fun | .cSub => True | .cOld => False | .cNew => False | .cPlus => True
  | .fChurn _ => fun | .cSub => False | .cOld => False | .cNew => False | .cPlus => True

def reqNeed (t : Nat) : Form → Cond → Nat
  | .fSub => fun | .cSub => 1 | .cOld => 0 | .cNew => 0 | .cPlus => 0
  | .fOld => fun | .cSub => 1 | .cOld => 1 | .cNew => 0 | .cPlus => 0
  | .fNew => fun | .cSub => 1 | .cOld => 0 | .cNew => 1 | .cPlus => 0
  | .fPlus => fun | .cSub => 1 | .cOld => 0 | .cNew => 0 | .cPlus => 1
  | .fChurn k => fun | .cSub => 0 | .cOld => 0 | .cNew => 0 | .cPlus => if natEq t k then 1 else 2

def l_legacy (_ : Nat) : Cond → Nat
  | .cSub => 1
  | .cOld => 1
  | .cNew => 0
  | .cPlus => 0

def l_evolve (_ : Nat) : Cond → Nat
  | .cSub => 1
  | .cOld => 0
  | .cNew => 1
  | .cPlus => 1

def l_churn (_ : Nat) : Cond → Nat
  | .cSub => 0
  | .cOld => 0
  | .cNew => 0
  | .cPlus => 1

def web : Web Form Cond where
  level := l_evolve
  active _ _ := True
  requires := reqCond
  need := reqNeed
  draws := reqCond

def Viable (l : Nat → Cond → Nat) : Prop :=
  ∀ t, 1 ≤ l t .cSub

def QChurn (t : Nat) (f : Form) : Prop :=
  web.Admits (l_churn t) t f

private theorem legacy_admits_sub (t : Nat) : web.Admits (l_legacy t) t .fSub := by
  intro c hreq
  cases c with
  | cSub => exact Nat.le_refl 1
  | cOld | cNew | cPlus => exact False.elim hreq

private theorem legacy_admits_old (t : Nat) : web.Admits (l_legacy t) t .fOld := by
  intro c hreq
  cases c with
  | cSub | cOld => exact Nat.le_refl 1
  | cNew | cPlus => exact False.elim hreq

private theorem evolve_admits_sub (t : Nat) : web.Admits (l_evolve t) t .fSub := by
  intro c hreq
  cases c with
  | cSub => exact Nat.le_refl 1
  | cOld | cNew | cPlus => exact False.elim hreq

private theorem evolve_admits_new (t : Nat) : web.Admits (l_evolve t) t .fNew := by
  intro c hreq
  cases c with
  | cSub | cNew => exact Nat.le_refl 1
  | cOld | cPlus => exact False.elim hreq

private theorem evolve_admits_plus (t : Nat) : web.Admits (l_evolve t) t .fPlus := by
  intro c hreq
  cases c with
  | cSub | cPlus => exact Nat.le_refl 1
  | cOld | cNew => exact False.elim hreq

private theorem churn_admits_at (t : Nat) : web.Admits (l_churn t) t (.fChurn t) := by
  intro c hreq
  cases c with
  | cPlus =>
    show (if natEq t t then 1 else 2) ≤ 1
    rw [natEq_self t]
    exact Nat.le_refl 1
  | cSub | cOld | cNew => exact False.elim hreq

private theorem churn_not_admits_next (t : Nat) : ¬ web.Admits (l_churn (t + 1)) (t + 1) (.fChurn t) := by
  intro hadm
  have hle : (if natEq (t + 1) t then 1 else 2) ≤ 1 := hadm .cPlus trivial
  rw [natEq_succ_false t] at hle
  exact Nat.not_le_of_gt (by decide : 1 < 2) hle

private theorem legacy_not_admits_new (t : Nat) : ¬ web.Admits (l_legacy t) t .fNew := by
  intro hadm
  exact Nat.not_le_of_gt (Nat.succ_pos 0) (hadm .cNew trivial)

private theorem legacy_not_admits_plus (t : Nat) : ¬ web.Admits (l_legacy t) t .fPlus := by
  intro hadm
  exact Nat.not_le_of_gt (Nat.succ_pos 0) (hadm .cPlus trivial)

private theorem legacy_not_admits_churn (t k : Nat) : ¬ web.Admits (l_legacy t) t (.fChurn k) := by
  intro hadm
  have hle : reqNeed t (.fChurn k) .cPlus ≤ 0 := hadm .cPlus trivial
  cases h : natEq t k with
  | true =>
    have h1 : (if natEq t k then 1 else 2) ≤ 0 := hle
    rw [h] at h1
    exact Nat.not_le_of_gt (Nat.succ_pos 0) h1
  | false =>
    have h2 : (if natEq t k then 1 else 2) ≤ 0 := hle
    rw [h] at h2
    exact Nat.not_le_of_gt (by decide : 0 < 2) h2

private theorem evolve_not_admits_old (t : Nat) : ¬ web.Admits (l_evolve t) t .fOld := by
  intro hadm
  exact Nat.not_le_of_gt (Nat.succ_pos 0) (hadm .cOld trivial)

private theorem churn_not_admits_sub (t : Nat) : ¬ web.Admits (l_churn t) t .fSub := by
  intro hadm
  exact Nat.not_le_of_gt (Nat.succ_pos 0) (hadm .cSub trivial)

private theorem churn_not_admits_old (t : Nat) : ¬ web.Admits (l_churn t) t .fOld := by
  intro hadm
  exact Nat.not_le_of_gt (Nat.succ_pos 0) (hadm .cSub trivial)

private theorem churn_not_admits_new (t : Nat) : ¬ web.Admits (l_churn t) t .fNew := by
  intro hadm
  exact Nat.not_le_of_gt (Nat.succ_pos 0) (hadm .cSub trivial)

private theorem churn_not_admits_plus (t : Nat) : ¬ web.Admits (l_churn t) t .fPlus := by
  intro hadm
  exact Nat.not_le_of_gt (Nat.succ_pos 0) (hadm .cSub trivial)

theorem evolve_mixed_legacy : web.Mixed l_evolve l_legacy :=
  ⟨⟨0, .fNew, evolve_admits_new 0, legacy_not_admits_new 0⟩,
   ⟨0, .fOld, legacy_admits_old 0, evolve_not_admits_old 0⟩⟩

theorem evolve_not_widens_legacy : ¬ web.Widens l_evolve l_legacy :=
  fun widens => Web.Widens.not_mixed widens evolve_mixed_legacy

theorem evolve_strict_transformativeViable :
    StrictTransformativeViable web Viable cap l_evolve l_legacy := by
  refine ⟨⟨fun _ => Nat.le_refl 1, ?_⟩, ?_⟩
  · intro t k ⟨f, hcap, hadm⟩
    cases f with
    | fSub => exact ⟨.fSub, hcap, evolve_admits_sub t⟩
    | fOld => exact ⟨.fNew, hcap, evolve_admits_new t⟩
    | fNew => exact absurd hadm (legacy_not_admits_new t)
    | fPlus => exact absurd hadm (legacy_not_admits_plus t)
    | fChurn m => exact absurd hadm (legacy_not_admits_churn t m)
  · refine ⟨0, .kExtra, ⟨.fPlus, rfl, evolve_admits_plus 0⟩, ?_⟩
    intro ⟨f, hcap, hadm⟩
    cases f with
    | fSub => cases hcap
    | fOld => cases hcap
    | fNew => cases hcap
    | fPlus => exact legacy_not_admits_plus 0 hadm
    | fChurn m => exact legacy_not_admits_churn 0 m hadm

theorem churn_mixed_legacy : web.Mixed l_churn l_legacy :=
  ⟨⟨0, .fChurn 0, churn_admits_at 0, legacy_not_admits_churn 0 0⟩,
   ⟨0, .fSub, legacy_admits_sub 0, churn_not_admits_sub 0⟩⟩

theorem churn_generation : «全生成» Steps.next «一» (Steps.same QChurn) 1 :=
  Steps.generation_iff_begins.mpr fun y hy => by
    obtain ⟨n, hn⟩ := le_dest hy
    have hyn : y = n + 1 := hn.trans (Nat.add_comm 1 n)
    refine ⟨n + 1, Nat.le_of_eq hyn, Steps.begins_iff.mpr fun hsame => ?_⟩
    exact churn_not_admits_next (n + 1) ((hsame (.fChurn (n + 1))).mp (churn_admits_at (n + 1)))

theorem churn_not_transformativeViable : ¬ TransformativeViable web Viable cap l_churn l_legacy := by
  intro ⟨hviable, _⟩
  exact Nat.not_le_of_gt (Nat.succ_pos 0) (hviable 0)

theorem churn_also_fails_macroIncludes : ¬ web.MacroIncludes cap l_churn l_legacy := by
  intro hinc
  match hinc 0 .kSub ⟨.fSub, rfl, legacy_admits_sub 0⟩ with
  | ⟨f, hcap, hadm⟩ =>
    cases f with
    | fSub => exact churn_not_admits_sub 0 hadm
    | fOld => cases hcap
    | fNew => cases hcap
    | fPlus => cases hcap
    | fChurn _ => cases hcap

/-- Full separation of transformative viability from exact widening and destructive churn. -/
theorem three_regime_separation :
    web.Mixed l_evolve l_legacy ∧
    ¬ web.Widens l_evolve l_legacy ∧
    StrictTransformativeViable web Viable cap l_evolve l_legacy ∧
    web.Mixed l_churn l_legacy ∧
    «全生成» Steps.next «一» (Steps.same QChurn) 1 ∧
    ¬ TransformativeViable web Viable cap l_churn l_legacy :=
  ⟨evolve_mixed_legacy,
   evolve_not_widens_legacy,
   evolve_strict_transformativeViable,
   churn_mixed_legacy,
   churn_generation,
   churn_not_transformativeViable⟩

end ThreeRegime

/-! ## Finite Balanced Conserving Transformation Witness (`FiniteGainless`) -/

namespace FiniteGainless

inductive Cond | cSub | cA | cB
inductive Form | fSub | fA | fB
inductive Cap | kSub | kWork

def all : List Cond := [.cSub, .cA, .cB]

theorem every : ∀ c : Cond, c ∈ all
  | .cSub => .head _
  | .cA => .tail _ (.head _)
  | .cB => .tail _ (.tail _ (.head _))

theorem distinct : Distinct all :=
  ⟨(fun mem => match mem with | .tail _ (.tail _ no) => nomatch no),
   ⟨(fun mem => match mem with | .tail _ no => nomatch no),
    ⟨(fun no => nomatch no), trivial⟩⟩⟩

def cap : Form → Cap
  | .fSub => .kSub
  | .fA => .kWork
  | .fB => .kWork

def flip : Nat → Bool
  | 0 => true
  | t + 1 => ! flip t

def level (t : Nat) : Cond → Nat
  | .cSub => 1
  | .cA => if flip t then 1 else 0
  | .cB => if flip t then 0 else 1

def requires (_ : Nat) : Form → Cond → Prop
  | .fSub => fun | .cSub => True | .cA => False | .cB => False
  | .fA => fun | .cSub => False | .cA => True | .cB => False
  | .fB => fun | .cSub => False | .cA => False | .cB => True

def need (_ : Nat) : Form → Cond → Nat
  | .fSub => fun | .cSub => 1 | .cA => 0 | .cB => 0
  | .fA => fun | .cSub => 0 | .cA => 1 | .cB => 0
  | .fB => fun | .cSub => 0 | .cA => 0 | .cB => 1

def web : Web Form Cond where
  level := level
  active _ _ := True
  requires := requires
  need := need
  draws := requires

def takeFn (t : Nat) : Form → Cond → Nat
  | .fA => fun | .cSub => 0 | .cA => if flip t then 1 else 0 | .cB => if flip t then 0 else 1
  | .fSub => fun _ => 0
  | .fB => fun _ => 0

def giveFn (t : Nat) : Form → Cond → Nat
  | .fA => fun | .cSub => 0 | .cA => if flip t then 0 else 1 | .cB => if flip t then 1 else 0
  | .fSub => fun _ => 0
  | .fB => fun _ => 0

def flow : Flow Form Cond where
  present _ := [.fA]
  take := takeFn
  give := giveFn

-- Zero-axiom decidable membership helper avoiding `by_cases` (`propext`/`Classical.propDecidable`).
private theorem cond_eq_or_ne : ∀ a c : Cond, a = c ∨ a ≠ c
  | .cSub, .cSub | .cA, .cA | .cB, .cB => .inl rfl
  | .cSub, .cA | .cSub, .cB | .cA, .cSub | .cA, .cB | .cB, .cSub | .cB, .cA =>
    .inr fun h => nomatch h

private theorem cond_mem_or_not (c : Cond) : ∀ l : List Cond, c ∈ l ∨ ¬ c ∈ l
  | [] => .inr fun no => nomatch no
  | a :: as =>
    match cond_eq_or_ne a c with
    | .inl eq => .inl (eq ▸ .head _)
    | .inr ne =>
      match cond_mem_or_not c as with
      | .inl m => .inl (.tail _ m)
      | .inr nm => .inr fun m => match m with | .head _ => ne rfl | .tail _ m' => nm m'

private theorem cond_mem_of_ne_zero {cs : List Cond} {c : Cond} {q : Cond → Nat}
    (closed : ∀ d, ¬ d ∈ cs → q d = 0) (pos : 0 < q c) : c ∈ cs :=
  match cond_mem_or_not c cs with
  | .inl m => m
  | .inr nm => absurd (Eq.subst (motive := fun n => 0 < n) (closed c nm) pos) (Nat.lt_irrefl 0)

private theorem total_eq_at_of_distinct {x : Cond} {q : Cond → Nat} :
    ∀ {cs : List Cond}, Distinct cs → x ∈ cs → (∀ d, d ≠ x → q d = 0) → total cs q = q x
  | [], _, mem, _ => nomatch mem
  | a :: as, ⟨fresh, dist⟩, mem, zero => by
    cases mem with
    | head =>
      have rest0 : total as q = 0 := total_eq_zero fun d md =>
        zero d fun same => fresh (same ▸ md)
      exact (congrArg (q x + ·) rest0).trans (Nat.add_zero (q x))
    | tail _ mem' =>
      have hne : a ≠ x := fun same => fresh (same ▸ mem')
      exact (congrArg (· + total as q) (zero a hne)).trans
        ((Nat.zero_add _).trans (total_eq_at_of_distinct dist mem' zero))

theorem conserving : flow.Conserving := by
  intro cs t dist closed f hf
  have hf' : f ∈ [.fA] := hf
  have hfA : f = .fA := by
    cases hf' with
    | head => rfl
    | tail _ no => nomatch no
  subst hfA
  cases hflip : flip t with
  | true =>
    have hg_zero : ∀ d, d ≠ .cB → giveFn t .fA d = 0 := fun d hne => by
      cases d with
      | cSub => rfl
      | cA => show (if flip t then 0 else 1) = 0; rw [hflip]; rfl
      | cB => exact absurd rfl hne
    have ht_zero : ∀ d, d ≠ .cA → takeFn t .fA d = 0 := fun d hne => by
      cases d with
      | cSub => rfl
      | cA => exact absurd rfl hne
      | cB => show (if flip t then 0 else 1) = 0; rw [hflip]; rfl
    have hg_pos : 0 < giveFn t .fA .cB := by
      show 0 < (if flip t then 1 else 0)
      rw [hflip]
      exact Nat.one_pos
    have ht_pos : 0 < takeFn t .fA .cA := by
      show 0 < (if flip t then 1 else 0)
      rw [hflip]
      exact Nat.one_pos
    have hcB : .cB ∈ cs := cond_mem_of_ne_zero (fun d hd => (closed .fA hf d hd).2) hg_pos
    have hcA : .cA ∈ cs := cond_mem_of_ne_zero (fun d hd => (closed .fA hf d hd).1) ht_pos
    have hgive : total cs (giveFn t .fA) = 1 := by
      rw [total_eq_at_of_distinct dist hcB hg_zero]
      show (if flip t then 1 else 0) = 1
      rw [hflip]; rfl
    have htake : total cs (takeFn t .fA) = 1 := by
      rw [total_eq_at_of_distinct dist hcA ht_zero]
      show (if flip t then 1 else 0) = 1
      rw [hflip]; rfl
    exact hgive.trans htake.symm
  | false =>
    have hg_zero : ∀ d, d ≠ .cA → giveFn t .fA d = 0 := fun d hne => by
      cases d with
      | cSub => rfl
      | cA => exact absurd rfl hne
      | cB => show (if flip t then 1 else 0) = 0; rw [hflip]; rfl
    have ht_zero : ∀ d, d ≠ .cB → takeFn t .fA d = 0 := fun d hne => by
      cases d with
      | cSub => rfl
      | cA => show (if flip t then 1 else 0) = 0; rw [hflip]; rfl
      | cB => exact absurd rfl hne
    have hg_pos : 0 < giveFn t .fA .cA := by
      show 0 < (if flip t then 0 else 1)
      rw [hflip]
      exact Nat.one_pos
    have ht_pos : 0 < takeFn t .fA .cB := by
      show 0 < (if flip t then 0 else 1)
      rw [hflip]
      exact Nat.one_pos
    have hcA : .cA ∈ cs := cond_mem_of_ne_zero (fun d hd => (closed .fA hf d hd).2) hg_pos
    have hcB : .cB ∈ cs := cond_mem_of_ne_zero (fun d hd => (closed .fA hf d hd).1) ht_pos
    have hgive : total cs (giveFn t .fA) = 1 := by
      rw [total_eq_at_of_distinct dist hcA hg_zero]
      show (if flip t then 0 else 1) = 1
      rw [hflip]; rfl
    have htake : total cs (takeFn t .fA) = 1 := by
      rw [total_eq_at_of_distinct dist hcB ht_zero]
      show (if flip t then 0 else 1) = 1
      rw [hflip]; rfl
    exact hgive.trans htake.symm

theorem gainless : flow.Gainless :=
  conserving.gainless

theorem closed (t : Nat) : flow.ClosedAt all t :=
  fun _ _ c out => absurd (every c) out

theorem balances (t : Nat) : flow.BalancesOn web all t := by
  intro c _
  show level (t + 1) c + (takeFn t .fA c + 0) = level t c + (giveFn t .fA c + 0)
  rw [Nat.add_zero, Nat.add_zero]
  cases c with
  | cSub => rfl
  | cA =>
    show (if ! flip t then 1 else 0) + (if flip t then 1 else 0) =
         (if flip t then 1 else 0) + (if flip t then 0 else 1)
    cases flip t <;> rfl
  | cB =>
    show (if ! flip t then 0 else 1) + (if flip t then 0 else 1) =
         (if flip t then 0 else 1) + (if flip t then 1 else 0)
    cases flip t <;> rfl

theorem requiresWithin : ∀ t f, 0 ≤ t → web.Supported t f → web.RequiresWithin all f :=
  fun _ _ _ _ _ _ c hreq => ⟨hreq, rfl, every c⟩

theorem not_keepsWidening : ¬ web.KeepsWidening Web.itself web.level 0 :=
  Flow.whole_not_keepsWidening every distinct gainless (T₀ := 0) (fun t _ => balances t) requiresWithin

private theorem admits_sub (t : Nat) : web.Admits (web.level t) t .fSub := by
  intro c hreq
  cases c with
  | cSub => exact Nat.le_refl 1
  | cA | cB => exact False.elim hreq

private theorem admits_A_of_true {t : Nat} (h : flip t = true) :
    web.Admits (web.level t) t .fA := by
  intro c hreq
  cases c with
  | cA =>
    show 1 ≤ (if flip t then 1 else 0)
    rw [h]
    exact Nat.le_refl 1
  | cSub | cB => exact False.elim hreq

private theorem not_admits_A_of_false {t : Nat} (h : flip t = false) :
    ¬ web.Admits (web.level t) t .fA := by
  intro hadm
  have hle : 1 ≤ (if flip t then 1 else 0) := hadm .cA trivial
  rw [h] at hle
  exact Nat.not_le_of_gt Nat.one_pos hle

private theorem admits_B_of_false {t : Nat} (h : flip t = false) :
    web.Admits (web.level t) t .fB := by
  intro c hreq
  cases c with
  | cB =>
    show 1 ≤ (if flip t then 0 else 1)
    rw [h]
    exact Nat.le_refl 1
  | cSub | cA => exact False.elim hreq

private theorem not_admits_B_of_true {t : Nat} (h : flip t = true) :
    ¬ web.Admits (web.level t) t .fB := by
  intro hadm
  have hle : 1 ≤ (if flip t then 0 else 1) := hadm .cB trivial
  rw [h] at hle
  exact Nat.not_le_of_gt Nat.one_pos hle

theorem micro_turnover (t : Nat) :
    ∃ f, web.Admits (web.level t) t f ∧ ¬ web.Admits (web.level (t + 1)) (t + 1) f := by
  cases h : flip t with
  | true =>
    have hnext : flip (t + 1) = false := by show (! flip t) = false; rw [h]; rfl
    exact ⟨.fA, admits_A_of_true h, not_admits_A_of_false hnext⟩
  | false =>
    have hnext : flip (t + 1) = true := by show (! flip t) = true; rw [h]; rfl
    exact ⟨.fB, admits_B_of_false h, not_admits_B_of_true hnext⟩

theorem transformsViably : TransformsViably web (fun t => 1 ≤ web.level t .cSub) cap 0 := by
  refine ⟨fun _ _ => Nat.le_refl 1, ?_, fun t _ => micro_turnover t⟩
  intro _ t _ _ k _
  cases k with
  | kSub => exact ⟨.fSub, rfl, admits_sub t⟩
  | kWork =>
    cases h : flip t with
    | true => exact ⟨.fA, rfl, admits_A_of_true h⟩
    | false => exact ⟨.fB, rfl, admits_B_of_false h⟩

theorem along_capSame :
    TransformsViablyAlong web (fun t => 1 ≤ web.level t .cSub) cap (fun _ a b => cap a = cap b) 0 :=
  transformsViably_iff_along_capSame.mp transformsViably

theorem not_along_itself :
    ¬ TransformsViablyAlong web (fun t => 1 ≤ web.level t .cSub) cap Web.itself 0 :=
  not_along_itself_of_transformsViably

/-- Main finite balanced conserving transformation theorem: no keeping-widening by name, yet
    viable reserve preservation, macro-capability persistence, and genuine step-by-step
    micro-turnover. -/
theorem finite_gainless_transformsViably :
    flow.Conserving ∧
    flow.Gainless ∧
    (∀ t, flow.ClosedAt all t) ∧
    (∀ t, flow.BalancesOn web all t) ∧
    (∀ t f, 0 ≤ t → web.Supported t f → web.RequiresWithin all f) ∧
    ¬ web.KeepsWidening Web.itself web.level 0 ∧
    TransformsViably web (fun t => 1 ≤ web.level t .cSub) cap 0 ∧
    (∀ t, ∃ f, web.Admits (web.level t) t f ∧ ¬ web.Admits (web.level (t + 1)) (t + 1) f) :=
  ⟨conserving, gainless, closed, balances, requiresWithin,
   not_keepsWidening, transformsViably, micro_turnover⟩

end FiniteGainless

end Becoming
