# Re-check of UE19's fold

29 October 2026. Read-only re-check, AI-written, of how [REVIEW-UE19](REVIEW-UE19.md)'s eleven findings were folded. It covers the revised core module (sha256 `96faa98d…e22e41db`), periphery module (`173fc8b3…1e78a3f6`) and [NOTE](NOTE.md) (`2612277f…ea22ee37`). The core module was rebuilt in a separate scratch tree, reusing the cached steps of these bytes: 12 theorems in 20 declarations, every axiom report empty, no warnings. A probe of 3 theorems in 8 declarations (below) also has empty reports. The periphery module was compiled with UE17's script against UE17's `FreeEnergyReals`, unchanged since the review: no warnings, and all 21 declarations report exactly `propext`, `Classical.choice` and `Quot.sound`. Nothing else was changed.

## Verdict

Every finding is folded soundly. The new declarations are the review's probes under the adopted names, their docstrings say what they prove, and the texts follow the Lean. What remains is small:
- one false cross-reference in the NOTE (R1);
- two wordings that read as more than the Lean (R2, R3);
- two optional additions, both probed (R4, R5).

It can land after R1, a one-line fix; R2 to R5 are optional.

## The eleven findings

- **F1:** taken. `seekWeight`, `seek_tied` and `seeking_keeps_order` are the probe's. The header and the NOTE now say "every experiment ties" and cite the T-maze as the case where seeking corrects. The theorem is not vacuous: probe `seeking_instance` instantiates it.
- **F2, F5:** taken. The coarse form and the gain form are as probed, with `efe` renamed. `epistemic_eq_zero_of_lumped` stays as the one-class case.
- **F3, F10:** taken. The parent law is named (`Relabel.EquivariantValue.tied`), and the posterior laws are graded as corollaries, with the seeking form as what is new. The analogy to `determines_lumped_iff` is gone. The readings carry [AI reading, D45]. The standing is Rothenberg and Poirier. The third part now forbids the unqualified wording, not active inference's account.
- **F4:** taken. Each source is cited for what it states, Wen's name and version are corrected, and "structure learning" is no longer attributed to him.
- **F6:** taken in the header and in `epistemic_eq_divergence`, but not in the docstrings of `risk` and `pragmatic` (R3).
- **F7:** taken. `Agree` replaces `Coin`, its cases enumerated, with every number as probed.
- **F8:** taken for `order_kept`. `posterior_le_iff_prior` keeps `positive` (R4).
- **F9:** taken (`Tied`, `tied_mass`, `order_kept`, `expectedFreeEnergy`). The module's name `LumpedSeeking` now fits, since it holds seeking.
- **F11:** the join and the many-step form are named as not stated in NOTE §3. The data-processing bound is not (R1). `posterior_ratio_of_lumped` is stated on UE17's `posterior`.

## Findings

**R1 (E). False cross-reference** (NOTE §6, F11 line). It says the data-processing bound is "named as not stated (§3)", but §3 does not name it. *Fix:* add to §3's "Does not show": "the data-processing bound, that a policy's epistemic value is at least its classes', the excess being what it tells about the split within a class".

**R2 (S). The two halves read as joined** (periphery header l. 33). "The counting form, with seeking, is `Becoming.LumpedSeeking`" reads as a proved correspondence, while NOTE §3 says no theorem joins the two. *Fix:* "Its counting form, with seeking, is stated in `Becoming.LumpedSeeking`; no theorem here joins the two."

**R3 (S). The zero caveat is missing from two docstrings** (l. 56, l. 69). `risk` is still "the divergence" and `pragmatic` "the expected log preference". *Fix:* add "(as usually defined where `P` is positive wherever the predicted outcomes are; see the header)". Optional, since the header says it.

**R4 (I). `posterior_le_iff_prior` needs no `positive`.** Probe `posterior_le_iff_prior'` splits on the record's weight. With nothing in it, `single_le_evidence` and `weighs` force `prior h₁ = 0`, so both sides hold. Optional: `order_kept` no longer uses `positive`.

**R5 (I). Seeking corrects where some experiment separates.** Probe `seeking_corrects` has two experiments: reading both tosses, or only whether they agree. A policy choosing the first, after one course of two heads, puts the true coin above the tails-biased one, which `agreeing` ties. Adding it beside `seeking_keeps_order` would state the third part's contrast in the seeking form: seeking corrects within what some experiment separates, and not beyond. Today only `turns_fair` states that, for a single record. Optional.

## Probe

Run from the package folder: `python3 -B scratch_build.py <tree> Becoming.LumpedSeeking Becoming.UE19RecheckProbe`, with the module byte-identical to the study's. Result: 3 theorems in 8 declarations, every axiom report empty, no warnings.

