import Init

/-! # BecomingSpec V1: Ultra-Short Frozen Core Targets (`import Init` ONLY, 0 axioms, 0 `.injEq`)
AI-written (Track S1, 2026-11-24). Decoupled target propositions; proofs live in `Solution.lean`. -/
set_option genInjectivity false

namespace BecomingSpec.V1

/-! ## 1. `prefixMargin` & non-vacuous `live` execution -/
def stock (g : Nat → Nat) (x h : Nat) : Nat := (x - h) + g (x - h)
structure MarginSpec (Env : Type) where
  g : Nat → Nat
  envDraw : Env → Nat
  adm : Env → Prop
  xCrit : Nat
  warnLevel : Nat
  post : Nat
  cap : Nat
  envCap : Nat
  lag : Nat
def MarginSpec.draw {Env : Type} (m : MarginSpec Env) (eta : Nat) : Nat :=
  if eta = 0 then m.post else m.cap
def MarginSpec.step {Env : Type} (m : MarginSpec Env) (st : Nat × Nat) (e : Env) : Nat × Nat :=
  (stock m.g st.1 (m.draw st.2 + m.envDraw e), if st.1 < m.warnLevel then st.2 - 1 else st.2)
def MarginSpec.run {Env : Type} (m : MarginSpec Env) (st : Nat × Nat) : List Env → Nat × Nat
  | [] => st
  | e :: es => m.run (m.step st e) es
def MarginSpec.Valid {Env : Type} (m : MarginSpec Env) (x₀ eta₀ : Nat) : Prop :=
  (∀ a b, a ≤ b → m.g a ≤ m.g b) ∧ m.post ≤ m.cap ∧ eta₀ ≤ m.lag ∧
  (∀ e, m.adm e → m.envDraw e ≤ m.envCap) ∧ m.xCrit ≤ stock m.g m.xCrit (m.post + m.envCap) ∧
  m.xCrit + (m.lag + 1) * (m.cap + m.envCap) ≤ m.warnLevel ∧
  m.xCrit + eta₀ * (m.cap + m.envCap) ≤ x₀

def prefixMarginTarget : Prop :=
  ∀ {Env : Type} (m : MarginSpec Env) (x₀ eta₀ : Nat) (es : List Env),
    m.Valid x₀ eta₀ → (∀ e, e ∈ es → m.adm e) →
    let st := m.run (x₀, eta₀) es
    m.xCrit + st.2 * (m.cap + m.envCap) ≤ st.1 ∧ st.2 ≤ m.lag ∧ m.xCrit ≤ st.1

def liveG (z : Nat) : Nat := if 4 ≤ z then 1 else 0
def liveMargin : MarginSpec Unit := ⟨liveG, fun _ => 0, fun _ => True, 5, 14, 1, 3, 0, 2⟩

def liveTarget : Prop :=
  0 < liveMargin.post ∧ liveMargin.post < liveMargin.cap ∧ liveMargin.Valid 15 2 ∧
  ∃ e₀ e₁ e₂ e₃ : Unit,
    liveMargin.adm e₀ ∧ liveMargin.adm e₁ ∧ liveMargin.adm e₂ ∧ liveMargin.adm e₃ ∧
    let s1 := liveMargin.step (15, 2) e₀
    let s2 := liveMargin.step s1 e₁
    let s3 := liveMargin.step s2 e₂
    let s4 := liveMargin.step s3 e₃
    0 < liveMargin.draw 2 ∧ 0 < liveMargin.draw s3.2 ∧
    s1.1 < liveMargin.warnLevel ∧ s1.1 < 15 ∧ s2.1 < s1.1 ∧ s3.1 < s2.1 ∧
    s3.2 = 0 ∧ liveMargin.xCrit ≤ s3.1 ∧ liveMargin.xCrit ≤ s4.1

/-! ## 2. `cycleBoundary`: alternating draws `4`/`2`, floor `5` -/
def iter {α : Type} (f : α → α) : Nat → α → α
  | 0, x => x
  | n + 1, x => iter f n (f x)
def cycleGain (z : Nat) : Nat := if 1 ≤ z then 3 else 0
def cycleDraw (b : Bool) : Nat := if b then 4 else 2
def cycleStep (s : Bool × Nat) : Bool × Nat := (!s.1, stock cycleGain s.2 (cycleDraw s.1))

def cycleBoundaryTarget : Prop :=
  (∀ n, 5 ≤ (iter cycleStep n (true, 6)).2) ∧
  (∃ n, (iter cycleStep n (true, 5)).2 < 5) ∧
  (∀ n, 5 ≤ (iter (fun s => cycleStep (cycleStep s)) n (true, 5)).2)

/-! ## 3. `sameView_obstruction` & IN1 `gpt-5.4-mini` Seed 0 vs Seed 4 prefix8 -/
def sameViewObstructionTarget : Prop :=
  ∀ {H V : Type} (view : H → V) (safe : H → Prop) (h₀ h₁ : H),
    view h₀ = view h₁ → safe h₀ → ¬ safe h₁ →
    (∀ dec : V → Bool, dec (view h₀) = dec (view h₁)) ∧
    ¬ ∃ dec : V → Bool, (dec (view h₀) = true ↔ safe h₀) ∧ (dec (view h₁) = true ↔ safe h₁)

