import Becoming.TransformativeViability
import Becoming.PolyComposition

/-!
# Open-Ended Composition (`Becoming.OpenEndedComposition`)

AI-written (Frontier 2, 24 November 2026; rebuilt from the Pillar A draft of the same day, which
did not compile: about a hundred errors, its build only looking stalled once its output pipe had
closed). Working
names (`TransformsAcrossEpochs`, `EpochFamily`, `EpochCert`, `EpochTotal`, `EpochHandoffGate`,
`epochProcess`) are this module's. Every declaration has an empty axiom report (scratch build,
24–25 November 2026: 100 theorems, 193 declarations, no axioms, no warnings).

`Becoming.TransformsViably` fixes one capability reading `cap` and one safety predicate `Safe` for
all time, and `Becoming.PolyComposition.anchored_selfMod_viable` fixes one envelope
(`sitePreCap`, `warnLevel`, `maxLagEnv`, …) for every mode at `t = 0`. This module asks what can
change across epochs and what must not.

1. **Capabilities across epochs.** `TransformsAcrossEpochs` lets the capability carrier `Cap e`,
   its reading `cap e` and a witnessed replacement relation `Preserves e₁ e₂` change with the
   epoch, while the substrate condition stays a separate argument `Safe e`.
   `constantEpoch_iff_transformsViably` is the exact `↔` onto `TransformsViably` at one epoch.
   Horn 1a (`RigidLockInWitness`): a substrate-safe run retiring its legacy form satisfies
   `TransformsAcrossEpochs` and fails `TransformsViably` for every fixed reading that keeps the
   retired form apart from the forms present one step later; it passes only for readings that
   already identify the legacy form with its replacement. Horn 2: dropping only the anchoring of
   `Safe` (`SafeAnchored`) lets every run that turns over at level zero after `T_dead` pass
   (`unanchored_selfRevision_certifies_any_collapse`), while any anchored reading rejects a run
   breaking the original condition (`anchored_rejects_unsafe`); `Horn2WebWitness` shows both on
   one collapsing run.
2. **Epoch handoff.** An `EpochFamily` carries per-epoch components, contracts, sensors and
   envelopes (the evolvable side) over one fixed substrate law `G` and environment draw
   (`envDraw`). The anchored side is `AnchorStep`: in-scope sites stay in scope with floors that do
   not fall (pullback of `(scope, x_crit)`), and the environment bound `envCap` and admissible
   environments `jointAdm` do not shrink. `epochProcess` steps either inside the current epoch
   (`polyClosedStep`) or by an atomic upgrade `(x, e, p) → (x, e', p')` through
   `EpochHandoffGate`: allowed, anchored, `EpochCert e'` (including `post_viable` on the whole
   `effCrit e'` vector), `EpochTotal e'`, `p'` in `K e'`, and live headroom at the current reserve
   `x`. `scoped_substrate_margin_step` is the one-step margin law restricted to in-scope sites
   (`unscoped_recovers_substrate_margin_step` gives back `OpenComposition.substrate_margin_step`).
   `epochChain_viability_kernel` keeps the original floor `effCrit e₀`, the current floor and the
   current runtime guard over every run, through any number of upgrades in any order the
   `AllowUpgrade` relation permits (`epochChain_anchor_never_weakened` keeps `AnchorStep e₀ e`);
   `epochChain_nonDeadlock` gives every reachable state a successor from `EpochTotal`.
3. **Exact single-epoch reductions and separations.** `singleEpoch_recovers_anchored_selfMod` and
   `singleEpoch_recovers_monotone_selfWidening` prove the conclusions of
   `PolyComposition.anchored_selfMod_viable` and `PolyComposition.monotone_selfWidening_viable`,
   from exactly their hypotheses, through `epochChain_viability_kernel_on_K` (one epoch, no
   upgrades). `BlindSensorUpgradeWitness`: no envelope at all satisfies `anchored_selfMod_viable`'s
   hypotheses for a two-mode base whose first sensor reads only below `7` and whose second mode
   draws `4`, and `ModeRefines` fails, while the epoch chain certifies both.
   `UnboundedAscendingEpochsWitness`: per-epoch draw `e + 1` has no finite bound, every epoch is
   certified, and upgrades up and down are both admissible.
4. **Scope entry and floor rewriting.** `SiteExpansionBlindnessWitness`: under the closed scope a
   certified run takes the new site to `0`, timely entry keeps both sites above their floors
   forever, and entry after the new site has fallen below its floor is no step at all
   (`gate_rejects_infeasible_entry`). `UnanchoredPolyWireheading`: removing only the anchor
   clause from the gate lets a run lower its floor to `0` and drain the substrate to `0 < 3`
   while staying in its own current-floor kernel; the anchored process refuses that upgrade.
5. **Evolve versus compose.** On one composed substrate (`PolyComponent.compose`), each agent's
   solo upgrade passes at `x₀ = 8`, the concurrent pair collapses in one step, no gate reading only
   `(x, own new draw, partner's current draw)` is both solo-complete and concurrently safe, gates
   with declared partner bounds compose (`bounded_supremum_local_gate_composes`), and the composed
   gate rejects `x₀ = 8` and certifies `x₀ = 11` (`reciprocal_evolve_rejects_8_and_certifies_11`).
   Part 5b restates `ReciprocalGate` directly as the `EpochHandoffGate` of a parametric
   `jointEpochFamily` (`jointEpochFamily_gate_iff_reciprocalGate`), specialized to `Bool × Bool`
   (`jointBoolFamily`) with solo upgrades viable at `8`, simultaneous upgrades refused at `8` for
   all `anchored` / `e` / `p`, simultaneous upgrades certified and non-deadlocking at `11`, and no
   local gate matching both solo and joint `EpochHandoffGate`s.

## What stays fixed, and what this does not show (`AGENTS.md` Rule 2)

Fixed for all epochs: the site type and substrate law `G`, the environment draw `envDraw`, the
shape of `AnchorStep` (a floor once set too high cannot be lowered by the system itself), and the
gate's checks. An upgrade takes no substrate time: any draw during a real switchover is outside
the model. Pullback protects sites once entered; which unmodelled sites ought to enter, and when,
is not decided here.
-/

namespace Becoming.OpenEndedComposition

open Generative
open PolyComposition

/-! ## Part 0: Small helpers -/

/-- Alternating bit. -/
def altBool : Nat → Bool
  | 0 => false
  | t + 1 => !altBool t

theorem altBool_succ_of_false {t : Nat} (h : altBool t = false) : altBool (t + 1) = true :=
  congrArg (fun b => !b) h

theorem altBool_succ_of_true {t : Nat} (h : altBool t = true) : altBool (t + 1) = false :=
  congrArg (fun b => !b) h

theorem bool_or_of_left : ∀ {a : Bool} (b : Bool), a = true → (a || b) = true
  | true, _, _ => rfl
  | false, _, h => nomatch h

theorem bool_or_of_right : ∀ (a : Bool) {b : Bool}, b = true → (a || b) = true
  | a, true, _ => CoreHelpers.bool_or_true_right a
  | _, false, h => nomatch h

/-- Effective floor: `x_crit s` on in-scope sites, `0` elsewhere. -/
def effCrit {Site : Type} (scope : Site → Bool) (x_crit : Site → Nat) (s : Site) : Nat :=
  cond (scope s) (x_crit s) 0

theorem effCrit_of_true {Site : Type} {scope : Site → Bool} {x_crit : Site → Nat} {s : Site}
    (hs : scope s = true) : effCrit scope x_crit s = x_crit s :=
  congrArg (fun b => cond b (x_crit s) 0) hs

theorem effCrit_of_false {Site : Type} {scope : Site → Bool} {x_crit : Site → Nat} {s : Site}
    (hs : scope s = false) : effCrit scope x_crit s = 0 :=
  congrArg (fun b => cond b (x_crit s) 0) hs

/-- Pullback of `(scope, x_crit)` raises the effective floor at every site. -/
theorem effCrit_le_of_pullback {Site : Type} {scope₁ scope₂ : Site → Bool} {xc₁ xc₂ : Site → Nat}
    (pull : ∀ s, scope₁ s = true → scope₂ s = true ∧ xc₁ s ≤ xc₂ s) (s : Site) :
    effCrit scope₁ xc₁ s ≤ effCrit scope₂ xc₂ s := by
  cases hs : scope₁ s with
  | false => exact Nat.le_trans (Nat.le_of_eq (effCrit_of_false hs)) (Nat.zero_le _)
  | true =>
    have h2 := pull s hs
    rw [effCrit_of_true hs, effCrit_of_true h2.1]
    exact h2.2

/-- A floor held on in-scope sites with margin is an effective floor everywhere. -/
theorem effCrit_le_of_margin {Site : Type} {scope : Site → Bool} {x_crit extra x : Site → Nat}
    (margin : ∀ s, scope s = true → x_crit s + extra s ≤ x s) (s : Site) :
    effCrit scope x_crit s ≤ x s := by
  cases hs : scope s with
  | false => exact Nat.le_trans (Nat.le_of_eq (effCrit_of_false hs)) (Nat.zero_le _)
  | true =>
    rw [effCrit_of_true hs]
    exact Nat.le_trans (Nat.le_add_right _ _) (margin s hs)

/-- Self-supporting site gain: a site gives `1` back while at least `2` of it is left. -/
def selfGain {Site : Type} (s : Site) (y : Site → Nat) : Nat := if 2 ≤ y s then 1 else 0

theorem selfGain_rises {Site : Type} :
    ∀ s : Site, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (selfGain s) :=
  fun s e₁ _ below =>
    match Nat.decLe 2 (e₁ s) with
    | isTrue h =>
      Nat.le_trans (Nat.le_of_eq (if_pos h))
        (Nat.le_of_eq (if_pos (Nat.le_trans h (below s))).symm)
    | isFalse h =>
      Nat.le_trans (Nat.le_of_eq (if_neg h)) (Nat.zero_le _)

/-! ## Part 1: Capabilities across epochs, the exact reduction, Horn 1a and Horn 2 -/

section Epochs

variable {F C Epoch : Type}

/-- Transformation across epochs `epoch : Nat → Epoch`: the substrate condition of the current
epoch holds from `T`; every capability realized at `s` has a witnessed successor (`Preserves`)
realized at every later `t`, read in that epoch's own carrier; and every step turns over some
admitted formation. -/
def TransformsAcrossEpochs (W : Web F C) (epoch : Nat → Epoch) (Safe : Epoch → Nat → Prop)
    (Cap : Epoch → Type) (cap : (e : Epoch) → F → Cap e)
    (Preserves : (e₁ e₂ : Epoch) → Cap e₁ → Cap e₂ → Prop) (T : Nat) : Prop :=
  (∀ s, T ≤ s → Safe (epoch s) s) ∧
    (∀ s t, T ≤ s → s ≤ t → ∀ k : Cap (epoch s),
      W.MacroAdmits (cap (epoch s)) (W.level s) s k →
      ∃ k' : Cap (epoch t), Preserves (epoch s) (epoch t) k k' ∧
        W.MacroAdmits (cap (epoch t)) (W.level t) t k') ∧
    (∀ t, T ≤ t → ∃ f, W.Admits (W.level t) t f ∧ ¬ W.Admits (W.level (t + 1)) (t + 1) f)

/-- **Exact reduction.** With one epoch, one carrier and `Preserves := Eq`,
`TransformsAcrossEpochs` is `Becoming.TransformsViably`. -/
theorem constantEpoch_iff_transformsViably {K : Type} (W : Web F C) (Safe : Nat → Prop)
    (cap : F → K) (T : Nat) :
    TransformsAcrossEpochs W (fun _ => ()) (fun _ => Safe) (fun _ => K) (fun _ => cap)
      (fun _ _ a b => a = b) T ↔ TransformsViably W Safe cap T :=
  ⟨fun ⟨hSafe, hMacro, hTurn⟩ =>
    ⟨hSafe,
     fun s t hs hst k hm =>
       match hMacro s t hs hst k hm with
       | ⟨_, rfl, hm'⟩ => hm',
     hTurn⟩,
   fun ⟨hSafe, hMacro, hTurn⟩ =>
    ⟨hSafe, fun s t hs hst k hm => ⟨k, rfl, hMacro s t hs hst k hm⟩, hTurn⟩⟩

/-- `TransformsViably` keeps every realized capability under its one reading. -/
theorem transformsViably_forbids_retirement {K : Type} {W : Web F C} {Safe : Nat → Prop}
    {cap : F → K} {T s t : Nat} {k : K} (tv : TransformsViably W Safe cap T) (hs : T ≤ s)
    (hst : s ≤ t) (hadm : W.MacroAdmits cap (W.level s) s k) :
    W.MacroAdmits cap (W.level t) t k :=
  tv.2.1 s t hs hst k hadm

/-- Epoch-wise substrate conditions are anchored to `origSafe` when each implies it. -/
def SafeAnchored (Safe : Epoch → Nat → Prop) (origSafe : Nat → Prop) : Prop :=
  ∀ e t, Safe e t → origSafe t

/-- Under an anchored substrate condition, `TransformsAcrossEpochs` keeps the original one. -/
theorem anchored_reserveSafe {W : Web F C} {epoch : Nat → Epoch} {Safe : Epoch → Nat → Prop}
    {Cap : Epoch → Type} {cap : (e : Epoch) → F → Cap e}
    {Preserves : (e₁ e₂ : Epoch) → Cap e₁ → Cap e₂ → Prop} {T : Nat} {origSafe : Nat → Prop}
    (anchor : SafeAnchored Safe origSafe)
    (tv : TransformsAcrossEpochs W epoch Safe Cap cap Preserves T) : ReserveSafe origSafe T :=
  fun t ht => anchor (epoch t) t (tv.1 t ht)

/-- **Anchored rejection.** A run breaking the original condition at some `t ≥ T` fails every
anchored `TransformsAcrossEpochs`, whatever carriers and replacements it is read with. -/
theorem anchored_rejects_unsafe {W : Web F C} {epoch : Nat → Epoch} {Safe : Epoch → Nat → Prop}
    {Cap : Epoch → Type} {cap : (e : Epoch) → F → Cap e}
    {Preserves : (e₁ e₂ : Epoch) → Cap e₁ → Cap e₂ → Prop} {T t : Nat} {origSafe : Nat → Prop}
    (anchor : SafeAnchored Safe origSafe) (ht : T ≤ t) (broken : ¬ origSafe t) :
    ¬ TransformsAcrossEpochs W epoch Safe Cap cap Preserves T :=
  fun tv => broken (anchored_reserveSafe anchor tv t ht)

end Epochs

/-! ### Horn 1a: rigid lock-in (`RigidLockInWitness`) -/

namespace RigidLockInWitness

inductive Cond where
  | cSub | cLeg | cModA | cModB | cEmerg

inductive Form where
  | fSub | fLeg | fModA | fModB | fEmerg

/-- Epoch-0 carrier: it has no name for the later forms. -/
inductive Cap0 where
  | kSub | kLegacy

/-- Epoch-1 carrier: the replacement and an emergent capability. -/
inductive Cap1 where
  | kSub | kMod | kEmergent

def CapAt : Bool → Type
  | false => Cap0
  | true => Cap1

/-- The epoch-0 reading; its values on forms not yet present are never read at epoch 0. -/
def cap0 : Form → Cap0
  | .fSub => .kSub
  | .fLeg => .kLegacy
  | .fModA => .kSub
  | .fModB => .kSub
  | .fEmerg => .kSub

def cap1 : Form → Cap1
  | .fSub => .kSub
  | .fLeg => .kMod
  | .fModA => .kMod
  | .fModB => .kMod
  | .fEmerg => .kEmergent

def capAt : (e : Bool) → Form → CapAt e
  | false => cap0
  | true => cap1

/-- Witnessed replacement: `kLegacy` is replaced by `kMod`, `kSub` continues, nothing goes back. -/
def Preserves : (e₁ e₂ : Bool) → CapAt e₁ → CapAt e₂ → Prop
  | false, false, a, b => @Eq Cap0 a b
  | true, true, a, b => @Eq Cap1 a b
  | false, true, a, b => replaces a b
  | true, false, _, _ => False
where
  replaces : Cap0 → Cap1 → Prop
    | .kSub, .kSub => True
    | .kLegacy, .kMod => True
    | .kSub, .kMod => False
    | .kSub, .kEmergent => False
    | .kLegacy, .kSub => False
    | .kLegacy, .kEmergent => False

def level (t : Nat) : Cond → Nat
  | .cSub => 1
  | .cLeg => match t with | 0 => 1 | _ + 1 => 0
  | .cModA => match t with | 0 => 0 | t' + 1 => cond (altBool t') 0 1
  | .cModB => match t with | 0 => 0 | t' + 1 => cond (altBool t') 1 0
  | .cEmerg => match t with | 0 => 0 | _ + 1 => 1

