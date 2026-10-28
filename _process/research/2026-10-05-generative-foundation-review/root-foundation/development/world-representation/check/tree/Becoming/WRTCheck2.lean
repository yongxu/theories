import Becoming.Persistence
import Becoming.Amounts
import Becoming.Diagonal

/-!
# Scratch check of the WRT design's revision (not a landed module)

The statements the revision adds after the first review: «尽» pulled back along a map carrying
continuation on a closed region; F3 from the amounts' law of falls ending (`Amounts.falls_end` at
whole numbers); amount-induced relations decided, and conservation exactly `Q` on one relatum where
`Q` is decided; a family of worlds whose occurrence models agree while their standings differ;
carrying of the same-step relations and of presence by a re-identification; the no-injection lemma
from `Diagonal.claims_incomplete`; conservation realized from labels; carrying stated through «像».
-/

namespace Becoming

namespace WRTCheck2

/-! ## «尽» reflects along a map carrying continuation on a closed region -/

theorem jin_pullback {α κ : Type} {R L : «际» α} {R' L' : «际» κ} (φ : α → κ) (P : α → Prop)
    (carries : ∀ x y, P x → «续» R L x y → P y ∧ «续» R' L' (φ x) (φ y)) :
    ∀ x, P x → «尽» R' L' (φ x) → «尽» R L x := by
  have key : ∀ a, «尽» R' L' a → ∀ x, φ x = a → P x → «尽» R L x := by
    intro a h
    induction h with
    | mk _ ih =>
      intro x same hx
      exact .mk fun y c =>
        match carries x y hx c with
        | ⟨hy, c'⟩ => ih (φ y) (Eq.subst (motive := fun b => «续» R' L' b (φ y)) same c') y rfl hy
  exact fun x hx h => key (φ x) h x rfl hx

/-! ## F3: a line of falls ends, from the amounts' law -/

/-- The level of an occurrence's relatum falls across the step from it. -/
def falling (w : World) (x : Nat × w.Relatum) : Prop :=
  w.web.Falls x.1 x.2

