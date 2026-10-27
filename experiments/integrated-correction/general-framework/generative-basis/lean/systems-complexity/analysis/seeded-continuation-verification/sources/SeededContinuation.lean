import JointContinuation -- 脊柱上 / On the spine (I4, 2026-10-16): `Becoming.Invariant.run`, `Becoming.Viability.Plan.zip_keeps` — 脊柱的律更一般 / the spine law is more general; MODULE-CLASSIFICATION.md

/-! Seeded mutual continuation within one history. Initial support, one-step
preservation, joint availability and faithful views are separate obligations. -/
namespace SeededContinuation
open ContinuationAdequacy JointContinuation
variable {X A B U V O P : Type}

/-- Past/current conditions, not an assumed next-state conclusion, support both
next-state guarantees. -/
theorem mutual_history
    (step : X → X → Prop) (r s : X → Prop) (h : Nat → X)
    (initial : r (h 0) ∧ s (h 0))
    (path : ∀ n, step (h n) (h (n+1)))
    (left : ∀ x y, r x → s x → step x y → r y)
    (right : ∀ x y, r x → s x → step x y → s y) :
    ∀ n, r (h n) ∧ s (h n) := by
  intro n
  induction n with
  | zero => exact initial
  | succ n ih => exact ⟨left _ _ ih.1 ih.2 (path n), right _ _ ih.1 ih.2 (path n)⟩

/-- Derive the previous recursive compatibility condition from initial support,
local authorization, faithful joint effects, and stepwise mutual preservation. -/
theorem compatible_from_seed
    (joint : X → (U × V) → X → Prop) (left : A → U → A → Prop)
    (right : B → V → B → Prop) (pa : X → A) (pb : X → B)
    (oa : A → O) (ob : B → P) (ga : A → Prop) (gb : B → Prop)
    (la : A → U → Prop) (lb : B → V → Prop) (lj : X → (U × V) → Prop)
    (r s : X → Prop)
    (project : ∀ x uv y, joint x uv y → left (pa x) uv.1 (pa y) ∧ right (pb x) uv.2 (pb y))
    (ready : ∀ x u v, r x → s x → la (pa x) u → lb (pb x) v →
      lj x (u,v) ∧ ∃ y, joint x (u,v) y)
    (keepR : ∀ x uv y, r x → s x → joint x uv y → r y)
    (keepS : ∀ x uv y, r x → s x → joint x uv y → s y)
    (n : Nat) : ∀ (p : Plan U O n) (q : Plan V P n) C Ca Cb,
    (∀ x, C x → Ca (pa x) ∧ Cb (pb x)) →
    (∀ x, C x → r x ∧ s x) →
    works left oa ga la p Ca → works right ob gb lb q Cb →
    compatible joint (fun x => (oa (pa x), ob (pb x))) lj p q C := by
  induction n with
  | zero => intro p q C Ca Cb _ _ _ _; cases p; cases q; trivial
  | succ n ih =>
    intro p q C Ca Cb cover seed hp hq
    cases p with
    | act u f =>
      cases q with
      | act v g =>
        refine ⟨?_, ?_⟩
        · intro x hx
          exact ready x u v (seed x hx).1 (seed x hx).2
            (hp.2.1 _ (cover x hx).1).1 (hq.2.1 _ (cover x hx).2).1
        · intro o
          apply ih (f o.1) (g o.2) _ (post left oa Ca u o.1) (post right ob Cb v o.2)
          · exact actual_joint_post_projects joint left right pa pb oa ob C Ca Cb cover project (u,v) o
          · rintro y ⟨x,hx,hs,_⟩
            exact ⟨keepR _ _ _ (seed x hx).1 (seed x hx).2 hs,
              keepS _ _ _ (seed x hx).1 (seed x hx).2 hs⟩
          · exact hp.2.2 o.1
          · exact hq.2.2 o.2