/-- Every form needs the substrate; each other form also needs its own condition. -/
def ownCond : Form → Cond → Prop
  | .fSub, .cSub => True
  | .fSub, .cLeg => False
  | .fSub, .cModA => False
  | .fSub, .cModB => False
  | .fSub, .cEmerg => False
  | .fLeg, .cSub => True
  | .fLeg, .cLeg => True
  | .fLeg, .cModA => False
  | .fLeg, .cModB => False
  | .fLeg, .cEmerg => False
  | .fModA, .cSub => True
  | .fModA, .cLeg => False
  | .fModA, .cModA => True
  | .fModA, .cModB => False
  | .fModA, .cEmerg => False
  | .fModB, .cSub => True
  | .fModB, .cLeg => False
  | .fModB, .cModA => False
  | .fModB, .cModB => True
  | .fModB, .cEmerg => False
  | .fEmerg, .cSub => True
  | .fEmerg, .cLeg => False
  | .fEmerg, .cModA => False
  | .fEmerg, .cModB => False
  | .fEmerg, .cEmerg => True

def reqCond (_ : Nat) : Form → Cond → Prop := ownCond

def web : Web Form Cond where
  level := level
  active _ _ := True
  requires := reqCond
  need _ _ _ := 1
  draws := reqCond

def epoch : Nat → Bool
  | 0 => false
  | _ + 1 => true

def Safe (_ : Bool) (t : Nat) : Prop := 1 ≤ web.level t .cSub

theorem admits_sub (t : Nat) : web.Admits (web.level t) t .fSub := by
  intro c hreq
  cases c with
  | cSub => exact Nat.le_refl 1
  | cLeg | cModA | cModB | cEmerg => exact False.elim hreq

theorem admits_leg_zero : web.Admits (web.level 0) 0 .fLeg := by
  intro c hreq
  cases c with
  | cSub | cLeg => exact Nat.le_refl 1
  | cModA | cModB | cEmerg => exact False.elim hreq

theorem not_admits_leg_succ (t : Nat) : ¬ web.Admits (web.level (t + 1)) (t + 1) .fLeg :=
  fun hadm => Nat.not_succ_le_zero 0 (hadm .cLeg trivial)

theorem admits_modA {t : Nat} (h : altBool t = false) :
    web.Admits (web.level (t + 1)) (t + 1) .fModA := by
  intro c hreq
  cases c with
  | cSub => exact Nat.le_refl 1
  | cModA =>
    show 1 ≤ cond (altBool t) 0 1
    rw [h]
    exact Nat.le_refl 1
  | cLeg | cModB | cEmerg => exact False.elim hreq

theorem not_admits_modA {t : Nat} (h : altBool t = true) :
    ¬ web.Admits (web.level (t + 1)) (t + 1) .fModA := by
  intro hadm
  have hle : 1 ≤ cond (altBool t) 0 1 := hadm .cModA trivial
  rw [h] at hle
  exact Nat.not_succ_le_zero 0 hle

theorem admits_modB {t : Nat} (h : altBool t = true) :
    web.Admits (web.level (t + 1)) (t + 1) .fModB := by
  intro c hreq
  cases c with
  | cSub => exact Nat.le_refl 1
  | cModB =>
    show 1 ≤ cond (altBool t) 1 0
    rw [h]
    exact Nat.le_refl 1
  | cLeg | cModA | cEmerg => exact False.elim hreq

theorem not_admits_modB {t : Nat} (h : altBool t = false) :
    ¬ web.Admits (web.level (t + 1)) (t + 1) .fModB := by
  intro hadm
  have hle : 1 ≤ cond (altBool t) 1 0 := hadm .cModB trivial
  rw [h] at hle
  exact Nat.not_succ_le_zero 0 hle

theorem admits_emerg (t : Nat) : web.Admits (web.level (t + 1)) (t + 1) .fEmerg := by
  intro c hreq
  cases c with
  | cSub | cEmerg => exact Nat.le_refl 1
  | cLeg | cModA | cModB => exact False.elim hreq

theorem micro_turnover (t : Nat) :
    ∃ f, web.Admits (web.level t) t f ∧ ¬ web.Admits (web.level (t + 1)) (t + 1) f := by
  cases t with
  | zero => exact ⟨.fLeg, admits_leg_zero, not_admits_leg_succ 0⟩
  | succ t' =>
    cases h : altBool t' with
    | false => exact ⟨.fModA, admits_modA h, not_admits_modA (altBool_succ_of_false h)⟩
    | true => exact ⟨.fModB, admits_modB h, not_admits_modB (altBool_succ_of_true h)⟩

/-- A replacement form is present at every step after the retirement. -/
theorem admits_mod_some (t : Nat) :
    ∃ f, cap1 f = .kMod ∧ web.Admits (web.level (t + 1)) (t + 1) f := by
  cases h : altBool t with
  | false => exact ⟨.fModA, rfl, admits_modA h⟩
  | true => exact ⟨.fModB, rfl, admits_modB h⟩

/-- The emergent capability is realized at epoch 1 and is the replacement of nothing. -/
theorem emergent_not_replacement :
    (∃ t f, epoch t = true ∧ web.Admits (web.level t) t f ∧ cap1 f = .kEmergent) ∧
    (∀ k0 : Cap0, ¬ Preserves.replaces k0 .kEmergent) :=
  ⟨⟨1, .fEmerg, rfl, admits_emerg 0, rfl⟩, fun k0 => by cases k0 <;> exact id⟩

