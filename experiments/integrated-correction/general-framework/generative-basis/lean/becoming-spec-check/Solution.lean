import BecomingSpec.V1.Targets
import BecomingSpec.V2.Targets
import BecomingSpec.Revision.IN1
import BecomingSpec.Extensions.OplaxTargets
import BecomingSpec.Extensions.EntryTargets
import Becoming.RegimeMargin
import Becoming.OpenComposition
import Becoming.PacedStock
import Becoming.Assurance
import Becoming.GuardHorizon
import Becoming.Significance
import Becoming.OplaxHistory
import EncounterEntry

/-!
# BecomingSpec Solution & Core Adapters (`Solution.lean`)

AI-written (Track S1, 2026-11-24). Imports `BecomingSpec.*` AND read-only `Becoming.*` modules,
proving ALL frozen target theorems in `BecomingSpecCheck` with 0 axioms and 0 `sorry`, together
with explicit adapter lemmas showing `Becoming` step/guard/comparison maps commute with `BecomingSpec`.
-/

namespace BecomingSpecCheck

open Generative

/-! ## Adapter 1: `prefixMargin` & `live` ↔ `Becoming.RegimeMargin` + `Becoming.OpenComposition` -/

theorem adapter_stock_eq_regimeStep (g : Nat → Nat) (x h : Nat) :
    BecomingSpec.V1.stock g x h = Becoming.RegimeMargin.step g h x :=
  rfl

def toCountdownComp {Env : Type} (m : BecomingSpec.V1.MarginSpec Env) :
    Becoming.OpenComposition.OpenComponent Nat Bool Unit Empty Unit :=
  Becoming.OpenComposition.countdownComponent m.cap m.post (fun _ o => o)

def toCountdownContract {Env : Type} (m : BecomingSpec.V1.MarginSpec Env)
    (eta₀ : Nat) (hPost : m.post ≤ m.cap) (hEta : eta₀ ≤ m.lag) :
    Becoming.OpenComposition.InterfaceContract (toCountdownComp m) eta₀ :=
  Becoming.OpenComposition.countdownContract m.cap m.post 0 m.lag eta₀
    (fun _ o => o) (fun o => o = true) hPost hEta (fun _ _ _ ho => ho)

private theorem bool_ite_eq_prop_ite {c : Prop} [inst : Decidable c] {α : Type} (a b : α) :
    (if decide c = true then a else b) = (if c then a else b) := by
  cases inst with
  | isTrue _ => rfl
  | isFalse _ => rfl

theorem adapter_margin_closedStep_commutes {Env : Type} (m : BecomingSpec.V1.MarginSpec Env)
    (x : Unit → Nat) (eta : Nat) (st : Nat × Nat) (hx : x () = st.1) (heta : eta = st.2) (e : Env) :
    let stepSt := Becoming.OpenComposition.closedStep (toCountdownComp m)
      (fun arr => decide (arr () < m.warnLevel)) (fun em _ _ => em)
      (fun _ arr => m.g (arr ())) (fun env _ => m.envDraw env)
      (x, eta) (e, ())
    stepSt.1 () = (m.step st e).1 ∧ stepSt.2 = (m.step st e).2 := by
  dsimp only [Becoming.OpenComposition.closedStep, Becoming.OpenComposition.closedStepWith,
    toCountdownComp, Becoming.OpenComposition.countdownComponent,
    Becoming.OpenComposition.OpenComponent.ofOpenLoop, Becoming.OpenComposition.countdownLoop,
    Becoming.RegimeMargin.Coupled.Indexed.step, Becoming.RegimeMargin.Coupled.Indexed.left,
    Becoming.RegimeMargin.Drawn.whole, BecomingSpec.V1.MarginSpec.step,
    BecomingSpec.V1.MarginSpec.draw, BecomingSpec.V1.stock]
  rw [hx, heta]
  exact ⟨rfl, bool_ite_eq_prop_ite (st.2 - 1) st.2⟩

