import Becoming.Experiment

/-!
# Mechanism: a projection the step factors through, and standard causal models as processes

On 12 October 2026 the AI compared the theory with a general cause–effect system: a state going
on as `x_{t+1} = F(x_t, u_t, ε_t)` under inputs and noise, with feedback, adaptive parameters
and attractors. Ren gave the go: "Great, let's finish all of them". `Becoming.Experiment` calls
the factoring of a step through a projection a model of what is irrelevant. This module states,
with no premise beyond what each law names, exactly when a projection carries such a model, what
a system that changes its own rule is, and where the standard model's inputs, interventions and
noise sit. A projection `π : S → K` of the configuration is a description of it: neither a
reading of time nor a finer unit of amount (`Becoming.Resolution`).

* **A projection carries a law exactly where configurations alike under it go alike.** The step
  read through `π` (`Image`) is the least process the step factors through (`factors_image`,
  `Image.least`). Some determined process on the description admits every step so read if and
  only if configurations alike under `π` go alike under `π` (`GoAlike`, `carries_law_iff`,
  `image_determined_iff`): the grammar's law that the image of a relation along a map has a fixed
  successor exactly where sameness under the map goes alike (`«像定后当且仅当同行»` of
  `Becoming.GrammarLaws`), at each move (`image_step_iff`). Through the identity this is
  determinacy (`goAlike_id_iff`); through the description that distinguishes nothing it always
  holds (`goAlike_const`); a description of the image carries a law exactly where the composite
  description does (`goAlike_image_iff`).
  Two runs taking the same moves from configurations alike stay alike (`GoAlike.runs_agree`).
* **What the step does not depend on is re-absorbed in one step.** Where the whole next
  configuration depends only on `π` (`DependsOnlyOn`), two runs taking the same moves from
  configurations alike under `π` are equal from the first step on
  (`DependsOnlyOn.reabsorbed`). For a determined law this is `Law.reabsorbed`; with the
  configuration read as a state and a rule, and the rule as the projection, it is
  `Law.perturbation_reabsorbed` of `Becoming.Capture` (P62), proved there as its instance.
* **A system that changes its own rule.** A state going on under a rule that itself goes on
  (`adaptive`) is one determined process on the joint configuration (`adaptive_determined`).
  The state carries a law of its own exactly where the rule makes no difference to it
  (`adaptive_state_law_iff`, `adaptive_state_carries_iff`); on a stretch where the rule stays,
  the state's steps are those of the rule's own law (`ruleLaw`, `Run.steps_by_rule`). In
  `Switching` the rule alternates: no determined process on the state admits even the run's
  first two steps read through the state (`Switching.no_state_law`), while the joint process is
  determined (`Switching.determined`).
* **A law through a projection is not fixed where not yet taken.** Where some determined
  process on the description admits the run's steps so read, and the run has not taken a move
  at a projected configuration (`Run.TakesThrough`), the record fixes no outcome of it there
  (`Run.not_fixesThrough_of_untaken`), even where configurations alike under `π` go alike
  (`Run.not_fixesThrough_of_goAlike`): `Run.not_fixes_of_untaken` read through `π`.
* **Standard causal models.** `x_{t+1} = F(x_t, u_t, ε_t)` is a determined process whose move is
  the input and the noise together (`inputs`, `inputs_determined`, `trajectory`, `inputsRun`).
  An intervention is a move not taken: the record fixes no outcome of it
  (`inputs_intervention_unfixed`), and the model does (`inputs_model_fixes`). Noise is a move
  not represented: with it forgotten (`forget`, `Run.forget`), the process stays determined
  exactly where the noise makes no difference (`forget_inputs_determined_iff`). In `Coarse` the
  move does not determine the configuration, yet its first part carries a determined law
  (`Coarse.not_determined`, `Coarse.goAlike`, `Coarse.carries`).

**Readings (the AI's, adopted on Ren's delegation of 15 October 2026, DELEGATED-CHOICES D25).**
- A mechanism is a projection of configuration that carries a law. P53's model of what is
  irrelevant is now characterized exactly and with no premise (`carries_law_iff`): what is
  irrelevant to the change, read through `π`, is what configurations alike under `π` differ in.
