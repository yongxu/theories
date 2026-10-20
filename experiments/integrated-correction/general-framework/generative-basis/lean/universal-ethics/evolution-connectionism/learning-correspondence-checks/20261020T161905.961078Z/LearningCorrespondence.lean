import Becoming.Learning
import Becoming.Mechanism
import CompositionalAcquisition
import UpdaterConsequences

/-!
# Learning correspondence: the acquisition chain and the connectionist models as instances of the core

On 12 October 2026 Ren asked for the account of learning to be completed ("please, fully
complete"), after the AI had proposed bringing the earlier acquisition chain and connectionist
models onto the Becoming spine. Those models were checked before the spine had laws of
learning, each with its own definitions. This periphery module states their central
relationships as instances of the core's laws, keeping each model's earlier scope. It imports
the core and the earlier modules; the core imports nothing of it.

* **Compositional acquisition is generalization through a lumping of laws.** Within the
  uniform law family with distinguishable primitive effects (`Uniform`), the three encounters of
  `CompositionalAcquisition` determine the value at every expression, encountered or not
  (`uniform_determines`): the earlier `acquired_all_expressions` read as `Becoming.Learning`'s
  `Determines`. Admitting the earlier nonuniform law that agrees on the three encounters, the
  encounters determine nothing at the novel expression (`nonuniform_not_determined`): the
  earlier `nonuniform_fails_transfer` read as the class being free there. The exactness of the
  acquired code is re-proved here case by case (`acquire_exact`), so that the instance has an
  empty axiom report.
* **A network's activity under fixed weights is a determined law.** The development of
  `ConnectionistRecovery` is the orbit of its step (`develop_orbit`); while the weights stay it
  is P66's law of a rule held fixed.
* **Hebbian development is one process on activity and weights.** Activity stepping under the
  weights while the weights store the activity is P66's `adaptive` system (`hebbian`,
  `hebbian_determined`). The activity has a law of its own exactly where the weights make no
  difference to its step (`hebbian_activity_law_iff`); in the three-unit memory of
  `DevelopmentalMemory` they do (`weights_matter`), so activity alone has no law there
  (`hebbian_no_activity_law`).
* **The route of updating is the meta level.** The network going on under a route of updating
  (`UpdaterConsequences.update`) is again an `adaptive` system, with the route as the rule
  (`updating`, `updating_determined`). The network has a law of its own exactly where the route
  makes no difference (`updating_network_law_iff`); at the earlier models' starting network and
  first task the two routes differ (`route_matters`), so the network alone has no law
  (`updating_no_network_law`). The responsive route changes the network exactly where the task
  fails (`responsive_kept`, `responsive_learns`): learning by refutation at the level of the
  network.