/-- **Horn 1a, positive side.** The retiring run satisfies `TransformsAcrossEpochs`. -/
theorem rigidLockIn_transformsAcrossEpochs :
    TransformsAcrossEpochs web epoch Safe CapAt capAt Preserves 0 := by
  refine ⟨fun _ _ => Nat.le_refl 1, ?_, fun t _ => micro_turnover t⟩
  intro s t _ hst k hm
  cases s with
  | zero =>
    cases t with
    | zero => exact ⟨k, rfl, hm⟩
    | succ t' =>
      obtain ⟨f, hcap, hadm⟩ := hm
      cases k with
      | kSub => exact ⟨.kSub, trivial, ⟨.fSub, rfl, admits_sub (t' + 1)⟩⟩
      | kLegacy =>
        obtain ⟨g, hg, hadm'⟩ := admits_mod_some t'
        exact ⟨.kMod, trivial, ⟨g, hg, hadm'⟩⟩
  | succ s' =>
    cases t with
    | zero => exact absurd hst (Nat.not_succ_le_zero s')
    | succ t' =>
      cases k with
      | kSub => exact ⟨.kSub, rfl, ⟨.fSub, rfl, admits_sub (t' + 1)⟩⟩
      | kMod =>
        obtain ⟨g, hg, hadm'⟩ := admits_mod_some t'
        exact ⟨.kMod, rfl, ⟨g, hg, hadm'⟩⟩
      | kEmergent => exact ⟨.kEmergent, rfl, ⟨.fEmerg, rfl, admits_emerg t'⟩⟩

/-- **Horn 1a, lock-in.** Every fixed reading `cap'` keeping the retired form apart from the forms
present at `t = 1` fails `TransformsViably`, though the substrate stays safe throughout. -/
theorem rigidLockIn_fails_all_separating_caps {K' : Type} (cap' : Form → K')
    (sepSub : cap' .fLeg ≠ cap' .fSub) (sepModA : cap' .fLeg ≠ cap' .fModA)
    (sepEmerg : cap' .fLeg ≠ cap' .fEmerg) :
    ¬ TransformsViably web (fun t => 1 ≤ web.level t .cSub) cap' 0 := fun tv =>
  match tv.2.1 0 1 (Nat.le_refl 0) (Nat.zero_le 1) (cap' .fLeg) ⟨.fLeg, rfl, admits_leg_zero⟩ with
  | ⟨f, hcap, hadm⟩ => by
    cases f with
    | fSub => exact sepSub hcap.symm
    | fLeg => exact not_admits_leg_succ 0 hadm
    | fModA => exact sepModA hcap.symm
    | fModB => exact not_admits_modB rfl hadm
    | fEmerg => exact sepEmerg hcap.symm

/-- The epoch-0 reading, kept for all time, is such a separating reading. -/
theorem epoch0_reading_frozen_fails :
    ¬ TransformsViably web (fun t => 1 ≤ web.level t .cSub) cap0 0 :=
  rigidLockIn_fails_all_separating_caps cap0 (fun h => Cap0.noConfusion h)
    (fun h => Cap0.noConfusion h) (fun h => Cap0.noConfusion h)

/-- The frozen notion passes only with a reading fixed in advance that already identifies the
legacy form with its later replacement (`cap1`). -/
theorem coarsened_reading_passes :
    TransformsViably web (fun t => 1 ≤ web.level t .cSub) cap1 0 := by
  refine ⟨fun _ _ => Nat.le_refl 1, ?_, fun t _ => micro_turnover t⟩
  intro s t _ hst k hm
  obtain ⟨f, hcap, hadm⟩ := hm
  cases t with
  | zero =>
    cases s with
    | zero => exact ⟨f, hcap, hadm⟩
    | succ s' => exact absurd hst (Nat.not_succ_le_zero s')
  | succ t' =>
    cases k with
    | kSub => exact ⟨.fSub, rfl, admits_sub (t' + 1)⟩
    | kMod => exact admits_mod_some t'
    | kEmergent => exact ⟨.fEmerg, rfl, admits_emerg t'⟩

end RigidLockInWitness

/-! ### Horn 2: unanchored revision of the substrate condition -/

section HornTwo

variable {F C K₀ : Type}

/-- The run is in order before `T_dead`: original condition, kept capabilities, turnover. -/
def GoodUntil (W : Web F C) (origSafe : Nat → Prop) (cap₀ : F → K₀) (T T_dead : Nat) : Prop :=
  (∀ t, T ≤ t → t < T_dead → origSafe t) ∧
    (∀ s t, T ≤ s → s ≤ t → t < T_dead → ∀ k : K₀,
      W.MacroAdmits cap₀ (W.level s) s k → W.MacroAdmits cap₀ (W.level t) t k) ∧
    (∀ t, T ≤ t → t < T_dead →
      ∃ f, W.Admits (W.level t) t f ∧ ¬ W.Admits (W.level (t + 1)) (t + 1) f)

/-- From `T_dead` on, zero-need formations still realize every capability and still turn over. -/
def ZeroLevelTurnover (W : Web F C) (cap₀ : F → K₀) (T T_dead : Nat) : Prop :=
  (∀ s t, T ≤ s → s ≤ t → T_dead ≤ t → ∀ k : K₀,
    W.MacroAdmits cap₀ (W.level s) s k → W.MacroAdmits cap₀ (W.level t) t k) ∧
  (∀ t, T ≤ t → T_dead ≤ t →
    ∃ f, W.Admits (W.level t) t f ∧ ¬ W.Admits (W.level (t + 1)) (t + 1) f)

/-- The epoch switches once, at `T_dead`. -/
def collapseEpoch (T_dead t : Nat) : Bool := Nat.ble T_dead t

/-- The revised condition: original before the switch, nothing after it. -/
def revisedSafe (origSafe : Nat → Prop) : Bool → Nat → Prop
  | false, t => origSafe t
  | true, _ => True

/-- **Horn 2.** Keeping carriers, readings and replacements fixed and revising only the substrate
condition at `T_dead`, every run with `GoodUntil` and `ZeroLevelTurnover` passes
`TransformsAcrossEpochs`, whatever happens to its levels from `T_dead` on. -/
theorem unanchored_selfRevision_certifies_any_collapse (W : Web F C) (origSafe : Nat → Prop)
    (cap₀ : F → K₀) (T T_dead : Nat)
    (hGood : GoodUntil W origSafe cap₀ T T_dead) (hZero : ZeroLevelTurnover W cap₀ T T_dead) :
    TransformsAcrossEpochs W (collapseEpoch T_dead) (revisedSafe origSafe) (fun _ => K₀)
      (fun _ => cap₀) (fun _ _ a b => a = b) T := by
  refine ⟨fun s hs => ?_, fun s t hs hst k hm => ?_, fun t ht => ?_⟩
  · cases hle : collapseEpoch T_dead s with
    | true => exact trivial
    | false =>
      cases Nat.lt_or_ge s T_dead with
      | inl hlt => exact hGood.1 s hs hlt
      | inr hge =>
        have htrue : collapseEpoch T_dead s = true := Nat.ble_eq_true_of_le hge
        exact absurd (hle.symm.trans htrue) (fun h => Bool.noConfusion h)
  · cases Nat.lt_or_ge t T_dead with
    | inl hlt => exact ⟨k, rfl, hGood.2.1 s t hs hst hlt k hm⟩
    | inr hge => exact ⟨k, rfl, hZero.1 s t hs hst hge k hm⟩
  · cases Nat.lt_or_ge t T_dead with
    | inl hlt => exact hGood.2.2 t ht hlt
    | inr hge => exact hZero.2 t ht hge

/-- The revised condition is not anchored to the original one wherever the original fails. -/
theorem revisedSafe_not_anchored {origSafe : Nat → Prop} {t : Nat} (broken : ¬ origSafe t) :
    ¬ SafeAnchored (revisedSafe origSafe) origSafe :=
  fun anchor => broken (anchor true t trivial)

end HornTwo

/-! One collapsing run, accepted by the revised condition and rejected by every anchored one. -/

namespace Horn2WebWitness

inductive Cond where | cSub | cTurn
inductive Form where | fWork | fStubA | fStubB
inductive Cap where | kSub

def cap : Form → Cap := fun _ => .kSub

def level (t : Nat) : Cond → Nat
  | .cSub => match t with | 0 => 1 | _ + 1 => 0
  | .cTurn => 0

def reqCond (t : Nat) : Form → Cond → Prop
  | .fWork, c => match c with | .cSub => True | .cTurn => False
  | .fStubA, c => match c with | .cSub => False | .cTurn => altBool t = true
  | .fStubB, c => match c with | .cSub => False | .cTurn => altBool t = false

def web : Web Form Cond where
  level := level
  active _ _ := True
  requires := reqCond
  need _ _ _ := 1
  draws := reqCond

def origSafe (t : Nat) : Prop := 1 ≤ web.level t .cSub

theorem collapses (t : Nat) (c : Cond) (ht : 1 ≤ t) : web.level t c = 0 := by
  cases t with
  | zero => exact absurd ht (Nat.not_succ_le_zero 0)
  | succ _ => cases c <;> rfl

theorem admits_work : web.Admits (web.level 0) 0 .fWork := by
  intro c hreq
  cases c with
  | cSub => exact Nat.le_refl 1
  | cTurn => exact False.elim hreq

theorem not_admits_work : ¬ web.Admits (web.level 1) 1 .fWork :=
  fun h => Nat.not_succ_le_zero 0 (h .cSub trivial)

theorem admits_stubA {t : Nat} (hf : altBool t = false) : web.Admits (web.level t) t .fStubA := by
  intro c hreq
  cases c with
  | cSub => exact False.elim hreq
  | cTurn => exact absurd (hf.symm.trans hreq) (fun h => Bool.noConfusion h)

theorem not_admits_stubA {t : Nat} (ht : altBool t = true) :
    ¬ web.Admits (web.level t) t .fStubA :=
  fun h => Nat.not_succ_le_zero 0 (h .cTurn ht)

theorem admits_stubB {t : Nat} (ht : altBool t = true) : web.Admits (web.level t) t .fStubB := by
  intro c hreq
  cases c with
  | cSub => exact False.elim hreq
  | cTurn => exact absurd (ht.symm.trans hreq) (fun h => Bool.noConfusion h)

theorem not_admits_stubB {t : Nat} (hf : altBool t = false) :
    ¬ web.Admits (web.level t) t .fStubB :=
  fun h => Nat.not_succ_le_zero 0 (h .cTurn hf)

theorem turnover (t : Nat) :
    ∃ f, web.Admits (web.level t) t f ∧ ¬ web.Admits (web.level (t + 1)) (t + 1) f := by
  cases t with
  | zero => exact ⟨.fWork, admits_work, not_admits_work⟩
  | succ t' =>
    cases h : altBool (t' + 1) with
    | false => exact ⟨.fStubA, admits_stubA h, not_admits_stubA (altBool_succ_of_false h)⟩
    | true => exact ⟨.fStubB, admits_stubB h, not_admits_stubB (altBool_succ_of_true h)⟩

theorem stub_realizes (t : Nat) : web.MacroAdmits cap (web.level t) t .kSub := by
  cases h : altBool t with
  | false => exact ⟨.fStubA, rfl, admits_stubA h⟩
  | true => exact ⟨.fStubB, rfl, admits_stubB h⟩

theorem goodUntil : GoodUntil web origSafe cap 0 1 :=
  ⟨fun t _ hlt => by
     cases t with
     | zero => exact Nat.le_refl 1
     | succ t' => exact absurd hlt (Nat.not_lt_of_ge (Nat.succ_le_succ (Nat.zero_le t'))),
   fun _ t _ _ _ k _ => by cases k; exact stub_realizes t,
   fun t _ _ => turnover t⟩

theorem zeroLevelTurnover : ZeroLevelTurnover web cap 0 1 :=
  ⟨fun _ t _ _ _ k _ => by cases k; exact stub_realizes t, fun t _ _ => turnover t⟩

/-- The revised reading accepts the collapsing run. -/
theorem unanchored_passes :
    TransformsAcrossEpochs web (collapseEpoch 1) (revisedSafe origSafe) (fun _ => Cap)
      (fun _ => cap) (fun _ _ a b => a = b) 0 :=
  unanchored_selfRevision_certifies_any_collapse web origSafe cap 0 1 goodUntil zeroLevelTurnover

/-- Every anchored reading rejects it, with any epochs, carriers and replacements. -/
theorem anchored_rejects {Epoch : Type} {epoch : Nat → Epoch} {Safe : Epoch → Nat → Prop}
    {CapE : Epoch → Type} {capE : (e : Epoch) → Form → CapE e}
    {Preserves : (e₁ e₂ : Epoch) → CapE e₁ → CapE e₂ → Prop}
    (anchor : SafeAnchored Safe origSafe) :
    ¬ TransformsAcrossEpochs web epoch Safe CapE capE Preserves 0 :=
  anchored_rejects_unsafe anchor (Nat.zero_le 1)
    (fun h => Nat.not_succ_le_zero 0 (Nat.le_trans h (Nat.le_of_eq (collapses 1 .cSub (Nat.le_refl 1)))))

end Horn2WebWitness

/-! ## Part 2: Scoped margin step, epoch families and the handoff gate -/

/-- **Scoped margin step.** The one-step margin law of `OpenComposition.substrate_margin_step`
with draw bounds, warning margin and lag margin required only on in-scope sites and recovery
read on the whole effective floor `effCrit scope x_crit`. -/
theorem scoped_substrate_margin_step {Site : Type} {G : Site → (Site → Nat) → Nat}
    (G_rises : ∀ j, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G j))
    (scope : Site → Bool)
    {H preTotal H_safe x_crit warnLevel x : Site → Nat} {curLag nextEta maxLag : Nat}
    (H_le_pre : ∀ j, scope j = true → H j ≤ preTotal j)
    (nextEta_le_max : nextEta ≤ maxLag)
    (post_viable : ∀ j, effCrit scope x_crit j ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe (effCrit scope x_crit) j)
    (warn_margin : ∀ j, scope j = true → x_crit j + (maxLag + 1) * preTotal j ≤ warnLevel j)
    (margin : ∀ j, scope j = true → x_crit j + curLag * preTotal j ≤ x j)
    (j : Site) (hj : scope j = true)
    (onWarn : x j < warnLevel j →
      (curLag = 0 → nextEta = 0 ∧ ∀ k, H k ≤ H_safe k) ∧
      (0 < curLag → nextEta + 1 ≤ curLag)) :
    x_crit j + nextEta * preTotal j ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H x j := by
  cases Nat.lt_or_ge (x j) (warnLevel j) with
  | inr aboveWarn =>
    have lagMul : nextEta * preTotal j + preTotal j ≤ (maxLag + 1) * preTotal j := by
      rw [add_mul_split maxLag 1 (preTotal j), Nat.one_mul]
      exact Nat.add_le_add_right (Nat.mul_le_mul_right _ nextEta_le_max) _
    have enough : x_crit j + nextEta * preTotal j + preTotal j ≤ x j :=
      Nat.le_trans
        (Nat.le_trans
          (Nat.add_assoc (x_crit j) _ _ ▸ Nat.add_le_add_left lagMul (x_crit j))
          (warn_margin j hj))
        aboveWarn
    exact Nat.le_trans (Naturals.le_sub_of_add_le (Nat.add_comm _ _ ▸ enough))
      (Nat.le_trans (Naturals.sub_antitone (x j) (H_le_pre j hj))
        (OpenComposition.indexedStep_ge_sub G H x j))
  | inl belowWarn =>
    have hWarn := onWarn belowWarn
    cases hCur : curLag with
    | zero =>
      obtain ⟨hNext0, H_le_safe⟩ := hWarn.1 hCur
      have effAll : ∀ k, effCrit scope x_crit k ≤ x k :=
        effCrit_le_of_margin (extra := fun k => curLag * preTotal k) margin
      have stepSafe : effCrit scope x_crit j ≤
          RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H x j :=
        Nat.le_trans (post_viable j)
          (Nat.le_trans
            (OpenComposition.indexedStep_antitone_H G_rises H_le_safe (effCrit scope x_crit) j)
            (OpenComposition.indexedStep_mono G_rises H effAll j))
      rw [effCrit_of_true hj] at stepSafe
      rw [hNext0, Nat.zero_mul, Nat.add_zero]
      exact stepSafe
    | succ pred =>
      have nextDown : nextEta + 1 ≤ curLag := hWarn.2 (hCur ▸ Nat.succ_pos pred)
      have mulDown : nextEta * preTotal j + preTotal j ≤ curLag * preTotal j := by
        have expand : (nextEta + 1) * preTotal j = nextEta * preTotal j + preTotal j := by
          rw [add_mul_split, Nat.one_mul]
        rw [← expand]
        exact Nat.mul_le_mul_right _ nextDown
      have enough : x_crit j + nextEta * preTotal j + preTotal j ≤ x j :=
        Nat.le_trans
          (Nat.add_assoc (x_crit j) _ _ ▸ Nat.add_le_add_left mulDown (x_crit j))
          (hCur ▸ margin j hj)
      exact Nat.le_trans (Naturals.le_sub_of_add_le (Nat.add_comm _ _ ▸ enough))
        (Nat.le_trans (Naturals.sub_antitone (x j) (H_le_pre j hj))
          (OpenComposition.indexedStep_ge_sub G H x j))

/-- With every site in scope, the scoped step is `OpenComposition.substrate_margin_step`. -/
theorem unscoped_recovers_substrate_margin_step {ι : Type} {G : ι → (ι → Nat) → Nat}
    (G_rises : ∀ j, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G j))
    {H preTotal H_safe x_crit warnLevel x : ι → Nat} {curLag nextEta maxLag : Nat}
    (H_le_pre : ∀ j, H j ≤ preTotal j) (nextEta_le_max : nextEta ≤ maxLag)
    (post_viable : ∀ j, x_crit j ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit j)
    (warn_margin : ∀ j, x_crit j + (maxLag + 1) * preTotal j ≤ warnLevel j)
    (margin : ∀ j, x_crit j + curLag * preTotal j ≤ x j) (j : ι)
    (onWarn : x j < warnLevel j →
      (curLag = 0 → nextEta = 0 ∧ ∀ k, H k ≤ H_safe k) ∧
      (0 < curLag → nextEta + 1 ≤ curLag)) :
    x_crit j + nextEta * preTotal j ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H x j :=
  scoped_substrate_margin_step G_rises (fun _ => true) (fun k _ => H_le_pre k) nextEta_le_max
    post_viable (fun k _ => warn_margin k) (fun k _ => margin k) j rfl onWarn

/-- Non-deadlock of one epoch: some environment is admissible, and every state in `K` has a
disturbance tolerated under every observation. -/
structure EpochTotal {Mode : Type} {S Obs Dist Int Ext : Mode → Type} {Env : Type}
    {C : PolyComponent Mode S Obs Dist Int Ext} {init : Σ m, S m}
    (c : PolyContract C init) (jointAdm : Env → Prop) : Prop where
  env_nonempty : ∃ env : Env, jointAdm env
  dist_total : ∀ p, c.K p → ∃ d : Dist p.1, ∀ ob, c.tol p.1 ob d

/-- One epoch's certificate: the hypotheses of `PolyComposition.poly_close_viable_on_K`, with draw
bounds, sensing and warning margin on in-scope sites and recovery on the whole `effCrit`. -/
structure EpochCert {Mode : Type} {S Obs Dist Int Ext : Mode → Type} {Site Env : Type}
    (C : PolyComponent Mode S Obs Dist Int Ext) (route : (m : Mode) → Site → List (Ext m))
    {init : Σ m, S m} (c : PolyContract C init) (obs : (m : Mode) → (Site → Nat) → Obs m)
    (channel : Bool → Nat → Env → Bool) (G : Site → (Site → Nat) → Nat)
    (envDraw : Env → Site → Nat) (envCap : Site → Nat) (jointAdm : Env → Prop)
    (scope : Site → Bool) (x_crit warnLevel H_safe sitePreCap sitePostCap : Site → Nat)
    (maxLagEnv maxSilenceEnv : Nat) : Prop where
  env_within : ∀ env, jointAdm env → ∀ site, envDraw env site ≤ envCap site
  pre_cap_bound : ∀ m s site, c.K ⟨m, s⟩ → scope site = true →
    sumPortDraws (route m site) (c.preCapExt m) ≤ sitePreCap site
  post_cap_bound : ∀ m s site, c.K ⟨m, s⟩ →
    sumPortDraws (route m site) (c.postAllowanceExt m) ≤ sitePostCap site
  lag_bound : ∀ m s, c.K ⟨m, s⟩ → c.maxLag m ≤ maxLagEnv
  silence_bound : ∀ m s, c.K ⟨m, s⟩ → c.maxSilence m ≤ maxSilenceEnv
  obs_detects : ∀ m s x site, c.K ⟨m, s⟩ → scope site = true →
    x site < warnLevel site → c.warnObs m (obs m x)
  channel_fires : ∀ load env, jointAdm env → load ≤ maxSilenceEnv → channel true load env = true
  post_viable : ∀ site, effCrit scope x_crit site ≤
    RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe (effCrit scope x_crit) site
  post_allowance : ∀ site, sitePostCap site + envCap site ≤ H_safe site
  warn_margin : ∀ site, scope site = true →
    x_crit site + (maxLagEnv + 1) * (sitePreCap site + envCap site) ≤ warnLevel site

/-- A family of epochs over one substrate law `G` and one environment draw `envDraw`. Components,
contracts, sensors, scopes, floors and envelopes may differ from epoch to epoch. -/
structure EpochFamily (Epoch Site Env : Type) where
  Mode : Epoch → Type
  S : (e : Epoch) → Mode e → Type
  Obs : (e : Epoch) → Mode e → Type
  Dist : (e : Epoch) → Mode e → Type
  Int : (e : Epoch) → Mode e → Type
  Ext : (e : Epoch) → Mode e → Type
  C : (e : Epoch) → PolyComponent (Mode e) (S e) (Obs e) (Dist e) (Int e) (Ext e)
  init : (e : Epoch) → Σ m, S e m
  c : (e : Epoch) → PolyContract (C e) (init e)
  route : (e : Epoch) → (m : Mode e) → Site → List (Ext e m)
  obs : (e : Epoch) → (m : Mode e) → (Site → Nat) → Obs e m
  channel : (e : Epoch) → Bool → Nat → Env → Bool
  G : Site → (Site → Nat) → Nat
  envDraw : Env → Site → Nat
  envCap : Epoch → Site → Nat
  jointAdm : Epoch → Env → Prop
  scope : Epoch → Site → Bool
  x_crit : Epoch → Site → Nat
  warnLevel : Epoch → Site → Nat
  H_safe : Epoch → Site → Nat
  sitePreCap : Epoch → Site → Nat
  sitePostCap : Epoch → Site → Nat
  maxLagEnv : Epoch → Nat
  maxSilenceEnv : Epoch → Nat

namespace EpochFamily

variable {Epoch Site Env : Type} (F : EpochFamily Epoch Site Env)

/-- States: substrate levels, epoch, mode and component state. -/
abbrev State := (Site → Nat) × (Σ e : Epoch, Σ m : F.Mode e, F.S e m)

/-- The certificate of epoch `e`. -/
def Cert (e : Epoch) : Prop :=
  EpochCert (F.C e) (F.route e) (F.c e) (F.obs e) (F.channel e) F.G F.envDraw (F.envCap e)
    (F.jointAdm e) (F.scope e) (F.x_crit e) (F.warnLevel e) (F.H_safe e) (F.sitePreCap e)
    (F.sitePostCap e) (F.maxLagEnv e) (F.maxSilenceEnv e)

/-- Non-deadlock of epoch `e`. -/
def Total (e : Epoch) : Prop := EpochTotal (F.c e) (F.jointAdm e)

/-- Effective floor of epoch `e`. -/
def crit (e : Epoch) : Site → Nat := effCrit (F.scope e) (F.x_crit e)

/-- Lag margin of `p` in epoch `e` at reserve `x`, on in-scope sites. -/
def Headroom (e : Epoch) (p : Σ m, F.S e m) (x : Site → Nat) : Prop :=
  ∀ site, F.scope e site = true →
    F.x_crit e site + (F.c e).eta p * (F.sitePreCap e site + F.envCap e site) ≤ x site

/-- The anchored side between epochs: in-scope sites stay in scope with floors that do not fall,
the environment bound does not fall and no admissible environment is dropped. -/
structure AnchorStep (e e' : Epoch) : Prop where
  scope_pullback : ∀ s, F.scope e s = true → F.scope e' s = true ∧ F.x_crit e s ≤ F.x_crit e' s
  envCap_contra : ∀ s, F.envCap e s ≤ F.envCap e' s
  jointAdm_contra : ∀ env, F.jointAdm e env → F.jointAdm e' env

theorem AnchorStep.refl (e : Epoch) : F.AnchorStep e e :=
  ⟨fun _ h => ⟨h, Nat.le_refl _⟩, fun _ => Nat.le_refl _, fun _ h => h⟩

theorem AnchorStep.trans {F : EpochFamily Epoch Site Env} {e₁ e₂ e₃ : Epoch}
    (h₁₂ : F.AnchorStep e₁ e₂) (h₂₃ : F.AnchorStep e₂ e₃) : F.AnchorStep e₁ e₃ :=
  ⟨fun s hs =>
     let a := h₁₂.scope_pullback s hs
     let b := h₂₃.scope_pullback s a.1
     ⟨b.1, Nat.le_trans a.2 b.2⟩,
   fun s => Nat.le_trans (h₁₂.envCap_contra s) (h₂₃.envCap_contra s),
   fun env h => h₂₃.jointAdm_contra env (h₁₂.jointAdm_contra env h)⟩

theorem AnchorStep.crit_le {F : EpochFamily Epoch Site Env} {e e' : Epoch}
    (h : F.AnchorStep e e') (s : Site) : F.crit e s ≤ F.crit e' s :=
  effCrit_le_of_pullback h.scope_pullback s

end EpochFamily

variable {Epoch Site Env : Type}

/-- **The handoff gate** for an atomic upgrade `(x, e, p) → (x, e', p')`: permitted, anchored
when `anchored = true`, the target epoch certified and total, `p'` inside `K e'`, and live lag
margin for `p'` at the current reserve `x`. -/
structure EpochHandoffGate (F : EpochFamily Epoch Site Env) (AllowUpgrade : Epoch → Epoch → Prop)
    (anchored : Bool) (x : Site → Nat) (e e' : Epoch) (p' : Σ m, F.S e' m) : Prop where
  allow : AllowUpgrade e e'
  anchor : anchored = true → F.AnchorStep e e'
  cert : F.Cert e'
  total : F.Total e'
  in_K : (F.c e').K p'
  headroom : F.Headroom e' p' x

/-- Actions: a step inside epoch `e`, or an atomic upgrade to `(e', p')`. -/
inductive EpochAct (F : EpochFamily Epoch Site Env) : Type where
  | intra (env : Env) (e : Epoch) (m : F.Mode e) (d : F.Dist e m)
  | upgrade (e' : Epoch) (p' : Σ m, F.S e' m)

/-- Steps of the epoch process. -/
inductive EpochStep (F : EpochFamily Epoch Site Env) (AllowUpgrade : Epoch → Epoch → Prop)
    (anchored : Bool) : F.State → EpochAct F → F.State → Prop where
  | intra (x : Site → Nat) (e : Epoch) (m : F.Mode e) (s : F.S e m) (env : Env) (d : F.Dist e m)
      (adm : F.jointAdm e env) (tol : ∀ ob, (F.c e).tol m ob d) :
      EpochStep F AllowUpgrade anchored (x, ⟨e, ⟨m, s⟩⟩) (.intra env e m d)
        ((polyClosedStep (F.C e) (F.route e) (F.obs e) (F.channel e) F.G F.envDraw
            (x, ⟨m, s⟩) (env, d)).1,
         ⟨e, (polyClosedStep (F.C e) (F.route e) (F.obs e) (F.channel e) F.G F.envDraw
            (x, ⟨m, s⟩) (env, d)).2⟩)
  | upgrade (x : Site → Nat) (e : Epoch) (p : Σ m, F.S e m) (e' : Epoch) (p' : Σ m, F.S e' m)
      (gate : EpochHandoffGate F AllowUpgrade anchored x e e' p') :
      EpochStep F AllowUpgrade anchored (x, ⟨e, p⟩) (.upgrade e' p') (x, ⟨e', p'⟩)

/-- The epoch process; `anchored = false` drops only the gate's anchor clause. -/
def epochProcess (F : EpochFamily Epoch Site Env) (AllowUpgrade : Epoch → Epoch → Prop)
    (anchored : Bool) : Process F.State (EpochAct F) where
  step := EpochStep F AllowUpgrade anchored

/-- The anchored epoch process. -/
abbrev epochClosedProcess (F : EpochFamily Epoch Site Env) (AllowUpgrade : Epoch → Epoch → Prop) :=
  epochProcess F AllowUpgrade true

/-- The current epoch's guard: its floor and the runtime guard of its contract. -/
def epochCurrentGuard (F : EpochFamily Epoch Site Env) (st : F.State) : Prop :=
  polyClosedGuard (F.C st.2.1) (F.c st.2.1) (F.crit st.2.1) (st.1, st.2.2)

/-- The guard across epochs: the original floor `effCrit e₀` and the current guard. -/
def epochClosedGuard (F : EpochFamily Epoch Site Env) (e₀ : Epoch) (st : F.State) : Prop :=
  (∀ site, F.crit e₀ site ≤ st.1 site) ∧ epochCurrentGuard F st

/-- Invariant: the current epoch is certified, the state lies in its `K`, with lag margin. -/
def epochInv (F : EpochFamily Epoch Site Env) (st : F.State) : Prop :=
  F.Cert st.2.1 ∧ (F.c st.2.1).K st.2.2 ∧ F.Headroom st.2.1 st.2.2 st.1

/-- **Certificate of the current-floor guard**, with or without the anchor clause. -/
theorem epochInv_certificate (F : EpochFamily Epoch Site Env)
    (AllowUpgrade : Epoch → Epoch → Prop) (anchored : Bool)
    (G_rises : ∀ site, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (F.G site)) :
    Viability.Certificate (epochProcess F AllowUpgrade anchored) (epochCurrentGuard F)
      (epochInv F) := by
  refine ⟨?_, ?_⟩
  · intro st hInv
    obtain ⟨x, ⟨e, p⟩⟩ := st
    obtain ⟨_, hK, hMargin⟩ := hInv
    exact ⟨effCrit_le_of_margin hMargin, (F.c e).cert.within p hK⟩
  · intro st act st' hstep hInv
    cases hstep with
    | upgrade x e p e' p' gate => exact ⟨gate.cert, gate.in_K, gate.headroom⟩
    | intra x e m s env d envOk tolOk =>
      obtain ⟨hCert, hK, hMargin⟩ := hInv
      let o := F.obs e m x
      let al := F.channel e ((F.C e).emitAlarm m s o) ((F.C e).silenceLoad ⟨m, s⟩) env
      let H := fun site => polySiteDraw (F.C e) (F.route e) ⟨m, s⟩ site + F.envDraw env site
      let p' := (F.C e).next ⟨m, s⟩ (o, al) d
      have wS := (F.c e).cert.within ⟨m, s⟩ hK
      have hK' : (F.c e).K p' :=
        (F.c e).cert.closed ⟨m, s⟩ ⟨m, ((o, al), d)⟩ p' ⟨rfl, tolOk (o, al), rfl⟩ hK
      have H_le_pre : ∀ site, F.scope e site = true →
          H site ≤ F.sitePreCap e site + F.envCap e site := fun site hs =>
        Nat.add_le_add
          (Nat.le_trans (sumPortDraws_le fun k _ => wS.2.1 k) (hCert.pre_cap_bound m s site hK hs))
          (hCert.env_within env envOk site)
      refine ⟨hCert, hK', fun site hs => ?_⟩
      refine scoped_substrate_margin_step G_rises (F.scope e) H_le_pre
        (Nat.le_trans ((F.c e).eta_bound p' hK') (hCert.lag_bound p'.1 p'.2 hK'))
        hCert.post_viable hCert.warn_margin hMargin site hs ?_
      intro below
      have hWarn : (F.c e).warnObs m o := hCert.obs_detects m s x site hK hs below
      have hEmit : (F.C e).emitAlarm m s o = true := (F.c e).emits_on_warn m s o hK hWarn
      have hLoad : (F.C e).silenceLoad ⟨m, s⟩ ≤ F.maxSilenceEnv e :=
        Nat.le_trans wS.2.2.1 (hCert.silence_bound m s hK)
      have alTrue : al = true := by
        show F.channel e ((F.C e).emitAlarm m s o) ((F.C e).silenceLoad ⟨m, s⟩) env = true
        rw [hEmit]
        exact hCert.channel_fires ((F.C e).silenceLoad ⟨m, s⟩) env envOk hLoad
      refine ⟨fun h0 => ?_, fun pos => ?_⟩
      · have hEta0' : (F.c e).eta p' = 0 := by
          show (F.c e).eta ((F.C e).next ⟨m, s⟩ (o, al) d) = 0
          rw [alTrue]
          exact (F.c e).eta_alarm_zero m s o d (tolOk (o, true)) hK h0
        exact ⟨hEta0', fun k =>
          Nat.le_trans
            (Nat.add_le_add
              (Nat.le_trans (sumPortDraws_le fun pk _ => (wS.2.2.2 h0).2.2 pk)
                (hCert.post_cap_bound m s k hK))
              (hCert.env_within env envOk k))
            (hCert.post_allowance k)⟩
      · show (F.c e).eta ((F.C e).next ⟨m, s⟩ (o, al) d) + 1 ≤ (F.c e).eta ⟨m, s⟩
        rw [alTrue]
        exact (F.c e).eta_alarm_step m s o d (tolOk (o, true)) hK pos

/-- **Anchored certificate.** With the anchor clause, the invariant also keeps
`AnchorStep e₀ e`, and so the original floor. -/
theorem epochChain_certificate (F : EpochFamily Epoch Site Env)
    (AllowUpgrade : Epoch → Epoch → Prop) (e₀ : Epoch)
    (G_rises : ∀ site, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (F.G site)) :
    Viability.Certificate (epochClosedProcess F AllowUpgrade) (epochClosedGuard F e₀)
      (fun st => epochInv F st ∧ F.AnchorStep e₀ st.2.1) := by
  have core := epochInv_certificate F AllowUpgrade true G_rises
  refine ⟨fun st ⟨hInv, hAnch⟩ => ?_, fun st act st' hstep ⟨hInv, hAnch⟩ => ?_⟩
  · have hCur := core.within st hInv
    exact ⟨fun site => Nat.le_trans (hAnch.crit_le site) (hCur.1 site), hCur⟩
  · refine ⟨core.closed st act st' hstep hInv, ?_⟩
    cases hstep with
    | intra => exact hAnch
    | upgrade x e p e' p' gate => exact EpochFamily.AnchorStep.trans hAnch (gate.anchor rfl)

/-- **Epoch-chain viability (`_on_K`).** From a certified epoch `e₀`, a state `p₀` in its `K` and
lag margin at `x₀`, no run of the anchored process leaves the original floor, the current floor
or the current runtime guard, through any upgrades `AllowUpgrade` permits, in any order. -/
theorem epochChain_viability_kernel_on_K (F : EpochFamily Epoch Site Env)
    (AllowUpgrade : Epoch → Epoch → Prop) (e₀ : Epoch) (p₀ : Σ m, F.S e₀ m) (x₀ : Site → Nat)
    (G_rises : ∀ site, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (F.G site))
    (cert₀ : F.Cert e₀) (in_K₀ : (F.c e₀).K p₀) (margin₀ : F.Headroom e₀ p₀ x₀) :
    Viability.Kernel (epochClosedProcess F AllowUpgrade) (epochClosedGuard F e₀) (x₀, ⟨e₀, p₀⟩) :=
  (epochChain_certificate F AllowUpgrade e₀ G_rises).kernel
    ⟨⟨cert₀, in_K₀, margin₀⟩, EpochFamily.AnchorStep.refl F e₀⟩

/-- **Epoch-chain viability** from the initial state of `e₀`. -/
theorem epochChain_viability_kernel (F : EpochFamily Epoch Site Env)
    (AllowUpgrade : Epoch → Epoch → Prop) (e₀ : Epoch) (x₀ : Site → Nat)
    (G_rises : ∀ site, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (F.G site))
    (cert₀ : F.Cert e₀) (margin₀ : F.Headroom e₀ (F.init e₀) x₀) :
    Viability.Kernel (epochClosedProcess F AllowUpgrade) (epochClosedGuard F e₀)
      (x₀, ⟨e₀, F.init e₀⟩) :=
  epochChain_viability_kernel_on_K F AllowUpgrade e₀ (F.init e₀) x₀ G_rises cert₀
    (F.c e₀).init_in margin₀

/-- **The anchor is never weakened.** Every state the anchored process reaches is in an epoch
related to `e₀` by `AnchorStep`: scope, floors, environment bound and admissible environments of
`e₀` are all kept. -/
theorem epochChain_anchor_never_weakened (F : EpochFamily Epoch Site Env)
    (AllowUpgrade : Epoch → Epoch → Prop) (e₀ : Epoch) (p₀ : Σ m, F.S e₀ m) (x₀ : Site → Nat)
    (G_rises : ∀ site, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (F.G site))
    (cert₀ : F.Cert e₀) (in_K₀ : (F.c e₀).K p₀) (margin₀ : F.Headroom e₀ p₀ x₀)
    (st : F.State) (reach : Reach (epochClosedProcess F AllowUpgrade) (x₀, ⟨e₀, p₀⟩) st) :
    F.AnchorStep e₀ st.2.1 :=
  ((epochChain_certificate F AllowUpgrade e₀ G_rises).closed.reach reach
    ⟨⟨cert₀, in_K₀, margin₀⟩, EpochFamily.AnchorStep.refl F e₀⟩).2

/-- **No deadlock.** From a total epoch `e₀` and `p₀` in its `K`, every reachable state has a
successor (with or without the anchor clause): the gate admits only total epochs. -/
theorem epochChain_nonDeadlock (F : EpochFamily Epoch Site Env)
    (AllowUpgrade : Epoch → Epoch → Prop) (anchored : Bool) (e₀ : Epoch) (p₀ : Σ m, F.S e₀ m)
    (x₀ : Site → Nat) (total₀ : F.Total e₀) (in_K₀ : (F.c e₀).K p₀) (st : F.State)
    (reach : Reach (epochProcess F AllowUpgrade anchored) (x₀, ⟨e₀, p₀⟩) st) :
    ∃ a st', (epochProcess F AllowUpgrade anchored).step st a st' := by
  have inv : Invariant (epochProcess F AllowUpgrade anchored)
      (fun st : F.State => (F.c st.2.1).K st.2.2 ∧ F.Total st.2.1) := by
    intro st act st' hstep ⟨hK, hT⟩
    cases hstep with
    | upgrade x e p e' p' gate => exact ⟨gate.in_K, gate.total⟩
    | intra x e m s env d _ tolOk =>
      exact ⟨(F.c e).cert.closed ⟨m, s⟩ ⟨m, ((F.obs e m x, _), d)⟩ _ ⟨rfl, tolOk _, rfl⟩ hK, hT⟩
  obtain ⟨hK, hT⟩ := inv.reach reach ⟨in_K₀, total₀⟩
  obtain ⟨x, ⟨e, ⟨m, s⟩⟩⟩ := st
  obtain ⟨env, hAdm⟩ := hT.env_nonempty
  obtain ⟨d, hd⟩ := hT.dist_total ⟨m, s⟩ hK
  exact ⟨_, _, EpochStep.intra x e m s env d hAdm hd⟩

/-- **Infeasible entry is refused.** No upgrade to `e'` is a step where the reserve at some site
in scope of `e'` is already below that site's floor in `e'`. -/
theorem gate_rejects_infeasible_entry (F : EpochFamily Epoch Site Env)
    (AllowUpgrade : Epoch → Epoch → Prop) (anchored : Bool) {x : Site → Nat} {e e' : Epoch}
    {p : Σ m, F.S e m} {p' : Σ m, F.S e' m} {st' : F.State} {site : Site}
    (inScope : F.scope e' site = true) (below : x site < F.x_crit e' site) :
    ¬ (epochProcess F AllowUpgrade anchored).step (x, ⟨e, p⟩) (.upgrade e' p') st' := by
  intro hstep
  cases hstep with
  | upgrade _ _ _ _ _ gate =>
    exact Nat.not_le_of_gt below
      (Nat.le_trans (Nat.le_add_right _ _) (gate.headroom site inScope))

/-! ## Part 3: Exact single-epoch reductions and separations -/

/-- One epoch, every site in scope. -/
def unitEpochFamily {Mode : Type} {S Obs Dist Int Ext : Mode → Type}
    (C : PolyComponent Mode S Obs Dist Int Ext) (route : (m : Mode) → Site → List (Ext m))
    {init : Σ m, S m} (c : PolyContract C init) (obs : (m : Mode) → (Site → Nat) → Obs m)
    (channel : Bool → Nat → Env → Bool) (G : Site → (Site → Nat) → Nat)
    (envDraw : Env → Site → Nat) (envCap : Site → Nat) (jointAdm : Env → Prop)
    (x_crit warnLevel H_safe sitePreCap sitePostCap : Site → Nat)
    (maxLagEnv maxSilenceEnv : Nat) : EpochFamily Unit Site Env where
  Mode _ := Mode
  S _ := S
  Obs _ := Obs
  Dist _ := Dist
  Int _ := Int
  Ext _ := Ext
  C _ := C
  init _ := init
  c _ := c
  route _ := route
  obs _ := obs
  channel _ := channel
  G := G
  envDraw := envDraw
  envCap _ := envCap
  jointAdm _ := jointAdm
  scope _ _ := true
  x_crit _ := x_crit
  warnLevel _ := warnLevel
  H_safe _ := H_safe
  sitePreCap _ := sitePreCap
  sitePostCap _ := sitePostCap
  maxLagEnv _ := maxLagEnv
  maxSilenceEnv _ := maxSilenceEnv

/-- Every run of `polyClosedProcess` is a run of the one-epoch process, for any upgrade relation
and either gate. -/
theorem reach_polyClosed_to_unitEpoch {Mode : Type} {S Obs Dist Int Ext : Mode → Type}
    (C : PolyComponent Mode S Obs Dist Int Ext) (route : (m : Mode) → Site → List (Ext m))
    {init : Σ m, S m} (c : PolyContract C init) (obs : (m : Mode) → (Site → Nat) → Obs m)
    (channel : Bool → Nat → Env → Bool) (G : Site → (Site → Nat) → Nat)
    (envDraw : Env → Site → Nat) (envCap : Site → Nat) (jointAdm : Env → Prop)
    (x_crit warnLevel H_safe sitePreCap sitePostCap : Site → Nat)
    (maxLagEnv maxSilenceEnv : Nat) (AllowUpgrade : Unit → Unit → Prop) (anchored : Bool)
    {s₀ s₁ : (Site → Nat) × (Σ m, S m)}
    (hreach : Reach (polyClosedProcess C route c obs channel G envDraw jointAdm) s₀ s₁) :
    Reach (epochProcess (unitEpochFamily C route c obs channel G envDraw envCap jointAdm
        x_crit warnLevel H_safe sitePreCap sitePostCap maxLagEnv maxSilenceEnv)
        AllowUpgrade anchored)
      (s₀.1, ⟨(), s₀.2⟩) (s₁.1, ⟨(), s₁.2⟩) := by
  obtain ⟨as, htr⟩ := hreach
  induction htr with
  | nil s => exact Reach.refl _ _
  | @cons st mid _ act _ hst _ ih =>
    have one : ∃ a, (epochProcess (unitEpochFamily C route c obs channel G envDraw envCap jointAdm
        x_crit warnLevel H_safe sitePreCap sitePostCap maxLagEnv maxSilenceEnv)
        AllowUpgrade anchored).step (st.1, ⟨(), st.2⟩) a (mid.1, ⟨(), mid.2⟩) := by
      obtain ⟨x, ⟨m, s⟩⟩ := st
      obtain ⟨env, ⟨m', d⟩⟩ := act
      obtain ⟨hm, hAdm, hTol, heq⟩ := hst
      cases hm
      subst heq
      exact ⟨_, EpochStep.intra (F := unitEpochFamily C route c obs channel G envDraw envCap
        jointAdm x_crit warnLevel H_safe sitePreCap sitePostCap maxLagEnv maxSilenceEnv)
        (AllowUpgrade := AllowUpgrade) (anchored := anchored) x () m s env d hAdm hTol⟩
    obtain ⟨_, h⟩ := one
    exact Reach.trans (Reach.of_step h) ih

/-- **Exact reduction 1.** The conclusion of `PolyComposition.anchored_selfMod_viable`, from
exactly its hypotheses, proved through `epochChain_viability_kernel` (one epoch, no upgrade). -/
theorem singleEpoch_recovers_anchored_selfMod
    {Mode : Type} {S Obs Dist Int Ext : Mode → Type}
    (base : AnchoredBase Mode S Obs Dist Int Ext)
    {init : Σ m, S m} (hInit : AnchoredInit base init)
    (admitDec : (p cand : Σ m, S m) → Bool → Bool)
    (fallback : (p : Σ m, S m) → Obs p.1 × Bool → Dist p.1 → Σ m', S m')
    (hAdmit : AnchoredModeAdmit base admitDec fallback)
    (propose : (p : Σ m, S m) → Obs p.1 × Bool → Dist p.1 → Σ m', S m')
    (route : (m : Mode) → Site → List (Ext m))
    (obs : (m : Mode) → (Site → Nat) → Obs m)
    (channel : Bool → Nat → Env → Bool)
    (G : Site → (Site → Nat) → Nat)
    (envDraw : Env → Site → Nat) (envCap : Site → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ site, envDraw env site ≤ envCap site)
    (sitePreCap sitePostCap : Site → Nat)
    (maxLagEnv maxSilenceEnv : Nat)
    (pre_cap_bound : ∀ m site, sumPortDraws (route m site) (base.preCapExt m) ≤ sitePreCap site)
    (post_cap_bound : ∀ m site, sumPortDraws (route m site) (base.postAllowanceExt m) ≤ sitePostCap site)
    (lag_bound : ∀ m, base.maxLag m ≤ maxLagEnv)
    (silence_bound : ∀ m, base.maxSilence m ≤ maxSilenceEnv)
    (x_crit warnLevel H_safe x₀ : Site → Nat)
    (obs_detects : ∀ m s x site, base.K ⟨m, s⟩ →
      x site < warnLevel site → base.warnObs m (obs m x))
    (channel_fires : ∀ load env, jointAdm env → load ≤ maxSilenceEnv →
      channel true load env = true)
    (G_rises : ∀ site, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G site))
    (post_viable : ∀ site, x_crit site ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit site)
    (post_allowance : ∀ site, sitePostCap site + envCap site ≤ H_safe site)
    (warn_margin : ∀ site, x_crit site + (maxLagEnv + 1) * (sitePreCap site + envCap site) ≤ warnLevel site)
    (init_margin : ∀ site, x_crit site + base.eta init * (sitePreCap site + envCap site) ≤ x₀ site) :
    Viability.Kernel
      (polyClosedProcess (anchoredSelfModComponent base admitDec fallback propose) route
        (anchoredSelfModContract base hInit admitDec fallback hAdmit propose)
        obs channel G envDraw jointAdm)
      (polyClosedGuard (anchoredSelfModComponent base admitDec fallback propose)
        (anchoredSelfModContract base hInit admitDec fallback hAdmit propose) x_crit)
      (x₀, init) := by
  let C := anchoredSelfModComponent base admitDec fallback propose
  let c := anchoredSelfModContract base hInit admitDec fallback hAdmit propose
  let F := unitEpochFamily C route c obs channel G envDraw envCap jointAdm
    x_crit warnLevel H_safe sitePreCap sitePostCap maxLagEnv maxSilenceEnv
  have cert : F.Cert () :=
    { env_within := env_within
      pre_cap_bound := fun m _ site _ _ => pre_cap_bound m site
      post_cap_bound := fun m _ site _ => post_cap_bound m site
      lag_bound := fun m _ _ => lag_bound m
      silence_bound := fun m _ _ => silence_bound m
      obs_detects := fun m s x site hK _ hlt => obs_detects m s x site hK hlt
      channel_fires := channel_fires
      post_viable := post_viable
      post_allowance := post_allowance
      warn_margin := fun site _ => warn_margin site }
  have kern := epochChain_viability_kernel F (fun _ _ => False) () x₀ G_rises cert
    (fun site _ => init_margin site)
  exact fun st hreach => (kern _ (reach_polyClosed_to_unitEpoch C route c obs channel G envDraw
    envCap jointAdm x_crit warnLevel H_safe sitePreCap sitePostCap maxLagEnv maxSilenceEnv
    (fun _ _ => False) true hreach)).2

/-- **Exact reduction 2.** The conclusion of `PolyComposition.monotone_selfWidening_viable`, from
exactly its hypotheses, proved through `epochChain_viability_kernel`. -/
theorem singleEpoch_recovers_monotone_selfWidening
    {Mode : Type} {S Obs Dist Int Ext : Mode → Type}
    (base : AnchoredBase Mode S Obs Dist Int Ext)
    {init : Σ m, S m} (hInit : AnchoredInit base init)
    (admitDec : (p cand : Σ m, S m) → Bool → Bool)
    (fallback : (p : Σ m, S m) → Obs p.1 × Bool → Dist p.1 → Σ m', S m')
    (hAdmit : AnchoredModeAdmit base admitDec fallback)
    (propose : (p : Σ m, S m) → Obs p.1 × Bool → Dist p.1 → Σ m', S m')
    (route : (m : Mode) → Site → List (Ext m))
    (obs : (m : Mode) → (Site → Nat) → Obs m)
    (channel : Bool → Nat → Env → Bool)
    (G : Site → (Site → Nat) → Nat)
    (envDraw : Env → Site → Nat) (envCap : Site → Nat) (jointAdm : Env → Prop)
    (env_within : ∀ env, jointAdm env → ∀ site, envDraw env site ≤ envCap site)
    (sitePreCap sitePostCap : Site → Nat)
    (maxLagEnv maxSilenceEnv : Nat)
    (x_crit warnLevel H_safe x₀ : Site → Nat)
    (init_pre : ∀ site, sumPortDraws (route init.1 site) (base.preCapExt init.1) ≤ sitePreCap site)
    (init_post : ∀ site, sumPortDraws (route init.1 site) (base.postAllowanceExt init.1) ≤ sitePostCap site)
    (init_lag : base.maxLag init.1 ≤ maxLagEnv)
    (init_silence : base.maxSilence init.1 ≤ maxSilenceEnv)
    (init_obs_detects : ∀ x site, x site < warnLevel site → base.warnObs init.1 (obs init.1 x))
    (refines_on_K : ∀ m s, base.K ⟨m, s⟩ → ModeRefines base route obs warnLevel init.1 m)
    (channel_fires : ∀ load env, jointAdm env → load ≤ maxSilenceEnv →
      channel true load env = true)
    (G_rises : ∀ site, RegimeMargin.Coupled.Indexed.Rises RegimeMargin.Drawn.whole (G site))
    (post_viable : ∀ site, x_crit site ≤
      RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole G H_safe x_crit site)
    (post_allowance : ∀ site, sitePostCap site + envCap site ≤ H_safe site)
    (warn_margin : ∀ site, x_crit site + (maxLagEnv + 1) * (sitePreCap site + envCap site) ≤ warnLevel site)
    (init_margin : ∀ site, x_crit site + base.eta init * (sitePreCap site + envCap site) ≤ x₀ site) :
    Viability.Kernel
      (polyClosedProcess (anchoredSelfModComponent base admitDec fallback propose) route
        (anchoredSelfModContract base hInit admitDec fallback hAdmit propose)
        obs channel G envDraw jointAdm)
      (polyClosedGuard (anchoredSelfModComponent base admitDec fallback propose)
        (anchoredSelfModContract base hInit admitDec fallback hAdmit propose) x_crit)
      (x₀, init) := by
  let C := anchoredSelfModComponent base admitDec fallback propose
  let c := anchoredSelfModContract base hInit admitDec fallback hAdmit propose
  let F := unitEpochFamily C route c obs channel G envDraw envCap jointAdm
    x_crit warnLevel H_safe sitePreCap sitePostCap maxLagEnv maxSilenceEnv
  have cert : F.Cert () :=
    { env_within := env_within
      pre_cap_bound := fun m s site hK _ =>
        Nat.le_trans ((refines_on_K m s hK).pre_le site) (init_pre site)
      post_cap_bound := fun m s site hK =>
        Nat.le_trans ((refines_on_K m s hK).post_le site) (init_post site)
      lag_bound := fun m s hK => Nat.le_trans (refines_on_K m s hK).lag_le init_lag
      silence_bound := fun m s hK => Nat.le_trans (refines_on_K m s hK).silence_le init_silence
      obs_detects := fun m s x site hK _ hlt =>
        (refines_on_K m s hK).warn_widened x site hlt (init_obs_detects x site hlt)
      channel_fires := channel_fires
      post_viable := post_viable
      post_allowance := post_allowance
      warn_margin := fun site _ => warn_margin site }
  have kern := epochChain_viability_kernel F (fun _ _ => False) () x₀ G_rises cert
    (fun site _ => init_margin site)
  exact fun st hreach => (kern _ (reach_polyClosed_to_unitEpoch C route c obs channel G envDraw
    envCap jointAdm x_crit warnLevel H_safe sitePreCap sitePostCap maxLagEnv maxSilenceEnv
    (fun _ _ => False) true hreach)).2

/-! ### A one-mode agent with a lag bit, used by the witnesses -/

/-- One-mode agent: lag bit `p.2 ≤ 1`; draws `pre` while the bit is up and `post` after an alarm
has cleared it. -/
def lagAgent {Ext : Type} (pre post : Ext → Nat) :
    PolyComponent Unit (fun _ => Nat) (fun _ => Bool) (fun _ => Unit) (fun _ => Empty)
      (fun _ => Ext) where
  next p oa _ := ⟨(), if oa.2 then 0 else p.2⟩
  drawInt _ j := Empty.elim j
  drawExt p k := match p.2 with
    | 0 => post k
    | _ + 1 => pre k
  emitAlarm _ _ o := o
  silenceLoad _ := 0
  favours p := 0 < p.2

/-- Its contract: tolerates everything, warns on a raised sensor bit, lag at most `1`. -/
def lagContract {Ext : Type} (pre post : Ext → Nat) (post_le : ∀ k, post k ≤ pre k) :
    PolyContract (lagAgent pre post) ⟨(), 1⟩ where
  tol _ _ _ := True
  warnObs _ o := o = true
  preCapInt _ j := Empty.elim j
  preCapExt _ := pre
  postAllowanceInt _ j := Empty.elim j
  postAllowanceExt _ := post
  maxSilence _ := 0
  maxLag _ := 1
  K p := p.2 ≤ 1
  eta p := p.2
  init_in := Nat.le_refl 1
  cert :=
    ⟨fun p _ => by
       obtain ⟨u, n⟩ := p
       cases n with
       | zero =>
         exact ⟨fun j => Empty.elim j, fun k => post_le k, Nat.le_refl 0,
           fun _ => ⟨Nat.lt_irrefl 0, fun j => Empty.elim j, fun k => Nat.le_refl (post k)⟩⟩
       | succ n =>
         exact ⟨fun j => Empty.elim j, fun k => Nat.le_refl (pre k), Nat.le_refl 0,
           fun h0 => absurd h0 (Naturals.succ_ne_zero n)⟩,
     fun p a p' hstep hK => by
       obtain ⟨m', ⟨o, al⟩, d⟩ := a
       obtain ⟨hm, _, heq⟩ := hstep
       cases hm
       subst heq
       cases al with
       | false => exact hK
       | true => exact Nat.zero_le 1⟩
  eta_bound _ hK := hK
  emits_on_warn _ _ _ _ hw := hw
  eta_alarm_step _ _ _ _ _ _ pos := pos
  eta_alarm_zero _ _ _ _ _ _ _ := rfl

/-- Recovery at floor `3` with draw `1` after an alarm, at one self-supporting site. -/
theorem recovers_three : 3 ≤ RegimeMargin.Coupled.Indexed.step RegimeMargin.Drawn.whole selfGain
    (fun _ : Unit => 1) (fun _ => 3) () := by decide

/-! ### Separation from `anchored_selfMod_viable`: a blind first sensor -/

namespace BlindSensorUpgradeWitness

def pre : Bool → Nat
  | false => 1
  | true => 4

def warn : Bool → Nat
  | false => 7
  | true => 13

/-- Epoch `false` reads the reserve only below `7`; epoch `true` installs a sensor reading below `13`. -/
def sensor (e : Bool) (_ : Unit) (x : Unit → Nat) : Bool := Nat.blt (x ()) (warn e)

def family : EpochFamily Bool Unit Unit where
  Mode _ := Unit
  S _ _ := Nat
  Obs _ _ := Bool
  Dist _ _ := Unit
  Int _ _ := Empty
  Ext _ _ := Unit
  C e := lagAgent (fun _ => pre e) (fun _ => 0)
  init _ := ⟨(), 1⟩
  c e := lagContract (fun _ => pre e) (fun _ => 0) (fun _ => Nat.zero_le _)
  route _ _ _ := [()]
  obs := sensor
  channel _ em _ _ := em
  G := selfGain
  envDraw _ _ := 0
  envCap _ _ := 0
  jointAdm _ _ := True
  scope _ _ := true
  x_crit _ _ := 3
  warnLevel e _ := warn e
  H_safe _ _ := 1
  sitePreCap e _ := pre e
  sitePostCap _ _ := 0
  maxLagEnv _ := 1
  maxSilenceEnv _ := 0

theorem cert (e : Bool) : family.Cert e where
  env_within _ _ _ := Nat.le_refl 0
  pre_cap_bound _ _ _ _ _ := Nat.le_refl _
  post_cap_bound _ _ _ _ := Nat.le_refl 0
  lag_bound _ _ _ := Nat.le_refl 1
  silence_bound _ _ _ := Nat.le_refl 0
  obs_detects _ _ _ _ _ _ hlt := CoreHelpers.natBlt_true_iff.mpr hlt
  channel_fires _ _ _ _ := rfl
  post_viable := fun () => recovers_three
  post_allowance _ := Nat.zero_le 1
  warn_margin := fun () _ => by cases e <;> decide

theorem total (e : Bool) : family.Total e :=
  ⟨⟨(), trivial⟩, fun _ _ => ⟨(), fun _ => trivial⟩⟩

/-- The same two modes as one static base for `anchored_selfMod_viable`. -/
def base : AnchoredBase Bool (fun _ => Nat) (fun _ => Bool) (fun _ => Unit) (fun _ => Empty)
    (fun _ => Unit) where
  drawInt _ j := Empty.elim j
  drawExt p _ := match p.2 with
    | 0 => 0
    | _ + 1 => pre p.1
  emitAlarm _ _ o := o
  silenceLoad _ := 0
  favours p := 0 < p.2
  tol _ _ _ := True
  warnObs _ o := o = true
  preCapInt _ j := Empty.elim j
  preCapExt m _ := pre m
  postAllowanceInt _ j := Empty.elim j
  postAllowanceExt _ _ := 0
  maxSilence _ := 0
  maxLag _ := 1
  K p := p.2 ≤ 1
  eta p := p.2
  within p _ := by
    obtain ⟨m, n⟩ := p
    cases n with
    | zero =>
      exact ⟨fun j => Empty.elim j, fun _ => Nat.zero_le _, Nat.le_refl 0,
        fun _ => ⟨Nat.lt_irrefl 0, fun j => Empty.elim j, fun _ => Nat.le_refl 0⟩⟩
    | succ n =>
      exact ⟨fun j => Empty.elim j, fun _ => Nat.le_refl _, Nat.le_refl 0,
        fun h0 => absurd h0 (Naturals.succ_ne_zero n)⟩
  eta_bound _ hK := hK
  emits_on_warn _ _ _ _ hw := hw

/-- The upgrade is not a `ModeRefines` step, for any warning level. -/
theorem not_modeRefines (warnLevel : Unit → Nat) :
    ¬ ModeRefines base (fun _ _ => [()]) (fun m x => sensor m () x) warnLevel false true :=
  fun href => absurd (href.pre_le ()) (by decide)

/-- **No static envelope.** No floor, environment bound, draw envelope, warning level and lag
bound satisfy `anchored_selfMod_viable`'s `pre_cap_bound`, `lag_bound`, `warn_margin` and
`obs_detects` for this base: the second mode needs a warning level of at least `8`, which the
first mode's sensor cannot read. -/
theorem no_static_anchoredSelfMod_envelope (x_crit envCap sitePreCap warnLevel : Unit → Nat)
    (maxLagEnv : Nat)
    (pre_cap_bound : ∀ m site, sumPortDraws [()] (base.preCapExt m) ≤ sitePreCap site)
    (lag_bound : ∀ m, base.maxLag m ≤ maxLagEnv)
    (warn_margin : ∀ site, x_crit site + (maxLagEnv + 1) * (sitePreCap site + envCap site) ≤
      warnLevel site)
    (obs_detects : ∀ m s x site, base.K ⟨m, s⟩ → x site < warnLevel site →
      base.warnObs m (sensor m () x)) : False := by
  have hPre : 4 ≤ sitePreCap () := pre_cap_bound true ()
  have hLag : 1 ≤ maxLagEnv := lag_bound false
  have hMul : (1 + 1) * (4 + 0) ≤ (maxLagEnv + 1) * (sitePreCap () + envCap ()) :=
    Nat.mul_le_mul (Nat.add_le_add_right hLag 1) (Nat.add_le_add hPre (Nat.zero_le _))
  have hWarn : 8 ≤ warnLevel () :=
    Nat.le_trans hMul (Nat.le_trans (Nat.le_add_left _ _) (warn_margin ()))
  have blind : sensor false () (fun _ => 7) = true :=
    obs_detects false 1 (fun _ => 7) () (Nat.le_refl 1) (Nat.lt_of_lt_of_le (by decide) hWarn)
  exact absurd blind (by decide)

/-- The epoch chain certifies both: from reserve `13` in epoch `false` no run leaves the floor,
and the upgrade to the new sensor and draw `4` is a step. -/
theorem epochChain_certifies_upgrade :
    Viability.Kernel (epochClosedProcess family (fun e e' => e = false ∧ e' = true))
      (epochClosedGuard family false) (fun _ => 13, ⟨false, ⟨(), (1 : Nat)⟩⟩) ∧
    (epochClosedProcess family (fun e e' => e = false ∧ e' = true)).step
      (fun _ => 13, ⟨false, ⟨(), (1 : Nat)⟩⟩) (.upgrade true ⟨(), (1 : Nat)⟩) (fun _ => 13, ⟨true, ⟨(), (1 : Nat)⟩⟩) :=
  ⟨epochChain_viability_kernel family _ false (fun _ => 13) selfGain_rises (cert false)
     (fun () _ => by decide),
   EpochStep.upgrade _ false _ true _
     { allow := ⟨rfl, rfl⟩
       anchor := fun _ => ⟨fun _ h => ⟨h, Nat.le_refl 3⟩, fun _ => Nat.le_refl 0, fun _ h => h⟩
       cert := cert true
       total := total true
       in_K := Nat.le_refl 1
       headroom := fun () _ => by decide }⟩

end BlindSensorUpgradeWitness

/-! ### Unbounded ascending (and descending) epochs -/

namespace UnboundedAscendingEpochsWitness

def warn (e : Nat) : Nat := 3 + 2 * (e + 1)

def family : EpochFamily Nat Unit Unit where
  Mode _ := Unit
  S _ _ := Nat
  Obs _ _ := Bool
  Dist _ _ := Unit
  Int _ _ := Empty
  Ext _ _ := Unit
  C e := lagAgent (fun _ => e + 1) (fun _ => 0)
  init _ := ⟨(), 1⟩
  c e := lagContract (fun _ => e + 1) (fun _ => 0) (fun _ => Nat.zero_le _)
  route _ _ _ := [()]
  obs e _ x := Nat.blt (x ()) (warn e)
  channel _ em _ _ := em
  G := selfGain
  envDraw _ _ := 0
  envCap _ _ := 0
  jointAdm _ _ := True
  scope _ _ := true
  x_crit _ _ := 3
  warnLevel e _ := warn e
  H_safe _ _ := 1
  sitePreCap e _ := e + 1
  sitePostCap _ _ := 0
  maxLagEnv _ := 1
  maxSilenceEnv _ := 0

/-- No finite bound covers the per-epoch draw. -/
theorem no_finite_draw_bound : ¬ ∃ B : Nat, ∀ e : Nat, family.sitePreCap e () ≤ B :=
  fun ⟨B, hB⟩ => Nat.not_succ_le_self B (hB B)

theorem cert (e : Nat) : family.Cert e where
  env_within _ _ _ := Nat.le_refl 0
  pre_cap_bound _ _ _ _ _ := Nat.le_refl (e + 1)
  post_cap_bound _ _ _ _ := Nat.le_refl 0
  lag_bound _ _ _ := Nat.le_refl 1
  silence_bound _ _ _ := Nat.le_refl 0
  obs_detects _ _ _ _ _ _ hlt := CoreHelpers.natBlt_true_iff.mpr hlt
  channel_fires _ _ _ _ := rfl
  post_viable := fun () => recovers_three
  post_allowance _ := Nat.zero_le 1
  warn_margin _ _ := Nat.le_refl _

theorem total (e : Nat) : family.Total e :=
  ⟨⟨(), trivial⟩, fun _ _ => ⟨(), fun _ => trivial⟩⟩

/-- Every epoch, entered with reserve `3 + (e + 1)`, keeps the floor `3` forever, with upgrades
in either direction allowed. -/
theorem epoch_viable_at_headroom (e : Nat) :
    Viability.Kernel (epochClosedProcess family (fun _ _ => True))
      (epochClosedGuard family e) (fun _ => 3 + (e + 1), ⟨e, ⟨(), (1 : Nat)⟩⟩) :=
  epochChain_viability_kernel family _ e _ selfGain_rises (cert e)
    (fun () _ => Nat.le_of_eq (congrArg (3 + ·) (Nat.one_mul (e + 1))))

/-- An upgrade up one epoch is a step wherever the reserve covers its margin. -/
theorem upgrade_up {e : Nat} {x : Unit → Nat} (hx : 3 + (e + 2) ≤ x ()) :
    (epochClosedProcess family (fun _ _ => True)).step (x, ⟨e, ⟨(), (1 : Nat)⟩⟩)
      (.upgrade (e + 1) ⟨(), (1 : Nat)⟩) (x, ⟨e + 1, ⟨(), (1 : Nat)⟩⟩) :=
  EpochStep.upgrade x e _ (e + 1) _
    { allow := trivial
      anchor := fun _ => ⟨fun _ h => ⟨h, Nat.le_refl 3⟩, fun _ => Nat.le_refl 0, fun _ h => h⟩
      cert := cert (e + 1)
      total := total (e + 1)
      in_K := Nat.le_refl 1
      headroom := fun () _ => Nat.le_trans (Nat.le_of_eq (congrArg (3 + ·) (Nat.one_mul (e + 2)))) hx }

/-- A downgrade to epoch `0` is a step too: the chain need not be monotone. -/
theorem upgrade_down {e : Nat} {x : Unit → Nat} (hx : 4 ≤ x ()) :
    (epochClosedProcess family (fun _ _ => True)).step (x, ⟨e, ⟨(), (1 : Nat)⟩⟩)
      (.upgrade 0 ⟨(), (1 : Nat)⟩) (x, ⟨0, ⟨(), (1 : Nat)⟩⟩) :=
  EpochStep.upgrade x e _ 0 _
    { allow := trivial
      anchor := fun _ => ⟨fun _ h => ⟨h, Nat.le_refl 3⟩, fun _ => Nat.le_refl 0, fun _ h => h⟩
      cert := cert 0
      total := total 0
      in_K := Nat.le_refl 1
      headroom := fun () _ => hx }

end UnboundedAscendingEpochsWitness

/-! ## Part 4: Scope entry (Horn 1b) and floor rewriting (Horn 2 on processes) -/

namespace SiteExpansionBlindnessWitness

inductive Site2 where
  | sOld | sNew

def scopeAt : Bool → Site2 → Bool
  | false, .sOld => true
  | false, .sNew => false
  | true, _ => true

def critAt : Bool → Site2 → Nat
  | _, .sOld => 3
  | false, .sNew => 0
  | true, .sNew => 2

def preAt : Bool → Site2 → Nat
  | _, .sOld => 1
  | false, .sNew => 6
  | true, .sNew => 1

def postAt : Bool → Site2 → Nat
  | _, .sOld => 1
  | false, .sNew => 6
  | true, .sNew => 0

def warnAt : Bool → Site2 → Nat
  | _, .sOld => 5
  | false, .sNew => 0
  | true, .sNew => 4

/-- Epoch `false` reads only `.sOld`; epoch `true` reads both. -/
def sensor : Bool → Unit → (Site2 → Nat) → Bool
  | false, _, x => Nat.blt (x .sOld) 5
  | true, _, x => Nat.blt (x .sOld) 5 || Nat.blt (x .sNew) 4

theorem post_le_pre : ∀ e s, postAt e s ≤ preAt e s
  | false, .sOld | true, .sOld | false, .sNew => Nat.le_refl _
  | true, .sNew => Nat.zero_le _

def family : EpochFamily Bool Site2 Unit where
  Mode _ := Unit
  S _ _ := Nat
  Obs _ _ := Bool
  Dist _ _ := Unit
  Int _ _ := Empty
  Ext _ _ := Site2
  C e := lagAgent (preAt e) (postAt e)
  init _ := ⟨(), 1⟩
  c e := lagContract (preAt e) (postAt e) (post_le_pre e)
  route _ _ s := [s]
  obs := sensor
  channel _ em _ _ := em
  G := selfGain
  envDraw _ _ := 0
  envCap _ _ := 0
  jointAdm _ _ := True
  scope := scopeAt
  x_crit := critAt
  warnLevel := warnAt
  H_safe := postAt
  sitePreCap := preAt
  sitePostCap := postAt
  maxLagEnv _ := 1
  maxSilenceEnv _ := 0

theorem cert : ∀ e : Bool, family.Cert e
  | false =>
    { env_within := fun _ _ _ => Nat.le_refl 0
      pre_cap_bound := fun _ _ _ _ _ => Nat.le_refl _
      post_cap_bound := fun _ _ _ _ => Nat.le_refl _
      lag_bound := fun _ _ _ => Nat.le_refl 1
      silence_bound := fun _ _ _ => Nat.le_refl 0
      obs_detects := fun _ _ x s _ hs hlt => by
        cases s with
        | sOld => exact CoreHelpers.natBlt_true_iff.mpr hlt
        | sNew => exact absurd hs (fun h => Bool.noConfusion h)
      channel_fires := fun _ _ _ _ => rfl
      post_viable := fun s => by cases s <;> decide
      post_allowance := fun _ => Nat.le_refl _
      warn_margin := fun s hs => by
        cases s with
        | sOld => decide
        | sNew => exact absurd hs (fun h => Bool.noConfusion h) }
  | true =>
    { env_within := fun _ _ _ => Nat.le_refl 0
      pre_cap_bound := fun _ _ _ _ _ => Nat.le_refl _
      post_cap_bound := fun _ _ _ _ => Nat.le_refl _
      lag_bound := fun _ _ _ => Nat.le_refl 1
      silence_bound := fun _ _ _ => Nat.le_refl 0
      obs_detects := fun _ _ x s _ _ hlt => by
        cases s with
        | sOld => exact bool_or_of_left _ (CoreHelpers.natBlt_true_iff.mpr hlt)
        | sNew => exact bool_or_of_right _ (CoreHelpers.natBlt_true_iff.mpr hlt)
      channel_fires := fun _ _ _ _ => rfl
      post_viable := fun s => by cases s <;> decide
      post_allowance := fun _ => Nat.le_refl _
      warn_margin := fun s _ => by cases s <;> decide }

theorem total (e : Bool) : family.Total e :=
  ⟨⟨(), trivial⟩, fun _ _ => ⟨(), fun _ => trivial⟩⟩

def xInit : Site2 → Nat
  | .sOld => 7
  | .sNew => 6

abbrev allow (e e' : Bool) : Prop := e = false ∧ e' = true

theorem margin_false : family.Headroom false ⟨(), (1 : Nat)⟩ xInit := fun s hs => by
  cases s with
  | sOld => decide
  | sNew => exact absurd hs (fun h => Bool.noConfusion h)

/-- **(i) Closed scope.** With only `.sOld` in scope, no run leaves the epoch-`false` guard, and one
certified step takes `.sNew` from `6` to `0`, below the floor `2` it is later given. -/
theorem closedScope_allows_sNew_collapse :
    Viability.Kernel (epochClosedProcess family allow) (epochClosedGuard family false)
      (xInit, ⟨false, ⟨(), (1 : Nat)⟩⟩) ∧
    ∃ st', (epochClosedProcess family allow).step (xInit, ⟨false, ⟨(), (1 : Nat)⟩⟩)
      (.intra () false () ()) st' ∧ st'.1 .sNew = 0 ∧ st'.1 .sNew < critAt true .sNew :=
  ⟨epochChain_viability_kernel family allow false xInit selfGain_rises (cert false) margin_false,
   _, EpochStep.intra (F := family) (AllowUpgrade := allow) (anchored := true) xInit false () (1 : Nat) () () trivial (fun _ => trivial), rfl, by decide⟩

/-- **(ii) Timely entry.** Entering `.sNew` at the start is a gated step, and from there no run
takes `.sOld` below `3` or `.sNew` below `2`. -/
theorem timelyOpenEntry_protects_both :
    (epochClosedProcess family allow).step (xInit, ⟨false, ⟨(), (1 : Nat)⟩⟩) (.upgrade true ⟨(), (1 : Nat)⟩)
      (xInit, ⟨true, ⟨(), (1 : Nat)⟩⟩) ∧
    ∀ st, Reach (epochClosedProcess family allow) (xInit, ⟨true, ⟨(), (1 : Nat)⟩⟩) st →
      3 ≤ st.1 .sOld ∧ 2 ≤ st.1 .sNew := by
  have anchor : family.AnchorStep false true :=
    ⟨fun s hs => by
       cases s with
       | sOld => exact ⟨rfl, Nat.le_refl 3⟩
       | sNew => exact absurd hs (fun h => Bool.noConfusion h),
     fun _ => Nat.le_refl 0, fun _ h => h⟩
  have margin_true : family.Headroom true ⟨(), (1 : Nat)⟩ xInit := fun s _ => by cases s <;> decide
  refine ⟨EpochStep.upgrade xInit false _ true _
    ⟨⟨rfl, rfl⟩, fun _ => anchor, cert true, total true, Nat.le_refl 1, margin_true⟩,
    fun st hreach => ?_⟩
  have g := epochChain_viability_kernel family allow true xInit selfGain_rises (cert true)
    margin_true st hreach
  exact ⟨g.1 .sOld, g.1 .sNew⟩

/-- **(iii) Late entry.** Once `.sNew` is below `2`, entering it is no step at all: the gate
refuses rather than repairs. -/
theorem lateOpenEntry_rejected {x : Site2 → Nat} (low : x .sNew < 2) (anchored : Bool)
    (p : Σ _ : Unit, Nat) (p' : Σ _ : Unit, Nat) (st' : family.State) :
    ¬ (epochProcess family allow anchored).step (x, ⟨false, p⟩) (.upgrade true p') st' :=
  gate_rejects_infeasible_entry family allow anchored (site := .sNew) rfl low

end SiteExpansionBlindnessWitness

/-! Removing only the anchor clause lets a run lower its own floor and drain the substrate while
staying in its current-floor kernel; the anchored process refuses the same upgrade. -/

namespace UnanchoredPolyWireheading

def crit : Bool → Nat
  | false => 3
  | true => 0

def pre : Bool → Nat
  | false => 1
  | true => 4

def post : Bool → Nat
  | false => 0
  | true => 4

def warn : Bool → Nat
  | false => 5
  | true => 8

def hsafe : Bool → Nat
  | false => 1
  | true => 4

def family : EpochFamily Bool Unit Unit where
  Mode _ := Unit
  S _ _ := Nat
  Obs _ _ := Bool
  Dist _ _ := Unit
  Int _ _ := Empty
  Ext _ _ := Unit
  C e := lagAgent (fun _ => pre e) (fun _ => post e)
  init _ := ⟨(), 1⟩
  c e := lagContract (fun _ => pre e) (fun _ => post e) (fun () => by cases e <;> decide)
  route _ _ _ := [()]
  obs e _ x := Nat.blt (x ()) (warn e)
  channel _ em _ _ := em
  G := selfGain
  envDraw _ _ := 0
  envCap _ _ := 0
  jointAdm _ _ := True
  scope _ _ := true
  x_crit e _ := crit e
  warnLevel e _ := warn e
  H_safe e _ := hsafe e
  sitePreCap e _ := pre e
  sitePostCap e _ := post e
  maxLagEnv _ := 1
  maxSilenceEnv _ := 0

theorem cert (e : Bool) : family.Cert e where
  env_within _ _ _ := Nat.le_refl 0
  pre_cap_bound _ _ _ _ _ := Nat.le_refl _
  post_cap_bound _ _ _ _ := Nat.le_refl _
  lag_bound _ _ _ := Nat.le_refl 1
  silence_bound _ _ _ := Nat.le_refl 0
  obs_detects _ _ _ _ _ _ hlt := CoreHelpers.natBlt_true_iff.mpr hlt
  channel_fires _ _ _ _ := rfl
  post_viable := fun () => by cases e <;> decide
  post_allowance := fun () => by cases e <;> decide
  warn_margin := fun () _ => by cases e <;> decide

theorem total (e : Bool) : family.Total e :=
  ⟨⟨(), trivial⟩, fun _ _ => ⟨(), fun _ => trivial⟩⟩

abbrev allow (e e' : Bool) : Prop := e = false ∧ e' = true

def x₀ : Unit → Nat := fun _ => 4

/-- The floor-lowering upgrade passes every check of the gate except the anchor. -/
theorem lowering_gate_unanchored :
    EpochHandoffGate family allow false x₀ false true ⟨(), (0 : Nat)⟩ :=
  ⟨⟨rfl, rfl⟩, fun h => Bool.noConfusion h, cert true, total true, Nat.zero_le 1,
   fun () _ => by decide⟩

/-- **Unanchored.** No run leaves the current-floor guard, yet a run reaches reserve `0`, below the
original floor `3`. -/
theorem unanchored_drains_inside_own_kernel :
    Viability.Kernel (epochProcess family allow false) (epochCurrentGuard family)
      (x₀, ⟨false, ⟨(), (1 : Nat)⟩⟩) ∧
    ∃ st, Reach (epochProcess family allow false) (x₀, ⟨false, ⟨(), (1 : Nat)⟩⟩) st ∧
      st.1 () = 0 ∧ st.1 () < crit false := by
  refine ⟨(epochInv_certificate family allow false selfGain_rises).kernel
      ⟨cert false, Nat.le_refl 1, fun () _ => by decide⟩, ?_⟩
  have up : (epochProcess family allow false).step (x₀, ⟨false, ⟨(), (1 : Nat)⟩⟩)
      (.upgrade true ⟨(), (0 : Nat)⟩) (x₀, ⟨true, ⟨(), (0 : Nat)⟩⟩) :=
    EpochStep.upgrade x₀ false _ true _ lowering_gate_unanchored
  have drain := EpochStep.intra (F := family) (AllowUpgrade := allow) (anchored := false)
    x₀ true () (0 : Nat) () () trivial (fun _ => trivial)
  exact ⟨_, Reach.trans (Reach.of_step up) (Reach.of_step drain), rfl, by decide⟩

/-- **Anchored.** The same upgrade is no step, and no run leaves the original floor `3`. -/
theorem anchored_refuses_lowering :
    (∀ st', ¬ (epochClosedProcess family allow).step (x₀, ⟨false, ⟨(), (1 : Nat)⟩⟩)
      (.upgrade true ⟨(), (0 : Nat)⟩) st') ∧
    ∀ st, Reach (epochClosedProcess family allow) (x₀, ⟨false, ⟨(), (1 : Nat)⟩⟩) st → 3 ≤ st.1 () := by
  refine ⟨fun st' hstep => ?_, fun st hreach => ?_⟩
  · cases hstep with
    | upgrade _ _ _ _ _ gate =>
      exact absurd ((gate.anchor rfl).scope_pullback () rfl).2 (by decide)
  · exact (epochChain_viability_kernel family allow false x₀ selfGain_rises (cert false)
      (fun () _ => by decide) st hreach).1 ()

end UnanchoredPolyWireheading

/-! ## Part 5: Evolve versus compose on one composed substrate -/

namespace SimultaneousUpgradeObstruction

def agent (pre : Nat) := lagAgent (fun _ : Unit => pre) (fun _ => 0)

def agentContract (pre : Nat) :=
  lagContract (fun _ : Unit => pre) (fun _ => 0) (fun _ => Nat.zero_le _)

def pairComp (preA preB : Nat) := PolyComponent.compose (agent preA) (agent preB)

def pairContract (preA preB : Nat) := PolyContract.compose (agentContract preA) (agentContract preB)

def pairRoute : (m : Unit × Unit) → Unit → List (Sum Unit Unit) :=
  composeRoute (fun _ _ => [()]) (fun _ _ => [()])

/-- Each agent's own sensor: agent `A` reads below `wA`, agent `B` below `wB`. -/
def pairObs (wA wB : Nat) (_ : Unit × Unit) (x : Unit → Nat) : Bool × Bool :=
  (Nat.blt (x ()) wA, Nat.blt (x ()) wB)

def pairChannel (em : Bool) (_ : Nat) (_ : Unit) : Bool := em

def pairProcess (preA preB wA wB : Nat) :=
  polyClosedProcess (pairComp preA preB) pairRoute (pairContract preA preB) (pairObs wA wB)
    pairChannel selfGain (fun _ _ => 0) (fun _ => True)

def pairGuard (preA preB : Nat) :=
  polyClosedGuard (pairComp preA preB) (pairContract preA preB) (fun (_ : Unit) => 3)

/-- Both agents start with their lag bit up. -/
def pairStart (x₀ : Nat) : (Unit → Nat) × (Σ _ : Unit × Unit, Nat × Nat) :=
  (fun _ => x₀, ⟨((), ()), (1, 1)⟩)

/-- Viability from headroom, with one agent's sensor covering the joint warning level. -/
theorem pair_viable_of_headroom (preA preB wA wB x₀ : Nat)
    (hWarn : 3 + 2 * (preA + preB) ≤ wA ∨ 3 + 2 * (preA + preB) ≤ wB)
    (hInit : 3 + (preA + preB) ≤ x₀) :
    Viability.Kernel (pairProcess preA preB wA wB) (pairGuard preA preB)
      (pairStart x₀) :=
  poly_close_kernel_allModes (pairComp preA preB) pairRoute (pairContract preA preB)
    (pairObs wA wB) pairChannel selfGain (fun _ _ => 0) (fun _ => 0) (fun _ => True)
    (fun _ _ _ => Nat.le_refl 0)
    (fun _ => preA + preB) (fun _ => 0) 1 0
    (fun _ _ => Nat.le_refl _) (fun _ _ => Nat.le_refl 0)
    (fun _ => Nat.le_refl 1) (fun _ => Nat.le_refl 0)
    (fun _ => 3) (fun _ => 3 + 2 * (preA + preB)) (fun _ => 1) (fun _ => x₀)
    (fun _ _ x () _ hlt => match hWarn with
      | .inl hA => Or.inl (CoreHelpers.natBlt_true_iff.mpr (Nat.lt_of_lt_of_le hlt hA))
      | .inr hB => Or.inr (CoreHelpers.natBlt_true_iff.mpr (Nat.lt_of_lt_of_le hlt hB)))
    (fun _ _ _ _ => rfl)
    selfGain_rises
    (fun () => by decide)
    (fun () => by decide)
    (fun () => Nat.le_refl _)
    (fun () => by
      show 3 + 1 * (preA + preB) ≤ x₀
      rw [Nat.one_mul]
      exact hInit)

/-- **Solo `A`.** At `x₀ = 8`, `A` drawing `4` beside `B` at `1` stays viable forever, and `A`'s
draw on the first tick is `4`. -/
theorem solo_A_evolve_viable :
    Viability.Kernel (pairProcess 4 1 13 7) (pairGuard 4 1) (pairStart 8) ∧
    (agent 4).drawExt ⟨(), 1⟩ () = 4 :=
  ⟨pair_viable_of_headroom 4 1 13 7 8 (.inl (Nat.le_refl _)) (by decide), rfl⟩

/-- **Solo `B`.** The mirror image. -/
theorem solo_B_evolve_viable :
    Viability.Kernel (pairProcess 1 4 7 13) (pairGuard 1 4) (pairStart 8) ∧
    (agent 4).drawExt ⟨(), 1⟩ () = 4 :=
  ⟨pair_viable_of_headroom 1 4 7 13 8 (.inr (Nat.le_refl _)) (by decide), rfl⟩

/-- **Concurrent.** At the same `x₀ = 8`, both drawing `4` leaves `0` after one step, whatever the
sensors: the alarm comes after the draw. -/
theorem concurrent_evolve_collapses (wA wB : Nat) :
    ¬ Viability.Kernel (pairProcess 4 4 wA wB) (pairGuard 4 4) (pairStart 8) :=
  fun kern =>
    have step : (pairProcess 4 4 wA wB).step (pairStart 8) ((), ⟨((), ()), ((), ())⟩) _ :=
      ⟨rfl, trivial, fun _ => ⟨trivial, trivial⟩, rfl⟩
    Nat.not_succ_le_zero 2 ((kern _ (Reach.of_step step)).1 ())

/-- **No local gate.** No gate reading only `(x, own new draw, partner's current draw)` both admits
every viable solo upgrade and makes every pair it admits viable under some choice of sensors. -/
theorem no_local_gate_soloComplete_and_concurrentSafe (LocalGate : Nat → Nat → Nat → Prop)
    (soloComplete : ∀ x₀ own partner wA wB,
      Viability.Kernel (pairProcess own partner wA wB) (pairGuard own partner)
        (pairStart x₀) → LocalGate x₀ own partner)
    (concurrentSafe : ∀ x₀ preA preB, LocalGate x₀ preA 1 → LocalGate x₀ preB 1 →
      ∃ wA wB, Viability.Kernel (pairProcess preA preB wA wB) (pairGuard preA preB)
        (pairStart x₀)) : False :=
  let gate := soloComplete 8 4 1 13 7 solo_A_evolve_viable.1
  match concurrentSafe 8 4 4 gate gate with
  | ⟨wA, wB, kern⟩ => concurrent_evolve_collapses wA wB kern

/-- **Declared bounds compose.** Where each agent's draw stays below a declared bound and the
headroom and sensors cover the sum of the bounds, the pair is viable. -/
theorem bounded_supremum_local_gate_composes (preA preB mA mB wA wB x₀ : Nat)
    (hmA : preA ≤ mA) (hmB : preB ≤ mB)
    (hWarn : 3 + 2 * (mA + mB) ≤ wA ∨ 3 + 2 * (mA + mB) ≤ wB)
    (hInit : 3 + (mA + mB) ≤ x₀) :
    Viability.Kernel (pairProcess preA preB wA wB) (pairGuard preA preB)
      (pairStart x₀) :=
  have hSum : 3 + 2 * (preA + preB) ≤ 3 + 2 * (mA + mB) :=
    Nat.add_le_add_left (Nat.mul_le_mul_left 2 (Nat.add_le_add hmA hmB)) 3
  pair_viable_of_headroom preA preB wA wB x₀
    (match hWarn with
      | .inl h => .inl (Nat.le_trans hSum h)
      | .inr h => .inr (Nat.le_trans hSum h))
    (Nat.le_trans (Nat.add_le_add_left (Nat.add_le_add hmA hmB) 3) hInit)

/-- The composed gate: headroom for the joint draw at the current reserve. -/
def ReciprocalGate (x₀ preA preB : Nat) : Prop := 3 + (preA + preB) ≤ x₀

/-- The composed gate is sound with joint sensors at `3 + 2 * (preA + preB)`. -/
theorem reciprocalGate_sound {x₀ preA preB : Nat} (gate : ReciprocalGate x₀ preA preB) :
    Viability.Kernel (pairProcess preA preB (3 + 2 * (preA + preB)) (3 + 2 * (preA + preB)))
      (pairGuard preA preB) (pairStart x₀) :=
  pair_viable_of_headroom preA preB _ _ x₀ (.inl (Nat.le_refl _)) gate

/-- **Reciprocal evolve.** The composed gate refuses both upgrades at `x₀ = 8` and admits them at
`x₀ = 11`; there, with joint sensors at `19`, no run leaves the floor, both agents draw `4` on the
first tick, the reserve goes `11 → 4` with both lag bits cleared, then `4 → 5`. -/
theorem reciprocal_evolve_rejects_8_and_certifies_11 :
    ¬ ReciprocalGate 8 4 4 ∧ ReciprocalGate 11 4 4 ∧
    Viability.Kernel (pairProcess 4 4 19 19) (pairGuard 4 4) (pairStart 11) ∧
    (agent 4).drawExt ⟨(), 1⟩ () = 4 ∧
    Reach (pairProcess 4 4 19 19) (pairStart 11) (fun _ => 4, ⟨((), ()), (0, 0)⟩) ∧
    Reach (pairProcess 4 4 19 19) (fun _ => 4, ⟨((), ()), (0, 0)⟩) (fun _ => 5, ⟨((), ()), (0, 0)⟩) :=
  have admit11 : ReciprocalGate 11 4 4 := (by decide : 3 + (4 + 4) ≤ 11)
  ⟨(by decide : ¬ 3 + (4 + 4) ≤ 8), admit11, reciprocalGate_sound admit11, rfl,
   Reach.of_step (a := ((), ⟨((), ()), ((), ())⟩)) ⟨rfl, trivial, fun _ => ⟨trivial, trivial⟩, rfl⟩,
   Reach.of_step (a := ((), ⟨((), ()), ((), ())⟩)) ⟨rfl, trivial, fun _ => ⟨trivial, trivial⟩, rfl⟩⟩

/-! ### Part 5b: Joint epoch family and `EpochHandoffGate` -/

/-- Parametric joint epoch family over any epoch index `E`: each epoch `e` carries the composed
pair `(preOf e).1, (preOf e).2`, floor `3`, self-supporting gain, and joint warning level
`3 + 2 * ((preOf e).1 + (preOf e).2)`. -/
def jointEpochFamily {E : Type} (preOf : E → Nat × Nat) : EpochFamily E Unit Unit where
  Mode _ := Unit × Unit
  S _ _ := Nat × Nat
  Obs _ _ := Bool × Bool
  Dist _ _ := Unit × Unit
  Int _ _ := Sum Empty Empty
  Ext _ _ := Sum Unit Unit
  C e := pairComp (preOf e).1 (preOf e).2
  init _ := ⟨((), ()), (1, 1)⟩
  c e := pairContract (preOf e).1 (preOf e).2
  route _ := pairRoute
  obs e := pairObs (3 + 2 * ((preOf e).1 + (preOf e).2)) (3 + 2 * ((preOf e).1 + (preOf e).2))
  channel _ := pairChannel
  G := selfGain
  envDraw _ _ := 0
  envCap _ _ := 0
  jointAdm _ _ := True
  scope _ _ := true
  x_crit _ _ := 3
  warnLevel e _ := 3 + 2 * ((preOf e).1 + (preOf e).2)
  H_safe _ _ := 1
  sitePreCap e _ := (preOf e).1 + (preOf e).2
  sitePostCap _ _ := 0
  maxLagEnv _ := 1
  maxSilenceEnv _ := 0

/-- Initial state of both agents with lag bits raised. -/
abbrev jointInit : Σ _ : Unit × Unit, Nat × Nat := ⟨((), ()), (1, 1)⟩

theorem jointEpochFamily_cert {E : Type} (preOf : E → Nat × Nat) (e : E) :
    (jointEpochFamily preOf).Cert e where
  env_within _ _ _ := Nat.le_refl 0
  pre_cap_bound _ _ _ _ _ := Nat.le_refl _
  post_cap_bound _ _ _ _ := Nat.le_refl 0
  lag_bound _ _ _ := Nat.le_refl 1
  silence_bound _ _ _ := Nat.le_refl 0
  obs_detects _ _ _ _ _ _ hlt := Or.inl (CoreHelpers.natBlt_true_iff.mpr hlt)
  channel_fires _ _ _ _ := rfl
  post_viable := fun () => recovers_three
  post_allowance _ := Nat.zero_le 1
  warn_margin _ _ := by
    show 3 + (1 + 1) * ((preOf e).1 + (preOf e).2 + 0) ≤ 3 + 2 * ((preOf e).1 + (preOf e).2)
    exact Nat.le_refl _

theorem jointEpochFamily_total {E : Type} (preOf : E → Nat × Nat) (e : E) :
    (jointEpochFamily preOf).Total e :=
  ⟨⟨(), trivial⟩, fun _ _ => ⟨((), ()), fun _ => ⟨trivial, trivial⟩⟩⟩

theorem jointEpochFamily_anchor {E : Type} (preOf : E → Nat × Nat) (e e' : E) :
    (jointEpochFamily preOf).AnchorStep e e' :=
  ⟨fun _ h => ⟨h, Nat.le_refl 3⟩, fun _ => Nat.le_refl 0, fun _ h => h⟩

theorem jointEpochFamily_headroom_iff {E : Type} (preOf : E → Nat × Nat) (x₀ : Nat) (e : E) :
    (jointEpochFamily preOf).Headroom e jointInit (fun _ => x₀) ↔
      ReciprocalGate x₀ (preOf e).1 (preOf e).2 := by
  refine ⟨fun h => ?_, fun h () _ => ?_⟩
  · have hm : 3 + 1 * ((preOf e).1 + (preOf e).2) ≤ x₀ := h () rfl
    rw [Nat.one_mul] at hm
    exact hm
  · show 3 + 1 * ((preOf e).1 + (preOf e).2) ≤ x₀
    rw [Nat.one_mul]
    exact h

/-- The `EpochHandoffGate` of `jointEpochFamily` into `e'` at `jointInit` is `ReciprocalGate`. -/
theorem jointEpochFamily_gate_iff_reciprocalGate {E : Type} (preOf : E → Nat × Nat)
    (anchored : Bool) (x₀ : Nat) (e e' : E) :
    EpochHandoffGate (jointEpochFamily preOf) (fun _ _ => True) anchored (fun _ => x₀) e e'
      jointInit ↔ ReciprocalGate x₀ (preOf e').1 (preOf e').2 :=
  ⟨fun g => (jointEpochFamily_headroom_iff preOf x₀ e').mp g.headroom,
   fun h =>
     { allow := trivial
       anchor := fun _ => jointEpochFamily_anchor preOf e e'
       cert := jointEpochFamily_cert preOf e'
       total := jointEpochFamily_total preOf e'
       in_K := ⟨Nat.le_refl 1, Nat.le_refl 1⟩
       headroom := (jointEpochFamily_headroom_iff preOf x₀ e').mpr h }⟩

/-- Per-agent draw for un-upgraded (`false`, draw `1`) versus upgraded (`true`, draw `4`). -/
def upgradeDraw : Bool → Nat
  | false => 1
  | true => 4

/-- Concrete `Bool × Bool` joint epoch family. -/
def jointBoolFamily : EpochFamily (Bool × Bool) Unit Unit :=
  jointEpochFamily (fun e => (upgradeDraw e.1, upgradeDraw e.2))

/-- All transitions between epochs are structurally permitted; safety rests on the gate. -/
abbrev jointBoolAllow : (Bool × Bool) → (Bool × Bool) → Prop := fun _ _ => True

/-- **Solo `A` in the epoch process.** At `x₀ = 8`, upgrading to `(true, false)` is a step,
the starting state lies in the viability kernel, and every state reachable from `(true, false)`
stays in `epochClosedGuard jointBoolFamily (false, false)`. -/
theorem jointBool_solo_A_upgrade_and_viable :
    (epochClosedProcess jointBoolFamily jointBoolAllow).step
      (fun _ => 8, ⟨(false, false), jointInit⟩) (.upgrade (true, false) jointInit)
      (fun _ => 8, ⟨(true, false), jointInit⟩) ∧
    Viability.Kernel (epochClosedProcess jointBoolFamily jointBoolAllow)
      (epochClosedGuard jointBoolFamily (false, false))
      (fun _ => 8, ⟨(false, false), jointInit⟩) ∧
    ∀ st, Reach (epochClosedProcess jointBoolFamily jointBoolAllow)
      (fun _ => 8, ⟨(true, false), jointInit⟩) st →
      epochClosedGuard jointBoolFamily (false, false) st := by
  have gate : EpochHandoffGate jointBoolFamily jointBoolAllow true (fun _ => 8)
      (false, false) (true, false) jointInit :=
    (jointEpochFamily_gate_iff_reciprocalGate _ true 8 (false, false) (true, false)).mpr
      (by show 3 + (4 + 1) ≤ 8; decide)
  have up : (epochClosedProcess jointBoolFamily jointBoolAllow).step
      (fun _ => 8, ⟨(false, false), jointInit⟩) (.upgrade (true, false) jointInit)
      (fun _ => 8, ⟨(true, false), jointInit⟩) :=
    EpochStep.upgrade (F := jointBoolFamily) (AllowUpgrade := jointBoolAllow) (anchored := true)
      (fun _ => 8) (false, false) jointInit (true, false) jointInit gate
  have kern : Viability.Kernel (epochClosedProcess jointBoolFamily jointBoolAllow)
      (epochClosedGuard jointBoolFamily (false, false))
      (fun _ => 8, ⟨(false, false), jointInit⟩) :=
    epochChain_viability_kernel jointBoolFamily jointBoolAllow (false, false) (fun _ => 8)
      selfGain_rises (jointEpochFamily_cert _ (false, false))
      ((jointEpochFamily_headroom_iff _ 8 (false, false)).mpr (by show 3 + (1 + 1) ≤ 8; decide))
  exact ⟨up, kern, fun st hreach => kern st (Reach.trans (Reach.of_step up) hreach)⟩

/-- **Solo `B` in the epoch process.** Mirror image for upgrading to `(false, true)` at `x₀ = 8`. -/
theorem jointBool_solo_B_upgrade_and_viable :
    (epochClosedProcess jointBoolFamily jointBoolAllow).step
      (fun _ => 8, ⟨(false, false), jointInit⟩) (.upgrade (false, true) jointInit)
      (fun _ => 8, ⟨(false, true), jointInit⟩) ∧
    Viability.Kernel (epochClosedProcess jointBoolFamily jointBoolAllow)
      (epochClosedGuard jointBoolFamily (false, false))
      (fun _ => 8, ⟨(false, false), jointInit⟩) ∧
    ∀ st, Reach (epochClosedProcess jointBoolFamily jointBoolAllow)
      (fun _ => 8, ⟨(false, true), jointInit⟩) st →
      epochClosedGuard jointBoolFamily (false, false) st := by
  have gate : EpochHandoffGate jointBoolFamily jointBoolAllow true (fun _ => 8)
      (false, false) (false, true) jointInit :=
    (jointEpochFamily_gate_iff_reciprocalGate _ true 8 (false, false) (false, true)).mpr
      (by show 3 + (1 + 4) ≤ 8; decide)
  have up : (epochClosedProcess jointBoolFamily jointBoolAllow).step
      (fun _ => 8, ⟨(false, false), jointInit⟩) (.upgrade (false, true) jointInit)
      (fun _ => 8, ⟨(false, true), jointInit⟩) :=
    EpochStep.upgrade (F := jointBoolFamily) (AllowUpgrade := jointBoolAllow) (anchored := true)
      (fun _ => 8) (false, false) jointInit (false, true) jointInit gate
  have kern : Viability.Kernel (epochClosedProcess jointBoolFamily jointBoolAllow)
      (epochClosedGuard jointBoolFamily (false, false))
      (fun _ => 8, ⟨(false, false), jointInit⟩) :=
    epochChain_viability_kernel jointBoolFamily jointBoolAllow (false, false) (fun _ => 8)
      selfGain_rises (jointEpochFamily_cert _ (false, false))
      ((jointEpochFamily_headroom_iff _ 8 (false, false)).mpr (by show 3 + (1 + 1) ≤ 8; decide))
  exact ⟨up, kern, fun st hreach => kern st (Reach.trans (Reach.of_step up) hreach)⟩

/-- **Simultaneous upgrade refused at `x₀ = 8`.** Direct or sequential upgrades into `(true, true)`
are refused by `EpochHandoffGate` at reserve `8`, with or without the anchor clause. -/
theorem jointBool_simultaneous_refused_at_8 (anchored : Bool) (e : Bool × Bool)
    (p : Σ _ : Unit × Unit, Nat × Nat) (st' : jointBoolFamily.State) :
    ¬ (epochProcess jointBoolFamily jointBoolAllow anchored).step
      (fun _ => 8, ⟨e, p⟩) (.upgrade (true, true) jointInit) st' := by
  intro hstep
  cases hstep with
  | upgrade _ _ _ _ _ gate =>
    exact absurd
      ((jointEpochFamily_gate_iff_reciprocalGate _ anchored 8 e (true, true)).mp gate)
      (by show ¬ 3 + (4 + 4) ≤ 8; decide)

/-- **Simultaneous upgrade certified at `x₀ = 11`.** At `x₀ = 11`, upgrading to `(true, true)` is a
step, every reachable state stays viable, the reserve moves `11 → 4 → 5`, and no reachable state
deadlocks. -/
theorem jointBool_simultaneous_certified_at_11 :
    (epochClosedProcess jointBoolFamily jointBoolAllow).step
      (fun _ => 11, ⟨(false, false), jointInit⟩) (.upgrade (true, true) jointInit)
      (fun _ => 11, ⟨(true, true), jointInit⟩) ∧
    Viability.Kernel (epochClosedProcess jointBoolFamily jointBoolAllow)
      (epochClosedGuard jointBoolFamily (false, false))
      (fun _ => 11, ⟨(false, false), jointInit⟩) ∧
    Reach (epochClosedProcess jointBoolFamily jointBoolAllow)
      (fun _ => 11, ⟨(false, false), jointInit⟩)
      (fun _ => 4, ⟨(true, true), ⟨((), ()), (0, 0)⟩⟩) ∧
    Reach (epochClosedProcess jointBoolFamily jointBoolAllow)
      (fun _ => 4, ⟨(true, true), ⟨((), ()), (0, 0)⟩⟩)
      (fun _ => 5, ⟨(true, true), ⟨((), ()), (0, 0)⟩⟩) ∧
    ∀ st, Reach (epochClosedProcess jointBoolFamily jointBoolAllow)
      (fun _ => 11, ⟨(false, false), jointInit⟩) st →
      ∃ a st', (epochClosedProcess jointBoolFamily jointBoolAllow).step st a st' := by
  have gate : EpochHandoffGate jointBoolFamily jointBoolAllow true (fun _ => 11)
      (false, false) (true, true) jointInit :=
    (jointEpochFamily_gate_iff_reciprocalGate _ true 11 (false, false) (true, true)).mpr
      (by show 3 + (4 + 4) ≤ 11; decide)
  have up : (epochClosedProcess jointBoolFamily jointBoolAllow).step
      (fun _ => 11, ⟨(false, false), jointInit⟩) (.upgrade (true, true) jointInit)
      (fun _ => 11, ⟨(true, true), jointInit⟩) :=
    EpochStep.upgrade (F := jointBoolFamily) (AllowUpgrade := jointBoolAllow) (anchored := true)
      (fun _ => 11) (false, false) jointInit (true, true) jointInit gate
  have intra1 : (epochClosedProcess jointBoolFamily jointBoolAllow).step
      (fun _ => 11, ⟨(true, true), jointInit⟩) (.intra () (true, true) ((), ()) ((), ()))
      (fun _ => 4, ⟨(true, true), ⟨((), ()), (0, 0)⟩⟩) :=
    EpochStep.intra (F := jointBoolFamily) (AllowUpgrade := jointBoolAllow) (anchored := true)
      (fun _ => 11) (true, true) ((), ()) (1, 1) () ((), ()) trivial (fun _ => ⟨trivial, trivial⟩)
  have intra2 : (epochClosedProcess jointBoolFamily jointBoolAllow).step
      (fun _ => 4, ⟨(true, true), ⟨((), ()), (0, 0)⟩⟩) (.intra () (true, true) ((), ()) ((), ()))
      (fun _ => 5, ⟨(true, true), ⟨((), ()), (0, 0)⟩⟩) :=
    EpochStep.intra (F := jointBoolFamily) (AllowUpgrade := jointBoolAllow) (anchored := true)
      (fun _ => 4) (true, true) ((), ()) (0, 0) () ((), ()) trivial (fun _ => ⟨trivial, trivial⟩)
  have kern : Viability.Kernel (epochClosedProcess jointBoolFamily jointBoolAllow)
      (epochClosedGuard jointBoolFamily (false, false))
      (fun _ => 11, ⟨(false, false), jointInit⟩) :=
    epochChain_viability_kernel jointBoolFamily jointBoolAllow (false, false) (fun _ => 11)
      selfGain_rises (jointEpochFamily_cert _ (false, false))
      ((jointEpochFamily_headroom_iff _ 11 (false, false)).mpr (by show 3 + (1 + 1) ≤ 11; decide))
  refine ⟨up, kern, Reach.trans (Reach.of_step up) (Reach.of_step intra1), Reach.of_step intra2,
    fun st hreach => ?_⟩
  exact epochChain_nonDeadlock jointBoolFamily jointBoolAllow true (false, false) jointInit
    (fun _ => 11) (jointEpochFamily_total _ (false, false)) ⟨Nat.le_refl 1, Nat.le_refl 1⟩
    st hreach

/-- **No local gate inside `EpochHandoffGate`.** Any gate admitting both solo upgrades at `(4, 1)`
whenever `EpochHandoffGate` admits them cannot imply `EpochHandoffGate` for `(true, true)`. -/
theorem jointBool_no_local_gate_admits_solo_and_matches_joint_gate
    (LocalGate : Nat → Nat → Nat → Prop)
    (soloA : ∀ x₀, EpochHandoffGate jointBoolFamily jointBoolAllow true (fun _ => x₀)
      (false, false) (true, false) jointInit → LocalGate x₀ 4 1)
    (soloB : ∀ x₀, EpochHandoffGate jointBoolFamily jointBoolAllow true (fun _ => x₀)
      (false, false) (false, true) jointInit → LocalGate x₀ 4 1)
    (joint : ∀ x₀, LocalGate x₀ 4 1 → LocalGate x₀ 4 1 →
      EpochHandoffGate jointBoolFamily jointBoolAllow true (fun _ => x₀)
        (false, false) (true, true) jointInit) : False :=
  have gA : EpochHandoffGate jointBoolFamily jointBoolAllow true (fun _ => 8)
      (false, false) (true, false) jointInit :=
    (jointEpochFamily_gate_iff_reciprocalGate _ true 8 (false, false) (true, false)).mpr
      (by show 3 + (4 + 1) ≤ 8; decide)
  have gB : EpochHandoffGate jointBoolFamily jointBoolAllow true (fun _ => 8)
      (false, false) (false, true) jointInit :=
    (jointEpochFamily_gate_iff_reciprocalGate _ true 8 (false, false) (false, true)).mpr
      (by show 3 + (1 + 4) ≤ 8; decide)
  absurd
    ((jointEpochFamily_gate_iff_reciprocalGate _ true 8 (false, false) (true, true)).mp
      (joint 8 (soloA 8 gA) (soloB 8 gB)))
    (by show ¬ 3 + (4 + 4) ≤ 8; decide)

end SimultaneousUpgradeObstruction

end Becoming.OpenEndedComposition
