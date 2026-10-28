import Becoming.Persistence
import Becoming.Space
import Becoming.GrammarMap

/-!
# Scratch check of the WRT design's statements (not a landed module)

Checks that the witnesses the design proposes are provable in the pure core as stated: the
no-injection lemma, conservation never being identity on predicates of `Nat`, the pair of worlds
alike in their web and pattern of exchange that differ in balance, and a line of falls never going
on without end. Two transport laws show the shape WRT1 proposes.
-/

namespace Becoming

namespace WRTCheck

/-- No map of the predicates on `Nat` into `Nat` is one to one. -/
theorem no_injection (i : (Nat → Prop) → Nat) (inj : ∀ A B, i A = i B → A = B) : False :=
  let D : Nat → Prop := fun n => ∃ A, n = i A ∧ ¬ A n
  have h : D (i D) ↔ ¬ D (i D) :=
    ⟨fun ⟨A, same, notA⟩ => Eq.subst (motive := fun B => ¬ B (i D)) (inj D A same).symm notA,
     fun notD => ⟨D, rfl, notD⟩⟩
  have notD : ¬ D (i D) := fun d => h.mp d d
  notD (h.mpr notD)

/-- Where conservation across a step is identity, the standings after it tell every two relata
apart. -/
theorem conserves_identity_injective {w : World} {t : Nat}
    (identity : ∀ g f, w.Conserves t g f ↔ g = f) :
    ∀ f f', w.web.level (t + 1) f = w.web.level (t + 1) f' → f = f' :=
  fun f f' same =>
    have self : w.Conserves t f f := (identity f f).mpr rfl
    (identity f f').mp
      (Eq.subst (motive := fun n => n + w.flow.taken t f = w.web.level t f + w.flow.given t f)
        same self)

/-- Conservation across a step is never identity on the predicates of `Nat`. -/
theorem not_conserves_identity (L : Flow (Nat → Prop) (Nat → Prop))
    (W : Web (Nat → Prop) (Nat → Prop)) (t : Nat) :
    ¬ ∀ g f, (World.of (Nat → Prop) L W).Conserves t g f ↔ g = f :=
  fun identity => no_injection ((World.of (Nat → Prop) L W).web.level (t + 1))
    (conserves_identity_injective identity)

/-- Given one relatum it conserves, a relatum conserves exactly those standing after the step as
that one does. -/
theorem conserves_iff_same_level {w : World} {t : Nat} {g f : w.Relatum} (h : w.Conserves t g f)
    (f' : w.Relatum) : w.Conserves t g f' ↔ w.web.level (t + 1) f' = w.web.level (t + 1) f :=
  ⟨fun h' => add_right_cancel (w.flow.taken t g) (h'.trans h.symm),
   fun same => Eq.subst (motive := fun n => n + w.flow.taken t g = w.web.level t g + w.flow.given t g)
     same.symm h⟩

/-- The idle world with its gift doubled: the same web and the same pattern of exchange. -/
def idleTwice : World :=
  World.of Unit (Witnesses.giving () 2) World.Idle.web

theorem idleTwice_unbalanced : ¬ idleTwice.Balanced :=
  fun balanced => Nat.succ_ne_self 1 (balanced 0 ()).symm

/-- What a world's relations are at each step, with no amount read except whether it is positive
or a need is met. -/
structure Relations (R : Type) where
  active : Nat → R → Prop
  requires : Nat → R → R → Prop
  draws : Nat → R → R → Prop
  present : Nat → R → Prop
  gives : Nat → R → R → Prop
  takes : Nat → R → R → Prop
  met : Nat → R → R → Prop

def relations (w : World) : Relations w.Relatum :=
  ⟨w.web.active, w.web.requires, w.web.draws, fun t x => x ∈ w.flow.present t,
   fun t f c => 0 < w.flow.give t f c, fun t f c => 0 < w.flow.take t f c,
   fun t f c => w.web.need t f c ≤ w.web.level t c⟩

/-- Two readings of relations hold the same relations. -/
def Relations.Alike {R : Type} (a b : Relations R) : Prop :=
  (∀ t x, a.active t x ↔ b.active t x) ∧ (∀ t x y, a.requires t x y ↔ b.requires t x y) ∧
  (∀ t x y, a.draws t x y ↔ b.draws t x y) ∧ (∀ t x, a.present t x ↔ b.present t x) ∧
  (∀ t x y, a.gives t x y ↔ b.gives t x y) ∧ (∀ t x y, a.takes t x y ↔ b.takes t x y) ∧
  (∀ t x y, a.met t x y ↔ b.met t x y)

/-- **Balance is not a property of the relations.** No property of a world's relations that keeps
to their likeness is balance: the idle world and its double are alike in every relation, with the
same web, and one balances while the other does not. -/
theorem balance_not_relational :
    ¬ ∃ Φ : (R : Type) → Relations R → Prop,
      (∀ R (a b : Relations R), a.Alike b → (Φ R a ↔ Φ R b)) ∧
      ∀ w : World, w.Balanced ↔ Φ w.Relatum (relations w) :=
  fun ⟨_, keeps, balance⟩ =>
    have alike : (relations World.idle).Alike (relations idleTwice) :=
      ⟨fun _ _ => Iff.rfl, fun _ _ _ => Iff.rfl, fun _ _ _ => Iff.rfl, fun _ _ => Iff.rfl,
       fun _ _ _ => ⟨fun _ => Nat.zero_lt_succ 1, fun _ => Nat.zero_lt_succ 0⟩,
       fun _ _ _ => Iff.rfl, fun _ _ _ => Iff.rfl⟩
    idleTwice_unbalanced ((balance idleTwice).mpr
      ((keeps Unit _ _ alike).mp ((balance World.idle).mp World.idle_world.1)))

/-- The level of an occurrence's relatum falls across the step from it. -/
def Falls (w : World) (x : Nat × w.Relatum) : Prop :=
  w.web.level (x.1 + 1) x.2 < w.web.level x.1 x.2

/-- **A line of falls does not go on without end.** -/
theorem falls_not_endless (w : World) (x : Nat × w.Relatum) (falls : Falls w x) :
    ¬ «不穷» Steps.along (Web.alikeBy (Falls w)) x :=
  fun endless =>
    have climb : ∀ k, «所及» Steps.along (Web.alikeBy (Falls w)) x (x.1 + k, x.2) ∧
        Falls w (x.1 + k, x.2) ∧ w.web.level (x.1 + k) x.2 + k ≤ w.web.level x.1 x.2 :=
      fun k => Nat.rec (motive := fun k => «所及» Steps.along (Web.alikeBy (Falls w)) x (x.1 + k, x.2) ∧
          Falls w (x.1 + k, x.2) ∧ w.web.level (x.1 + k) x.2 + k ≤ w.web.level x.1 x.2)
        ⟨Or.inl rfl, falls, Nat.le_refl _⟩
        (fun k ⟨reached, here, bound⟩ =>
          match endless _ reached with
          | ⟨⟨_, _⟩, ⟨⟨h₁, h₂⟩, alike⟩⟩ => by
            cases h₁; cases h₂
            exact ⟨«所及之传递» reached (Or.inr (.one ⟨⟨rfl, rfl⟩, alike⟩)), alike.mp here,
              Nat.le_trans (Nat.succ_le_of_lt (Nat.add_lt_add_right here k)) bound⟩)
        k
    have top := (climb (w.web.level x.1 x.2 + 1)).2.2
    Nat.not_succ_le_self _ (Nat.le_trans (Nat.le_add_left _ _) top)

/-- The model with a fall everywhere goes on without end: no world's line of falls is it. -/
theorem everywhere_endless :
    «不穷» Steps.along (Web.alikeBy (fun _ : Nat × Unit => True)) (0, ()) :=
  fun y _ => ⟨(y.1 + 1, y.2), ⟨rfl, rfl⟩, Iff.rfl⟩

/-- The world with relata `F` whose activity is `Q` and nothing else. -/
def ofActivity (F : Type) (Q : Nat × F → Prop) : World :=
  World.of F Flow.still (Witnesses.unrequired (fun _ _ => 0) fun t f => Q (t, f))

/-- Its class of activity is the class of `Q`. -/
theorem ofActivity_class (F : Type) (Q : Nat × F → Prop) :
    (ofActivity F Q).web.activityClass = Web.alikeBy Q :=
  rfl

/-- Conservation is carried by every re-identification. -/
theorem conserves_reidentify {w : World} {R' : Type} (σ : Reidentify w.Relatum R') (t : Nat)
    (x y : R') :
    (w.reidentify σ).Conserves t x y ↔ w.Conserves t (σ.old t x) (σ.old (t + 1) y) :=
  ⟨fun h => (congrArg (w.web.level (t + 1) (σ.old (t + 1) y) + ·)
      (World.reidentify_taken σ t x)).symm.trans
      (h.trans (congrArg (w.web.level t (σ.old t x) + ·) (World.reidentify_given σ t x))),
   fun h => (congrArg (w.web.level (t + 1) (σ.old (t + 1) y) + ·)
      (World.reidentify_taken σ t x)).trans
      (h.trans (congrArg (w.web.level t (σ.old t x) + ·) (World.reidentify_given σ t x)).symm)⟩

/-- A later step, read on the occurrences: along the names, then across by the same step. -/
theorem later_iff {R : Type} {x y : Nat × R} :
    x.1 < y.1 ↔ «而» («及» Steps.along) (fun a b : Nat × R => a.1 = b.1) x y :=
  ⟨fun lt =>
    have reach : ∀ k, «及» Steps.along x (x.1 + k + 1, x.2) := fun k =>
      Nat.rec (motive := fun k => «及» Steps.along x (x.1 + k + 1, x.2)) (.one ⟨rfl, rfl⟩)
        (fun _ ih => «及之传递» ih (.one ⟨rfl, rfl⟩)) k
    have split : ∀ {m n : Nat}, m < n → ∃ k, n = m + k + 1 := fun lt => by
      induction lt with
      | refl => exact ⟨0, rfl⟩
      | step _ ih => exact match ih with | ⟨k, same⟩ => ⟨k + 1, congrArg Nat.succ same⟩
    match split lt with
    | ⟨k, same⟩ => ⟨(x.1 + k + 1, x.2), reach k, same.symm⟩,
   fun ⟨z, r, same⟩ =>
    have advances : ∀ {a b : Nat × R}, «及» Steps.along a b → a.1 < b.1 := fun r => by
      induction r with
      | one s => exact Eq.subst (motive := fun n => _ < n) s.1.symm (Nat.lt_succ_self _)
      | more s _ ih => exact Nat.lt_trans (Eq.subst (motive := fun n => _ < n) s.1.symm (Nat.lt_succ_self _)) ih
    Eq.subst (motive := fun n => x.1 < n) same (advances r)⟩

/-! ## Transport, two laws of WRT1's shape -/

variable {α β : Type}

/-- A one-to-one correspondence of carriers. -/
structure Corr (α β : Type) where
  to : α → β
  back : β → α
  back_to : ∀ x, back (to x) = x
  to_back : ∀ y, to (back y) = y

/-- The correspondence carries `R` to `R'`. -/
def Corr.Carries (e : Corr α β) (R : «际» α) (R' : «际» β) : Prop :=
  ∀ x y, R x y ↔ R' (e.to x) (e.to y)

theorem Corr.carries_back {e : Corr α β} {R : «际» α} {R' : «际» β} (h : e.Carries R R')
    (u v : β) : R' u v ↔ R (e.back u) (e.back v) :=
  have := h (e.back u) (e.back v)
  Eq.subst (motive := fun b => R' u b ↔ R (e.back u) (e.back v)) (e.to_back v)
    (Eq.subst (motive := fun a => R' a (e.to (e.back v)) ↔ R (e.back u) (e.back v)) (e.to_back u)
      this.symm)

theorem Corr.reach {e : Corr α β} {R : «际» α} {R' : «际» β} (h : e.Carries R R') {x y : α} :
    «及» R x y ↔ «及» R' (e.to x) (e.to y) :=
  ⟨fun r => by
    induction r with
    | one c => exact .one ((h _ _).mp c)
    | more c _ ih => exact .more ((h _ _).mp c) ih,
   fun r =>
    have back : ∀ {u v}, «及» R' u v → «及» R (e.back u) (e.back v) := fun r => by
      induction r with
      | one c => exact .one ((Corr.carries_back h _ _).mp c)
      | more c _ ih => exact .more ((Corr.carries_back h _ _).mp c) ih
    Eq.subst (motive := fun b => «及» R x b) (e.back_to y)
      (Eq.subst (motive := fun a => «及» R a (e.back (e.to y))) (e.back_to x) (back r))⟩

theorem Corr.sheng {e : Corr α β} {R E : «际» α} {R' E' : «际» β} (hR : e.Carries R R')
    (hE : e.Carries E E') {y : α} : «生» R E y ↔ «生» R' E' (e.to y) :=
  ⟨fun begins ⟨x', r, s⟩ => begins ⟨e.back x',
      (Corr.carries_back hR x' (e.to y)).mp r |> Eq.subst (motive := fun b => R (e.back x') b) (e.back_to y),
      (Corr.carries_back hE x' (e.to y)).mp s |> Eq.subst (motive := fun b => E (e.back x') b) (e.back_to y)⟩,
   fun begins ⟨x, r, s⟩ => begins ⟨e.to x, (hR x y).mp r, (hE x y).mp s⟩⟩

end WRTCheck

end Becoming