theorem v1_prefixMargin : BecomingSpec.V1.prefixMarginTarget := by
  intro Env m x₀ eta₀ es hValid hAdm
  rcases hValid with ⟨hMono, hPost, hEta, hEnvWithin, hPostViable, hWarnMargin, hInitMargin⟩
  let comp := toCountdownComp m
  let contract := toCountdownContract m eta₀ hPost hEta
  let obs : (Unit → Nat) → Bool := fun arr => decide (arr () < m.warnLevel)
  let chan : Bool → Nat → Env → Bool := fun em _ _ => em
  let G : Unit → (Unit → Nat) → Nat := fun _ arr => m.g (arr ())
  let envDraw : Env → Unit → Nat := fun env _ => m.envDraw env
  let envCap : Unit → Nat := fun _ => m.envCap
  let xCrit : Unit → Nat := fun _ => m.xCrit
  let warnLvl : Unit → Nat := fun _ => m.warnLevel
  let hSafe : Unit → Nat := fun _ => m.post + m.envCap
  have res := Becoming.OpenComposition.close_contract_viable comp contract obs chan G envDraw envCap
    m.adm (fun env he _ => hEnvWithin env he) xCrit warnLvl hSafe (fun _ => x₀)
    (fun x _ hlt => decide_eq_true hlt) (fun _ _ _ _ => rfl)
    (fun _ e₁ e₂ hle => hMono (e₁ ()) (e₂ ()) (hle ()))
    (fun _ => hPostViable) (fun _ => Nat.le_refl _) (fun _ => hWarnMargin) (fun _ => hInitMargin)
  have runInv : ∀ (es' : List Env) (x : Unit → Nat) (eta : Nat) (st : Nat × Nat),
      (∀ e, e ∈ es' → m.adm e) → x () = st.1 → eta = st.2 →
      Becoming.OpenComposition.closedInv contract envCap xCrit (x, eta) →
      let st' := m.run st es'
      m.xCrit + st'.2 * (m.cap + m.envCap) ≤ st'.1 ∧ st'.2 ≤ m.lag ∧ m.xCrit ≤ st'.1 := by
    intro es'
    induction es' with
    | nil =>
      intro x eta st _ hx heta hInv
      have hMargin := hInv.2 ()
      dsimp only at hMargin
      rw [hx, heta] at hMargin
      have hEtaLag : st.2 ≤ m.lag := heta ▸ hInv.1
      exact ⟨hMargin, hEtaLag, Nat.le_trans (Nat.le_add_right _ _) hMargin⟩
    | cons e rest ih =>
      intro x eta st hAll hx heta hInv
      have hStepComm := adapter_margin_closedStep_commutes m x eta st hx heta e
      have hTol : ∀ ob, contract.tol ob () := fun _ => trivial
      have hInv' := res.2.closed (x, eta) (e, ()) _ ⟨⟨hAll e (.head _), hTol⟩, rfl⟩ hInv
      exact ih _ _ (m.step st e) (fun e' he' => hAll e' (.tail _ he')) hStepComm.1 hStepComm.2 hInv'
  exact runInv es (fun _ => x₀) eta₀ (x₀, eta₀) hAdm rfl rfl res.1

private theorem liveG_mono : ∀ a b, a ≤ b → BecomingSpec.V1.liveG a ≤ BecomingSpec.V1.liveG b := by
  intro a b hab
  dsimp only [BecomingSpec.V1.liveG]
  cases Nat.decLe 4 a with
  | isTrue ha =>
    rw [if_pos ha, if_pos (Nat.le_trans ha hab)]
    exact Nat.le_refl 1
  | isFalse ha =>
    rw [if_neg ha]
    exact Nat.zero_le _

theorem v1_live : BecomingSpec.V1.liveTarget := by
  refine ⟨by decide, by decide, ?_, (), (), (), (), trivial, trivial, trivial, trivial, ?_⟩
  · exact ⟨liveG_mono, by decide, by decide, fun _ _ => Nat.zero_le 0, by decide, by decide, by decide⟩
  · refine ⟨by decide, by decide, by decide, by decide, by decide, by decide, rfl, by decide, by decide⟩

theorem adapter_live_openComposition_commutes :
    let comp := toCountdownComp BecomingSpec.V1.liveMargin
    let stepFn := Becoming.OpenComposition.closedStep comp
      (fun arr => decide (arr () < BecomingSpec.V1.liveMargin.warnLevel))
      (fun em _ _ => em) (fun _ arr => BecomingSpec.V1.liveMargin.g (arr ()))
      (fun env _ => BecomingSpec.V1.liveMargin.envDraw env)
    let st1 := stepFn (fun _ => 15, 2) ((), ())
    let st2 := stepFn st1 ((), ())
    let st3 := stepFn st2 ((), ())
    let st4 := stepFn st3 ((), ())
    (st1.1 (), st1.2) = (13, 2) ∧ (st2.1 (), st2.2) = (11, 1) ∧
    (st3.1 (), st3.2) = (9, 0) ∧ (st4.1 (), st4.2) = (9, 0) :=
  ⟨rfl, rfl, rfl, rfl⟩

/-! ## Adapter 2: `cycleBoundary` ↔ `Becoming.PacedStock.SlackShortWitness` -/

def toSlackState (s : Bool × Nat) : List Bool × Nat := ([s.1], s.2)

private theorem iter_succ {α : Type} (f : α → α) :
    ∀ (n : Nat) (x : α), BecomingSpec.V1.iter f (n + 1) x = f (BecomingSpec.V1.iter f n x)
  | 0, _ => rfl
  | n + 1, x => iter_succ f n (f x)

theorem adapter_cycleStep_commutes (s : Bool × Nat) (hPos : 1 ≤ s.2) :
    toSlackState (BecomingSpec.V1.cycleStep s) =
      Becoming.PacedStock.SlackShortWitness.fineStep (toSlackState s) := by
  obtain ⟨b, x⟩ := s
  cases x with
  | zero => exact absurd hPos (Nat.not_lt_zero 0)
  | succ x' =>
    have hPos' : decide (1 ≤ x' + 1) = true :=
      decide_eq_true (Nat.succ_le_succ (Nat.zero_le x'))
    cases b with
    | true =>
      change ([false], (x' + 1 - 4) + if 1 ≤ x' + 1 - 4 then 3 else 0) =
        ((cond (decide (1 ≤ x' + 1)) [false] []) ++ [],
         (x' + 1 - 4) + cond (decide (1 ≤ x' + 1 - 4)) 3 0)
      rw [hPos']
      cases hd : decide (1 ≤ x' + 1 - 4) with
      | true => rw [if_pos (of_decide_eq_true hd)]; rfl
      | false => rw [if_neg (of_decide_eq_false hd)]; rfl
    | false =>
      change ([true], (x' + 1 - 2) + if 1 ≤ x' + 1 - 2 then 3 else 0) =
        ((cond (decide (1 ≤ x' + 1)) [true] []) ++ [],
         (x' + 1 - 2) + cond (decide (1 ≤ x' + 1 - 2)) 3 0)
      rw [hPos']
      cases hd : decide (1 ≤ x' + 1 - 2) with
      | true => rw [if_pos (of_decide_eq_true hd)]; rfl
      | false => rw [if_neg (of_decide_eq_false hd)]; rfl

theorem adapter_cycleStep_reach6 :
    ∀ n, Becoming.Reach Becoming.PacedStock.SlackShortWitness.frame.P
      (toSlackState (true, 6)) (toSlackState (BecomingSpec.V1.iter BecomingSpec.V1.cycleStep n (true, 6)))
  | 0 => Becoming.Reach.refl _ _
  | n + 1 => by
    have ih := adapter_cycleStep_reach6 n
    have hGe5 : 5 ≤ (BecomingSpec.V1.iter BecomingSpec.V1.cycleStep n (true, 6)).2 :=
      Becoming.PacedStock.SlackShortWitness.atSix_fine_kernel_by_slack _ ih
    have hPos : 1 ≤ (BecomingSpec.V1.iter BecomingSpec.V1.cycleStep n (true, 6)).2 :=
      Nat.le_trans (by decide : 1 ≤ 5) hGe5
    have hStep : Becoming.PacedStock.SlackShortWitness.frame.P.step
        (toSlackState (BecomingSpec.V1.iter BecomingSpec.V1.cycleStep n (true, 6))) ()
        (toSlackState (BecomingSpec.V1.iter BecomingSpec.V1.cycleStep (n + 1) (true, 6))) := by
      rw [iter_succ]
      exact adapter_cycleStep_commutes _ hPos
    exact Becoming.Reach.trans ih (Becoming.Reach.of_step hStep)

private theorem cycleStep_pos_of_ge5 (s : Bool × Nat) (h5 : 5 ≤ s.2) :
    1 ≤ (BecomingSpec.V1.cycleStep s).2 := by
  dsimp only [BecomingSpec.V1.cycleStep, BecomingSpec.V1.cycleDraw, BecomingSpec.V1.stock]
  cases hb : s.1 with
  | true =>
    have h4 : 1 + 4 ≤ s.2 := h5
    have hsub : 1 ≤ s.2 - (if true = true then 4 else 2) :=
      Becoming.Naturals.le_sub_of_add_le h4
    exact Nat.le_trans hsub (Nat.le_add_right _ _)
  | false =>
    have h2 : 1 + 2 ≤ s.2 := Nat.le_trans (by decide : 1 + 2 ≤ 5) h5
    have hsub : 1 ≤ s.2 - (if false = true then 4 else 2) :=
      Becoming.Naturals.le_sub_of_add_le h2
    exact Nat.le_trans hsub (Nat.le_add_right _ _)

theorem adapter_cycleStep2_reach5 :
    ∀ n, Becoming.Reach
      (Becoming.PacedStock.SlackShortWitness.frame.blocks Becoming.PacedStock.SlackShortWitness.expand).P
      (toSlackState (true, 5))
      (toSlackState (BecomingSpec.V1.iter (fun s => BecomingSpec.V1.cycleStep (BecomingSpec.V1.cycleStep s)) n (true, 5)))
  | 0 => Becoming.Reach.refl _ _
  | n + 1 => by
    have ih := adapter_cycleStep2_reach5 n
    let cur := BecomingSpec.V1.iter (fun s => BecomingSpec.V1.cycleStep (BecomingSpec.V1.cycleStep s)) n (true, 5)
    have hGe5 : 5 ≤ cur.2 := Becoming.PacedStock.SlackShortWitness.atFive_block_kernel _ ih
    have hPos1 : 1 ≤ cur.2 := Nat.le_trans (by decide : 1 ≤ 5) hGe5
    have hPos2 : 1 ≤ (BecomingSpec.V1.cycleStep cur).2 := cycleStep_pos_of_ge5 cur hGe5
    have step1 : Becoming.PacedStock.SlackShortWitness.frame.P.step
        (toSlackState cur) () (toSlackState (BecomingSpec.V1.cycleStep cur)) :=
      adapter_cycleStep_commutes cur hPos1
    have step2 : Becoming.PacedStock.SlackShortWitness.frame.P.step
        (toSlackState (BecomingSpec.V1.cycleStep cur)) ()
        (toSlackState (BecomingSpec.V1.cycleStep (BecomingSpec.V1.cycleStep cur))) :=
      adapter_cycleStep_commutes (BecomingSpec.V1.cycleStep cur) hPos2
    have blockStep : (Becoming.PacedStock.SlackShortWitness.frame.blocks
        Becoming.PacedStock.SlackShortWitness.expand).P.step
        (toSlackState cur) ()
        (toSlackState (BecomingSpec.V1.iter (fun s => BecomingSpec.V1.cycleStep (BecomingSpec.V1.cycleStep s)) (n + 1) (true, 5))) := by
      rw [iter_succ]
      exact .cons step1 (.cons step2 (.nil _))
    exact Becoming.Reach.trans ih (Becoming.Reach.of_step blockStep)

theorem v1_cycleBoundary : BecomingSpec.V1.cycleBoundaryTarget := by
  refine ⟨?_, ⟨1, by decide⟩, ?_⟩
  · intro n
    exact Becoming.PacedStock.SlackShortWitness.atSix_fine_kernel_by_slack
      (toSlackState (BecomingSpec.V1.iter BecomingSpec.V1.cycleStep n (true, 6)))
      (adapter_cycleStep_reach6 n)
  · intro n
    exact Becoming.PacedStock.SlackShortWitness.atFive_block_kernel
      (toSlackState (BecomingSpec.V1.iter
        (fun s => BecomingSpec.V1.cycleStep (BecomingSpec.V1.cycleStep s)) n (true, 5)))
      (adapter_cycleStep2_reach5 n)

/-! ## Adapter 3: `sameView_obstruction` ↔ `Becoming.OplaxHistory.FiberViabilitySplit` -/

theorem adapter_sameView_to_fiberSplit {H V : Type} (view : H → V) (safe : H → Prop)
    {h₀ h₁ : H} (heq : view h₀ = view h₁) (hs0 : safe h₀) (hns1 : ¬ safe h₁) :
    Becoming.OplaxHistory.FiberViabilitySplit view safe ∧
    ∀ Kq : V → Prop, ¬ ((∀ u, safe u → Kq (view u)) ∧ (∀ u, Kq (view u) → safe u)) :=
  let hsplit : Becoming.OplaxHistory.FiberViabilitySplit view safe := ⟨h₀, h₁, heq, hs0, hns1⟩
  ⟨hsplit, fun Kq => Becoming.OplaxHistory.fiberSplit_refutes_macro_viability_soundness hsplit Kq⟩

theorem v1_sameViewObstruction : BecomingSpec.V1.sameViewObstructionTarget := by
  intro H V view safe h₀ h₁ heq hs0 hns1
  refine ⟨fun dec => congrArg dec heq, ?_⟩
  intro ⟨dec, hiff0, hiff1⟩
  have hdt0 : dec (view h₀) = true := hiff0.mpr hs0
  have hdt1 : dec (view h₁) = true := (congrArg dec heq).symm.trans hdt0
  exact hns1 (hiff1.mp hdt1)

theorem v1_in1SameViewWitness : BecomingSpec.V1.in1SameViewWitnessTarget :=
  ⟨rfl, rfl, rfl, fun _ => rfl⟩

/-! ## Adapter 4: `commonAction` ↔ `Becoming.GuardHorizon` + `InquirySufficiency.finite_choice` -/

private def hasObs {H : Type} {n : Nat} (obs : H → Fin n) (o : Fin n) : List H → Bool
  | [] => false
  | h :: hs => match Nat.decEq (obs h).val o.val with
    | isTrue _ => true
    | isFalse _ => hasObs obs o hs

private theorem hasObs_sound {H : Type} {n : Nat} (obs : H → Fin n) (o : Fin n) :
    ∀ hs : List H, hasObs obs o hs = true → ∃ h, h ∈ hs ∧ obs h = o
  | [], hf => Bool.noConfusion hf
  | h :: hs, ht => by
    dsimp only [hasObs] at ht
    cases hEq : Nat.decEq (obs h).val o.val with
    | isTrue hv => exact ⟨h, .head _, Fin.ext hv⟩
    | isFalse hnv =>
      rw [hEq] at ht
      obtain ⟨h', hMem, hObs⟩ := hasObs_sound obs o hs ht
      exact ⟨h', .tail _ hMem, hObs⟩

private theorem hasObs_complete {H : Type} {n : Nat} (obs : H → Fin n) (o : Fin n) :
    ∀ {hs : List H}, hasObs obs o hs = false → ∀ h, h ∈ hs → obs h ≠ o
  | [], _, _, hMem => nomatch hMem
  | h :: hs, hf, h', hMem => by
    dsimp only [hasObs] at hf
    cases hEq : Nat.decEq (obs h).val o.val with
    | isTrue hv => rw [hEq] at hf; exact Bool.noConfusion hf
    | isFalse hnv =>
      rw [hEq] at hf
      cases hMem with
      | head => exact fun eq => hnv (congrArg Fin.val eq)
      | tail _ hTail => exact hasObs_complete obs o hf h' hTail

def choiceFin (n : Nat) (A : Type) : Becoming.Viability.ChoiceOver (Fin n) A :=
  fun R h => Generative.InquirySufficiency.finite_choice R h

theorem adapter_commonAction_via_guardHorizon {H A : Type} {n : Nat}
    (hs : List H) (obs : H → Fin n) (U : H → A → Prop) (a₀ : A) :
    Becoming.GuardHorizon.UniformPolicy obs (fun h a => h ∈ hs → U h a) ↔
      ∀ o : Fin n, (∃ h, h ∈ hs ∧ obs h = o) → ∃ a : A, ∀ h, h ∈ hs → obs h = o → U h a := by
  let good : H → A → Prop := fun h a => h ∈ hs → U h a
  have hGH := Becoming.GuardHorizon.uniform_policy_iff_fiber_feasible (choiceFin n A) obs good
  constructor
  · intro hU o ⟨_, _, _⟩
    obtain ⟨a, ha⟩ := hGH.mp hU o
    exact ⟨a, fun h hMem hObs => ha h hObs hMem⟩
  · intro hReach
    refine hGH.mpr fun o => ?_
    cases hb : hasObs obs o hs with
    | true =>
      obtain ⟨a, ha⟩ := hReach o (hasObs_sound obs o hs hb)
      exact ⟨a, fun h hObs hMem => ha h hMem hObs⟩
    | false =>
      exact ⟨a₀, fun h hObs hMem => absurd hObs (hasObs_complete obs o hb h hMem)⟩

theorem v1_commonAction : BecomingSpec.V1.commonActionTarget := by
  intro H A n hs obs U a₀
  have hAd := adapter_commonAction_via_guardHorizon hs obs U a₀
  exact ⟨fun ⟨π, hπ⟩ => hAd.mp ⟨π, fun h hMem => hπ h hMem⟩,
    fun hF => let ⟨π, hπ⟩ := hAd.mpr hF; ⟨π, fun h hMem => hπ h hMem⟩⟩

/-! ## Adapter 5: `completes` & `branch_stuck` ↔ `Becoming.Assurance` -/

def toProcess {S A : Type} (step : BecomingSpec.V1.StepRel S A) : Process S A := ⟨step⟩

theorem adapter_trace_iff {S A : Type} (step : BecomingSpec.V1.StepRel S A) :
    ∀ {s t : S} {plan : List A},
      BecomingSpec.V1.Trace step s plan t ↔ Trace (toProcess step) s plan t := by
  intro s t plan
  constructor
  · intro tr
    induction tr with
    | nil s => exact .nil s
    | cons h1 _ ih => exact .cons h1 ih
  · intro tr
    induction tr with
    | nil s => exact .nil s
    | cons h1 _ ih => exact .cons h1 ih

theorem adapter_safeTrace_iff {S A : Type} (step safe : BecomingSpec.V1.StepRel S A) :
    ∀ {s t : S} {plan : List A},
      BecomingSpec.V1.SafeTrace step safe s plan t ↔
        InquirySufficiency.SafeTrace (toProcess step) safe s plan t := by
  intro s t plan
  constructor
  · intro tr
    induction tr with
    | nil s => exact .nil s
    | cons h1 h2 _ ih => exact .cons h1 h2 ih
  · intro tr
    induction tr with
    | nil s => exact .nil s
    | cons h1 h2 _ ih => exact .cons h1 h2 ih

theorem adapter_completes_iff {S A : Type} (step safe : BecomingSpec.V1.StepRel S A)
    (goal : S → Prop) : ∀ (s : S) (plan : List A),
      BecomingSpec.V1.Completes step safe goal s plan ↔
        InquirySufficiency.Completes (toProcess step) safe goal s plan
  | _, [] => Iff.rfl
  | _, _ :: rest =>
    ⟨fun ⟨hEn, hAll⟩ => ⟨hEn, fun t hst =>
        ⟨(hAll t hst).1, (adapter_completes_iff step safe goal t rest).mp (hAll t hst).2⟩⟩,
     fun ⟨hEn, hAll⟩ => ⟨hEn, fun t hst =>
        ⟨(hAll t hst).1, (adapter_completes_iff step safe goal t rest).mpr (hAll t hst).2⟩⟩⟩

theorem adapter_determined_iff {S A : Type} (step : BecomingSpec.V1.StepRel S A) :
    BecomingSpec.V1.Determined step ↔ Becoming.Determined (toProcess step) :=
  Iff.rfl

theorem adapter_branchStep_eq :
    toProcess BecomingSpec.V1.branchStep = Becoming.Assurance.Branch.process :=
  rfl

theorem v1_completes : BecomingSpec.V1.completesTarget := by
  constructor
  · intro S A step safe goal s plan hComp
    have hRuns := Becoming.Assurance.runs_of_completes
      ((adapter_completes_iff step safe goal s plan).mp hComp)
    refine ⟨let ⟨t, ht⟩ := hRuns.1; ⟨t, (adapter_trace_iff step).mpr ht⟩, fun t ht => ?_⟩
    have h := hRuns.2 t ((adapter_trace_iff step).mp ht)
    exact ⟨(adapter_safeTrace_iff step safe).mpr h.1, h.2⟩
  · intro S A step safe goal s plan hDet
    have hIff := Becoming.Assurance.completes_iff_of_determined
      ((adapter_determined_iff step).mp hDet) (safe := safe) (goal := goal) (s := s) (plan := plan)
    refine (adapter_completes_iff step safe goal s plan).trans (hIff.trans ?_)
    constructor
    · intro ⟨⟨t, ht⟩, hAll⟩
      refine ⟨⟨t, (adapter_trace_iff step).mpr ht⟩, fun t' ht' => ?_⟩
      have h := hAll t' ((adapter_trace_iff step).mp ht')
      exact ⟨(adapter_safeTrace_iff step safe).mpr h.1, h.2⟩
    · intro ⟨⟨t, ht⟩, hAll⟩
      refine ⟨⟨t, (adapter_trace_iff step).mp ht⟩, fun t' ht' => ?_⟩
      have h := hAll t' ((adapter_trace_iff step).mpr ht')
      exact ⟨(adapter_safeTrace_iff step safe).mp h.1, h.2⟩

theorem v1_branchStuck : BecomingSpec.V1.branchStuckTarget := by
  have hB := Becoming.Assurance.Branch.runs_not_completes
  refine ⟨?_, ?_, ?_⟩
  · obtain ⟨t, ht⟩ := hB.1.1
    exact ⟨t, (adapter_trace_iff BecomingSpec.V1.branchStep).mpr (adapter_branchStep_eq ▸ ht)⟩
  · intro t ht
    exact hB.1.2 t (adapter_branchStep_eq ▸ (adapter_trace_iff BecomingSpec.V1.branchStep).mp ht)
  · intro hComp
    apply hB.2
    exact (adapter_completes_iff BecomingSpec.V1.branchStep _ _ 0 [(), ()]).mp hComp

/-! ## Adapter 6: `significanceFree` ↔ `Becoming.Significance` -/

theorem adapter_unrestricted_iff {Pos F : Type} (sig : Pos → Nat → F → Prop) :
    BecomingSpec.V1.Unrestricted sig ↔ Becoming.Unrestricted sig :=
  ⟨fun h ⟨p, t, f⟩ => h p t f, fun h p t f => h (p, t, f)⟩

theorem v1_significanceFree : BecomingSpec.V1.significanceFreeTarget := by
  constructor
  · intro Pos F D p f law ⟨d, hd⟩ hEnt
    apply Becoming.dynamicsLaw_cannot_entail_unrestricted (Pos := Pos) (F := F) hd p f
    intro d' hd' sig
    exact (adapter_unrestricted_iff sig).mp (hEnt d' hd' sig)
  · intro Pos F D p f law hReads ⟨d, sig, hd⟩ hEnt
    exact Becoming.ReadsOnlyDynamics.not_entails hReads
      (fun d' sig' h' => (adapter_unrestricted_iff sig').mp (hEnt d' sig' h')) p f hd

/-! ## Adapter 7: V2 & IN1 View Refinement + `Becoming.OplaxHistory.FiberViabilitySplit` -/

theorem v2_eraseCommutes : BecomingSpec.V2.eraseCommutesTarget :=
  fun _ => rfl

theorem v2_pass2RefinesPass1 : BecomingSpec.V2.pass2RefinesPass1Target :=
  fun _ hp => hp.1

theorem v2_v1Blindness : BecomingSpec.V2.v1BlindnessTarget :=
  fun _ _ heq _ _ dec => congrArg dec heq

theorem adapter_in1_fiberSplit {h₀ h₁ : BecomingSpec.V2.LakeHistory}
    (heq : BecomingSpec.V2.q₁ h₀ = BecomingSpec.V2.q₁ h₁)
    (hp0 : BecomingSpec.V2.Pass₂ (BecomingSpec.V2.q₂ h₀))
    (hnp1 : ¬ BecomingSpec.V2.Pass₂ (BecomingSpec.V2.q₂ h₁)) :
    Becoming.OplaxHistory.FiberViabilitySplit BecomingSpec.V2.q₁
      (fun h => BecomingSpec.V2.Pass₂ (BecomingSpec.V2.q₂ h)) :=
  ⟨h₀, h₁, heq, hp0, hnp1⟩

theorem in1_sameView : BecomingSpec.Revision.IN1.in1SameViewTarget :=
  rfl

theorem in1_separation : BecomingSpec.Revision.IN1.in1SeparationTarget :=
  ⟨show 70 ≤ 100 by decide, ⟨show 70 ≤ 100 by decide, rfl⟩,
    fun h => Bool.noConfusion h.2, rfl, rfl⟩

theorem in1_decisionDefeat : BecomingSpec.Revision.IN1.in1DecisionDefeatTarget :=
  fun _ => rfl

theorem in1_seed3FaithfulHarm : BecomingSpec.Revision.IN1.in1Seed3FaithfulHarmTarget :=
  ⟨(fun m hm => by
     cases hm with
     | head => rfl
     | tail _ hTail => cases hTail),
   show 70 ≤ 80 by decide, fun h => Bool.noConfusion h.2, rfl, rfl⟩

theorem in1_seed7RevisionSaves : BecomingSpec.Revision.IN1.in1Seed7RevisionSavesTarget := by
  refine ⟨?_, ⟨show 70 ≤ 100 by decide, rfl⟩, rfl, show 70 ≤ 100 by decide,
    fun h => Bool.noConfusion h.2, rfl, ⟨show 70 ≤ 100 by decide, rfl⟩, rfl,
    show 70 ≤ 100 by decide, fun h => Bool.noConfusion h.2, rfl⟩
  intro hf
  have hReq := hf _ (.head _)
  exact absurd (congrArg (fun r : BecomingSpec.V2.Triple => r.2.1) hReq) (by decide)

/-! ## Adapter 8: `Extensions.OplaxTargets` ↔ `Becoming.OplaxHistory` -/

def toOplaxSpan {A B : Type} (S : BecomingSpec.Extensions.Span A B) :
    Becoming.OplaxHistory.RelSpan A B where
  W := S.W
  left := S.left
  right := S.right

def toOplaxFunctor (F : BecomingSpec.Extensions.Functor) : Becoming.OplaxHistory.SpanFunctor where
  obj := F.obj
  map := F.map
  map_id := F.map_id
  map_comp := F.map_comp
  map_congr := F.map_congr

private def pbToOplax {W₁ W₂ D : Type} {r : W₁ → D} {l : W₂ → D}
    (p : BecomingSpec.Extensions.Pullback r l) : Becoming.OplaxHistory.PullbackElem r l :=
  ⟨p.fst, p.snd, p.mid⟩

private def pbFromOplax {W₁ W₂ D : Type} {r : W₁ → D} {l : W₂ → D}
    (p : Becoming.OplaxHistory.PullbackElem r l) : BecomingSpec.Extensions.Pullback r l :=
  ⟨p.fst, p.snd, p.mid⟩

private theorem pbToFrom {W₁ W₂ D : Type} {r : W₁ → D} {l : W₂ → D}
    (p : Becoming.OplaxHistory.PullbackElem r l) : pbToOplax (pbFromOplax p) = p :=
  rfl

private theorem pbFromTo {W₁ W₂ D : Type} {r : W₁ → D} {l : W₂ → D}
    (p : BecomingSpec.Extensions.Pullback r l) : pbFromOplax (pbToOplax p) = p :=
  rfl

private theorem pbInj {W₁ W₂ D : Type} {r : W₁ → D} {l : W₂ → D}
    {p q : BecomingSpec.Extensions.Pullback r l} (h1 : p.fst = q.fst) (h2 : p.snd = q.snd) : p = q := by
  cases p; cases q
  change _ = _ at h1; change _ = _ at h2
  subst h1; subst h2; rfl

theorem adapter_chi_bijective_iff (F : BecomingSpec.Extensions.Functor) {A D C : Type}
    (H : BecomingSpec.Extensions.Span A D) (K : BecomingSpec.Extensions.Span D C) :
    BecomingSpec.Extensions.IsBijective (BecomingSpec.Extensions.chi F H K) ↔
      Becoming.OplaxHistory.IsBijective
        (Becoming.OplaxHistory.chi (toOplaxFunctor F) (toOplaxSpan H) (toOplaxSpan K)).map := by
  let chiS := BecomingSpec.Extensions.chi F H K
  let chiO := (Becoming.OplaxHistory.chi (toOplaxFunctor F) (toOplaxSpan H) (toOplaxSpan K)).map
  have hFst : ∀ x : BecomingSpec.Extensions.Pullback H.right K.left,
      Becoming.OplaxHistory.PullbackElem.fst (pbToOplax x) = x.fst := fun _ => rfl
  have hSnd : ∀ x : BecomingSpec.Extensions.Pullback H.right K.left,
      Becoming.OplaxHistory.PullbackElem.snd (pbToOplax x) = x.snd := fun _ => rfl
  have hFst' : ∀ x : Becoming.OplaxHistory.PullbackElem H.right K.left,
      BecomingSpec.Extensions.Pullback.fst (pbFromOplax x) = x.fst := fun _ => rfl
  have hSnd' : ∀ x : Becoming.OplaxHistory.PullbackElem H.right K.left,
      BecomingSpec.Extensions.Pullback.snd (pbFromOplax x) = x.snd := fun _ => rfl
  have hComm : ∀ u : F.obj (Becoming.OplaxHistory.PullbackElem H.right K.left),
      pbToOplax (chiS (F.map pbFromOplax u)) = chiO u := by
    intro u
    refine Becoming.OplaxHistory.PullbackElem.ext ?_ ?_
    · exact (F.map_comp BecomingSpec.Extensions.Pullback.fst pbFromOplax u).symm.trans
        (F.map_congr hFst' u)
    · exact (F.map_comp BecomingSpec.Extensions.Pullback.snd pbFromOplax u).symm.trans
        (F.map_congr hSnd' u)
  have hComm' : ∀ u : F.obj (BecomingSpec.Extensions.Pullback H.right K.left),
      pbFromOplax (chiO (F.map pbToOplax u)) = chiS u := by
    intro u
    refine pbInj ?_ ?_
    · exact (F.map_comp Becoming.OplaxHistory.PullbackElem.fst pbToOplax u).symm.trans
        (F.map_congr hFst u)
    · exact (F.map_comp Becoming.OplaxHistory.PullbackElem.snd pbToOplax u).symm.trans
        (F.map_congr hSnd u)
  have hMapInv₁ : ∀ u : F.obj (BecomingSpec.Extensions.Pullback H.right K.left),
      F.map (@pbFromOplax H.W K.W D H.right K.left) (F.map (@pbToOplax H.W K.W D H.right K.left) u) = u := fun u =>
    (F.map_comp (@pbFromOplax H.W K.W D H.right K.left) (@pbToOplax H.W K.W D H.right K.left) u).symm.trans
      ((F.map_congr (@pbFromTo H.W K.W D H.right K.left) u).trans (F.map_id u))
  have hMapInv₂ : ∀ u : F.obj (Becoming.OplaxHistory.PullbackElem H.right K.left),
      F.map (@pbToOplax H.W K.W D H.right K.left) (F.map (@pbFromOplax H.W K.W D H.right K.left) u) = u := fun u =>
    (F.map_comp (@pbToOplax H.W K.W D H.right K.left) (@pbFromOplax H.W K.W D H.right K.left) u).symm.trans
      ((F.map_congr (@pbToFrom H.W K.W D H.right K.left) u).trans (F.map_id u))
  constructor
  · intro ⟨hinj, hsurj⟩
    refine ⟨?_, ?_⟩
    · intro u₁ u₂ heq
      have h1 : chiS (F.map pbFromOplax u₁) = chiS (F.map pbFromOplax u₂) := by
        have h' : pbFromOplax (chiO u₁) = pbFromOplax (chiO u₂) := congrArg pbFromOplax heq
        have hu1 := congrArg pbFromOplax (hComm u₁)
        have hu2 := congrArg pbFromOplax (hComm u₂)
        rw [pbFromTo] at hu1 hu2
        exact hu1.trans (h'.trans hu2.symm)
      have h2 := hinj _ _ h1
      have h3 := congrArg (F.map pbToOplax) h2
      exact (hMapInv₂ u₁).symm.trans (h3.trans (hMapInv₂ u₂))
    · intro y
      obtain ⟨v, hv⟩ := hsurj (pbFromOplax y)
      refine ⟨F.map pbToOplax v, ?_⟩
      have hy : pbToOplax (chiS v) = y := congrArg pbToOplax hv
      have hEq := congrArg pbToOplax (hComm' v)
      rw [pbToFrom] at hEq
      exact hEq.trans hy
  · intro ⟨hinj, hsurj⟩
    refine ⟨?_, ?_⟩
    · intro u₁ u₂ heq
      have h1 : chiO (F.map pbToOplax u₁) = chiO (F.map pbToOplax u₂) := by
        have h' : pbToOplax (chiS u₁) = pbToOplax (chiS u₂) := congrArg pbToOplax heq
        have hu1 := congrArg pbToOplax (hComm' u₁)
        have hu2 := congrArg pbToOplax (hComm' u₂)
        rw [pbToFrom] at hu1 hu2
        exact hu1.trans (h'.trans hu2.symm)
      have h2 := hinj _ _ h1
      have h3 := congrArg (F.map pbFromOplax) h2
      exact (hMapInv₁ u₁).symm.trans (h3.trans (hMapInv₁ u₂))
    · intro y
      obtain ⟨v, hv⟩ := hsurj (pbToOplax y)
      refine ⟨F.map pbFromOplax v, ?_⟩
      have hy : pbFromOplax (chiO v) = y := congrArg pbFromOplax hv
      have hEq := congrArg pbFromOplax (hComm v)
      rw [pbFromTo] at hEq
      exact hEq.trans hy

private theorem bcMap_const_bijective_iff (F : BecomingSpec.Extensions.Functor) {A D C : Type}
    (H : BecomingSpec.Extensions.Span A D) (K : BecomingSpec.Extensions.Span D C)
    (X : Type) (v : F.obj K.W) :
    BecomingSpec.Extensions.IsBijective (BecomingSpec.Extensions.bcMap F H K (fun _ => X) v) ↔
      Becoming.OplaxHistory.IsBijective
        (Becoming.OplaxHistory.bcMap (toOplaxFunctor F) (toOplaxSpan H) (toOplaxSpan K) (fun _ => X) v) := by
  let fS := BecomingSpec.Extensions.bcMap F H K (fun _ => X) v
  let fO := Becoming.OplaxHistory.bcMap (toOplaxFunctor F) (toOplaxSpan H) (toOplaxSpan K) (fun _ => X) v
  have hMapInv₁ : ∀ u : F.obj (BecomingSpec.Extensions.Pullback H.right K.left),
      F.map (@pbFromOplax H.W K.W D H.right K.left) (F.map (@pbToOplax H.W K.W D H.right K.left) u) = u := fun u =>
    (F.map_comp (@pbFromOplax H.W K.W D H.right K.left) (@pbToOplax H.W K.W D H.right K.left) u).symm.trans
      ((F.map_congr (@pbFromTo H.W K.W D H.right K.left) u).trans (F.map_id u))
  have hMapInv₂ : ∀ u : F.obj (Becoming.OplaxHistory.PullbackElem H.right K.left),
      F.map (@pbToOplax H.W K.W D H.right K.left) (F.map (@pbFromOplax H.W K.W D H.right K.left) u) = u := fun u =>
    (F.map_comp (@pbToOplax H.W K.W D H.right K.left) (@pbFromOplax H.W K.W D H.right K.left) u).symm.trans
      ((F.map_congr (@pbToFrom H.W K.W D H.right K.left) u).trans (F.map_id u))
  let toL (x : BecomingSpec.Extensions.BCLeft F H K (fun _ => X) v) :
      Becoming.OplaxHistory.BCLeft (toOplaxFunctor F) (toOplaxSpan H) (toOplaxSpan K) (fun _ => X) v :=
    ⟨F.map pbToOplax x.u,
     (F.map_comp Becoming.OplaxHistory.PullbackElem.snd pbToOplax x.u).symm.trans
       ((F.map_congr (fun _ => rfl) x.u).trans x.eqV),
     x.val⟩
  let fromL (x : Becoming.OplaxHistory.BCLeft (toOplaxFunctor F) (toOplaxSpan H) (toOplaxSpan K) (fun _ => X) v) :
      BecomingSpec.Extensions.BCLeft F H K (fun _ => X) v :=
    ⟨F.map pbFromOplax x.u,
     (F.map_comp BecomingSpec.Extensions.Pullback.snd pbFromOplax x.u).symm.trans
       ((F.map_congr (fun _ => rfl) x.u).trans x.eqV),
     x.val⟩
  let toR (y : BecomingSpec.Extensions.BCRight F H K (fun _ => X) v) :
      Becoming.OplaxHistory.BCRight (toOplaxFunctor F) (toOplaxSpan H) (toOplaxSpan K) (fun _ => X) v :=
    ⟨y.w, y.eqMid, y.val⟩
  let fromR (y : Becoming.OplaxHistory.BCRight (toOplaxFunctor F) (toOplaxSpan H) (toOplaxSpan K) (fun _ => X) v) :
      BecomingSpec.Extensions.BCRight F H K (fun _ => X) v :=
    ⟨y.w, y.eqMid, y.val⟩
  have hFromToR : ∀ y, fromR (toR y) = y := fun _ => rfl
  have hToFromR : ∀ y, toR (fromR y) = y := fun _ => rfl
  have hFromToL : ∀ x, fromL (toL x) = x := by
    intro ⟨u, eqV, val⟩
    have hu : F.map pbFromOplax (F.map pbToOplax u) = u := hMapInv₁ u
    dsimp only [fromL, toL]
    have aux : ∀ {u' : F.obj (BecomingSpec.Extensions.Pullback H.right K.left)} (h : u' = u)
        (eq' : F.map BecomingSpec.Extensions.Pullback.snd u' = v),
        (BecomingSpec.Extensions.BCLeft.mk u' eq' val :
          BecomingSpec.Extensions.BCLeft F H K (fun _ => X) v) = ⟨u, eqV, val⟩ := by
      intro u' h eq'
      cases h
      rfl
    exact aux hu _
  have hToFromL : ∀ x, toL (fromL x) = x := by
    intro ⟨u, eqV, val⟩
    have hu : F.map pbToOplax (F.map pbFromOplax u) = u := hMapInv₂ u
    dsimp only [toL, fromL]
    have aux : ∀ {u' : F.obj (Becoming.OplaxHistory.PullbackElem H.right K.left)} (h : u' = u)
        (eq' : F.map Becoming.OplaxHistory.PullbackElem.snd u' = v),
        (Becoming.OplaxHistory.BCLeft.mk u' eq' val :
          Becoming.OplaxHistory.BCLeft (toOplaxFunctor F) (toOplaxSpan H) (toOplaxSpan K) (fun _ => X) v) = ⟨u, eqV, val⟩ := by
      intro u' h eq'
      cases h
      rfl
    exact aux hu _
  have hCommL : ∀ x, toR (fS x) = fO (toL x) := by
    intro ⟨u, eqV, val⟩
    dsimp only [toR, fS, BecomingSpec.Extensions.bcMap, fO, Becoming.OplaxHistory.bcMap, toL]
    have hw : F.map BecomingSpec.Extensions.Pullback.fst u =
        F.map Becoming.OplaxHistory.PullbackElem.fst (F.map pbToOplax u) :=
      ((F.map_comp Becoming.OplaxHistory.PullbackElem.fst pbToOplax u).symm.trans
        (F.map_congr (fun _ => rfl) u)).symm
    exact Becoming.OplaxHistory.bcRight_mk_ext hw rfl
  have hCommR : ∀ x, fromR (fO x) = fS (fromL x) := by
    intro ⟨u, eqV, val⟩
    dsimp only [fromR, fO, Becoming.OplaxHistory.bcMap, fS, BecomingSpec.Extensions.bcMap, fromL]
    have hw : F.map Becoming.OplaxHistory.PullbackElem.fst u =
        F.map BecomingSpec.Extensions.Pullback.fst (F.map pbFromOplax u) :=
      ((F.map_comp BecomingSpec.Extensions.Pullback.fst pbFromOplax u).symm.trans
        (F.map_congr (fun _ => rfl) u)).symm
    have aux : ∀ {w₁ w₂ : F.obj H.W} (h : w₁ = w₂)
        {eq₁ : F.map H.right w₁ = F.map K.left v} {eq₂ : F.map H.right w₂ = F.map K.left v},
        (BecomingSpec.Extensions.BCRight.mk w₁ eq₁ val :
          BecomingSpec.Extensions.BCRight F H K (fun _ => X) v) = ⟨w₂, eq₂, val⟩ := by
      intro w₁ w₂ h eq₁ eq₂
      cases h
      rfl
    exact aux hw
  constructor
  · intro ⟨hinj, hsurj⟩
    refine ⟨?_, ?_⟩
    · intro x₁ x₂ heq
      have h1 : fS (fromL x₁) = fS (fromL x₂) := by
        have h' : fromR (fO x₁) = fromR (fO x₂) := congrArg fromR heq
        rw [hCommR x₁, hCommR x₂] at h'
        exact h'
      have h2 := congrArg toL (hinj _ _ h1)
      exact (hToFromL x₁).symm.trans (h2.trans (hToFromL x₂))
    · intro y
      obtain ⟨x, hx⟩ := hsurj (fromR y)
      refine ⟨toL x, ?_⟩
      have h1 : toR (fS x) = toR (fromR y) := congrArg toR hx
      rw [hCommL x, hToFromR y] at h1
      exact h1
  · intro ⟨hinj, hsurj⟩
    refine ⟨?_, ?_⟩
    · intro x₁ x₂ heq
      have h1 : fO (toL x₁) = fO (toL x₂) := by
        have h' : toR (fS x₁) = toR (fS x₂) := congrArg toR heq
        rw [hCommL x₁, hCommL x₂] at h'
        exact h'
      have h2 := congrArg fromL (hinj _ _ h1)
      exact (hFromToL x₁).symm.trans (h2.trans (hFromToL x₂))
    · intro y
      obtain ⟨x, hx⟩ := hsurj (toR y)
      refine ⟨fromL x, ?_⟩
      have h1 : fromR (fO x) = fromR (toR y) := congrArg fromR hx
      rw [hCommR x, hFromToR y] at h1
      exact h1

private theorem pbExt {W₁ W₂ D : Type} {r : W₁ → D} {l : W₂ → D}
    {p q : BecomingSpec.Extensions.Pullback r l} (h1 : p.fst = q.fst) (h2 : p.snd = q.snd) : p = q := by
  cases p; cases q
  change _ = _ at h1; change _ = _ at h2
  subst h1; subst h2; rfl

private theorem bcRightValEq {F : BecomingSpec.Extensions.Functor} {A D C : Type}
    {H : BecomingSpec.Extensions.Span A D} {K : BecomingSpec.Extensions.Span D C}
    {E : F.obj H.W → Type} {v : F.obj K.W}
    {w₁ w₂ : F.obj H.W} (hw : w₁ = w₂)
    {eq₁ : F.map H.right w₁ = F.map K.left v} {eq₂ : F.map H.right w₂ = F.map K.left v}
    {val₁ : E w₁} {val₂ : E w₂}
    (heq : (BecomingSpec.Extensions.BCRight.mk w₁ eq₁ val₁ :
      BecomingSpec.Extensions.BCRight F H K E v) = ⟨w₂, eq₂, val₂⟩) :
    (hw ▸ val₁ : E w₂) = val₂ := by
  cases heq
  rfl

private theorem bcLeftMkExt {F : BecomingSpec.Extensions.Functor} {A D C : Type}
    {H : BecomingSpec.Extensions.Span A D} {K : BecomingSpec.Extensions.Span D C}
    {E : F.obj H.W → Type} {v : F.obj K.W}
    {u : F.obj (BecomingSpec.Extensions.Pullback H.right K.left)}
    {eq₁ eq₂ : F.map BecomingSpec.Extensions.Pullback.snd u = v}
    {val₁ val₂ : E (F.map BecomingSpec.Extensions.Pullback.fst u)}
    (hval : val₁ = val₂) :
    (BecomingSpec.Extensions.BCLeft.mk u eq₁ val₁ :
      BecomingSpec.Extensions.BCLeft F H K E v) = ⟨u, eq₂, val₂⟩ := by
  subst hval
  rfl

private theorem bcRightMkExt {F : BecomingSpec.Extensions.Functor} {A D C : Type}
    {H : BecomingSpec.Extensions.Span A D} {K : BecomingSpec.Extensions.Span D C}
    {E : F.obj H.W → Type} {v : F.obj K.W}
    {w₁ w₂ : F.obj H.W} (hw : w₁ = w₂)
    {eq₁ : F.map H.right w₁ = F.map K.left v} {eq₂ : F.map H.right w₂ = F.map K.left v}
    {val₁ : E w₁} {val₂ : E w₂}
    (hval : (hw ▸ val₁ : E w₂) = val₂) :
    (BecomingSpec.Extensions.BCRight.mk w₁ eq₁ val₁ :
      BecomingSpec.Extensions.BCRight F H K E v) = ⟨w₂, eq₂, val₂⟩ := by
  cases hw
  cases hval
  rfl

theorem ext_allFibers : BecomingSpec.Extensions.allFibersTarget := by
  intro F A D C H K
  have hOplax := Becoming.OplaxHistory.chi_bijective_iff_bc_all (toOplaxFunctor F) (toOplaxSpan H) (toOplaxSpan K)
  constructor
  · constructor
    · intro ⟨hinj, hsurj⟩ E v
      refine ⟨?_, ?_⟩
      · intro ⟨u₁, eq₁, val₁⟩ ⟨u₂, eq₂, val₂⟩ heq
        have hw : F.map BecomingSpec.Extensions.Pullback.fst u₁ =
            F.map BecomingSpec.Extensions.Pullback.fst u₂ :=
          congrArg BecomingSpec.Extensions.BCRight.w heq
        have hu : u₁ = u₂ := hinj u₁ u₂ (pbExt hw (eq₁.trans eq₂.symm))
        cases hu
        exact bcLeftMkExt (bcRightValEq rfl heq)
      · intro ⟨w, eqMid, val⟩
        obtain ⟨u, hu⟩ := hsurj ⟨w, v, eqMid⟩
        have hfst : F.map BecomingSpec.Extensions.Pullback.fst u = w :=
          congrArg BecomingSpec.Extensions.Pullback.fst hu
        have hsnd : F.map BecomingSpec.Extensions.Pullback.snd u = v :=
          congrArg BecomingSpec.Extensions.Pullback.snd hu
        refine ⟨⟨u, hsnd, hfst.symm ▸ val⟩, ?_⟩
        exact bcRightMkExt hfst (by cases hfst; rfl)
    · intro hAll
      have hUnit : ∀ v', Becoming.OplaxHistory.IsBijective
          (Becoming.OplaxHistory.bcMap (toOplaxFunctor F) (toOplaxSpan H) (toOplaxSpan K) (fun _ => Unit) v') :=
        fun v' => (bcMap_const_bijective_iff F H K Unit v').mp (hAll (fun _ => Unit) v')
      have hPb : Becoming.OplaxHistory.FImageIsPullback (toOplaxFunctor F) (toOplaxSpan H) (toOplaxSpan K) := by
        intro w v hmid
        obtain ⟨_, hsurjU⟩ := hUnit v
        obtain ⟨⟨u, hsnd, _⟩, heq⟩ := hsurjU ⟨w, hmid, ()⟩
        refine ⟨u, ⟨congrArg Becoming.OplaxHistory.BCRight.w heq, hsnd⟩, ?_⟩
        intro u' hfst' hsnd'
        obtain ⟨hinjU, _⟩ := hUnit (F.map Becoming.OplaxHistory.PullbackElem.snd u)
        have eqSnd : F.map Becoming.OplaxHistory.PullbackElem.snd u' =
            F.map Becoming.OplaxHistory.PullbackElem.snd u :=
          hsnd'.trans hsnd.symm
        have hbcEq :
            Becoming.OplaxHistory.bcMap (toOplaxFunctor F) (toOplaxSpan H) (toOplaxSpan K) (fun _ => Unit)
              (F.map Becoming.OplaxHistory.PullbackElem.snd u) ⟨u', eqSnd, ()⟩ =
            Becoming.OplaxHistory.bcMap (toOplaxFunctor F) (toOplaxSpan H) (toOplaxSpan K) (fun _ => Unit)
              (F.map Becoming.OplaxHistory.PullbackElem.snd u) ⟨u, rfl, ()⟩ :=
          Becoming.OplaxHistory.bcRight_mk_ext
            (hfst'.trans (congrArg Becoming.OplaxHistory.BCRight.w heq).symm) rfl
        exact congrArg Becoming.OplaxHistory.BCLeft.u (hinjU _ _ hbcEq)
      exact (adapter_chi_bijective_iff F H K).mpr
        ((Becoming.OplaxHistory.chi_bijective_iff_pullback
          (toOplaxFunctor F) (toOplaxSpan H) (toOplaxSpan K)).mpr hPb)
  · intro v
    exact (bcMap_const_bijective_iff F H K Empty v).mpr
      (Becoming.OplaxHistory.bc_empty_family_trivial_counterexample
        (toOplaxFunctor F) (toOplaxSpan H) (toOplaxSpan K) v)

theorem adapter_oplax_chi_iff_bc_all (F : BecomingSpec.Extensions.Functor) {A D C : Type}
    (H : BecomingSpec.Extensions.Span A D) (K : BecomingSpec.Extensions.Span D C) :
    BecomingSpec.Extensions.IsBijective (BecomingSpec.Extensions.chi F H K) ↔
      ∀ (E : (toOplaxFunctor F).obj (toOplaxSpan H).W → Type) (v : (toOplaxFunctor F).obj (toOplaxSpan K).W),
        Becoming.OplaxHistory.IsBijective
          (Becoming.OplaxHistory.bcMap (toOplaxFunctor F) (toOplaxSpan H) (toOplaxSpan K) E v) :=
  (adapter_chi_bijective_iff F H K).trans
    (Becoming.OplaxHistory.chi_bijective_iff_bc_all (toOplaxFunctor F) (toOplaxSpan H) (toOplaxSpan K))

theorem ext_missingLift : BecomingSpec.Extensions.missingLiftTarget := by
  refine ⟨?_, ?_, ?_⟩
  · intro hSurj
    apply Becoming.OplaxHistory.EmergentCrossSeamWitness.chiZeroToOne_not_surjective
    intro y
    obtain ⟨e, _⟩ := hSurj ⟨y.fst, y.snd, y.mid⟩
    exact Empty.elim e
  · intro hSurj
    apply Becoming.OplaxHistory.EmergentCrossSeamWitness.chiTwoToFour_not_surjective
    intro p
    obtain ⟨b, hb⟩ := hSurj p
    exact ⟨b, by cases b <;> exact hb⟩
  · refine ⟨Becoming.OplaxHistory.C2CoupledAlignmentWitness.CoupledState, Nat,
      Becoming.OplaxHistory.C2CoupledAlignmentWitness.c2ProjMicro,
      Becoming.Viability.Kernel Becoming.OplaxHistory.C2CoupledAlignmentWitness.proc
        Becoming.OplaxHistory.C2CoupledAlignmentWitness.guardS, ?_, ?_⟩
    · exact Becoming.OplaxHistory.C2CoupledAlignmentWitness.c2_coupled_fiber_split
    · exact Becoming.OplaxHistory.C2CoupledAlignmentWitness.c2_coupled_no_macro_soundness

/-! ## Adapter 8: Adaptive Inquiry, Branching & Open Second Entry ↔ `EncounterEntry` -/

def toSpecSlotProbe : EncounterEntry.SlotProbe → BecomingSpec.Extensions.SlotProbe
  | .probeWhere => .probeWhere
  | .readL => .readL
  | .readR => .readR

def fromSpecSlotProbe : BecomingSpec.Extensions.SlotProbe → EncounterEntry.SlotProbe
  | .probeWhere => .probeWhere
  | .readL => .readL
  | .readR => .readR

def toSpecPair (s : EncounterEntry.SlotState) : Bool × Bool := (s.slotLoc, s.slotVal)
def fromSpecPair (s : Bool × Bool) : EncounterEntry.SlotState := ⟨s.1, s.2⟩

theorem fromToSpecSlotProbe (p : BecomingSpec.Extensions.SlotProbe) :
    toSpecSlotProbe (fromSpecSlotProbe p) = p := by
  cases p <;> rfl

theorem toFromSpecSlotProbe (p : EncounterEntry.SlotProbe) :
    fromSpecSlotProbe (toSpecSlotProbe p) = p := by
  cases p <;> rfl

theorem toFromSpecPair (s : Bool × Bool) : toSpecPair (fromSpecPair s) = s := rfl
theorem fromToSpecPair (s : EncounterEntry.SlotState) : fromSpecPair (toSpecPair s) = s := rfl

theorem adapter_slotOracle_commutes (s : Bool × Bool) (p : EncounterEntry.SlotProbe) :
    EncounterEntry.slotOracle (fromSpecPair s) p =
      BecomingSpec.Extensions.slotOracle s (toSpecSlotProbe p) := by
  cases p with
  | probeWhere => rfl
  | readL => cases s.1 <;> rfl
  | readR => cases s.1 <;> rfl

def toSpecTree :
    EncounterEntry.InquiryTree EncounterEntry.SlotProbe Bool EncounterEntry.SlotState →
      BecomingSpec.Extensions.InquiryTree BecomingSpec.Extensions.SlotProbe Bool (Bool × Bool)
  | .stop act => .stop (toSpecPair act)
  | .ask p next => .ask (toSpecSlotProbe p) (fun o => toSpecTree (next o))

def fromSpecTree :
    BecomingSpec.Extensions.InquiryTree BecomingSpec.Extensions.SlotProbe Bool (Bool × Bool) →
      EncounterEntry.InquiryTree EncounterEntry.SlotProbe Bool EncounterEntry.SlotState
  | .stop act => .stop (fromSpecPair act)
  | .ask p next => .ask (fromSpecSlotProbe p) (fun o => fromSpecTree (next o))

theorem toSpecTree_within :
    ∀ {n : Nat} {t : EncounterEntry.InquiryTree EncounterEntry.SlotProbe Bool EncounterEntry.SlotState},
      EncounterEntry.WithinQueries n t → BecomingSpec.Extensions.WithinQueries n (toSpecTree t)
  | _, .stop _, .stop n act => .stop n (toSpecPair act)
  | _, .ask _ _, .ask n p next h =>
      .ask n (toSpecSlotProbe p) (fun o => toSpecTree (next o)) (fun o => toSpecTree_within (h o))

theorem runTree_toSpecTree (s : Bool × Bool) :
    ∀ t : EncounterEntry.InquiryTree EncounterEntry.SlotProbe Bool EncounterEntry.SlotState,
      BecomingSpec.Extensions.runTree (BecomingSpec.Extensions.slotOracle s) (toSpecTree t) =
        toSpecPair (EncounterEntry.runTree (EncounterEntry.slotOracle (fromSpecPair s)) t)
  | .stop _ => rfl
  | .ask p next => by
      change BecomingSpec.Extensions.runTree (BecomingSpec.Extensions.slotOracle s)
          (toSpecTree (next (BecomingSpec.Extensions.slotOracle s (toSpecSlotProbe p)))) =
        toSpecPair (EncounterEntry.runTree (EncounterEntry.slotOracle (fromSpecPair s))
          (next (EncounterEntry.slotOracle (fromSpecPair s) p)))
      rw [← adapter_slotOracle_commutes s p]
      exact runTree_toSpecTree s (next (EncounterEntry.slotOracle (fromSpecPair s) p))

theorem runTree_fromSpecTree (s : Bool × Bool) :
    ∀ t : BecomingSpec.Extensions.InquiryTree BecomingSpec.Extensions.SlotProbe Bool (Bool × Bool),
      EncounterEntry.runTree (EncounterEntry.slotOracle (fromSpecPair s)) (fromSpecTree t) =
        fromSpecPair (BecomingSpec.Extensions.runTree (BecomingSpec.Extensions.slotOracle s) t)
  | .stop _ => rfl
  | .ask p next => by
      change EncounterEntry.runTree (EncounterEntry.slotOracle (fromSpecPair s))
          (fromSpecTree (next (EncounterEntry.slotOracle (fromSpecPair s) (fromSpecSlotProbe p)))) =
        fromSpecPair (BecomingSpec.Extensions.runTree (BecomingSpec.Extensions.slotOracle s)
          (next (BecomingSpec.Extensions.slotOracle s p)))
      rw [adapter_slotOracle_commutes s (fromSpecSlotProbe p), fromToSpecSlotProbe p]
      exact runTree_fromSpecTree s (next (BecomingSpec.Extensions.slotOracle s p))

theorem runTree_ofFixed_adapter {Act₁ Act₂ : Type} (g : Act₁ → Act₂) (s : Bool × Bool) :
    ∀ (ps : List BecomingSpec.Extensions.SlotProbe) (dec : List Bool → Act₁),
      EncounterEntry.runTree (EncounterEntry.slotOracle (fromSpecPair s))
          (EncounterEntry.ofFixed (ps.map fromSpecSlotProbe) (fun os => g (dec os))) =
        g (BecomingSpec.Extensions.runTree (BecomingSpec.Extensions.slotOracle s)
          (BecomingSpec.Extensions.ofFixed ps dec))
  | [], _ => rfl
  | p :: ps, dec => by
      change EncounterEntry.runTree (EncounterEntry.slotOracle (fromSpecPair s))
          (EncounterEntry.ofFixed (ps.map fromSpecSlotProbe)
            (fun os => g (dec (EncounterEntry.slotOracle (fromSpecPair s) (fromSpecSlotProbe p) :: os)))) =
        g (BecomingSpec.Extensions.runTree (BecomingSpec.Extensions.slotOracle s)
          (BecomingSpec.Extensions.ofFixed ps (fun os => dec (BecomingSpec.Extensions.slotOracle s p :: os))))
      rw [adapter_slotOracle_commutes s (fromSpecSlotProbe p), fromToSpecSlotProbe p]
      exact runTree_ofFixed_adapter g s ps (fun os => dec (BecomingSpec.Extensions.slotOracle s p :: os))

theorem entry_adaptiveBeatsFixed : BecomingSpec.Extensions.adaptiveBeatsFixedTarget := by
  refine ⟨⟨toSpecTree EncounterEntry.adaptiveSlotTree,
      toSpecTree_within EncounterEntry.adaptiveSlotTree_within_two, ?_⟩, ?_, ?_⟩
  · intro s
    rw [runTree_toSpecTree s EncounterEntry.adaptiveSlotTree,
      EncounterEntry.adaptive_two_step_identifies_pair (fromSpecPair s)]
    exact toFromSpecPair s
  · intro p₁ p₂ dec
    obtain ⟨⟨s₁, s₂, hne, heq⟩, ⟨sBad, hBad⟩⟩ :=
      EncounterEntry.fixed_two_step_misses_pair (fromSpecSlotProbe p₁) (fromSpecSlotProbe p₂)
        (fun os => fromSpecPair (dec os))
    refine ⟨⟨toSpecPair s₁, toSpecPair s₂, fun h => hne (congrArg fromSpecPair h), ?_⟩,
      ⟨toSpecPair sBad, fun h => hBad ?_⟩⟩
    · have h1 := runTree_ofFixed_adapter fromSpecPair (toSpecPair s₁) [p₁, p₂] dec
      have h2 := runTree_ofFixed_adapter fromSpecPair (toSpecPair s₂) [p₁, p₂] dec
      have hs1 : fromSpecPair (toSpecPair s₁) = s₁ := fromToSpecPair s₁
      have hs2 : fromSpecPair (toSpecPair s₂) = s₂ := fromToSpecPair s₂
      rw [hs1] at h1
      rw [hs2] at h2
      have eqEnc :
          EncounterEntry.runTree (EncounterEntry.slotOracle s₁)
            (EncounterEntry.ofFixed [fromSpecSlotProbe p₁, fromSpecSlotProbe p₂]
              (fun os => fromSpecPair (dec os))) =
          EncounterEntry.runTree (EncounterEntry.slotOracle s₂)
            (EncounterEntry.ofFixed [fromSpecSlotProbe p₁, fromSpecSlotProbe p₂]
              (fun os => fromSpecPair (dec os))) := heq
      have hLeft : fromSpecPair (BecomingSpec.Extensions.runTree (BecomingSpec.Extensions.slotOracle (toSpecPair s₁))
          (BecomingSpec.Extensions.ofFixed [p₁, p₂] dec)) =
          fromSpecPair (BecomingSpec.Extensions.runTree (BecomingSpec.Extensions.slotOracle (toSpecPair s₂))
          (BecomingSpec.Extensions.ofFixed [p₁, p₂] dec)) := h1.symm.trans (eqEnc.trans h2)
      exact congrArg toSpecPair hLeft
    · have hB := runTree_ofFixed_adapter fromSpecPair (toSpecPair sBad) [p₁, p₂] dec
      rw [fromToSpecPair sBad] at hB
      exact hB.trans (congrArg fromSpecPair h)
  · refine ⟨EncounterEntry.valueOnlyDecode, fun s => ?_⟩
    have hV := runTree_ofFixed_adapter (fun v : Bool => v) s [.readL, .readR] EncounterEntry.valueOnlyDecode
    have hEnc := EncounterEntry.fixed_two_step_recovers_value_only (fromSpecPair s)
    exact hV.symm.trans hEnc

def toSpecBranchState : EncounterEntry.BranchState → BecomingSpec.Extensions.BranchState
  | .entry => .entry
  | .leftMid => .leftMid
  | .rightMid => .rightMid
  | .exitDone => .exitDone

def fromSpecBranchState : BecomingSpec.Extensions.BranchState → EncounterEntry.BranchState
  | .entry => .entry
  | .leftMid => .leftMid
  | .rightMid => .rightMid
  | .exitDone => .exitDone

def toSpecBranchLabel : EncounterEntry.BranchLabel → BecomingSpec.Extensions.BranchLabel
  | .stepX => .stepX
  | .reqA => .reqA
  | .reqB => .reqB

def fromSpecBranchLabel : BecomingSpec.Extensions.BranchLabel → EncounterEntry.BranchLabel
  | .stepX => .stepX
  | .reqA => .reqA
  | .reqB => .reqB

def fromSpecPostReq : BecomingSpec.Extensions.PostReq → EncounterEntry.PostReq
  | .reqA => .reqA
  | .reqB => .reqB

def toSpecPostReq : EncounterEntry.PostReq → BecomingSpec.Extensions.PostReq
  | .reqA => .reqA
  | .reqB => .reqB

theorem toFromSpecBranchState (s : BecomingSpec.Extensions.BranchState) :
    toSpecBranchState (fromSpecBranchState s) = s := by
  cases s <;> rfl

theorem fromToSpecBranchState (s : EncounterEntry.BranchState) :
    fromSpecBranchState (toSpecBranchState s) = s := by
  cases s <;> rfl

theorem branchStateEq_commutes (a b : EncounterEntry.BranchState) :
    BecomingSpec.Extensions.branchStateEq (toSpecBranchState a) (toSpecBranchState b) =
      EncounterEntry.branchStateEq a b := by
  cases a <;> cases b <;> rfl

def toSpecEdges (sys : EncounterEntry.BranchSys)
    (s : BecomingSpec.Extensions.BranchState) (l : BecomingSpec.Extensions.BranchLabel) :
    List BecomingSpec.Extensions.BranchState :=
  (sys.edges (fromSpecBranchState s) (fromSpecBranchLabel l)).map toSpecBranchState

theorem sumNatList_eq : ∀ xs : List Nat,
    BecomingSpec.Extensions.sumNatList xs = EncounterEntry.sumNatList xs
  | [] => rfl
  | x :: xs => congrArg (x + ·) (sumNatList_eq xs)

theorem map_toSpec_pathsFrom (sys : EncounterEntry.BranchSys) :
    ∀ (w : List EncounterEntry.BranchLabel) (s tgt : EncounterEntry.BranchState),
      BecomingSpec.Extensions.pathsFrom (toSpecEdges sys)
          (toSpecBranchState s) (w.map toSpecBranchLabel) (toSpecBranchState tgt) =
        EncounterEntry.pathsFrom sys s w tgt
  | [], s, tgt => by
      change (if BecomingSpec.Extensions.branchStateEq (toSpecBranchState s) (toSpecBranchState tgt) then 1 else 0) =
        (if EncounterEntry.branchStateEq s tgt then 1 else 0)
      rw [branchStateEq_commutes s tgt]
  | l :: ls, s, tgt => by
      change BecomingSpec.Extensions.sumNatList
          (((toSpecEdges sys (toSpecBranchState s) (toSpecBranchLabel l)).map
            (fun s' => BecomingSpec.Extensions.pathsFrom (toSpecEdges sys) s'
              (ls.map toSpecBranchLabel) (toSpecBranchState tgt)))) =
        EncounterEntry.sumNatList
          ((sys.edges s l).map (fun s' => EncounterEntry.pathsFrom sys s' ls tgt))
      rw [sumNatList_eq]
      have hEdge : toSpecEdges sys (toSpecBranchState s) (toSpecBranchLabel l) =
          (sys.edges s l).map toSpecBranchState := by
        cases s <;> cases l <;> rfl
      rw [hEdge]
      have hMap :
          ((sys.edges s l).map toSpecBranchState).map
            (fun s' => BecomingSpec.Extensions.pathsFrom (toSpecEdges sys) s'
              (ls.map toSpecBranchLabel) (toSpecBranchState tgt)) =
          (sys.edges s l).map (fun s' => EncounterEntry.pathsFrom sys s' ls tgt) := by
        induction (sys.edges s l) with
        | nil => rfl
        | cons hd tl ih =>
            exact congr (congrArg List.cons (map_toSpec_pathsFrom sys ls hd tgt)) ih
      rw [hMap]

theorem adapter_pathsFrom_commutes (sys : EncounterEntry.BranchSys)
    (w : List BecomingSpec.Extensions.BranchLabel) :
    BecomingSpec.Extensions.pathsFrom (toSpecEdges sys) .entry w .exitDone =
      EncounterEntry.entryToExitCount sys (w.map fromSpecBranchLabel) := by
  have hw : w = (w.map fromSpecBranchLabel).map toSpecBranchLabel := by
    induction w with
    | nil => rfl
    | cons a as ih =>
        have ha : a = toSpecBranchLabel (fromSpecBranchLabel a) := by cases a <;> rfl
        exact congr (congrArg List.cons ha) ih
  have hLhs := map_toSpec_pathsFrom sys (w.map fromSpecBranchLabel) .entry .exitDone
  rw [← hw] at hLhs
  exact hLhs

theorem mem_map_toSpec {α β : Type} (f : α → β) {a : α} :
    ∀ {xs : List α}, a ∈ xs → f a ∈ xs.map f
  | _ :: _, .head _ => .head _
  | _ :: _, .tail _ h => .tail _ (mem_map_toSpec f h)

theorem mem_of_mem_map_toSpec {α β : Type} (f : α → β) :
    ∀ {xs : List α} {b : β}, b ∈ xs.map f → ∃ a, a ∈ xs ∧ f a = b
  | _ :: _, _, .head _ => ⟨_, .head _, rfl⟩
  | _ :: _, _, .tail _ h =>
      let ⟨a, ha, heq⟩ := mem_of_mem_map_toSpec f h
      ⟨a, .tail _ ha, heq⟩

theorem adapter_completesPostBranch_iff (sys : EncounterEntry.BranchSys) :
    BecomingSpec.Extensions.CompletesPostBranch (toSpecEdges sys) ↔
      EncounterEntry.CompletesPostBranch sys := by
  constructor
  · intro hSpec mid hMid r
    have hEdge : toSpecEdges sys .entry .stepX = (sys.edges .entry .stepX).map toSpecBranchState := rfl
    have hMem : toSpecBranchState mid ∈ toSpecEdges sys .entry .stepX :=
      hEdge ▸ mem_map_toSpec toSpecBranchState hMid
    obtain ⟨tgt, hTgtMem, hTgtEq⟩ := hSpec (toSpecBranchState mid) hMem (toSpecPostReq r)
    have hLab : toSpecEdges sys (toSpecBranchState mid) (BecomingSpec.Extensions.postLabel (toSpecPostReq r)) =
        (sys.edges mid (EncounterEntry.postLabel r)).map toSpecBranchState := by
      cases mid <;> cases r <;> rfl
    rw [hLab] at hTgtMem
    obtain ⟨tgtEnc, hEncMem, hEncEq⟩ := mem_of_mem_map_toSpec toSpecBranchState hTgtMem
    have hEqExit : toSpecBranchState tgtEnc = .exitDone := hEncEq.trans hTgtEq
    have hEncExit : tgtEnc = .exitDone := by
      cases tgtEnc <;> first | rfl | exact nomatch hEqExit
    exact ⟨tgtEnc, hEncMem, hEncExit⟩
  · intro hEnc mid hMid r
    have hEdge : toSpecEdges sys .entry .stepX = (sys.edges .entry .stepX).map toSpecBranchState := rfl
    rw [hEdge] at hMid
    obtain ⟨midEnc, hEncMid, hMidEq⟩ := mem_of_mem_map_toSpec toSpecBranchState hMid
    obtain ⟨tgt, hTgtMem, hTgtEq⟩ := hEnc midEnc hEncMid (fromSpecPostReq r)
    have hMidFrom : fromSpecBranchState mid = midEnc := by
      rw [← hMidEq]
      exact fromToSpecBranchState midEnc
    have hLab : toSpecEdges sys mid (BecomingSpec.Extensions.postLabel r) =
        (sys.edges midEnc (EncounterEntry.postLabel (fromSpecPostReq r))).map toSpecBranchState := by
      change (sys.edges (fromSpecBranchState mid) (fromSpecBranchLabel (BecomingSpec.Extensions.postLabel r))).map toSpecBranchState = _
      rw [hMidFrom]
      cases r <;> rfl
    refine ⟨toSpecBranchState tgt, hLab ▸ mem_map_toSpec toSpecBranchState hTgtMem, ?_⟩
    rw [hTgtEq]
    rfl

theorem entry_branchingVsPathCount : BecomingSpec.Extensions.branchingVsPathCountTarget := by
  refine ⟨toSpecEdges EncounterEntry.sysA, toSpecEdges EncounterEntry.sysB, ?_, ?_, ?_, ?_, ?_⟩
  · rw [adapter_pathsFrom_commutes]
    exact EncounterEntry.sysA_path_counts_2xa_2xb.1
  · rw [adapter_pathsFrom_commutes]
    exact EncounterEntry.sysA_path_counts_2xa_2xb.2
  · intro w
    rw [adapter_pathsFrom_commutes, adapter_pathsFrom_commutes]
    exact EncounterEntry.pathCount_eq (w.map fromSpecBranchLabel)
  · exact (adapter_completesPostBranch_iff EncounterEntry.sysA).mpr EncounterEntry.sysA_completes_all
  · intro hB
    exact EncounterEntry.sysB_branch_stuck ((adapter_completesPostBranch_iff EncounterEntry.sysB).mp hB)

def encounterEntryInterface :
    BecomingSpec.Extensions.OpenEntryInterface
      EncounterEntry.World EncounterEntry.ProcState EncounterEntry.Act
      EncounterEntry.Submission EncounterEntry.FreshObserver EncounterEntry.ProcOp where
  initResolved := EncounterEntry.initResolved
  pubRead := EncounterEntry.publicRead
  subQuery sub w := sub.query w
  subSafe sub := sub.probeSafe
  subRisk sub := sub.probeRisk
  obsRead obs q w := obs.readContact q w
  obsHazard obs w := obs.checkHazard w
  openGate st sub := EncounterEntry.openGate st sub = true
  sealingGate := EncounterEntry.sealingGate
  execStep := EncounterEntry.execStep
  runOps := EncounterEntry.runOps
  reachable := EncounterEntry.ReachableProc
  submitOp := EncounterEntry.ProcOp.submit
  verifyOp := EncounterEntry.ProcOp.verifyHead
  applyOp := EncounterEntry.ProcOp.applyRevision
  actuateOp := EncounterEntry.ProcOp.actuate
  reserve st := st.reserve
  stepsLeft st := st.stepsLeft
  rejectedCount st := st.rejectedCount
  installedCount st := st.installed.length
  lastAct st := st.lastAct
  protectAct := EncounterEntry.Act.protect
  normalAct := EncounterEntry.Act.normalOp
  queueEmpty st := st.queue = []

theorem adapter_encounterEntryInterface_openGate (st : EncounterEntry.ProcState) (sub : EncounterEntry.Submission) :
    encounterEntryInterface.openGate st sub ↔ EncounterEntry.openGate st sub = true :=
  Iff.rfl

theorem adapter_encounterEntryInterface_runOps (st : EncounterEntry.ProcState) (ops : List EncounterEntry.ProcOp) :
    encounterEntryInterface.runOps st ops = EncounterEntry.runOps st ops :=
  rfl

theorem entry_openSecondEntry : BecomingSpec.Extensions.openSecondEntryTarget := by
  have hMain := EncounterEntry.encounter_refines_and_preserves_entry
  obtain ⟨⟨hPub1, hQ1, hOpen1, stPend, hPendRun, hPendRej⟩,
          ⟨del, msk, hDelRun, hMskRun, hStepsEq, hActNeq, hDelFloor, hMskFloor⟩,
          ⟨stRej, hRejRun, hRejCount, hRejInst, hRejAct⟩,
          ⟨⟨hSeal0, stRev1, stAct2, stMsk2, hRev1Run, hSeal1, hOpen2, hAct2Run, hMsk2Run, hAct2Neq, hAct2Floor, hMsk2Floor⟩,
           hUniv⟩⟩ := hMain
  exact ⟨EncounterEntry.World, EncounterEntry.ProcState, EncounterEntry.Act,
    EncounterEntry.Submission, EncounterEntry.FreshObserver, EncounterEntry.ProcOp,
    encounterEntryInterface, EncounterEntry.reserveFloor, EncounterEntry.canonicalObserver,
    EncounterEntry.worldSafeBase, EncounterEntry.worldRisk1, EncounterEntry.worldRisk2,
    EncounterEntry.entrant1Sub, EncounterEntry.entrant2Sub, EncounterEntry.falseSub,
    EncounterEntry.protect_ne_normalOp, hPub1, hQ1, hOpen1, hSeal0,
    ⟨stPend, hPendRun, hPendRej⟩,
    ⟨del, msk, hDelRun, hMskRun, hStepsEq, hActNeq, hDelFloor, hMskFloor⟩,
    ⟨stRej, hRejRun, hRejCount, hRejInst, hRejAct⟩,
    ⟨stRev1, stAct2, stMsk2, hRev1Run, hSeal1, hOpen2, hAct2Run, hMsk2Run, hAct2Neq, hAct2Floor, hMsk2Floor⟩,
    hUniv⟩

end BecomingSpecCheck
