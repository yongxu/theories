import Becoming.Acceptance
import Becoming.Viability
import Becoming.Keeping
import Becoming.CommonResponse

/-!
# Guard horizon: keeping a guard by a choice of moves, over a horizon, from readings

A guard marks the configurations in which a requested change can still be carried out. On a process, the guard is
kept for `n` steps from a configuration where it holds there and, for `n` more, some enabled move
leads only to configurations keeping it for one step fewer (`Viable`); such a move is admissible
(`Admissible`). This is the controlled reading of the core's viability law (`Viability`), where
the kernel asks that no course leave the guard.

* **One step of the horizon.** `viable_succ_iff`, `viable_guard`; a move the process does not
  enable keeps nothing, so no vacuous universal over absent successors counts
  (`not_enabled_not_admissible`). A choice best by the score with acceptance among admissible
  moves accepts, is enabled, keeps the guard and is best among them (`shielded_choice`).
* **Closed sets and the core's certificates.** A set within the guard where some enabled move
  stays in the set keeps the guard at every horizon (`closed_viable`); so does a certificate of
  `Viability` with an enabled move at each configuration (`certificate_closed`,
  `certificate_viable`), and the kernel where every configuration reached has one
  (`kernel_viable`).
* **Deterministic laws and values.** For a law with free moves, keeping the guard (`DViable`) is
  keeping it in the law's process `Viability.disturbed` (`dViable_iff`); a choice of moves staying
  within the guard (`PathSafe`) shows its start keeps it (`pathSafe_dViable`, `safe_path_viable`)
  and its course is a trace kept within the guard (`Kept`, `pathSafe_iff`). Under values certified
  step by step within the guard (`Bellman`), every such course returns at most the value
  (`bellman_bounds_safe`, `kept_return_le`); a choice best by the score with acceptance at every
  configuration keeping the guard stays within it, returns exactly the value and accepts
  (`recomputed_composition`, `recomputed_kept`, `recomputed_choice_accepts`,
  `recomputed_accepts`).
* **Choosing from readings.** A choice made from a reading of the configurations
  (`UniformPolicy`) needs one move good at every configuration of each reading (`FiberFeasible`);
  the converse needs choice over the readings (`Viability.ChoiceOver`), named as a hypothesis
  (`uniform_policy_iff_fiber_feasible`, `uniform_iff`). Given choice over the readings and every
  reading given by some configuration, a choice from readings exists exactly where a response common
  over the reading's sameness does (`uniform_policy_iff_common`, through the core's
  `«自反传递则共应当且仅当承遍»`); with choice, no configuration and no move, a common response exists
  with no choice from readings (`ungiven_reading_not_uniform`). Moves good configuration by
  configuration need not be a choice from readings (`statewise_not_uniform`, from the core's
  `«共应之例».EachNotCommon`); a reading telling the
  configurations apart restores one (`discriminating_reading_uniform`); a uniform choice survives
  every finer reading (`uniform_finer`) and keeps the guard one step further (`uniform_viable`).
* **Coverage and handoff.** An empty catalogue of requirements covers vacuously, hiding loss
  (`empty_requirement_hides_loss`); coverage transports along a retaining translation
  (`coverage_transports`). Access at the endpoints of a route replacement can hide a gap
  (`endpoint_access_hides_gap`); an overlapping handoff keeps access throughout
  (`overlapping_handoff_keeps_access`), and the old route may be retired
  (`route_retirement_allowed`).

Which guard marks what an activity needs, the scores, the values and the readings are supplied;
nothing here says that a closed set, a certificate or a uniform choice exists. This states the
horizon part of `CorrectionInfrastructure` (8 October) and its joins `GuardHorizonProcesses` and
`GuardHorizonProcessesInherited` in the core (board item F3C, 18 October 2026). No premise beyond
the named choice; every declaration has an empty axiom report.
-/

namespace Becoming

open Generative IntegerOrder Integers Acceptance

namespace GuardHorizon

variable {S A : Type}

/-! ## One step of the horizon -/

