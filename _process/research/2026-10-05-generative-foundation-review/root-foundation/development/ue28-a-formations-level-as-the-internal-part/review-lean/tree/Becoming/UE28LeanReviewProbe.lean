import Becoming.BlanketCouplings

/-!
# Review probe for the UE28 scratch Lean (scratch, not for landing)

AI-written by an independent reviewer, 1 November 2026. Built against a copy of the scratch
`Becoming.BlanketCouplings` (UE28's version, copied unchanged into this tree for the build only).
Checks, in the pure core:
(A) `Web.ValuesThrough` is per step, so a value carrying the step also gives the values of what
couples into the phased drain's formation, and under it the phased drain's level is the internal
part of a law determined part by part;
(B) with an act course carrying the step, every run read by `levelRun` is admitted, balanced or not;
(C) a value giving the values of what couples in across steps, which `listed_values`' value does,
turns `levelRun_admitted_iff` into a statement on the World's records alone;
(D) the steady feed's level never repeats, so every value and every act course pass;
(E) an alternating drain and feed from what does not couple in, the level repeating, the agent
determined non-vacuously;
(F) `rowAct` ignores presence: a formation present at no step, its level unmoved, whose row counts
for nothing, is not determined under `rowAct`, and is under a constant act.
-/

namespace Becoming

namespace UE28LeanReviewProbe

open Generative Blanket BlanketCouplings

/-! ## (A) A value carrying the step -/

/-- The step as the value. -/
def clockValue : Nat → (Two → Nat) → Nat := fun t _ => t

/-- **It gives the values of what couples into the phased drain's `g`**: `ValuesThrough` compares
values at one step only. -/
theorem clockValue_values :
    PhasedDrain.web.ValuesThrough (fun _ _ => False) Two.g clockValue :=
  fun _ _ _ => ⟨fun _ => ⟨⟨fun _ _ req => False.elim req, fun _ _ req => False.elim req⟩,
    fun _ never => False.elim never⟩, fun _ => rfl⟩

/-- **Under it the phased drain's agent is determined.** -/
theorem clock_agentDetermined :
    AgentDetermined (fun t => PhasedDrain.web.level t Two.g)
      (fun t => clockValue t (PhasedDrain.web.level t)) PhasedDrain.act :=
  fun j k _ (same : j = k) _ =>
    match k, same with
    | _, rfl => ⟨rfl, rfl⟩

/-- **So the phased drain's level is the internal part of a law determined part by part**, read
with a value that gives the values of what couples into `g` (`clockValue_values`). -/
theorem clock_admitted :
    ∃ Q : Process (Parts Nat Nat (List Nat × List Nat) Nat) Unit, BlanketDetermined Q ∧
      ∀ r (m : Nat → Unit), r = levelRun PhasedDrain.web Two.g clockValue PhasedDrain.act →
        Admits Q r m :=
  readAlong_admitted_iff.mpr clock_agentDetermined

/-! ## (B) An act course carrying the step -/

/-- **With the step as the act, every run read by `levelRun` is admitted**, balanced or not. -/
theorem clockAct_admitted {R O : Type} (W : Web R R) (g : R) (value : Nat → (R → Nat) → O) :
    ∃ Q : Process (Parts Nat O Nat Nat) Unit, BlanketDetermined Q ∧
      ∀ r (m : Nat → Unit), r = levelRun W g value (fun t => t) → Admits Q r m :=
  readAlong_admitted_iff.mpr fun j k _ _ (same : j = k) =>
    match k, same with
    | _, rfl => ⟨rfl, rfl⟩

/-! ## (C) Values across steps, and the statement on the World's records -/

section Across

variable {R C O A : Type}

/-- `value` gives the values of what couples into `g` across steps: at any two steps, two levels
take one value exactly where they admit `g` alike, each at its step, and the conditions coupled
into `g` by level stand alike. -/
def ValuesAcross (W : Web R C) (obs : R → C → Prop) (g : R) (value : Nat → (C → Nat) → O) :
    Prop :=
  ∀ j k x y, value j x = value k y ↔ (W.Admits x j g ↔ W.Admits y k g) ∧ ∀ c, obs g c → x c = y c

/-- Across steps is at every step. -/
theorem ValuesAcross.through {W : Web R C} {obs : R → C → Prop} {g : R}
    {value : Nat → (C → Nat) → O} (across : ValuesAcross W obs g value) :
    W.ValuesThrough obs g value :=
  fun t x y => across t t x y

/-- **`listed_values`' value gives the values across steps**: whether the levels admit `g`, decided,
and the listed levels, with no step in the value. -/
theorem listed_valuesAcross {W : Web R C} {obs : R → C → Prop} {g : R}
    {admits : Nat → (C → Nat) → Bool} (decides : ∀ t x, admits t x = true ↔ W.Admits x t g)
    {cs : List C} (listed : ∀ c, obs g c ↔ c ∈ cs) :
    ValuesAcross W obs g (fun t x => (admits t x, cs.map x)) :=
  fun j k x y =>
    ⟨fun same =>
      match Prod.mk.inj same with
      | ⟨admitted, levels⟩ =>
        ⟨(decides j x).symm.trans
          ((Eq.subst (motive := fun b => admits j x = true ↔ b = true) admitted Iff.rfl).trans
            (decides k y)),
         fun c observed => map_eq_at levels ((listed c).mp observed)⟩,
     fun ⟨admitted, levels⟩ =>
      (congrArg (Prod.mk · (cs.map x))
          (Becoming.bool_eq_of_iff ((decides j x).trans (admitted.trans (decides k y).symm)))).trans
        (congrArg (Prod.mk (admits k y))
          (map_eq_on fun c mem => levels c ((listed c).mpr mem)))⟩

/-- **On the World's records**: where the value gives the values across steps, a formation's level
is the internal part of a law determined part by part, along a balanced run with the step
external, exactly where, at any two steps alike on its level, alike in admitting it, alike on the
conditions coupled into it by level and alike in its act, the exchange into it cross-sums alike and
its next acts agree. -/
theorem levelRun_admitted_iff_records {L : Flow R R} {W : Web R R}
    (history : L.BalancedHistory W.level) {g : R} {obs : R → R → Prop}
    {value : Nat → (R → Nat) → O} (across : ValuesAcross W obs g value) {act : Nat → A} :
    (∃ Q : Process (Parts Nat O A Nat) Unit, BlanketDetermined Q ∧
        ∀ r (m : Nat → Unit), r = levelRun W g value act → Admits Q r m) ↔
      ∀ j k, W.level j g = W.level k g →
        (W.Admits (W.level j) j g ↔ W.Admits (W.level k) k g) →
        (∀ c, obs g c → W.level j c = W.level k c) →
        act j = act k → L.given j g + L.taken k g = L.given k g + L.taken j g ∧
          act (j + 1) = act (k + 1) :=
  (levelRun_admitted_iff history).trans
    ⟨fun ex j k sl sa so sact => ex j k sl ((across j k _ _).mpr ⟨sa, so⟩) sact,
     fun ex j k sl sv sact =>
      match (across j k _ _).mp sv with
      | ⟨sa, so⟩ => ex j k sl sa so sact⟩

end Across

/-! ## (D) The steady feed passes vacuously -/

/-- **The steady feed's level never repeats**, so with any value and any act course its agent is
determined. -/
theorem steadyFeed_any {O A : Type} (value : Nat → (Two → Nat) → O) (act : Nat → A) :
    AgentDetermined (fun t => SteadyFeed.web.level t Two.g)
      (fun t => value t (SteadyFeed.web.level t)) act :=
  fun j k (same : j = k) _ _ =>
    match k, same with
    | _, rfl => ⟨rfl, rfl⟩

/-! ## (E) An alternating drain and feed: determined, not vacuously -/

namespace Alternating

/-- `h`'s phase: on, off, on, … -/
def phase : Nat → Bool
  | 0 => true
  | n + 1 => !(phase n)

def gLevel : Bool → Nat
  | true => 1
  | false => 0

def hLevel : Bool → Nat
  | true => 0
  | false => 1

def hTakesG : Bool → Nat
  | true => 1
  | false => 0

def hGivesG : Bool → Nat
  | true => 0
  | false => 1

def hTakesH : Bool → Nat
  | true => 0
  | false => 1

def hGivesH : Bool → Nat
  | true => 1
  | false => 0

/-- `h` takes from `g` when on and gives to it when off; its phase is its own level. -/
def take : Nat → Two → Two → Nat
  | t, .h, .g => hTakesG (phase t)
  | t, .h, .h => hTakesH (phase t)
  | _, .g, .g => 0
  | _, .g, .h => 0

def give : Nat → Two → Two → Nat
  | t, .h, .g => hGivesG (phase t)
  | t, .h, .h => hGivesH (phase t)
  | _, .g, .g => 0
  | _, .g, .h => 0

def flow : Flow Two Two := ⟨fun _ => [Two.h], take, give⟩

def level : Nat → Two → Nat
  | t, .g => gLevel (phase t)
  | t, .h => hLevel (phase t)

def web : Web Two Two :=
  ⟨level, fun _ _ => True, fun _ _ _ => False, fun _ _ _ => 0, fun _ _ _ => False⟩

theorem balance_g : ∀ p, gLevel (!p) + (hTakesG p + 0) = gLevel p + (hGivesG p + 0)
  | true => rfl
  | false => rfl

theorem balance_h : ∀ p, hLevel (!p) + (hTakesH p + 0) = hLevel p + (hGivesH p + 0)
  | true => rfl
  | false => rfl

/-- **The flow balances at every step.** -/
theorem balances : flow.BalancedHistory web.level := fun t c => match c with
  | .g => balance_g (phase t)
  | .h => balance_h (phase t)

/-- **`h` does not couple into `g`.** -/
theorem uncoupled : ¬ web.CoupledInto (fun _ _ => False) Two.g Two.h :=
  fun coupled => match coupled with
    | .inl ⟨_, never⟩ => never
    | .inr never => never

def value : Nat → (Two → Nat) → Unit := fun _ _ => ()

def act : Nat → List Nat × List Nat := rowAct [Two.g, Two.h] flow Two.g

theorem gLevel_inj : ∀ (p q : Bool), gLevel p = gLevel q → p = q
  | true, true, _ => rfl
  | false, false, _ => rfl
  | true, false, same => (Naturals.succ_ne_zero 0 same).elim
  | false, true, same => (Naturals.succ_ne_zero 0 same.symm).elim

/-- **The level repeats**: steps 0 and 2 are alike on it, so the condition is tested. -/
theorem repeats : web.level 0 Two.g = web.level 2 Two.g := rfl

/-- **The agent is determined**, the next level read off the level. -/
theorem agentDetermined :
    AgentDetermined (fun t => web.level t Two.g) (fun t => value t (web.level t)) act :=
  fun j k sl _ _ =>
    ⟨congrArg (fun p => gLevel (!p)) (gLevel_inj (phase j) (phase k) sl), rfl⟩

end Alternating

/-! ## (F) `rowAct` ignores presence -/

namespace AbsentRow

/-- `g`'s row: one from `h` at the first phase, though `g` is present at no step. -/
def gTakesH : ReadsExternal.Three → Nat
  | .first => 1
  | .second => 0
  | .third => 0

def take : Nat → Two → Two → Nat
  | t, .g, .h => gTakesH (PhasedDrain.phase t)
  | _, .g, .g => 0
  | _, .h, _ => 0

/-- No relatum takes part in any step. -/
def flow : Flow Two Two := ⟨fun _ => [], take, fun _ _ _ => 0⟩

def web : Web Two Two :=
  ⟨fun _ _ => 1, fun _ _ => True, fun _ _ _ => False, fun _ _ _ => 0, fun _ _ _ => False⟩

/-- **The flow balances**: nothing moves any level. -/
theorem balances : flow.BalancedHistory web.level := fun _ _ => rfl

theorem absent : ∀ t, flow.present t = [] := fun _ => rfl

def value : Nat → (Two → Nat) → Unit := fun _ _ => ()

def act : Nat → List Nat × List Nat := rowAct [Two.g, Two.h] flow Two.g

/-- **Under `rowAct` the agent is not determined**: at steps 1 and 2 the level, the value and the
row agree, and the next rows do not, though the row counts for nothing. -/
theorem not_agentDetermined :
    ¬ AgentDetermined (fun t => web.level t Two.g) (fun t => value t (web.level t)) act :=
  fun det =>
    have rows : act 2 = act 3 := (det 1 2 rfl rfl rfl).2
    have firsts : [0, 0] = [0, 1] := congrArg Prod.fst rows
    Naturals.succ_ne_zero 0 (List.cons.inj (List.cons.inj firsts).2).1.symm

/-- **Under a constant act it is.** -/
theorem constant_agentDetermined :
    AgentDetermined (fun t => web.level t Two.g) (fun t => value t (web.level t))
      (fun _ => ()) :=
  fun _ _ _ _ _ => ⟨rfl, rfl⟩

end AbsentRow

end UE28LeanReviewProbe

end Becoming