/-- **A line of falls ends (尽)**: the levels along it are a course of falls of a whole amount, which
ends (`Amounts.falls_end` at `Amounts.whole`, least loss one). -/
theorem falls_exhaust (w : World) (x : Nat × w.Relatum) (falls : falling w x) :
    «尽» Steps.along (Web.alikeBy (falling w)) x :=
  jin_pullback (R' := «而» («所闭» (fun a b => Amounts.whole.le b a))
      (fun a b => Amounts.whole.le (Amounts.whole.add b 1) a)) (L' := «一»)
    (fun y => w.web.level y.1 y.2) (falling w)
    (fun x y hx c => by
      cases y with
      | mk s g =>
        cases c with
        | intro along alike =>
          cases along with
          | intro h₁ h₂ =>
            cases h₁; cases h₂
            exact ⟨alike.mp hx, ⟨w.web.level x.1 x.2, fun _ _ held => held, hx⟩, trivial⟩)
    x falls
    (Amounts.falls_end (M := Amounts.whole) (ε := 1) (w.web.level x.1 x.2 + 1) (w.web.level x.1 x.2)
      (Amounts.whole_within (w.web.level x.1 x.2)))

theorem falls_not_endless (w : World) (x : Nat × w.Relatum) (falls : falling w x) :
    ¬ «不穷» Steps.along (Web.alikeBy (falling w)) x :=
  «尽则非不穷» (falls_exhaust w x falls)

/-! ## Decidedness: what amounts induce is decided -/

theorem conserves_decided (w : World) (t : Nat) (g f : w.Relatum) :
    w.Conserves t g f ∨ ¬ w.Conserves t g f :=
  match Nat.decEq (w.web.level (t + 1) f + w.flow.taken t g) (w.web.level t g + w.flow.given t g) with
  | isTrue h => Or.inl h
  | isFalse h => Or.inr h

/-- **Some world on one relatum has conservation `Q` across every step exactly where `Q` is
decided.** -/
theorem conservation_iff_decided (Q : Prop) :
    (∃ (L : Flow Unit Unit) (W : Web Unit Unit), ∀ t, (World.of Unit L W).Conserves t () () ↔ Q) ↔
      (Q ∨ ¬ Q) :=
  ⟨fun ⟨L, W, h⟩ => match conserves_decided (World.of Unit L W) 0 () () with
     | .inl c => Or.inl ((h 0).mp c)
     | .inr n => Or.inr fun q => n ((h 0).mpr q),
   fun d => match d with
     | .inl q => ⟨Flow.still, Witnesses.unrequired (fun _ _ => 0) (fun _ _ => False),
         fun _ => ⟨fun _ => q, fun _ => rfl⟩⟩
     | .inr nq => ⟨⟨fun _ => [()], fun _ _ _ => 1, fun _ _ _ => 0⟩,
         Witnesses.unrequired (fun _ _ => 0) (fun _ _ => False),
         fun _ => ⟨fun c => absurd c (fun h => Nat.noConfusion h), fun q => absurd q nq⟩⟩⟩

/-! ## The model forgets the standing -/

/-- One relatum, never active, standing at `k` throughout, with nothing exchanged. -/
def standingAt (k : Nat) : World :=
  World.of Unit Flow.still (Witnesses.unrequired (fun _ _ => k) fun _ _ => False)

/-- **Every relation and partial identity of the occurrence model agrees between two positive
standings.** -/
theorem standingAt_alike {k k' : Nat} (pos : 0 < k) (pos' : 0 < k') (t : Nat) :
    ((standingAt k).web.active t () ↔ (standingAt k').web.active t ()) ∧
    (0 < (standingAt k).web.level t () ↔ 0 < (standingAt k').web.level t ()) ∧
    ((standingAt k).web.requires t () () ↔ (standingAt k').web.requires t () ()) ∧
    ((standingAt k).web.draws t () () ↔ (standingAt k').web.draws t () ()) ∧
    ((() ∈ (standingAt k).flow.present t) ↔ (() ∈ (standingAt k').flow.present t)) ∧
    ((standingAt k).web.need t () () ≤ (standingAt k).web.level t () ↔
      (standingAt k').web.need t () () ≤ (standingAt k').web.level t ()) ∧
    (0 < (standingAt k).flow.give t () () ↔ 0 < (standingAt k').flow.give t () ()) ∧
    (0 < (standingAt k).flow.take t () () ↔ 0 < (standingAt k').flow.take t () ()) ∧
    ((standingAt k).Conserves t () () ↔ (standingAt k').Conserves t () ()) ∧
    ((standingAt k).web.Falls t () ↔ (standingAt k').web.Falls t ()) ∧
    (standingAt k).web.level t () = k :=
  ⟨Iff.rfl, ⟨fun _ => pos', fun _ => pos⟩, Iff.rfl, Iff.rfl, Iff.rfl,
   ⟨fun _ => Nat.zero_le _, fun _ => Nat.zero_le _⟩, Iff.rfl,
   Iff.rfl, ⟨fun _ => rfl, fun _ => rfl⟩,
   ⟨fun h => absurd h (Nat.lt_irrefl k), fun h => absurd h (Nat.lt_irrefl k')⟩, rfl⟩

/-! ## Carrying by a re-identification -/

/-- A relation within each step, read on occurrences. -/
def withinStep {R : Type} (r : Nat → R → R → Prop) : «际» (Nat × R) :=
  fun x y => x.1 = y.1 ∧ r x.1 x.2 y.2

theorem withinStep_carried {R R' : Type} (σ : Reidentify R R') {r : Nat → R → R → Prop}
    {r' : Nat → R' → R' → Prop} (pointwise : ∀ t x y, r' t x y ↔ r t (σ.old t x) (σ.old t y))
    (x y : Nat × R') :
    withinStep r' x y ↔ withinStep r (x.1, σ.old x.1 x.2) (y.1, σ.old y.1 y.2) :=
  ⟨fun ⟨same, h⟩ => ⟨same, Eq.subst (motive := fun s => r x.1 (σ.old x.1 x.2) (σ.old s y.2)) same
      ((pointwise _ _ _).mp h)⟩,
   fun ⟨same, h⟩ => ⟨same, (pointwise _ _ _).mpr
      (Eq.subst (motive := fun s => r x.1 (σ.old x.1 x.2) (σ.old s y.2)) same.symm h)⟩⟩

/-- The same-step relations of a re-identified world, here requiring, are carried. -/
theorem requires_carried {w : World} {R' : Type} (σ : Reidentify w.Relatum R') (x y : Nat × R') :
    withinStep (w.reidentify σ).web.requires x y ↔
      withinStep w.web.requires (x.1, σ.old x.1 x.2) (y.1, σ.old y.1 y.2) :=
  withinStep_carried σ (fun _ _ _ => Iff.rfl) x y

/-- Presence is carried: a relatum is present in the re-identified world's move exactly where the
relatum it names is present in the world's. -/
theorem present_carried {w : World} {R' : Type} (σ : Reidentify w.Relatum R') (t : Nat) (x : R') :
    x ∈ (w.reidentify σ).flow.present t ↔ σ.old t x ∈ w.flow.present t :=
  Reidentify.mem_map σ t

/-! ## The diagonal lemma reused -/

theorem no_injection (i : (Nat → Prop) → Nat) (inj : ∀ A B, i A = i B → A = B) : False :=
  Diagonal.claims_incomplete (fun n m => ∃ B, i B = n ∧ B m)
    (fun g => ⟨i g, fun m => ⟨fun ⟨B, same, b⟩ => Eq.subst (motive := fun C => C m) (inj B g same) b,
      fun gm => ⟨g, rfl, gm⟩⟩⟩)

/-! ## Conservation realized from labels -/

/-- The world on relata `R` with one relatum `r₀` exchanging, whose standings are `level` and whose
exchange makes `g` conserve into exactly the relata standing after the step at `target t g`. -/
def ofLabels {R : Type} (r₀ : R) (level : Nat → R → Nat) (target : Nat → R → Option Nat) : World :=
  World.of R
    ⟨fun _ => [r₀],
     fun t _ g => match target t g with | some _ => level t g | none => level t g + 1,
     fun t _ g => match target t g with | some n => n | none => 0⟩
    (Witnesses.unrequired level fun _ _ => False)

/-- **Every relation labelled by standings is some world's conservation.** -/
theorem ofLabels_conserves {R : Type} (r₀ : R) (level : Nat → R → Nat) (target : Nat → R → Option Nat)
    (t : Nat) (g f : R) :
    (ofLabels r₀ level target).Conserves t g f ↔ target t g = some (level (t + 1) f) := by
  show level (t + 1) f + ((match target t g with | some _ => level t g | none => level t g + 1) + 0) =
      level t g + ((match target t g with | some n => n | none => 0) + 0) ↔ target t g = some (level (t + 1) f)
  cases target t g with
  | none => exact ⟨fun h => absurd (Nat.le_of_eq h)
      (Nat.not_le_of_lt (Nat.lt_of_lt_of_le (Nat.lt_succ_self (level t g)) (Nat.le_add_left _ _))),
      fun h => nomatch h⟩
  | some n => exact ⟨fun h => congrArg some
      (add_right_cancel (level t g) (h.trans (Nat.add_comm (level t g) n))).symm,
      fun h => Eq.subst (motive := fun m => level (t + 1) f + (level t g + 0) = level t g + (m + 0))
        (Option.some.inj h).symm (Nat.add_comm (level (t + 1) f) (level t g))⟩

/-- The world on relata `R` with one relatum `r₀` exchanging, whose standings are `level`, and where,
across the step from `t`, `g` is credited `credit t g` and debited `debit t g`. -/
def ofExchange {R : Type} (r₀ : R) (level credit debit : Nat → R → Nat) : World :=
  World.of R ⟨fun _ => [r₀], fun t _ g => debit t g + level t g, fun t _ g => credit t g⟩
    (Witnesses.unrequired level fun _ _ => False)

/-- **Conservation is exactly a relation of this form**: `f` after the step, with `g`'s debit, is
`g`'s credit. Every world's conservation has it (credit the standing with what is given, debit
what is taken), and every such relation is some world's. -/
theorem ofExchange_conserves {R : Type} (r₀ : R) (level credit debit : Nat → R → Nat) (t : Nat)
    (g f : R) :
    (ofExchange r₀ level credit debit).Conserves t g f ↔ level (t + 1) f + debit t g = credit t g :=
  ⟨fun h => add_right_cancel (level t g)
      ((Nat.add_assoc (level (t + 1) f) (debit t g) (level t g)).trans
        (h.trans (Nat.add_comm (level t g) (credit t g)))),
   fun h => (Nat.add_assoc (level (t + 1) f) (debit t g) (level t g)).symm.trans
      ((congrArg (· + level t g) h).trans (Nat.add_comm (credit t g) (level t g)))⟩

/-! ## Carrying through «像» -/

/-- A one-to-one correspondence of carriers. -/
structure Corr (α β : Type) where
  to : α → β
  back : β → α
  back_to : ∀ x, back (to x) = x
  to_back : ∀ y, to (back y) = y

/-- **Carrying, read through the grammar's image.** The image of `R` along a one-to-one
correspondence is `R'` exactly where two things are related by `R` exactly where their images are
related by `R'`. -/
theorem carries_iff_image {α β : Type} (e : Corr α β) (R : «际» α) (R' : «际» β) :
    «谓» («像» e.to R) R' ↔ ∀ x y, R x y ↔ R' (e.to x) (e.to y) :=
  ⟨fun same x y =>
    ⟨fun r => (same (e.to x) (e.to y)).mp ⟨x, y, rfl, r, rfl⟩,
     fun r' => match (same (e.to x) (e.to y)).mpr r' with
      | ⟨s, u, hs, r, hu⟩ =>
        have sx : s = x := (e.back_to s).symm.trans ((congrArg e.back hs).trans (e.back_to x))
        have uy : u = y := (e.back_to u).symm.trans ((congrArg e.back hu).trans (e.back_to y))
        Eq.subst (motive := fun b => R x b) uy (Eq.subst (motive := fun a => R a u) sx r)⟩,
   fun carries k k' =>
    ⟨fun ⟨s, u, hs, r, hu⟩ => Eq.subst (motive := fun b => R' k b) hu
        (Eq.subst (motive := fun a => R' a (e.to u)) hs ((carries s u).mp r)),
     fun r' => ⟨e.back k, e.back k', e.to_back k,
        (carries (e.back k) (e.back k')).mpr
          (Eq.subst (motive := fun b => R' (e.to (e.back k)) b) (e.to_back k').symm
            (Eq.subst (motive := fun a => R' a k') (e.to_back k).symm r')),
        e.to_back k'⟩⟩⟩

/-- A re-identification at one step is a one-to-one correspondence of the relata named there. -/
def reidentifyAt {R R' : Type} (σ : Reidentify R R') (t : Nat) : Corr R' R :=
  ⟨σ.old t, σ.new t, σ.new_old t, σ.old_new t⟩

/-- A re-identification is a one-to-one correspondence of occurrences, `(t, x) ↦ (t, σ.old t x)`. -/
def reidentifyOcc {R R' : Type} (σ : Reidentify R R') : Corr (Nat × R') (Nat × R) :=
  ⟨fun x => (x.1, σ.old x.1 x.2), fun y => (y.1, σ.new y.1 y.2),
   fun x => congrArg (Prod.mk x.1) (σ.new_old x.1 x.2),
   fun y => congrArg (Prod.mk y.1) (σ.old_new y.1 y.2)⟩

/-- The names' step and the step along the names' continuation agree. -/
theorem along_iff_itself {F : Type} {x y : Nat × F} :
    Steps.along x y ↔ Web.continuationStep (fun _ g f => g = f) x y :=
  ⟨fun ⟨next, same⟩ => ⟨next, same.symm⟩, fun ⟨next, same⟩ => ⟨next, same.symm⟩⟩

end WRTCheck2

end Becoming