**Readings (the AI's, pending Ren).** The earlier models are now readings of the one core:
acquisition is generalization through a lumping, network learning is a law on the joint
configuration of activity and weights, and choosing how to learn is the same law one
configuration wider. Their supplied grammar, primitives, tasks, profiles, constants and routes
remain supplied; their empirical correspondence keeps its earlier status.

What is not derived: the grammar, the probes, the tasks and profiles, the routes, the
correspondence of any of these to an actual learner or network. Declarations proved with Mathlib
report its standard axioms; the instances proved without it have empty reports. No ethical
predicate, ranking or axiom occurs.
-/

-- Real-valued activity and weights are noncomputable; the section stays open to the end of the file.
noncomputable section

namespace Becoming

namespace LearningCorrespondence

open Learning

/-! ## Compositional acquisition -/

section Acquisition

open Generative.CompositionalAcquisition

/-- The interpretations of the uniform law family with distinguishable primitive effects. -/
def Uniform (g : Expr → List Bool) : Prop := ∃ c : Code, c.first ≠ c.second ∧ g = eval c

/-- The three encounters of the acquisition. -/
def encounters : List Expr := [p0, p1, orderProbe]

/-- The acquired code is exact where the primitive effects are distinguishable, case by case. -/
theorem acquire_exact : ∀ c : Code, c.first ≠ c.second → acquire (observe c) = c
  | ⟨false, true, false⟩, _ => rfl
  | ⟨false, true, true⟩, _ => rfl
  | ⟨true, false, false⟩, _ => rfl
  | ⟨true, false, true⟩, _ => rfl
  | ⟨false, false, _⟩, distinct => absurd rfl distinct
  | ⟨true, true, _⟩, distinct => absurd rfl distinct

/-- What one encounter shows: the interpretations' values there agree. -/
theorem agree_at {g g' : Expr → List Bool} {c c' : Code} (at_c : g = eval c)
    (at_c' : g' = eval c') {e : Expr} (same : g e = g' e) : eval c e = eval c' e :=
  (congrFun at_c e).symm.trans (same.trans (congrFun at_c' e))

/-- **The encounters determine every expression within the uniform family.** -/
theorem uniform_determines (e : Expr) : Determines Uniform (· ∈ encounters) e :=
  fun _ _ ⟨c, distinct, at_c⟩ ⟨c', distinct', at_c'⟩ agree =>
    have first : c.first = c'.first := Option.some.inj (congrArg List.head?
      (agree_at at_c at_c' (agree p0 (List.Mem.head _))))
    have second : c.second = c'.second := Option.some.inj (congrArg List.head?
      (agree_at at_c at_c' (agree p1 (List.Mem.tail _ (List.Mem.head _)))))
    have ordered : eval c orderProbe = eval c' orderProbe :=
      agree_at at_c at_c' (agree orderProbe (List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _))))
    have observed : observe c = observe c' :=
      show Evidence.mk c.first c.second (eval c orderProbe) =
          Evidence.mk c'.first c'.second (eval c' orderProbe) from
        congr (congr (congrArg Evidence.mk first) second) ordered
    have codes : c = c' :=
      (acquire_exact c distinct).symm.trans ((congrArg acquire observed).trans
        (acquire_exact c' distinct'))
    (congrFun at_c e).trans ((congrArg (fun k => eval k e) codes).trans (congrFun at_c' e).symm)

/-- **Admitting a nonuniform law, the encounters fix nothing at the novel expression.** -/
theorem nonuniform_not_determined :
    ¬ Determines (fun g => Uniform g ∨ g = nonuniform) (· ∈ encounters) novel :=
  fun determines =>
    have training := nonuniform_matches_training
    nonuniform_fails_transfer (determines nonuniform (eval usual) (Or.inr rfl)
      (Or.inl ⟨usual, fun same => Bool.noConfusion same, rfl⟩) fun i mem =>
        match i, mem with
        | _, .head _ => training.1
        | _, .tail _ (.head _) => training.2.1
        | _, .tail _ (.tail _ (.head _)) => training.2.2
        | _, .tail _ (.tail _ (.tail _ out)) => nomatch out)

end Acquisition

/-! ## Network activity, Hebbian development and the route of updating -/

section Networks

open ConnectionistRecovery DevelopmentalMemory UpdaterConsequences

/-- **Activity under fixed weights is the orbit of a determined law.** -/
theorem develop_orbit {n : Nat} (σ : ℝ → ℝ) (τ δ : ℝ) (B : Network n) (g : Profile n) :
    ∀ t, develop σ τ δ B g t = Law.orbit (step σ τ δ B) g t
  | 0 => rfl
  | t + 1 => congrArg (step σ τ δ B) (develop_orbit σ τ δ B g t)

/-- Hebbian development: the activity steps under the weights, and the weights store the
activity. -/
def hebbian {n : Nat} (σ : ℝ → ℝ) (τ δ η : ℝ) :
    Generative.Process (Profile n × Network n) Unit :=
  adaptive (fun B p (_ : Unit) => step σ τ δ B p) (fun B p => store η p B)

theorem hebbian_determined {n : Nat} (σ : ℝ → ℝ) (τ δ η : ℝ) :
    Determined (hebbian (n := n) σ τ δ η) :=
  adaptive_determined _ _

/-- **Activity has a law of its own exactly where the weights make no difference to its
step.** -/
theorem hebbian_activity_law_iff {n : Nat} {σ : ℝ → ℝ} {τ δ η : ℝ} :
    GoAlike (hebbian (n := n) σ τ δ η) Prod.fst ↔
      ∀ (B B' : Network n) (p : Profile n), step σ τ δ B p = step σ τ δ B' p :=
  adaptive_state_law_iff.trans
    ⟨fun every B B' p => every B B' p (), fun every B B' p _ => every B B' p⟩

/-- In the three-unit memory the weights make a difference: the stored network and the empty one
send the first profile to different activity. -/
theorem weights_matter :
    step Real.tanh 1 1 (weighted 1 1) first ≠ step Real.tanh 1 1 (weighted 0 0) first := by
  intro same
  have at0 := congrFun same 0
  simp only [step, first_field] at at0
  norm_num at at0
  exact ne_of_gt ((tanh_positive_iff 4).mpr (by norm_num)) at0

/-- **Activity alone has no law in Hebbian development of the three-unit memory.** -/
theorem hebbian_no_activity_law (η : ℝ) :
    ¬ GoAlike (hebbian (n := 3) Real.tanh 1 1 η) Prod.fst :=
  fun alike => weights_matter (hebbian_activity_law_iff.mp alike _ _ first)

/-- The route of updating: the network goes on under a route, by the task met, and the route
stays. -/
def updating : Generative.Process (Network 3 × Route) Task :=
  adaptive (fun r B task => update r B task) (fun r _ => r)

theorem updating_determined : Determined updating :=
  adaptive_determined _ _

/-- **The network has a law of its own exactly where the route makes no difference.** -/
theorem updating_network_law_iff :
    GoAlike updating Prod.fst ↔ ∀ r r' B task, update r B task = update r' B task :=
  adaptive_state_law_iff

/-- The responsive route keeps the network where the task succeeds. -/
theorem responsive_kept {B : Network 3} {task : Task} (succeeded : succeeds B task) :
    update .responsive B task = B := by
  simp only [update]
  exact if_pos succeeded

/-- The responsive route learns where the task fails. -/
theorem responsive_learns {B : Network 3} {task : Task} (failed : ¬ succeeds B task) :
    update .responsive B task = learn 1 (profile task) B := by
  simp only [update]
  exact if_neg failed

/-- At the starting network and the first task, the two routes differ: the continual route
learns, the responsive one keeps. -/
theorem route_matters : update .continual (weighted 1 1) .a ≠ update .responsive (weighted 1 1) .a := by
  have succeeded : succeeds (weighted 1 1) .a := (succeeds_first_iff 1 1).mpr (by norm_num)
  rw [responsive_kept succeeded]
  simp only [update, profile]
  rw [learned_first]
  intro same
  have at00 := congrFun (congrFun same 0) 0
  simp only [weighted, first, second] at at00
  norm_num at at00

/-- **Where the route makes a difference, the network alone has no law.** -/
theorem updating_no_network_law : ¬ GoAlike updating Prod.fst :=
  fun alike => route_matters (updating_network_law_iff.mp alike _ _ _ _)

end Networks

end LearningCorrespondence

end Becoming