- A projection of configuration is a third thing beside readings of time and finer units of
  amount: it reads what the configuration is, not when it is or in what unit it is counted. A
  law at a coarser description (emergence) is `GoAlike` at that description. It can hold where
  the whole configuration has none (`Coarse`); and since the description that distinguishes
  nothing always carries one, the content of an emergent law is which description carries it.
- The rule holding the outcome (`Becoming.Capture`) is `DependsOnlyOn` the rule.
- A system that changes its own causality is a law on the joint configuration of state and
  rule, with no law at the state alone wherever the rule makes a difference to the state. No
  further kind of law is needed: every law stated of every process already covers the joint
  configuration.
- An intervention is a move not taken, fixed by a model and not by the record. Retargeting
  (`retarget`) is the replacement of one structural equation at one configuration and move.
  Noise is a move not represented.

What is not derived: which projection an actual unfolding carries a law through; that any
formation forms or uses one; how a rule comes to change; that input and noise are separable in
an actual unfolding. No ethical predicate, ranking or axiom occurs.

`trajectory` is stated in `Becoming.Recurrence`, beside `Law.orbit` (board item W).
-/

namespace Becoming

open Generative

universe u v w u'

variable {S : Type u} {A : Type v} {K : Type w}

/-! ## A projection that carries a law -/

/-- The step of `P` read through `π`: `a` goes from `k` to `κ` where some step of `P` by `a`
goes from a configuration projecting to `k` to one projecting to `κ`. -/
def Image (P : Process S A) (π : S → K) : Process K A :=
  ⟨fun k a κ => ∃ s u, π s = k ∧ P.step s a u ∧ π u = κ⟩

/-- The step of `P` factors through `π` into its image. -/
theorem factors_image (P : Process S A) (π : S → K) : FactorsThrough P π (Image P π) :=
  fun s _ u step => ⟨s, u, rfl, step, rfl⟩

/-- **The image is the least process the step factors through.** Every process into which the
step of `P` factors through `π` admits every step of the image. -/
theorem Image.least {P : Process S A} {π : S → K} {Q : Process K A}
    (factors : FactorsThrough P π Q) {k : K} {a : A} {κ : K} :
    (Image P π).step k a κ → Q.step k a κ
  | ⟨s, u, at_k, step, to⟩ => at_k ▸ to ▸ factors s a u step

/-- Each move of the image is the grammar's image (`«像»`) of the move along the projection, by
definition. It documents the representation: no proof uses it, since unfolding the definitions does
the work (`image_determined_iff`). -/
theorem image_step_iff {P : Process S A} {π : S → K} {a : A} {k κ : K} :
    (Image P π).step k a κ ↔ «像» π (fun s t => P.step s a t) k κ :=
  Iff.rfl

/-- **The image is determined exactly where configurations alike go alike**: the grammar's law of
the image (`«像定后当且仅当同行»`) at each move, determinacy being a fixed successor at each move
(`determined_iff_fixed`) and going alike the grammar's at each move (`goAlikeUnder_iff_alike`). The
law carried may be partial: nothing is said of a successor existing. -/
theorem image_determined_iff {P : Process S A} {π : S → K} :
    Determined (Image P π) ↔ GoAlike P π :=
  determined_iff_fixed.trans
    ⟨fun fixed => goAlikeUnder_iff_alike.mpr fun a =>
        («像定后当且仅当同行» (π := π) (R := fun s t => P.step s a t)).mp (fixed a),
     fun alike a => («像定后当且仅当同行» (π := π) (R := fun s t => P.step s a t)).mpr
        (goAlikeUnder_iff_alike.mp alike a)⟩