/-- **The guard is kept for `n` steps**: it holds, and for `n` more steps some enabled move leads
only to configurations keeping it for one step fewer. -/
def Viable (P : Process S A) (guard : S → Prop) : Nat → S → Prop
  | 0, s => guard s
  | n + 1, s => guard s ∧ ∃ a, Enabled P s a ∧ ∀ t, P.step s a t → Viable P guard n t

/-- A move admissible for keeping the guard `n` more steps. -/
def Admissible (P : Process S A) (guard : S → Prop) (n : Nat) (s : S) (a : A) : Prop :=
  Enabled P s a ∧ ∀ t, P.step s a t → Viable P guard n t

variable (P : Process S A) (guard : S → Prop)

/-- **The guard is kept for `n + 1` steps exactly where it holds and some move is admissible.** -/
theorem viable_succ_iff (n : Nat) (s : S) :
    Viable P guard (n + 1) s ↔ guard s ∧ ∃ a, Admissible P guard n s a := Iff.rfl

/-- **A configuration keeping the guard for any horizon is within it.** -/
theorem viable_guard : ∀ {n : Nat} {s : S}, Viable P guard n s → guard s
  | 0, _, kept => kept
  | _ + 1, _, kept => kept.1

/-- **A move the process does not enable keeps nothing.** -/
theorem not_enabled_not_admissible {n : Nat} {s : S} {a : A} (absent : ¬ Enabled P s a) :
    ¬ Admissible P guard n s a :=
  fun ⟨enabled, _⟩ => absent enabled

/-- **A choice best by the score with acceptance among the admissible moves accepts, is enabled,
keeps the guard and has the best base score among the admissible moves.** -/
theorem shielded_choice {n : Nat} {s : S} {q : A → Int} {lift : Int} (positive : 0 < lift)
    {x : A × Bool}
    (best : Best (fun y : A × Bool => Admissible P guard n s y.1) (AcceptScore q lift) x) :
    x.2 = true ∧ Enabled P s x.1 ∧ (∀ t, P.step s x.1 t → Viable P guard n t) ∧
      ∀ a, Admissible P guard n s a → q a ≤ q x.1 :=
  match (acceptance_factorization (Admissible P guard n s) q lift positive x).mp best with
  | ⟨accepted, ⟨enabled, kept⟩, opt⟩ => ⟨accepted, enabled, kept, opt⟩

/-! ## Closed sets and the core's certificates -/

/-- A set within the guard where some enabled move stays in the set. -/
def Closed (K : S → Prop) : Prop :=
  ∀ s, K s → guard s ∧ ∃ a, Enabled P s a ∧ ∀ t, P.step s a t → K t

/-- **Every configuration of a closed set keeps the guard at every horizon.** -/
theorem closed_viable {K : S → Prop} (closed : Closed P guard K) :
    ∀ n s, K s → Viable P guard n s
  | 0, s, held => (closed s held).1
  | n + 1, s, held => match closed s held with
    | ⟨within, a, enabled, stays⟩ =>
      ⟨within, a, enabled, fun t st => closed_viable closed n t (stays t st)⟩

/-- **A certificate of the core's viability law with an enabled move at each configuration is
closed.** -/
theorem certificate_closed {K : S → Prop} (cert : Viability.Certificate P guard K)
    (live : ∀ s, K s → ∃ a, Enabled P s a) : Closed P guard K :=
  fun s held => ⟨cert.within s held,
    match live s held with
    | ⟨a, enabled⟩ => ⟨a, enabled, fun t st => cert.closed s a t st held⟩⟩

/-- **Every configuration of such a certificate keeps the guard at every horizon.** -/
theorem certificate_viable {K : S → Prop} (cert : Viability.Certificate P guard K)
    (live : ∀ s, K s → ∃ a, Enabled P s a) : ∀ n s, K s → Viable P guard n s :=
  closed_viable P guard (certificate_closed P guard cert live)