abbrev Triple := Nat × Nat × Nat
def in1Step (st : Nat × Bool) (req : Triple) : Nat × Bool :=
  let total := req.1 + req.2.1 + req.2.2
  let caught := if total ≤ st.1 then req
    else (req.1 * st.1 / total, req.2.1 * st.1 / total, req.2.2 * st.1 / total)
  let left := st.1 - (caught.1 + caught.2.1 + caught.2.2)
  (if left < 5 then 0 else if 2 * left ≤ 100 then 2 * left else 100, st.2 && decide (70 ≤ left))
def in1Trace (st : Nat × Bool) : List (Triple × Triple) → List (Nat × Triple × Nat) × Bool
  | [] => ([], st.2)
  | (said, req) :: rest =>
    let st' := in1Step st req
    let tail := in1Trace st' rest
    ((st.1, said, st'.1) :: tail.1, tail.2)
def s0_m8 : List (Triple × Triple) := List.replicate 8 ((10, 10, 10), (10, 10, 10))
def s4_m8 : List (Triple × Triple) :=
  List.replicate 7 ((10, 10, 10), (10, 10, 10)) ++ [((10, 10, 10), (30, 10, 10))]

def in1SameViewWitnessTarget : Prop :=
  (in1Trace (100, true) s0_m8).1 = (in1Trace (100, true) s4_m8).1 ∧
  (in1Trace (100, true) s0_m8).2 = true ∧ (in1Trace (100, true) s4_m8).2 = false ∧
  ∀ dec : List (Nat × Triple × Nat) → Bool,
    dec (in1Trace (100, true) s0_m8).1 = dec (in1Trace (100, true) s4_m8).1

/-! ## 4. `commonAction` on finite observation fibers -/
def commonActionTarget : Prop :=
  ∀ {H A : Type} {n : Nat} (hs : List H) (obs : H → Fin n) (U : H → A → Prop), A →
    ((∃ π : Fin n → A, ∀ h, h ∈ hs → U h (π (obs h))) ↔
      ∀ o : Fin n, (∃ h, h ∈ hs ∧ obs h = o) → ∃ a : A, ∀ h, h ∈ hs → obs h = o → U h a)

/-! ## 5. `completes` & `branch_stuck` (`Assurance.Branch` 4-state witness) -/
def StepRel (S A : Type) : Type := S → A → S → Prop
inductive Trace {S A : Type} (step : StepRel S A) : S → List A → S → Prop where
  | nil (s : S) : Trace step s [] s
  | cons {s m t : S} {a : A} {rest : List A} : step s a m → Trace step m rest t → Trace step s (a :: rest) t
inductive SafeTrace {S A : Type} (step safe : StepRel S A) : S → List A → S → Prop where
  | nil (s : S) : SafeTrace step safe s [] s
  | cons {s m t : S} {a : A} {rest : List A} :
      step s a m → safe s a m → SafeTrace step safe m rest t → SafeTrace step safe s (a :: rest) t
def Completes {S A : Type} (step safe : StepRel S A) (goal : S → Prop) : S → List A → Prop
  | s, [] => goal s
  | s, a :: rest => (∃ t, step s a t) ∧ ∀ t, step s a t → safe s a t ∧ Completes step safe goal t rest
def Determined {S A : Type} (step : StepRel S A) : Prop :=
  ∀ s a t₁ t₂, step s a t₁ → step s a t₂ → t₁ = t₂

def completesTarget : Prop :=
  (∀ {S A : Type} (step safe : StepRel S A) (goal : S → Prop) (s : S) (plan : List A),
    Completes step safe goal s plan →
      (∃ t, Trace step s plan t) ∧ ∀ t, Trace step s plan t → SafeTrace step safe s plan t ∧ goal t) ∧
  (∀ {S A : Type} (step safe : StepRel S A) (goal : S → Prop) (s : S) (plan : List A),
    Determined step →
    (Completes step safe goal s plan ↔
      (∃ t, Trace step s plan t) ∧ ∀ t, Trace step s plan t → SafeTrace step safe s plan t ∧ goal t))

def branchStep : StepRel Nat Unit := fun s _ t => (s = 0 ∧ (t = 1 ∨ t = 2)) ∨ (s = 1 ∧ t = 3)
def branchStuckTarget : Prop :=
  (∃ t, Trace branchStep 0 [(), ()] t) ∧ (∀ t, Trace branchStep 0 [(), ()] t → t = 3) ∧
  ¬ Completes branchStep (fun _ _ _ => True) (fun t => t = 3) 0 [(), ()]

/-! ## 6. `significanceFree`: dynamics never forces `Unrestricted` significance -/
def Unrestricted {Pos F : Type} (sig : Pos → Nat → F → Prop) : Prop := ∀ p t f, sig p t f
def ReadsOnlyDynamics {Pos F D : Type} (law : D → (Pos → Nat → F → Prop) → Prop) : Prop :=
  ∀ d sig sig', law d sig → law d sig'
def significanceFreeTarget : Prop :=
  (∀ {Pos F D : Type} (_ : Pos) (_ : F) (law : D → Prop),
    (∃ d, law d) → ¬ (∀ d, law d → ∀ sig : Pos → Nat → F → Prop, Unrestricted sig)) ∧
  (∀ {Pos F D : Type} (_ : Pos) (_ : F) (law : D → (Pos → Nat → F → Prop) → Prop),
    ReadsOnlyDynamics law → (∃ d sig, law d sig) → ¬ (∀ d sig, law d sig → Unrestricted sig))

end BecomingSpec.V1