/-- **A projection carries a law exactly where configurations alike under it go alike.** Some
determined process on the description admits every step of `P` read through `π` if and only if
configurations alike under `π` go alike under `π`. It holds of every process and every
projection. -/
theorem carries_law_iff {P : Process S A} {π : S → K} :
    (∃ Q : Process K A, Determined Q ∧ FactorsThrough P π Q) ↔ GoAlike P π :=
  ⟨fun ⟨Q, determined, factors⟩ s s' a u u' same step step' =>
    determined (π s) a (π u) (π u') (factors s a u step)
      (Eq.subst (motive := fun k => Q.step k a (π u')) same.symm (factors s' a u' step')),
   fun alike => ⟨Image P π, image_determined_iff.mpr alike, factors_image P π⟩⟩

/-- **Through the identity, going alike is determinacy.** -/
theorem goAlike_id_iff {P : Process S A} : GoAlike P id ↔ Determined P :=
  ⟨fun alike s a u u' step step' => alike s s a u u' rfl step step',
   fun determined s s' a u u' same step step' =>
    determined s a u u' step
      (Eq.subst (motive := fun x => P.step x a u') (show s = s' from same).symm step')⟩

/-- The description that distinguishes nothing carries a law for every process. -/
theorem goAlike_const (P : Process S A) (k : K) : GoAlike P (fun _ => k) :=
  fun _ _ _ _ _ _ _ _ => rfl

/-- **Descriptions compose.** A description `ρ` of the image of `P` through `π` carries a law
exactly where the composite description `ρ ∘ π` of `P` does. -/
theorem goAlike_image_iff {P : Process S A} {π : S → K} {L : Type u'} {ρ : K → L} :
    GoAlike (Image P π) ρ ↔ GoAlike P (ρ ∘ π) :=
  ⟨fun alike s s' a u u' same step step' =>
    alike (π s) (π s') a (π u) (π u') same ⟨s, u, rfl, step, rfl⟩ ⟨s', u', rfl, step', rfl⟩,
   fun alike _ _ a _ _ same ⟨s, u, at_k, step, to⟩ ⟨s', u', at_k', step', to'⟩ =>
    (congrArg ρ to).symm.trans
      ((alike s s' a u u'
          ((congrArg ρ at_k).trans (same.trans (congrArg ρ at_k').symm)) step step').trans
        (congrArg ρ to'))⟩

/-- **Runs alike stay alike.** Where configurations alike under `π` go alike, two runs taking
the same moves from configurations alike under `π` are alike under `π` at every step. -/
theorem GoAlike.runs_agree {P : Process S A} {π : S → K} (alike : GoAlike P π) (r r' : Run P)
    (moves : ∀ n, r.act n = r'.act n) (start : π (r.state 0) = π (r'.state 0)) :
    ∀ n, π (r.state n) = π (r'.state n)
  | 0 => start
  | n + 1 =>
    alike (r.state n) (r'.state n) (r.act n) (r.state (n + 1)) (r'.state (n + 1))
      (GoAlike.runs_agree alike r r' moves start n) (r.step n)
      (Eq.subst (motive := fun a => P.step (r'.state n) a (r'.state (n + 1))) (moves n).symm
        (r'.step n))

/-! ## What the step does not depend on -/

/-- The next configuration depends only on `π`: wherever two configurations project alike, the
same move takes them to one configuration. -/
def DependsOnlyOn (P : Process S A) (π : S → K) : Prop :=
  ∀ s s' a u u', π s = π s' → P.step s a u → P.step s' a u' → u = u'

/-- Depending only on `π`, configurations alike under `π` go alike under it. -/
theorem DependsOnlyOn.goAlike {P : Process S A} {π : S → K} (only : DependsOnlyOn P π) :
    GoAlike P π :=
  fun s s' a u u' same step step' => congrArg π (only s s' a u u' same step step')

/-- **What the step does not depend on is re-absorbed in one step.** Where the next
configuration depends only on `π`, two runs taking the same moves from configurations alike
under `π` are equal from the first step on: whatever else differed at the start is gone. -/
theorem DependsOnlyOn.reabsorbed {P : Process S A} {π : S → K} (only : DependsOnlyOn P π)
    (r r' : Run P) (moves : ∀ n, r.act n = r'.act n) (start : π (r.state 0) = π (r'.state 0)) :
    ∀ n, r.state (n + 1) = r'.state (n + 1) :=
  fun n => only (r.state n) (r'.state n) (r.act n) (r.state (n + 1)) (r'.state (n + 1))
    (only.goAlike.runs_agree r r' moves start n) (r.step n)
    (Eq.subst (motive := fun a => P.step (r'.state n) a (r'.state (n + 1))) (moves n).symm
      (r'.step n))

namespace Law

/-- As a process, a determined law depends only on `π` exactly where configurations alike
under `π` go on to one configuration. -/
theorem dependsOnlyOn_iff {next : S → S} {π : S → K} :
    DependsOnlyOn (process next) π ↔ ∀ s s', π s = π s' → next s = next s' :=
  ⟨fun only s s' same => only s s' () (next s) (next s') same rfl rfl,
   fun only s s' _ _ _ same step step' => step.trans ((only s s' same).trans step'.symm)⟩

/-- **A determined law re-absorbs what it does not depend on.** Where `next` depends only on
`π`, configurations alike under `π` have the same orbit from the next step on: an instance of
`DependsOnlyOn.reabsorbed`. -/
theorem reabsorbed {next : S → S} {π : S → K} (only : ∀ s s', π s = π s' → next s = next s')
    {s s' : S} (same : π s = π s') : ∀ n, orbit next s (n + 1) = orbit next s' (n + 1) :=
  (dependsOnlyOn_iff.mpr only).reabsorbed (run next s) (run next s') (fun _ => rfl) same

end Law

/-! ## A system that changes its own rule -/

section Adaptive

variable {X : Type u} {R : Type v} {U : Type w}

/-- A state `x` going on under a rule `g` that itself goes on: by the move `u`, the state
becomes `F g x u` and the rule becomes `G g x`. The configuration is the pair. -/
def adaptive (F : R → X → U → X) (G : R → X → R) : Process (X × R) U :=
  ⟨fun s u s' => s' = (F s.2 s.1 u, G s.2 s.1)⟩

/-- A system changing its own rule is one determined process on the joint configuration. -/
theorem adaptive_determined (F : R → X → U → X) (G : R → X → R) :
    Determined (adaptive F G) :=
  fun _ _ _ _ step step' => step.trans step'.symm

/-- **The state carries a law of its own exactly where the rule makes no difference to it.** -/
theorem adaptive_state_law_iff {F : R → X → U → X} {G : R → X → R} :
    GoAlike (adaptive F G) Prod.fst ↔ ∀ g g' x u, F g x u = F g' x u :=
  ⟨fun alike g g' x u => alike (x, g) (x, g') u _ _ rfl rfl rfl,
   fun every s s' u _ _ same step step' =>
    (congrArg Prod.fst step).trans ((every s.2 s'.2 s.1 u).trans
      ((congrArg (fun y => F s'.2 y u) same).trans (congrArg Prod.fst step').symm))⟩

/-- Some determined process on the state admits every step read through the state exactly
where the rule makes no difference to the state. -/
theorem adaptive_state_carries_iff {F : R → X → U → X} {G : R → X → R} :
    (∃ Q : Process X U, Determined Q ∧ FactorsThrough (adaptive F G) Prod.fst Q) ↔
      ∀ g g' x u, F g x u = F g' x u :=
  carries_law_iff.trans adaptive_state_law_iff

/-- The state's own law under the rule `g` held fixed. -/
def ruleLaw (F : R → X → U → X) (g : R) : Process X U :=
  ⟨fun x u x' => x' = F g x u⟩

/-- A rule held fixed is a determined law of the state. -/
theorem ruleLaw_determined (F : R → X → U → X) (g : R) : Determined (ruleLaw F g) :=
  fun _ _ _ _ step step' => step.trans step'.symm

/-- **While the rule stays, the state goes by it.** Along a run of an adaptive system, on a
stretch before `t` where the rule stays `g`, the state's steps are those of the law of `g`. -/
theorem Run.steps_by_rule {F : R → X → U → X} {G : R → X → R} (r : Run (adaptive F G))
    {g : R} {t : Nat} (stays : ∀ n, n < t → (r.state n).2 = g) :
    r.StepsThrough Prod.fst (ruleLaw F g) t :=
  fun n before => (congrArg Prod.fst (r.step n)).trans
    (congrArg (fun h => F h (r.state n).1 (r.act n)) (stays n before))

end Adaptive

/-! ## A law through a projection is not fixed where not yet taken -/

namespace Run

variable {P : Process S A}

/-- Before step `t` the run takes move `a` at a configuration projecting to `k`. -/
def TakesThrough (r : Run P) (π : S → K) (t : Nat) (k : K) (a : A) : Prop :=
  ∃ n, n < t ∧ π (r.state n) = k ∧ r.act n = a

/-- A run that has not taken `a` at a configuration projecting to `k` before `t` has every step
before `t`, read through `π`, admitted by every retargeting there of a process admitting them. -/
theorem stepsThrough_retarget (r : Run P) {π : S → K} {Q : Process K A} {t : Nat}
    (steps : r.StepsThrough π Q t) {k : K} {a : A} (untaken : ¬ r.TakesThrough π t k a)
    (κ₀ : K) : r.StepsThrough π (retarget Q k a κ₀) t :=
  fun n before => .inl ⟨fun ⟨same, same'⟩ => untaken ⟨n, before, same, same'⟩, steps n before⟩

/-- **A law through a projection is not fixed where not yet taken.** Where some determined
process on the description admits the run's steps before `t` read through `π`, and the run has
not taken `a` at a configuration projecting to `k` before `t`, the record fixes no outcome of
`a` at `k`: determined processes admitting every step so read send it to any two projected
configurations. A change of mechanism at a projected configuration not yet met does not
show before it happens. -/
theorem not_fixesThrough_of_untaken (r : Run P) {π : S → K} {t : Nat} {k : K} {a : A}
    (law : ∃ Q : Process K A, Determined Q ∧ r.StepsThrough π Q t)
    (untaken : ¬ r.TakesThrough π t k a) {κ₁ κ₂ : K} (two : κ₁ ≠ κ₂) :
    ¬ ∃ κ, r.FixesThrough π t k a κ :=
  fun ⟨_, fixes⟩ => match law with
    | ⟨Q, determined, steps⟩ => two
      ((fixes _ (retarget_determined determined k a κ₁) (r.stepsThrough_retarget steps untaken κ₁)
          κ₁ (retarget_step Q k a κ₁)).trans
        (fixes _ (retarget_determined determined k a κ₂) (r.stepsThrough_retarget steps untaken κ₂)
          κ₂ (retarget_step Q k a κ₂)).symm)

/-- **A true mechanism is not fixed where not yet taken either.** Where configurations alike
under `π` go alike, the record fixes no outcome of a move at a projected configuration the run
has not taken it at. -/
theorem not_fixesThrough_of_goAlike (r : Run P) {π : S → K} (alike : GoAlike P π) {t : Nat}
    {k : K} {a : A} (untaken : ¬ r.TakesThrough π t k a) {κ₁ κ₂ : K} (two : κ₁ ≠ κ₂) :
    ¬ ∃ κ, r.FixesThrough π t k a κ :=
  r.not_fixesThrough_of_untaken
    ⟨Image P π, image_determined_iff.mpr alike, r.stepsThrough_of_factors (factors_image P π) t⟩
    untaken two

end Run

/-! ## Standard causal models -/

section Inputs

variable {X : Type u} {U : Type v} {E : Type w}

/-- The standard model `x_{t+1} = F(x_t, u_t, ε_t)` as a process: the move is the input and the
noise together. -/
def inputs (F : X → U → E → X) : Process X (U × E) :=
  ⟨fun x m x' => x' = F x m.1 m.2⟩

/-- The standard model is determined by its move. -/
theorem inputs_determined (F : X → U → E → X) : Determined (inputs F) :=
  fun _ _ _ _ step step' => step.trans step'.symm

/-- The trajectory as a run of the process, its moves the inputs and noise. -/
def inputsRun (F : X → U → E → X) (x₀ : X) (u : Nat → U) (e : Nat → E) : Run (inputs F) :=
  ⟨trajectory F x₀ u e, fun n => (u n, e n), fun _ => rfl⟩

/-- **An intervention is a move not taken.** Where a run of the standard model has not taken
input `u'` with noise `e'` at `x` before `t`, and there are two configurations, the record up
to `t` fixes no outcome of that move there: an instance of `Run.not_fixes_of_untaken`. -/
theorem inputs_intervention_unfixed {F : X → U → E → X} (r : Run (inputs F)) {t : Nat} {x : X}
    {u' : U} {e' : E} (untaken : ¬ r.Takes t x (u', e')) {y z : X} (two : y ≠ z) :
    ¬ ∃ w, r.Fixes t x (u', e') w :=
  r.not_fixes_of_untaken (inputs_determined F) untaken two

/-- **The model fixes the intervention.** The standard model sends `(u', e')` at `x` to
`F x u' e'` and nowhere else. -/
theorem inputs_model_fixes (F : X → U → E → X) (x : X) (u' : U) (e' : E) :
    (inputs F).step x (u', e') (F x u' e') ∧ ∀ w, (inputs F).step x (u', e') w → w = F x u' e' :=
  ⟨rfl, fun _ step => step⟩

/-- The process with the second part of its move forgotten: `u` goes from `s` to `s'` where it
does so with some `e`. -/
def forget (P : Process S (U × E)) : Process S U :=
  ⟨fun s u s' => ∃ e, P.step s (u, e) s'⟩

/-- A run with the second part of its moves forgotten. -/
def Run.forget {P : Process S (U × E)} (r : Run P) : Run (Becoming.forget P) :=
  ⟨r.state, fun n => (r.act n).1, fun n => ⟨(r.act n).2, r.step n⟩⟩

/-- **Noise is a move not represented.** With the noise forgotten, the standard model stays
determined exactly where the noise makes no difference. -/
theorem forget_inputs_determined_iff {F : X → U → E → X} :
    Determined (forget (inputs F)) ↔ ∀ x u e e', F x u e = F x u e' :=
  ⟨fun determined x u e e' => determined x u (F x u e) (F x u e') ⟨e, rfl⟩ ⟨e', rfl⟩,
   fun every x u _ _ ⟨e, step⟩ ⟨e', step'⟩ => step.trans ((every x u e e').trans step'.symm)⟩

end Inputs

/-! ## A law at a coarser description

The configuration has two parts. Each step flips the first part; the second part may become
anything. -/

namespace Coarse

/-- The first part flips; the second part is free. -/
def process : Process (Bool × Bool) Unit := ⟨fun s _ u => u.1 = !s.1⟩

/-- The move does not determine the configuration. -/
theorem not_determined : ¬ Determined process :=
  fun determined => Bool.noConfusion
    (congrArg Prod.snd (determined (false, false) () (true, false) (true, true) rfl rfl))

/-- Configurations with the same first part go to configurations with the same first part. -/
theorem goAlike : GoAlike process Prod.fst :=
  fun _ _ _ _ _ same step step' => step.trans ((congrArg not same).trans step'.symm)

/-- **A description can carry a law where the whole configuration does not.** The move does
not determine the configuration, yet the step factors through its first part into the
determined law of flipping. -/
theorem carries :
    ¬ Determined process ∧ FactorsThrough process Prod.fst (Law.process not) ∧
      Determined (Law.process not) :=
  ⟨not_determined, fun _ _ _ step => step, fun _ _ _ _ step step' => step.trans step'.symm⟩

end Coarse

/-! ## A rule that changes itself

The state becomes the rule, and the rule alternates. -/

namespace Switching

/-- The state becomes the rule. -/
def follow (g _ : Bool) (_ : Unit) : Bool := g

/-- The rule alternates. -/
def alternate (g _ : Bool) : Bool := !g

/-- The adaptive system of following an alternating rule. -/
def process : Process (Bool × Bool) Unit := adaptive follow alternate

/-- One step of it: the state takes the rule, the rule flips. -/
def next (s : Bool × Bool) : Bool × Bool := (s.2, !s.2)

/-- The run from state and rule both false. -/
def run : Run process := ⟨Law.orbit next (false, false), fun _ => (), fun _ => rfl⟩

/-- The joint process is determined. -/
theorem determined : Determined process := adaptive_determined follow alternate

/-- The rule makes a difference to the state. -/
theorem not_goAlike : ¬ GoAlike process Prod.fst :=
  fun alike => Bool.noConfusion
    ((adaptive_state_law_iff (F := follow) (G := alternate)).mp alike false true false ())

/-- **A system changing its own rule has no law at the state alone.** No determined process on
the state admits the run's first two steps read through the state, nor any longer stretch;
the joint process is determined. -/
theorem no_state_law {t : Nat} (two : 2 ≤ t) :
    ¬ ∃ Q : Process Bool Unit, Determined Q ∧ run.StepsThrough Prod.fst Q t :=
  fun ⟨_, determined, steps⟩ =>
    Bool.noConfusion (determined _ _ _ _ (steps 0 (Nat.lt_of_lt_of_le (by decide) two))
      (steps 1 (Nat.lt_of_lt_of_le (by decide) two)))

end Switching

end Becoming