/-- **Where no course leaves the guard and every configuration reached has an enabled move, the
guard is kept at every horizon.** -/
theorem kernel_viable {s : S} (kept : Viability.Kernel P guard s)
    (live : ∀ t, Reach P s t → ∃ a, Enabled P t a) : ∀ n, Viable P guard n s :=
  fun n => closed_viable P guard (K := Reach P s)
    (fun t reach => ⟨kept t reach,
      match live t reach with
      | ⟨a, enabled⟩ => ⟨a, enabled, fun _ st => reach.trans (Reach.of_step st)⟩⟩)
    n s (Reach.refl P s)

/-! ## Deterministic laws and values -/

/-- The guard kept for `n` steps under a law with free moves. -/
def DViable (next : S → A → S) : Nat → S → Prop
  | 0, s => guard s
  | n + 1, s => guard s ∧ ∃ a, DViable next n (next s a)

/-- A move after which the law keeps the guard `n` more steps. -/
def DAllowed (next : S → A → S) (n : Nat) (s : S) (a : A) : Prop :=
  DViable guard next n (next s a)

/-- The return of a choice of moves over `n` steps; the choice depends on the steps left and the
configuration. -/
def Return (next : S → A → S) (reward : S → A → Int) (policy : Nat → S → A) : Nat → S → Int
  | 0, _ => 0
  | n + 1, s => reward s (policy n s) + Return next reward policy n (next s (policy n s))

/-- A choice of moves stays within the guard over `n` steps. -/
def PathSafe (next : S → A → S) (policy : Nat → S → A) : Nat → S → Prop
  | 0, s => guard s
  | n + 1, s => guard s ∧ PathSafe next policy n (next s (policy n s))

/-- Values certified step by step within the guard: zero at the end, and at each configuration
keeping the guard, attained by an allowed move and bounding every allowed one. -/
def Bellman (next : S → A → S) (reward : S → A → Int) (V : Nat → S → Int) : Prop :=
  (∀ s, V 0 s = 0) ∧ ∀ n s, DViable guard next (n + 1) s →
    (∃ a, DAllowed guard next n s a ∧ V (n + 1) s = reward s a + V n (next s a)) ∧
    (∀ a, DAllowed guard next n s a → reward s a + V n (next s a) ≤ V (n + 1) s)

/-- **A choice of moves staying within the guard shows its start keeps it.** -/
theorem pathSafe_dViable (next : S → A → S) (policy : Nat → S → A) :
    ∀ n s, PathSafe guard next policy n s → DViable guard next n s
  | 0, _, h => h
  | n + 1, s, h => ⟨h.1, policy n s, pathSafe_dViable next policy n _ h.2⟩

/-- **Under certified values, every choice staying within the guard returns at most the
value.** -/
theorem bellman_bounds_safe (next : S → A → S) (reward : S → A → Int) (V : Nat → S → Int)
    (bellman : Bellman guard next reward V) (policy : Nat → S → A) :
    ∀ n s, PathSafe guard next policy n s → Return next reward policy n s ≤ V n s
  | 0, s, _ => (bellman.1 s).symm ▸ le_refl 0
  | n + 1, s, safe =>
    have viable := pathSafe_dViable guard next policy (n + 1) s safe
    have allowed := pathSafe_dViable guard next policy n _ safe.2
    have bound := (bellman.2 n s viable).2 (policy n s) allowed
    have tail := bellman_bounds_safe next reward V bellman policy n _ safe.2
    le_trans (add_le_add_left tail (reward s (policy n s))) bound