/-- The seeded one-step obligations close the previous plan-composition interface. -/
theorem seeded_joint_plan
    (joint : X → (U × V) → X → Prop) (left : A → U → A → Prop)
    (right : B → V → B → Prop) (pa : X → A) (pb : X → B)
    (oa : A → O) (ob : B → P) (ga : A → Prop) (gb : B → Prop)
    (la : A → U → Prop) (lb : B → V → Prop) (lj : X → (U × V) → Prop)
    (r s : X → Prop)
    (project : ∀ x uv y, joint x uv y → left (pa x) uv.1 (pa y) ∧ right (pb x) uv.2 (pb y))
    (ready : ∀ x u v, r x → s x → la (pa x) u → lb (pb x) v →
      lj x (u,v) ∧ ∃ y, joint x (u,v) y)
    (keepR : ∀ x uv y, r x → s x → joint x uv y → r y)
    (keepS : ∀ x uv y, r x → s x → joint x uv y → s y)
    (n : Nat) (p : Plan U O n) (q : Plan V P n) (C : X → Prop) (Ca : A → Prop) (Cb : B → Prop)
    (cover : ∀ x, C x → Ca (pa x) ∧ Cb (pb x))
    (seed : ∀ x, C x → r x ∧ s x)
    (hp : works left oa ga la p Ca) (hq : works right ob gb lb q Cb) :
    works joint (fun x => (oa (pa x),ob (pb x)))
      (fun x => ga (pa x) ∧ gb (pb x)) lj (zipPlan p q) C := by
  exact joint_plan_composition joint left right pa pb oa ob ga gb la lb lj project n p q C Ca Cb cover hp hq
    (compatible_from_seed joint left right pa pb oa ob ga gb la lb lj r s project ready keepR keepS n p q C Ca Cb cover seed hp hq)

/-- Preservation can hold vacuously while there is no actual successor. -/
theorem preservation_without_availability :
    (∀ _x _y : Unit, True → True → False → True) ∧
    ¬ ∃ y : Unit, (fun _ _ : Unit => False) () y := by simp

/-- Two eventual conditional promises do not force either event. -/
theorem reciprocal_eventual_promises_can_be_empty :
    ∃ a b : Nat → Prop,
      ((∃ n, a n) → ∃ n, b n) ∧ ((∃ n, b n) → ∃ n, a n) ∧
      (∀ n, ¬ a n ∧ ¬ b n) := by
  exact ⟨fun _ => False,fun _ => False,fun ⟨_,h⟩ => h.elim,
    fun ⟨_,h⟩ => h.elim,fun _ => ⟨id,id⟩⟩

-- A shared renewal configuration; coordinates record roles within its history.
-- The stored ignition capacity is already present, not created by a promise.
structure Config where
  left : Bool
  right : Bool
  reserve : Bool
  deriving DecidableEq

def tick (x : Config) : Config := ⟨x.right,x.left,x.reserve⟩
def run : Nat → Config → Config
  | 0, x => x
  | n+1, x => tick (run n x)

def active (x : Config) : Prop := x.left=true ∧ x.right=true

def ignite (x y : Config) : Prop := x.reserve=true ∧ y=⟨true,true,false⟩

theorem tick_supports_mutually (x : Config) :
    ((tick x).left=true ↔ x.right=true) ∧ ((tick x).right=true ↔ x.left=true) := by
  exact ⟨Iff.rfl,Iff.rfl⟩

theorem tick_active_iff (x : Config) : active (tick x) ↔ active x := by
  simp only [active,tick]; exact and_comm

theorem active_run_iff (n : Nat) (x : Config) : active (run n x) ↔ active x := by
  induction n with
  | zero => rfl
  | succ n ih => exact (tick_active_iff _).trans ih

theorem empty_never_starts (n : Nat) : run n ⟨false,false,false⟩=⟨false,false,false⟩ := by
  induction n with
  | zero => rfl
  | succ n ih => simp [run,ih,tick]

theorem partial_seed_not_joint (n : Nat) : ¬ active (run n ⟨true,false,false⟩) := by
  rw [active_run_iff]; simp [active]

theorem stored_seed_starts_and_maintains :
    ∃ y, ignite ⟨false,false,true⟩ y ∧ ∀ n, active (run n y) := by
  refine ⟨⟨true,true,false⟩,⟨rfl,rfl⟩,?_⟩
  intro n; rw [active_run_iff]; exact ⟨rfl,rfl⟩

theorem ignition_requires_actual_reserve (x y : Config) (h : ignite x y) :
    x.reserve=true ∧ y.reserve=false := by
  rcases h with ⟨h,rfl⟩; exact ⟨h,rfl⟩

theorem absent_reserve_blocks_ignition : ¬ ∃ y, ignite ⟨false,false,false⟩ y := by
  simp [ignite]

end SeededContinuation

#print axioms SeededContinuation.mutual_history
#print axioms SeededContinuation.compatible_from_seed
#print axioms SeededContinuation.seeded_joint_plan
#print axioms SeededContinuation.preservation_without_availability
#print axioms SeededContinuation.reciprocal_eventual_promises_can_be_empty
#print axioms SeededContinuation.tick_supports_mutually
#print axioms SeededContinuation.tick_active_iff
#print axioms SeededContinuation.active_run_iff
#print axioms SeededContinuation.empty_never_starts
#print axioms SeededContinuation.partial_seed_not_joint
#print axioms SeededContinuation.stored_seed_starts_and_maintains
#print axioms SeededContinuation.ignition_requires_actual_reserve
#print axioms SeededContinuation.absent_reserve_blocks_ignition