```lean
import Becoming.LumpedSeeking

/-! Re-check probe for UE19: not for landing. -/

namespace Becoming

namespace UE19RecheckProbe

open ConditionalWeights LumpedSeeking

/-! ## C1. `posterior_le_iff_prior` needs no `positive` -/

theorem posterior_le_iff_prior' {α β : Type} [DecidableEq α] (prior : α → Nat) (lik : α → β → Nat)
    {hs : List α} (os : List β) (rec : β → Bool) (distinct : Distinct hs) {h₁ h₂ : α}
    (mem₁ : h₁ ∈ hs) (mem₂ : h₂ ∈ hs) (tied : Tied lik h₁ h₂) (weighs : 0 < mass os (lik h₁) rec) :
    (share (openSteps hs os) (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => decide (c.1 = h₁))).le
      (share (openSteps hs os) (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
        (fun c => decide (c.1 = h₂))) ↔ prior h₁ ≤ prior h₂ :=
  match Nat.eq_zero_or_pos (mass (openSteps hs os) (pairWeight prior lik) (fun c => rec c.2)) with
  | .inr positive =>
    posterior_le_iff_prior prior lik os rec distinct mem₁ mem₂ tied weighs positive
  | .inl zero =>
    have whole : mass (openSteps hs os)
        (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik)) (fun _ => true) = 0 :=
      (whole_restrict _ _ _).trans zero
    have none : prior h₁ = 0 :=
      Nat.eq_zero_of_le_zero (Nat.le_of_mul_le_mul_right
        (Nat.le_trans (single_le_evidence prior lik os rec distinct mem₁)
          (Nat.le_trans (Nat.le_of_eq zero) (Nat.le_of_eq (Nat.zero_mul _).symm))) weighs)
    ⟨fun _ => none ▸ Nat.zero_le _,
     fun _ => show mass (openSteps hs os)
           (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
           (fun c => decide (c.1 = h₁)) *
         mass (openSteps hs os)
           (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik)) (fun _ => true) ≤
         mass (openSteps hs os)
           (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik))
           (fun c => decide (c.1 = h₂)) *
         mass (openSteps hs os)
           (ConditionalWeights.restrict (fun c => rec c.2) (pairWeight prior lik)) (fun _ => true) by
       rw [whole, Nat.mul_zero, Nat.mul_zero]; exact Nat.le_refl 0⟩

/-! ## C2. `seeking_keeps_order` is not vacuous: one experiment, the model reading agreement -/

/-- A course of one step under the one experiment. -/
def oneStep : List (List (Unit × (Bool × Bool))) := [[((), (true, true))]]

theorem seeking_instance :
    ¬ (share (openSteps Agree.hypotheses oneStep)
        (ConditionalWeights.restrict (fun c => (fun _ => true) c.2)
          (pairWeight Agree.prior (seekWeight (fun _ _ => 1) (fun _ => Agree.agreeing))))
        (fun c => decide (c.1 = Agree.Bias.tails))).le
      (share (openSteps Agree.hypotheses oneStep)
        (ConditionalWeights.restrict (fun c => (fun _ => true) c.2)
          (pairWeight Agree.prior (seekWeight (fun _ _ => 1) (fun _ => Agree.agreeing))))
        (fun c => decide (c.1 = Agree.Bias.heads))) :=
  seeking_keeps_order Agree.prior (fun _ _ => 1) (fun _ => Agree.agreeing) oneStep (fun _ => true)
    Agree.distinct (.head _) (.tail _ (.tail _ (.head _))) (fun _ => Agree.ties) (by decide)
    (by decide)

/-! ## C3. Where some experiment separates, seeking can correct -/

/-- A model reading both tosses: three in four heads, two in four, one in four. -/
def readBoth : Agree.Bias → Bool × Bool → Nat
  | .heads, (true, true) => 9
  | .heads, (true, false) => 3
  | .heads, (false, true) => 3
  | .heads, (false, false) => 1
  | .fair, (true, true) => 4
  | .fair, (true, false) => 4
  | .fair, (false, true) => 4
  | .fair, (false, false) => 4
  | .tails, (true, true) => 1
  | .tails, (true, false) => 3
  | .tails, (false, true) => 3
  | .tails, (false, false) => 9

/-- Two experiments: reading both tosses (`true`) or only their agreement (`false`). -/
def experiment : Bool → Agree.Bias → Bool × Bool → Nat
  | true => readBoth
  | false => Agree.agreeing

/-- A policy choosing the separating experiment. -/
def pickReading : List (Bool × (Bool × Bool)) → Bool → Nat
  | _, true => 1
  | _, false => 0

def readCourse : List (List (Bool × (Bool × Bool))) := [[(true, (true, true))]]

theorem seeking_corrects :
    ¬ (share (openSteps Agree.hypotheses readCourse)
        (ConditionalWeights.restrict (fun c => (fun _ => true) c.2)
          (pairWeight Agree.prior (seekWeight pickReading experiment)))
        (fun c => decide (c.1 = Agree.Bias.heads))).le
      (share (openSteps Agree.hypotheses readCourse)
        (ConditionalWeights.restrict (fun c => (fun _ => true) c.2)
          (pairWeight Agree.prior (seekWeight pickReading experiment)))
        (fun c => decide (c.1 = Agree.Bias.tails))) :=
  fun le => absurd ((posterior_le_iff Agree.prior (seekWeight pickReading experiment)
    Agree.hypotheses readCourse (fun _ => true) (fun h => decide (h = Agree.Bias.heads))
    (fun h => decide (h = Agree.Bias.tails)) (by decide)).mp le) (by decide)

end UE19RecheckProbe

end Becoming
```