/-- **A choice best by the score with acceptance among the moves after which the law keeps the
guard, at every configuration keeping it, stays within the guard and returns exactly the
value.** -/
theorem recomputed_composition (next : S → A → S) (reward : S → A → Int) (V : Nat → S → Int)
    (bellman : Bellman guard next reward V) (lift : Int) (positive : 0 < lift)
    (choose : Nat → S → A × Bool)
    (optimal : ∀ n s, DViable guard next (n + 1) s →
      Best (fun x : A × Bool => DAllowed guard next n s x.1)
        (AcceptScore (fun a => reward s a + V n (next s a)) lift) (choose n s)) :
    ∀ n s, DViable guard next n s →
      PathSafe guard next (fun k t => (choose k t).1) n s ∧
      Return next reward (fun k t => (choose k t).1) n s = V n s
  | 0, s, hs => ⟨hs, (bellman.1 s).symm⟩
  | n + 1, s, hs =>
    match (acceptance_factorization (DAllowed guard next n s)
        (fun a => reward s a + V n (next s a)) lift positive (choose n s)).mp (optimal n s hs) with
    | ⟨_, chosenAllowed, best⟩ =>
      have tail := recomputed_composition next reward V bellman lift positive choose optimal n _
        chosenAllowed
      match (bellman.2 n s hs).1 with
      | ⟨a, ha, attained⟩ =>
        have upper := (bellman.2 n s hs).2 (choose n s).1 chosenAllowed
        have lower := best a ha
        ⟨⟨hs.1, tail.1⟩, by
          show reward s (choose n s).1 + Return next reward (fun k t => (choose k t).1) n
            (next s (choose n s).1) = V (n + 1) s
          rw [tail.2]
          exact le_antisymm upper (attained ▸ lower)⟩

/-- **Such a choice accepts at every configuration keeping the guard.** -/
theorem recomputed_choice_accepts (next : S → A → S) (reward : S → A → Int)
    (V : Nat → S → Int) (lift : Int) (positive : 0 < lift)
    (choose : Nat → S → A × Bool) (n : Nat) (s : S)
    (optimal : Best (fun x : A × Bool => DAllowed guard next n s x.1)
      (AcceptScore (fun a => reward s a + V n (next s a)) lift) (choose n s)) :
    (choose n s).2 = true :=
  ((acceptance_factorization (DAllowed guard next n s)
    (fun a => reward s a + V n (next s a)) lift positive (choose n s)).mp optimal).1

/-- **Keeping the guard under a law with free moves is keeping it in the law's process.** -/
theorem dViable_iff (next : S → A → S) :
    ∀ n s, DViable guard next n s ↔ Viable (Viability.disturbed next fun _ => True) guard n s
  | 0, _ => Iff.rfl
  | n + 1, s =>
    ⟨fun ⟨within, a, kept⟩ => ⟨within, a, ⟨next s a, trivial, rfl⟩,
        fun _ ⟨_, lands⟩ => lands ▸ (dViable_iff next n (next s a)).mp kept⟩,
     fun ⟨within, a, _, all⟩ => ⟨within, a, (dViable_iff next n (next s a)).mpr
        (all (next s a) ⟨trivial, rfl⟩)⟩⟩

/-- **The course of a choice staying within the guard shows its start keeps the guard in the
law's process.** -/
theorem safe_path_viable (next : S → A → S) (policy : Nat → S → A) (n : Nat) (s : S)
    (safe : PathSafe guard next policy n s) :
    Viable (Viability.disturbed next fun _ => True) guard n s :=
  (dViable_iff guard next n s).mp (pathSafe_dViable guard next policy n s safe)

/-- A trace of a process every configuration of which is within the guard. -/
inductive Kept : S → List A → S → Prop where
  | nil {s : S} : guard s → Kept s [] s
  | cons {s m t : S} {a : A} {as : List A} :
      guard s → P.step s a m → Kept m as t → Kept s (a :: as) t

variable {P guard} in
/-- **A course kept within the guard is a trace of the process.** -/
theorem Kept.trace {s t : S} {as : List A} : Kept P guard s as t → Trace P s as t
  | .nil _ => .nil _
  | .cons _ st rest => .cons st rest.trace

variable {P guard} in
/-- A course kept within the guard begins within it. -/
theorem Kept.start {s t : S} {as : List A} : Kept P guard s as t → guard s
  | .nil within => within
  | .cons within _ _ => within

/-- The moves of a choice of moves over `n` steps under a law. -/
def moves (next : S → A → S) (policy : Nat → S → A) : Nat → S → List A
  | 0, _ => []
  | n + 1, s => policy n s :: moves next policy n (next s (policy n s))

/-- Where those `n` moves end. -/
def last (next : S → A → S) (policy : Nat → S → A) : Nat → S → S
  | 0, s => s
  | n + 1, s => last next policy n (next s (policy n s))

/-- **A choice stays within the guard over `n` steps exactly when its course is a trace of the
law's process kept within the guard.** -/
theorem pathSafe_iff (next : S → A → S) (policy : Nat → S → A) :
    ∀ n s, PathSafe guard next policy n s ↔
      Kept (Viability.disturbed next fun _ => True) guard s (moves next policy n s)
        (last next policy n s)
  | 0, _ => ⟨fun within => .nil within, fun | .nil within => within⟩
  | n + 1, _ =>
    ⟨fun ⟨within, rest⟩ => .cons within ⟨trivial, rfl⟩ ((pathSafe_iff next policy n _).mp rest),
     fun | .cons within ⟨_, rfl⟩ rest => ⟨within, (pathSafe_iff next policy n _).mpr rest⟩⟩

/-- **Every choice whose course is a trace kept within the guard returns at most the certified
value.** -/
theorem kept_return_le (next : S → A → S) {reward : S → A → Int} {V : Nat → S → Int}
    (bellman : Bellman guard next reward V) (policy : Nat → S → A) {n : Nat} {s : S}
    (kept : Kept (Viability.disturbed next fun _ => True) guard s (moves next policy n s)
      (last next policy n s)) :
    Return next reward policy n s ≤ V n s :=
  bellman_bounds_safe guard next reward V bellman policy n s
    ((pathSafe_iff guard next policy n s).mpr kept)

/-- **From every configuration keeping the guard in the law's process, the recomputed choice's
course is a trace kept within the guard returning exactly the value.** -/
theorem recomputed_kept (next : S → A → S) {reward : S → A → Int} {V : Nat → S → Int}
    (bellman : Bellman guard next reward V) {lift : Int} (positive : 0 < lift)
    (choose : Nat → S → A × Bool)
    (optimal : ∀ n s, DViable guard next (n + 1) s →
      Best (fun x : A × Bool => DAllowed guard next n s x.1)
        (AcceptScore (fun a => reward s a + V n (next s a)) lift) (choose n s))
    {n : Nat} {s : S} (viable : Viable (Viability.disturbed next fun _ => True) guard n s) :
    Kept (Viability.disturbed next fun _ => True) guard s
        (moves next (fun k t => (choose k t).1) n s) (last next (fun k t => (choose k t).1) n s) ∧
      Return next reward (fun k t => (choose k t).1) n s = V n s :=
  match recomputed_composition guard next reward V bellman lift positive choose optimal
      n s ((dViable_iff guard next n s).mpr viable) with
  | ⟨safe, value⟩ => ⟨(pathSafe_iff guard next _ n s).mp safe, value⟩

/-- **A choice best by the score with acceptance among the moves after which the law's process
keeps the guard accepts.** -/
theorem recomputed_accepts (next : S → A → S) {reward : S → A → Int} {V : Nat → S → Int}
    {lift : Int} (positive : 0 < lift) (choose : Nat → S → A × Bool) {n : Nat} {s : S}
    (best : Best
      (fun x : A × Bool => Viable (Viability.disturbed next fun _ => True) guard n (next s x.1))
      (AcceptScore (fun a => reward s a + V n (next s a)) lift) (choose n s)) :
    (choose n s).2 = true :=
  recomputed_choice_accepts guard next reward V lift positive choose n s
    ⟨(dViable_iff guard next n _).mpr best.1,
     fun x allowed => best.2 x ((dViable_iff guard next n _).mp allowed)⟩

/-! ## Choosing from readings -/

/-- A choice of good moves made from a reading of the configurations. -/
def UniformPolicy {O : Type} (obs : S → O) (good : S → A → Prop) : Prop :=
  ∃ policy : O → A, ∀ s, good s (policy (obs s))

/-- Each reading has one move good at every configuration giving it. -/
def FiberFeasible {O : Type} (obs : S → O) (good : S → A → Prop) : Prop :=
  ∀ o, ∃ a, ∀ s, obs s = o → good s a

/-- **A choice from readings gives each reading one good move.** -/
theorem fiber_of_uniform {O : Type} (obs : S → O) (good : S → A → Prop)
    (uniform : UniformPolicy obs good) : FiberFeasible obs good :=
  match uniform with
  | ⟨policy, valid⟩ => fun o => ⟨policy o, fun s hs => hs ▸ valid s⟩

/-- **A choice from readings exists exactly where each reading has one good move**, given choice
over the readings. -/
theorem uniform_policy_iff_fiber_feasible {O : Type} (choice : Viability.ChoiceOver O A)
    (obs : S → O) (good : S → A → Prop) :
    UniformPolicy obs good ↔ FiberFeasible obs good :=
  ⟨fiber_of_uniform obs good,
   fun feasible => match choice (fun o a => ∀ s, obs s = o → good s a) feasible with
    | ⟨f, chosen⟩ => ⟨f, fun s => chosen (obs s) s rfl⟩⟩

/-- **Given choice over the readings and every reading given by some configuration, a choice
from readings exists exactly where a response common over the reading's sameness does**: the core's
law of a common response (`«自反传递则共应当且仅当承遍»`) read at a map. -/
theorem uniform_policy_iff_common {O : Type} (choice : Viability.ChoiceOver O A)
    (obs : S → O) (given : ∀ o, ∃ s, obs s = o) (good : S → A → Prop) :
    UniformPolicy obs good ↔ ∃ J, «共应» (fun s s' => obs s = obs s') (fun a s => good s a) J :=
  have fibers : FiberFeasible obs good ↔
      ∀ s, ∃ a, «承» («逆» (fun s s' : S => obs s = obs s')) (fun s => good s a) s :=
    ⟨fun feasible s => match feasible (obs s) with
      | ⟨a, held⟩ => ⟨a, fun s' same => held s' same.symm⟩,
     fun each o => match given o with
      | ⟨s, at_o⟩ => match each s with
        | ⟨a, held⟩ => ⟨a, fun s' at_o' => held s' (at_o.trans at_o'.symm)⟩⟩
  (uniform_policy_iff_fiber_feasible choice obs good).trans
    (fibers.trans («自反传递则共应当且仅当承遍» (E := fun s s' : S => obs s = obs s') (fun _ => rfl)
      (fun _ _ _ xy yz => xy.trans yz) (fun a s => good s a)).symm)

/-- **A reading no configuration gives, with no move at all, leaves a common response without a
choice from readings**: with no configuration and no move, choice over the one reading holds, the reading is
given by no configuration, a response common over the sameness exists vacuously, and the reading
has no move. -/
theorem ungiven_reading_not_uniform :
    Viability.ChoiceOver Unit Empty ∧ ¬ (∀ o : Unit, ∃ s : Empty, (fun _ => ()) s = o) ∧
      (∃ J, «共应» (fun s s' : Empty => (fun _ => ()) s = (fun _ => ()) s')
        (fun (_ : Empty) (_ : Empty) => True) J) ∧
      ¬ UniformPolicy (A := Empty) (fun _ : Empty => ()) (fun _ _ => True) :=
  ⟨(fun _ each => match each () with | ⟨a, _⟩ => nomatch a),
   (fun given => match given () with | ⟨s, _⟩ => nomatch s),
   ⟨fun _ _ => True, fun _ _ _ => trivial, (fun s => nomatch s), fun _ _ _ _ _ => trivial⟩,
   fun ⟨policy, _⟩ => nomatch policy ()⟩

/-- **Moves good configuration by configuration need not be a choice from readings**: a choice from
the one reading would give a response common over everything, which the core's
`«共应之例».EachNotCommon` excludes. -/
theorem statewise_not_uniform :
    (∀ s : Bool, ∃ a : Bool, a = s) ∧
    ¬ UniformPolicy (fun _ : Bool => ()) (fun s a : Bool => a = s) :=
  ⟨«共应之例».EachNotCommon.each,
   fun ⟨policy, valid⟩ => «共应之例».EachNotCommon.none
     ⟨_, «共应之细» (fun _ _ _ => rfl)
       («依读而应则共应» (fun _ : Bool => ()) «共应之例».EachNotCommon.G policy valid)⟩⟩

/-- **A reading telling the configurations apart restores a choice.** -/
theorem discriminating_reading_uniform :
    UniformPolicy (fun s : Bool => s) (fun s a : Bool => a = s) := ⟨id, fun _ => rfl⟩

/-- **A choice from readings survives every finer reading.** -/
theorem uniform_finer {O R : Type} (coarse : S → O) (fine : S → R) (forget : R → O)
    (compatible : ∀ s, forget (fine s) = coarse s) (good : S → A → Prop)
    (h : UniformPolicy coarse good) : UniformPolicy fine good :=
  match h with
  | ⟨policy, valid⟩ => ⟨fun p => policy (forget p), fun s => by
      show good s (policy (forget (fine s)))
      rw [compatible s]
      exact valid s⟩

/-- **A choice of admissible moves from a reading keeps the guard one step further from every
configuration within it.** -/
theorem uniform_viable {O : Type} {read : S → O} {n : Nat}
    (uniform : UniformPolicy read (Admissible P guard n)) {s : S} (within : guard s) :
    Viable P guard (n + 1) s :=
  match uniform with
  | ⟨choice, admissible⟩ => ⟨within, choice (read s), admissible s⟩

/-- **Admissible moves can be chosen from a reading exactly where each reading has one move
admissible at every configuration giving it**, given choice over the readings. -/
theorem uniform_iff {O : Type} (choice : Viability.ChoiceOver O A) (read : S → O) (n : Nat) :
    UniformPolicy read (Admissible P guard n) ↔
      ∀ o, ∃ a, ∀ s, read s = o → Admissible P guard n s a :=
  uniform_policy_iff_fiber_feasible choice read (Admissible P guard n)

/-! ## Coverage and handoff -/

/-- Every required item is available. -/
def Covers {I : Type} (required available : I → Prop) : Prop :=
  ∀ i, required i → available i

/-- **An empty catalogue of requirements covers vacuously, hiding loss.** -/
theorem empty_requirement_hides_loss :
    Covers (fun _ : Unit => False) (fun _ => False) ∧
    ¬ Covers (fun _ : Unit => True) (fun _ => False) :=
  ⟨fun _ h => h, fun h => h () trivial⟩

/-- **Coverage transports along a translation retaining the old requirements.** -/
theorem coverage_transports {I J : Type}
    (old : I → Prop) (new available : J → Prop) (translate : I → J)
    (retained : ∀ i, old i → new (translate i)) (coverage : Covers new available) :
    ∀ i, old i → available (translate i) := fun i hi => coverage _ (retained i hi)

/-- Access through the old or the new route. -/
def RouteAccess (s : Bool × Bool) : Prop := s.1 = true ∨ s.2 = true

/-- Access at every point of a course. -/
def PrefixAccess (trace : List (Bool × Bool)) : Prop := ∀ s, s ∈ trace → RouteAccess s

/-- **Access at the endpoints of a route replacement can hide a gap.** -/
theorem endpoint_access_hides_gap :
    RouteAccess (true, false) ∧ RouteAccess (false, true) ∧
    ¬ PrefixAccess [(true, false), (false, false), (false, true)] :=
  ⟨.inl rfl, .inr rfl, fun h => match h (false, false) (.tail _ (.head _)) with
    | .inl e => nomatch e
    | .inr e => nomatch e⟩

/-- **An overlapping handoff keeps access throughout.** -/
theorem overlapping_handoff_keeps_access :
    PrefixAccess [(true, false), (true, true), (false, true)] :=
  fun s m => match s, m with
    | _, .head _ => .inl rfl
    | _, .tail _ (.head _) => .inl rfl
    | _, .tail _ (.tail _ (.head _)) => .inr rfl

/-- **The old route may be retired: keeping access is not freezing a route.** -/
theorem route_retirement_allowed : RouteAccess (false, true) ∧ (false, true).1 ≠ true :=
  ⟨.inr rfl, fun e => nomatch e⟩

end GuardHorizon

end Becoming
